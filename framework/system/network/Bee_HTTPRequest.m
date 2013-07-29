//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "Bee_HTTPRequest.h"
#import "Bee_HTTPMockServer.h"
#import "NSObject+BeeHTTPRequest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation BeeEmptyRequest

- (void)startSynchronous
{
	[self performSelector:@selector(reportFailure)];
}

- (void)startAsynchronous
{
	[self performSelector:@selector(reportFailure)];
}

@end

#pragma mark -

@interface BeeHTTPRequest()
{
	NSUInteger				_state;
	NSMutableArray *		_responders;
//	id						_responder;
	
	NSInteger				_errorCode;
	NSMutableDictionary *	_userInfo;
	
	BOOL					_sendProgressed;
	BOOL					_recvProgressed;
	BeeHTTPRequestBlock		_whenUpdate;
	
	NSTimeInterval			_initTimeStamp;
	NSTimeInterval			_sendTimeStamp;
	NSTimeInterval			_recvTimeStamp;
	NSTimeInterval			_doneTimeStamp;
	
#if (__ON__ == __BEE_DEVELOPMENT__)
	NSMutableArray *		_callstack;
#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
}

- (void)updateSendProgress;
- (void)updateRecvProgress;
- (void)addFileData:(id)data fileName:(NSString *)name alias:(NSString *)alias;

@end

#pragma mark -

@implementation BeeHTTPRequest

DEF_INT( STATE_CREATED,		0 );
DEF_INT( STATE_SENDING,		1 );
DEF_INT( STATE_RECVING,		2 );
DEF_INT( STATE_FAILED,		3 );
DEF_INT( STATE_SUCCEED,		4 );
DEF_INT( STATE_CANCELLED,	5 );
DEF_INT( STATE_REDIRECTED,	6 );

@dynamic HEADER;
@dynamic BODY;
@dynamic PARAM;
@dynamic FILE;
@dynamic TIMEOUT;

@synthesize state = _state;
@synthesize errorCode = _errorCode;
//@synthesize responder = _responder;
@synthesize responders = _responders;
@synthesize userInfo = _userInfo;

@synthesize whenUpdate = _whenUpdate;

@synthesize initTimeStamp = _initTimeStamp;
@synthesize sendTimeStamp = _sendTimeStamp;
@synthesize recvTimeStamp = _recvTimeStamp;
@synthesize doneTimeStamp = _doneTimeStamp;

@synthesize timeCostPending;	// 排队等待耗时
@synthesize timeCostOverDNS;	// 网络连接耗时（DNS）
@synthesize timeCostRecving;	// 网络收包耗时
@synthesize timeCostOverAir;	// 网络整体耗时

#if (__ON__ == __BEE_DEVELOPMENT__)
@synthesize callstack = _callstack;
#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

@dynamic created;
@dynamic sending;
@dynamic recving;
@dynamic failed;
@dynamic succeed;
//@synthesize cancelled;
@dynamic redirected;

@synthesize sendProgressed = _sendProgressed;
@synthesize recvProgressed = _recvProgressed;

@synthesize uploadPercent;
@synthesize uploadBytes;
@synthesize uploadTotalBytes;
@synthesize downloadPercent;
@synthesize downloadBytes;
@synthesize downloadTotalBytes;

- (id)initWithURL:(NSURL *)newURL
{
	self = [super initWithURL:newURL];
	if ( self )
	{
		_state = BeeHTTPRequest.STATE_CREATED;
		_errorCode = 0;
		
		_responders = [[NSMutableArray nonRetainingArray] retain];
		_userInfo = [[NSMutableDictionary alloc] init];
		
		_whenUpdate = nil;
		
		_sendProgressed = NO;
		_recvProgressed = NO;
		
		_initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		_sendTimeStamp = _initTimeStamp;
		_recvTimeStamp = _initTimeStamp;	
		_doneTimeStamp = _initTimeStamp;

	#if (__ON__ == __BEE_DEVELOPMENT__)
		_callstack = [[NSMutableArray alloc] init];
		[_callstack addObjectsFromArray:[BeeRuntime callstack:16]];
	#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
	}

	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %@, state ==> %llu, %llu/%llu",
			self.requestMethod, [self.url absoluteString],
			(unsigned long long)self.state,
			(unsigned long long)[self uploadBytes],
			(unsigned long long)[self downloadBytes]];
}

- (void)dealloc
{
	self.whenUpdate = nil;
	
	[_responders removeAllObjects];
	[_responders release];
	_responders = nil;

	[_userInfo removeAllObjects];
	[_userInfo release];
	_userInfo = nil;
	
#if (__ON__ == __BEE_DEVELOPMENT__)
	[_callstack removeAllObjects];
	[_callstack release];
	_callstack = nil;
#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
	
	[super dealloc];
}

- (CGFloat)uploadPercent
{
	NSUInteger bytes1 = self.uploadBytes;
	NSUInteger bytes2 = self.uploadTotalBytes;
	
	return bytes2 ? ((CGFloat)bytes1 / (CGFloat)bytes2) : 0.0f;
}

- (NSUInteger)uploadBytes
{
	if ( [self.requestMethod isEqualToString:@"GET"] )
	{
		return 0;
	}
	else if ( [self.requestMethod isEqualToString:@"POST"] )
	{
		return self.postLength;		
	}
	
	return 0;
}

- (NSUInteger)uploadTotalBytes
{
	if ( [self.requestMethod isEqualToString:@"GET"] )
	{
		return 0;
	}
	else if ( [self.requestMethod isEqualToString:@"POST"] )
	{
		return self.postLength;		
	}
	
	return 0;
}

- (CGFloat)downloadPercent
{
	NSUInteger bytes1 = self.downloadBytes;
	NSUInteger bytes2 = self.downloadTotalBytes;
	
	return bytes2 ? ((CGFloat)bytes1 / (CGFloat)bytes2) : 0.0f;
}

- (NSUInteger)downloadBytes
{
	return [[self rawResponseData] length];
}

- (NSUInteger)downloadTotalBytes
{
	return self.contentLength;	
}

- (BOOL)is:(NSString *)text
{
	return [[self.url absoluteString] isEqualToString:text];
}

- (void)callResponders
{
    NSArray * responds = [self.responders copy];

	for ( NSObject * responder in responds)
	{
		[self forwardResponder:responder];
	}
	
    [responds release];
}

- (void)forwardResponder:(NSObject *)obj
{
	BOOL allowed = YES;
	
	if ( [obj respondsToSelector:@selector(prehandleRequest:)] )
	{
		allowed = [obj prehandleRequest:self];
	}
	
	if ( allowed )
	{
		[obj retain];
		
		if ( [obj isRequestResponder] )
		{
			[obj handleRequest:self];
		}
		
		[obj posthandleRequest:self];
		
		[obj release];
	}
}

- (void)changeState:(NSUInteger)state
{
	if ( state != _state )
	{
		_state = state;

		if ( BeeHTTPRequest.STATE_SENDING == _state )
		{
			_sendTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		}
		else if ( BeeHTTPRequest.STATE_RECVING == _state )
		{
			_recvTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		}
		else if ( BeeHTTPRequest.STATE_FAILED == _state || BeeHTTPRequest.STATE_SUCCEED == _state || BeeHTTPRequest.STATE_CANCELLED == _state )
		{
			_doneTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		}

		[self callResponders];
		
		if ( self.whenUpdate )
		{
			self.whenUpdate( self );
		}
	}
}

- (void)updateSendProgress
{
	_sendProgressed = YES;
	
	[self callResponders];

	if ( self.whenUpdate )
	{
		self.whenUpdate( self );
	}
	
	_sendProgressed = NO;
}

- (void)updateRecvProgress
{
	if ( _state == BeeHTTPRequest.STATE_SUCCEED || _state == BeeHTTPRequest.STATE_FAILED || _state == BeeHTTPRequest.STATE_CANCELLED )
		return;
    
    if ( self.didUseCachedResponse )
		return;
    
	_recvProgressed = YES;
	
	[self callResponders];

	if ( self.whenUpdate )
	{
		self.whenUpdate( self );
	}
	
	_recvProgressed = NO;
}

- (NSTimeInterval)timeCostPending
{
	return _sendTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostOverDNS
{
	return _recvTimeStamp - _sendTimeStamp;
}

- (NSTimeInterval)timeCostRecving
{
	return _doneTimeStamp - _recvTimeStamp;
}

- (NSTimeInterval)timeCostOverAir
{
	return _doneTimeStamp - _sendTimeStamp;
}

- (BOOL)created
{
	return BeeHTTPRequest.STATE_CREATED == _state ? YES : NO;
}

- (BOOL)sending
{
	return BeeHTTPRequest.STATE_SENDING == _state ? YES : NO;
}

- (BOOL)recving
{
	return BeeHTTPRequest.STATE_RECVING == _state ? YES : NO;
}

- (BOOL)succeed
{
	return BeeHTTPRequest.STATE_SUCCEED == _state ? YES : NO;
}

- (BOOL)failed
{
	return BeeHTTPRequest.STATE_FAILED == _state ? YES : NO;
}

- (BOOL)cancelled
{
	return BeeHTTPRequest.STATE_CANCELLED == _state ? YES : NO;
}

- (BOOL)redirected
{
	return BeeHTTPRequest.STATE_REDIRECTED == _state ? YES : NO;
}

- (BOOL)hasResponder:(id)responder
{
	return [_responders containsObject:responder];
}

- (void)addResponder:(id)responder
{
	[_responders addObject:responder];
}

- (void)removeResponder:(id)responder
{
	[_responders removeObject:responder];
}

- (void)removeAllResponders
{
	[_responders removeAllObjects];
}

- (BeeHTTPRequestBlockN)HEADER
{
	BeeHTTPRequestBlockN block = ^ BeeHTTPRequest * ( id first, ... )
	{
		va_list args;
		va_start( args, first );

		NSString * key = [(NSObject *)first asNSString];
		NSString * value = [va_arg( args, NSObject * ) asNSString];

		[self addRequestHeader:key value:(NSString *)value];

		va_end( args );

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockN)BODY
{
	BeeHTTPRequestBlockN block = ^ BeeHTTPRequest * ( id first, ... )
	{
		NSData * data = nil;
		
		if ( [first isKindOfClass:[NSData class]] )
		{
			data = (NSData *)first;
		}
		else if ( [first isKindOfClass:[NSString class]] )
		{
			data = [(NSString *)first dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
		}
		else if ( [first isKindOfClass:[NSArray class]] )
		{
			NSString * text = [NSString queryStringFromArray:(NSArray *)first];
			if ( text )
			{
				data = [text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
			}
		}
		else if ( [first isKindOfClass:[NSDictionary class]] )
		{
			NSString * text = [NSString queryStringFromDictionary:(NSDictionary *)first];
			if ( text )
			{
				data = [text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
			}
		}
		else
		{
			data = [[first description] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
		}

		if ( data )
		{
			self.postBody = [NSMutableData dataWithData:data];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockN)PARAM
{
	BeeHTTPRequestBlockN block = ^ BeeHTTPRequest * ( id first, ... )
	{
		if ( nil == first )
			return self;

		NSDictionary * inputParams = nil;
		
		if ( [first isKindOfClass:[NSDictionary class]] )
		{
			inputParams = (NSDictionary *)first;
		}
		else
		{
			va_list args;
			va_start( args, first );
			
			NSString * key = [(NSString *)first asNSString];
			NSString * value = [va_arg( args, NSObject * ) asNSString];
			
			if ( key && value )
			{
				inputParams = [NSDictionary dictionaryWithObject:value forKey:key];
			}
			
			va_end( args );
		}
			
		if ( [self.requestMethod is:@"GET"] )
		{
			for ( NSString * key in inputParams.allKeys )
			{
				NSObject * value = [inputParams objectForKey:key];
				
				NSString * base = [self.url absoluteString];
				NSString * params = [NSString queryStringFromKeyValues:key, [value asNSString], nil];
				NSString * query = self.url.query;
				
				NSURL * newURL = nil;

				if ( query.length )
				{
					newURL = [NSURL URLWithString:[base stringByAppendingFormat:@"&%@", params]];
				}
				else
				{
					newURL = [NSURL URLWithString:[base stringByAppendingFormat:@"?%@", params]];
				}

				if ( newURL )
				{
					[self setURL:newURL];	
				}
			}
		}
		else
		{
			for ( NSString * key in inputParams.allKeys )
			{
				NSObject * value = [inputParams objectForKey:key];
				
				[self setPostValue:[value asNSString] forKey:key];
			}
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

- (void)addFileData:(id)data fileName:(NSString *)name alias:(NSString *)alias
{
	if ( data )
	{
		NSString * fullPath = [NSString stringWithFormat:@"%@/Temp/", [BeeSandbox libCachePath]];
		if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:NULL] )
		{
			BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:fullPath
												 withIntermediateDirectories:YES
																  attributes:nil
																	   error:nil];
			if ( NO == ret )
				return;
		}
		
		NSString * fileName = [fullPath stringByAppendingString:name];
		BOOL fileWritten = NO;
		
		if ( [data isKindOfClass:[NSString class]] )
		{
			NSString * string = (NSString *)data;
			fileWritten = [string writeToFile:fileName
								   atomically:YES
									 encoding:NSUTF8StringEncoding
										error:NULL];
		}
		else if ( [data isKindOfClass:[NSData class]] )
		{
			fileWritten = [data writeToFile:fileName
									options:NSDataWritingAtomic
									  error:NULL];
		}
		else
		{
			NSData * decoded = [[data description] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
			fileWritten = [decoded writeToFile:fileName
									   options:NSDataWritingAtomic
										 error:NULL];
		}
		
		if ( fileWritten && [[NSFileManager defaultManager] fileExistsAtPath:fileName isDirectory:NULL] )
		{
			[self setFile:fileName forKey:(alias ? alias : name)];
		}
	}
}

- (BeeHTTPRequestBlockN)FILE
{
	BeeHTTPRequestBlockN block = ^ BeeHTTPRequest * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * name = [(NSString *)first asNSString];
		NSObject * data = va_arg( args, NSObject * );
		
		[self addFileData:data fileName:name alias:nil];
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockN)FILE_ALIAS
{
	BeeHTTPRequestBlockN block = ^ BeeHTTPRequest * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * name = [(NSString *)first asNSString];
		NSObject * data = va_arg( args, NSObject * );
		NSString * alias = va_arg( args, NSString * );

		[self addFileData:data fileName:name alias:alias];
		
		va_end( args );
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockT)TIMEOUT
{
	BeeHTTPRequestBlockT block = ^ BeeHTTPRequest * ( NSTimeInterval interval )
	{
		self.timeOutSeconds = interval;
		
		return self;
	};
	
	return [[block copy] autorelease];
}


- (void)startSynchronous
{
#if defined(__BEE_MOCKSERVER__) && __BEE_MOCKSERVER__
	if ( [self.url.absoluteString hasPrefix:@"mock://"] )
	{
		[BeeHTTPMockServer route:self];
		return;
	}
#endif	// #if defined(__BEE_MOCKSERVER__) && __BEE_MOCKSERVER__

	[super startSynchronous];
}

- (void)startAsynchronous
{
#if defined(__BEE_MOCKSERVER__) && __BEE_MOCKSERVER__
	if ( [self.url.absoluteString hasPrefix:@"mock://"] )
	{
		[BeeHTTPMockServer route:self];
		return;
	}
#endif	// #if defined(__BEE_MOCKSERVER__) && __BEE_MOCKSERVER__
	
	[super startAsynchronous];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeHTTPRequest )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

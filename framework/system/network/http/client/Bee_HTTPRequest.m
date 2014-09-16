//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
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
#import "Bee_HTTPClientConfig.h"

#import "NSObject+BeeHTTPRequest.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#import <QuartzCore/QuartzCore.h>
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(BeeHTTPRequest)

- (BOOL)isRequestResponder
{
	if ( [self respondsToSelector:@selector(handleRequest:)] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)prehandleRequest:(BeeHTTPRequest *)request
{
	return YES;
}

- (void)posthandleRequest:(BeeHTTPRequest *)request
{
}

- (void)handleRequest:(BeeHTTPRequest *)request
{
}

@end

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
	NSObject *				_userObject;
	
	BOOL					_sendProgressed;
	BOOL					_recvProgressed;

	BeeHTTPRequestBlock		_whenUpdate;
	BeeHTTPRequestBlock		_whenSending;
	BeeHTTPRequestBlock		_whenSendProgressed;
	BeeHTTPRequestBlock		_whenRecving;
	BeeHTTPRequestBlock		_whenRecvProgressed;
	BeeHTTPRequestBlock		_whenFailed;
	BeeHTTPRequestBlock		_whenSucceed;
	BeeHTTPRequestBlock		_whenCancelled;
	BeeHTTPRequestBlock		_whenRedirected;

	NSTimeInterval			_initTimeStamp;
	NSTimeInterval			_sendTimeStamp;
	NSTimeInterval			_recvTimeStamp;
	NSTimeInterval			_doneTimeStamp;
	
#if __BEE_DEVELOPMENT__
	NSMutableArray *		_callstack;
#endif	// #if __BEE_DEVELOPMENT__
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
@dynamic FILE_ALIAS;
@dynamic FILE_MP4;
@dynamic FILE_MP4_ALIAS;
@dynamic FILE_PNG;
@dynamic FILE_PNG_ALIAS;
@dynamic FILE_JPG;
@dynamic FILE_JPG_ALIAS;
@dynamic TIMEOUT;
@dynamic SAVE_AS;
@dynamic SHOULD_COMPRESS;
@dynamic SHOULD_DECOMPRESS;

@synthesize state = _state;
@synthesize errorCode = _errorCode;
//@synthesize responder = _responder;
@synthesize responders = _responders;
@synthesize userInfo = _userInfo;
@synthesize userObject = _userObject;

@synthesize whenUpdate = _whenUpdate;
@synthesize whenSending = _whenSending;
@synthesize whenSendProgressed = _whenSendProgressed;
@synthesize whenRecving = _whenRecving;
@synthesize whenRecvProgressed = _whenRecvProgressed;
@synthesize whenFailed = _whenFailed;
@synthesize whenSucceed = _whenSucceed;
@synthesize whenCancelled = _whenCancelled;
@synthesize whenRedirected = _whenRedirected;

@synthesize initTimeStamp = _initTimeStamp;
@synthesize sendTimeStamp = _sendTimeStamp;
@synthesize recvTimeStamp = _recvTimeStamp;
@synthesize doneTimeStamp = _doneTimeStamp;

@synthesize timeCostPending;	// 排队等待耗时
@synthesize timeCostOverDNS;	// 网络连接耗时（DNS）
@synthesize timeCostRecving;	// 网络收包耗时
@synthesize timeCostOverAir;	// 网络整体耗时

#if __BEE_DEVELOPMENT__
@synthesize callstack = _callstack;
#endif	// #if __BEE_DEVELOPMENT__

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
		_userObject = nil;
		
		_sendProgressed = NO;
		_recvProgressed = NO;
		
		_initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		_sendTimeStamp = _initTimeStamp;
		_recvTimeStamp = _initTimeStamp;	
		_doneTimeStamp = _initTimeStamp;

	#if __BEE_DEVELOPMENT__
		_callstack = [[NSMutableArray alloc] init];
		[_callstack addObjectsFromArray:[BeeRuntime callstack:16]];
	#endif	// #if __BEE_DEVELOPMENT__

		self.userAgent = [BeeHTTPClientConfig sharedInstance].userAgent;
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
	self.whenSending = nil;
	self.whenSendProgressed = nil;
	self.whenRecving = nil;
	self.whenRecvProgressed = nil;
	self.whenFailed = nil;
	self.whenSucceed = nil;
	self.whenCancelled = nil;
	self.whenRedirected = nil;
	
	self.postBody = nil;

	[_responders removeAllObjects];
	[_responders release];
	_responders = nil;

	[_userInfo removeAllObjects];
	[_userInfo release];
	_userInfo = nil;
	
	[_userObject release];
	_userObject = nil;
	
#if __BEE_DEVELOPMENT__
	[_callstack removeAllObjects];
	[_callstack release];
	_callstack = nil;
#endif	// #if __BEE_DEVELOPMENT__
	
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
	return self.totalBytesSent;
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
	return self.totalBytesRead;
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

		if ( BeeHTTPRequest.STATE_SENDING == _state )
		{
			if ( self.whenSending )
			{
				self.whenSending();
			}
		}
		else if ( BeeHTTPRequest.STATE_RECVING == _state )
		{
			if ( self.whenRecving )
			{
				self.whenRecving();
			}
		}
		else if ( BeeHTTPRequest.STATE_FAILED == _state )
		{
			ERROR( @"\t\tHTTP %@ '%@', failed", self.requestMethod, self.url.absoluteString );
			
			if ( self.whenFailed )
			{
				self.whenFailed();
			}
		}
		else if ( BeeHTTPRequest.STATE_SUCCEED == _state )
		{
			INFO( @"\t\tHTTP %@ '%@', succeed", self.requestMethod, self.url.absoluteString );
			
			if ( self.whenSucceed )
			{
				self.whenSucceed();
			}
		}
		else if ( BeeHTTPRequest.STATE_CANCELLED == _state )
		{
			INFO( @"\t\tHTTP %@ '%@', cancelled", self.requestMethod, self.url.absoluteString );

			if ( self.whenCancelled )
			{
				self.whenCancelled();
			}
		}
		
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
	}
}

- (void)updateSendProgress
{
	_sendProgressed = YES;
	
	[self callResponders];

	if ( self.whenSendProgressed )
	{
		self.whenSendProgressed();
	}
	
	if ( self.whenUpdate )
	{
		self.whenUpdate();
	}
	
	INFO( @"\t\tHTTP %@ '%@', upload %d/%d", self.requestMethod, self.url.absoluteString, self.uploadBytes, self.uploadTotalBytes );
	
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

	if ( self.whenRecvProgressed )
	{
		self.whenRecvProgressed();
	}

	if ( self.whenUpdate )
	{
		self.whenUpdate();
	}
	
	INFO( @"\t\tHTTP %@ '%@', download %d/%d", self.requestMethod, self.url.absoluteString, self.downloadBytes, self.downloadTotalBytes );
	
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

- (BeeHTTPRequestBlockN)PARAMS
{
    BeeHTTPRequestBlockN block = ^ BeeRequest * ( id first, ... )
    {
        va_list args;
        va_start( args , first );
        
        
        BOOL bFirst = YES;
        
        for ( ;; )
        {
            NSString *key = nil;
            if (bFirst)
            {
                bFirst = NO;
                key = [first asNSString];
            }
            else
            {
                key = [va_arg( args, NSObject * ) asNSString];
            }
            
            if ( nil == key )
                break;
            
            NSObject * value = [va_arg( args, NSObject * ) asNSString];
            if ( nil == value )
                break;
            
            if ( [self.requestMethod is:@"GET"] )
            {
                NSString * base = [self.url absoluteString];
                NSString * params = [NSString queryStringFromKeyValues:key, value, nil];
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
            
            else
            {
                [self setPostValue:value forKey:key];
            }
            
        }
        
        va_end( args );
        
        return self;
    };
    return [[block copy] autorelease];
}

- (void)addFileData:(id)data fileName:(NSString *)name alias:(NSString *)alias type:(NSString *)type
{
	if ( data )
	{
		NSString * fullPath = [NSString stringWithFormat:@"%@/%@/Temporary/", [BeeSandbox libCachePath], [BeeSystemInfo appVersion]];
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
			if ( type && type.length )
			{
				[self setFile:data withFileName:fileName andContentType:type forKey:(alias ? alias : name)];
			}
			else
			{
				[self setFile:fileName forKey:(alias ? alias : name)];
			}
		}
	}
}

- (void)addFileData:(id)data fileName:(NSString *)name alias:(NSString *)alias
{
    [self addFileData:data fileName:name alias:alias type:nil];
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

- (BeeHTTPRequestBlockN)FILE_MP4
{
	BeeHTTPRequestBlockN block = ^ BeeHTTPRequest * ( id first, ... )
	{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
		
		va_list args;
		va_start( args, first );
		
		NSString * name = [(NSString *)first asNSString];
		NSObject * data = va_arg( args, NSObject * );

        [self addData:data withFileName:name andContentType:@"image/png" forKey:name];

		va_end( args );
		
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockN)FILE_PNG
{
	BeeHTTPRequestBlockN block = ^ BeeHTTPRequest * ( id first, ... )
	{
	#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

		va_list args;
		va_start( args, first );
		
		NSString * name = [(NSString *)first asNSString];
		NSObject * data = va_arg( args, NSObject * );
        
        if ( [data isKindOfClass:[UIImage class]] )
        {
            data = UIImagePNGRepresentation( (UIImage *)data );
        }
        
        [self addData:data withFileName:name andContentType:@"image/png" forKey:name];
		
		va_end( args );

	#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockN)FILE_JPG
{
	BeeHTTPRequestBlockN block = ^ BeeHTTPRequest * ( id first, ... )
	{
	#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

		va_list args;
		va_start( args, first );
		
		NSString * name = [(NSString *)first asNSString];
		NSObject * data = va_arg( args, NSObject * );
        
        if ( [data isKindOfClass:[UIImage class]] )
        {
            data = UIImageJPEGRepresentation( (UIImage *)data, 1.0f );
        }
        
        [self addData:data withFileName:nil andContentType:@"image/jpeg" forKey:name];
		
		va_end( args );
		
	#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

- (BeeHTTPRequestBlockN)FILE_MP4_ALIAS
{
	BeeHTTPRequestBlockN block = ^ BeeHTTPRequest * ( id first, ... )
	{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
		
		va_list args;
		va_start( args, first );
		
		NSString * name = [(NSString *)first asNSString];
		NSObject * data = va_arg( args, NSObject * );
		NSString * alias = va_arg( args, NSString * );
        
        [self addData:data withFileName:alias andContentType:@"video/mp4" forKey:name];
		
		va_end( args );
		
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockN)FILE_PNG_ALIAS
{
	BeeHTTPRequestBlockN block = ^ BeeHTTPRequest * ( id first, ... )
	{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
		
		va_list args;
		va_start( args, first );
		
		NSString * name = [(NSString *)first asNSString];
		NSObject * data = va_arg( args, NSObject * );
		NSString * alias = va_arg( args, NSString * );

        if ( [data isKindOfClass:[UIImage class]] )
        {
            data = UIImagePNGRepresentation( (UIImage *)data );
        }
        
        [self addData:data withFileName:alias andContentType:@"image/png" forKey:name];
		
		va_end( args );
		
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockN)FILE_JPG_ALIAS
{
	BeeHTTPRequestBlockN block = ^ BeeHTTPRequest * ( id first, ... )
	{
	#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
		
		va_list args;
		va_start( args, first );
		
		NSString * name = [(NSString *)first asNSString];
		NSObject * data = va_arg( args, NSObject * );
		NSString * alias = va_arg( args, NSString * );

        if ( [data isKindOfClass:[UIImage class]] )
        {
            data = data = UIImageJPEGRepresentation( (UIImage *)data, 1.0f );
        }

        [self addData:data withFileName:alias andContentType:@"image/jpeg" forKey:name];

		va_end( args );
		
	#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

- (BeeHTTPRequestBlockS)SAVE_AS
{
	BeeHTTPRequestBlockS block = ^ BeeHTTPRequest * ( NSString * path )
	{
		NSString * fullFolder = nil;
		NSString * fullPath = nil;
		
		if ( NSNotFound == [path rangeOfString:@"/"].location )
		{
			fullFolder = [NSString stringWithFormat:@"%@/%@/Download", [BeeSandbox libCachePath], [BeeSystemInfo appVersion]];
			fullFolder = [fullFolder stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
			
			fullPath = [fullFolder stringByAppendingPathComponent:path];
			fullPath = [fullPath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
		}
		else
		{
			fullFolder = [path stringByReplacingOccurrencesOfString:[path lastPathComponent] withString:@""];
			fullFolder = [fullFolder stringByReplacingOccurrencesOfString:@"//" withString:@"/"];

			fullPath = path;
			fullPath = [fullPath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
		}

		if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:fullFolder isDirectory:NULL] )
		{
			BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:fullFolder
												 withIntermediateDirectories:YES
																  attributes:nil
																	   error:nil];
			if ( NO == ret )
				return NO;
		}

		[self setDownloadDestinationPath:fullPath];
		[self setTemporaryFileDownloadPath:[fullPath stringByAppendingPathExtension:@".tmp"]];

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockB)SHOULD_COMPRESS
{
	BeeHTTPRequestBlockB block = ^ BeeHTTPRequest * ( BOOL flag )
	{
		[self setShouldCompressRequestBody:flag];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockB)SHOULD_DECOMPRESS
{
	BeeHTTPRequestBlockB block = ^ BeeHTTPRequest * ( BOOL flag )
	{
		if ( flag )
		{
		#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

			[self setShouldContinueWhenAppEntersBackground:YES];

		#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

			[self setShouldWaitToInflateCompressedResponses:YES];
			[self setAllowCompressedResponse:YES];
			[self setAllowResumeForFileDownloads:YES];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (void)startSynchronous
{
	[super startSynchronous];
}

- (void)startAsynchronous
{
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

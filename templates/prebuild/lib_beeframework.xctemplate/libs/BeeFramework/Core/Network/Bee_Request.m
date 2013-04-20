//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  Bee_Request.m
//

#include <execinfo.h>

#import "Bee_Precompile.h"
#import "Bee_Network.h"
#import "Bee_Runtime.h"
#import "Bee_Log.h"

#import "NSArray+BeeExtension.h"
#import "NSString+BeeExtension.h"
#import "NSDictionary+BeeExtension.h"
#import "NSObject+BeeTypeConversion.h"

#import "ASIHTTPRequest.h"
#import "ASIDataDecompressor.h"
#import "ASIFormDataRequest.h"

#pragma mark -

@interface BeeRequest(Private)
- (void)updateSendProgress;
- (void)updateRecvProgress;
@end

#pragma mark -

@implementation BeeRequest

DEF_INT( STATE_CREATED,		0 );
DEF_INT( STATE_SENDING,		1 );
DEF_INT( STATE_RECVING,		2 );
DEF_INT( STATE_FAILED,		3 );
DEF_INT( STATE_SUCCEED,		4 );
DEF_INT( STATE_CANCELLED,	5 );

@dynamic HEADER;
@dynamic BODY;
@dynamic PARAM;
@dynamic FILE;

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

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
@synthesize callstack = _callstack;
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

@synthesize created;
@synthesize sending;
@synthesize recving;
@synthesize failed;
@synthesize succeed;
//@synthesize cancelled;
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
		_state = BeeRequest.STATE_CREATED;
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

	#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
		_callstack = [[NSMutableArray alloc] init];
		[_callstack addObjectsFromArray:[BeeRuntime callstack:16]];
	#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	}

	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %@, state ==> %d, %d/%d",
			self.requestMethod, [self.url absoluteString],
			self.state,
			[self uploadBytes], [self downloadBytes]];
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
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	[_callstack removeAllObjects];
	[_callstack release];
	_callstack = nil;
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
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
		if ( [responder isRequestResponder] )
		{
			[responder handleRequest:self];
		}
	}
	
    [responds release];
}

- (void)forwardResponder:(NSObject *)obj
{
	if ( [obj isRequestResponder] )
	{
		[obj handleRequest:self];
	}			
}

- (void)changeState:(NSUInteger)state
{
	if ( state != _state )
	{
		_state = state;

		if ( BeeRequest.STATE_SENDING == _state )
		{
			_sendTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		}
		else if ( BeeRequest.STATE_RECVING == _state )
		{
			_recvTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		}
		else if ( BeeRequest.STATE_FAILED == _state || BeeRequest.STATE_SUCCEED == _state || BeeRequest.STATE_CANCELLED == _state )
		{
			_doneTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		}

		[self callResponders];

//		if ( [_responder isRequestResponder] )
//		{
//			[_responder handleRequest:self];
//		}
		
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

//	if ( [_responder isRequestResponder] )
//	{
//		[_responder handleRequest:self];
//	}
	
	if ( self.whenUpdate )
	{
		self.whenUpdate( self );
	}
	
	_sendProgressed = NO;
}

- (void)updateRecvProgress
{
	if ( _state == BeeRequest.STATE_SUCCEED || _state == BeeRequest.STATE_FAILED || _state == BeeRequest.STATE_CANCELLED )
		return;
    
    if ( self.didUseCachedResponse )
		return;
    
	_recvProgressed = YES;
	
	[self callResponders];

//	if ( [_responder isRequestResponder] )
//	{
//		[_responder handleRequest:self];
//	}
	
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
	return BeeRequest.STATE_CREATED == _state ? YES : NO;
}

- (BOOL)sending
{
	return BeeRequest.STATE_SENDING == _state ? YES : NO;
}

- (BOOL)recving
{
	return BeeRequest.STATE_RECVING == _state ? YES : NO;
}

- (BOOL)succeed
{
	return BeeRequest.STATE_SUCCEED == _state ? YES : NO;
}

- (BOOL)failed
{
	return BeeRequest.STATE_FAILED == _state ? YES : NO;
}

- (BOOL)cancelled
{
	return BeeRequest.STATE_CANCELLED == _state ? YES : NO;
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

- (BeeRequestBlockN)HEADER
{
	BeeRequestBlockN block = ^ BeeRequest * ( id first, ... )
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

- (BeeRequestBlockN)BODY
{
	BeeRequestBlockN block = ^ BeeRequest * ( id first, ... )
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

- (BeeRequestBlockN)PARAM
{
	BeeRequestBlockN block = ^ BeeRequest * ( id first, ... )
	{
		va_list args;
		va_start( args, first );

		NSString * key = [(NSString *)first asNSString];
		NSString * value = [va_arg( args, NSObject * ) asNSString];

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

		va_end( args );

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeRequestBlockN)FILE
{
	BeeRequestBlockN block = ^ BeeRequest * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * name = [(NSString *)first asNSString];
		id data = va_arg( args, NSObject * );

		if ( data )
		{
			NSString * path;
			
			path = NSHomeDirectory();
			path = [path stringByAppendingPathComponent:@"Documents"];
			path = [path stringByAppendingPathComponent:name];

			if ( [data isKindOfClass:[NSString class]] )
			{
				NSString * string = (NSString *)data;
				[string writeToFile:path
						 atomically:YES
						   encoding:NSUTF8StringEncoding
							  error:NULL];
			}
			else if ( [data isKindOfClass:[NSData class]] )
			{
				[data writeToFile:path
						  options:NSDataWritingAtomic
							error:NULL];
			}
			else
			{
				NSData * data = [[first description] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
				[data writeToFile:path
						  options:NSDataWritingAtomic
							error:NULL];
			}

			[self setFile:path forKey:name];
		}

		va_end( args );
		
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

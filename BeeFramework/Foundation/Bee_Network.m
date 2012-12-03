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
//  Bee_Network.m
//

#include <execinfo.h>

#import "Bee_Precompile.h"
#import "Bee_Network.h"
#import "Bee_Runtime.h"
#import "Bee_Log.h"

#import "NSArray+BeeExtension.h"
#import "NSDictionary+BeeExtension.h"

#import "ASIHTTPRequest.h"
#import "ASIDataDecompressor.h"
#import "ASIFormDataRequest.h"

#pragma mark -

#undef	DEFAULT_BLACKLIST_TIMEOUT
#define DEFAULT_BLACKLIST_TIMEOUT	(60.0f * 5.0f)	// 黑名单超时

#undef	DEFAULT_GET_TIMEOUT
#define DEFAULT_GET_TIMEOUT			(30.0f)			// 取图30秒超时

#undef	DEFAULT_POST_TIMEOUT
#define DEFAULT_POST_TIMEOUT		(30.0f)			// 发协议30秒超时

#undef	DEFAULT_UPLOAD_TIMEOUT
#define DEFAULT_UPLOAD_TIMEOUT		(120.0f)		// 上传图片120秒超时

#pragma mark -

@implementation NSObject(BeeRequestResponder)

- (BOOL)isRequestResponder
{
	if ( [self respondsToSelector:@selector(handleRequest:)] )
	{
		return YES;
	}
	
	return NO;
}

- (BeeRequest *)GET:(NSString *)url
{
	if ( [self isRequestResponder] )
	{
		BeeRequest * request = [BeeRequestQueue GET:url];
		[request addResponder:self];
//		request.responder = self;
		return request;
	}
	else
	{
		return nil;
	}
}

- (BeeRequest *)POST:(NSString *)url text:(NSString *)text
{
	if ( [self isRequestResponder] )
	{
		NSData * data = [text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
		BeeRequest * request = [BeeRequestQueue POST:url data:data];
		[request addResponder:self];
//		request.responder = self;
		return request;	
	}
	else
	{
		return nil;
	}
}

- (BeeRequest *)POST:(NSString *)url data:(NSData *)data
{
	if ( [self isRequestResponder] )
	{
		BeeRequest * request = [BeeRequestQueue POST:url data:data];
		[request addResponder:self];
//		request.responder = self;
		return request;	
	}
	else
	{
		return nil;
	}
}

- (BeeRequest *)POST:(NSString *)url dict:(NSDictionary *)kvs
{
	if ( [self isRequestResponder] )
	{
		BeeRequest * request = [BeeRequestQueue POST:url params:kvs];
		[request addResponder:self];
//		request.responder = self;
		return request;
	}
	else
	{
		return nil;
	}
}

- (BeeRequest *)POST:(NSString *)url params:(id)first, ...
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;
		
		CC( @"POST, %@ = %@", [key description], [value description] );
		
		[dict setObject:value forKey:key];
	}

	if ( [self isRequestResponder] )
	{
		BeeRequest * request = [BeeRequestQueue POST:url params:dict];
		[request addResponder:self];
//		request.responder = self;
		return request;
	}
	else
	{
		return nil;
	}
}

- (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files
{
	if ( [self isRequestResponder] )
	{
		BeeRequest * request = [BeeRequestQueue POST:url files:files];
		[request addResponder:self];
//		request.responder = self;
		return request;
	}
	else
	{
		return nil;
	}
}

- (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files dict:(NSDictionary *)kvs
{
	if ( [self isRequestResponder] )
	{
		BeeRequest * request = [BeeRequestQueue POST:url files:files params:kvs];
		[request addResponder:self];
//		request.responder = self;
		return request;
	}
	else
	{
		return nil;
	}	
}

- (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files params:(id)first, ...
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;
		
		[dict setObject:value forKey:key];
	}

	if ( [self isRequestResponder] )
	{
		BeeRequest * request = [BeeRequestQueue POST:url files:files params:dict];
		[request addResponder:self];
//		request.responder = self;
		return request;
	}
	else
	{
		return nil;
	}	
}

- (BOOL)requestingURL
{
	if ( [self isRequestResponder] )
	{
		return [BeeRequestQueue requesting:nil byResponder:self];
	}
	else
	{
		return NO;
	}		
}

- (BOOL)requestingURL:(NSString *)url
{
	if ( [self isRequestResponder] )
	{
		return [BeeRequestQueue requesting:url byResponder:self];
	}
	else
	{
		return NO;
	}			
}

- (NSArray *)requests
{
	return [BeeRequestQueue requests:nil byResponder:self];
}

- (NSArray *)requests:(NSString *)url
{
	return [BeeRequestQueue requests:url byResponder:self];
}

- (void)cancelRequests
{
	if ( [self isRequestResponder] )
	{
		[BeeRequestQueue cancelRequestByResponder:self];
	}
}

- (void)handleRequest:(BeeRequest *)request
{
}

@end

#pragma mark -

@interface BeeRequest(Private)
- (void)updateSendProgress;
- (void)updateRecvProgress;
@end

@implementation BeeRequest

DEF_INT( STATE_CREATED,		0 );
DEF_INT( STATE_SENDING,		1 );
DEF_INT( STATE_RECVING,		2 );
DEF_INT( STATE_FAILED,		3 );
DEF_INT( STATE_SUCCEED,		4 );
DEF_INT( STATE_CANCELLED,	5 );

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
		
		_responders = [[NSMutableArray alloc] init];
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
	
	[_responders removeAllObjectsNoRelease];
	[_responders release];
	
	[_userInfo removeAllObjects];
	[_userInfo release];
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	[_callstack removeAllObjects];
	[_callstack release];	
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
	for ( NSObject * responder in _responders )
	{
		if ( [responder isRequestResponder] )
		{
			[responder handleRequest:self];
		}			
	}	
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
	[_responders addObjectNoRetain:responder];
}

- (void)removeResponder:(id)responder
{
	[_responders removeObjectNoRelease:responder];
}

@end

#pragma mark -

@interface BeeRequestQueue(Private)
- (BOOL)checkResourceBroken:(NSString *)url;

- (BeeRequest *)GET:(NSString *)url sync:(BOOL)sync;
- (BeeRequest *)POST:(NSString *)url data:(NSData *)data sync:(BOOL)sync;
- (BeeRequest *)POST:(NSString *)url params:(NSDictionary *)kvs sync:(BOOL)sync;
- (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files params:(NSDictionary *)kvs sync:(BOOL)sync;

- (void)cancelRequest:(BeeRequest *)request;
- (void)cancelRequestByResponder:(id)responder;
- (void)cancelAllRequests;

- (void)blockURL:(NSString *)url;
- (void)unblockURL:(NSString *)url;

- (BOOL)requesting:(NSString *)url;
- (BOOL)requesting:(NSString *)url byResponder:(id)responder;

- (NSArray *)requests:(NSString *)url;
- (NSArray *)requests:(NSString *)url byResponder:(id)responder;

@end

#pragma mark -

@implementation BeeRequestQueue

@synthesize merge = _merge;
@synthesize online = _online;

@synthesize	blackListEnable = _blackListEnable;
@synthesize	blackListTimeout = _blackListTimeout;
@synthesize	blackList = _blackList;

@synthesize bytesUpload = _bytesUpload;
@synthesize bytesDownload = _bytesDownload;

@synthesize delay = _delay;
@synthesize requests = _requests;

@synthesize whenCreate = _whenCreate;
@synthesize whenUpdate = _whenUpdate;

+ (BOOL)isReachableViaWIFI
{
	return YES;
}

+ (BOOL)isReachableViaWLAN
{
	return YES;
}

+ (BOOL)isNetworkInUse
{
	return ([[BeeRequestQueue sharedInstance].requests count] > 0) ? YES : NO;
}

+ (NSUInteger)bandwidthUsedPerSecond
{
	return [ASIHTTPRequest averageBandwidthUsedPerSecond];
}

+ (BeeRequestQueue *)sharedInstance
{
	static BeeRequestQueue * __sharedInstance = nil;

	@synchronized(self)
	{
		if ( nil == __sharedInstance )
		{
			__sharedInstance = [[BeeRequestQueue alloc] init];

//			[ASIHTTPRequest setShouldThrottleBandwidthForWWAN:YES];
//			[ASIHTTPRequest throttleBandwidthForWWANUsingLimit:32 * 1024];	// 32K
			[ASIHTTPRequest setDefaultUserAgentString:@"Bee"];			
			[[ASIHTTPRequest sharedQueue] setMaxConcurrentOperationCount:10];
		}
	}
	
	return (BeeRequestQueue *)__sharedInstance;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_delay = 0.1f;
		_merge = YES;
		_online = YES;
		_requests = [[NSMutableArray alloc] init];

		_blackListEnable = YES;
		_blackListTimeout = DEFAULT_BLACKLIST_TIMEOUT;
		_blackList = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void)setOnline:(BOOL)en
{
	_online = en;

	if ( NO == _online )
	{
		[self cancelAllRequests];
	}
}

- (void)dealloc
{
	[self cancelAllRequests];

	[_requests removeAllObjects];
	[_requests release];

	[_blackList removeAllObjects];
	[_blackList release];
	
	self.whenCreate = nil;
	self.whenUpdate = nil;

	[super dealloc];
}

- (BOOL)checkResourceBroken:(NSString *)url
{
	if ( _blackListEnable )
	{
		NSDate * date = nil;
		NSDate * now = [NSDate date];
		
		date = [_blackList objectForKey:url];
		if ( date && ([date timeIntervalSince1970] - [now timeIntervalSince1970]) < _blackListTimeout )
		{
		#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
			CC( @"resource broken: %@", url );
		#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
			
			return YES;
		}
	}
		
	return NO;		
}

+ (BeeRequest *)GET:(NSString *)url
{
	return [[BeeRequestQueue sharedInstance] GET:url sync:NO];
}

- (BeeRequest *)GET:(NSString *)url sync:(BOOL)sync
{
	if ( NO == _online )
		return nil;
	
	if ( [self checkResourceBroken:url] )
	{
		return nil;
	}

	BeeRequest * request = nil;

	if ( NO == sync && _merge )
	{
		for ( BeeRequest * req in _requests )
		{
			if ( [req.url.absoluteString isEqualToString:url] )
			{
				return req;
			}
		}
	}

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"GET %@\n", url );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

	request = [[BeeRequest alloc] initWithURL:[NSURL URLWithString:url]];
	request.timeOutSeconds = DEFAULT_GET_TIMEOUT;
	request.requestMethod = @"GET";
	request.postBody = nil;
	[request setDelegate:self];
	[request setDownloadProgressDelegate:self];
	[request setUploadProgressDelegate:self];

	[request setNumberOfTimesToRetryOnTimeout:2];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif	// #if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0

	[request setThreadPriority:0.5];
	[request setQueuePriority:NSOperationQueuePriorityLow];

	[_requests addObject:request];
	
	if ( self.whenCreate )
	{
		self.whenCreate( request );
	}

	if ( sync )
	{
		[request startSynchronous];
	}
	else
	{
		if ( _delay )
		{
			[request performSelector:@selector(startAsynchronous)
						  withObject:nil
						  afterDelay:_delay];		
		}
		else
		{
			[request startAsynchronous];
		}
	}

	return [request autorelease];
}

+ (BeeRequest *)POST:(NSString *)url data:(NSData *)data
{
	return [[BeeRequestQueue sharedInstance] POST:url data:data sync:NO];
}

- (BeeRequest *)POST:(NSString *)url data:(NSData *)data sync:(BOOL)sync
{
	if ( NO == _online )
		return nil;
	
	BeeRequest * request = nil;
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"POST %@\n", url );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
	request = [[BeeRequest alloc] initWithURL:[NSURL URLWithString:url]];
	request.timeOutSeconds = DEFAULT_POST_TIMEOUT;
	request.requestMethod = @"POST";
	request.postFormat = ASIMultipartFormDataPostFormat; // ASIRawPostFormat;
	request.postBody = [NSMutableData dataWithData:data];
	[request setDelegate:self];
	[request setDownloadProgressDelegate:self];
	[request setUploadProgressDelegate:self];
	[request setNumberOfTimesToRetryOnTimeout:2];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif	// #if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0

	[request setThreadPriority:1.0];
	[request setQueuePriority:NSOperationQueuePriorityHigh];

	[_requests addObject:request];	
	
	if ( self.whenCreate )
	{
		self.whenCreate( request );
	}

	if ( sync )
	{
		[request startSynchronous];
	}
	else
	{
		if ( _delay )
		{
			[request performSelector:@selector(startAsynchronous)
						  withObject:nil
						  afterDelay:_delay];
		}
		else
		{
			[request startAsynchronous];
		}
	}
	
	return [request autorelease];
}

+ (BeeRequest *)POST:(NSString *)url params:(NSDictionary *)kvs
{
	return [[BeeRequestQueue sharedInstance] POST:url params:kvs sync:NO];
}

- (BeeRequest *)POST:(NSString *)url params:(NSDictionary *)kvs sync:(BOOL)sync
{
	if ( NO == _online )
		return nil;

	BeeRequest * request = nil;

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"POST %@\n", url );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

	request = [[BeeRequest alloc] initWithURL:[NSURL URLWithString:url]];
	request.timeOutSeconds = DEFAULT_POST_TIMEOUT;
	request.requestMethod = @"POST";
	request.postFormat = ASIMultipartFormDataPostFormat;
	[request setDelegate:self];
	[request setDownloadProgressDelegate:self];
	[request setUploadProgressDelegate:self];

	[request setNumberOfTimesToRetryOnTimeout:2];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif	// #if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	
	[request setThreadPriority:1.0];
	[request setQueuePriority:NSOperationQueuePriorityHigh];
	
	NSArray * keys = [kvs allKeys];
	for ( NSString * key in keys )
	{
		[request setPostValue:[kvs objectForKey:key] forKey:key];
	}

	[_requests addObject:request];
	
	if ( self.whenCreate )
	{
		self.whenCreate( request );
	}

	if ( sync )
	{
		[request startSynchronous];
	}
	else
	{
		if ( _delay )
		{
			[request performSelector:@selector(startAsynchronous)
						  withObject:nil
						  afterDelay:_delay];
		}
		else
		{
			[request startAsynchronous];			
		}
	}
	
	return [request autorelease];
}

+ (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files
{
	return [[BeeRequestQueue sharedInstance] POST:url files:files params:nil sync:NO];
}

+ (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files params:(NSDictionary *)kvs
{
	return [[BeeRequestQueue sharedInstance] POST:url files:files params:kvs sync:NO];
}

- (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files params:(NSDictionary *)kvs sync:(BOOL)sync
{
	if ( NO == _online )
		return nil;

	BeeRequest * request = nil;
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"POST %@\n", url );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

	request = [[BeeRequest alloc] initWithURL:[NSURL URLWithString:url]];
	request.timeOutSeconds = DEFAULT_UPLOAD_TIMEOUT;
	request.requestMethod = @"POST";
	request.postFormat = ASIMultipartFormDataPostFormat;
	[request setDelegate:self];
	[request setDownloadProgressDelegate:self];
	[request setUploadProgressDelegate:self];
	
	[request setNumberOfTimesToRetryOnTimeout:2];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif	// #if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	
	[request setThreadPriority:1.0];
	[request setQueuePriority:NSOperationQueuePriorityHigh];
	
	if ( kvs )
	{
		NSArray * keys = [kvs allKeys];
		for ( NSString * key in keys )
		{
			[request setPostValue:[kvs objectForKey:key] forKey:key];
		}
	}

	if ( files )
	{
		NSArray * fileNames = [files allKeys];
		for ( NSInteger i = 0; i < [fileNames count]; ++i )
		{
			NSString * fileName = [fileNames objectAtIndex:i];
			NSObject * fileData = [files objectForKey:fileName];

			if ( fileName && fileData )
			{
				NSString * homePath = NSHomeDirectory();
				NSString * docsPath = [homePath stringByAppendingPathComponent:@"Documents"];
				NSString * filePath = [docsPath stringByAppendingPathComponent:fileName];

				if ( [fileData isKindOfClass:[NSString class]] )
				{
					NSString * string = (NSString *)fileData;
					[string writeToFile:filePath
							 atomically:YES
							   encoding:NSUTF8StringEncoding
								  error:NULL];				
				}
				else if ( [fileData isKindOfClass:[NSData class]] )
				{
					NSData * data = (NSData *)fileData;
					[data writeToFile:filePath
							  options:NSDataWritingAtomic
								error:NULL];
				}
				else
				{
					NSAssert( 0, @"non-support type of file data" );
				}

				[request setFile:filePath forKey:fileName];
			}
		}
	}

	[_requests addObject:request];
	
	if ( self.whenCreate )
	{
		self.whenCreate( request );
	}

	if ( sync )
	{
		[request startSynchronous];
	}
	else
	{
		if ( _delay )
		{
			[request performSelector:@selector(startAsynchronous)
						  withObject:nil
						  afterDelay:_delay];
		}
		else
		{
			[request startAsynchronous];
		}
	}
	
	return [request autorelease];
}

+ (BOOL)requesting:(NSString *)url
{
	return [[BeeRequestQueue sharedInstance] requesting:url];
}

- (BOOL)requesting:(NSString *)url
{
	for ( BeeRequest * request in _requests )
	{
		if ( [[request.url absoluteString] isEqualToString:url] )
		{
			return YES;
		}			
	}

	return NO;
}

+ (BOOL)requesting:(NSString *)url byResponder:(id)responder
{
	return [[BeeRequestQueue sharedInstance] requesting:url byResponder:responder];
}

- (BOOL)requesting:(NSString *)url byResponder:(id)responder
{
	for ( BeeRequest * request in _requests )
	{
		if ( responder && NO == [request hasResponder:responder] /*request.responder != responder*/ )
			continue;

		if ( nil == url || [[request.url absoluteString] isEqualToString:url] )
		{
			return YES;
		}			
	}

	return NO;
}

+ (NSArray *)requests:(NSString *)url
{
	return [[BeeRequestQueue sharedInstance] requests:url];
}

- (NSArray *)requests:(NSString *)url
{
	NSMutableArray * array = [NSMutableArray array];
	
	for ( BeeRequest * request in _requests )
	{
		if ( [[request.url absoluteString] isEqualToString:url] )
		{
			[array addObject:request];
		}			
	}
	
	return array;
}

+ (NSArray *)requests:(NSString *)url byResponder:(id)responder
{
	return [[BeeRequestQueue sharedInstance] requests:url byResponder:responder];
}

- (NSArray *)requests:(NSString *)url byResponder:(id)responder
{
	NSMutableArray * array = [NSMutableArray array];

	for ( BeeRequest * request in _requests )
	{
		if ( responder && NO == [request hasResponder:responder] /* request.responder != responder */ )
			continue;
		
		if ( nil == url || [[request.url absoluteString] isEqualToString:url] )
		{
			[array addObject:request];
		}			
	}

	return array;
}

+ (void)cancelRequest:(BeeRequest *)request
{
	[[BeeRequestQueue sharedInstance] cancelRequest:request];
}

- (void)cancelRequest:(BeeRequest *)request
{
	[NSObject cancelPreviousPerformRequestsWithTarget:request selector:@selector(startAsynchronous) object:nil];
	
	if ( [_requests containsObject:request] )
	{
		if ( request.created || request.sending || request.recving )
		{
			[request clearDelegatesAndCancel];
			[request changeState:BeeRequest.STATE_CANCELLED];
		}
		
		[_requests removeObject:request];
	}	
}

+ (void)cancelRequestByResponder:(id)responder
{
	[[BeeRequestQueue sharedInstance] cancelRequestByResponder:responder];
}

- (void)cancelRequestByResponder:(id)responder
{
	if ( nil == responder )
	{
		[self cancelAllRequests];
	}
	else
	{
		NSMutableArray * tempArray = [NSMutableArray array];
		
		for ( BeeRequest * request in _requests )
		{
			if ( [request hasResponder:responder] /* request.responder == responder */ )
			{
				[tempArray addObject:request];				
			}			
		}
		
		for ( BeeRequest * request in tempArray )
		{
			[self cancelRequest:request];
		}
	}
}

+ (void)cancelAllRequests
{
	[[BeeRequestQueue sharedInstance] cancelAllRequests];
}

- (void)cancelAllRequests
{
	for ( BeeRequest * request in _requests )
	{
		[self cancelRequest:request];
	}
}

+ (void)blockURL:(NSString *)url
{
	[[BeeRequestQueue sharedInstance] blockURL:url];
}

- (void)blockURL:(NSString *)url
{
	[_blackList setObject:[NSDate date] forKey:url];
}

+ (void)unblockURL:(NSString *)url
{
	[[BeeRequestQueue sharedInstance] unblockURL:url];
}

- (void)unblockURL:(NSString *)url
{
	if ( [_blackList objectForKey:url] )
	{
		NSDate * date = [NSDate dateWithTimeInterval:(_blackListTimeout + 1.0f) sinceDate:[NSDate date]];
		[_blackList setObject:date forKey:url];
	}	
}

- (NSArray *)requests
{
	return _requests;
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestStarted:(ASIHTTPRequest *)request
{
	if ( NO == [request isKindOfClass:[BeeRequest class]] )
		return;

	BeeRequest * networkRequest = (BeeRequest *)request;
	[networkRequest changeState:BeeRequest.STATE_SENDING];

	_bytesUpload += request.postLength;
	
	if ( self.whenUpdate )
	{
		self.whenUpdate( networkRequest );
	}
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
	if ( NO == [request isKindOfClass:[BeeRequest class]] )
		return;

	BeeRequest * networkRequest = (BeeRequest *)request;
	[networkRequest changeState:BeeRequest.STATE_RECVING];
	
	if ( self.whenUpdate )
	{
		self.whenUpdate( networkRequest );
	}
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	_bytesDownload += [[request rawResponseData] length];
	
	if ( NO == [request isKindOfClass:[BeeRequest class]] )
		return;

	BeeRequest * networkRequest = (BeeRequest *)request;
	
#if __BEE_DEVELOPMENT__
	CC( @"\nHTTP %d(%@)\n%@\n",
		  request.responseStatusCode,
		  request.responseStatusMessage,
		  [request.url absoluteString] );
#endif

	if ( [request.requestMethod isEqualToString:@"GET"] )
	{
		if ( request.responseStatusCode >= 400 && request.responseStatusCode < 500 )
		{
			[self blockURL:[request.url absoluteString]];
		}
	}

	if ( 200 == request.responseStatusCode )
	{
		[networkRequest changeState:BeeRequest.STATE_SUCCEED];
	}
	else
	{
		[networkRequest changeState:BeeRequest.STATE_FAILED];
	}

	[_requests removeObject:networkRequest];
	[networkRequest cancel];	
	
	if ( self.whenUpdate )
	{
		self.whenUpdate( networkRequest );
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	if ( NO == [request isKindOfClass:[BeeRequest class]] )
		return;

	BeeRequest * networkRequest = (BeeRequest *)request;	
	networkRequest.errorCode = -1;
	[networkRequest changeState:BeeRequest.STATE_FAILED];
	[networkRequest cancel];
	
	[_requests removeObject:networkRequest];
	
	if ( self.whenUpdate )
	{
		self.whenUpdate( networkRequest );
	}
}

#pragma mark -

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
	[self requestFailed:request];
}

- (void)requestRedirected:(ASIHTTPRequest *)request
{
	[self requestFailed:request];
}

- (void)authenticationNeededForRequest:(ASIHTTPRequest *)request
{
	[self requestFailed:request];
}

- (void)proxyAuthenticationNeededForRequest:(ASIHTTPRequest *)request
{
	[self requestFailed:request];
}

#pragma mark -

// Called when the request receives some data - bytes is the length of that data
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
	if ( NO == [request isKindOfClass:[BeeRequest class]] )
		return;
	
	BeeRequest * networkRequest = (BeeRequest *)request;
	[networkRequest updateRecvProgress];
}

// Called when the request sends some data
// The first 32KB (128KB on older platforms) of data sent is not included in this amount because of limitations with the CFNetwork API
// bytes may be less than zero if a request needs to remove upload progress (probably because the request needs to run again)
- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
	if ( NO == [request isKindOfClass:[BeeRequest class]] )
		return;
	
	BeeRequest * networkRequest = (BeeRequest *)request;
	[networkRequest updateSendProgress];
}

// Called when a request needs to change the length of the content to download
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
	if ( NO == [request isKindOfClass:[BeeRequest class]] )
		return;
	
	BeeRequest * networkRequest = (BeeRequest *)request;
	[networkRequest updateRecvProgress];
}

// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength
{
	if ( NO == [request isKindOfClass:[BeeRequest class]] )
		return;
	
	BeeRequest * networkRequest = (BeeRequest *)request;
	[networkRequest updateSendProgress];
}

@end

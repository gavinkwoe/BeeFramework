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
#import "Bee_Log.h"
#import "Bee_RequestQueue.h"

#pragma mark -

#undef	DEFAULT_BLACKLIST_TIMEOUT
#define DEFAULT_BLACKLIST_TIMEOUT	(60.0f * 5.0f)	// 黑名单超时5分钟

#undef	DEFAULT_GET_TIMEOUT
#define DEFAULT_GET_TIMEOUT			(30.0f)			// 取图30秒超时

#undef	DEFAULT_POST_TIMEOUT
#define DEFAULT_POST_TIMEOUT		(30.0f)			// 发协议30秒超时

#undef	DEFAULT_PUT_TIMEOUT
#define DEFAULT_PUT_TIMEOUT			(30.0f)			// 上传30秒超时

#undef	DEFAULT_UPLOAD_TIMEOUT
#define DEFAULT_UPLOAD_TIMEOUT		(120.0f)		// 上传图片120秒超时

#pragma mark -

@interface BeeRequestQueue(Private)

- (BOOL)checkResourceBroken:(NSString *)url;

- (BeeRequest *)GET:(NSString *)url sync:(BOOL)sync;
- (BeeRequest *)POST:(NSString *)url sync:(BOOL)sync;
- (BeeRequest *)PUT:(NSString *)url sync:(BOOL)sync;

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

+ (BeeRequest *)POST:(NSString *)url
{
	return [[BeeRequestQueue sharedInstance] POST:url sync:NO];
}

- (BeeRequest *)POST:(NSString *)url sync:(BOOL)sync
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

+ (BeeRequest *)PUT:(NSString *)url
{
	return [[BeeRequestQueue sharedInstance] PUT:url sync:NO];
}

- (BeeRequest *)PUT:(NSString *)url sync:(BOOL)sync
{
	if ( NO == _online )
		return nil;
	
	BeeRequest * request = nil;
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"PUT %@\n", url );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

	request = [[BeeRequest alloc] initWithURL:[NSURL URLWithString:url]];
	request.timeOutSeconds = DEFAULT_PUT_TIMEOUT;
	request.requestMethod = @"PUT";
	request.postFormat = ASIURLEncodedPostFormat; // ASIRawPostFormat;
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
			[request changeState:BeeRequest.STATE_CANCELLED];
		}

		[request clearDelegatesAndCancel];
		[request removeAllResponders];

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
	CC( @"HTTP %d(%@)\n%@\n",
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

	[networkRequest clearDelegatesAndCancel];	
	[networkRequest removeAllResponders];

	[_requests removeObject:networkRequest];
		
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
	
	[networkRequest clearDelegatesAndCancel];	
	[networkRequest removeAllResponders];	
	
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

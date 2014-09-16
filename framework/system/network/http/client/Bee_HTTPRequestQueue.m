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

#import "Bee_HTTPRequestQueue.h"
#import "Bee_HTTPRequest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( BeePackage_HTTP, BeeHTTPRequestQueue, requestQueue );

#pragma mark -

#undef	DEFAULT_BLACKLIST_TIMEOUT
#define DEFAULT_BLACKLIST_TIMEOUT	(60.0f * 5.0f)	// 黑名单超时5分钟

#undef	DEFAULT_GET_TIMEOUT
#define DEFAULT_GET_TIMEOUT			(120.0f)		// 取图60秒超时

#undef	DEFAULT_POST_TIMEOUT
#define DEFAULT_POST_TIMEOUT		(120.0f)		// 发协议120秒超时

#undef	DEFAULT_PUT_TIMEOUT
#define DEFAULT_PUT_TIMEOUT			(120.0f)		// 上传30秒超时

#undef	DEFAULT_UPLOAD_TIMEOUT
#define DEFAULT_UPLOAD_TIMEOUT		(300.0f)		// 上传图片300秒超时

#undef	DEFAULT_DELETE_TIMEOUT
#define DEFAULT_DELETE_TIMEOUT		(120.0f)		// 上传图片120秒超时

#pragma mark -

@interface BeeHTTPRequestQueue()
{
	BOOL						_merge;
	BOOL						_online;
	
	BOOL						_blackListEnable;
	NSTimeInterval				_blackListTimeout;
	NSMutableDictionary *		_blackList;
	
	NSUInteger					_bytesUpload;
	NSUInteger					_bytesDownload;
	
	NSTimeInterval				_delay;
	NSMutableArray *			_requests;
	
	BeeHTTPRequestQueueBlock	_whenCreate;
	BeeHTTPRequestQueueBlock	_whenUpdate;
}

- (BOOL)checkResourceBroken:(NSString *)url;

- (BeeHTTPRequest *)GET:(NSString *)url sync:(BOOL)sync;
- (BeeHTTPRequest *)POST:(NSString *)url sync:(BOOL)sync;
- (BeeHTTPRequest *)PUT:(NSString *)url sync:(BOOL)sync;
- (BeeHTTPRequest *)DELETE:(NSString *)url sync:(BOOL)sync;

- (void)cancelRequest:(BeeHTTPRequest *)request;
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

@implementation BeeHTTPRequestQueue

DEF_SINGLETON( BeeHTTPRequestQueue )

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

+ (BOOL)isNetworkInUse
{
	return ([[BeeHTTPRequestQueue sharedInstance].requests count] > 0) ? YES : NO;
}

+ (NSUInteger)bandwidthUsedPerSecond
{
	return [ASIHTTPRequest averageBandwidthUsedPerSecond];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_delay = 0.01f;
		_merge = YES;
		_online = YES;
		_requests = [[NSMutableArray alloc] init];

		_blackListEnable = NO;
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
			ERROR( @"HTTP resource broken: %@", url );
			return YES;
		}
	}
		
	return NO;		
}

+ (BeeHTTPRequest *)GET:(NSString *)url
{
	return [[BeeHTTPRequestQueue sharedInstance] GET:url sync:NO];
}

- (BeeHTTPRequest *)GET:(NSString *)url sync:(BOOL)sync
{
	BeeHTTPRequest * request = nil;

	if ( NO == sync && _merge )
	{
		for ( BeeHTTPRequest * req in _requests )
		{
			if ( [req.url.absoluteString isEqualToString:url] )
			{
				return req;
			}
		}
	}

	NSURL * absoluteURL = [NSURL URLWithString:url];

	if ( NO == _online || [self checkResourceBroken:url] )
	{
		request = [[[BeeEmptyRequest alloc] initWithURL:absoluteURL] autorelease];
	}
	else
	{
		request = [[BeeHTTPRequest alloc] initWithURL:absoluteURL];
	}

	request.timeOutSeconds = DEFAULT_GET_TIMEOUT;
	request.requestMethod = @"GET";
	request.postBody = nil;
	[request setDelegate:self];
	[request setDownloadProgressDelegate:self];
	[request setUploadProgressDelegate:self];
	[request setShouldAttemptPersistentConnection:NO];

	[request setNumberOfTimesToRetryOnTimeout:2];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:NO];
#endif	// #if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0

	[request setThreadPriority:0.1];
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

+ (BeeHTTPRequest *)POST:(NSString *)url
{
	return [[BeeHTTPRequestQueue sharedInstance] POST:url sync:NO];
}

- (BeeHTTPRequest *)POST:(NSString *)url sync:(BOOL)sync
{
	BeeHTTPRequest * request = nil;
	
	NSURL * absoluteURL = [NSURL URLWithString:url];
	
	if ( NO == _online )
	{
		request = [[[BeeEmptyRequest alloc] initWithURL:absoluteURL] autorelease];
	}
	else
	{
		request = [[BeeHTTPRequest alloc] initWithURL:absoluteURL];
	}
	
	request.timeOutSeconds = DEFAULT_POST_TIMEOUT;
	request.requestMethod = @"POST";
//	request.postFormat = ASIMultipartFormDataPostFormat; // ASIRawPostFormat;
	[request setDelegate:self];
	[request setDownloadProgressDelegate:self];
	[request setUploadProgressDelegate:self];
	[request setNumberOfTimesToRetryOnTimeout:0];
	[request setShouldAttemptPersistentConnection:NO];
	
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif	// #if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0

	[request setThreadPriority:1.0];
	[request setQueuePriority:NSOperationQueuePriorityVeryHigh];

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

+ (BeeHTTPRequest *)PUT:(NSString *)url
{
	return [[BeeHTTPRequestQueue sharedInstance] PUT:url sync:NO];
}

- (BeeHTTPRequest *)PUT:(NSString *)url sync:(BOOL)sync
{
	BeeHTTPRequest * request = nil;
	
	NSURL * absoluteURL = [NSURL URLWithString:url];

	if ( NO == _online )
	{
		request = [[[BeeEmptyRequest alloc] initWithURL:absoluteURL] autorelease];
	}
	else
	{
		request = [[BeeHTTPRequest alloc] initWithURL:absoluteURL];
	}

	request.timeOutSeconds = DEFAULT_PUT_TIMEOUT;
	request.requestMethod = @"PUT";
//	request.postFormat = ASIURLEncodedPostFormat; // ASIRawPostFormat;
	[request setDelegate:self];
	[request setDownloadProgressDelegate:self];
	[request setUploadProgressDelegate:self];
	[request setNumberOfTimesToRetryOnTimeout:2];
	[request setShouldAttemptPersistentConnection:NO];
	
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

+ (BeeHTTPRequest *)DELETE:(NSString *)url
{
	return [[BeeHTTPRequestQueue sharedInstance] DELETE:url sync:NO];
}

- (BeeHTTPRequest *)DELETE:(NSString *)url sync:(BOOL)sync
{
	BeeHTTPRequest * request = nil;
	
	NSURL * absoluteURL = [NSURL URLWithString:url];
	
	if ( NO == _online )
	{
		request = [[[BeeEmptyRequest alloc] initWithURL:absoluteURL] autorelease];
	}
	else
	{
		request = [[BeeHTTPRequest alloc] initWithURL:absoluteURL];
	}

	request.timeOutSeconds = DEFAULT_DELETE_TIMEOUT;
	request.requestMethod = @"DELETE";
//	request.postFormat = ASIURLEncodedPostFormat; // ASIRawPostFormat;
	[request setDelegate:self];
	[request setDownloadProgressDelegate:self];
	[request setUploadProgressDelegate:self];
	[request setNumberOfTimesToRetryOnTimeout:2];
	[request setShouldAttemptPersistentConnection:NO];

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
	return [[BeeHTTPRequestQueue sharedInstance] requesting:url];
}

- (BOOL)requesting:(NSString *)url
{
	for ( BeeHTTPRequest * request in _requests )
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
	return [[BeeHTTPRequestQueue sharedInstance] requesting:url byResponder:responder];
}

- (BOOL)requesting:(NSString *)url byResponder:(id)responder
{
	for ( BeeHTTPRequest * request in _requests )
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
	return [[BeeHTTPRequestQueue sharedInstance] requests:url];
}

- (NSArray *)requests:(NSString *)url
{
	NSMutableArray * array = [NSMutableArray array];
	
	for ( BeeHTTPRequest * request in _requests )
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
	return [[BeeHTTPRequestQueue sharedInstance] requests:url byResponder:responder];
}

- (NSArray *)requests:(NSString *)url byResponder:(id)responder
{
	NSMutableArray * array = [NSMutableArray array];

	for ( BeeHTTPRequest * request in _requests )
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

+ (void)cancelRequest:(BeeHTTPRequest *)request
{
	[[BeeHTTPRequestQueue sharedInstance] cancelRequest:request];
}

- (void)cancelRequest:(BeeHTTPRequest *)request
{
	[NSObject cancelPreviousPerformRequestsWithTarget:request selector:@selector(startAsynchronous) object:nil];
	
	if ( [_requests containsObject:request] )
	{
		if ( request.created || request.sending || request.recving )
		{
			[request changeState:BeeHTTPRequest.STATE_CANCELLED];
		}

		[request clearDelegatesAndCancel];
		[request removeAllResponders];

		[_requests removeObject:request];
	}
}

+ (void)cancelRequestByResponder:(id)responder
{
	[[BeeHTTPRequestQueue sharedInstance] cancelRequestByResponder:responder];
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
		
		for ( BeeHTTPRequest * request in _requests )
		{
			if ( [request hasResponder:responder] /* request.responder == responder */ )
			{
				[tempArray addObject:request];				
			}			
		}
		
		for ( BeeHTTPRequest * request in tempArray )
		{
			[self cancelRequest:request];
		}
	}
}

+ (void)cancelAllRequests
{
	[[BeeHTTPRequestQueue sharedInstance] cancelAllRequests];
}

- (void)cancelAllRequests
{
	NSMutableArray * allRequests = [NSMutableArray arrayWithArray:_requests];
	
	for ( BeeHTTPRequest * request in allRequests )
	{
		[self cancelRequest:request];
	}
}

+ (void)blockURL:(NSString *)url
{
	[[BeeHTTPRequestQueue sharedInstance] blockURL:url];
}

- (void)blockURL:(NSString *)url
{
	[_blackList setObject:[NSDate date] forKey:url];
}

+ (void)unblockURL:(NSString *)url
{
	[[BeeHTTPRequestQueue sharedInstance] unblockURL:url];
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
	if ( NO == [request isKindOfClass:[BeeHTTPRequest class]] )
		return;

	BeeHTTPRequest * networkRequest = (BeeHTTPRequest *)request;
	[networkRequest changeState:BeeHTTPRequest.STATE_SENDING];

	_bytesUpload += request.postLength;
	
	if ( self.whenUpdate )
	{
		self.whenUpdate( networkRequest );
	}

	INFO( @"\t\tHTTP %@ %@\n%@", [request requestMethod], [request.url absoluteString], [[request postBody] asNSString] );
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
	if ( NO == [request isKindOfClass:[BeeHTTPRequest class]] )
		return;

	BeeHTTPRequest * networkRequest = (BeeHTTPRequest *)request;
	[networkRequest changeState:BeeHTTPRequest.STATE_RECVING];
	
	if ( self.whenUpdate )
	{
		self.whenUpdate( networkRequest );
	}
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	_bytesDownload += [[request rawResponseData] length];
	
	if ( NO == [request isKindOfClass:[BeeHTTPRequest class]] )
		return;

	BeeHTTPRequest * networkRequest = (BeeHTTPRequest *)request;
	
	if ( [request.requestMethod isEqualToString:@"GET"] )
	{
		if ( request.responseStatusCode >= 400 && request.responseStatusCode < 500 )
		{
			[self blockURL:[request.url absoluteString]];
		}
	}

	if ( 200 == request.responseStatusCode )
	{
		INFO( @"HTTP %d(%@)\n%@\n", request.responseStatusCode, request.responseStatusMessage, [request.url absoluteString], request.responseString );

		[networkRequest changeState:BeeHTTPRequest.STATE_SUCCEED];
	}
	else
	{
		ERROR( @"HTTP %d(%@)\n%@\n", request.responseStatusCode, request.responseStatusMessage, [request.url absoluteString], request.responseString );

		[networkRequest changeState:BeeHTTPRequest.STATE_FAILED];
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
	if ( NO == [request isKindOfClass:[BeeHTTPRequest class]] )
		return;

	BeeHTTPRequest * networkRequest = (BeeHTTPRequest *)request;

	networkRequest.errorCode = -1;
	[networkRequest changeState:BeeHTTPRequest.STATE_FAILED];
	
	[networkRequest clearDelegatesAndCancel];	
	[networkRequest removeAllResponders];	
	
	[_requests removeObject:networkRequest];
	
	if ( self.whenUpdate )
	{
		self.whenUpdate( networkRequest );
	}
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
	if ( NO == [request isKindOfClass:[BeeHTTPRequest class]] )
		return;
	
	BeeHTTPRequest * networkRequest = (BeeHTTPRequest *)request;
	[networkRequest changeState:BeeHTTPRequest.STATE_REDIRECTED];
}

- (void)requestRedirected:(ASIHTTPRequest *)request
{
	_bytesDownload += [[request rawResponseData] length];
	
	if ( NO == [request isKindOfClass:[BeeHTTPRequest class]] )
		return;

	BeeHTTPRequest * networkRequest = (BeeHTTPRequest *)request;
	
	INFO( @"HTTP %d(%@)\n%@",
		 request.responseStatusCode,
		 request.responseStatusMessage,
		 [request.url absoluteString] );

	if ( [request.requestMethod isEqualToString:@"GET"] )
	{
		if ( request.responseStatusCode >= 400 && request.responseStatusCode < 500 )
		{
			[self blockURL:[request.url absoluteString]];
		}
	}
	
	[networkRequest changeState:BeeHTTPRequest.STATE_SUCCEED];
	
	[networkRequest clearDelegatesAndCancel];
	[networkRequest removeAllResponders];
	
	[_requests removeObject:networkRequest];
	
	if ( self.whenUpdate )
	{
		self.whenUpdate( networkRequest );
	}
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
	if ( NO == [request isKindOfClass:[BeeHTTPRequest class]] )
		return;
	
	BeeHTTPRequest * networkRequest = (BeeHTTPRequest *)request;
	[networkRequest updateRecvProgress];
}

// Called when the request sends some data
// The first 32KB (128KB on older platforms) of data sent is not included in this amount because of limitations with the CFNetwork API
// bytes may be less than zero if a request needs to remove upload progress (probably because the request needs to run again)
- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
	if ( NO == [request isKindOfClass:[BeeHTTPRequest class]] )
		return;
	
	BeeHTTPRequest * networkRequest = (BeeHTTPRequest *)request;
	[networkRequest updateSendProgress];
}

// Called when a request needs to change the length of the content to download
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
	if ( NO == [request isKindOfClass:[BeeHTTPRequest class]] )
		return;
	
	BeeHTTPRequest * networkRequest = (BeeHTTPRequest *)request;
	[networkRequest updateRecvProgress];
}

// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength
{
	if ( NO == [request isKindOfClass:[BeeHTTPRequest class]] )
		return;
	
	BeeHTTPRequest * networkRequest = (BeeHTTPRequest *)request;
	[networkRequest updateSendProgress];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeHTTPRequestQueue )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

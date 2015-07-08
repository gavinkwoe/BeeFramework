//
//  UADHTTPRequestQueue.m
//  BabyunCore
//
//  Created by venking on 15/7/6.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "UADHTTPRequestQueue.h"
#import "Bee_HTTPRequest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( BeePackage_HTTP, UADHTTPRequestQueue, uadRequestQueue );

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

@interface UADHTTPRequestQueue()
{
    BOOL						_merge;
    BOOL						_online;
    
    BOOL						_blackListEnable;
    NSTimeInterval				_blackListTimeout;
    NSMutableDictionary *		_blackList;
    
    NSLock * m_uploadLock;
    NSUInteger					_bytesUpload;
    NSLock * m_downLock;
    NSUInteger					_bytesDownload;
    
    NSTimeInterval				_delay;
    NSMutableArray *			_requests;
    
    UADHTTPRequestQueueBlock	_whenCreate;
    UADHTTPRequestQueueBlock	_whenUpdate;
    
    NSCondition * m_lock;
    NSUInteger m_numberOfQueues;
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

@implementation UADHTTPRequestQueue

DEF_SINGLETON( UADHTTPRequestQueue )

static NSUInteger MAX_NUMBER_OF_QUEUE = 10;

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
    return ([[UADHTTPRequestQueue sharedInstance].requests count] > 0) ? YES : NO;
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
        _delay = 0.0f;
        _merge = YES;
        _online = YES;
        _requests = [[NSMutableArray alloc] init];
        
        _blackListEnable = NO;
        _blackListTimeout = DEFAULT_BLACKLIST_TIMEOUT;
        _blackList = [[NSMutableDictionary alloc] init];
        
        m_lock = [[NSCondition alloc] init];
        
        m_uploadLock = [[NSLock alloc] init];
        m_downLock = [[NSLock alloc] init];
    }
    
    return self;
}

+ (void) setMaxNumberOfQueue:(NSUInteger)number
{
    MAX_NUMBER_OF_QUEUE = number;
}

+ (NSUInteger) MAX_NUMBER_OF_QUEUE
{
    return MAX_NUMBER_OF_QUEUE;
}

- (NSArray *)getRequests
{
    [m_lock lock];
    NSArray * queue = [_requests copy];
    [m_lock unlock];
    return queue;
}

- (NSUInteger) addObject:(id)object
{
    [m_lock lock];
    if (_requests.count > m_numberOfQueues)
    {
        [m_lock wait];
    }
    
    [_requests addObject:object];
    NSUInteger count = _requests.count;
    [m_lock unlock];
    return count;
}

- (void) deleteObject:(id)object
{
    [m_lock lock];
    if (nil != object && [_requests containsObject:object])
    {
        [_requests removeObject:object];
    }
    [m_lock signal];
    [m_lock unlock];
}

- (void) removeAllObject
{
    [m_lock lock];
    [_requests removeAllObjects];
    [m_lock unlock];
}

- (NSUInteger) getRequestCount
{
    [m_lock lock];
    NSUInteger count = _requests.count;
    [m_lock unlock];
    return count;
}

- (BeeMessage *)objectAtIndex:(NSInteger)index
{
    [m_lock lock];
    BeeMessage * msg = [_requests safeObjectAtIndex:index];
    [m_lock unlock];
    
    return msg;
}

- (NSUInteger)addUploadBytes:(NSUInteger)bytes
{
    NSUInteger uploadByte = 0;
    [m_uploadLock lock];
    _bytesUpload += bytes;
    uploadByte = _bytesUpload;
    [m_uploadLock unlock];
    return uploadByte;
}

- (NSUInteger)addDownloadBytes:(NSUInteger)bytes
{
    NSUInteger uploadByte = 0;
    [m_downLock lock];
    _bytesDownload += bytes;
    uploadByte = _bytesDownload;
    [m_downLock unlock];
    return uploadByte;
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
    
    [self removeAllObject];// [_requests removeAllObjects];
    
    [_blackList removeAllObjects];
    
    self.whenCreate = nil;
    self.whenUpdate = nil;
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

- (BeeHTTPRequest *)createRequestWithURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter datas:(NSDictionary *)datas userInfo:(NSDictionary *)userInfo postFormat:(ASIPostFormat)format sync:(BOOL)sync
{
    BeeHTTPRequest * request = nil;
    
    NSURL * absoluteURL = [NSURL URLWithString:url];
    
    if ( NO == _online || [self checkResourceBroken:url] )
    {
        request = [[BeeEmptyRequest alloc] initWithURL:absoluteURL];
    }
    else
    {
        request = [[BeeHTTPRequest alloc] initWithURL:absoluteURL];
    }
    
    
    request.requestMethod = method;
    if (NSOrderedSame == [@"GET" compare:method])
    {
        request.timeOutSeconds = DEFAULT_GET_TIMEOUT;
    }
    else if (NSOrderedSame == [@"POST" compare:method])
    {
        request.timeOutSeconds = DEFAULT_POST_TIMEOUT;
    }
    
    else if (NSOrderedSame == [@"PUT" compare:method])
    {
        request.timeOutSeconds = DEFAULT_PUT_TIMEOUT;
    }
    
    if (format != ASIRawPostFormat)
    {
        request.postFormat = format;
    }
    request.postBody = nil;
    [request setDelegate:self];
    [request setDownloadProgressDelegate:self];
    [request setUploadProgressDelegate:self];
    [request setShouldAttemptPersistentConnection:NO];
    
    [request setNumberOfTimesToRetryOnTimeout:2];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:NO];
#endif	// #if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    
    for (NSString * dataKey in datas.allKeys)
    {
        [request setData:[datas objectForKey:dataKey] withFileName:nil andContentType:@"application/octet-stream" forKey:dataKey];
    }
    
    for (NSString * paramKey in parameter.allKeys)
    {
        [request setPostValue:[parameter objectForKey:paramKey] forKey:paramKey];
    }
    
    request.userInfo = [userInfo mutableCopy];
    
    [request setThreadPriority:0.1];
    [request setQueuePriority:NSOperationQueuePriorityLow];
    
    [self addObject:request];// [_requests addObject:request];
    
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
    
    return request;
}

+ (BeeHTTPRequest *)GET:(NSString *)url
{
    return [[UADHTTPRequestQueue sharedInstance] GET:url sync:NO];
}

- (BeeHTTPRequest *)GET:(NSString *)url sync:(BOOL)sync
{
    if ( NO == sync && _merge )
    {
        NSArray * requests = [self getRequests];
        for ( BeeHTTPRequest * req in requests )
        {
            if ( [req.url.absoluteString isEqualToString:url] )
            {
                return req;
            }
        }
    }
    
    return [self createRequestWithURL:url method:@"GET" parameter:nil datas:nil userInfo:nil postFormat:ASIRawPostFormat sync:sync];
}

+ (BeeHTTPRequest *)POST:(NSString *)url
{
    return [[UADHTTPRequestQueue sharedInstance] POST:url sync:NO];
}

- (BeeHTTPRequest *)POST:(NSString *)url sync:(BOOL)sync
{
    return [self createRequestWithURL:url method:@"GET" parameter:nil datas:nil userInfo:nil postFormat:ASIRawPostFormat sync:sync];
}

+ (BeeHTTPRequest *)POST:(NSString *)url parameter:(NSDictionary *)parameter datas:(NSDictionary *)datas userInfo:(NSDictionary *)userInfo postFormat:(ASIPostFormat)format
{
    return [[UADHTTPRequestQueue sharedInstance] POST:url parameter:parameter datas:datas userInfo:userInfo postFormat:format sync:NO];
}

- (BeeHTTPRequest *)POST:(NSString *)url parameter:(NSDictionary *)parameter datas:(NSDictionary *)datas userInfo:(NSDictionary *)userInfo postFormat:(ASIPostFormat)format sync:(BOOL)sync
{
    return [self createRequestWithURL:url method:@"POST" parameter:parameter datas:datas userInfo:userInfo postFormat:format sync:sync];
}

+ (BeeHTTPRequest *)PUT:(NSString *)url
{
    return [[UADHTTPRequestQueue sharedInstance] PUT:url sync:NO];
}

- (BeeHTTPRequest *)PUT:(NSString *)url sync:(BOOL)sync
{
    return [self createRequestWithURL:url method:@"PUT" parameter:nil datas:nil userInfo:nil postFormat:ASIRawPostFormat sync:sync];
}

+ (BeeHTTPRequest *)DELETE:(NSString *)url
{
    return [[UADHTTPRequestQueue sharedInstance] DELETE:url sync:NO];
}

- (BeeHTTPRequest *)DELETE:(NSString *)url sync:(BOOL)sync
{
    return [self createRequestWithURL:url method:@"DELETE" parameter:nil datas:nil userInfo:nil postFormat:ASIRawPostFormat sync:sync];
}

+ (BOOL)requesting:(NSString *)url
{
    return [[UADHTTPRequestQueue sharedInstance] requesting:url];
}

- (BOOL)requesting:(NSString *)url
{
    NSArray * requests = [self getRequests];
    for ( BeeHTTPRequest * request in requests )
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
    return [[UADHTTPRequestQueue sharedInstance] requesting:url byResponder:responder];
}

- (BOOL)requesting:(NSString *)url byResponder:(id)responder
{
    NSArray * requests = [self getRequests];
    for ( BeeHTTPRequest * request in requests )
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
    return [[UADHTTPRequestQueue sharedInstance] requests:url];
}

- (NSArray *)requests:(NSString *)url
{
    NSMutableArray * array = [NSMutableArray array];
    
    NSArray * requests = [self getRequests];
    for ( BeeHTTPRequest * request in requests )
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
    return [[UADHTTPRequestQueue sharedInstance] requests:url byResponder:responder];
}

- (NSArray *)requests:(NSString *)url byResponder:(id)responder
{
    NSMutableArray * array = [NSMutableArray array];
    
    NSArray * requests = [self getRequests];
    for ( BeeHTTPRequest * request in requests )
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
    [[UADHTTPRequestQueue sharedInstance] cancelRequest:request];
}

- (void)cancelRequest:(BeeHTTPRequest *)request
{
    [NSObject cancelPreviousPerformRequestsWithTarget:request selector:@selector(startAsynchronous) object:nil];
    
    NSArray * requests = [self getRequests];
    if ( [requests containsObject:request] )
    {
        if ( request.created || request.sending || request.recving )
        {
            [request changeState:BeeHTTPRequest.STATE_CANCELLED];
        }
        
        [request clearDelegatesAndCancel];
        [request removeAllResponders];
        
        [self deleteObject:request];
    }
}

+ (void)cancelRequestByResponder:(id)responder
{
    [[UADHTTPRequestQueue sharedInstance] cancelRequestByResponder:responder];
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
        
        NSArray * requests = [self getRequests];
        for ( BeeHTTPRequest * request in requests )
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
    [[UADHTTPRequestQueue sharedInstance] cancelAllRequests];
}

- (void)cancelAllRequests
{
    NSArray * requests = [self getRequests];
    NSMutableArray * allRequests = [NSMutableArray arrayWithArray:requests];
    
    for ( BeeHTTPRequest * request in allRequests )
    {
        [self cancelRequest:request];
    }
}

+ (void)blockURL:(NSString *)url
{
    [[UADHTTPRequestQueue sharedInstance] blockURL:url];
}

- (void)blockURL:(NSString *)url
{
    [_blackList setObject:[NSDate date] forKey:url];
}

+ (void)unblockURL:(NSString *)url
{
    [[UADHTTPRequestQueue sharedInstance] unblockURL:url];
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
    return [self getRequests];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestStarted:(ASIHTTPRequest *)request
{
    if ( NO == [request isKindOfClass:[BeeHTTPRequest class]] )
        return;
    
    BeeHTTPRequest * networkRequest = (BeeHTTPRequest *)request;
    [networkRequest changeState:BeeHTTPRequest.STATE_SENDING];
    
    [self addUploadBytes:request.postLength];
    
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
    [self addDownloadBytes:[[request rawResponseData] length]];
    
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
    
    [self deleteObject:networkRequest]; // [_requests removeObject:networkRequest];
    
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
    
    [self deleteObject:networkRequest]; // [_requests removeObject:networkRequest];
    
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
    [self addDownloadBytes:[[request rawResponseData] length]];
    
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
    
    [self deleteObject:networkRequest]; // [_requests removeObject:networkRequest];
    
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

TEST_CASE( UADHTTPRequestQueue )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

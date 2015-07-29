#import "UADHTTPRequest.h"

@interface UADHTTPRequest()
{
    NSLock * m_queueLock;
    ASINetworkQueue * m_queues;
    
    NSUInteger m_numberOfBlocks;
    
    NSLock * m_downLock;
    CGFloat m_bytesDownload;
    NSLock * m_upLock;
    CGFloat m_bytesUpload;
}
@end

@implementation UADHTTPRequest

- (id) initWithNumberOfBlocks:(NSUInteger)block numberOfThread:(NSUInteger)thread
{
    if (self = [super init])
    {
        m_queueLock = [[NSLock alloc] init];
        m_queues = [[ASINetworkQueue alloc] init];
        [m_queues setShouldCancelAllRequestsOnFailure:NO];
        [m_queues setMaxConcurrentOperationCount:thread];
        
        m_downLock = [[NSLock alloc] init];
        m_upLock = [[NSLock alloc] init];
        
        m_numberOfBlocks = block;
        
        self.preload = NO;
    }
    return self;
}

- (void) setDownloadProgress:(CGFloat)progress
{
    [m_downLock lock];
    CGFloat totalProgress = m_numberOfBlocks ? (CGFloat) progress / m_numberOfBlocks : 0.0f;
    m_bytesDownload = totalProgress;
    [m_downLock unlock];
}

- (CGFloat) getDownloadProgress
{
    [m_downLock lock];
    CGFloat progress = m_bytesDownload;
    [m_downLock unlock];
    return progress;
}

- (void) setUploadProgress:(CGFloat)progress
{
    [m_upLock lock];
    CGFloat totalProgress = m_numberOfBlocks ? (CGFloat) progress / m_numberOfBlocks : 0.0f;
    m_bytesUpload = totalProgress;
    [m_upLock unlock];
}

- (CGFloat) getUploadProgress
{
    [m_downLock lock];
    CGFloat progress = m_bytesUpload;
    [m_downLock unlock];
    return progress;
}

- (id) init
{
    if (self = [super init])
    {
        m_downLock = [[NSLock alloc] init];
        m_upLock = [[NSLock alloc] init];
        m_numberOfBlocks = 1;
        self.preload = YES;
    }
    return self;
}

- (ASIHTTPRequest *) postHTTPWithURL:(NSString *)url parameter:(NSDictionary *)parameter datas:(NSDictionary *)datas userInfo:(NSDictionary *)userInfo postFormat:(ASIPostFormat)format
{
    if (!url)
    {
        return nil;
    }
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    request.requestMethod = @"POST";
    [request setTimeOutSeconds:60];
    [request setShouldContinueWhenAppEntersBackground:YES];
    request.showAccurateProgress = YES; // 精确进度条
    request.postFormat = format;
    
    request.userInfo = userInfo;
    
    for (NSString * dataKey in datas.allKeys)
    {
        [request setData:[datas objectForKey:dataKey] withFileName:nil andContentType:@"application/octet-stream" forKey:dataKey];
    }
    
    for (NSString * paramKey in parameter.allKeys)
    {
        [request setPostValue:[parameter objectForKey:paramKey] forKey:paramKey];
    }
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidReceiveDataSelector:@selector(requestReceiveData:)];
    
    request.uploadProgressDelegate = self;
    request.downloadProgressDelegate = self;
    
    return request;
}

+ (ASIHTTPRequest *) postHTTPWithURL:(NSString *)url parameter:(NSDictionary *)parameter datas:(NSDictionary *)datas userInfo:(NSDictionary *)userInfo postFormat:(ASIPostFormat)format
{
    return [[[UADHTTPRequest alloc] init] postHTTPWithURL:url
                                                parameter:parameter
                                                    datas:datas
                                                 userInfo:userInfo
                                               postFormat:format];
}

- (void) addRequest:(ASIHTTPRequest *)theRequest
{
    [m_queueLock lock];
    [m_queues addOperation:theRequest];
    [m_queueLock unlock];
}

- (void) runQueues
{
    [m_queues go];
}

- (void) responseRequest:(ASIHTTPRequest *)theRequest object:(UADHTTPRequest *)object
{
    INFO(@"<%@, %p>", [self class], self);
}

- (UADHTTPRequest *) changeRequest:(ASIHTTPRequest *)theRequest status:(UAD_HTTPRequestStatus)status
{
    _status = status;
    INFO( @"HTTP [%@] %d(%@)\n%@\n", theRequest.userInfo, theRequest.responseStatusCode, theRequest.responseStatusMessage, [theRequest.url absoluteString], theRequest.responseString );
    if ( self.whenUpdate )
    {
        self.whenUpdate(theRequest);
    }
    
    /*if ( [self.delegate respondsToSelector:@selector(responseRequest:object:)] )
    {
        [self.delegate performSelector:@selector(responseRequest:object:) withObject:theRequest withObject:self];
    }
     */
    
    return self;
}

+ (UADHTTPRequest *) changeRequest:(ASIHTTPRequest *)theRequest status:(UAD_HTTPRequestStatus)status
{
    return [[[UADHTTPRequest alloc] init] changeRequest:theRequest status:status];
}

- (UADHTTPRequest *) actionRequest:(ASIHTTPRequest *)theRequest delay:(NSUInteger)delay
{
    UADHTTPRequest * http = [self changeRequest:theRequest status:UADHTTP_SENDING];
    
    if ( delay )
    {
        [theRequest performSelector:@selector(startAsynchronous)
                         withObject:nil
                         afterDelay:delay];
    }
    else
    {
        [theRequest startAsynchronous];
    }
    
    return http;
}

+ (UADHTTPRequest *) actionRequest:(ASIHTTPRequest *)theRequest delay:(NSUInteger)delay
{
    return [[[UADHTTPRequest alloc] init] actionRequest:theRequest delay:delay];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    INFO(@"requestStarted");
}

- (void) requestFinished:(ASIHTTPRequest *)theRequest
{
    if ( 200 == theRequest.responseStatusCode )
    {
        [self changeRequest:theRequest status:UADHTTP_SUCCEED];
    }
    else
    {
        [self changeRequest:theRequest status:UADHTTP_FAILED];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)theRequest
{
    [self changeRequest:theRequest status:UADHTTP_FAILED];
}

- (void) requestReceiveData:(ASIHTTPRequest *)theRequest
{
    [self changeRequest:theRequest status:UADHTTP_RECEIVE];
}

- (void) uploadProgress:(ASIHTTPRequest *)theRequest
{
    [self changeRequest:theRequest status:UADHTTP_RECEIVE];
}

#pragma mark - 精确进度 回调
// Called when the request receives some data - bytes is the length of that data
- (void)request:(ASIHTTPRequest *)theRequest didReceiveBytes:(long long)bytes
{
    INFO( @"DidReceive : %d", bytes );
    INFO( @"  HTTP %d(%@)", theRequest.responseStatusCode, theRequest.responseStatusMessage );
    INFO( @"  URL %@(%@)", [theRequest.url absoluteString], theRequest.responseString );
    INFO( @"  DOWN %d(%d)", theRequest.totalBytesRead, theRequest.contentLength );
    
    CGFloat fingleProgress = theRequest.contentLength ? (CGFloat)(theRequest.totalBytesRead)/(theRequest.contentLength) : 0.0f;
    [self setDownloadProgress:fingleProgress];
    
    if (self.downloadProcess)
    {
        self.downloadProcess(theRequest);
    }
}

// Called when the request sends some data
// The first 32KB (128KB on older platforms) of data sent is not included in this amount because of limitations with the CFNetwork API
// bytes may be less than zero if a request needs to remove upload progress (probably because the request needs to run again)
- (void)request:(ASIHTTPRequest *)theRequest didSendBytes:(long long)bytes
{
    INFO( @"DidSend : %d", bytes );
    INFO( @"  HTTP %d(%@)", theRequest.responseStatusCode, theRequest.responseStatusMessage );
    INFO( @"  URL %@(%@)", [theRequest.url absoluteString], theRequest.responseString );
    INFO( @"  UPLOAD %d(%d)", theRequest.totalBytesSent, theRequest.postLength );
    
    CGFloat fingleProgress = theRequest.postLength ? (CGFloat)(theRequest.totalBytesSent)/(theRequest.postLength) : 0.0f;
    [self setUploadProgress:fingleProgress];
    
    if (self.uploadProcess)
    {
        self.uploadProcess(theRequest);
    }
}

// Called when a request needs to change the length of the content to download
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
}

// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength
{
}

@end



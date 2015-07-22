//
//  UADHTTPManage.m
//  BabyunCore
//
//  Created by venking on 15/7/3.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "UADHTTPManage.h"
#import "UADHTTPRequest.h"
#import "Bee_Queue.h"
#import "UADHTTPCache.h"
#import "UADHTTPRequestQueue.h"

@implementation UADUserInfo

- (id) initWithModle:(BeeQueueModel *)model numberOfBlocks:(NSInteger)number indexOfBlock:(NSInteger)index
{
    if (self = [super init])
    {
        _model = model;
        _numberOfBlocks = number;
        _indexOfBlocks = index;
        _block = model.data;
        _retryCount = model.maxCountOfOperator;
        if (QUEUE_MODEL_UPLOAD_ALL != model.method)
        {
            _sizeOfBlocks = 0;
        }
        else
        {
            _sizeOfBlocks = model.data.length + 1;
        }
    }
    return self;
}

+ (NSString *) UAD_USER_INFO
{
    return @"UAD_USER_INFO";
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@: %p,\"model = %@ , number = %lu index = %lu\">", [self class], self, self.model, (unsigned long)self.numberOfBlocks, (unsigned long)self.indexOfBlocks];
}

@end

@implementation UADHTTPManageOption

- (id) initWithParameter:(NSMutableDictionary *)parameter userInfo:(NSMutableDictionary *)userInfo
{
    if (self = [super init])
    {
        if (nil != parameter)
        {
            _parameter = parameter;
        }
        else
        {
            _parameter = [[NSMutableDictionary alloc] init];
        }
        
        if (nil != userInfo)
        {
            _userInfo = userInfo;
        }
        else
        {
            _userInfo = [[NSMutableDictionary alloc] init];
        }
        
        _finished = NO;
    }
    return self;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@: %p,\"parameter = %@ , userInfo = %@ finished = %d\">", [self class], self, self.parameter, self.userInfo, self.finished];
}

@end

@interface UADHTTPManage()
{
    NSString * MODEL_QUEUE_NAME;
    NSOperationQueue * m_requestQueues;
    
    NSUInteger UADLOAD_MAX_SIZE;
    NSUInteger UADLOAD_MIN_SIZE;
}
@end

@implementation UADHTTPManage
@synthesize MODEL_QUEUE_NAME = _MODEL_QUEUE_NAME;

- (id)initWithQueue:(NSString *)queue numberOfthread:(NSUInteger)thread
{
    if (self = [super init])
    {
        self.MODEL_QUEUE_NAME = queue;
        m_requestQueues = [[NSOperationQueue alloc] init];
        [m_requestQueues setMaxConcurrentOperationCount:thread];
        UADLOAD_MAX_SIZE = 0;
        UADLOAD_MIN_SIZE = 1024 * 100;
    }
    return self;
}

- (void) setMaxSizeOfBlock:(NSUInteger)size
{
    if (UADLOAD_MIN_SIZE != 0 && UADLOAD_MIN_SIZE > size)
    {
        return ;
    }
    UADLOAD_MAX_SIZE = size;
}

- (void) setMinSizeOfBlock:(NSUInteger)size
{
    if (102400 < size)
    {
        if (UADLOAD_MAX_SIZE != 0 && UADLOAD_MAX_SIZE < size)
        {
            return ;
        }
        UADLOAD_MIN_SIZE = size;
    }
}

- (void) runLoop
{
    while (YES)
    {
        if (nil == MODEL_QUEUE_NAME)
        {
            MODEL_QUEUE_NAME = @"UPYun.Upload.Data.Queue";
        }
        __weak BeeQueueModel * model = [BeeQueue getFirstDataByQueue:MODEL_QUEUE_NAME];
        if (nil == model)
        {
            continue;
        }
        
        if (nil != self.fillModel)
        {
            if(YES != self.fillModel(model))
            {
                continue;
            }
        }
        
        NSBlockOperation * thread = [NSBlockOperation blockOperationWithBlock:^
        {
            if (QUEUE_MODEL_UPLOAD == model.action)
            {
                [self preupload:model];
            }
            else if (QUEUE_MODEL_DOWNLOAD == model.action)
            {
                [self downloadModel:model];
            }
        }];
        
        [m_requestQueues addOperation:thread];
    }
}

- (void) preupload:(BeeQueueModel *)model
{
    UADHTTPManageOption * option = [[UADHTTPManageOption alloc] initWithParameter:nil
                                                                         userInfo:nil];
    UADUserInfo * uadUserInfo = [[UADUserInfo alloc] initWithModle:model
                                                 numberOfBlocks:-1
                                                   indexOfBlock:-1];
    [option.userInfo setObject:uadUserInfo forKey:[UADUserInfo UAD_USER_INFO]];
    
    if (self.optionDictionary)
    {
        option = self.optionDictionary(option);
    }
    
    if (nil != option)
    {
        [self singleUploadWithOption:option];
    }
}

- (void)uploadWithOption:(UADHTTPManageOption *)option
{
    if (nil == option)
    {
        UADHTTP_ERROR(option);
        return ;
    }
    
    UADUserInfo * uadUserInfo = [option.userInfo objectForKey:[UADUserInfo UAD_USER_INFO]];
    if (nil == uadUserInfo)
    {
        return ;
    }
    
    NSData * datas = uadUserInfo.model.data;
    NSUInteger dataLength = datas.length;
    uadUserInfo.numberOfBlocks = (dataLength < uadUserInfo.sizeOfBlocks) ? 1 : (dataLength / uadUserInfo.sizeOfBlocks);
    NSUInteger lastBlocks = (uadUserInfo.numberOfBlocks -1);
    for (NSInteger index = 0; index < uadUserInfo.numberOfBlocks; ++index)
    {
        uadUserInfo.indexOfBlocks = index;

        NSInteger start = index * uadUserInfo.sizeOfBlocks;
        NSInteger length = (index != lastBlocks) ? uadUserInfo.sizeOfBlocks : dataLength - start;
        NSData * data = [datas subdataWithRange:NSMakeRange(start, length)];
        uadUserInfo.block = data;
        
        if (self.optionDictionary)
        {
            option = self.optionDictionary(option);
            [option.userInfo setObject:uadUserInfo forKey:[UADUserInfo UAD_USER_INFO]];
        }
        
        if (QUEUE_DATA_PAUSE == uadUserInfo.model.state)
        {
            [uadUserInfo.model pauseModel];
        }
        
        // [self singleUploadWithOption:option];
        [self multilUploadWithOption:option];
        
        // INFO(@"OOOOOOOOOOOOOOOOOOOOOO   %i ", index);
    }
}

- (void) singleUploadWithOption:(UADHTTPManageOption *)option
{
    UADUserInfo * uadUserInfo = [option.userInfo objectForKey:[UADUserInfo UAD_USER_INFO]];
    if (nil == uadUserInfo)
    {
        return ;
    }
    NSDictionary * uploadData = nil;
    ASIPostFormat format = ASIURLEncodedPostFormat;
    if (NO == option.finished && 0 <= uadUserInfo.numberOfBlocks)
    {
        format = ASIMultipartFormDataPostFormat;
        uploadData = @{@"file":uadUserInfo.block};
    }
    BeeHTTPRequest * request = [UADHTTPRequestQueue POST:uadUserInfo.model.url
                                               parameter:option.parameter
                                                   datas:uploadData
                                                userInfo:option.userInfo
                                              postFormat:format];
    
    @weakify(request);
    request.whenUpdate = ^
    {
        @normalize(request);
        if (QUEUE_DATA_PAUSE == uadUserInfo.model.state || QUEUE_DATA_REMOVE == uadUserInfo.model.state)
        {
            [UADHTTPRequestQueue cancelRequest:request];
        }
    };
    
    request.whenSucceed = ^
    {
        INFO(@"记录访问次数");
        @normalize(request);
        if (self.didSucceed)
        {
            UADHTTPManageOption * dataOption = nil;
            dataOption = self.didSucceed(request);
            [dataOption.userInfo setObject:uadUserInfo forKey:[UADUserInfo UAD_USER_INFO]];
            
            if (nil != dataOption)
            {
                if (dataOption.finished)
                {
                    INFO(@"All block was finished！File merge will be going");
                    
                    // [self singleUploadWithOption:dataOption];
                    [self multilUploadWithOption:dataOption];
                }
                else if (0 > uadUserInfo.numberOfBlocks && uadUserInfo.numberOfBlocks == uadUserInfo.indexOfBlocks)
                {
                    if (dataOption.finished)
                    {
                        INFO(@"FINISHED : [%@]", uadUserInfo.model.localPath);
                    }
                    else
                    {
                        INFO(@"Preconditioning is suceed! Blocks will be uploaded");
                        [self uploadWithOption:dataOption];
                    }
                }
                else
                {
                    [self saveModelCache:dataOption];
                    INFO(@"Block was uploaded already! {FILE : [%@], BLOCK : [%d]}", uadUserInfo.model.localPath, uadUserInfo.indexOfBlocks);
                }
                
                if (uadUserInfo.model.whenProgress)
                {
                    uadUserInfo.model.whenProgress(request.uploadPercent);
                }
            }
            else
            {
                INFO(@"FINISHED : [%@]", uadUserInfo.model.localPath);
            }
        }
        
    };
    
    request.whenFailed = ^
    {
        @normalize(request);
        INFO(@"FAILED:[%@]", request.responseString);
        
        UADHTTPManageOption * dataOption = nil;
        if (self.didFailed)
        {
            dataOption = self.didFailed(request);
        }
        if (nil != dataOption)
        {
            INFO(@"Try again ! {FILE : [%@], BLOCK : [%d]}", uadUserInfo.model.localPath, uadUserInfo.indexOfBlocks);
        }
        else
        {
            [UADHTTPRequestQueue cancelRequest:request];
        }
    };
    
    request.whenCancelled = ^
    {
        INFO(@"whenCancelled");
    };
}

- (void) multilUploadWithOption:(UADHTTPManageOption *)option
{
    NSBlockOperation * thread = [NSBlockOperation blockOperationWithBlock:^
                                 {
                                     [self singleUploadWithOption:option];
                                 }];
    
    [m_requestQueues addOperation:thread];
}

- (void) downloadModel:(BeeQueueModel *)model
{
}

- (BOOL) saveModelCache:(UADHTTPManageOption *)option
{
    UADUserInfo * userInfo = [option.userInfo objectForKey:[UADUserInfo UAD_USER_INFO]];
    
    UADHTTPCache * cache = [[UADHTTPCache alloc] initWithLocalPath:userInfo.model.localPath
                                                            server:userInfo.model.serverPath
                                                         blockSize:userInfo.numberOfBlocks];
    if (cache.LOAD())
    {
        NSString * newObj = [NSString stringWithFormat:@"%ld", (long)userInfo.indexOfBlocks];
        if (NO == [cache existWithObject:newObj])
        {
            [cache addObject:newObj];
            CGFloat progress = (0 != userInfo.numberOfBlocks) ? (CGFloat)([cache getObjectsCount] / userInfo.numberOfBlocks) : 1.0f;
            cache.progress = [NSNumber numberWithFloat:progress];
            cache.SAVE();
        }
    }
    
    return YES;
}

@end

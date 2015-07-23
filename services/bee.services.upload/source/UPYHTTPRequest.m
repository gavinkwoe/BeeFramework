//
//  UPYHTTPRequest.m
//  BabyunCore
//
//  Created by venking on 15/7/4.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "UPYHTTPRequest.h"
#import "UADHTTPManage.h"
#import "Bee_Queue.h"
#import "UADHTTPRequestQueue.h"

@interface UPYHTTPRequest()
{
    UADHTTPManage * m_httpManage;
}
@end

@implementation UPYHTTPRequest

DEF_SINGLETON(UPYHTTPRequest)

- (id) init
{
    if (self = [super init])
    {
        m_httpManage = [[UADHTTPManage alloc] initWithQueue:[UPYunUpload UPYUN_DATA_QUEUE]
                                             numberOfthread:[UPYunUpload MAX_THREAD_NUMBER]];
        [UPYunUpload setBlockSize:1024 * 100];
        [m_httpManage setMinSizeOfBlock:[UPYunUpload BLOCK_SIZE]];
    }
    
    return self;
}

+ (void) run
{
    [[UPYHTTPRequest sharedInstance] runRequest];
}

- (void) runRequest
{
    m_httpManage.fillModel = ^(BeeQueueModel * model)
    {
        if (0 == model.path.length)
        {
            model.path = [NSString stringWithFormat:@"/images/test/test_%@.txt", [[NSDate date] stringWithDateFormat:@"yyyyMMddhhmmss"]];
        }
        if (model && model.data)
        {
            // 数据已存在，不用读文件
        }
        else if (model && model.local)
        {
            NSFileManager * fileManager = [NSFileManager defaultManager];
            if ([fileManager isReadableFileAtPath:model.local])
            {
                model.data = [NSData dataWithContentsOfFile:model.local];
            }
            else
            {
                return NO;
            }
        }
        
        if (nil == model.server)
        {
            model.server = [NSString stringWithFormat:@"%@/%@/", [UPYunUpload API_SERVER], [UPYunUpload BUCKET]];
        }
        
        return YES;
    };
    
    m_httpManage.optionDictionary = ^(UADHTTPManageOption * option)
    {
        UADUserInfo * uadUserInfo = [option.userInfo objectForKey:[UADUserInfo UAD_USER_INFO]];
        // 预处理 参数
        if (0 > uadUserInfo.numberOfBlocks && 0 > uadUserInfo.indexOfBlocks && uadUserInfo.model)
        {
            if (QUEUE_MODEL_UPLOAD_ALL != uadUserInfo.model.method)
            {
                uadUserInfo.sizeOfBlocks = [UPYunUpload BLOCK_SIZE];
            }
            else
            {
                [UPYunUpload setBlockSize:uadUserInfo.sizeOfBlocks];
            }
            NSDictionary * group = [UPYunUpload parameterGroupWithData:uadUserInfo.model.data
                                                                  path:uadUserInfo.model.path];
            NSDictionary * parameter = [UPYunUpload requestParameterByParameterGroup:group
                                                                           condition:[UPYunUpload PASSCODE]];
            option.parameter = [parameter mutableCopy];
        }
        // 正式数据上传 参数
        else
        {
            // 上传 令牌 以及 秘钥 来自预处理
            option = [self setupOptionWithToken:[option.userInfo objectForKey:@"save_token"]
                                         secret:[option.userInfo objectForKey:@"token_secret"]
                                          index:uadUserInfo.indexOfBlocks
                                           data:uadUserInfo.block];
        }
        return option;
    };
    
    m_httpManage.didSucceed = ^(ASIHTTPRequest * theRequest)
    {
        UADHTTPManageOption * option = nil;
        UADUserInfo * uadUserInfo = [theRequest.userInfo objectForKey:[UADUserInfo UAD_USER_INFO]];
        NSDictionary * result = [theRequest.responseString objectFromJSONString];
        if (result)
        {
            // 从预处理中获取 令牌 以及 秘钥, 并保存在每个请求的用户信息中供上传正式数据使用
            UPYunResult * upyunResult = [[UPYunResult alloc] initWithDictionary:result];
            
            if (nil != upyunResult.saveToken)
            {
                NSUInteger finished = 0;
                for (NSInteger i = 0; i < upyunResult.blockNumber; ++i)
                {
                    if (1 == [upyunResult.blockState[i] integerValue])
                    {
                        ++finished;
                    }
                }
                
                CGFloat progress = (CGFloat)finished / upyunResult.blockNumber;
                [uadUserInfo.model setProgress:progress];
                if (uadUserInfo.model.whenUpdate)
                {
                    uadUserInfo.model.whenUpdate(progress);
                }
                
                INFO(@"%@ progress %f", uadUserInfo.model.local, progress);
                
                option = [self setupOptionWithToken:upyunResult.saveToken
                                             secret:upyunResult.tokenSecret
                                              index:0
                                               data:nil];
                if (1.0f == progress)
                {
                    option.finished = YES;
                }
                else
                {
                    option.finished = NO;
                }
            }
            else
            {
                option.finished = YES;
            }
        }
        
        return option;
    };
    
    m_httpManage.didFailed = ^(ASIHTTPRequest * theRequest)
    {
        UADUserInfo * uadUserInfo = [theRequest.userInfo objectForKey:[UADUserInfo UAD_USER_INFO]];
        
        INFO(@"文件 %@ 第 %i 块 上传失败[块大小%li]。 可重试 %i 次。 \n %@", uadUserInfo.model.local, uadUserInfo.indexOfBlocks, uadUserInfo.block.length, uadUserInfo.retryCount, theRequest.responseString);
        
        UADHTTPManageOption * option = nil;
        if (0 < uadUserInfo.retryCount)
        {
            --uadUserInfo.retryCount;
            option = [self setupOptionWithToken:[theRequest.userInfo objectForKey:@"save_token"]
                                         secret:[theRequest.userInfo objectForKey:@"token_secret"]
                                          index:uadUserInfo.indexOfBlocks
                                           data:uadUserInfo.block];
        }
        
        return option;
    };
    
    [m_httpManage runLoop];
}

- (UADHTTPManageOption *) setupOptionWithToken:(NSString *)token secret:(NSString *)secret index:(NSInteger)index data:(NSData *)data
{
    // 正式上传数据需要使用的 参数
    NSMutableDictionary * parameter = nil;
    NSMutableDictionary * group = [[NSMutableDictionary alloc]
                                   initWithDictionary:@{@"save_token":token,
                                                        @"expiration":EXPIRED_TIME}];
    if (nil != data)
    {
        [group setObject:@(index) forKey:@"block_index"];
        [group setObject:[data MD5HexDigest] forKey:@"block_hash"];
    }
    
    parameter = [[UPYunUpload requestParameterByParameterGroup:group
                                                     condition:secret] mutableCopy];
    NSDictionary * userInfo = @{@"save_token":token, @"token_secret":secret};
    
    UADHTTPManageOption * option = [[UADHTTPManageOption alloc] initWithParameter:parameter
                                                                         userInfo:[userInfo mutableCopy]];
    return option;
}

@end

//
//  FileUploadMessage.m
//  BabyunCore
//
//  Created by venking on 15/6/15.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "FileUploadMessage.h"

@implementation ParameterOption

- (id) initWithDictionary:(NSDictionary *)option
{
    if (self = [super init])
    {
        _model = [option objectForKey:@"BeeQueueModel"];
        _blockMessage = [option objectForKey:@"BlockBeeMessage"];
        _result = [option objectForKey:@"UPYunResult"];
    }
    return self;
}
@end

@interface FileUploadMessage()
{
#ifdef FILE_UPLOAD_MESSAGE_MULTI_THREAD
    NSOperationQueue * m_blockQueues; // 每个文件一个线程块
#endif
}
@end

@implementation FileUploadMessage

- (void) initParam
{
    [UPYunUpload setBlockSize:202500];
#ifdef FILE_UPLOAD_MESSAGE_MULTI_THREAD
    if (!m_blockQueues)
    {
        m_blockQueues = [[NSOperationQueue alloc] init];
        m_blockQueues.maxConcurrentOperationCount = [UPYunUpload MAX_THREAD_NUMBER];
    }
#endif
}

- (BeeQueueModel *) fillModel:(BeeQueueModel *)model
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
            return nil;
        }
    }
    if (QUEUE_MODEL_UPLOAD_ALL != model.method)
    {
        // 默认为 [UPYunUpload BLOCK_SIZE];
    }
    else
    {
        [UPYunUpload setBlockSize:(model.data.length + 1)];
    }
    
    if (nil == model.server)
    {
        model.server = [UPYunUpload API_SERVER];
    }
    
    if (nil == model.bucket)
    {
        model.bucket = [UPYunUpload BUCKET];
    }
    
    if (nil == model.passcode)
    {
        model.passcode = [UPYunUpload PASSCODE];
    }
    
    self.url = [NSString stringWithFormat:@"%@/%@", model.server, model.bucket];
    self.formAPI = model.passcode;
    
    return model;
}

- (void)routine
{
    BACKGROUND_BEGIN
    {
        [self initParam];
        
        while (YES)
        {
            __weak BeeQueueModel * model = nil;
            if (nil == (model = [BeeQueue getFirstDataByQueue:[UPYunUpload UPYUN_DATA_QUEUE]]))
            {
                sleep(1);
                continue;
            }

#ifdef FILE_UPLOAD_MESSAGE_MULTI_THREAD
            NSBlockOperation * file = [NSBlockOperation blockOperationWithBlock:^{
#endif
                if ([self fillModel:model])
                {
                    [self demonWithModel:model];
                }
#ifdef FILE_UPLOAD_MESSAGE_MULTI_THREAD
            }];
            [m_blockQueues addOperation:file];
#endif
        }
    }
    BACKGROUND_COMMIT
}

- (void) demonWithModel:(BeeQueueModel *)model
{
    BeeMessage * file = [BeeMessage message];
    @weakify(file);
    
    file.whenSending = [^
    {
        @normalize(file);
        NSDictionary * group = [UPYunUpload parameterGroupWithData:model.data path:model.path];
        NSDictionary * param = [UPYunUpload requestParameterByParameterGroup:group condition:self.formAPI];
        
        file.HTTP_POST(self.url)
        .HEADER(@"Content-Type", @"application/x-www-form-urlencoded")
        .PARAM(param);
    } copy];
    
    file.whenSucceed = [^
    {
        @normalize(file);
        NSDictionary * result = file.responseJSONDictionary;
        
        NSString * server = [NSString stringWithFormat:@"%@/%@", model.visit, model.path];
        UADHTTPCache * uploadCache = [[UADHTTPCache alloc] initWithKey:model.key
                                                                 local:model.local
                                                                server:server
                                                             sizeOfAll:model.data.length
                                                           sizeOfBlock:[UPYunUpload BLOCK_SIZE]];
        
        uploadCache.LOAD(); // 加载指定文件缓存
        
        if (result)
        {
            UPYunResult * resultInfo = [[UPYunResult alloc] initWithDictionary:result];
            // 上传块需要用的参数
            ParameterOption * option = [[ParameterOption alloc] init];
            option.model = model;
            option.result = resultInfo;
            option.cache = uploadCache;
            
            [self childBlock:option];
        }
    } copy];
    
    file.whenFailed = [^
    {
        @normalize(file);
        if (file.responseString)
        {
            [BeeQueue failedKey:model.key ofQueue:[UPYunUpload UPYUN_DATA_QUEUE]];
            ERROR(@"{NAME:%@,KEY:%@} 请求失败! [%@]", model.name, model.key, file.responseString);
        }
    } copy];
    
    file.whenCancelled = [^
    {
        INFO(@"");
    } copy];
    
    file.whenWaiting = [^
    {
        // 块上传完成，进行缓存记录
    } copy];
    
    [file send];
}

- (void) childBlock:(ParameterOption *)option
{
    NSArray * datas = [UPYunUpload subData:option.model.data];
    option.model.data = nil;
    
    if (option.result && datas.count != option.result.blockNumber)
    {
        ERROR(@"[ERROR]:{NAME:%@,KEY:%@} 应答数据块与实际不符!", option.model.name, option.model.key);
        return ;
    }
    
    // 分块数据上传
    for (NSInteger index = 0; index < datas.count;)
    {
        if (option.model && QUEUE_DATA_PAUSE == option.model.state)
        {
            [BeeQueue pauseKey:option.model.key ofQueue:[UPYunUpload UPYUN_DATA_QUEUE]];
            option.model = nil;
            break;
        }
        else if (option.model && QUEUE_DATA_REMOVE == option.model.state)
        {
            [BeeQueue removeKey:option.model.key ofQueue:[UPYunUpload UPYUN_DATA_QUEUE]];
            option.model = nil;
            break ;
        }
        
        if (1.0f == [option.cache.progress integerValue])
        {
            if (option.model.whenSucced)
            {
                NSString * server = [NSString stringWithFormat:@"%@/%@", option.model.visit, option.model.path];
                option.model.whenSucced(server);
            }
            break;
        }
        
        if (NSOrderedSame == [option.cache.key compare:option.model.key]
                && YES == [option.cache existWithObject:[NSString stringWithFormat:@"%ld", (long)index]])
        {
            ++index;
            continue;
        }
        
        NSData * data = datas[index];
        NSDictionary * group = @{@"save_token":option.result.saveToken,
                                 @"expiration":EXPIRED_TIME,
                                 @"block_index":@(index),
                                 @"block_hash":[data MD5HexDigest]};
        
        NSMutableDictionary * parameter = [[UPYunUpload requestParameterByParameterGroup:group condition:option.result.tokenSecret] mutableCopy];
        [parameter setObject:data forKey:@"file"];
        
        option.blockMessage = nil;
        NSDictionary * userInfo = @{@"group":group,
                                    @"parameter":parameter,
                                    @"option":option};
        
#ifdef FILE_UPLOAD_MESSAGE_MULTI_THREAD
        self.UPLOAD(userInfo, 0);
#else
        [self uploadBlock:userInfo count:0];
#endif
        
        ++index; // 控制索引
    }
}

- (UploadBlock)UPLOAD
{
    UploadBlock block = ^ void (NSDictionary * userInfo, NSInteger count){
        [self uploadBlock:userInfo count:count];
    };
    return [block copy];
}

- (void) uploadBlock:(NSDictionary *)userInfo count:(NSUInteger)count
{
    NSDictionary * dict = userInfo;
    
    NSMutableDictionary * parameter = [dict objectForKey:@"parameter"];
    NSDictionary * group = [dict objectForKey:@"group"];
    ParameterOption * option = [dict objectForKey:@"option"];
    NSData * data = [parameter objectForKey:@"file"];
    INFO(@"将要上传的数据信息. index:%@, expiration:%@, size:%li, thread:%@",
         [group objectForKey:@"block_index"],
         [group objectForKey:@"expiration"],
         data.length, [NSThread currentThread]);
    
    BeeMessage * block = [BeeMessage message];
    
    ++count;
    if (nil != data)
    {
        [parameter removeObjectForKey:@"file"];
        
        block.HTTP_POST(self.url)
        .HEADER(@"Content-Type", @"multipart/form-data")
        .FILE(@"file", data)
        .PARAM(parameter);
        
        [parameter setValue:data forKey:@"file"];
    }
    else
    {
        block.HTTP_POST(self.url)
        .HEADER(@"Content-Type", @"application/x-www-form-urlencoded")
        .PARAM(parameter);
    }
    
    @weakify(block);
    block.whenUpdate = ^{
        @normalize(block);
        // 当上传暂停时，需求正在上传的块
        if (QUEUE_DATA_PAUSE == option.model.state)
        {
            [block cancel];
            [BeeQueue pauseKey:option.model.key ofQueue:[UPYunUpload UPYUN_DATA_QUEUE]];
        }
        else if (QUEUE_DATA_REMOVE == option.model.state)
        {
            [block cancel];
            [BeeQueue removeKey:option.model.key ofQueue:[UPYunUpload UPYUN_DATA_QUEUE]];
        }
    };
    
    // 实时更新处理进度
    block.whenProgressed = ^
    {
    };
    
    // 处理成功
    block.whenSucceed = ^
    {
        @normalize(block);
        NSDictionary * result = block.responseJSONDictionary;
        UPYunResult * paramInfo = nil;
        
        if (nil != data)
        {
            paramInfo = [[UPYunResult alloc] initWithDictionary:result];
            NSUInteger finished = 0;
            for (NSInteger i = 0; i < paramInfo.blockNumber; ++i)
            {
                if (1 == [paramInfo.blockState[i] integerValue])
                {
                    ++finished;
                }
            }
            
            CGFloat progress = (CGFloat)finished / paramInfo.blockNumber;
            INFO(@"文件 %@ 上传进度 ：%f", option.model.local, progress);
            [option.model setProgress:progress];
            if (1.0f == progress)
            {
                [self fileMergeWithOption:option];
            }
            
            if (option.model.whenUpdate)
            {
                option.model.whenUpdate(progress);
            }
            
            option.cache.progress = @(progress);
            [option.cache addObject:[group objectForKey:@"block_index"]];
        }
        else
        {
            // 合并操作完成，整个文件上传完成。
            [BeeQueue successKey:option.model.key ofQueue:[UPYunUpload UPYUN_DATA_QUEUE]];
            INFO(@"SUCESS : %@", parameter);
            option.cache.progress = @(1.0f);
            [option.model setProgress:1];
            if (option.model.whenSucced)
            {
                NSString * server = [NSString stringWithFormat:@"%@/%@", option.model.visit, option.model.path];
                option.model.whenSucced(server);
            }
        }
        
        [option.cache saveCache];
    };
    
    // 处理失败
    block.whenFailed = ^
    {
        if ([UPYunUpload MAX_RETRY_NUMBER] > count)
        {
            @normalize(block);
            NSString * index = [group objectForKey:@"block_index"];
            if (nil == index)
            {
                index = @"合并";
            }
            else
            {
                index = [NSString stringWithFormat:@"第 %@ 块", index];
            }
            NSString * info = [NSString stringWithFormat:@"文件 %@ %@ 第 %lu 次 上传失败[块大小%li]。 \n %@", option.model.local, index, (unsigned long)count, (unsigned long)data.length, block.responseJSONDictionary];
            INFO(@"%@", info);
            [self uploadBlock:userInfo count:count];
            
            if (option.model.whenFailed)
            {
                // option.model.whenFailed(info);
            }
        }
        else
        {
            [BeeQueue failedKey:option.model.key ofQueue:[UPYunUpload UPYUN_DATA_QUEUE]];
            if (option.model.whenFailed)
            {
                NSString * info = [NSString stringWithFormat:@"[%@]上传失败", option.model.local];
                option.model.whenFailed(info);
            }
        }
    };
    
    [block send];
}

- (void) fileMergeWithOption:(ParameterOption *)option
{
    NSDictionary * group = @{@"save_token":option.result.saveToken,
                             @"expiration":EXPIRED_TIME};
    
    NSMutableDictionary * parameter = [[UPYunUpload requestParameterByParameterGroup:group condition:option.result.tokenSecret] mutableCopy];
    NSDictionary * userInfo = @{@"group":group,
                                @"parameter":parameter,
                                @"option":option};
    [self uploadBlock:userInfo count:0];
}

@end

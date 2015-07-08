//
//  FormatParameter.m
//  BabyunCore
//
//  Created by venking on 15/6/12.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "Bee.h"
#import "UPYunUpload.h"

@implementation UPYunResult

- (id) initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        self.saveToken = [data objectForKey:@"save_token"];
        self.tokenSecret = [data objectForKey:@"token_secret"];
        self.bucketName = [data objectForKey:@"bucket_name"];
        self.blockNumber = [[data objectForKey:@"blocks"] integerValue];
        self.blockState = [[data objectForKey:@"status"] mutableCopy];
        self.expiredTime = [[data objectForKey:@"expired_at"] integerValue];
    }
    return self;
}

@end

static NSString * API_SERVER = @"http://m0.api.upyun.com";

static NSString * BUCKET = @"babyun-dev";

static NSString * PASSCODE = @"kdc/DDjp6UwDs6zam5dYrVS73oM=";

static NSInteger BLOCK_SIZE = 1024 * 100;

static NSInteger AUTHORIZATION_TIME = 60.0f;

static NSUInteger MAX_RETRY_NUMBER = 3;

static NSUInteger MAX_THREAD_NUMBER = 5;

static NSString * UPYUN_DATA_QUEUE = @"UPYun.Upload.Data.Queue";

@interface UPYunUpload()
{

}
@end

@implementation UPYunUpload

+ (void) setServer:(NSString *)server
{
    API_SERVER = server;
}

+ (void) setBucket:(NSString *)bucket
{
    BUCKET = bucket;
}

+(void) setPasscode:(NSString *)passcode
{
    PASSCODE = passcode;
}

+ (void) setUPYunDataQueue:(NSString *)queueName
{
    UPYUN_DATA_QUEUE = queueName;
}

+ (void) setBlockSize:(NSInteger)size
{
    if (1024 * 100 > size)
    {
        INFO(@"最少 1024 * 100");
    }
    
    BLOCK_SIZE = size;
}

+ (void) setAuthorizaionTime:(NSInteger)authorizaionTime
{
    AUTHORIZATION_TIME = authorizaionTime;
}

+ (void)setMaxRetryNumber:(NSUInteger)maxRetryNumber
{
    MAX_RETRY_NUMBER = maxRetryNumber;
}

+ (void) setMaxThreadNumber:(NSUInteger) maxThreadNumber
{
    MAX_THREAD_NUMBER = maxThreadNumber;
}

+ (NSString *) API_SERVER
{
    return API_SERVER;
}

+ (NSString *) BUCKET
{
    return BUCKET;
}
+ (NSString *) PASSCODE
{
    return PASSCODE;
}

+ (NSString *) UPYUN_DATA_QUEUE
{
    return UPYUN_DATA_QUEUE;
}

+ (NSInteger) BLOCK_SIZE
{
    return BLOCK_SIZE;
}

+ (NSInteger) AUTHORIZATION_TIME
{
    return AUTHORIZATION_TIME;
}

+ (NSUInteger) MAX_RETRY_NUMBER
{
    return MAX_RETRY_NUMBER;
}

+ (NSUInteger) MAX_THREAD_NUMBER
{
    return MAX_THREAD_NUMBER;
}

+ (NSInteger) calculateBlockCountOfData:(NSData *)data
{
    if (data.length < BLOCK_SIZE)
    {
        return 1;
    }
    return (data.length / BLOCK_SIZE);
}

+ (NSArray *) subData:(NSData *)data
{
    NSInteger blockCount = [self calculateBlockCountOfData:data];
    NSMutableArray * blocks = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < blockCount; i++ )
    {
        NSInteger start = i * BLOCK_SIZE;
        NSInteger length = BLOCK_SIZE;
        if (i == (blockCount -1))
        {
            length = data.length - start;
        }
        NSData * subData = [data subdataWithRange:NSMakeRange(start, length)];
        [blocks addObject:subData];
    }
    return blocks;
}

+ (NSDictionary *) infoOfData:(NSData *)data
{
    NSInteger blockCount = [self calculateBlockCountOfData:data];
    NSDictionary * info = @{@"file_blocks":@(blockCount),
                            @"file_hash":[data MD5HexDigest],
                            @"file_size":@(data.length)};
    return [[info copy] autorelease];
}

/*
 客户端初始化上传参数组设置。
 参数 :
 返回值 : 首次上传的参数组字典包。
 */
+ (NSDictionary *) parameterGroupWithData:(NSData *)data path:(NSString *)path
{
    NSDictionary * dataInfo = [self infoOfData:data];
    
    NSMutableDictionary * paramGroup = [[NSMutableDictionary alloc]initWithDictionary:dataInfo];
    [paramGroup setObject:EXPIRED_TIME forKey:@"expiration"];//设置授权过期时间
    [paramGroup setObject:path forKey:@"path"];//设置保存路径
    
    /*
     *  其他可选参数组 见：
     *  http://docs.upyun.com/api/form_api/#Policy%e5%86%85%e5%ae%b9%e8%af%a6%e8%a7%a3
     */
    
    return [[paramGroup copy] autorelease];
}

/*
 计算上传请求参数。
 参数：
 condition : 需要附件的条件。（表单API，服务器返回的令牌）
 */
+ (NSDictionary *) requestParameterByParameterGroup:(NSDictionary *)paramGroup condition:(NSString *)condition
{
    NSString * signature = [paramGroup toString];
    signature = [signature stringByAppendingString:condition];
    
    NSString * policy = [[paramGroup toJsonString] base64encode];
    
    
    NSDictionary * parameter = @{@"signature":[signature UPYunMD5],
                                 @"policy":policy};
    return parameter;
}
@end

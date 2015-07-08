//
//  FormatParameter.h
//  BabyunCore
//
//  Created by venking on 15/6/12.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "Bee.h"

#define EXPIRED_TIME @(ceil([[NSDate date] timeIntervalSince1970]) + [UPYunUpload AUTHORIZATION_TIME])

@interface UPYunResult : NSObject
@property (nonatomic, strong) NSString * saveToken;
@property (nonatomic, strong) NSString * tokenSecret;
@property (nonatomic, strong) NSString * bucketName;
@property (nonatomic, assign) NSInteger blockNumber;
@property (nonatomic, strong) NSMutableArray * blockState;
@property (nonatomic, assign) NSTimeInterval expiredTime;

- (id) initWithDictionary:(NSDictionary *)data;
@end

@interface UPYunUpload : NSObject

+ (void) setServer:(NSString *)server;
+ (void) setBucket:(NSString *)bucket;
+ (void) setPasscode:(NSString *)passcode;
+ (void) setUPYunDataQueue:(NSString *)queueName;
+ (void) setBlockSize:(NSInteger)size;
+ (void) setAuthorizaionTime:(NSInteger)authorizaionTime;
+ (void) setMaxRetryNumber:(NSUInteger)maxRetryNumber;
+ (void) setMaxThreadNumber:(NSUInteger) maxThreadNumber;

+ (NSString *) API_SERVER;
+ (NSString *) BUCKET;
+ (NSString *) PASSCODE;
+ (NSString *) UPYUN_DATA_QUEUE;
+ (NSInteger) BLOCK_SIZE;
+ (NSInteger) AUTHORIZATION_TIME;
+ (NSUInteger) MAX_RETRY_NUMBER;
+ (NSUInteger) MAX_THREAD_NUMBER;

+ (NSArray *) subData:(NSData *)data;
+ (NSDictionary *) parameterGroupWithData:(NSData *)data path:(NSString *)path;
+ (NSDictionary *) requestParameterByParameterGroup:(NSDictionary *)paramGroup condition:(NSString *)condition;

@end

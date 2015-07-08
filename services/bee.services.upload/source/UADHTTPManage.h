//
//  UADHTTPManage.h
//  BabyunCore
//
//  Created by venking on 15/7/3.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "UADHTTPRequest.h"

@class BeeQueueModel;
@interface UADUserInfo : NSObject
@property (nonatomic, assign) NSInteger numberOfBlocks;
@property (nonatomic, assign) NSInteger indexOfBlocks;
@property (nonatomic, strong) BeeQueueModel * model;
@property (nonatomic, strong) NSData * block;
@property (nonatomic, assign) NSInteger retryCount;
+ (NSString *) UAD_USER_INFO;
@end

@interface UADHTTPManageOption : NSObject
@property (nonatomic, strong) NSMutableDictionary * parameter;
@property (nonatomic, strong) NSMutableDictionary * userInfo;
@property (nonatomic, assign) BOOL finished;
- (id) initWithParameter:(NSMutableDictionary *)parameter userInfo:(NSMutableDictionary *)userInfo;
@end

typedef BOOL (^UADHTTPManageBlock)(BeeQueueModel *);
typedef UADHTTPManageOption * (^UADHTTPManageRequestBlock)(ASIHTTPRequest *);
typedef UADHTTPManageOption * (^UADHTTPManageOptionBlock)(UADHTTPManageOption *);

@interface UADHTTPManage : NSObject
@property (nonatomic, strong) NSString * MODEL_QUEUE_NAME;

// 由调用者实现
@property (nonatomic, copy) UADHTTPManageBlock fillModel; // 数据填充
@property (nonatomic, copy) UADHTTPManageOptionBlock optionDictionary; // 参数以及用户标识信息的设置
@property (nonatomic, copy) UADHTTPManageRequestBlock didSucceed;
@property (nonatomic, copy) UADHTTPManageRequestBlock didFailed;

- (id)initWithQueue:(NSString *)queue numberOfthread:(NSUInteger)thread;
- (void) setMaxSizeOfBlock:(NSUInteger)size;
- (void) setMinSizeOfBlock:(NSUInteger)size;
- (void) runLoop;

@end

//
//  FileUploadMessage.h
//  BabyunCore
//
//  Created by venking on 15/6/15.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "Bee.h"
#import "Bee_Queue.h"
#import "UPYunUpload.h"
#import "UADHTTPCache.h"

@interface ParameterOption : NSObject
@property (nonatomic, strong) BeeQueueModel * model;
@property (nonatomic, strong) BeeMessage * blockMessage;
@property (nonatomic, strong) UPYunResult * result;
@property (nonatomic, strong) UADHTTPCache * cache;
@end

typedef void (^UploadBlock) (NSDictionary * first, NSInteger count);

@interface FileUploadMessage  : NSObject
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * formAPI;
@property (nonatomic, readonly) UploadBlock UPLOAD;
- (void)routine;
@end

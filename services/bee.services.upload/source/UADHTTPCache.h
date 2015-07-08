//
//  UploadCache.h
//  BabyunCore
//
//  Created by venking on 15/6/26.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "Bee_ActiveRecord.h"

@interface UADHTTPCache : BeeActiveRecord

@property (nonatomic, strong) NSNumber * key;
@property (nonatomic, strong) NSString * fileMD5;
@property (nonatomic, strong) NSString * localPath;
@property (nonatomic, strong) NSString * serverPath;
@property (nonatomic, strong) NSNumber * blockSize;
@property (nonatomic, strong) NSNumber * fileSize;

@property (nonatomic, strong) NSString * objs;
@property (nonatomic, strong) NSNumber * progress;

- (id) initWithLocalPath:(NSString *) local server:(NSString *)server blockSize:(NSUInteger)size;
- (BOOL) existWithObject:(NSString *)obj;
- (void) addObject:(NSString *)obj;
- (NSUInteger) getObjectsCount;
@end
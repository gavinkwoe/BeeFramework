//
//  UploadCache.h
//  BabyunCore
//
//  Created by venking on 15/6/26.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "Bee_ActiveRecord.h"

@interface UADHTTPCache : BeeActiveRecord

@property (nonatomic, readonly) NSString * key;
@property (nonatomic, readonly) NSString * localPath;
@property (nonatomic, readonly) NSString * serverPath;
@property (nonatomic, readonly) NSNumber * allSize;
@property (nonatomic, readonly) NSNumber * blockSize;

@property (nonatomic, readonly) NSString * bloks;
@property (nonatomic, strong) NSNumber * progress;

- (id) initWithKey:(NSString *)key
             local:(NSString *)local
            server:(NSString *)server
         sizeOfAll:(NSUInteger)all
       sizeOfBlock:(NSUInteger)block;

- (BOOL) existWithObject:(NSString *)obj;
- (void) addObject:(NSString *)obj;
- (NSUInteger) getObjectsCount;
- (void) saveCache;
@end
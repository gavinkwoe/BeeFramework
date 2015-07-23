//
//  UploadCache.m
//  BabyunCore
//
//  Created by venking on 15/6/26.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "UADHTTPCache.h"

@implementation UADHTTPCache
- (id) initWithKey:(NSString *)key local:(NSString *)local server:(NSString *)server sizeOfAll:(NSUInteger)all sizeOfBlock:(NSUInteger)block

{
    if (self = [super init])
    {
        _key = key;
        _localPath = local;
        _serverPath = server;
        _allSize = [NSNumber numberWithInteger:all];
        _blockSize = [NSNumber numberWithInteger:block];
        
        _progress = [[NSNumber alloc] initWithInt:0];
        _bloks = nil;
        
        [UADHTTPCache mapPropertyAsKey:@"key"];
    }
    return self;
}

- (BOOL) existWithObject:(NSString *)obj
{
    if (nil == obj || nil == _bloks)
    {
        return NO;
    }
    obj = [NSString stringWithFormat:@"%@", obj];
    
    NSRange range = [_bloks rangeOfString:@","];
    if (range.length > 0)
    {
        NSArray * objs = [_bloks componentsSeparatedByString:@","];
        return [objs containsObject:obj];
    }
    else
    {
        return (NSOrderedSame == [_bloks compare:obj]);
    }
    
    return NO;
}

- (void) addObject:(NSString *)obj
{
    if (nil == obj)
    {
        return;
    }
    
    if (nil == _bloks)
    {
        _bloks = [NSString stringWithFormat:@"%@", obj];
    }
    else if (![self existWithObject:obj])
    {
        _bloks = [NSString stringWithFormat:@"%@,%@",_bloks, obj];
    }
}

- (NSUInteger) getObjectsCount
{
    NSArray * objs = [_bloks componentsSeparatedByString:@","];
    return objs.count;
}

@end

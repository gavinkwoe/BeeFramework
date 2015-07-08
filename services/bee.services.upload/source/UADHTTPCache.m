//
//  UploadCache.m
//  BabyunCore
//
//  Created by venking on 15/6/26.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "UADHTTPCache.h"

@implementation UADHTTPCache
- (id) initWithLocalPath:(NSString *)local server:(NSString *)server blockSize:(NSUInteger)size

{
    if (self = [super init])
    {
        self.localPath = local;
        self.serverPath = server;
        self.blockSize = [NSNumber numberWithInteger:size];
        self.fileMD5 = [local MD5];
        
        self.progress = [[NSNumber alloc] initWithInt:0];
        self.objs = nil;
        
        [self calculateKey];
    }
    return self;
}

- (void) calculateKey
{
    if (self.localPath)
    {
        NSFileManager * file = [NSFileManager defaultManager];
        if ([file fileExistsAtPath:self.localPath])
        {
            NSError * fileError;
            NSDictionary * attr = [file attributesOfItemAtPath:self.localPath error:&fileError];
            INFO(@"%@", attr);
            _key = [attr objectForKey:@"NSFileSystemFileNumber"];
            NSUInteger size = [[attr objectForKey:@"NSFileSize"] integerValue];
            _fileSize = @(size);
        }
    }
}

- (BOOL) existWithObject:(NSString *)obj
{
    if (nil == obj)
    {
        return NO;
    }
    
    NSArray * objcs = [self.objs componentsSeparatedByString:@","];
    return [objcs containsObject:obj];
}

- (void) addObject:(NSString *)obj
{
    if (nil == obj)
    {
        return;
    }
    
    if (nil == self.objs)
    {
        self.objs = obj;
    }
    else
    {
        self.objs = [NSString stringWithFormat:@"%@,%@", self.objs, obj];
    }
}

- (NSUInteger) getObjectsCount
{
    return [self.objs componentsSeparatedByString:@","].count;
}

@end

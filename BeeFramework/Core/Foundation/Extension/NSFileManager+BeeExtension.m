//
//  NSFileManager+BeeExtension.m
//  StaticLibrary
//
//  Created by ly on 13-6-2.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import "NSFileManager+BeeExtension.h"

@implementation NSFileManager (BeeExtension)

+ (BOOL)iCloudAvaliable:(NSString *)containerID
{
    NSURL *ubiq = [[self defaultManager]
                   URLForUbiquityContainerIdentifier:containerID];
    
    return ( (ubiq) ? YES : NO );
}

@end

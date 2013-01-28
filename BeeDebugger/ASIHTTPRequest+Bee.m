//
//  ASIHTTPRequest+Bee.m
//  WhatsBug
//
//  Created by cui on 13-1-25.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import "ASIHTTPRequest+Bee.h"
#import <objc/runtime.h>

static BOOL forceThrottleBandwith = NO;
static IMP originalIsBandwidthThrottled;

@implementation ASIHTTPRequest (BeeExt)
+ (void)load
{
    Class clazz = objc_getMetaClass(class_getName([self class]));
    SEL selector = @selector(setForceThrottleBandwidth:);
    if ( ! [clazz resolveClassMethod:selector]) {
        IMP imp = class_getMethodImplementation(clazz, @selector(_setForceThrottleBandwidth:));
        class_addMethod(clazz, selector, imp, "v:C");
        
        SEL bandwidthSelector = @selector(isBandwidthThrottled);
        originalIsBandwidthThrottled = class_getMethodImplementation(clazz, bandwidthSelector);
        Method method = class_getClassMethod(clazz, bandwidthSelector);
        IMP myImp = class_getMethodImplementation(clazz, @selector(_isBandwidthThrottled));
		method_setImplementation( method, myImp );
    }
    class_getClassMethod(clazz, @selector(setForceThrottleBandwidth:));
}

// Set to YES to force turn on throttling
+ (void)_setForceThrottleBandwidth:(BOOL)throttle
{
    forceThrottleBandwith = throttle;
}

+ (BOOL)_isBandwidthThrottled
{
    if ( forceThrottleBandwith )
        return YES;
    if (originalIsBandwidthThrottled) {
       return (BOOL)originalIsBandwidthThrottled(self, _cmd);
    }
    return NO;
}

@end

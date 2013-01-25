//
//  ASIHTTPRequest+Bee.h
//  WhatsBug
//
//  Created by cui on 13-1-25.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

// add ForceThrottleBandwidth method to latest ASIHTTPRequest

#import "ASIHTTPRequest.h"

@interface ASIHTTPRequest (Bee)
// Set to YES to force turn on throttling
+ (void)setForceThrottleBandwidth:(BOOL)throttle;

@end

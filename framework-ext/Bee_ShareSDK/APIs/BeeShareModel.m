//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  BeeShareModel.m
//  BeeSNS
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "BeeShareModel.h"
#import "BeeShareApi.h"

@implementation BeeShareStorge

//- (void)dealloc
//{
//    self.user = nil;
//    self.auth = nil;
//    
//    [super dealloc];
//}

- (void)serialize
{
//    [self keychainWrite:[[self.auth objectToDictionary] JSONString] forKey:@"auth"];
}

- (void)unserialize
{
//	self.auth = [[[self auth] class] objectFromDictionary:[[self keychainRead:@"auth"] objectFromJSONString]];
}
- (void)removeStorge
{
    [self keychainDelete:@"auth"];
}

@end


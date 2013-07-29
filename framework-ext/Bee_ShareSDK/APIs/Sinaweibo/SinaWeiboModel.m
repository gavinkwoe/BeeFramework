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
//  SinaWeiboModel.m
//  BeeSNS
//
//  Created by QFish on 4/27/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "SinaWeiboModel.h"

#pragma mark -

#pragma mark -

@implementation SinaWeiboStorage

DEF_SINGLETON( SinaWeiboStorage );

- (void)serialize
{
    [self keychainWrite:[[self.auth objectToDictionary] JSONString] forKey:@"auth"];
}

- (void)unserialize
{
	self.auth = [SinaWeiboAuth objectFromDictionary:[[self keychainRead:@"auth"] objectFromJSONString]];
}

@end

@implementation SinaWeiboAuth
@end

@implementation SinaWeiboUser
@end


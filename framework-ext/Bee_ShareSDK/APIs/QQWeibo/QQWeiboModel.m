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
//  QQWeiboModel.m
//  BeeSNS
//
//  Created by QFish on 4/27/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "QQWeiboModel.h"

#pragma mark -

@implementation QQWeiboStorage

DEF_SINGLETON( QQWeiboStorage );

- (void)serialize
{
    [self keychainWrite:[self.auth objectToString] forKey:@"auth"];
}

- (void)unserialize
{
	self.auth  = [QQWeiboAuth objectFromString:[self keychainRead:@"auth"]];
}

@end

@implementation QQWeiboAuth
@end

@implementation QQWeiboUser
@end

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
//  RenrenModel.m
//  BeeSNS
//
//  Created by QFish on 4/27/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "RenrenModel.h"

#pragma mark -

@implementation RenrenStorage

DEF_SINGLETON( RenrenStorage );

- (void)serialize
{
    [self keychainWrite:[self.auth objectToString] forKey:@"auth"];
}

- (void)unserialize
{
	self.auth  = [RenrenAuth objectFromString:[self keychainRead:@"auth"]];
}

@end

@implementation RenrenAuth
@end

@implementation RenrenUser
@end

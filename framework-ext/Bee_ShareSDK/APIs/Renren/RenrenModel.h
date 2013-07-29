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
//  RenrenModel.h
//  BeeSNS
//
//  Created by QFish on 4/27/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "BeeShareModel.h"

#pragma mark - Renren

@class RenrenUser;
@class RenrenAuth;

@interface RenrenStorage : BeeShareStorge

@property (nonatomic, retain) RenrenUser * user;
@property (nonatomic, retain) RenrenAuth * auth;

AS_SINGLETON( RenrenStorage )

@end

#pragma mark -

@interface RenrenAuth : NSObject
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * expires_in;
@property (nonatomic, retain) NSString * access_token;
@end

@interface RenrenUser : NSObject
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profile_image_url;
@end


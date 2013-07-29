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
//  SinaWeiboModel.h
//  BeeSNS
//
//  Created by QFish on 4/27/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "BeeShareModel.h"

@class SinaWeiboUser;
@class SinaWeiboAuth;

#pragma mark -

@interface SinaWeiboStorage : BeeShareStorge

@property (nonatomic, retain) SinaWeiboUser * user;
@property (nonatomic, retain) SinaWeiboAuth * auth;

AS_SINGLETON( SinaWeiboStorage )

@end

#pragma mark - Sina Weibo

@interface SinaWeiboAuth : NSObject
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * remind_in;
@property (nonatomic, retain) NSString * expires_in;
@property (nonatomic, retain) NSString * access_token;
@end

#pragma mark -

@interface SinaWeiboUser : NSObject
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profile_image_url;
@end

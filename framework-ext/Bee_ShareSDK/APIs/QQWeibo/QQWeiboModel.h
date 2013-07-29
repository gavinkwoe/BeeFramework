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
//  QQWeiboModel.h
//  BeeSNS
//
//  Created by QFish on 4/27/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "BeeShareModel.h"

#pragma mark - QQ Weibo

@class QQWeiboUser;
@class QQWeiboAuth;

@interface QQWeiboStorage : BeeShareStorge

@property (nonatomic, retain) QQWeiboUser * user;
@property (nonatomic, retain) QQWeiboAuth * auth;

AS_SINGLETON( QQWeiboStorage )

@end

#pragma mark -

@interface QQWeiboAuth : NSObject
@property (nonatomic, retain) NSString * access_token;
@property (nonatomic, retain) NSString * openkey;
@property (nonatomic, retain) NSString * openid;
@property (nonatomic, retain) NSString * expires_in;
@end

@interface QQWeiboUser : NSObject
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profile_image_url;
@end

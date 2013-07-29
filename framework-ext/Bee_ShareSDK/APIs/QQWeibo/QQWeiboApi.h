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
//  QQWeiboApi.h
//  BeeSNS
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "BeeShareApi.h"
#import "QQWeiboModel.h"
#import "QQAuthorizeBoard.h"

#define kQQAppKey                       @"801349116"
#define kQQAppSecret                    @"58342e65b5c460baead49940c1b7e085"
#define kQQAppRedirectURI               @"http://www.baidu.com"

#define kQQWeiboSDKAPIDomain             @"https://open.t.qq.com/api/"
#define kQQWeiboSDKOAuth2APIDomain       @"https://open.t.qq.com/cgi-bin/oauth2/"
#define kQQWeiboWebAuthURL               @"https://open.t.qq.com/cgi-bin/oauth2/authorize"

#pragma mark -

@interface QQWeibo : BeeShareApi

@property (nonatomic, retain) QQWeiboAuth * auth;

AS_SINGLETON( QQWeibo )

AS_MESSAGE( signin )
AS_MESSAGE( user_info )

@end

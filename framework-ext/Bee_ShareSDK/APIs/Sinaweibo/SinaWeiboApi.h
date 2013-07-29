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
//  SinaWeiboApi.h
//  BeeSNS
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "BeeShareApi.h"
#import "SinaWeiboModel.h"
#import "SinaAuthorizeBoard.h"

#define kSinaAppKey                         @"3982969467"
#define kSinaAppSecret                      @"9059f0a5123fab6e944b99701a23acf1"
#define kSinaAppRedirectURI                 @"https://api.weibo.com/oauth2/default.html"

#define kSinaWeiboSDKAPIDomain              @"https://api.weibo.com/2/"
#define kSinaWeiboSDKOAuth2APIDomain        @"https://api.weibo.com/2/oauth2/"
#define kSinaWeiboWebAuthURL                @"https://open.weibo.cn/oauth2/authorize"
#define kSinaWeiboWebAccessTokenURL         @"https://api.weibo.com/2/oauth2/access_token"
#define kSinaWeiboStatusesURL               @"https://open.weibo.cn/2/statuses/update.json"

#pragma mark -

@interface SinaWeibo : BeeShareApi
{
}

@property (nonatomic, retain) SinaWeiboAuth * auth;

AS_SINGLETON( SinaWeibo )

// oauth2
AS_MESSAGE( oauth2_access_token )   // 获取用户信息

// users
AS_MESSAGE( users_show )            // 获取用户信息

//statuses
AS_MESSAGE( statuses_update )       // 发布一条新微博
AS_MESSAGE( statuses_upload )       // 上传图片并发布一条新微博

@end

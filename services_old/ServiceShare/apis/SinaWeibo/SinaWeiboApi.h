//
//  SinaWeibo.h
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "ServiceShare_API.h"

#define kSinaWeiboSDKAPIDomain          @"https://api.weibo.com/2/"
#define kSinaWeiboSDKOAuth2APIDomain    @"https://api.weibo.com/oauth2/"

@interface SinaWeiboApi : ServiceShareApi

AS_SINGLETON( SinaWeiboApi )

- (void)authorize;
- (void)shareWithText:(NSString *)text;
- (void)shareWithText:(NSString *)text image:(NSObject *)image;
- (void)shareWithText:(NSString *)text imageUrl:(NSObject *)imageUrl;

#pragma mark - 

// oauth2
AS_MESSAGE( oauth2_access_token )   // oauth2授权

//statuses
AS_MESSAGE( statuses_update )           // 发布一条新微博
AS_MESSAGE( statuses_upload )           // 上传图片并发布一条新微博
AS_MESSAGE( statuses_upload_url_text )  // 发布一条微博同时指定上传的图片或图片url 

@end

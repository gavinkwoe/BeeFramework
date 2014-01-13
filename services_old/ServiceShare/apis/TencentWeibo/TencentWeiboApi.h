//
//  TencentWeibo.h
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "ServiceShare_API.h"

#define kTencentWeiboSDKAPIDomain          @"https://open.t.qq.com/api/"
#define kTencentWeiboSDKOAuth2APIDomain    @"https://open.t.qq.com/cgi-bin/oauth2/"

@interface TencentWeiboApi : ServiceShareApi

AS_SINGLETON( TencentWeiboApi )

- (void)authorize;
- (void)shareWithText:(NSString *)text;
- (void)shareWithText:(NSString *)text image:(NSObject *)image;
- (void)shareWithText:(NSString *)text imageUrl:(NSObject *)imageUrl;

#pragma mark - 

// oauth2
AS_MESSAGE( oauth2_access_token )   // oauth2授权

// t
AS_MESSAGE( t_add )                 // 发布一条新微博
AS_MESSAGE( t_add_pic )             // 上传图片并发布一条新微博
AS_MESSAGE( t_add_multi )           // 发表带视频、音乐、图片等内容的微博
AS_MESSAGE( t_add_pic_url )         // 发布一条微博同时指定上传的图片或图片url

@end

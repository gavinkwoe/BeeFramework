//
//  TencentWeibo.h
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "TencentWeiboApi.h"

@interface TencentWeibo : NSObject

AS_SINGLETON( TencentWeibo );

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSObject * image;

@property (nonatomic, copy) ServiceShareBlock       begin;
@property (nonatomic, copy) ServiceShareBlock       cancel;
@property (nonatomic, copy) ServiceShareBlock       success;
@property (nonatomic, copy) ServiceShareBlockError  failure;

- (void)share;
- (void)authorize;
- (void)unauthorize;
- (BOOL)isLogin;

+ (void)configWithAppKey:(NSString *)appKey
               appSecret:(NSString *)appSecret
             redirectUri:(NSString *)redirectUri;

@end

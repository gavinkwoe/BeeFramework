//
//  Weixin.h
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "WXApi.h"
#import "ServiceShare_API.h"

@interface Weixin : NSObject<WXApiDelegate>

AS_SINGLETON( Weixin );

@property (nonatomic, assign) int        scene;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSObject * image;
@property (nonatomic, retain) NSObject * thumb; // UIImage , NSString or NSData
@property (nonatomic, retain) NSString * title;

@property (nonatomic, copy) ServiceShareBlock       begin;
@property (nonatomic, copy) ServiceShareBlock       cancel;
@property (nonatomic, copy) ServiceShareBlock       success;
@property (nonatomic, copy) ServiceShareBlockError  failure;

- (void)shareToFriend;
- (void)shareToTimeline;

+ (void)powerOn;

+ (void)configWithAppID:(NSString *)appID appKey:(NSString *)appKey;

@end

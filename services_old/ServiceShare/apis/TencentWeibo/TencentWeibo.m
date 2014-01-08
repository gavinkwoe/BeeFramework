//
//  TencentWeibo.m
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "TencentWeibo.h"
#import "ServiceShare.h"

@implementation TencentWeibo

DEF_SINGLETON( TencentWeibo );

- (id)init
{
    self = [super init];

    if ( self )
    {
        [self observeNotification:ServiceShareApi.BEGIN];
        [self observeNotification:ServiceShareApi.CANCEL];
        [self observeNotification:ServiceShareApi.FAILURE];
        [self observeNotification:ServiceShareApi.SUCCESS];
        [self observeNotification:ServiceShareApi.AUTHORIZE_CANCEL];
        [self observeNotification:ServiceShareApi.AUTHORIZE_FAILURE];
        [self observeNotification:ServiceShareApi.AUTHORIZE_SUCCESS];
    }
    
    return self;
}

- (void)dealloc
{
    [self unobserveAllNotifications];
    
    self.text = nil;
    self.image = nil;
    
    self.begin = nil;
    self.cancel = nil;
    self.failure = nil;
    self.success = nil;
    
    [super dealloc];
}

+ (void)configWithAppKey:(NSString *)appKey
               appSecret:(NSString *)appSecret
             redirectUri:(NSString *)redirectUri
{
    [TencentWeiboApi sharedInstance].appKey = appKey;
    [TencentWeiboApi sharedInstance].appSecret = appSecret;
    [TencentWeiboApi sharedInstance].redirectUri = redirectUri;
}

#pragma mark -

- (void)share
{
    if ( self.image )
    {
        if ( [self.image isKindOfClass:[UIImage class]] )
        {
            [[TencentWeiboApi sharedInstance] shareWithText:self.text image:self.image];
        }
        else if ( [self.image isKindOfClass:[NSString class]] )
        {
            [[TencentWeiboApi sharedInstance] shareWithText:self.text imageUrl:self.image];
        }
        else
        {
            ERROR( @"%@ is not a url or UIImage",  self.image );
        }
    }
    else
    {
        [[TencentWeiboApi sharedInstance] shareWithText:self.text];
    }
}

- (void)authorize
{
    [[TencentWeiboApi sharedInstance] authorize];
}

- (void)unauthorize
{
    [[TencentWeiboApi sharedInstance] unauthorize];
}

- (BOOL)isLogin
{
    return [[TencentWeiboApi sharedInstance] isAuthorized];
}

- (void)clear
{
    self.text = nil;
    self.image = nil;
    self.begin = nil;
    self.cancel = nil;
    self.failure = nil;
    self.success = nil;
}

ON_NOTIFICATION2( ServiceShareApi, notification )
{
    if ( [notification is:ServiceShareApi.BEGIN] )
    {
        if ( self.begin )
        {
            self.begin();
            self.begin = nil;
        }
    }
    else if ( [notification is:ServiceShareApi.CANCEL] )
    {
        if ( self.cancel )
        {
            self.cancel();
            [self clear];
        }
    }
    else if ( [notification is:ServiceShareApi.FAILURE] )
    {
        if ( self.failure )
        {
            self.failure(notification.object);
            [self clear];
        }
    }
    else if ( [notification is:ServiceShareApi.SUCCESS] )
    {
        if ( self.success )
        {
            self.success();
            [self clear];
        }
    }
    else if ( [notification is:ServiceShareApi.AUTHORIZE_FAILURE] )
    {
        if ( self.failure )
        {
            self.failure(notification.object);
            [self clear];
        }
    }
    else if ( [notification is:ServiceShareApi.AUTHORIZE_CANCEL] )
    {
        if ( self.cancel )
        {
            self.cancel();
            [self clear];
        }
    }
    
    else if ( [notification is:ServiceShareApi.AUTHORIZE_SUCCESS] )
    {
        // do nothing
    }
}

@end

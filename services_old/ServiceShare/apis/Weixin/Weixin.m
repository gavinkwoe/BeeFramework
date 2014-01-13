//
//  Weixin.m
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "Weixin.h"
#import "ServiceShare.h"

@interface Weixin()
@property (nonatomic, retain) NSString * appID;
@property (nonatomic, retain) NSString * appKey;
@end

@implementation Weixin

DEF_SINGLETON( Weixin );

- (id)init
{
    self = [super init];

    if ( self )
    {
        [self observeNotification:BeeUIApplication.LAUNCHED];
        [self observeNotification:ServiceShareApi.BEGIN];
        [self observeNotification:ServiceShareApi.CANCEL];
        [self observeNotification:ServiceShareApi.FAILURE];
        [self observeNotification:ServiceShareApi.SUCCESS];
    }
    
    return self;
}

- (void)dealloc
{
    [self unobserveAllNotifications];
    
    self.appID = nil;
    self.appKey = nil;
    
    self.text = nil;
    self.image = nil;

    self.begin = nil;
    self.cancel = nil;
    self.failure = nil;
    self.success = nil;
    
    [super dealloc];
}

+ (void)powerOn
{
    [WXApi registerApp:[Weixin sharedInstance].appID];
}

+ (void)configWithAppID:(NSString *)appID appKey:(NSString *)appKey
{
    [Weixin sharedInstance].appID = appID;
    [Weixin sharedInstance].appKey = appKey;
}

#pragma mark -

- (void)shareTo:(NSInteger)scene
{
    [WXApi registerApp:[Weixin sharedInstance].appID];
    
    if ( ![WXApi isWXAppInstalled] )
    {
        ServiceShareError * error = [ServiceShareError errorWithCode:@(1) desc:@"您未安装微信\n无法分享到微信." domain:@"weixin"];
        [self postNotification:ServiceShareApi.FAILURE withObject:error];
        return;
    }

    SendMessageToWXReq * req = [[[SendMessageToWXReq alloc] init] autorelease];

    if ( self.image || self.thumb )
    {
		WXMediaMessage * message = [WXMediaMessage message];

		if ( self.title && self.title.length )
		{
			message.title = self.title;
		}

		if ( self.thumb )
		{
			NSData * thumbData = nil;
			
			if ( [self.thumb isKindOfClass:[UIImage class]] )
			{
				thumbData = [(UIImage *)self.thumb dataWithExt:@"png"];
			}
			else if ( [self.thumb isKindOfClass:[NSString class]] )
			{
				thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)self.thumb]];
			}
			else if ( [self.thumb isKindOfClass:[NSData class]] )
			{
				thumbData = (NSData *)self.thumb;
			}
			
			message.thumbData = thumbData;
		}

		if ( self.image )
		{
			WXImageObject * image = [WXImageObject object];
			
			if ( [self.image isKindOfClass:[UIImage class]] )
			{
				image.imageData = [(UIImage *)self.image dataWithExt:@"png"];
			}
			else if ( [self.image isKindOfClass:[NSString class]] )
			{
				image.imageUrl = (NSString *)self.image;
			}
			
			message.mediaObject = image;
		}
		
		if ( self.text )
		{
			message.description = self.text;
		}

        req.bText = NO;
		req.message = message;
    }
    else
    {
        req.bText = YES;
		req.text = self.text ? self.text : self.title;
    }

    req.scene = scene;
    
    [self postNotification:ServiceShareApi.BEGIN];

    [WXApi sendReq:req];
}

- (void)shareToFriend
{
    [self shareTo:WXSceneSession];
}

- (void)shareToTimeline
{
    [self shareTo:WXSceneTimeline];
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

ON_NOTIFICATION2( BeeUIApplication, notification )
{
    if ( [notification is:BeeUIApplication.LAUNCHED] )
    {
        NSDictionary * params = notification.object;
        
        if ( params )
        {
            NSURL * url = [params objectForKey:@"url"];
            NSString * source = [params objectForKey:@"source"];
            
            if ( [[url absoluteString] hasSuffix:@"wechat"] || [source hasPrefix:@"com.tencent.xin"] )
            {
                [WXApi handleOpenURL:url delegate:self];
            }
        }
    }
}

ON_NOTIFICATION2( ServiceShareApi, notification )
{
    if ( [notification is:ServiceShareApi.BEGIN] )
    {
        if ( self.begin )
        {
            self.begin(notification.object);
            self.begin = nil;
        }
    }
    else if ( [notification is:ServiceShareApi.CANCEL] )
    {
        if ( self.cancel )
        {
            self.cancel(notification.object);
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
            self.success(notification.object);
            [self clear];
        }
    }
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq*)req
{
    
}

- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        switch ( resp.errCode )
        {
            case WXSuccess:
            {
                [self postNotification:ServiceShareApi.SUCCESS];
                break;
            }
            case WXErrCodeUserCancel:
            {
                [self postNotification:ServiceShareApi.CANCEL];
                break;
            }
            default:
            {
                [self postNotification:ServiceShareApi.FAILURE];
                break;
            }
        }
    }
}

@end

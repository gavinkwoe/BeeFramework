//
//  SinaWeibo.m
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "SinaWeiboApi.h"
#import "ServiceShare.h"
#import "SinaWeiboAuthorizeBoard.h"

#pragma mark - SinaWeiboError

@interface SinaWeiboError : NSObject
@property (nonatomic, retain) NSString * error;
@property (nonatomic, retain) NSString * request;
@property (nonatomic, retain) NSNumber * error_code;
@end

@implementation SinaWeiboError
@end

#pragma mark - SinaWeiboState

@interface SinaWeiboState : NSObject

AS_SINGLETON( SinaWeiboState );

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSObject * image;
@property (nonatomic, assign) SEL currentAction;

- (void)clear;

@end

@implementation SinaWeiboState

DEF_SINGLETON( SinaWeiboState );

- (void)clear
{
    self.text = nil;
    self.image = nil;
    self.currentAction = nil;
}

@end

#pragma mark - SinaWeiboApi

@interface SinaWeiboApi()

@property (nonatomic, retain) NSString * access_token;
@property (nonatomic, retain) NSNumber * expires_in;
@property (nonatomic, retain) NSString * remind_in;
@property (nonatomic, retain) NSString * uid;

@end

@implementation SinaWeiboApi

DEF_SINGLETON( SinaWeiboApi );

DEF_MESSAGE( oauth2_access_token )
DEF_MESSAGE( statuses_update )
DEF_MESSAGE( statuses_upload )
DEF_MESSAGE( statuses_upload_url_text )

- (void)load
{
    [super load];
    
    [self restoreAuthData];
}

ON_NOTIFICATION2( ServiceShare, notification )
{
    if ( [notification is:[ServiceShare CLOSE]] )
    {
        [SinaWeiboState sharedInstance].text = nil;
        [SinaWeiboState sharedInstance].image = nil;
        [SinaWeiboState sharedInstance].currentAction = nil;
    }
}

#pragma mark - ShareMethod

- (void)shareWithText:(NSString *)text
{
    // 判断是否已授权
    if ( self.isAuthorized )
    {
        [self postNotification:self.BEGIN];
        self.MSG( self.statuses_update ).INPUT( @"status", text ).TIMEOUT( 20.0f );
    }
    else
    {
        [SinaWeiboState sharedInstance].text = text;
        [SinaWeiboState sharedInstance].currentAction = _cmd;
        [self authorize];
    }
}

- (void)shareWithText:(NSString *)text image:(UIImage *)image
{
    // 判断是否已授权
    if ( self.isAuthorized )
    {
        [self postNotification:self.BEGIN];
        self.MSG( self.statuses_upload ).INPUT( @"status", text ).INPUT( @"pic", image ).TIMEOUT( 20.0f );
    }
    else
    {
        [SinaWeiboState sharedInstance].text = text;
        [SinaWeiboState sharedInstance].image = image;
        [SinaWeiboState sharedInstance].currentAction = _cmd;
        [self authorize];
    }
}

- (void)shareWithText:(NSString *)text imageUrl:(NSString *)imageUrl
{
    // 判断是否已授权
    if ( self.isAuthorized )
    {
        [self postNotification:self.BEGIN];
        self.MSG( self.statuses_upload_url_text ).INPUT( @"status", text ).INPUT( @"url", imageUrl ).TIMEOUT( 20.0f );
    }
    else
    {
        [SinaWeiboState sharedInstance].text = text;
        [SinaWeiboState sharedInstance].image = imageUrl;
        [SinaWeiboState sharedInstance].currentAction = _cmd;
        [self authorize];
    }
}

# pragma mark - ServiceShareApiProtocol

- (NSString *)authorizeURL
{
    NSAssert( self.appKey != nil , @"You should set the appKey first" );
    
    NSDictionary * params = @{
        @"display" : @"mobile",
        @"client_id" : self.appKey,
        @"redirect_uri" : self.redirectUri,
        @"response_type" : @"code"
    };
    
    return [[self authorizeApi:@"authorize"] urlByAppendingDict:params];
}

- (NSString *)api:(NSString *)apiPath
{
    return [kSinaWeiboSDKAPIDomain stringByAppendingString:apiPath];
}

- (NSString *)authorizeApi:(NSString *)apiPath
{
    return [kSinaWeiboSDKOAuth2APIDomain stringByAppendingString:apiPath];
}

- (BOOL)isAuthorized
{
    return self.isExpired && self.access_token && self.uid;
}

- (BOOL)isExpired
{
    if ( self.expires_in )
    {
        NSDate * now = [NSDate date];
        NSDate * exp = [self.expires_in dateValue];
        return ( [now compare:exp] == NSOrderedAscending );
    }
    return NO;
}

- (void)authorize
{
//    [self unauthorize];
    
    [[ServiceShare sharedInstance] showAuthorizeBoard:[SinaWeiboAuthorizeBoard class]];
}

- (void)unauthorize
{
	if ( self.appKey && self.appSecret )
	{
		// clear cookies
		NSHTTPCookieStorage * cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
		NSArray * serviceShareCookies = [cookies cookiesForURL:[NSURL URLWithString:self.authorizeURL]];
		
		for ( NSHTTPCookie * cookie in serviceShareCookies )
		{
			[cookies deleteCookie:cookie];
		}
		
		[self removeAuthData];
	}
	
    [[SinaWeiboState sharedInstance] clear];
}


- (void)saveAuthData:(id)authData
{
    // authData is kind of NSString
    [self userDefaultsWrite:authData forKey:@"auth"];
    [self restoreAuthData];
}

- (void)removeAuthData
{
    [self userDefaultsRemove:@"auth"];
    self.access_token = nil;
    self.expires_in = nil;
    self.remind_in = nil;
    self.uid = nil;
    
    INFO( @"ServiceShare : Remove the auth data." );
}

- (void)restoreAuthData
{
    NSDictionary * auth = [[self userDefaultsRead:@"auth"] objectFromJSONString];
    
    if ( auth )
    {
        self.access_token = [auth objectForKey:@"access_token"];
        self.expires_in = [auth objectForKey:@"expires_in"];
        self.remind_in = [auth objectForKey:@"remind_in"];
        self.uid = [auth objectForKey:@"uid"];
    }
}

#pragma mark - controller

- (void)handleFailedMessage:(BeeMessage *)msg
{
    INFO( @"ServiceShare: %@",  msg.responseString );
    
    SinaWeiboError * sinaError = [SinaWeiboError objectFromString:msg.responseString];
    
    ServiceShareError * error = [ServiceShareError errorWithCode:sinaError.error_code
                                                            desc:sinaError.error
                                                          domain:[NSString stringWithFormat:@"SinaWeibo: %@", sinaError.request]];
    
    [self postNotification:self.FAILURE withObject:error];
}

- (void)posthandleMessage:(BeeMessage *)msg
{
    if ( [msg is:self.oauth2_access_token] )
    {
        return;
    }
    
    if ( msg.succeed )
	{
        if ( nil == [msg.responseJSONDictionary objectForKey:@"error_code"] )
        {
            [self postNotification:ServiceShareApi.SUCCESS withObject:msg];
        }
        else
        {
            [self handleFailedMessage:msg];
        }
	}
	else if ( msg.failed )
	{
        [self handleFailedMessage:msg];
	}
	else if ( msg.cancelled )
	{
        [self postNotification:self.CANCEL withObject:msg];
	}
}

- (void)oauth2_access_token:(BeeMessage *)msg
{
    if ( msg.sending )
	{
        NSString * code = msg.GET_INPUT(@"code");
        NSString * grant_type = @"authorization_code";
        NSString * scope = @"all";
        msg
        .POST( [self authorizeApi:@"access_token"] )
        .PARAM( @"client_id", self.appKey )
        .PARAM( @"client_secret", self.appSecret )
        .PARAM( @"redirect_uri", self.redirectUri )
        .PARAM( @"grant_type", grant_type )
        .PARAM( @"scope", scope )
        .PARAM( @"code", code )
        .postFormat = ASIURLEncodedPostFormat;
	}
	else if ( msg.succeed )
	{
        NSMutableDictionary * auth = [NSMutableDictionary dictionaryWithDictionary:msg.responseJSONDictionary];
        double expires_in = [[auth objectForKey:@"expires_in"] intValue] + [[NSDate date] timeIntervalSince1970];
        [auth setObject:[NSNumber numberWithDouble:expires_in] forKey:@"expires_in"];

        [self saveAuthData:[auth JSONString]];
        
        [self postNotification:self.AUTHORIZE_SUCCESS];
        
        // get the action next to do
        SEL action = [SinaWeiboState sharedInstance].currentAction;
        // if the action is existing, do it, or post the notification
        if ( action && [self respondsToSelector:action] )
        {
            if ( sel_isEqual(action, @selector(shareWithText:image:)) )
            {
                [self shareWithText:[SinaWeiboState sharedInstance].text image:[SinaWeiboState sharedInstance].image];
            }
            else if ( sel_isEqual(action, @selector(shareWithText:imageUrl:)) )
            {
                [self shareWithText:[SinaWeiboState sharedInstance].text imageUrl:[SinaWeiboState sharedInstance].image];
            }
            else if ( sel_isEqual(action, @selector(shareWithText:)) )
            {
                [self shareWithText:[SinaWeiboState sharedInstance].text];
            }
            else
            {
                [self handleFailedMessage:msg];
            }
        }
        else
        {
            // if no more action, it must be success for authorizing.
            [self postNotification:self.SUCCESS];
        }
    }
	else if ( msg.failed )
	{
        [self handleFailedMessage:msg];
	}
	else if ( msg.cancelled )
	{
	}
}

- (void)statuses_update:(BeeMessage *)msg
{    
    if ( msg.sending )
	{   
        msg
        .POST( [self api:@"statuses/update.json"] )
        .PARAM( @"access_token", self.access_token )
        .PARAM( @"status", msg.GET_INPUT(@"status") )
        .postFormat = ASIURLEncodedPostFormat
        ;
    }
}

- (void)statuses_upload:(BeeMessage *)msg
{
    if ( msg.sending )
	{
        msg
        .POST( [self api:@"statuses/upload.json"] )
        .PARAM( @"access_token", self.access_token )
        .PARAM( @"status", msg.GET_INPUT(@"status") )
        .FILE_PNG( @"pic", msg.GET_INPUT(@"pic") )
        .postFormat = ASIURLEncodedPostFormat
        ;
    }
}

- (void)statuses_upload_url_text:(BeeMessage *)msg
{
    if ( msg.sending )
	{
        msg
        .POST( [self api:@"statuses/upload_url_text.json"] )
        .PARAM( @"access_token", self.access_token )
        .PARAM( @"status", msg.GET_INPUT(@"status") )
        .PARAM( @"url", msg.GET_INPUT(@"url") )
        .postFormat = ASIURLEncodedPostFormat
        ;
    }
}

@end

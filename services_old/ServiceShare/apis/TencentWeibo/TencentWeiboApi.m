//
//  TencentWeibo.m
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "TencentWeiboApi.h"
#import "ServiceShare.h"
#import "TencentWeiboAuthorizeBoard.h"

#pragma mark - SinaWeiboError

@interface TencentWeiboError : NSObject
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSNumber * seqid;
@property (nonatomic, retain) NSNumber * errcode;
@end

@implementation TencentWeiboError
@end

#pragma mark - TencentWeiboState

@interface TencentWeiboState : NSObject
AS_SINGLETON( TencentWeiboState );

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSObject * image;
@property (nonatomic, assign) SEL currentAction;

- (void)clear;

@end

@implementation TencentWeiboState

DEF_SINGLETON( TencentWeiboState );

- (void)clear
{
    self.text = nil;
    self.image = nil;
    self.currentAction = nil;
}

@end

#pragma mark - TencentWeiboApi

@interface TencentWeiboApi()

@property (nonatomic, retain) NSString * nick;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * openid;
@property (nonatomic, retain) NSString * openkey;
@property (nonatomic, retain) NSNumber * expires_in;
@property (nonatomic, retain) NSString * access_token;
@property (nonatomic, retain) NSString * refresh_token;

@end

@implementation TencentWeiboApi

DEF_SINGLETON( TencentWeiboApi );

DEF_MESSAGE( oauth2_access_token )
DEF_MESSAGE( t_add )
DEF_MESSAGE( t_add_pic )
DEF_MESSAGE( t_add_multi )
DEF_MESSAGE( t_add_pic_url )


- (void)load
{
    [super load];
    
    [self restoreAuthData];
}

ON_NOTIFICATION2( ServiceShare, notification )
{
    if ( [notification is:[ServiceShare CLOSE]] )
    {
        [TencentWeiboState sharedInstance].text = nil;
        [TencentWeiboState sharedInstance].image = nil;
        [TencentWeiboState sharedInstance].currentAction = nil;
    }
}

#pragma mark - ShareMethod

- (void)shareWithText:(NSString *)text
{
    // 判断是否已授权
    if ( self.isAuthorized )
    {
        [self postNotification:self.BEGIN];
        self.MSG( self.t_add ).INPUT( @"content", text );
    }
    else
    {
        [TencentWeiboState sharedInstance].text = text;
        [TencentWeiboState sharedInstance].currentAction = _cmd;
        [self authorize];
    }
}

- (void)shareWithText:(NSString *)text image:(UIImage *)image
{
    // 判断是否已授权
    if ( self.isAuthorized )
    {
        [self postNotification:self.BEGIN];
        self.MSG( self.t_add_pic ).INPUT( @"content", text ).INPUT( @"pic", image );
    }
    else
    {
        [TencentWeiboState sharedInstance].text = text;
        [TencentWeiboState sharedInstance].image = image;
        [TencentWeiboState sharedInstance].currentAction = _cmd;
        [self authorize];
    }
}

- (void)shareWithText:(NSString *)text imageUrl:(NSString *)imageUrl
{
    // 判断是否已授权
    if ( self.isAuthorized )
    {
        [self postNotification:self.BEGIN];
        self.MSG( self.t_add_multi ).INPUT( @"content", text ).INPUT( @"url", imageUrl );
    }
    else
    {
        [TencentWeiboState sharedInstance].text = text;
        [TencentWeiboState sharedInstance].image = imageUrl;
        [TencentWeiboState sharedInstance].currentAction = _cmd;
        [self authorize];
    }
}

# pragma mark - ServiceShareApiProtocol

- (NSString *)authorizeURL
{
    NSDictionary * params = @{
        @"client_id": self.appKey,
        @"redirect_uri": self.redirectUri,
        @"response_type": @"token"
    };
    
    return [[self authorizeApi:@"authorize"] urlByAppendingDict:params];
}

- (NSString *)api:(NSString *)apiPath
{
    return [kTencentWeiboSDKAPIDomain stringByAppendingString:apiPath];
}

- (NSString *)authorizeApi:(NSString *)apiPath
{
    return [kTencentWeiboSDKOAuth2APIDomain stringByAppendingString:apiPath];
}

- (BOOL)isAuthorized
{
    return self.isExpired && self.access_token && self.openid;
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
    
    [[ServiceShare sharedInstance] showAuthorizeBoard:[TencentWeiboAuthorizeBoard class]];
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
	
    [[TencentWeiboState sharedInstance] clear];
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
    
    self.nick = nil;
    self.name = nil;
    self.state = nil;
    self.openid = nil;
    self.openkey = nil;
    self.expires_in = nil;
    self.access_token = nil;
    self.refresh_token = nil;
    
    INFO( @"ServiceShare : Remove the auth data." );
}

- (void)restoreAuthData
{
    NSDictionary * auth = [[self userDefaultsRead:@"auth"] objectFromJSONString];
    
    if ( auth )
    {
        self.nick = [auth objectForKey:@"nick"];
        self.name = [auth objectForKey:@"name"];
        self.state = [auth objectForKey:@"state"];
        self.openid = [auth objectForKey:@"openid"];
        self.openkey = [auth objectForKey:@"openkey"];
        self.expires_in = [auth objectForKey:@"expires_in"];
        self.access_token = [auth objectForKey:@"access_token"];
        self.refresh_token = [auth objectForKey:@"refresh_token"];
    }
}

#pragma mark - controller

- (void)handleFailedMessage:(BeeMessage *)msg
{
    INFO( @"ServiceShare: %@",  msg.responseString );
    
    TencentWeiboError * tError = [TencentWeiboError objectFromString:msg.responseString];
    
    ServiceShareError * error = [ServiceShareError errorWithCode:tError.errcode
                                                            desc:tError.msg
                                                          domain:[NSString stringWithFormat:@"TencentWeibo: %@", tError.seqid]];
    
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
        if ( 0 == [[msg.responseJSONDictionary objectForKey:@"errcode"] integerValue] )
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
        NSString * auth = msg.GET_INPUT( @"auth" );
        
        [self saveAuthData:[auth JSONString]];
        
        [self postNotification:self.AUTHORIZE_SUCCESS];
        
        // get the action next to do
        SEL action = [TencentWeiboState sharedInstance].currentAction;
        // if the action is existing, do it, or post the notification
        if ( action && [self respondsToSelector:action] )
        {
            if ( sel_isEqual(action, @selector(shareWithText:image:)) )
            {
                [self shareWithText:[TencentWeiboState sharedInstance].text image:[TencentWeiboState sharedInstance].image];
            }
            else if ( sel_isEqual(action, @selector(shareWithText:imageUrl:)) )
            {
                [self shareWithText:[TencentWeiboState sharedInstance].text imageUrl:[TencentWeiboState sharedInstance].image];
            }
            else if ( sel_isEqual(action, @selector(shareWithText:)) )
            {
                [self shareWithText:[TencentWeiboState sharedInstance].text];
            }
            else
            {
                [self postNotification:self.FAILURE];
            }
        }
        else
        {
            // if no more action, it must be success for authorizing.
            [self postNotification:self.SUCCESS];
        }

        msg.succeed = YES;
        
        return;
	}
	else if ( msg.succeed )
	{
    }
	else if ( msg.failed )
	{
        [self handleFailedMessage:msg];
	}
	else if ( msg.cancelled )
	{
	}
}

- (void)t_add:(BeeMessage *)msg
{    
    if ( msg.sending )
	{   
        msg
        .POST( [self api:@"t/add"] )
        .PARAM( @"oauth_consumer_key", self.appKey )
        .PARAM( @"access_token", self.access_token )
        .PARAM( @"openid", self.openid )
        .PARAM( @"clientip", @"10.0.0.1" )
        .PARAM( @"oauth_version", @"2.a" )
        .PARAM( @"scope", @"all" )
        .PARAM( @"format", @"json" )
        .PARAM( @"content", msg.GET_INPUT(@"content") )
        .postFormat = ASIURLEncodedPostFormat
        ;
    }
}

- (void)t_add_multi:(BeeMessage *)msg
{
    if ( msg.sending )
	{
        msg
        .POST( [self api:@"t/add_multi"] )
        .PARAM( @"oauth_consumer_key", self.appKey )
        .PARAM( @"access_token", self.access_token )
        .PARAM( @"openid", self.openid )
        .PARAM( @"clientip", @"10.0.0.1" )
        .PARAM( @"oauth_version", @"2.a" )
        .PARAM( @"scope", @"all" )
        .PARAM( @"format", @"json" )
        .PARAM( @"content", msg.GET_INPUT(@"content") )
        .PARAM( @"pic_url", msg.GET_INPUT( @"url" ) )
        .postFormat = ASIURLEncodedPostFormat
        ;
    }
}

- (void)t_add_pic:(BeeMessage *)msg
{
    if ( msg.sending )
	{
        msg
        .POST( [self api:@"t/add_pic"] )
        .PARAM( @"oauth_consumer_key", [TencentWeiboApi sharedInstance].appKey )
        .PARAM( @"access_token", self.access_token )
        .PARAM( @"openid", self.openid )
        .PARAM( @"clientip", @"10.0.0.1" )
        .PARAM( @"oauth_version", @"2.a" )
        .PARAM( @"scope", @"all" )
        .PARAM( @"format", @"json" )
        .PARAM( @"content", msg.GET_INPUT(@"content") )
        .FILE_PNG( @"pic", msg.GET_INPUT( @"pic" ) )
        .postFormat = ASIURLEncodedPostFormat
        ;
    }
}

- (void)t_add_pic_url:(BeeMessage *)msg
{
    if ( msg.sending )
	{
        msg
        .POST( [self api:@"t/add_pic_url"] )
        .PARAM( @"oauth_consumer_key", [TencentWeiboApi sharedInstance].appKey )
        .PARAM( @"access_token", self.access_token )
        .PARAM( @"openid", self.openid )
        .PARAM( @"clientip", @"10.0.0.1" )
        .PARAM( @"oauth_version", @"2.a" )
        .PARAM( @"scope", @"all" )
        .PARAM( @"format", @"json" )
        .PARAM( @"content", msg.GET_INPUT(@"content") )
        .PARAM( @"pic_url", msg.GET_INPUT( @"url" ) )
        .postFormat = ASIURLEncodedPostFormat
        ;
    }
}

@end

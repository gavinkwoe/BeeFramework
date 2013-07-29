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
//  QQWeiboApi.m
//  BeeSNS
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "QQWeiboApi.h"

#pragma mark -

@implementation QQWeibo

DEF_SINGLETON( QQWeibo )

DEF_MESSAGE( user_info )
DEF_MESSAGE( signin )

+ (NSString *)authorizeUrl
{
    NSDictionary * params = @{
                              @"client_id": kQQAppKey,
                              @"redirect_uri": kQQAppRedirectURI,
                              @"response_type": @"token"
                              };
    
    NSString * url = kQQWeiboWebAuthURL;
    
    return [url urlByAppendingDict:params];
}

- (NSString *)url
{
	return @"https://open.t.qq.com/api/";
}

#pragma mark -

- (void)signin:(BeeMessage *)msg
{
    if ( msg.sending )
	{
        [self postNotification:BeeShareApi.SIGNIN_DID_SUCCESS withObject:self];
        return;
    }
	else if ( msg.succeed )
	{
	}
	else if ( msg.failed )
	{
        
	}
	else if ( msg.cancelled )
	{
	}
}

- (void)user_info:(BeeMessage *)msg
{
    if ( msg.sending )
	{
//        NSString * string = @"https://open.t.qq.com/api/REQUEST_METHOD?oauth_consumer_key=APP_KEY&access_token=ACCESSTOKEN&openid=OPENID&clientip=CLIENTIP&oauth_version=2.a&scope=all";
        msg
        .GET( self.url.APPEND( @"user/info" ) )
        .PARAM( @"access_token", [QQWeiboStorage sharedInstance].auth.access_token )
        .PARAM( @"openid", [QQWeiboStorage sharedInstance].auth.openid )
        .PARAM( @"oauth_consumer_key", kQQAppKey )
        .PARAM( @"clientip", @"10.0.0.0" )
        .PARAM( @"oauth_version", @"2.a" )
        .PARAM( @"scope", @"all" )
        .PARAM( @"format", @"json" )
        ;
    }
	else if ( msg.succeed )
	{
        
	}
	else if ( msg.failed )
	{
        
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - BeeShareApiProtocol

- (void)setup
{
    
    [[QQWeiboStorage sharedInstance] unserialize];
    QQWeiboAuth * auth = [QQWeiboStorage sharedInstance].auth;
    
    if ( auth )
    {
        [self restoreAuthData:auth];
    }
    
    self.authorizeBoardClazz = [QQAuthorizeBoard class];
    self.title = @"QQ 微博";
}

- (void)logout
{
    [super logout];
    
    _auth = nil;
    
    // remove auth data
    [[QQWeiboStorage sharedInstance] removeStorge];
}

- (BOOL)isLogined
{
    return _auth.openid && _auth.access_token && _auth.expires_in;
}

- (BOOL)isExpired
{
    NSDate * now = [NSDate date];
    return ( [now compare:[BeeShareApi dateWithString:_auth.expires_in]] == NSOrderedDescending );
}

- (void)restoreAuthData:(id)authData
{
    _auth = authData;
}

@end

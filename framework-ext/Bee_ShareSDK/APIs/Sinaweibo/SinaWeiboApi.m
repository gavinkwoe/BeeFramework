//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_/_/_/_/_/ 
//
//	Powered by BeeFramework
//
//
//  SinaWeiboApi.m
//  BeeSNS
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//
#import "SinaWeiboApi.h"
#import "SinaWeiboModel.h"

#pragma mark -

@implementation SinaWeibo

@synthesize context = _context;

DEF_SINGLETON( SinaWeibo )

DEF_MESSAGE( oauth2_access_token )
DEF_MESSAGE( users_show )
DEF_MESSAGE( statuses_update )
DEF_MESSAGE( statuses_upload )

+ (NSString *)authorizeUrl
{
    NSDictionary * params = @{
                              @"client_id": kSinaAppKey,
                              @"redirect_uri": kSinaAppRedirectURI,
                              @"display": @"mobile",
                              @"response_type": @"code"
                             };
    
    return [kSinaWeiboWebAuthURL urlByAppendingDict:params];
}

- (NSString *)url
{
	return @"https://api.weibo.com/";
}

- (void)oauth2_access_token:(BeeMessage *)msg
{
    if ( msg.sending )
	{
        NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                                 kSinaAppKey, @"client_id",
                                 kSinaAppSecret, @"client_secret",
                                 kSinaAppRedirectURI, @"redirect_uri",
                                 @"authorization_code", @"grant_type",
                                 msg.GET_INPUT(@"code"), @"code", nil];

        msg.POST( [kSinaWeiboWebAccessTokenURL urlByAppendingDict:params] ).BODY( params );
	}
	else if ( msg.succeed )
	{
        SinaWeiboAuth * auth = \
        [SinaWeiboAuth objectFromString:msg.responseString];
        [SinaWeiboStorage sharedInstance].auth = auth;
        
        if ( auth )
        {
            [self restoreAuthData:auth];
            [[SinaWeiboStorage sharedInstance] serialize];
            [self postNotification:BeeShareApi.SIGNIN_DID_SUCCESS withObject:self];
        }
        
    }
	else if ( msg.failed )
	{
        [self postNotification:BeeShareApi.SIGNIN_DID_FAILED];
        CC( @"Sina get access token failed." );
	}
	else if ( msg.cancelled )
	{
	}
}

- (void)users_show:(BeeMessage *)msg
{
    if ( msg.sending )
	{
        msg
        .GET( self.url.APPEND( @"users/show.json" ) )
        .PARAM( @"access_token", [SinaWeiboStorage sharedInstance].auth.access_token )
        .PARAM( @"uid", [SinaWeiboStorage sharedInstance].auth.uid )
        ;
    }
	else if ( msg.succeed )
	{
        SinaWeiboUser * user = [SinaWeiboUser objectFromString:msg.responseString];
        [SinaWeiboStorage sharedInstance].user = user;
        [[SinaWeiboStorage sharedInstance] serialize];
	}
	else if ( msg.failed )
	{
        
	}
	else if ( msg.cancelled )
	{
	}
}

- (void)statuses_update:(BeeMessage *)msg
{
    if ( msg.sending )
	{
        
        NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [SinaWeiboStorage sharedInstance].auth.access_token, @"access_token",
                                 @"Hello".URLEncoding, @"status", nil];

        NSString * url = [kSinaWeiboStatusesURL urlByAppendingDict:params];
        msg
        .POST( url )
        .PARAM( @"status", @"Hello".URLEncoding )
        .PARAM( @"access_token", [SinaWeiboStorage sharedInstance].auth.access_token )
//        .BODY( params )
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
    
    [[SinaWeiboStorage sharedInstance] unserialize];
    SinaWeiboAuth * auth = [SinaWeiboStorage sharedInstance].auth;
    
    if ( auth )
    {
        [self restoreAuthData:auth];
    }
    
    self.authorizeBoardClazz = [SinaAuthorizeBoard class];
}

- (void)logout
{
    [super logout];
    
    _auth = nil;
    
    // remove auth data
    [[SinaWeiboStorage sharedInstance] removeStorge];
}

- (BOOL)isLogined
{
    return _auth.uid && _auth.access_token && _auth.expires_in;
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

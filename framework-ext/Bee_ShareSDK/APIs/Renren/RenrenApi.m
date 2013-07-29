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
//  RenrenApi.m
//  BeeSNS
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "RenrenApi.h"

#pragma mark -

@implementation Renren

DEF_SINGLETON( Renren )
DEF_MESSAGE( users_getLoggedInUser )

+ (NSString *)authorizeUrl
{
    NSDictionary * params = @{
                              @"client_id": kRenrenAppKey,
                              @"redirect_uri": kRenrenAppRedirectURI,
                              @"response_type": @"token"
                              };
    
    NSString * url = kAuthBaseURL;
    
    return [url urlByAppendingDict:params];
}

- (NSString *)url
{
	return @"https://api.renren.com/restserver.do";
}

#pragma mark - BeeShareApiProtocol

- (void)setup
{
    [[RenrenStorage sharedInstance] unserialize];
    RenrenAuth * auth = [RenrenStorage sharedInstance].auth;
    
    if ( auth )
    {
        [self restoreAuthData:auth];
    }
    
    self.authorizeBoardClazz = [RenrenAuthorizeBoard class];
    self.title = @"人人";
}

- (void)logout
{

    [super logout];

    _auth = nil;
    
    // remove auth data
    [[RenrenStorage sharedInstance] removeStorge];
}

- (BOOL)isLogined
{
    return _auth.access_token && _auth.expires_in;
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

- (NSString *)call_id
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

#pragma mark - Messages

- (void)users_getLoggedInUser:(BeeMessage *)msg
{
    if ( msg.sending )
	{
        NSDictionary * params = @{
                                             @"v": @"3.0",
                                  @"access_token": [RenrenStorage sharedInstance].auth.access_token,
                                        @"format": @"json",
                                       @"call_id": [self call_id],
                                        @"method": @"users.getLoggedInUser"
                                 };
                                  
        msg.POST( [[self url] urlByAppendingDict:params] ).BODY( params );
	}
	else if ( msg.succeed )
	{
        
        NSString * error_code = [msg.responseJSONDictionary objectForKey:@"error_code"];
        if ( error_code )
        {
            msg.failed =YES;
            msg.succeed = NO;
            msg.errorCode = error_code.integerValue;
            msg.errorDesc = [msg.responseJSONDictionary objectForKey:@"error_msg"];
            return;
        }
        else
        {
            RenrenAuth * auth = [RenrenStorage sharedInstance].auth;
            auth.uid = [msg.responseJSONDictionary objectForKey:@"uid"];
            
            if ( auth.uid )
            {
                [RenrenStorage sharedInstance].auth = auth;
                [[RenrenStorage sharedInstance] serialize];
                
                [self restoreAuthData:auth];
                [self postNotification:BeeShareApi.SIGNIN_DID_SUCCESS withObject:self];
            }
        }
    }
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

@end

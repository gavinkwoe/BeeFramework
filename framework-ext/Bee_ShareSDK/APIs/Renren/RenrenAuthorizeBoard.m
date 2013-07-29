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
//  RenrenAuthBoard.m
//  BeeSNS
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "RenrenAuthorizeBoard.h"
#import "RenrenApi.h"

#pragma mark -

@implementation RenrenAuthorizeBoard

- (NSString *)authorizeUrl
{
    return [Renren authorizeUrl];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
//    http://graph.renren.com/oauth/login_success.html#access_token=233134|6.8656c5104e58c72056600e7385607f99.2592000.1369641600-521801830&expires_in=2594812

    NSString *urlString = request.URL.absoluteString;

    CC(@"url = %@", urlString);
    
    NSURL * url = request.URL;
    
    NSString *query = [url fragment]; // url中＃字符后面的部分。
    if ( !query )
    {
        query = [url query];
    }
    
    NSDictionary * params = [BeeShareApi dictionaryWtihURLParams:query];
    
    NSString * access_token = ((NSString *)[params objectForKey:@"access_token"]).URLDecoding;
    NSString * error_reason = [params objectForKey:@"error"];
    
    if( error_reason )
    {
        [self hide];
        [self sendUISignal:BeeShareApi.SIGNIN_DID_CANCEL];
        return NO;
    }
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        BOOL userDidCancel = ( ( error_reason && [error_reason isEqualToString:@"login_denied"] )
                              || [error_reason isEqualToString:@"access_denied"] );
        if( userDidCancel )
        {
            [self sendUISignal:BeeShareApi.SIGNIN_DID_CANCEL];
        }
        else
        {
            NSString *q = [url absoluteString];
            
            if (![q hasPrefix:kAuthBaseURL])
            {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
        }
        return NO;
    }
    
    if ( navigationType == UIWebViewNavigationTypeFormSubmitted )
    {
        NSString *state = [params objectForKey:@"flag"];
        
        if ( ( state && [state isEqualToString:@"success"] ) || access_token )
        {
            NSString * expires_in = [params objectForKey:@"expires_in"];            
            RenrenAuth * auth = [[RenrenAuth alloc] init];
            auth.access_token = access_token;
            auth.expires_in = expires_in;
            
            [RenrenStorage sharedInstance].auth = auth;
            [[RenrenStorage sharedInstance] serialize];
            [auth release];
          
            [self hide];

            self.MSG( [Renren users_getLoggedInUser] );
        }
    }
    
    return YES;
}

@end

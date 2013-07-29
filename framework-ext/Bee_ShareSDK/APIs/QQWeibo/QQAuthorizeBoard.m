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
//  AuthorizeBoard.m
//  BeeSNS
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "QQAuthorizeBoard.h"
#import "QQWeiboApi.h"

#pragma mark -

@implementation QQAuthorizeBoard

- (NSString *)authorizeUrl
{
    return [QQWeibo authorizeUrl];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * url = [[NSString alloc] initWithString:request.URL.absoluteString];
    
    NSString *siteRedirectURI = [NSString stringWithFormat:@"%@%@", kQQWeiboSDKOAuth2APIDomain, kQQAppRedirectURI];
    
    if ([url hasPrefix:kQQAppRedirectURI] || [url hasPrefix:siteRedirectURI])
    {
        QQWeiboAuth * auth = [[QQWeiboAuth alloc] init];
        
        auth.access_token = [BeeShareApi paramValueFromUrl:url paramName:@"access_token"];
        auth.openid = [BeeShareApi paramValueFromUrl:url paramName:@"openid"];
        auth.openkey = [BeeShareApi paramValueFromUrl:url paramName:@"openkey"];
        auth.expires_in = [BeeShareApi paramValueFromUrl:url paramName:@"expires_in"];

        [QQWeiboStorage sharedInstance].auth = auth;
        [[QQWeiboStorage sharedInstance] serialize];
        
        [self hide];
    
        self.MSG( QQWeibo.signin );
    }
    
    return YES;
}

@end

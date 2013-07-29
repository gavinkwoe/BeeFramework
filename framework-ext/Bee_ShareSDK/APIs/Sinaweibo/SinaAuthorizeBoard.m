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

#import "SinaAuthorizeBoard.h"
#import "SinaWeiboApi.h"

#pragma mark -

@implementation SinaAuthorizeBoard

- (NSString *)authorizeUrl
{
    return [SinaWeibo authorizeUrl];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSLog(@"url = %@", url);
    
    NSString *siteRedirectURI = [NSString stringWithFormat:@"%@%@", kSinaWeiboSDKOAuth2APIDomain, kSinaAppRedirectURI];
    
    if ([url hasPrefix:kSinaAppRedirectURI] || [url hasPrefix:siteRedirectURI])
    {
        NSString *error_code = [BeeShareApi paramValueFromUrl:url paramName:@"error_code"];
        
        if (error_code)
        {
            NSString *error = [BeeShareApi paramValueFromUrl:url paramName:@"error"];
            NSString *error_uri = [BeeShareApi paramValueFromUrl:url paramName:@"error_uri"];
            NSString *error_description = [BeeShareApi paramValueFromUrl:url paramName:@"error_description"];
            
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       error, @"error",
                                       error_uri, @"error_uri",
                                       error_code, @"error_code",
                                       error_description, @"error_description", nil];
            
            [self hide];
            
            CC( errorInfo );
        }
        else
        {
            NSString *code = [SinaWeibo paramValueFromUrl:url paramName:@"code"];
            if (code)
            {
                self.MSG( SinaWeibo.oauth2_access_token ).INPUT( @"code", code );
                [self hide];
            }
        }
        
        return NO;
    }
    
    return YES;
}

@end

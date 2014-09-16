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
//  SinaWeiboAuthorizeBoard.m
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "SinaWeiboAuthorizeBoard.h"

#pragma mark -

@interface SinaWeiboAuthorizeBoard()
{
	//<#@private var#>
}
@end

@implementation SinaWeiboAuthorizeBoard

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

- (NSString *)authorizeURL
{
    return [SinaWeiboApi sharedInstance].authorizeURL;
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * url = request.URL.absoluteString;
    INFO( @"url = %@", url );
    
    NSString * siteRedirectURI = [NSString stringWithFormat:@"%@%@", kSinaWeiboSDKOAuth2APIDomain, [SinaWeiboApi sharedInstance].redirectUri];

    if ([url hasPrefix:[SinaWeiboApi sharedInstance].redirectUri] || [url hasPrefix:siteRedirectURI])
    {
        NSString * error_code = [SinaWeiboApi paramValueFromUrl:url paramName:@"error_code"];

        if (error_code)
        {
            NSString *error_uri = [SinaWeiboApi paramValueFromUrl:url paramName:@"error_uri"];
            NSString *error_description = [SinaWeiboApi paramValueFromUrl:url paramName:@"error_description"];

            ServiceShareError * error = [ServiceShareError errorWithCode:error_code
                                                                    desc:error_description
                                                                  domain:error_uri];
            
            [self postNotification:ServiceShareApi.FAILURE withObject:error];
            
            CC( [error description] );
        }
        else
        {
            NSString *code = [SinaWeiboApi paramValueFromUrl:url paramName:@"code"];
            if (code)
            {   
                self.MSG( [SinaWeiboApi sharedInstance].oauth2_access_token ).INPUT( @"code", code );
            }
        }
    
        return NO;
    }
    
    return YES;
}

@end

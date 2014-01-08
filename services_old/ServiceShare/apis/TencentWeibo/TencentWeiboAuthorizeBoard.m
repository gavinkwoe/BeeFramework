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
//  TencentWeiboAuthorizeBoard.m
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "TencentWeiboAuthorizeBoard.h"

#pragma mark -

@interface TencentWeiboAuthorizeBoard()
{
	//<#@private var#>
}
@end

@implementation TencentWeiboAuthorizeBoard

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
    return [TencentWeiboApi sharedInstance].authorizeURL;
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * url = request.URL.absoluteString;
    INFO( @"url = %@", url );
    
    NSString * siteRedirectURI = [NSString stringWithFormat:@"%@%@", kTencentWeiboSDKOAuth2APIDomain, [TencentWeiboApi sharedInstance].redirectUri];
    
    if ([url hasPrefix:[TencentWeiboApi sharedInstance].redirectUri] || [url hasPrefix:siteRedirectURI])
    {
        NSMutableDictionary * auth = [NSMutableDictionary dictionaryWithDictionary:[TencentWeiboApi dictionaryWtihURLString:url]];
        double expires_in = [[auth objectForKey:@"expires_in"] intValue] + [[NSDate date] timeIntervalSince1970];
        [auth setObject:[NSNumber numberWithDouble:expires_in] forKey:@"expires_in"];
        
        self.MSG( [TencentWeiboApi sharedInstance].oauth2_access_token ).INPUT( @"auth", auth );
    }
    
    return YES;
}

@end

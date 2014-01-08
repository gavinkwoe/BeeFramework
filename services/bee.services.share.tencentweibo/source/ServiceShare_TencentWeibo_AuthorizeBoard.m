//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceShare_TencentWeibo_AuthorizeBoard.h"
#import "ServiceShare_TencentWeibo_Config.h"
#import "ServiceShare_TencentWeibo.h"
#import "ServiceShare_Utility.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceShare_TencentWeibo_AuthorizeBoard

#pragma mark -

- (void)load
{
	self.authorizeURL = [[ServiceShare_TencentWeibo_Config sharedInstance] authorizeURL];
}

- (void)unload
{
}

#pragma mark -

ON_SIGNAL3( BeeUIWebView, WILL_START, signal )
{
	SIGNAL_FORWARD( signal );
	
	ServiceShare_TencentWeibo * service = [ServiceShare_TencentWeibo sharedInstance];
	
	NSString * redirectURI = service.config.redirectURI;
	NSString * siteRedirectURI = service.config.siteRedirectURI;

	NSString * url = self.web.loadingURL;
    
	if ( [url hasPrefix:redirectURI] || [url hasPrefix:siteRedirectURI] )
    {
        NSDictionary *	auth = [ServiceShare_Utility dictionaryWtihURLString:url];
		NSNumber *		expires_sec = [auth objectForKey:@"expires_in"];
		double			expires_in = expires_sec.doubleValue + [[NSDate date] timeIntervalSince1970];

		service.openid = [auth objectForKey:@"openid"];
		service.openkey = [auth objectForKey:@"openkey"];
		service.accessToken = [auth objectForKey:@"access_token"];
		service.refreshToken = [auth objectForKey:@"refresh_token"];
		service.expiresIn = [NSNumber numberWithDouble:expires_in];

		[service notifyAuthSucceed];

		signal.RETURN_NO();
    }
	else
	{
		signal.RETURN_YES();
	}
}

ON_SIGNAL3( BeeUIWebView, DID_START, signal )
{
	SIGNAL_FORWARD( signal );
}

ON_SIGNAL3( BeeUIWebView, DID_FINISH, signal )
{
	SIGNAL_FORWARD( signal );
}

ON_SIGNAL3( BeeUIWebView, DID_FAILED, signal )
{
	SIGNAL_FORWARD( signal );
	
	ServiceShare_TencentWeibo * service = [ServiceShare_TencentWeibo sharedInstance];
	service.errorCode = @"0";
	service.errorMsg = @"Unknown error";
	service.errorSeqId = @"";
	[service notifyAuthFailed];
}

ON_SIGNAL3( BeeUIWebView, DID_LOAD_CANCELLED, signal )
{
	SIGNAL_FORWARD( signal );
	
//	ServiceShare_TencentWeibo * service = [ServiceShare_TencentWeibo sharedInstance];
//	[service notifyAuthCancelled];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

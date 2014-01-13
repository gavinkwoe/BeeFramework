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

#import "ServiceShare_SinaWeibo_Config.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

#define kSinaWeiboSDKAPIDomain          @"https://api.weibo.com/2/"
#define kSinaWeiboSDKOAuth2APIDomain    @"https://api.weibo.com/oauth2/"

#pragma mark -

@implementation ServiceShare_SinaWeibo_Config

DEF_SINGLETON( ServiceShare_SinaWeibo_Config )

@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize redirectURI = _redirectURI;

- (NSString *)siteRedirectURI
{
	NSAssert( self.appKey, @"You should set the redirectURI first" );
	
	return [self authorizeURL:self.redirectURI];
}

- (NSString *)authorizeURL
{
	NSAssert( self.appKey, @"You should set the appKey first" );

    NSDictionary * params = @{
		@"display"			: @"mobile",
		@"response_type"	: @"code",
		@"redirect_uri"		: self.redirectURI,
		@"client_id"		: self.appKey
	};

    return [[self authorizeURL:@"authorize"] urlByAppendingDict:params];
}

- (NSString *)authorizeURL:(NSString *)apiPath
{
	return [kSinaWeiboSDKOAuth2APIDomain stringByAppendingString:apiPath];
}

- (NSString *)apiURL:(NSString *)apiPath
{
	return [kSinaWeiboSDKAPIDomain stringByAppendingString:apiPath];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

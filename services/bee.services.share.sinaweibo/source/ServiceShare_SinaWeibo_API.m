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

#import "ServiceShare_SinaWeibo.h"
#import "ServiceShare_SinaWeibo_API.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation SINAWEIBO_OAUTH2_ACCESS_TOKEN

@synthesize code = _code;

- (void)routine
{
	ServiceShare_SinaWeibo * service = [ServiceShare_SinaWeibo sharedInstance];
	
    if ( self.sending )
	{
        NSString * grant_type = @"authorization_code";
        NSString * scope = @"all";
		
        self
        .POST( [service.config authorizeURL:@"access_token"] )
        .PARAM( @"client_id", service.config.appKey )
        .PARAM( @"client_secret", service.config.appSecret )
        .PARAM( @"redirect_uri", service.config.redirectURI )
        .PARAM( @"grant_type", grant_type )
        .PARAM( @"scope", scope )
        .PARAM( @"code", self.code )
        .postFormat = ASIURLEncodedPostFormat;
	}
	else if ( self.succeed )
	{
		NSNumber * errorCode = [self.responseJSONDictionary objectForKey:@"error_code"];
		if ( nil == errorCode )
		{
			NSNumber *	expires_sec = [self.responseJSONDictionary objectForKey:@"expires_in"];
			double		expires_in = expires_sec.doubleValue + [[NSDate date] timeIntervalSince1970];
			
			service.accessToken = [self.responseJSONDictionary objectForKey:@"access_token"];
			service.expiresIn = [NSNumber numberWithDouble:expires_in];
			service.remindIn = [self.responseJSONDictionary objectForKey:@"remind_in"];
			service.uid = [self.responseJSONDictionary objectForKey:@"uid"];
			
			[service notifyAuthSucceed];
		}
		else
		{
			service.errorCode = [errorCode asNSString];
			service.errorDesc = [self.responseJSONDictionary objectForKey:@"error"];
			service.errorURI = [self.responseJSONDictionary objectForKey:@"request"];
			
			[service notifyAuthFailed];
		}
    }
	else if ( self.failed )
	{
		service.errorCode = [self.responseJSONDictionary objectForKey:@"error_code"];
		service.errorDesc = [self.responseJSONDictionary objectForKey:@"error"];
		service.errorURI = [self.responseJSONDictionary objectForKey:@"request"];

		[service notifyAuthFailed];
	}
	else if ( self.cancelled )
	{
		[service notifyAuthCancelled];
	}
}

@end

#pragma mark -

@implementation SINAWEIBO_STATUSES_UPDATE

@synthesize text = _text;

- (void)routine
{
	ServiceShare_SinaWeibo * service = [ServiceShare_SinaWeibo sharedInstance];
	
    if ( self.sending )
	{
        self
        .POST( [service.config apiURL:@"statuses/update.json"] )
        .PARAM( @"access_token", service.accessToken )
        .PARAM( @"status", self.text )
        .postFormat = ASIURLEncodedPostFormat;
    }
	else if ( self.succeed )
	{
		[service notifyShareSucceed];
	}
	else if ( self.failed )
	{
		service.errorCode = [self.responseJSONDictionary objectForKey:@"error_code"];
		service.errorDesc = [self.responseJSONDictionary objectForKey:@"error"];
		service.errorURI = [self.responseJSONDictionary objectForKey:@"request"];

		[service notifyShareFailed];
	}
	else if ( self.cancelled )
	{
		[service notifyShareCancelled];
	}
}

@end

#pragma mark -

@implementation SINAWEIBO_STATUSES_UPLOAD

@synthesize text = _text;
@synthesize photo = _photo;

- (void)routine
{
	ServiceShare_SinaWeibo * service = [ServiceShare_SinaWeibo sharedInstance];
	
    if ( self.sending )
	{
        self
        .POST( [service.config apiURL:@"statuses/upload.json"] )
        .PARAM( @"access_token", service.accessToken )
        .PARAM( @"status", self.text )
        .FILE_PNG( @"pic", self.photo )
        .postFormat = ASIURLEncodedPostFormat;
    }
	else if ( self.succeed )
	{
		[service notifyShareSucceed];
	}
	else if ( self.failed )
	{
		service.errorCode = [self.responseJSONDictionary objectForKey:@"error_code"];
		service.errorDesc = [self.responseJSONDictionary objectForKey:@"error"];
		service.errorURI = [self.responseJSONDictionary objectForKey:@"request"];

		[service notifyShareFailed];
	}
	else if ( self.cancelled )
	{
		[service notifyShareCancelled];
	}
}

@end

#pragma mark -

@implementation SINAWEIBO_STATUSES_UPLOAD_URL_TEXT

@synthesize text = _text;
@synthesize photoURL = _photoURL;

- (void)routine
{
	ServiceShare_SinaWeibo * service = [ServiceShare_SinaWeibo sharedInstance];
	
    if ( self.sending )
	{
        self
        .POST( [service.config apiURL:@"statuses/upload_url_text.json"] )
        .PARAM( @"access_token", service.accessToken )
        .PARAM( @"status", self.text )
        .PARAM( @"url", self.photoURL );
    }
	else if ( self.succeed )
	{
		[service notifyShareSucceed];
	}
	else if ( self.failed )
	{
		service.errorCode = [self.responseJSONDictionary objectForKey:@"error_code"];
		service.errorDesc = [self.responseJSONDictionary objectForKey:@"error"];
		service.errorURI = [self.responseJSONDictionary objectForKey:@"request"];

		[service notifyShareFailed];
	}
	else if ( self.cancelled )
	{
		[service notifyShareCancelled];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

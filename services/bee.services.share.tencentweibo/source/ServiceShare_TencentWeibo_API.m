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

#import "ServiceShare_TencentWeibo.h"
#import "ServiceShare_TencentWeibo_API.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation TENCENTWEIBO_T_ADD

@synthesize text = _text;

- (void)routine
{
	ServiceShare_TencentWeibo * service = [ServiceShare_TencentWeibo sharedInstance];
	
    if ( self.sending )
	{
		self
        .POST( [service.config apiURL:@"t/add"] )
        .PARAM( @"oauth_consumer_key", service.config.appKey )
        .PARAM( @"access_token", service.accessToken )
        .PARAM( @"openid", service.openid )
        .PARAM( @"clientip", @"10.0.0.1" )
        .PARAM( @"oauth_version", @"2.a" )
        .PARAM( @"scope", @"all" )
        .PARAM( @"format", @"json" )
        .PARAM( @"content", self.text )
        .postFormat = ASIURLEncodedPostFormat;
    }
	else if ( self.succeed )
	{
		[service notifyShareSucceed];
	}
	else if ( self.failed )
	{
		service.errorMsg = [self.responseJSONDictionary objectForKey:@"msg"];
		service.errorSeqId = [self.responseJSONDictionary objectForKey:@"seqid"];
		service.errorCode = [self.responseJSONDictionary objectForKey:@"errcode"];

		[service notifyShareFailed];
	}
	else if ( self.cancelled )
	{
		[service notifyShareCancelled];
	}
}

@end

#pragma mark -

@implementation TENCENTWEIBO_T_ADD_PIC

@synthesize text = _text;
@synthesize photo = _photo;

- (void)routine
{
	ServiceShare_TencentWeibo * service = [ServiceShare_TencentWeibo sharedInstance];
	
    if ( self.sending )
	{
        self
        .POST( [service.config apiURL:@"t/add_pic"] )
        .PARAM( @"oauth_consumer_key", service.config.appKey )
        .PARAM( @"access_token", service.accessToken )
        .PARAM( @"openid", service.openid )
        .PARAM( @"clientip", @"10.0.0.1" )
        .PARAM( @"oauth_version", @"2.a" )
        .PARAM( @"scope", @"all" )
        .PARAM( @"format", @"json" )
        .PARAM( @"content", self.text )
        .FILE_PNG( @"pic", self.photo )
        .postFormat = ASIURLEncodedPostFormat;
    }
	else if ( self.succeed )
	{
		[service notifyShareSucceed];
	}
	else if ( self.failed )
	{
		service.errorMsg = [self.responseJSONDictionary objectForKey:@"msg"];
		service.errorSeqId = [self.responseJSONDictionary objectForKey:@"seqid"];
		service.errorCode = [self.responseJSONDictionary objectForKey:@"errcode"];

		[service notifyShareFailed];
	}
	else if ( self.cancelled )
	{
		[service notifyShareCancelled];
	}
}

@end

#pragma mark -

@implementation TENCENTWEIBO_T_ADD_MULTI

@synthesize text = _text;
@synthesize photoURL = _photoURL;

- (void)routine
{
	ServiceShare_TencentWeibo * service = [ServiceShare_TencentWeibo sharedInstance];
	
    if ( self.sending )
	{
        self
        .POST( [service.config apiURL:@"t/add_multi"] )
        .PARAM( @"oauth_consumer_key", service.config.appKey )
        .PARAM( @"access_token", service.accessToken )
        .PARAM( @"openid", service.openid )
        .PARAM( @"clientip", @"10.0.0.1" )
        .PARAM( @"oauth_version", @"2.a" )
        .PARAM( @"scope", @"all" )
        .PARAM( @"format", @"json" )
        .PARAM( @"content", self.text )
        .PARAM( @"pic_url", self.photoURL )
        .postFormat = ASIURLEncodedPostFormat;
    }
	else if ( self.succeed )
	{
		[service notifyShareSucceed];
	}
	else if ( self.failed )
	{
		service.errorMsg = [self.responseJSONDictionary objectForKey:@"msg"];
		service.errorSeqId = [self.responseJSONDictionary objectForKey:@"seqid"];
		service.errorCode = [self.responseJSONDictionary objectForKey:@"errcode"];

		[service notifyShareFailed];
	}
	else if ( self.cancelled )
	{
		[service notifyShareCancelled];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

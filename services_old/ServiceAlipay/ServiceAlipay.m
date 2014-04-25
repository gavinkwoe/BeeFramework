//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2013-2014, {Bee} open source community
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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "ServiceAlipay.h"
#import "AlixPay.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"

#pragma mark -

DEF_SERVICE( ServiceAlipay, alipay )

#pragma mark -

@interface ServiceAlipay()
- (void)notifyWaiting;
- (void)notifySucceed;
- (void)notifyFailed;
@end

#pragma mark -

@implementation ServiceAlipay

SERVICE_AUTO_LOADING( YES );

DEF_INT( ERROR_SUCCEED,		9000 )
DEF_INT( ERROR_SYS_ERROR,	4000 )
DEF_INT( ERROR_BAD_FORMAT,	4001 )
DEF_INT( ERROR_BAD_ACCOUNT,	4003 )
DEF_INT( ERROR_UNBINDED,	4004 )
DEF_INT( ERROR_CANNOT_BIND,	4005 )
DEF_INT( ERROR_CANNOT_PAY,	4006 )
DEF_INT( ERROR_EXPIRED,		4010 )
DEF_INT( ERROR_MAINTENANCE,	6000 )
DEF_INT( ERROR_USER_CANCEL,	6001 )

DEF_INT( ERROR_INVALID_DATA,	-1 )
DEF_INT( ERROR_INSTALL_ALIPAY,	-2 )
DEF_INT( ERROR_SIGNATURE,		-3 )

DEF_NOTIFICATION( WAITING )
DEF_NOTIFICATION( SUCCEED )
DEF_NOTIFICATION( FAILED )

@dynamic order;
@dynamic config;

@synthesize errorCode = _errorCode;
@synthesize errorDesc = _errorDesc;

@synthesize whenWaiting = _whenWaiting;
@synthesize whenSucceed = _whenSucceed;
@synthesize whenFailed = _whenFailed;

- (void)load
{
    [super load];
	
	[self observeNotification:BeeUIApplication.LAUNCHED];
	[self observeNotification:BeeUIApplication.TERMINATED];
	[self observeNotification:BeeUIApplication.STATE_CHANGED];
}

- (void)unload
{
	[self unobserveAllNotifications];

	self.whenWaiting = nil;
	self.whenSucceed = nil;
	self.whenFailed = nil;
	self.errorDesc = nil;
	
    [super unload];
}

- (void)notifyWaiting
{
	[self postNotification:ServiceAlipay.WAITING];
	
	if ( self.whenWaiting )
	{
		self.whenWaiting();
	}
}

- (void)notifySucceed
{
	[self postNotification:ServiceAlipay.SUCCEED];
	
	if ( self.whenSucceed )
	{
		self.whenSucceed();
	}
}

- (void)notifyFailed
{
	[self postNotification:ServiceAlipay.FAILED];
	
	if ( self.whenFailed )
	{
		self.whenFailed();
	}
}

- (ServiceAlipay_Order *)order
{
	return [ServiceAlipay_Order sharedInstance];
}

- (ServiceAlipay_Config *)config
{
	return [ServiceAlipay_Config sharedInstance];
}

- (BOOL)pay
{
	NSString * appSchema = [BeeSystemInfo appSchema:@"default"];
	if ( nil == appSchema )
	{
		appSchema = [BeeSystemInfo appSchema];
		if ( nil == appSchema )
		{
			ERROR( @"failed to retrieve application schema" );

			self.errorCode = self.ERROR_INVALID_DATA;
			self.errorDesc = @"订单数据无效";
			[self notifyFailed];
			return NO;
		}
	}

	NSString * order = [[ServiceAlipay_Order sharedInstance] generate];
	if ( nil == order )
	{
		ERROR( @"failed to create order" );

		self.errorCode = self.ERROR_INVALID_DATA;
		self.errorDesc = @"订单数据无效";
		[self notifyFailed];
		return NO;
	}

	AlixPay * alixpay = [AlixPay shared];
	if ( nil == alixpay )
	{
		ERROR( @"failed to get AlixPay instance" );

		self.errorCode = self.ERROR_INSTALL_ALIPAY;
		self.errorDesc = @"请先安装支付宝";
		[self notifyFailed];
		return NO;
	}
	
	int ret = [alixpay pay:order applicationScheme:appSchema];
	if ( ret == kSPErrorAlipayClientNotInstalled )
	{
		ERROR( @"install Alipay first" );

		self.errorCode = self.ERROR_INSTALL_ALIPAY;
		self.errorDesc = @"请先安装支付宝";
		[self notifyFailed];
		return NO;
	}
	else if ( ret == kSPErrorSignError )
	{
		ERROR( @"failed to sign" );

		self.errorCode = self.ERROR_SIGNATURE;
		self.errorDesc = @"签名错误，无法支付";
		[self notifyFailed];
		return NO;
	}

	INFO( @"Alipay, processing.." );

	[self notifyWaiting];
	return YES;
}

ON_NOTIFICATION3( BeeUIApplication, LAUNCHED, notification )
{
	NSURL * url = [(NSDictionary *)notification.object objectForKey:@"url"];
	if ( nil == url )
	{
		return;
	}

	AlixPay * alixpay = [AlixPay shared];
	if ( nil == alixpay )
	{
		ERROR( @"failed to get AlixPay instance" );
		
		self.errorCode = self.ERROR_INSTALL_ALIPAY;
		self.errorDesc = @"请先安装支付宝";
		[self notifyFailed];
		return;
	}
	
	AlixPayResult * result = [alixpay handleOpenURL:url];
	if ( result )
	{
		INFO( @"alipay, status = %d, %@", result.statusCode, result.statusMessage );
		
		self.errorCode = result.statusCode;
		self.errorDesc = result.statusMessage;

		[[ServiceAlipay_Order sharedInstance] clear];

		if ( 9000 == result.statusCode )
		{
			id<DataVerifier> verifier = CreateRSADataVerifier( [ServiceAlipay_Config sharedInstance].publicKey );
			if ( nil == verifier )
			{
				INFO( @"Alipay, failed to pay" );

				[self notifyFailed];
				return;
			}

			BOOL succeed = [verifier verifyString:result.resultString withSign:result.signString];
			if ( NO == succeed )
			{
				INFO( @"Alipay, invalid signature" );
				
				[self notifyFailed];
				return;
			}

			INFO( @"Alipay, succeed" );

			[self notifySucceed];
		}
		else
		{
			INFO( @"Alipay, failed to pay" );

			[self notifyFailed];
		}
	}
}

ON_NOTIFICATION3( BeeUIApplication, STATE_CHANGED, notification )
{
	if ( [BeeUIApplication sharedInstance].inForeground )
	{
		[[ServiceAlipay_Order sharedInstance] clear];
	}
}

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

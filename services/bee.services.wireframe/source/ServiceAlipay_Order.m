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

#import "ServiceAlipay_Order.h"
#import "ServiceAlipay_Config.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "AlixPay.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "DataSigner.h"

#pragma mark -

@implementation ServiceAlipay_Order

DEF_SINGLETON( ServiceAlipay_Order )

@synthesize no = _no;
@synthesize name = _name;
@synthesize desc = _desc;
@synthesize price = _price;

- (NSString *)generate
{	
	AlixPayOrder * order = [[[AlixPayOrder alloc] init] autorelease];

	order.partner	= [ServiceAlipay_Config sharedInstance].parnter;
	order.seller	= [ServiceAlipay_Config sharedInstance].seller;
	order.notifyURL	= [ServiceAlipay_Config sharedInstance].notifyURL;

	if ( self.no && self.no.length )
	{
		order.tradeNO = self.no;
	}
	else
	{
		order.tradeNO = [NSString stringWithFormat:@"%d", (int)[NSDate timeIntervalSinceReferenceDate]];
	}

	if ( self.name && self.name.length )
	{
		order.productName = self.name;
	}
	else
	{
		order.productName = @"unknown";
	}

	if ( self.desc && self.desc.length )
	{
		order.productDescription = self.desc;
	}
	else
	{
		order.productDescription = @"unknown";
	}

	if ( self.price && self.price.length )
	{
		order.amount = self.price;
	}
	else
	{
		order.amount = @"0.00";
	}

	NSString *		orderDesc = [order description];
	id<DataSigner>	signer = CreateRSADataSigner( [ServiceAlipay_Config sharedInstance].privateKey );
	
	NSString * signedString = [signer signString:orderDesc];
	if ( nil == signedString )
	{
		ERROR( @"failed to generate order string" );
		return nil;
	}
	
	NSString * orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderDesc, signedString, @"RSA"];
	if ( nil == orderString || 0 == orderString.length )
	{
		return nil;
	}
	
	return orderString;
}

- (void)clear
{
	self.no = nil;
	self.name = nil;
	self.desc = nil;
	self.price = nil;
}

- (void)load
{
}

- (void)unload
{
	self.no = nil;
	self.name = nil;
	self.desc = nil;
	self.price = nil;
}

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

//
//  AlixPayOrder.m
//  AliPay
//
//  Created by WenBi on 11-5-18.
//  Copyright 2011 Alipay. All rights reserved.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "AlixPayOrder.h"

#pragma mark -
#pragma mark AlixPayOrder
@implementation AlixPayOrder

@synthesize partner = _partner;
@synthesize seller = _seller;
@synthesize tradeNO = _tradeNO;
@synthesize productName = _productName;
@synthesize productDescription = _productDescription;
@synthesize amount = _amount;
@synthesize notifyURL = _notifyURL;
@synthesize extraParams = _extraParams;

- (void)dealloc {
	self.partner = nil;
	self.seller = nil;
	self.tradeNO = nil;
	self.productName = nil;
	self.productDescription = nil;
	self.amount = nil;
	self.notifyURL = nil;
	[self.extraParams release];
	[super dealloc];
}

//拼接订单字符串函数,运行外部商户自行优化
- (NSString *)description {
	NSMutableString * discription = [NSMutableString string];
	[discription appendFormat:@"partner=\"%@\"", self.partner ? self.partner : @""];
	[discription appendFormat:@"&seller=\"%@\"", self.seller ? self.seller : @""];
	[discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO ? self.tradeNO : @""];
	[discription appendFormat:@"&subject=\"%@\"", self.productName ? self.productName : @""];
	[discription appendFormat:@"&body=\"%@\"", self.productDescription ? self.productDescription : @""];
	[discription appendFormat:@"&total_fee=\"%@\"", self.amount ? self.amount : @""];
	[discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL ? self.notifyURL : @""];
	for (NSString * key in [self.extraParams allKeys]) {
		[discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
	}
	return discription;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

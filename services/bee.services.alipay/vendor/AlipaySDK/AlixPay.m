//
//  AlixPayClient.m
//  AliPay
//
//  Created by WenBi on 11-5-16.
//  Copyright 2011 Alipay. All rights reserved.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <UIKit/UIApplication.h>
#import "JSONKit.h"
#import "AlixPay.h"

static AlixPay * safepayClient = nil;

#define ALIPAY_SAFEPAY     @"SafePay"
#define ALIPAY_DATASTRING  @"dataString"
#define ALIPAY_SCHEME      @"fromAppUrlScheme"
#define ALIPAY_TYPE        @"requestType"

#pragma mark -
#pragma mark AlixPay
@implementation AlixPay

+ (AlixPay *)shared {
	if (safepayClient == nil) {
		safepayClient = [[AlixPay alloc] init];
	}
	return safepayClient;
}



- (int)pay:(NSString *)orderString applicationScheme:(NSString *)scheme {
	
	int ret = kSPErrorOK;
	NSDictionary * oderParams = [NSDictionary dictionaryWithObjectsAndKeys:
							 orderString,ALIPAY_DATASTRING,
							 scheme, ALIPAY_SCHEME,
							 ALIPAY_SAFEPAY, ALIPAY_TYPE,
							 nil];
	
	//采用SBjson将params转化为json格式的字符串
	NSString * jsonString = [oderParams JSONString];
	
	//将数据拼接成符合alipay规范的Url
    //注意：这里优先接入独立快捷支付客户端
	NSString * urlSafypayString = [NSString stringWithFormat:@"safepay://alipayclient/?%@", 
							[jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * urlAlipayString = [NSString stringWithFormat:@"alipay://alipayclient/?%@",
                                  [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURL *safepayUrl = [NSURL URLWithString:urlSafypayString];
    NSURL *alipayUrl = [NSURL URLWithString:urlAlipayString];
	
	//通过打开Url调用快捷支付服务
	//实质上,外部商户只需保证把商品信息拼接成符合规范的字符串转为Url并打开,其余任何函数代码都可以自行优化
	if ([[UIApplication sharedApplication] canOpenURL:safepayUrl]) {
		[[UIApplication sharedApplication] openURL:safepayUrl];
	}
    else if ([[UIApplication sharedApplication] canOpenURL:alipayUrl]) {
		[[UIApplication sharedApplication] openURL:alipayUrl];
	}
	else {
		ret = kSPErrorAlipayClientNotInstalled;
	}	
	return ret;
}

//将url数据封装成AlixPayResult使用,允许外部商户自行优化
- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[[AlixPayResult alloc] initWithResultString:query] autorelease];
}

//将快捷支付回调url解析数据
- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] isEqualToString:@"safepay"]) {
		result = [self resultFromURL:url];
	}
		
	return result;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
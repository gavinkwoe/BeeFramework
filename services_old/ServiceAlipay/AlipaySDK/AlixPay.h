//
//  AlixPayClient.h
//  AliPay
//
//  Created by WenBi on 11-5-16.
//  Copyright 2011 Alipay. All rights reserved.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <Foundation/Foundation.h>

#import "AlixPayResult.h"

enum {
	kSPErrorOK,
	kSPErrorAlipayClientNotInstalled,
	kSPErrorSignError,
};

@interface AlixPay : NSObject {
}

+ (AlixPay *)shared;

- (int)pay:(NSString *)orderString applicationScheme:(NSString *)scheme;
- (AlixPayResult *)handleOpenURL:(NSURL *)url;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
//
//  AlixPayResult.m
//  SafepayInterface
//
//  Created by WenBi on 11-5-20.
//  Copyright 2011 Alipay. All rights reserved.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "AlixPayResult.h"
#import "JSONKit.h"

@interface AlixPayResult ()

- (void)setStatusCode:(int)code;
- (void)setStatusMessage:(NSString *)message;
- (void)setResultString:(NSString *)string;
- (void)setSignString:(NSString *)string;
- (void)setSignType:(NSString *)signType;

@end


@implementation AlixPayResult

@synthesize statusCode = _statusCode;
@synthesize statusMessage = _statusMessage;
@synthesize resultString = _resultString;
@synthesize signString = _signString;
@synthesize signType = _signType;


//解析安全支付返回数据函数,允许外部商户自行优化
- (id)initWithResultString:(NSString *)string {
	
	if (self = [super init]) {
		
		self.statusCode = 4006;
		self.statusMessage = @"订单支付失败";
		
		NSDictionary * jsonQuery = [string objectFromJSONString];
		
		do {
			
			NSDictionary * jsonMemo = [jsonQuery objectForKey:@"memo"];
			if (jsonMemo == nil) {
				break;
			}
			self.statusCode = [[jsonMemo objectForKey:@"ResultStatus"] intValue];
			self.statusMessage = [jsonMemo objectForKey:@"memo"];
			if (self.statusCode != 9000) {
				break;
			}
			
			NSString *result = [jsonMemo objectForKey:@"result"];
			
			//
			// 签名类型
			//
			NSRange valueRange = [result rangeOfString:@"&sign_type=\""];
			if (valueRange.location == NSNotFound) {
				break;
			}
			self.resultString = [result substringToIndex:valueRange.location];
			valueRange.location += valueRange.length;
			valueRange.length = [result length] - valueRange.location;
			NSRange tempRange = [result rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:valueRange];
			if (tempRange.location == NSNotFound) {
				break;
			}
			valueRange.length = tempRange.location - valueRange.location;
			if (valueRange.length <= 0) {
				break;
			}
			self.signType = [result substringWithRange:valueRange];
			//
			// 签名字符串
			//
			valueRange.location = tempRange.location;
			valueRange.length = [result length] - valueRange.location;
			valueRange = [result rangeOfString:@"sign=\"" options:NSCaseInsensitiveSearch range:valueRange];
			if (valueRange.location == NSNotFound) {
				break;
			}
			valueRange.location += valueRange.length;
			valueRange.length = [result length] - valueRange.location;
			tempRange = [result rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:valueRange];
			if (tempRange.location == NSNotFound) {
				break;
			}
			valueRange.length = tempRange.location - valueRange.location;
			if (valueRange.length <= 0) {
				break;
			}
			self.signString = [result substringWithRange:valueRange];
			
		} while (0);
		
	}
	
	return self;
}

- (void)dealloc {
	[_statusMessage release];
	[_resultString release];
	[_signString release];
	[_signType release];
	[super dealloc];
}

- (NSString *)description {
	NSMutableString * description = [NSMutableString string];
	[description appendString:@"result = {\n"];
	[description appendFormat:@"\tstatusCode=%d\n", self.statusCode];
	[description appendFormat:@"\tstatusMessage=%@\n", self.statusMessage];
	[description appendFormat:@"\tsignType=%@\n", self.signType];
	[description appendFormat:@"\tsignString=%@\n", self.signString];
	[description appendString:@"}\n"];
	return description;
}

- (void)setSignType:(NSString *)signType {
	if (_signType != signType) {
		[_signType release];
		_signType = [signType retain];
	}
}

- (void)setSignString:(NSString *)string {
	if (_signString != string) {
		[_signString release];
		_signString = [string retain];
	}
}

- (void)setStatusCode:(int)code {
	_statusCode = code;
}

- (void)setStatusMessage:(NSString *)message {
	if (_statusMessage != message) {
		[_statusMessage release];
		_statusMessage = [message retain];
	}
}

- (void)setResultString:(NSString *)string {
	if (_resultString != string) {
		[_resultString release];
		_resultString = [string retain];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

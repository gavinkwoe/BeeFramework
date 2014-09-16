//
//  RSADataSigner.m
//  SafepayService
//
//  Created by wenbi on 11-4-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RSADataSigner.h"
#import "openssl_wrapper.h"

@implementation RSADataSigner

- (id)initWithPrivateKey:(NSString *)privateKey {
	if (self = [super init]) {
		_privateKey = [privateKey copy];
	}
	return self;
}

- (void)dealloc {
	[_privateKey release];
	[super dealloc];
}

- (NSString*)urlEncodedString:(NSString *)string
{
	NSString * result = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
																			(CFStringRef)string,
																			NULL,
																			(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																			kCFStringEncodingUTF8 );
	return [result autorelease];
}



//- (NSString *)urlEncodedString:(NSData *)src
//{
//	char *hex = "0123456789ABCDEF";
//	unsigned char * data = (unsigned char*)[src bytes];
//	int len = [src length];
//	NSMutableString* s = [NSMutableString string];
//	for(int i = 0;i<len;i++){
//		unsigned char c = data[i];
//		if( ('a' <= c && c <= 'z')
//		   || ('A' <= c && c <= 'Z')
//		   || ('0' <= c && c <= '9') ){
//			NSString* ts = [[NSString alloc] initWithCString:(char *)&c length:1];
//			
//			[s appendString:ts];
//			[ts release];
//		} else {
//			[s appendString:@"%"];
//			char ts1 = hex[c >> 4];
//			NSString* ts = [[NSString alloc] initWithCString:&ts1 length:1];
//			[s appendString:ts];
//			[ts release];
//			char ts2 = hex[c & 15];
//			ts = [[NSString alloc] initWithCString:&ts2 length:1];
//			[s appendString:ts];
//			[ts release];
//			
//		}
//	}
//	return s;
//}

- (NSString *)formatPrivateKey:(NSString *)privateKey {
    const char *pstr = [privateKey UTF8String];
    int len = [privateKey length];
    NSMutableString *result = [NSMutableString string];
//    [result appendString:@"-----BEGIN PRIVATE KEY-----\n"];
	[result appendString:@"-----BEGIN RSA PRIVATE KEY-----\n"];
    int index = 0;
	int count = 0;
    while (index < len) {
        char ch = pstr[index];
		if (ch == '\r' || ch == '\n') {
			++index;
			continue;
		}
        [result appendFormat:@"%c", ch];
        if (++count == 76)
        {
            [result appendString:@"\n"];
			count = 0;
        }
        index++;
    }
//    [result appendString:@"\n-----END PRIVATE KEY-----"];
	[result appendString:@"\n-----END RSA PRIVATE KEY-----"];
    return result;
}

- (NSString *)algorithmName {
	return @"RSA";
}

//该签名方法仅供参考,外部商户可用自己方法替换
- (NSString *)signString:(NSString *)string {
	
	//在Document文件夹下创建私钥文件
	NSString * signedString = nil;
	NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [documentPath stringByAppendingPathComponent:@"AlixPay-RSAPrivateKey"];
	
	//
	// 把密钥写入文件
	//
	NSString *formatKey = [self formatPrivateKey:_privateKey];
	[formatKey writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
	unsigned int sig_len;
    int ret = rsa_sign_with_private_key_pem((char *)message, messageLength, sig, &sig_len, (char *)[path UTF8String]);
	//签名成功,需要给签名字符串base64编码和UrlEncode,该两个方法也可以根据情况替换为自己函数
    if (ret == 1) {
        NSString * base64String = base64StringFromData([NSData dataWithBytes:sig length:sig_len]);
		//NSData * UTF8Data = [base64String dataUsingEncoding:NSUTF8StringEncoding];
		signedString = [self urlEncodedString:base64String];
    }

	free(sig);
    return signedString;
}

@end

//
//  JSHttpHelper.h
//  UMan
//
//  Created by 王 正星 on 14-7-20.
//  Copyright (c) 2014年 zhengxing Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface JSHttpHelper : NSObject

+ (ASIHTTPRequest *)post:(NSString *)url withJSONValue:(NSDictionary *)parma withDelegate:(id)delegate withUserInfo:(NSString *)userInfo;

+ (ASIHTTPRequest *)post:(NSString *)url withValue:(NSDictionary *)parma withDelegate:(id)delegate withUserInfo:(NSString *)userInfo;

+ (ASIHTTPRequest *)get:(NSString *)url withValue:(NSDictionary *)parma withDelegate:(id)delegate withUserInfo:(NSString *)userInfo;

+ (ASIHTTPRequest*)post:(NSString*)url withValue:(NSDictionary*)parma withDelegate:(id)delegate withDict:(NSDictionary*)userInfo;

+ (ASIHTTPRequest *)post:(NSString *)url withValueDict:(NSDictionary *)parma withDataDict:(NSDictionary*)data withDelegate:(id)delegate withUserInfo:(NSString *)userInfo;
+ (ASIHTTPRequest*)post:(NSString*)url withDataDict:(NSDictionary*)data withDelegate:(id)delegate withUserInfo:(NSDictionary*)userInfo;
@end

//
//  UADHTTPRequestQueue.h
//  BabyunCore
//
//  Created by venking on 15/7/6.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "Bee_Precompile.h"
#import "Bee_Package.h"
#import "Bee_Foundation.h"
#import "Bee_HTTPPackage.h"
#import "Bee_HTTPRequest.h"

#pragma mark -

AS_PACKAGE( BeePackage_HTTP, UADHTTPRequestQueue, uadRequestQueue );

#pragma mark -

@class BeeHTTPRequest;
@class UADHTTPRequestQueue;

@compatibility_alias UADRequestQueue UADHTTPRequestQueue;

typedef void (^UADHTTPRequestQueueBlock)( BeeHTTPRequest * req );

#pragma mark -

@interface UADHTTPRequestQueue : NSObject<ASIHTTPRequestDelegate>

AS_SINGLETON( UADHTTPRequestQueue )

@property (nonatomic, assign) BOOL						merge;
@property (nonatomic, assign) BOOL						online;				// 开网/断网

@property (nonatomic, assign) BOOL						blackListEnable;	// 是否使用黑名单
@property (nonatomic, assign) NSTimeInterval			blackListTimeout;	// 黑名单超时
@property (nonatomic, retain) NSMutableDictionary *		blackList;

@property (nonatomic, assign) NSUInteger				bytesUpload;
@property (nonatomic, assign) NSUInteger				bytesDownload;

@property (nonatomic, assign) NSTimeInterval			delay;
@property (nonatomic, retain) NSMutableArray *			requests;

@property (nonatomic, copy) UADHTTPRequestQueueBlock	whenCreate;
@property (nonatomic, copy) UADHTTPRequestQueueBlock	whenUpdate;

+ (BOOL)isNetworkInUse;
+ (NSUInteger)bandwidthUsedPerSecond;

+ (NSUInteger) MAX_NUMBER_OF_QUEUE;

+ (BeeHTTPRequest *)GET:(NSString *)url;
+ (BeeHTTPRequest *)POST:(NSString *)url;
+ (BeeHTTPRequest *)PUT:(NSString *)url;
+ (BeeHTTPRequest *)DELETE:(NSString *)url;

+ (BeeHTTPRequest *)POST:(NSString *)url parameter:(NSDictionary *)parameter datas:(NSDictionary *)datas userInfo:(NSDictionary *)userInfo postFormat:(ASIPostFormat)format;

+ (BOOL)requesting:(NSString *)url;
+ (BOOL)requesting:(NSString *)url byResponder:(id)responder;

+ (NSArray *)requests:(NSString *)url;
+ (NSArray *)requests:(NSString *)url byResponder:(id)responder;

+ (void)cancelRequest:(BeeHTTPRequest *)request;
+ (void)cancelRequestByResponder:(id)responder;
+ (void)cancelAllRequests;

+ (void)blockURL:(NSString *)url;
+ (void)unblockURL:(NSString *)url;

@end
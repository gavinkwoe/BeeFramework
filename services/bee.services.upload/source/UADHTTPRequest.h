//
//  UADHTTPRequest.h
//  UADHTTPRequest
//
//  Created by venking on 15/7/1.
//  Copyright (c) 2015年 babyun. All rights reserved.
//


#import "Bee.h"

#undef UADHTTP_ERROR
#define UADHTTP_ERROR(OPTION) ERROR(@"The parameters[%@] for the class[%@] method[%@] is nil. %lu", [OPTION class], [self class], __FUNCTION__)

#pragma mark - 请求状态定义
typedef enum
{
    UADHTTP_SENDING = 0,
    UADHTTP_SUCCEED,
    UADHTTP_FAILED,
    UADHTTP_CANCELED,
    UADHTTP_RECEIVE
}UAD_HTTPRequestStatus;

@class UADHTTPRequest;
@protocol UADHTTPRequestDelegate <NSObject>
- (void) responseRequest:(ASIHTTPRequest *)theRequest object:(UADHTTPRequest *)object;
@end

typedef NSDictionary * (^UADHTTPRequestBlock)( id );

@interface UADHTTPRequest : NSObject
@property (nonatomic, assign) BOOL preload;
@property (nonatomic, readonly) UAD_HTTPRequestStatus status;
@property (nonatomic, copy) UADHTTPRequestBlock whenUpdate;
@property (nonatomic, copy) UADHTTPRequestBlock uploadProcess;
@property (nonatomic, copy) UADHTTPRequestBlock downloadProcess;
@property (nonatomic, copy) UADHTTPRequestBlock cancelRequest;

@property (nonatomic, weak) id <UADHTTPRequestDelegate> delegate;

+ (ASIHTTPRequest *) postHTTPWithURL:(NSString *)url parameter:(NSDictionary *)parameter datas:(NSDictionary *)datas userInfo:(NSDictionary *)userInfo postFormat:(ASIPostFormat)format;
- (ASIHTTPRequest *) postHTTPWithURL:(NSString *)url parameter:(NSDictionary *)parameter datas:(NSDictionary *)datas userInfo:(NSDictionary *)userInfo postFormat:(ASIPostFormat)format;
+ (UADHTTPRequest *) actionRequest:(ASIHTTPRequest *)theRequest delay:(NSUInteger)delay;
- (UADHTTPRequest *) actionRequest:(ASIHTTPRequest *)theRequest delay:(NSUInteger)delay;

- (id) initWithNumberOfBlocks:(NSUInteger)block numberOfThread:(NSUInteger)thread;
- (CGFloat) getDownloadProgress;
- (CGFloat) getUploadProgress;
- (void) addRequest:(ASIHTTPRequest *)theRequest;
- (void) runQueues;

@end
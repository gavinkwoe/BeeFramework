//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//
//
//  Bee_Network.h
//

#import <Foundation/Foundation.h>
#import "Bee_Singleton.h"

#import "ASIHTTPRequest.h"
#import "ASIDataDecompressor.h"
#import "ASIFormDataRequest.h"

#pragma mark -

@class ASIFormDataRequest;
@class BeeRequest;

#pragma mark -

@interface NSObject(BeeRequestResponder)

- (BOOL)isRequestResponder;

- (BeeRequest *)GET:(NSString *)url;
- (BeeRequest *)POST:(NSString *)url data:(NSData *)data;
- (BeeRequest *)POST:(NSString *)url text:(NSString *)text;
- (BeeRequest *)POST:(NSString *)url dict:(NSDictionary *)kvs;
- (BeeRequest *)POST:(NSString *)url params:(id)first, ...;
- (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files;
- (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files dict:(NSDictionary *)kvs;
- (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files params:(id)first, ...;

- (BOOL)requestingURL;
- (BOOL)requestingURL:(NSString *)url;

- (NSArray *)requests;
- (NSArray *)requests:(NSString *)url;

- (void)cancelRequests;

- (void)handleRequest:(BeeRequest *)request;

@end

#pragma mark -

typedef enum
{
	BEE_REQUEST_STATE_CREATED = 0,
	BEE_REQUEST_STATE_SENDING,
	BEE_REQUEST_STATE_RECVING,
	BEE_REQUEST_STATE_FAILED,
	BEE_REQUEST_STATE_SUCCEED,
	BEE_REQUEST_STATE_CANCELLED
} BeeRequestState;

#pragma mark -

typedef void (^BeeRequestBlock)( BeeRequest * req );

#pragma mark -

@interface BeeRequest : ASIFormDataRequest
{
	BeeRequestState			_state;
	id						_responder;

	NSInteger				_errorCode;
	NSMutableDictionary *	_userInfo;

	BOOL					_sendProgressed;
	BOOL					_recvProgressed;
	BeeRequestBlock			_whenUpdate;
	
	NSTimeInterval			_initTimeStamp;
	NSTimeInterval			_sendTimeStamp;
	NSTimeInterval			_recvTimeStamp;
	NSTimeInterval			_doneTimeStamp;

#ifdef __BEE_DEVELOPMENT__
	NSMutableArray *		_callstack;
#endif	// #ifdef __BEE_DEVELOPMENT__
}

@property (nonatomic, assign) BeeRequestState			state;
@property (nonatomic, assign) id						responder;

@property (nonatomic, assign) NSInteger					errorCode;
@property (nonatomic, retain) NSMutableDictionary *		userInfo;

@property (nonatomic, copy) BeeRequestBlock				whenUpdate;

@property (nonatomic, assign) NSTimeInterval			initTimeStamp;
@property (nonatomic, assign) NSTimeInterval			sendTimeStamp;
@property (nonatomic, assign) NSTimeInterval			recvTimeStamp;
@property (nonatomic, assign) NSTimeInterval			doneTimeStamp;

#ifdef __BEE_DEVELOPMENT__
@property (nonatomic, readonly) NSMutableArray *		callstack;
#endif	// #ifdef __BEE_DEVELOPMENT__

@property (nonatomic, readonly) BOOL					created;
@property (nonatomic, readonly) BOOL					sending;
@property (nonatomic, readonly) BOOL					recving;
@property (nonatomic, readonly) BOOL					failed;
@property (nonatomic, readonly) BOOL					succeed;
@property (nonatomic, readonly) BOOL					cancelled;
@property (nonatomic, readonly) BOOL					sendProgressed;
@property (nonatomic, readonly) BOOL					recvProgressed;

- (void)changeState:(BeeRequestState)state;

- (NSTimeInterval)timeCostPending;	// 排队等待耗时
- (NSTimeInterval)timeCostOverDNS;	// 网络连接耗时（DNS）
- (NSTimeInterval)timeCostRecving;	// 网络收包耗时
- (NSTimeInterval)timeCostOverAir;	// 网络整体耗时

- (NSUInteger)uploadBytes;
- (NSUInteger)uploadTotalBytes;

- (NSUInteger)downloadBytes;
- (NSUInteger)downloadTotalBytes;

@end

#pragma mark -

@interface BeeRequestQueue : NSObject<ASIHTTPRequestDelegate>
{
	BOOL					_online;

	BOOL					_blackListEnable;
	NSTimeInterval			_blackListTimeout;
	NSMutableDictionary *	_blackList;

	NSUInteger				_bytesUpload;
	NSUInteger				_bytesDownload;
	
	NSTimeInterval			_delay;
	NSMutableArray *		_requests;

	BeeRequestBlock			_whenCreate;
	BeeRequestBlock			_whenUpdate;
}

@property (nonatomic, assign) BOOL						online;				// 开网/断网

@property (nonatomic, assign) BOOL						blackListEnable;	// 是否使用黑名单
@property (nonatomic, assign) NSTimeInterval			blackListTimeout;	// 黑名单超时
@property (nonatomic, retain) NSMutableDictionary *		blackList;

@property (nonatomic, assign) NSUInteger				bytesUpload;
@property (nonatomic, assign) NSUInteger				bytesDownload;

@property (nonatomic, assign) NSTimeInterval			delay;
@property (nonatomic, retain) NSMutableArray *			requests;

@property (nonatomic, copy) BeeRequestBlock				whenCreate;
@property (nonatomic, copy) BeeRequestBlock				whenUpdate;

+ (BeeRequestQueue *)sharedInstance;

+ (BOOL)isReachableViaWIFI;
+ (BOOL)isReachableViaWLAN;
+ (BOOL)isNetworkInUse;
+ (NSUInteger)bandwidthUsedPerSecond;

+ (BeeRequest *)GET:(NSString *)url;
+ (BeeRequest *)POST:(NSString *)url data:(NSData *)data;
+ (BeeRequest *)POST:(NSString *)url params:(NSDictionary *)kvs;
+ (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files;
+ (BeeRequest *)POST:(NSString *)url files:(NSDictionary *)files params:(NSDictionary *)kvs;

+ (BOOL)requesting:(NSString *)url;
+ (BOOL)requesting:(NSString *)url byResponder:(id)responder;

+ (NSArray *)requests:(NSString *)url;
+ (NSArray *)requests:(NSString *)url byResponder:(id)responder;

+ (void)cancelRequest:(BeeRequest *)request;
+ (void)cancelRequestByResponder:(id)responder;
+ (void)cancelAllRequests;

+ (void)blockURL:(NSString *)url;
+ (void)unblockURL:(NSString *)url;

@end

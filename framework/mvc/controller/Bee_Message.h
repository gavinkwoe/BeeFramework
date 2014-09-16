//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
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

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"

#pragma mark -

#undef	AS_MESSAGE
#define AS_MESSAGE( __name )	AS_STATIC_PROPERTY( __name )

#undef	DEF_MESSAGE
#define DEF_MESSAGE( __name )	DEF_STATIC_PROPERTY3( __name, @"message", [self description] )

#undef	DEF_MESSAGE2
#define DEF_MESSAGE2( __name, __msg ) \
		DEF_STATIC_PROPERTY3( __name, @"message", [self description] ); \
		- (void)__name:(BeeMessage *)__msg

#undef	DEF_MESSAGE3
#define DEF_MESSAGE3( __name, __type, __msg ) \
		DEF_STATIC_PROPERTY3( __name, @"message", [self description] ); \
		- (void)__name:(__type *)__msg

#undef	DEF_MESSAGE_
#define DEF_MESSAGE_( __name, __msg )	DEF_MESSAGE2( __name, __msg )

#pragma mark -

#undef	BEFORE_MESSAGE
#define BEFORE_MESSAGE( __msg ) \
		- (void)prehandleMessage:(BeeMessage *)__msg

#undef	AFTER_MESSAGE
#define AFTER_MESSAGE( __msg ) \
		- (void)posthandleMessage:(BeeMessage *)__msg

#undef	ON_MESSAGE
#define ON_MESSAGE( __msg ) \
		- (void)handleMessage:(BeeMessage *)__msg

#undef	ON_MESSAGE2
#define ON_MESSAGE2( __filter, __msg ) \
		- (void)handleMessage_##__filter:(BeeMessage *)__msg

#undef	ON_MESSAGE3
#define ON_MESSAGE3( __class, __name, __msg ) \
		- (void)handleMessage_##__class##_##__name:(BeeMessage *)__msg

#pragma mark -

@class BeeMessage;

typedef void			(^BeeMessageBlock)( void );
typedef BeeMessage *	(^BeeMessageBlockV)( void );
typedef BeeMessage *	(^BeeMessageBlockN)( id key, ... );
typedef BeeMessage *	(^BeeMessageBlockT)( NSTimeInterval time );
typedef id				(^BeeMessageObjectBlockN)( id key, ... );

#pragma mark -

@protocol BeeMessageExecutor<NSObject>
@optional
- (void)index:(BeeMessage *)msg;
- (void)route:(BeeMessage *)msg;
- (BOOL)prehandle:(BeeMessage *)msg;
- (void)posthandle:(BeeMessage *)msg;
@end

#pragma mark -

@interface BeeMessage : NSObject

AS_STRING( ERROR_DOMAIN_UNKNOWN )
AS_STRING( ERROR_DOMAIN_SERVER )
AS_STRING( ERROR_DOMAIN_CLIENT )
AS_STRING( ERROR_DOMAIN_NETWORK )

AS_INT( ERROR_CODE_OK )			// OK
AS_INT( ERROR_CODE_UNKNOWN )	// 非知错误
AS_INT( ERROR_CODE_TIMEOUT )	// 超时
AS_INT( ERROR_CODE_PARAMS )		// 参数错误
AS_INT( ERROR_CODE_ROUTES )		// 路由错误

AS_INT( STATE_CREATED )			// 消息被创建
AS_INT( STATE_SENDING )			// 消息正在发送
AS_INT( STATE_WAITING )			// 消息正在等待回应
AS_INT( STATE_SUCCEED )			// 消息处理成功（本地或网络）
AS_INT( STATE_FAILED )			// 消息处理失败（本地或网络）
AS_INT( STATE_CANCELLED )		// 消息被取消了

@property (nonatomic, readonly) BeeMessageBlockN		INPUT;
@property (nonatomic, readonly) BeeMessageBlockN		OUTPUT;
@property (nonatomic, readonly) BeeMessageObjectBlockN	GET_INPUT;
@property (nonatomic, readonly) BeeMessageObjectBlockN	GET_OUTPUT;
@property (nonatomic, readonly) BeeMessageBlockT		TIMEOUT;
@property (nonatomic, readonly) BeeMessageBlockV		TOLD_PROGRESS;

@property (nonatomic, assign) BOOL						unique;			// 是否同时只能发一个
@property (nonatomic, assign) BOOL						disabled;		// 是否被禁止回调
@property (nonatomic, assign) BOOL						async;			// 是否异步
@property (nonatomic, assign) BOOL						timeout;		// 是否超时了
@property (nonatomic, assign) BOOL						cached;			// 是否从缓存读取的
@property (nonatomic, assign) BOOL						emitted;		// 是否被发送了
@property (nonatomic, assign) BOOL						oneDirection;	// 是否单方向发送
@property (nonatomic, assign) NSTimeInterval			seconds;		// 超时时间
@property (nonatomic, assign) BOOL						useCache;

@property (nonatomic, assign) BOOL						toldProgress;
@property (nonatomic, assign) BOOL						progressed;

@property (nonatomic, assign) id						responder;
@property (nonatomic, assign) NSInteger					nextState;
@property (nonatomic, assign) NSInteger					state;
@property (nonatomic, retain) NSString *				message;
@property (nonatomic, retain) NSMutableDictionary *		input;
@property (nonatomic, retain) NSMutableDictionary *		output;

@property (nonatomic, assign) BOOL						executable;
@property (nonatomic, assign) id<BeeMessageExecutor>	executer;

@property (nonatomic, retain) NSString *				errorDomain;
@property (nonatomic, assign) NSInteger					errorCode;
@property (nonatomic, retain) NSString *				errorDesc;

@property (nonatomic, assign) NSTimeInterval			initTimeStamp;
@property (nonatomic, assign) NSTimeInterval			sendTimeStamp;
@property (nonatomic, assign) NSTimeInterval			recvTimeStamp;

@property (nonatomic, copy) BeeMessageBlock				whenUpdate;
@property (nonatomic, copy) BeeMessageBlock				whenSending;
@property (nonatomic, copy) BeeMessageBlock				whenWaiting;
@property (nonatomic, copy) BeeMessageBlock				whenProgressed;
@property (nonatomic, copy) BeeMessageBlock				whenSucceed;
@property (nonatomic, copy) BeeMessageBlock				whenFailed;
@property (nonatomic, copy) BeeMessageBlock				whenCancelled;

#if __BEE_DEVELOPMENT__
@property (nonatomic, readonly) NSMutableArray *		callstack;
#endif	// #if __BEE_DEVELOPMENT__

@property (nonatomic, assign) BOOL						created;
@property (nonatomic, assign) BOOL						arrived;
@property (nonatomic, assign) BOOL						sending;
@property (nonatomic, assign) BOOL						waiting;
@property (nonatomic, assign) BOOL						succeed;
@property (nonatomic, assign) BOOL						failed;
@property (nonatomic, assign) BOOL						cancelled;

@property (nonatomic, readonly) NSTimeInterval			timeElapsed;		// 整体经过时间
@property (nonatomic, readonly) NSTimeInterval			timeCostPending;	// 排队等待耗时
@property (nonatomic, readonly) NSTimeInterval			timeCostOverAir;	// 网络处理耗时

+ (BeeMessage *)message;
+ (BeeMessage *)message:(NSString *)msg;
+ (BeeMessage *)message:(NSString *)msg timeoutSeconds:(NSUInteger)seconds;
+ (BeeMessage *)message:(NSString *)msg responder:(id)responder;
+ (BeeMessage *)message:(NSString *)msg responder:(id)responder timeoutSeconds:(NSUInteger)seconds;

- (BeeMessage *)send;
- (BeeMessage *)input:(id)first, ...;
- (BeeMessage *)output:(id)first, ...;
- (BeeMessage *)cancel;
- (BeeMessage *)reset;

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;
- (BOOL)isTwinWith:(BeeMessage *)msg;	// 与某消息同属于一个发起源，相同NAME

- (void)setLastError;
- (void)setLastError:(NSInteger)code;
- (void)setLastError:(NSInteger)code domain:(NSString *)domain;
- (void)setLastError:(NSInteger)code domain:(NSString *)domain desc:(NSString *)desc;

- (void)runloop;
- (void)changeState:(NSInteger)newState;

- (void)callResponder;
- (void)forwardResponder:(NSObject *)obj;

// global configurations

+ (NSDictionary *)globalHeaders;
+ (void)setGlobalHeader:(id)value forKey:(NSString *)key;
+ (BOOL)hasGlobalHeaderForKey:(NSString *)key;
+ (void)removeGlobalHeaderForKey:(NSString *)key;

+ (NSArray *)globalExecuters;
+ (void)setGlobalExecuter:(id<BeeMessageExecutor>)executer;
+ (void)addGlobalExecuter:(id<BeeMessageExecutor>)executer;
+ (void)removeGlobalExecuter:(id<BeeMessageExecutor>)executer;
+ (void)removeAllGlobalExecuters;

// internal use only
- (void)internalStartTimer;
- (void)internalStopTimer;
- (void)internalNotifySending;
- (void)internalNotifyWaiting;
- (void)internalNotifySucceed;
- (void)internalNotifyFailed;
- (void)internalNotifyCancelled;
- (void)internalNotifyProgressUpdated;

@end

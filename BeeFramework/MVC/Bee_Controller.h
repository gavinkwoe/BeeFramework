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
//  Bee_Controller.h
//

#import <Foundation/Foundation.h>
#import "Bee_Singleton.h"
#import "Bee_Network.h"

#pragma mark -

#define AS_MESSAGE( __name )	AS_STATIC_PROPERTY( __name )
#define DEF_MESSAGE( __name )	DEF_STATIC_PROPERTY3( __name, @"message", [self description] )

#pragma mark -

#define BEE_ERROR_DOMAIN_UNKNOWN	@"domain.unknown"
#define BEE_ERROR_DOMAIN_SERVER		@"domain.server"
#define BEE_ERROR_DOMAIN_CLIENT		@"domain.client"
#define BEE_ERROR_DOMAIN_NETWORK	@"domain.network"

#define BEE_ERROR_CODE_OK			(0)		// OK
#define BEE_ERROR_CODE_UNKNOWN		(-1)	// 非知错误
#define BEE_ERROR_CODE_TIMEOUT		(-2)	// 超时
#define BEE_ERROR_CODE_WRONG_PARAM	(-3)	// 参数错误
#define BEE_ERROR_CODE_ROUTES		(-4)	// 路由错误

#pragma mark -

typedef enum
{
	BEE_MESSAGE_STATE_CREATED = 0,	// 消息被创建
	BEE_MESSAGE_STATE_SENDING,		// 消息正在发送
	BEE_MESSAGE_STATE_SUCCEED,		// 消息处理成功（本地或网络）
	BEE_MESSAGE_STATE_FAILED,		// 消息处理失败（本地或网络）
	BEE_MESSAGE_STATE_CANCELLED		// 消息被取消了
} BeeMessageState;

#pragma mark -

@class BeeMessage;
@class BeeMessageQueue;
@class BeeController;

#pragma mark -

@interface NSObject(BeeMessageResponder)

- (BOOL)sendingMessage:(NSString *)msg;
- (void)cancelMessage:(NSString *)msg;
- (void)cancelMessages;

- (BeeMessage *)message:(NSString *)msg;
- (BeeMessage *)message:(NSString *)msg timeoutSeconds:(NSUInteger)seconds;

- (BeeMessage *)sendMessage:(NSString *)msg;
- (BeeMessage *)sendMessage:(NSString *)msg timeoutSeconds:(NSUInteger)seconds;

- (void)handleMessage:(BeeMessage *)msg;

@end

#pragma mark -

typedef void (^BeeMessageBlock)( BeeMessage * msg );

#pragma mark -

@interface BeeMessage : NSObject
{
	BOOL						_unique;		// 同时只能执行一个该同名消息
	BOOL						_disabled;		// 不回调
	BOOL						_async;			// 所有操作均为异步（暂时不支持）
	BOOL						_timeout;		// 是否为超时？
	BOOL						_cached;		// 是否为缓存
	BOOL						_emitted;		// 已被发送
	BOOL						_oneDirection;	// 单向消息，Controller收到即算成功
	NSTimer *					_timer;			// 计时器，消息可以单独设置超时
	NSTimeInterval				_seconds;		// 超时时长（秒）
	BOOL						_useCache;		// 是否使用Cache
	BOOL						_toldProgress;	// 是否告知进度
	BOOL						_progressed;	// 是否有新进度

	BeeMessageState				_nextState;		// 消息状态(下一状态)
	BeeMessageState				_state;			// 消息状态
	NSString *					_message;		// 消息名字，格式: @"xxx.yyy"
	NSMutableDictionary *		_input;			// 输入参数字典
	NSMutableDictionary *		_output;		// 输出数据字典
	id							_responder;		// 回调对象
	BeeController *				_executer;		// 所负责处理该消息的Controller

	BeeRequest *				_request;		// 网络请求
	NSData *					_response;		// 网络返回数据
	
	NSString *					_errorDomain;	// 错误域
	NSInteger					_errorCode;		// 错误码
	NSString *					_errorDesc;		// 错误描述
	
	NSTimeInterval				_initTimeStamp;
	NSTimeInterval				_sendTimeStamp;
	NSTimeInterval				_recvTimeStamp;	

	BeeMessageBlock				_whenUpdate;

#ifdef __BEE_DEVELOPMENT__
	NSMutableArray *			_callstack;
#endif	// #ifdef __BEE_DEVELOPMENT__
}

@property (nonatomic, assign) BOOL						unique;
@property (nonatomic, assign) BOOL						disabled;
@property (nonatomic, assign) BOOL						async;
@property (nonatomic, assign) BOOL						timeout;
@property (nonatomic, assign) BOOL						cached;
@property (nonatomic, assign) BOOL						emitted;
@property (nonatomic, assign) BOOL						oneDirection;
@property (nonatomic, assign) NSTimeInterval			seconds;
@property (nonatomic, assign) BOOL						useCache;
@property (nonatomic, assign) BOOL						toldProgress;
@property (nonatomic, assign) id						responder;
@property (nonatomic, assign) BeeMessageState			nextState;
@property (nonatomic, assign) BeeMessageState			state;
@property (nonatomic, retain) NSString *				message;
@property (nonatomic, retain) NSMutableDictionary *		input;
@property (nonatomic, retain) NSMutableDictionary *		output;
@property (nonatomic, assign) BeeController *			executer;
@property (nonatomic, retain) BeeRequest *				request;
@property (nonatomic, retain) NSData *					response;
@property (nonatomic, retain) NSString *				errorDomain;
@property (nonatomic, assign) NSInteger					errorCode;
@property (nonatomic, retain) NSString *				errorDesc;

@property (nonatomic, assign) NSTimeInterval			initTimeStamp;
@property (nonatomic, assign) NSTimeInterval			sendTimeStamp;
@property (nonatomic, assign) NSTimeInterval			recvTimeStamp;

@property (nonatomic, copy) BeeMessageBlock				whenUpdate;

#ifdef __BEE_DEVELOPMENT__
@property (nonatomic, readonly) NSMutableArray *		callstack;
#endif	// #ifdef __BEE_DEVELOPMENT__

@property (nonatomic, assign) BOOL						created;
@property (nonatomic, assign) BOOL						sending;
@property (nonatomic, assign) BOOL						progressed;
@property (nonatomic, assign) BOOL						succeed;
@property (nonatomic, assign) BOOL						failed;
@property (nonatomic, assign) BOOL						cancelled;

+ (BeeMessage *)message:(NSString *)msg;
+ (BeeMessage *)message:(NSString *)msg timeoutSeconds:(NSUInteger)seconds;
+ (BeeMessage *)message:(NSString *)msg responder:(id)responder;
+ (BeeMessage *)message:(NSString *)msg responder:(id)responder timeoutSeconds:(NSUInteger)seconds;

- (BeeMessage *)send;
- (BeeMessage *)input:(id)first, ...;
- (BeeMessage *)output:(id)first, ...;
- (BeeMessage *)inputJSON:(NSString *)json;
- (BeeMessage *)outputJSON:(NSString *)json;
- (BeeMessage *)inputDict:(NSDictionary *)dict;
- (BeeMessage *)outputDict:(NSDictionary *)dict;
- (BeeMessage *)cancel;
- (BeeMessage *)reset;

- (float)uploadProgress;
- (float)downloadProgress;

- (NSTimeInterval)timeElapsed;		// 整体经过时间
- (NSTimeInterval)timeCostPending;	// 排队等待耗时
- (NSTimeInterval)timeCostOverAir;	// 网络处理耗时

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;
- (BOOL)isTwinWith:(BeeMessage *)msg;	// 与某消息同属于一个发起源，相同NAME

- (void)setLastError;
- (void)setLastError:(NSInteger)code domain:(NSString *)domain;
- (void)setLastError:(NSInteger)code domain:(NSString *)domain desc:(NSString *)desc;

- (void)runloop;
- (void)changeState:(BeeMessageState)newState;

@end

#pragma mark -

@interface BeeMessageQueue : NSObject
{
	BeeMessageBlock	_whenCreate;
	BeeMessageBlock	_whenUpdate;
	NSTimer *		_runloopTimer;
	BOOL			_pause;
}

AS_SINGLETON(BeeMessageQueue)

@property (nonatomic, copy) BeeMessageBlock	whenCreate;
@property (nonatomic, copy) BeeMessageBlock	whenUpdate;
@property (nonatomic, retain) NSTimer *		runloopTimer;
@property (nonatomic, assign) BOOL			pause;

- (NSArray *)allMessages;
- (NSArray *)pendingMessages;
- (NSArray *)sendingMessages;
- (NSArray *)finishedMessages;
- (NSArray *)messages:(NSString *)msgName;
- (NSArray *)messagesInSet:(NSArray *)msgNames;

- (BOOL)sendMessage:(BeeMessage *)msg;
- (void)removeMessage:(BeeMessage *)msg;
- (void)cancelMessage:(NSString *)msg;
- (void)cancelMessage:(NSString *)msg byResponder:(id)responder;
- (void)cancelMessages;

- (BOOL)sending:(NSString *)msg;
- (BOOL)sending:(NSString *)msg byResponder:(id)responder;

- (void)enableResponder:(id)responder;
- (void)disableResponder:(id)responder;

@end

#pragma mark -

@interface BeeController : NSObject
{
	NSString *				_prefix;
	NSMutableDictionary *	_mapping;
}

@property (nonatomic, retain) NSString *			prefix;
@property (nonatomic, retain) NSMutableDictionary *	mapping;

AS_SINGLETON( BeeController );

+ (NSString *)MESSAGE;	// 消息类别

+ (NSArray *)allControllers;

+ (BeeController *)routes:(NSString *)message;

- (void)load;
- (void)unload;

- (void)index:(BeeMessage *)msg;
- (void)route:(BeeMessage *)msg;

- (void)map:(NSString *)name action:(SEL)action;
- (void)map:(NSString *)name action:(SEL)action target:(id)target;

@end

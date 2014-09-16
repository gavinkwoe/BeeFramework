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

#import "Bee_Message.h"
#import "Bee_MessageQueue.h"
#import "Bee_Controller.h"
#import "Bee_Network.h"
#import "NSObject+BeeMessage.h"
#import "BeeMessage+BeeNetwork.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	DEFAULT_TIMEOUT_SECONDS
#define	DEFAULT_TIMEOUT_SECONDS		(30.0f)

#pragma mark -

@interface BeeMessage()
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
	BOOL						_arrived;		// 是否达到
	
	BOOL						_toldProgress;	// 是否告知进度
	BOOL						_progressed;	// 是否有新进度
	
	NSInteger					_nextState;		// 消息状态(下一状态)
	NSInteger					_state;			// 消息状态
	NSString *					_message;		// 消息名字，格式: @"xxx.yyy"
	NSMutableDictionary *		_input;			// 输入参数字典
	NSMutableDictionary *		_output;		// 输出数据字典
	id							_responder;		// 回调对象
	
	BOOL						_executable;	// 自处理
	id<BeeMessageExecutor>		_executer;		// 所负责处理该消息的Controller
	
	NSString *					_errorDomain;	// 错误域
	NSInteger					_errorCode;		// 错误码
	NSString *					_errorDesc;		// 错误描述
	
	NSTimeInterval				_initTimeStamp;
	NSTimeInterval				_sendTimeStamp;
	NSTimeInterval				_recvTimeStamp;
	
	BeeMessageBlock				_whenUpdate;
	BeeMessageBlock				_whenSending;
	BeeMessageBlock				_whenWaiting;
	BeeMessageBlock				_whenProgressed;
	BeeMessageBlock				_whenSucceed;
	BeeMessageBlock				_whenFailed;
	BeeMessageBlock				_whenCancelled;
    
#if __BEE_DEVELOPMENT__
	NSMutableArray *			_callstack;
#endif	// #if __BEE_DEVELOPMENT__
}

- (void)didMessageTimeout;
- (void)callResponder;

@end

#pragma mark -

@implementation BeeMessage

DEF_STRING( ERROR_DOMAIN_UNKNOWN,	@"domain.unknown" )
DEF_STRING( ERROR_DOMAIN_SERVER,	@"domain.server" )
DEF_STRING( ERROR_DOMAIN_CLIENT,	@"domain.client" )
DEF_STRING( ERROR_DOMAIN_NETWORK,	@"domain.network" )

DEF_INT( ERROR_CODE_OK,			0 )
DEF_INT( ERROR_CODE_UNKNOWN,	-1 )
DEF_INT( ERROR_CODE_TIMEOUT,	-2 )
DEF_INT( ERROR_CODE_PARAMS,		-3 )
DEF_INT( ERROR_CODE_ROUTES,		-4 )

DEF_INT( STATE_CREATED,		0 )
DEF_INT( STATE_SENDING,		1 )
DEF_INT( STATE_SUCCEED,		2 )
DEF_INT( STATE_FAILED,		3 )
DEF_INT( STATE_CANCELLED,	4 )
DEF_INT( STATE_WAITING,		5 )

@dynamic INPUT;
@dynamic OUTPUT;
@dynamic GET_INPUT;
@dynamic GET_OUTPUT;
@dynamic TIMEOUT;

@synthesize unique = _unique;
@synthesize disabled = _disabled;
@synthesize async = _async;
@synthesize timeout = _timeout;
@synthesize cached = _cached;
@synthesize emitted = _emitted;
@synthesize oneDirection = _oneDirection;
@synthesize seconds = _seconds;
@synthesize useCache = _useCache;

@synthesize toldProgress = _toldProgress;
@synthesize progressed = _progressed;

@synthesize responder = _responder;
@synthesize nextState = _nextState;
@synthesize state = _state;
@synthesize message = _message;
@synthesize input = _input;
@synthesize output = _output;

@synthesize executable = _executable;
@synthesize executer = _executer;

@synthesize errorDomain = _errorDomain;
@synthesize errorCode = _errorCode;
@synthesize errorDesc = _errorDesc;

@synthesize	initTimeStamp = _initTimeStamp;
@synthesize	sendTimeStamp = _sendTimeStamp;
@synthesize	recvTimeStamp = _recvTimeStamp;

@synthesize whenUpdate = _whenUpdate;
@synthesize whenSending = _whenSending;
@synthesize whenWaiting = _whenWaiting;
@synthesize whenProgressed = _whenProgressed;
@synthesize whenSucceed = _whenSucceed;
@synthesize whenFailed = _whenFailed;
@synthesize whenCancelled = _whenCancelled;

#if __BEE_DEVELOPMENT__
@synthesize callstack = _callstack;
#endif	// #if __BEE_DEVELOPMENT__

@synthesize created;
@synthesize arrived = _arrived;
@synthesize sending;
@synthesize waiting;
@synthesize succeed;
@synthesize failed;
@synthesize cancelled;

@synthesize timeElapsed;
@synthesize timeCostPending;
@synthesize timeCostOverAir;

static NSMutableDictionary *	__globalHeaders = nil;
static NSMutableArray *			__globalExecuters = nil;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_unique = NO;
		_async = YES;
		_cached = NO;
		_timeout = NO;
		_seconds = DEFAULT_TIMEOUT_SECONDS;
		_timer = nil;
		_useCache = NO;
        
		_nextState = BeeMessage.STATE_CREATED;
		_state = BeeMessage.STATE_CREATED;
		_message = nil;
		_input = [[NSMutableDictionary alloc] init];
		_output = [[NSMutableDictionary alloc] init];
		_responder = nil;
		_executer = nil;
		
		if ( __globalHeaders )
		{
			[_input addEntriesFromDictionary:__globalHeaders];
		}
        
		_errorCode = BeeMessage.ERROR_CODE_OK;
		_errorDomain = nil;
		
		_initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		_sendTimeStamp = _initTimeStamp;
		_recvTimeStamp = _initTimeStamp;
        
		_arrived = NO;
		
		if ( [BeeMessageQueue sharedInstance].whenCreate )
		{
			[BeeMessageQueue sharedInstance].whenCreate( self );
		}
		
#if __BEE_DEVELOPMENT__
		_callstack = [[NSMutableArray alloc] init];
#endif	// #if __BEE_DEVELOPMENT__
	}
	
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"msg '%@', state %u", self.message, self.state];
}

- (void)dealloc
{
	[self cancelRequests];
    
	[_timer invalidate];
	[_message release];
	[_input release];
	[_output release];
    
	[_errorDomain release];
	[_errorDesc release];
	
#if __BEE_DEVELOPMENT__
	[_callstack removeAllObjects];
	[_callstack release];
#endif	// #if __BEE_DEVELOPMENT__
	
	self.whenUpdate = nil;
	self.whenSending = nil;
	self.whenWaiting = nil;
	self.whenProgressed = nil;
	self.whenSucceed = nil;
	self.whenFailed = nil;
	self.whenCancelled = nil;
    
	[super dealloc];
}

+ (BeeMessage *)message
{
	return [[[BeeMessage alloc] init] autorelease];
}

+ (BeeMessage *)message:(NSString *)msg
{
	BeeMessage * bmsg = [[BeeMessage alloc] init];
	bmsg.message = msg;
	return [bmsg autorelease];
}

+ (BeeMessage *)message:(NSString *)msg timeoutSeconds:(NSUInteger)seconds
{
	BeeMessage * bmsg = [[BeeMessage alloc] init];
	bmsg.message = msg;
	bmsg.seconds = seconds ? seconds : DEFAULT_TIMEOUT_SECONDS;
	return [bmsg autorelease];
}

+ (BeeMessage *)message:(NSString *)msg responder:(id)responder
{
	BeeMessage * bmsg = [[BeeMessage alloc] init];
	bmsg.message = msg;
	bmsg.responder = responder;
	return [bmsg autorelease];
}

+ (BeeMessage *)message:(NSString *)msg responder:(id)responder timeoutSeconds:(NSUInteger)seconds
{
	BeeMessage * bmsg = [[BeeMessage alloc] init];
	bmsg.message = msg;
	bmsg.responder = responder;
	bmsg.seconds = seconds ? seconds : DEFAULT_TIMEOUT_SECONDS;
	return [bmsg autorelease];
}

#pragma mark -

+ (NSMutableDictionary *)__globalHeaders
{
	if ( nil == __globalHeaders )
	{
		__globalHeaders = [[NSMutableDictionary alloc] init];
	}
    
	return __globalHeaders;
}

+ (NSDictionary *)globalHeaders
{
	return [BeeMessage __globalHeaders];
}

+ (void)setGlobalHeader:(id)value forKey:(NSString *)key
{
	if ( nil == key || nil == value )
		return;
	
	NSMutableDictionary * dict = [BeeMessage __globalHeaders];
	if ( dict )
	{
		[dict setObject:value forKey:key];
	}
}

+ (BOOL)hasGlobalHeaderForKey:(NSString *)key
{
	if ( nil == key )
		return NO;
    
	NSMutableDictionary * dict = [BeeMessage __globalHeaders];
	if ( dict )
	{
		return [dict objectForKey:key] ? YES : NO;
	}
	
	return NO;
}

+ (void)removeGlobalHeaderForKey:(NSString *)key
{
	if ( nil == key )
		return;
    
	NSMutableDictionary * dict = [BeeMessage __globalHeaders];
	if ( dict )
	{
		[dict removeObjectForKey:key];
	}
}

#pragma mark -

+ (NSArray *)globalExecuters
{
	if ( nil == __globalExecuters )
	{
		__globalExecuters = [[NSMutableArray nonRetainingArray] retain];
	}
    
	return __globalExecuters;
}

+ (void)setGlobalExecuter:(id<BeeMessageExecutor>)executer
{
	[self addGlobalExecuter:executer];
}

+ (void)addGlobalExecuter:(id<BeeMessageExecutor>)executer
{
	if ( nil == __globalExecuters )
	{
		__globalExecuters = [[NSMutableArray nonRetainingArray] retain];
	}
	
	[__globalExecuters addObject:executer];
}

+ (void)removeGlobalExecuter:(id<BeeMessageExecutor>)executer
{
	if ( nil == __globalExecuters )
	{
		__globalExecuters = [[NSMutableArray nonRetainingArray] retain];
	}
	
	[__globalExecuters removeObject:executer];
}

+ (void)removeAllGlobalExecuters
{
	if ( nil == __globalExecuters )
	{
		__globalExecuters = [[NSMutableArray nonRetainingArray] retain];
	}
	
	[__globalExecuters removeAllObjects];
}

#pragma mark -

- (void)didMessageTimeout
{
	_timer = nil;
	_timeout = YES;
	_emitted = NO;
	
	self.errorCode = self.ERROR_CODE_TIMEOUT;
	self.errorDomain = self.ERROR_DOMAIN_NETWORK;
    
	[self changeState:BeeMessage.STATE_FAILED];
}

- (void)internalStartTimer
{
	if ( YES == _emitted || nil == _executer )
		return;
    
	[_timer invalidate];
	_timer = nil;
    
	if ( _seconds > 0.0f )
	{
		_timer = [NSTimer scheduledTimerWithTimeInterval:_seconds
												  target:self
												selector:@selector(didMessageTimeout)
												userInfo:nil
												 repeats:NO];
	}
    
	_emitted = YES;
}

- (void)internalStopTimer
{
	if ( NO == _emitted || nil == _executer )
		return;
	
	[_timer invalidate];
	_timer = nil;
	
	_emitted = NO;
}

- (void)internalNotifySending
{
	_sendTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	_recvTimeStamp = _sendTimeStamp;
	
	if ( NO == self.disabled )
	{
		if ( self.whenSending )
		{
			self.whenSending();
		}
        
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
        
		[self callResponder];
	}
    
	INFO( @"Message '%@' sent", _message );
}

- (void)internalNotifyWaiting
{
	_recvTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	
	if ( NO == self.disabled )
	{
		if ( self.whenWaiting )
		{
			self.whenWaiting();
		}
        
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
        
		[self callResponder];
	}
    
	INFO( @"Message '%@' waiting", _message );
}

- (void)internalNotifySucceed
{
	INFO( @"Message '%@' succeed", _message );
	
	_recvTimeStamp = [NSDate timeIntervalSinceReferenceDate];
    
	if ( NO == self.disabled )
	{
		if ( self.whenSucceed )
		{
			self.whenSucceed();
		}
		
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
		
		[self callResponder];
	}
}

- (void)internalNotifyFailed
{
	ERROR( @"Message '%@' failed", _message );
    
	_recvTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	
	if ( NO == self.disabled )
	{
		if ( self.whenFailed )
		{
			self.whenFailed();
		}
		
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
        
		[self callResponder];
	}
}

- (void)internalNotifyCancelled
{
	INFO( @"Message '%@' cancelled", _message );
	
	_recvTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	
	if ( NO == self.disabled )
	{
		if ( self.whenCancelled )
		{
			self.whenCancelled();
		}
		
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
        
		[self callResponder];
	}
}

- (void)internalNotifyProgressUpdated
{
	INFO( @"Message '%@' progress updated", _message );
    
	if ( NO == _toldProgress )
		return;
	
	_progressed = YES;
	
	if ( NO == self.disabled )
	{
		if ( self.whenProgressed )
		{
			self.whenProgressed();
		}
		
        //		if ( self.whenUpdate )
        //		{
        //			self.whenUpdate();
        //		}

		[self callResponder];
	}
	
	_progressed = NO;
}

- (void)callResponder
{
	[self forwardResponder:self.responder];
}

- (void)forwardResponder:(NSObject *)obj
{
	if ( nil == obj )
		return;
    
	if ( self.created || self.sending )
	{
		if ( [obj respondsToSelector:@selector(prehandleMessage:)] )
		{
			BOOL flag = [obj prehandleMessage:self];
			if ( NO == flag )
				return;
		}
	}
	
	BOOL handled = NO;
	
	if ( _message && _message.length )
	{
		NSArray * array = [_message componentsSeparatedByString:@"."];
		if ( array && array.count > 2 )
		{
            //			NSString * prefix = (NSString *)[array objectAtIndex:0];
			NSString * clazz = (NSString *)[array objectAtIndex:1];
			NSString * name = (NSString *)[array objectAtIndex:2];
            
			if ( NO == handled )
			{
				NSString *	selectorName = [NSString stringWithFormat:@"handleMessage_%@_%@:", clazz, name];
				SEL			selector = NSSelectorFromString(selectorName);
				
				if ( [obj respondsToSelector:selector] )
				{
					[obj performSelector:selector withObject:self];
					
					handled = YES;
				}
			}
            
			if ( NO == handled )
			{
				NSString *	selectorName = [NSString stringWithFormat:@"handleMessage_%@:", clazz];
				SEL			selector = NSSelectorFromString(selectorName);
				
				if ( [obj respondsToSelector:selector] )
				{
					[obj performSelector:selector withObject:self];
					
					handled = YES;
				}
			}
            
			if ( NO == handled )
			{
				NSString * selectorName;
				SEL selector;
                
				selectorName = [NSString stringWithFormat:@"handle%@:", clazz];
				selector = NSSelectorFromString( selectorName );
				
				if ( [obj respondsToSelector:selector] )
				{
					[obj performSelector:selector withObject:self];
                    
					handled = YES;
				}
			}
		}
	}
	
	if ( NO == handled )
	{
		NSString *	selectorName = [NSString stringWithFormat:@"%@:", [[self class] description]];
		SEL			selector = NSSelectorFromString(selectorName);
        
		if ( [obj respondsToSelector:selector] )
		{
			[obj performSelector:selector withObject:self];
			
			handled = YES;
		}
	}
    
	if ( NO == handled )
	{
		NSString *	selectorName = [NSString stringWithFormat:@"handleMessage_%@:", [[self class] description]];
		SEL			selector = NSSelectorFromString(selectorName);
		
		if ( [obj respondsToSelector:selector] )
		{
			[obj performSelector:selector withObject:self];
			
			handled = YES;
		}
	}
    
	if ( NO == handled )
	{
		if ( obj && [obj respondsToSelector:@selector(handleMessage:)] )
		{
			[obj performSelector:@selector(handleMessage:) withObject:self];
		}
	}
    
	if ( [obj respondsToSelector:@selector(posthandleMessage:)] )
	{
		[obj posthandleMessage:self];
	}
}

- (BeeMessage *)send
{
	if ( YES == _emitted )
		return self;
    
#if __BEE_DEVELOPMENT__
	[_callstack addObjectsFromArray:[BeeRuntime callstack:16]];
#endif	// #if __BEE_DEVELOPMENT__
    
	[[BeeMessageQueue sharedInstance] sendMessage:self];
	return self;
}

- (BeeMessage *)input:(id)first, ...
{
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [self.input count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;
		
		[self.input setObject:value forKey:key];
	}
	
	va_end( args );
	return self;
}

- (BeeMessage *)output:(id)first, ...
{
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [self.output count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;
		
		[self.output setObject:value forKey:key];
	}
	
	va_end( args );
	return self;
}

- (BeeMessage *)cancel
{
	if ( NO == _emitted || nil == _executer )
	{
		[self internalStopTimer];
        
		[[BeeMessageQueue sharedInstance] removeMessage:self];
		return self;
	}
	
	if ( self.sending )
	{
		[self changeState:BeeMessage.STATE_CANCELLED];
	}
    
	return self;
}

- (BeeMessage *)reset
{
	[self cancelRequests];
	[self internalStopTimer];
    
	self.responder = nil;
	
	self.whenUpdate = nil;
	self.whenSending = nil;
	self.whenWaiting = nil;
	self.whenProgressed = nil;
	self.whenSucceed = nil;
	self.whenFailed = nil;
	self.whenCancelled = nil;
    
	_initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	_sendTimeStamp = _initTimeStamp;
	_recvTimeStamp = _sendTimeStamp;
    
	return self;
}

- (NSTimeInterval)timeElapsed
{
	return _recvTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostPending
{
	return _sendTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostOverAir
{
	return _recvTimeStamp - _sendTimeStamp;
}

- (BOOL)is:(NSString *)name
{
	return [_message isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
	return [_message hasPrefix:prefix];
}

- (BOOL)isTwinWith:(BeeMessage *)msg
{
	if ( self == msg )
	{
		return YES;
	}
    
	if ( [_message isEqualToString:msg.message] && _responder == msg.responder )
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

- (void)setLastError
{
	self.errorCode = BeeMessage.ERROR_CODE_UNKNOWN;
	self.errorDomain = BeeMessage.ERROR_DOMAIN_UNKNOWN;
	self.errorDesc = @"unknown";
}

- (void)setLastError:(NSInteger)code
{
	self.errorCode = code;
	self.errorDomain = BeeMessage.ERROR_DOMAIN_UNKNOWN;
	self.errorDesc = @"unknown";
}

- (void)setLastError:(NSInteger)code domain:(NSString *)domain
{
	self.errorCode = code;
	self.errorDomain = domain;
	self.errorDesc = @"";
}

- (void)setLastError:(NSInteger)code domain:(NSString *)domain desc:(NSString *)desc
{
	self.errorCode = code;
	self.errorDomain = domain;
	self.errorDesc = desc ? desc : @"";
}

- (BOOL)created
{
	return BeeMessage.STATE_CREATED == _state ? YES : NO;
}

- (void)setCreated:(BOOL)flag
{
	if ( flag )
	{
		_nextState = BeeMessage.STATE_CREATED;
	}
}

- (BOOL)sending
{
	return BeeMessage.STATE_SENDING == _state ? YES : NO;
}

- (void)setSending:(BOOL)flag
{
	if ( flag )
	{
		_nextState = BeeMessage.STATE_SENDING;
	}
}

- (BOOL)waiting
{
	return BeeMessage.STATE_WAITING == _state ? YES : NO;
}

- (void)setWaiting:(BOOL)flag
{
	if ( flag )
	{
		_nextState = BeeMessage.STATE_WAITING;
	}
}

- (BOOL)succeed
{
	return BeeMessage.STATE_SUCCEED == _state ? YES : NO;
}

- (void)setSucceed:(BOOL)flag
{
	if ( flag )
	{
		_nextState = BeeMessage.STATE_SUCCEED;
	}
	else
	{
		_nextState = BeeMessage.STATE_FAILED;
	}
}

- (BOOL)failed
{
	return BeeMessage.STATE_FAILED == _state ? YES : NO;
}

- (void)setFailed:(BOOL)flag
{
	if ( flag )
	{
		_nextState = BeeMessage.STATE_FAILED;
	}
}

- (BOOL)cancelled
{
	return BeeMessage.STATE_CANCELLED == _state ? YES : NO;
}

- (void)setCancelled:(BOOL)flag
{
	if ( flag )
	{
		_nextState = BeeMessage.STATE_CANCELLED;
	}
}

- (void)runloop
{
	if ( _nextState != _state )
	{
		[self changeState:_nextState];
	}
}

- (void)changeState:(NSInteger)newState
{
	BOOL shouldRemove = NO;
    
	if ( _state == newState )
		return;
    
	_state = newState;
	_nextState = newState;
	
	if ( BeeMessage.STATE_CREATED != _state )
	{
		if ( NO == _arrived )
		{
			// TODO:
			_arrived = YES;
		}
	}
	
	for ( id<BeeMessageExecutor> executer in __globalExecuters )
	{
		if ( [executer respondsToSelector:@selector(route:)] )
		{
			[executer route:self];
		}
		else if ( [executer respondsToSelector:@selector(index:)] )
		{
			[executer index:self];
		}
	}
    
	if ( _executable )
	{
		[_executer route:self];
	}
	else
	{
		// Find an executer
		if ( nil == _executer )
		{
			_executer = [BeeMessageController routes:_message];
		}
        
		if ( [_executer respondsToSelector:@selector(route:)] )
		{
			[_executer route:self];
		}
		else
		{
			[_executer index:self];
		}
	}
    
	if ( BeeMessage.ERROR_CODE_OK != _errorCode )
	{
		_nextState = BeeMessage.STATE_FAILED;
		_state = BeeMessage.STATE_FAILED;
	}
    
	if ( BeeMessage.STATE_CREATED == _state )
	{
		// TODO: nothing to do
	}
	else if ( BeeMessage.STATE_SENDING == _state )
	{
		if ( self.oneDirection )
		{
			[self internalStopTimer];
			[self internalNotifySucceed];
			
			shouldRemove = YES;
		}
		else
		{
			[self internalStartTimer];
			[self internalNotifySending];
		}
	}
	else if ( BeeMessage.STATE_WAITING == _state )
	{
		[self internalNotifyWaiting];
	}
	else if ( BeeMessage.STATE_SUCCEED == _state )
	{
		if ( _nextState == _state )
        {
			[self internalStopTimer];
			[self internalNotifySucceed];
			
			if ( _nextState == _state )
			{
				[self cancelRequests];
				
				shouldRemove = YES;
			}
		}
	}
	else if ( BeeMessage.STATE_FAILED == _state )
	{
		if ( _nextState == _state )
        {
			[self internalStopTimer];
			[self internalNotifyFailed];
            
			if ( _nextState == _state )
			{
				[self cancelRequests];
                
				shouldRemove = YES;
			}
		}
	}
	else if ( BeeMessage.STATE_CANCELLED == _state )
	{
        if ( _nextState == _state )
        {
			[self internalStopTimer];
			[self internalNotifyCancelled];
            
			if ( _nextState == _state )
			{
				[self cancelRequests];
                
				shouldRemove = YES;
			}
		}
	}
    
	if ( [BeeMessageQueue sharedInstance].whenUpdate )
	{
		[BeeMessageQueue sharedInstance].whenUpdate( self );
	}
    
	if ( shouldRemove )
	{
		[[BeeMessageQueue sharedInstance] removeMessage:self];
	}
}

#pragma mark -

- (BeeMessageObjectBlockN)GET_INPUT
{
	BeeMessageObjectBlockN block = ^ id ( id first, ... )
	{
		return [self.input objectAtPath:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeMessageObjectBlockN)GET_OUTPUT
{
	BeeMessageObjectBlockN block = ^ id ( id first, ... )
	{
		return [self.output objectAtPath:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeMessageBlockN)INPUT
{
	BeeMessageBlockN block = ^ BeeMessage * ( id first, ... )
	{
		if ( first )
		{
			if ( [first isKindOfClass:[NSDictionary class]] )
			{
				[self.input addEntriesFromDictionary:(NSDictionary *)first];
			}
			else
			{
				va_list args;
				va_start( args, first );
				
				NSString *	key = (NSString *)first;
				NSObject *	value = va_arg( args, NSObject * );
				
				if ( key && value )
				{
					[self.input setObject:value atPath:key];
				}
                
				va_end( args );
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeMessageBlockN)OUTPUT
{
	BeeMessageBlockN block = ^ BeeMessage * ( id first, ... )
	{
		if ( first )
		{
			if ( [first isKindOfClass:[NSDictionary class]] )
			{
				[self.output addEntriesFromDictionary:(NSDictionary *)first];
			}
			else
			{
				va_list args;
				va_start( args, first );
				
				NSString *	key = (NSString *)first;
				NSObject *	value = va_arg( args, NSObject * );
				
				if ( key && value )
				{
					[self.output setObject:value atPath:key];
				}
				
				va_end( args );
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeMessageBlockT)TIMEOUT
{
	BeeMessageBlockT block = ^ BeeMessage * ( NSTimeInterval time )
	{
		self.seconds = time;
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( BeeMessage )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

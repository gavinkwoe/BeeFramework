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

#import "Bee_Singleton.h"
#import "Bee_Controller.h"
#import "Bee_Runtime.h"
#import "Bee_Log.h"
#import "JSONKit.h"

#undef	DEFAULT_RUNLOOP_INTERVAL
#define	DEFAULT_RUNLOOP_INTERVAL	(0.1f)

#undef	DEFAULT_TIMEOUT_SECONDS
#define	DEFAULT_TIMEOUT_SECONDS		(60.0f)

#pragma mark -

@implementation NSObject(BeeMessageResponder)

- (BOOL)sendingMessage:(NSString *)msg
{
	return [[BeeMessageQueue sharedInstance] sending:msg byResponder:self];
}

- (void)cancelMessage:(NSString *)msg
{
	[[BeeMessageQueue sharedInstance] cancelMessage:msg byResponder:self];
}

- (void)cancelMessages
{
	[[BeeMessageQueue sharedInstance] cancelMessage:nil byResponder:self];
}

- (BeeMessage *)message:(NSString *)msg
{
	return [self message:msg timeoutSeconds:0];
}

- (BeeMessage *)message:(NSString *)msg timeoutSeconds:(NSUInteger)seconds
{
	return [BeeMessage message:msg responder:self timeoutSeconds:seconds];
}

- (BeeMessage *)sendMessage:(NSString *)msg
{
	return [self sendMessage:msg timeoutSeconds:0];
}

- (BeeMessage *)sendMessage:(NSString *)msg timeoutSeconds:(NSUInteger)seconds
{
	return [[BeeMessage message:msg responder:self timeoutSeconds:seconds] send];
}

- (void)handleMessage:(BeeMessage *)msg
{
}

@end

#pragma mark -

@interface BeeMessage(Private)
- (void)didMessageTimeout;
- (void)internalStartTimer;
- (void)internalStopTimer;
- (void)internalNotifySending;
- (void)internalNotifySucceed;
- (void)internalNotifyFailed;
- (void)internalNotifyCancelled;
- (void)internalNotifyProgressUpdated;
@end

#pragma mark -

@implementation BeeMessage

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
@synthesize executer = _executer;

@synthesize request = _request;
@synthesize response = _response;

@synthesize errorDomain = _errorDomain;
@synthesize errorCode = _errorCode;
@synthesize errorDesc = _errorDesc;

@synthesize	initTimeStamp = _initTimeStamp;
@synthesize	sendTimeStamp = _sendTimeStamp;
@synthesize	recvTimeStamp = _recvTimeStamp;

@synthesize whenUpdate = _whenUpdate;

#ifdef __BEE_DEVELOPMENT__
@synthesize callstack = _callstack;
#endif	// #ifdef __BEE_DEVELOPMENT__

@synthesize created;
@synthesize sending;
@synthesize succeed;
@synthesize failed;
@synthesize cancelled;

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
		_toldProgress = NO;
		_progressed = NO;

		_nextState = BEE_MESSAGE_STATE_CREATED;
		_state = BEE_MESSAGE_STATE_CREATED;
		_message = [@"nil.nil" retain];
		_input = [[NSMutableDictionary alloc] init];
		_output = [[NSMutableDictionary alloc] init];
		_responder = nil;
		_executer = nil;
		_request = nil;
		_response = nil;

		_errorCode = BEE_ERROR_CODE_OK;
		_errorDomain = nil;
		
		_initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		_sendTimeStamp = _initTimeStamp;
		_recvTimeStamp = _initTimeStamp;

		self.whenUpdate = nil;
		
		if ( [BeeMessageQueue sharedInstance].whenCreate )
		{
			[BeeMessageQueue sharedInstance].whenCreate( self );
		}
		
	#ifdef __BEE_DEVELOPMENT__
		_callstack = [[NSMutableArray alloc] init];
	#endif	// #ifdef __BEE_DEVELOPMENT__
	}
	
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"msg '%@', state %d", self.message, self.state];
}

- (void)dealloc
{
	[self cancelRequests];

	[_timer invalidate];
	[_message release];
	[_input release];
	[_output release];
	[_request release];
	[_response release];
	[_errorDomain release];
	[_errorDesc release];
	
#ifdef __BEE_DEVELOPMENT__
	[_callstack removeAllObjects];
	[_callstack release];
#endif	// #ifdef __BEE_DEVELOPMENT__
	
	self.whenUpdate = nil;
	
	[super dealloc];
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

- (void)didMessageTimeout
{
	_timer = nil;
	_timeout = YES;
	_emitted = NO;
	
	[self changeState:BEE_MESSAGE_STATE_CANCELLED];
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
												userInfo:nil repeats:NO];		
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
		if ( self.whenUpdate )
		{
			self.whenUpdate( self );
		}

		if ( self.responder && [self.responder respondsToSelector:@selector(handleMessage:)] )
		{
			[self.responder handleMessage:self];			
		}		
	}
}

- (void)internalNotifySucceed
{
	_recvTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	
	if ( NO == self.disabled )
	{
		if ( self.whenUpdate )
		{
			self.whenUpdate( self );
		}

		if ( self.responder && [self.responder respondsToSelector:@selector(handleMessage:)] )
		{
			[self.responder handleMessage:self];			
		}
	}
}

- (void)internalNotifyFailed
{
	_recvTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	
	if ( NO == self.disabled )
	{
		if ( self.whenUpdate )
		{
			self.whenUpdate( self );
		}

		if ( self.responder && [self.responder respondsToSelector:@selector(handleMessage:)] )
		{
			[self.responder handleMessage:self];			
		}
	}
}

- (void)internalNotifyCancelled
{
	_recvTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	
	if ( NO == self.disabled )
	{
		if ( self.whenUpdate )
		{
			self.whenUpdate( self );
		}

		if ( self.responder && [self.responder respondsToSelector:@selector(handleMessage:)] )
		{
			[self.responder handleMessage:self];			
		}
	}
}

- (void)internalNotifyProgressUpdated
{
	if ( NO == _toldProgress )
		return;

	CC( @"upload = %0.2f, download = %0.2f", [self uploadProgress], [self downloadProgress] );
	
	_progressed = YES;

	if ( NO == self.disabled )
	{
		if ( self.whenUpdate )
		{
			self.whenUpdate( self );
		}

		if ( self.responder && [self.responder respondsToSelector:@selector(handleMessage:)] )
		{
			[self.responder handleMessage:self];			
		}	
	}

	_progressed = NO;
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
		
//		CC( @"input, %@ = %@", [key description], [value description] );
		
		[self.input setObject:value forKey:key];
	}
	
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
		
		CC( @"output, %@ = %@", [key description], [value description] );
		
		[self.output setObject:value forKey:key];
	}
	
	return self;
}

- (BeeMessage *)inputJSON:(NSString *)json
{
	NSObject * obj = [json objectFromJSONString];
	
	if ( [obj isKindOfClass:[NSDictionary class]] )
	{
		[self.input addEntriesFromDictionary:(NSDictionary *)obj];	
	}
		
	return self;
}

- (BeeMessage *)outputJSON:(NSString *)json
{
	NSObject * obj = [json objectFromJSONString];
	
	if ( [obj isKindOfClass:[NSDictionary class]] )
	{
		[self.output addEntriesFromDictionary:(NSDictionary *)obj];	
	}
	
	return self;
}

- (BeeMessage *)inputDict:(NSDictionary *)dict
{
	[self.input addEntriesFromDictionary:dict];	
	return self;
}

- (BeeMessage *)outputDict:(NSDictionary *)dict
{
	[self.output addEntriesFromDictionary:dict];	
	return self;	
}

- (BeeMessage *)cancel
{
	if ( NO == _emitted || nil == _executer )
		return self;
	
	[self changeState:BEE_MESSAGE_STATE_CANCELLED];
	return self;
}

- (BeeMessage *)reset
{
	[self cancelRequests];
	[self internalStopTimer];

	self.responder = nil;
	self.whenUpdate = nil;
	self.request = nil;

	_initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	_sendTimeStamp = _initTimeStamp;
	_recvTimeStamp = _sendTimeStamp;
		
	return self;
}

- (float)uploadProgress
{
	if ( _request )
	{
		unsigned long long sent = [_request totalBytesSent];
		unsigned long long total = [_request postLength];
		CC( @"%@, sent = %d, total = %d", self.message, sent, total );
		
		return (sent * 1.0f) / (total * 1.0f);				
	}
	else
	{
		return 0.0f;
	}
}

- (float)downloadProgress
{
	if ( _request )
	{
		unsigned long long recv = [_request totalBytesRead];
		unsigned long long total = [_request contentLength];
		CC( @"%@, recv = %d, total = %d", self.message, recv, total );
		
		return (recv * 1.0f) / (total * 1.0f);
	}
	else
	{
		return 0.0f;
	}
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
	self.errorCode = BEE_ERROR_CODE_UNKNOWN;
	self.errorDomain = BEE_ERROR_DOMAIN_UNKNOWN;
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
	return BEE_MESSAGE_STATE_CREATED == _state ? YES : NO;
}

- (void)setCreated:(BOOL)flag
{
	if ( flag )
	{
		_nextState = BEE_MESSAGE_STATE_CREATED;
	}
}

- (BOOL)sending
{
	return BEE_MESSAGE_STATE_SENDING == _state ? YES : NO;
}

- (void)setSending:(BOOL)flag
{
	if ( flag )
	{
		_nextState = BEE_MESSAGE_STATE_SENDING;
	}
}

- (BOOL)succeed
{
	return BEE_MESSAGE_STATE_SUCCEED == _state ? YES : NO;
}

- (void)setSucceed:(BOOL)flag
{
	if ( flag )
	{
		_nextState = BEE_MESSAGE_STATE_SUCCEED;
	}
}

- (BOOL)failed
{
	return BEE_MESSAGE_STATE_FAILED == _state ? YES : NO;
}

- (void)setFailed:(BOOL)flag
{
	if ( flag )
	{
		_nextState = BEE_MESSAGE_STATE_FAILED;
	}
}

- (BOOL)cancelled
{
	return BEE_MESSAGE_STATE_CANCELLED == _state ? YES : NO;
}

- (void)setCancelled:(BOOL)flag
{
	if ( flag )
	{
		_nextState = BEE_MESSAGE_STATE_CANCELLED;
	}
}

- (void)runloop
{
	if ( _nextState != _state )
	{
		[self changeState:_nextState];
	}
}

- (void)changeState:(BeeMessageState)newState
{
	if ( _state == newState )
		return;

	CC( @"msg '%@', state %d => %d", _message, _state, newState );

	_state = newState;
	_nextState = newState;

	// Find an executer
	if ( nil == _executer )
	{
		self.executer = [BeeController routes:_message];
		if ( nil == self.executer )
			return;
	}

	[_executer route:self];
	
	if ( BEE_ERROR_CODE_OK != _errorCode )
	{
		_state = BEE_MESSAGE_STATE_FAILED;
	}

	if ( BEE_MESSAGE_STATE_CREATED == _state )
	{
		// TODO: nothing to do
	}
	else if ( BEE_MESSAGE_STATE_SENDING == _state )
	{
	#if __BEE_DEVELOPMENT__
		CC( @"\n[REQUEST]\n'%@'.parameters = %@", _message, [_input description] );
	#endif	// #if __BEE_DEVELOPMENT__

		if ( self.oneDirection )
		{
			[self internalStopTimer];
			[self internalNotifySucceed];
			
			[[BeeMessageQueue sharedInstance] removeMessage:self];
		}
		else
		{
			[self internalStartTimer];
			[self internalNotifySending];
		}
	}
	else if ( BEE_MESSAGE_STATE_SUCCEED == _state )
	{
	#if __BEE_DEVELOPMENT__
		CC( @"\n[SUCCEED]\n'%@'.input = \n%@\n'%@'.output = \n%@\n",
		   _message, [_input description],
		   _message, [_output description]
		   );
	#endif	// #if __BEE_DEVELOPMENT__
		
		[self internalStopTimer];
		[self internalNotifySucceed];
		
		[[BeeMessageQueue sharedInstance] removeMessage:self];
	}	
	else if ( BEE_MESSAGE_STATE_FAILED == _state )
	{
	#if __BEE_DEVELOPMENT__
		CC( @"\n[FAILED]\n'%@'.input = \n%@\n", _message, [_input description] );
	#endif	// #if __BEE_DEVELOPMENT__
		
		[self internalStopTimer];
		[self internalNotifyFailed];	

		[[BeeMessageQueue sharedInstance] removeMessage:self];
	}
	else if ( BEE_MESSAGE_STATE_CANCELLED == _state )
	{
	#if __BEE_DEVELOPMENT__
		CC( @"\n[CANCELLED]\n'%@'.input = %@", _message, [_input description] );
	#endif	// #if __BEE_DEVELOPMENT__
		
		[self cancelRequests];
		
		[self internalStopTimer];	
		[self internalNotifyCancelled];

		[[BeeMessageQueue sharedInstance] removeMessage:self];
	}

	if ( [BeeMessageQueue sharedInstance].whenUpdate )
	{
		[BeeMessageQueue sharedInstance].whenUpdate( self );
	}
}

- (void)handleRequest:(BeeRequest *)request
{
	if ( request.sending )
	{
		self.request = request;
	}
	else if ( request.sendProgressed )
	{
		[self internalNotifyProgressUpdated];
	}
	else if ( request.recving )
	{
	}
	else if ( request.recvProgressed )
	{
		[self internalNotifyProgressUpdated];
	}
	else if ( request.succeed )
	{
		self.request = nil;

		self.response = [request responseData];
		
		[self changeState:BEE_MESSAGE_STATE_SUCCEED];
	}
	else if ( request.failed )
	{
		self.request = nil;
		
		if ( self.timeout )
		{
			self.errorDomain = BEE_ERROR_DOMAIN_SERVER;
			self.errorCode = BEE_ERROR_CODE_TIMEOUT;
			self.errorDesc = @"timeout";			
		}
		else
		{
			self.errorDomain = BEE_ERROR_DOMAIN_NETWORK;
			self.errorCode = request.errorCode;
			self.errorDesc = nil;
		}
		
		[self changeState:BEE_MESSAGE_STATE_FAILED];
	}
	else if ( request.cancelled )
	{
		self.request = nil;

		[self changeState:BEE_MESSAGE_STATE_CANCELLED];
	}
}

@end

#pragma mark -

@interface BeeMessageQueue(Private)
- (void)runloop;
@end

#pragma mark -

@implementation BeeMessageQueue

static NSMutableArray * __sharedQueue = nil;

@synthesize whenCreate = _whenCreate;
@synthesize	whenUpdate = _whenUpdate;
@synthesize runloopTimer = _runloopTimer;
@synthesize pause = _pause;

DEF_SINGLETON(BeeMessageQueue);

- (NSArray *)allMessages
{
	return __sharedQueue;
}

- (NSArray *)pendingMessages
{
	NSMutableArray * array = [NSMutableArray array];
	
	for ( BeeMessage * bmsg in __sharedQueue )
	{
		if ( bmsg.created )
		{
			[array addObject:bmsg];
		}
	}	
	
	return array;
}

- (NSArray *)sendingMessages
{
	NSMutableArray * array = [NSMutableArray array];
	
	for ( BeeMessage * msg in __sharedQueue )
	{
		if ( msg.sending )
		{
			[array addObject:msg];
		}
	}	
	
	return array;
}

- (NSArray *)finishedMessages
{
	NSMutableArray * array = [NSMutableArray array];
	
	for ( BeeMessage * bmsg in __sharedQueue )
	{
		if ( bmsg.succeed || bmsg.failed || bmsg.cancelled )
		{
			[array addObject:bmsg];
		}
	}

	return array;	
}

- (NSArray *)messages:(NSString *)msgName
{
	if ( nil == msgName )
	{
		return __sharedQueue;
	}
	else
	{
		NSMutableArray * array = [NSMutableArray array];
		
		for ( BeeMessage * msg in __sharedQueue )
		{
			if ( [msg.message isEqual:msgName] )
			{
				[array addObject:msg];
			}
		}	
		
		return array;
	}
}

- (NSArray *)messagesInSet:(NSArray *)msgNames
{
	NSMutableArray * array = [NSMutableArray array];
	
	for ( BeeMessage * msg in __sharedQueue )
	{
		for ( NSString * msgName in msgNames )
		{
			if ( [msg.message isEqual:msgName] )
			{
				[array addObject:msg];
				break;
			}			
		}		
	}	
	
	return array;
}

- (BOOL)sendMessage:(BeeMessage *)msg
{
	if ( [__sharedQueue containsObject:msg] )
		return NO;

	if ( msg.unique )
	{
		for ( BeeMessage * inqueue in __sharedQueue )
		{
			if ( [inqueue isTwinWith:msg] )
				return NO;
		}			
	}

	[msg setSending:YES];

	[__sharedQueue addObject:msg];
	return YES;
}

- (void)removeMessage:(BeeMessage *)msg
{
	[__sharedQueue removeObject:msg];
}

- (void)cancelMessage:(NSString *)msg
{
	if ( nil == msg )
	{
		[BeeRequestQueue cancelAllRequests];

		[__sharedQueue removeAllObjects];
	}
	else
	{
		NSUInteger		count = [__sharedQueue count];
		BeeMessage *	bmsg;
		
		for ( NSUInteger i = count; i > 0; --i )
		{
			bmsg = [__sharedQueue objectAtIndex:(i - 1)];
			if ( msg && NO == [msg isEqualToString:bmsg.message] )
				continue;
			
			[bmsg changeState:BEE_MESSAGE_STATE_CANCELLED];			
		}		
	}
}

- (BOOL)sending:(NSString *)msg
{
	if ( nil == msg )
	{
		return ([__sharedQueue count] > 0) ? YES : NO;
	}
	else
	{
		BeeMessage * bmsg = nil;

		NSUInteger count = [__sharedQueue count];		
		for ( NSUInteger i = count; i > 0; --i )
		{
			bmsg = [__sharedQueue objectAtIndex:(i - 1)];
			if ( YES == [msg isEqualToString:bmsg.message] )
			{
				if ( bmsg.created || bmsg.sending )
				{
					return YES;
				}
				else
				{
					return NO;
				}
			}
		}

		return NO;
	}
}

- (BOOL)sending:(NSString *)msg byResponder:(id)responder
{
	BeeMessage * bmsg = nil;
	
	NSUInteger count = [__sharedQueue count];		
	for ( NSUInteger i = count; i > 0; --i )
	{
		bmsg = [__sharedQueue objectAtIndex:(i - 1)];
		if ( responder && bmsg.responder != responder )
			continue;

		if ( nil == msg || [msg isEqualToString:bmsg.message] )
		{
			if ( bmsg.created || bmsg.sending )
			{
				return YES;
			}
			else
			{
				return NO;
			}
		}
	}
	
	return NO;
}

- (void)enableResponder:(id)responder
{
	NSUInteger		count = [__sharedQueue count];
	BeeMessage *	bmsg;
	
	for ( NSUInteger i = count; i > 0; --i )
	{
		bmsg = [__sharedQueue objectAtIndex:(i - 1)];
		if ( responder && bmsg.responder != responder )
			continue;
		
		bmsg.disabled = NO;
	}
}

- (void)disableResponder:(id)responder
{
	NSUInteger		count = [__sharedQueue count];
	BeeMessage *	bmsg;
	
	for ( NSUInteger i = count; i > 0; --i )
	{
		bmsg = [__sharedQueue objectAtIndex:(i - 1)];
		if ( responder && bmsg.responder != responder )
			continue;
		
		bmsg.disabled = YES;
	}
}

- (void)cancelMessage:(NSString *)msg byResponder:(id)responder
{
	NSUInteger		count = [__sharedQueue count];
	BeeMessage *	bmsg;
	
	for ( NSUInteger i = count; i > 0; --i )
	{
		bmsg = [__sharedQueue objectAtIndex:(i - 1)];
		if ( responder && bmsg.responder != responder )
			continue;
		
		if ( msg && NO == [msg isEqualToString:bmsg.message] )
			continue;
		
		[bmsg changeState:BEE_MESSAGE_STATE_CANCELLED];
	}
}

- (void)cancelMessages
{
	[BeeRequestQueue cancelAllRequests];

	[__sharedQueue removeAllObjects];
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		if ( nil == __sharedQueue )
		{
			__sharedQueue = [[NSMutableArray alloc] init];
		}
		
		if ( nil == self.runloopTimer )
		{
			self.runloopTimer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_RUNLOOP_INTERVAL
																 target:self
															   selector:@selector(runloop)
															   userInfo:nil
																repeats:YES];			
		}
	}
	
	return self;
}

- (void)runloop
{
	if ( _pause )
		return;
	
	for ( BeeMessage * bmsg in __sharedQueue )
	{
		[bmsg runloop];
	}
}

- (void)dealloc
{		
	[_runloopTimer invalidate];
	_runloopTimer = nil;
	
	self.whenCreate = nil;
	self.whenUpdate = nil;
	
	[super dealloc];
}

@end

#pragma mark -

@implementation BeeController

static NSMutableArray * __subControllers = nil;

@synthesize prefix = _prefix;
@synthesize mapping = _mapping;

DEF_SINGLETON( BeeController );

+ (NSString *)MESSAGE
{
	return [NSString stringWithFormat:@"message.%@", [self description]];
}

+ (BeeController *)routes:(NSString *)message
{
	BeeController * controller = [BeeController sharedInstance];

	for ( BeeController * subController in __subControllers )
	{
		if ( [message hasPrefix:subController.prefix] )
		{
			controller = subController;
			break;
		}
	}

	return controller;
}

+ (NSArray *)allControllers
{
	return __subControllers;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{		
		if ( nil == __subControllers )
		{
			__subControllers = [[NSMutableArray alloc] init];
		}

		self.mapping = [NSMutableDictionary dictionary];
		self.prefix = [NSString stringWithFormat:@"message.%@", [[self class] description]];

		[self load];

		if ( NO == [__subControllers containsObject:self] )
		{
			[__subControllers addObject:self];			
		}
	}
	
	return self;
}

- (void)dealloc
{	
	if ( [__subControllers containsObject:self] )
	{	
		[__subControllers removeObject:self];
	}

	[self unload];

	self.mapping = nil;
	self.prefix = nil;
	
	[super dealloc];
}

- (void)load
{
}

- (void)unload
{	
}

- (void)index:(BeeMessage *)msg
{
	CC( @"unknown message '%@'", msg.message );

	[msg setLastError:BEE_ERROR_CODE_ROUTES domain:BEE_ERROR_DOMAIN_UNKNOWN desc:@"No routes"];
}

- (void)route:(BeeMessage *)msg
{
	NSArray * array = [_mapping objectForKey:msg.message];
	if ( array && [array count] )
	{
		id target = [array objectAtIndex:0];
		SEL action = (SEL)[[array objectAtIndex:1] unsignedIntValue];
		
		[target performSelector:action withObject:msg];
//		[target performSelectorInBackground:action withObject:msg];
	}
	else
	{
		NSArray * parts = [msg.message componentsSeparatedByString:@"."];
		if ( parts && parts.count )
		{
			NSString * methodName = parts.lastObject;
			if ( methodName && methodName.length )
			{
				NSString *	selectorName = [methodName stringByAppendingString:@":"];
				SEL			selector = NSSelectorFromString(selectorName);
				
				if ( [self respondsToSelector:selector] )
				{
					[self performSelector:selector withObject:msg];
					return;
				}
			}
		}

		[self index:msg];
	}
}

- (void)map:(NSString *)name action:(SEL)action
{
	[self map:name action:action target:self];
}

- (void)map:(NSString *)name action:(SEL)action target:(id)target
{
	NSArray * array = [NSArray arrayWithObjects:target, [NSNumber numberWithUnsignedInt:(NSUInteger)action], nil];
	[_mapping setObject:array forKey:name];
}

@end

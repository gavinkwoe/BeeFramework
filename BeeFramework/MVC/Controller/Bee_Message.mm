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
//  Bee_Message.h
//

#import "Bee_Precompile.h"
#import "Bee_Core.h"
#import "Bee_Message.h"
#import "Bee_MessageQueue.h"
#import "Bee_Controller.h"

#import <objc/runtime.h>

#pragma mark -

#undef	DEFAULT_TIMEOUT_SECONDS
#define	DEFAULT_TIMEOUT_SECONDS		(10.0f)

#pragma mark -

@interface BeeMessage(Private)
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
@synthesize executer = _executer;

@synthesize errorDomain = _errorDomain;
@synthesize errorCode = _errorCode;
@synthesize errorDesc = _errorDesc;

@synthesize	initTimeStamp = _initTimeStamp;
@synthesize	sendTimeStamp = _sendTimeStamp;
@synthesize	recvTimeStamp = _recvTimeStamp;

@synthesize whenUpdate = _whenUpdate;

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
@synthesize callstack = _callstack;
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

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
		_message = [@"nil.nil" retain];
		_input = [[NSMutableDictionary alloc] init];
		_output = [[NSMutableDictionary alloc] init];
		_responder = nil;
		_executer = nil;

		_errorCode = BeeMessage.ERROR_CODE_OK;
		_errorDomain = nil;
		
		_initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		_sendTimeStamp = _initTimeStamp;
		_recvTimeStamp = _initTimeStamp;

		_arrived = NO;

		self.whenUpdate = nil;
		
		if ( [BeeMessageQueue sharedInstance].whenCreate )
		{
			[BeeMessageQueue sharedInstance].whenCreate( self );
		}
		
	#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
		_callstack = [[NSMutableArray alloc] init];
	#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
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

	[_errorDomain release];
	[_errorDesc release];
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	[_callstack removeAllObjects];
	[_callstack release];
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
	self.whenUpdate = nil;
	
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

- (void)didMessageTimeout
{
	_timer = nil;
	_timeout = YES;
	_emitted = NO;
	
	[self changeState:BeeMessage.STATE_CANCELLED];
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
		if ( self.whenUpdate )
		{
			self.whenUpdate( self );
		}

		[self callResponder];		
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
		
		[self callResponder];
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

		[self callResponder];
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

		[self callResponder];
	}
}

- (void)internalNotifyProgressUpdated
{
	if ( NO == _toldProgress )
		return;
	
	_state = BeeMessage.STATE_WAITING;
	_progressed = YES;
	
	if ( NO == self.disabled )
	{
		if ( self.whenUpdate )
		{
			self.whenUpdate( self );
		}

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

	NSArray * array = [_message componentsSeparatedByString:@"."];
	if ( array && array.count > 1 )
	{
//		NSString * prefix = (NSString *)[array objectAtIndex:0];
		NSString * clazz = (NSString *)[array objectAtIndex:1];
		NSString * name = (NSString *)[array objectAtIndex:2];

	#if defined(__BEE_SELECTOR_STYLE2__) && __BEE_SELECTOR_STYLE2__
		{
			NSString * selectorName;
			SEL selector;
			
			selectorName = [NSString stringWithFormat:@"handleMessage_%@_%@:", clazz, name];
			selector = NSSelectorFromString(selectorName);
			
			if ( [obj respondsToSelector:selector] )
			{
				[obj performSelector:selector withObject:self];
				return;
			}
			
			selectorName = [NSString stringWithFormat:@"handleMessage_%@:", clazz];
			selector = NSSelectorFromString(selectorName);
			
			if ( [obj respondsToSelector:selector] )
			{
				[obj performSelector:selector withObject:self];
				return;
			}
		}
	#endif	// #if defined(__BEE_SELECTOR_STYLE2__) && __BEE_SELECTOR_STYLE2__

	#if defined(__BEE_SELECTOR_STYLE1__) && __BEE_SELECTOR_STYLE1__
		{
			NSString * selectorName;
			SEL selector;

			selectorName = [NSString stringWithFormat:@"handle%@:", clazz];
			selector = NSSelectorFromString( selectorName );
			
			if ( [obj respondsToSelector:selector] )
			{
				[obj performSelector:selector withObject:self];
				return;
			}
		}
	#endif	// #if defined(__BEE_SELECTOR_STYLE1__) && __BEE_SELECTOR_STYLE1__
	}
	
	if ( obj && [obj respondsToSelector:@selector(handleMessage:)] )
	{
		[obj performSelector:@selector(handleMessage) withObject:self];
	}	
}

- (BeeMessage *)send
{
	if ( YES == _emitted )
		return self;

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	[_callstack addObjectsFromArray:[BeeRuntime callstack:16]];
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

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
		
		CC( @"output, %@ = %@", [key description], [value description] );
		
		[self.output setObject:value forKey:key];
	}
	
	va_end( args );
	return self;
}

- (BeeMessage *)cancel
{
	if ( NO == _emitted || nil == _executer )
		return self;
	
	[self changeState:BeeMessage.STATE_CANCELLED];
	return self;
}

- (BeeMessage *)reset
{
	[self cancelRequests];
	[self internalStopTimer];

	self.responder = nil;
	self.whenUpdate = nil;

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

	CC( @"msg '%@', state %d => %d", _message, _state, newState );

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
	
	// Find an executer
	if ( nil == _executer )
	{
		self.executer = [BeeController routes:_message];
		if ( nil == self.executer )
			return;
	}
		
	if ( [_executer respondsToSelector:@selector(route:)] )
	{
		[_executer route:self];
	}
	else
	{
		[_executer index:self];
	}
	
	if ( BeeMessage.ERROR_CODE_OK != _errorCode )
	{
		_state = BeeMessage.STATE_FAILED;
	}

	if ( BeeMessage.STATE_CREATED == _state )
	{
		// TODO: nothing to do
	}
	else if ( BeeMessage.STATE_SENDING == _state )
	{
	#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
		CC( @"[REQUEST]\n'%@'.parameters = %@", _message, [_input description] );
	#endif	//#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

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
		// TODO: nothing to do
	}
	else if ( BeeMessage.STATE_SUCCEED == _state )
	{
		if ( _nextState == _state )
        {
		#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
			CC( @"[SUCCEED]\n'%@'.input = \n%@\n'%@'.output = \n%@\n",
			   _message, [_input description],
			   _message, [_output description]
			   );
		#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
			
			[self internalStopTimer];
			[self internalNotifySucceed];
			
			shouldRemove = YES;
		}
	}
	else if ( BeeMessage.STATE_FAILED == _state )
	{
		if ( _nextState == _state )
        {
		#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
			CC( @"[FAILED]\n'%@'.input = \n%@\n", _message, [_input description] );
		#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
			
			[self internalStopTimer];
			[self internalNotifyFailed];	

			shouldRemove = YES;
		}
	}
	else if ( BeeMessage.STATE_CANCELLED == _state )
	{
        if ( _nextState == _state )
        {
		#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
			CC( @"[CANCELLED]\n'%@'.input = %@", _message, [_input description] );
		#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
			
			[self cancelRequests];
			
			[self internalStopTimer];	
			[self internalNotifyCancelled];

			shouldRemove = YES;
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
		va_list args;
		va_start( args, first );
		
		NSString *	key = (NSString *)first;
		NSObject *	value = va_arg( args, NSObject * );
		
		if ( key && value )
		{
			[self.input setObject:value atPath:key];
		}
		
		va_end( args );
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeMessageBlockN)OUTPUT
{
	BeeMessageBlockN block = ^ BeeMessage * ( id first, ... )
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

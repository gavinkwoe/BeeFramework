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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_UISignal.h"
#import "Bee_UISignalBus.h"

#import "UIView+Tag.h"
#import "UIView+UIViewController.h"
#import "UIView+BeeUISignal.h"
#import "UIViewController+BeeUISignal.h"

#pragma mark -

#undef	MAX_POOL_SIZE
#define MAX_POOL_SIZE	(30)

#undef	KEY_SIGNAL_RECEIVER
#define KEY_SIGNAL_RECEIVER	"UIView.signalReiceiver"

#pragma mark - 

@implementation NSObject(BeeUISignalResponder)

@dynamic signalReceiver;

- (id)signalReceiver
{
	return objc_getAssociatedObject( self, KEY_SIGNAL_RECEIVER );
}

- (void)setSignalReceiver:(id)receiver
{
	objc_setAssociatedObject( self, KEY_SIGNAL_RECEIVER, receiver, OBJC_ASSOCIATION_ASSIGN );
}

+ (NSString *)SIGNAL
{
	return [self SIGNAL_TYPE];
}

+ (NSString *)SIGNAL_TYPE
{
	return [NSString stringWithFormat:@"signal.%@.", [self description]];
}

- (BOOL)isUISignalResponder
{
	return NO;
}

- (NSString *)signalNamespace
{
	return nil;
}

- (NSString *)signalTag
{
	return nil;
}

- (NSObject *)signalTarget
{
	return nil;
}

- (void)handleUISignal:(BeeUISignal *)signal
{
}

@end

#pragma mark -

@interface BeeUISignal()
{
	BOOL				_inited;

	BOOL				_foreign;
	id					_foreignSource;
	id					_source;
	id					_target;

	NSUInteger			_state;

	NSUInteger			_jumpCount;
	NSMutableArray *	_jumpPath;

	NSString *			_name;
	NSString *			_prefix;
	NSObject *			_object;
	NSObject *			_returnValue;
	
	NSTimeInterval		_initTimeStamp;
	NSTimeInterval		_sendTimeStamp;
	NSTimeInterval		_arriveTimeStamp;
}

- (void)changeState:(NSUInteger)state;

@end

#pragma mark -

@implementation BeeUISignal

DEF_INT( STATE_INIT,	0 )
DEF_INT( STATE_SENDING,	1 )
DEF_INT( STATE_ARRIVED,	2 )
DEF_INT( STATE_DEAD,	3 )

@synthesize foreign = _foreign;
@synthesize foreignSource = _foreignSource;
@synthesize source = _source;
@synthesize target = _target;

@dynamic state;
@dynamic sending;
@dynamic arrived;
@dynamic dead;

@synthesize jumpCount = _jumpCount;
@synthesize jumpPath = _jumpPath;

@dynamic prettyName;
@synthesize name = _name;
@synthesize prefix = _prefix;
@synthesize object = _object;
@synthesize returnValue = _returnValue;

@synthesize initTimeStamp = _initTimeStamp;
@synthesize sendTimeStamp = _sendTimeStamp;
@synthesize arriveTimeStamp = _arriveTimeStamp;

@dynamic timeElapsed;
@dynamic timeCostPending;
@dynamic timeCostExecution;

@dynamic SOURCE;
@dynamic TARGET;
@dynamic OBJECT;
@dynamic DIE;
@dynamic RETURN;
@dynamic RETURN_YES;
@dynamic RETURN_NO;

#pragma mark -

+ (BeeUISignal *)signal
{
	return [[[BeeUISignal alloc] init] autorelease];
}

- (void)initSelf
{
	if ( NO == _inited )
	{
		_inited = YES;

		_foreign = NO;
		_foreignSource = nil;
		_source = nil;
		_target = nil;
		
		_state = BeeUISignal.STATE_INIT;
		_jumpCount = 0;
		_jumpPath = [[NSMutableArray alloc] init];
		
		self.name = @"signal.nil.nil";
		self.prefix = nil;
		self.object = nil;
		self.returnValue = nil;
		
		_initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		_sendTimeStamp = _initTimeStamp;
		_arriveTimeStamp = _initTimeStamp;
	}
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)dealloc
{
	[_jumpPath removeAllObjects];
	[_jumpPath release];

	self.name = nil;
	self.prefix = nil;
	self.object = nil;
	self.returnValue = nil;

	[super dealloc];
}

- (NSString *)prettyName
{
	return [self.name stringByReplacingOccurrencesOfString:@"signal." withString:@""];
}

- (NSString *)description
{
#if __BEE_DEVELOPMENT__
	return [NSString stringWithFormat:@"[%@] > %@", self.prettyName, [self.jumpPath join:@" > "]];
#else	// #if __BEE_DEVELOPMENT__
	return self.name;
#endif	// #if __BEE_DEVELOPMENT__
}

- (BOOL)is:(NSString *)name
{
	return [self.name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
	return [self.name hasPrefix:prefix];
}

- (BOOL)isSentFrom:(id)source
{
	return (self.source == source) ? YES : NO;
}

- (NSUInteger)state
{
	return _state;
}

- (void)setState:(NSUInteger)newState
{
	[self changeState:newState];
}

- (BOOL)sending
{
	return BeeUISignal.STATE_SENDING == _state ? YES : NO;
}

- (void)setSending:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:BeeUISignal.STATE_SENDING];
	}
}

- (BOOL)arrived
{
	return BeeUISignal.STATE_ARRIVED == _state ? YES : NO;
}

- (void)setArrived:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:BeeUISignal.STATE_ARRIVED];
	}
}

- (BOOL)dead
{
	return BeeUISignal.STATE_DEAD == _state ? YES : NO;
}

- (void)setDead:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:BeeUISignal.STATE_DEAD];
	}
}

- (void)changeState:(NSUInteger)newState
{
	if ( newState != _state )
	{
//		INFO( @"signal %@, state %d -> %d", self.prettyName, _state, newState );
		
		if ( BeeUISignal.STATE_SENDING == newState )
		{
			_sendTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		}
		else if ( BeeUISignal.STATE_ARRIVED == newState )
		{
			_arriveTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		}
		else if ( BeeUISignal.STATE_DEAD == newState )
		{
			_arriveTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		}

		_state = newState;
	}
}

- (void)log:(id)target
{
	if ( self.arrived || self.dead )
		return;
	
#if __BEE_DEVELOPMENT__
	if ( target )
	{
		NSString * className = [[target class] description];
		NSString * lastClassName = [_jumpPath lastObject];
		
		if ( lastClassName && [className isEqualToString:lastClassName] )
		{
//			WARN( @"duplicate class name %@", className );
		}
		else
		{
			[_jumpPath addObject:className];	
		}
	}
#endif	// #if __BEE_DEVELOPMENT__

	_jumpCount += 1;
}

- (BOOL)send
{
	return [BeeUISignalBus send:self];
}

- (BOOL)forward
{
	return [BeeUISignalBus forward:self];
}

- (BOOL)forward:(id)target
{
	return [BeeUISignalBus forward:self to:target];
}

- (NSTimeInterval)timeElapsed
{
	return _arriveTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostPending
{
	return _sendTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostExecution
{
	return _arriveTimeStamp - _sendTimeStamp;
}

- (BOOL)boolValue
{
	if ( nil == _returnValue || NO == [_returnValue isKindOfClass:[NSNumber class]] )
		return NO;

	return [(NSNumber *)_returnValue boolValue];
}

- (void)returnYES
{
	self.returnValue = [NSNumber numberWithBool:YES];
}

- (void)returnNO
{
	self.returnValue = [NSNumber numberWithBool:NO];
}

- (void)returnValue:(id)value
{
	self.returnValue = value;
}

#pragma mark -

- (BeeUISignalBlockN)SOURCE
{
	BeeUISignalBlockN block = ^ BeeUISignal * ( id first, ... )
	{
		self.source = first;
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUISignalBlockN)TARGET
{
	BeeUISignalBlockN block = ^ BeeUISignal * ( id first, ... )
	{
		self.target = first;
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUISignalBlockN)OBJECT
{
	BeeUISignalBlockN block = ^ BeeUISignal * ( id first, ... )
	{
		self.object = first;
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUISignalBlock)DIE
{
	BeeUISignalBlock block = ^ BeeUISignal * ( void )
	{
		self.state = BeeUISignal.STATE_DEAD;
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeUISignalBlockN)RETURN
{
	BeeUISignalBlockN block = ^ BeeUISignal * ( id first, ... )
	{
		self.returnValue = first;
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUISignalBlock)RETURN_YES
{
	BeeUISignalBlock block = ^ BeeUISignal * ( void )
	{
		self.returnValue = [NSNumber numberWithBool:YES];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUISignalBlock)RETURN_NO
{
	BeeUISignalBlock block = ^ BeeUISignal * ( void )
	{
		self.returnValue = [NSNumber numberWithBool:NO];
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

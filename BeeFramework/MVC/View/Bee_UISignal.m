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
//  Bee_UISignal.m
//

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_Singleton.h"
#import "Bee_Log.h"
#import "Bee_Performance.h"

#import <objc/runtime.h>

#pragma mark -

#undef	MAX_POOL_SIZE
#define MAX_POOL_SIZE	(8)

#pragma mark - 

@implementation NSObject(BeeUISignalResponder)

+ (NSString *)SIGNAL
{
	return [NSString stringWithFormat:@"signal.%@.", [self description]];
}

- (BOOL)isUISignalResponder
{
	if ( [self respondsToSelector:@selector(handleUISignal:)] )
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

@end

#pragma mark -

@interface BeeUISignal(Private)
- (void)routes;
@end

#pragma mark -

@implementation BeeUISignal

@synthesize dead = _dead;
@synthesize reach = _reach;
@synthesize jump = _jump;
@synthesize source = _source;
@synthesize target = _target;
@synthesize name = _name;
@synthesize object = _object;
@synthesize returnValue = _returnValue;

@synthesize initTimeStamp = _initTimeStamp;
@synthesize sendTimeStamp = _sendTimeStamp;
@synthesize reachTimeStamp = _reachTimeStamp;

@synthesize timeElapsed;
@synthesize timeCostPending;
@synthesize timeCostExecution;

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
@synthesize callPath = _callPath;
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

DEF_STATIC_PROPERTY( YES_VALUE );
DEF_STATIC_PROPERTY( NO_VALUE );

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self clear];
	}
	return self;
}

- (NSString *)description
{
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	return [NSString stringWithFormat:@"%@ > %@", _name, _callPath];
#else	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	return [NSString stringWithFormat:@"%@", _name];
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
}

- (BOOL)is:(NSString *)name
{
	return [_name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
	return [_name hasPrefix:prefix];
}

- (BOOL)isSentFrom:(id)source
{
	return (self.source == source) ? YES : NO;
}

- (BOOL)send
{	
	if ( _dead )
		return NO;
	
	_sendTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	if ( _source == _target )
	{
		[_callPath appendFormat:@"%@", [[_source class] description]];
	}
	else
	{
		[_callPath appendFormat:@"%@ > %@", [[_source class] description], [[_target class] description]];
	}
		
	if ( _reach )
	{
		[_callPath appendFormat:@" > [DONE]"];
	}
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

	if ( [_target isUISignalResponder] )
	{
		_jump = 1;
		
		[self routes];
	}
	else
	{
		_reachTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		_reach = YES;		
	}

	return _reach;
}

- (BOOL)forward:(id)target
{	
	if ( _dead )
		return NO;

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	[_callPath appendFormat:@" > %@", [[target class] description]];
	
	if ( _reach )
	{
		[_callPath appendFormat:@" > [DONE]"];
	}
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

	if ( [target isUISignalResponder] )
	{
		_jump += 1;

		_target = target;	
		
		[self routes];
	}
	else
	{
		_reachTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		_reach = YES;		
	}

	return _reach;
}

- (void)routes
{
	NSArray * array = [_name componentsSeparatedByString:@"."];
	if ( array && array.count > 1 )
	{
//		NSString * prefix = (NSString *)[array objectAtIndex:0];
		NSString * clazz = (NSString *)[array objectAtIndex:1];

		NSString *	selectorName = [NSString stringWithFormat:@"handle%@:", clazz];
		SEL			selector = NSSelectorFromString(selectorName);
		
		if ( [_target respondsToSelector:selector] )
		{
			[_target performSelector:selector withObject:self];
			return;
		}
	}

	Class rtti = [_source class];
	for ( ;; )
	{
		if ( nil == rtti )
			break;
		
		NSString *	selectorName = [NSString stringWithFormat:@"handle%@:", [rtti description]];
		SEL			selector = NSSelectorFromString(selectorName);

		if ( [_target respondsToSelector:selector] )
		{
			[_target performSelector:selector withObject:self];
			break;
		}
	
		rtti = class_getSuperclass( rtti );
	}

	if ( nil == rtti )
	{
		[_target handleUISignal:self];	
	}
}

- (NSTimeInterval)timeElapsed
{
	return _reachTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostPending
{
	return _sendTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostExecution
{
	return _reachTimeStamp - _sendTimeStamp;
}

- (void)clear
{
	self.dead = NO;
	self.reach = NO;
	self.jump = 0;
	self.source = nil;
	self.target = nil;
	self.name = @"signal.nil.nil";
	self.object = nil;
	self.returnValue = nil;
	
	_initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	_sendTimeStamp = _initTimeStamp;
	_reachTimeStamp = _initTimeStamp;

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	self.callPath = [NSMutableString string];
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
}

- (BOOL)boolValue
{
	if ( self.returnValue == BeeUISignal.YES_VALUE )
	{
		return YES;
	}
	else if ( self.returnValue == BeeUISignal.NO_VALUE )
	{
		return NO;
	}
	
	return NO;
}

- (void)returnYES
{
	self.returnValue = BeeUISignal.YES_VALUE;
}

- (void)returnNO
{
	self.returnValue = BeeUISignal.NO_VALUE;
}

- (void)dealloc
{
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	[_callPath release];
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
	[_name release];

	[_object release];
	[_returnValue release];
	
	[super dealloc];
}

@end

#pragma mark -

@implementation UIView(BeeUISignal)

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( self.superview )
	{
		[signal forward:self.superview];
	}
	else
	{
		signal.reach = YES;

	#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
		CC( @"[%@] > %@", signal.name, signal.callPath );
	#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	}
}

- (BeeUISignal *)sendUISignal:(NSString *)name
{
	return [self sendUISignal:name withObject:nil from:self];
}

- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object
{
	return [self sendUISignal:name withObject:object from:self];
}

- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object from:(id)source
{
	BeeUISignal * signal = [[[BeeUISignal alloc] init] autorelease];
	if ( signal )
	{
		signal.source = source ? source : self;
		signal.target = self;
		signal.name = name;		
		signal.object = object;
		[signal send];
	}
	return signal;
}

@end

#pragma mark -

@implementation UIViewController(BeeUISignal)

- (void)handleUISignal:(BeeUISignal *)signal
{
	signal.reach = YES;
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"[%@] > %@", signal.name, signal.callPath );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
}

- (BeeUISignal *)sendUISignal:(NSString *)name
{
	return [self sendUISignal:name withObject:nil from:self];
}

- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object
{
	return [self sendUISignal:name withObject:object from:self];
}

- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object from:(id)source
{
	BeeUISignal * signal = [[[BeeUISignal alloc] init] autorelease];
	if ( signal )
	{
		signal.source = source ? source : self;
		signal.target = self;
		signal.name = name;
		signal.object = object;
		[signal send];
	}
	return signal;
}

@end

#pragma mark -

@interface UISingleTapGestureRecognizer : UITapGestureRecognizer
{
	NSString *	_signalName;
	NSObject *	_signalObject;
}

@property (nonatomic, retain) NSString *	signalName;
@property (nonatomic, assign) NSObject *	signalObject;

@end

#pragma mark -

@implementation UISingleTapGestureRecognizer

@synthesize signalName = _signalName;
@synthesize signalObject = _signalObject;

- (id)initWithTarget:(id)target action:(SEL)action
{
	self = [super initWithTarget:target action:action];
	if ( self )
	{
		self.numberOfTapsRequired = 1;
		self.numberOfTouchesRequired = 1;
		self.cancelsTouchesInView = YES;
		self.delaysTouchesBegan = YES;
		self.delaysTouchesEnded = YES;		
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end

#pragma mark -

@implementation UIView(BeeTappable)

DEF_SIGNAL( TAPPED );

- (void)didSingleTapped:(UITapGestureRecognizer *)tapGesture
{
	if ( [tapGesture isKindOfClass:[UISingleTapGestureRecognizer class]] )
	{
		UISingleTapGestureRecognizer * gesture = (UISingleTapGestureRecognizer *)tapGesture;
		if ( UIGestureRecognizerStateEnded == gesture.state )
		{
			if ( gesture.signalName )
			{
				[self sendUISignal:gesture.signalName withObject:gesture.signalObject];
			}
			else
			{
				[self sendUISignal:UIView.TAPPED];
			}
		}
	}		
}

- (void)makeTappable
{
	[self makeTappable:nil];
}

- (void)makeTappable:(NSString *)signal
{
	[self makeTappable:signal withObject:nil];
}

- (void)makeTappable:(NSString *)signal withObject:(NSObject *)obj
{
	self.userInteractionEnabled = YES;
	
	UISingleTapGestureRecognizer * singleTapGesture = nil;
	for ( UITapGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[UISingleTapGestureRecognizer class]] )
		{
			singleTapGesture = (UISingleTapGestureRecognizer *)gesture;
		}
	}
	
	if ( nil == singleTapGesture )
	{
		singleTapGesture = [[[UISingleTapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTapped:)] autorelease];
		[self addGestureRecognizer:singleTapGesture];
	}
	
	singleTapGesture.signalName = signal;
	singleTapGesture.signalObject = obj;
}

- (void)makeUntappable
{
	self.userInteractionEnabled = NO;
	
	for ( UITapGestureRecognizer * gesture in self.gestureRecognizers )
	{
		[self removeGestureRecognizer:gesture];
	}
}

@end

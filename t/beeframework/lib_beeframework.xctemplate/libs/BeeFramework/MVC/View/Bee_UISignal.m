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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_Singleton.h"
#import "Bee_Log.h"
#import "Bee_Performance.h"
#import "UIView+BeeExtension.h"

#import <objc/runtime.h>

#pragma mark -

#undef	MAX_POOL_SIZE
#define MAX_POOL_SIZE	(8)

#define __USE_FOREIGN__	(1)

#pragma mark - 

@implementation NSObject(BeeUISignalResponder)

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

@synthesize foreign = _foreign;
@synthesize foreignSource = _foreignSource;

@synthesize dead = _dead;
@synthesize reach = _reach;
@synthesize jump = _jump;
@synthesize source = _source;
@synthesize target = _target;
@synthesize name = _name;
@synthesize namePrefix = _namePrefix;
@synthesize object = _object;
@synthesize returnValue = _returnValue;
@synthesize preSelector = _preSelector;

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

#if __USE_FOREIGN__
	NSArray * nameComponents = [_name componentsSeparatedByString:@"."];
	if ( nameComponents.count > 2 && [[nameComponents objectAtIndex:0] isEqualToString:@"signal"] )
	{
		NSString * sourceClassName = [[_source class] description];
		NSString * namePrefix = [nameComponents objectAtIndex:1];

		if ( [sourceClassName isEqualToString:namePrefix] )
		{
			self.foreign = NO;
		}
		else
		{
			self.namePrefix = namePrefix;
			
			self.foreign = YES;
			self.foreignSource = self.source;
		}
	}
	else
	{
		self.foreign = NO;
	}
#endif	// #if __USE_FOREIGN__

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

	if ( [_target isKindOfClass:[UIView class]] || [_target isKindOfClass:[UIViewController class]] )
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

#if __USE_FOREIGN__
	if ( _foreign )
	{
		if ( self.source == self.foreignSource )
		{
			NSString * targetClassName = [[target class] description];
			if ( [targetClassName isEqualToString:self.namePrefix] )
			{
				self.source = target;
			}	
//			else
//			{
//				Class targetClass = NSClassFromString( targetClassName );
//				Class sourceClass = NSClassFromString( self.namePrefix );
//				
//				if ( sourceClass == targetClass || [targetClass isSubclassOfClass:sourceClass] )
//				{
//					self.source = target;
//				}
//			}
		}
	}
#endif	// #if __USE_FOREIGN__

	if ( [_target isKindOfClass:[UIView class]] || [_target isKindOfClass:[UIViewController class]] )
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
// forward signal to user specialized signal handler first
	
	if ( _preSelector && _preSelector.length )
	{
		NSString *	selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", _preSelector];
		SEL			selector = NSSelectorFromString(selectorName);

		if ( [_target respondsToSelector:selector] )
		{
			[_target performSelector:selector withObject:self];
			return;
		}
	}

// then guess signal handler
	
	NSArray * array = [_name componentsSeparatedByString:@"."];
	if ( array && array.count > 1 )
	{
//		NSString * prefix = (NSString *)[array objectAtIndex:0];
		NSString * clazz = (NSString *)[array objectAtIndex:1];
		NSString * method = (NSString *)[array objectAtIndex:2];

		NSObject * targetObject = _target;
		
		if ( [_target isKindOfClass:[UIView class]] )
		{
			UIViewController * viewController = [(UIView *)_target viewController];
			if ( viewController )
			{
				targetObject = viewController;
			}
		}

	#if defined(__BEE_SELECTOR_STYLE2__) && __BEE_SELECTOR_STYLE2__
		{
			NSString * selectorName;
			SEL selector;
			
			selectorName = [NSString stringWithFormat:@"handleUISignal_%@_%@:", clazz, method];
			selector = NSSelectorFromString(selectorName);
			
			if ( [targetObject respondsToSelector:selector] )
			{
				[targetObject performSelector:selector withObject:self];
				return;
			}
			
			selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", clazz];
			selector = NSSelectorFromString(selectorName);
			
			if ( [targetObject respondsToSelector:selector] )
			{
				[targetObject performSelector:selector withObject:self];
				return;
			}
		}
	#endif	// #if defined(__BEE_SELECTOR_STYLE2__) && __BEE_SELECTOR_STYLE2__

	#if defined(__BEE_SELECTOR_STYLE1__) && __BEE_SELECTOR_STYLE1__
		{
			NSString * selectorName;
			SEL selector;
		
			selectorName = [NSString stringWithFormat:@"handle%@:", clazz];
			selector = NSSelectorFromString(selectorName);
			
			if ( [targetObject respondsToSelector:selector] )
			{
				[targetObject performSelector:selector withObject:self];
				return;
			}
		}
	#endif	// #if defined(__BEE_SELECTOR_STYLE1__) && __BEE_SELECTOR_STYLE1__		
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
		if ( [_target respondsToSelector:@selector(handleUISignal:)] )
		{
			[_target performSelector:@selector(handleUISignal:) withObject:self];
		}
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
	[_namePrefix release];

	[_object release];
	[_returnValue release];
	
	[_preSelector release];
	
	[super dealloc];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

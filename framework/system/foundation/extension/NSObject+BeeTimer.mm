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

#import "NSObject+BeeTimer.h"

#import "Bee_UnitTest.h"
#import "NSDictionary+BeeExtension.h"
#import "NSTimer+BeeExtension.h"
#import "NSArray+BeeExtension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface TimerAgent : NSObject
{
	NSMutableArray * _timers;
}

@property (nonatomic, retain) NSMutableArray * timers;

@end

#pragma mark -

@implementation TimerAgent

@synthesize timers = _timers;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_timers = [[NSMutableArray nonRetainingArray] retain];
	}
	return self;
}

- (void)dealloc
{
	for ( NSTimer * timer in _timers )
	{
		[timer invalidate];
	}

	[_timers removeAllObjects];
	[_timers release];
	
	[super dealloc];
}

- (NSTimer *)timerForName:(NSString *)name
{
	for ( NSTimer * timer in _timers )
	{
		if ( [timer.name isEqualToString:name] )
			return timer;
	}

	return nil;
}

@end

#pragma mark -

@implementation NSObject(BeeTimer)

- (TimerAgent *)__timerAgent
{
	TimerAgent * agent = objc_getAssociatedObject( self, "NSObject.timerAgent" );
	if ( nil == agent )
	{
		agent = [[[TimerAgent alloc] init] autorelease];
		
		objc_setAssociatedObject( self, "NSObject.timerAgent", agent, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
	
	return agent;
}

- (NSTimer *)timer:(NSTimeInterval)interval
{
	return [self timer:interval repeat:NO name:nil];
}

- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat
{
	return [self timer:interval repeat:repeat name:nil];
}

- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name
{
	TimerAgent * agent = [self __timerAgent];
	
	NSTimer * timer = [agent timerForName:name];
	if ( nil == timer )
	{
		timer = [NSTimer timerWithTimeInterval:interval
										target:self
									  selector:@selector(handleTimer:)
									  userInfo:nil
									   repeats:repeat];
		timer.name = name;
		[agent.timers addObject:timer];
	}

	return timer;
}

- (void)cancelTimer:(NSString *)name
{
	TimerAgent * agent = [self __timerAgent];
	
	NSTimer * timer = [agent timerForName:name];
	if ( timer )
	{
		[timer invalidate];
		[agent.timers removeObject:timer];
	}
}

- (void)cancelAllTimers
{
	TimerAgent * agent = [self __timerAgent];
	
	for ( NSTimer * timer in agent.timers )
	{
		[timer invalidate];
	}
	
	[agent.timers removeAllObjects];
}

- (void)handleTimer:(NSTimer *)timer
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSObject_BeeTimer )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

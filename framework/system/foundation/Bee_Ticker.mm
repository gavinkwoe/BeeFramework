//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#import "Bee_Ticker.h"
#import "Bee_UnitTest.h"
#import "NSArray+BeeExtension.h"
#import "NSObject+BeeTicker.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface BeeTicker()
{
	NSTimer *			_timer;
	NSTimeInterval		_lastTick;
	NSMutableArray *	_receivers;
}

- (void)performTick;

@end

#pragma mark -

@implementation BeeTicker

@synthesize timer = _timer;
@synthesize lastTick = _lastTick;

DEF_SINGLETON( BeeTicker )

- (id)init
{
	self = [super init];
	if ( self )
	{
		_receivers = [[NSMutableArray nonRetainingArray] retain];
	}
	
	return self;
}

- (void)addReceiver:(NSObject *)obj
{
	if ( NO == [_receivers containsObject:obj] )
	{
		[_receivers addObject:obj];
		
		if ( nil == _timer )
		{
			_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0f)
													  target:self 
													selector:@selector(performTick) 
													userInfo:nil
													 repeats:YES];
			
			_lastTick = [NSDate timeIntervalSinceReferenceDate];
		}
	}
}

- (void)removeReceiver:(NSObject *)obj
{
	[_receivers removeObject:obj];
	
	if ( 0 == _receivers.count )
	{
		[_timer invalidate];
		_timer = nil;
	}
}

- (void)performTick
{
	NSTimeInterval tick = [NSDate timeIntervalSinceReferenceDate];
	NSTimeInterval elapsed = tick - _lastTick;
	
	for ( NSObject * obj in _receivers )
	{
		if ( [obj respondsToSelector:@selector(handleTick:)] )
		{
			[obj handleTick:elapsed];
		}
	}

	_lastTick = tick;
}

- (void)dealloc
{
	[_timer invalidate];
	_timer = nil;
	
	[_receivers removeAllObjects];
	[_receivers release];

	[super dealloc];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( BeeTicker )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

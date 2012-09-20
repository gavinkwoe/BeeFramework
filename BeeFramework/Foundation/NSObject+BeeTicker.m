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
//  NSObject+BeeTicker.m
//

#import <Foundation/Foundation.h>
#import "NSObject+BeeTicker.h"
#import "NSArray+BeeExtension.h"
#import "Bee_Singleton.h"

#pragma mark -

@interface BeeTicker : NSObject
{
	NSTimer *			_timer;
	NSTimeInterval		_lastTick;
	NSMutableArray *	_receives;
}

@property (nonatomic, readonly)	NSTimer *			timer;
@property (nonatomic, readonly)	NSTimeInterval		lastTick;

AS_SINGLETON( BeeTicker )

- (void)addReceive:(NSObject *)obj;
- (void)removeReceive:(NSObject *)obj;

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
		_receives = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)addReceive:(NSObject *)obj
{
	if ( NO == [_receives containsObject:obj] )
	{
		[_receives addObjectNoRetain:obj];
		
		if ( nil == _timer )
		{
			_timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
													  target:self 
													selector:@selector(performTick) 
													userInfo:nil
													 repeats:YES];
			
			_lastTick = [NSDate timeIntervalSinceReferenceDate];
		}
	}
}

- (void)removeReceive:(NSObject *)obj
{
	[_receives removeObjectNoRelease:obj];
	
	if ( 0 == _receives.count )
	{
		[_timer invalidate];
		_timer = nil;
	}
}

- (void)performTick
{
	NSTimeInterval tick = [NSDate timeIntervalSinceReferenceDate];
	NSTimeInterval elapsed = tick - _lastTick;
	
	for ( NSObject * obj in _receives )
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
	
	[_receives removeAllObjectsNoRelease];
	[_receives release];

	[super dealloc];
}

@end

#pragma mark -

@implementation NSObject(BeeTicker)

- (void)observeTick
{
	[[BeeTicker sharedInstance] addReceive:self];
}

- (void)unobserveTick
{
	[[BeeTicker sharedInstance] removeReceive:self];
}

- (void)handleTick:(NSTimeInterval)elapsed
{
}

@end

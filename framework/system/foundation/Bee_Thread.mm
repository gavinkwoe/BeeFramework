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

#import "Bee_Thread.h"
#import "Bee_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( BeePackage, BeeThread, thread );
DEF_PACKAGE( BeePackage, BeeThread, taskQueue );

#pragma mark -

@interface BeeThread()
{
	dispatch_queue_t _foreQueue;
	dispatch_queue_t _backQueue;
}
@end

@implementation BeeThread

DEF_SINGLETON( BeeThread )

@dynamic MAIN;
@dynamic FORK;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_foreQueue = dispatch_get_main_queue();
		_backQueue = dispatch_queue_create( "com.Bee.taskQueue", nil );
	}
	
	return self;
}

+ (dispatch_queue_t)foreQueue
{
	return [[BeeThread sharedInstance] foreQueue];
}

- (dispatch_queue_t)foreQueue
{
	return _foreQueue;
}

+ (dispatch_queue_t)backQueue
{
	return [[BeeThread sharedInstance] backQueue];
}

- (dispatch_queue_t)backQueue
{
	return _backQueue;
}

- (void)dealloc
{
	[super dealloc];
}

+ (void)enqueueForeground:(dispatch_block_t)block
{
	return [[BeeThread sharedInstance] enqueueForeground:block];
}

- (void)enqueueForeground:(dispatch_block_t)block
{
	dispatch_async( _foreQueue, block );
}

+ (void)enqueueBackground:(dispatch_block_t)block
{
	return [[BeeThread sharedInstance] enqueueBackground:block];
}

- (void)enqueueBackground:(dispatch_block_t)block
{
	dispatch_async( _backQueue, block );
}

+ (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	[[BeeThread sharedInstance] enqueueForegroundWithDelay:ms block:block];
}

- (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
	dispatch_after( time, _foreQueue, block );	
}

+ (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	[[BeeThread sharedInstance] enqueueBackgroundWithDelay:ms block:block];
}

- (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
	dispatch_after( time, _backQueue, block );	
}

- (BeeThreadBlock)MAIN
{
	BeeThreadBlock block = ^ BeeThread * ( dispatch_block_t block )
	{
		[self enqueueForeground:block];
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeThreadBlock)FORK
{
	BeeThreadBlock block = ^ BeeThread * ( dispatch_block_t block )
	{
		[self enqueueBackground:block];
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

TEST_CASE( BeeThread )
{
	static int __flag = 0;

	HERE( "run in background", {
		
		BACKGROUND_BEGIN
		{
			EXPECTED( NO == [NSThread isMainThread] );
			EXPECTED( 0 == __flag );
			
			__flag = 1;
			
			FOREGROUND_BEGIN
			{
				EXPECTED( YES == [NSThread isMainThread] );
				EXPECTED( 1 == __flag );
				
				__flag = 0;
				
				BACKGROUND_BEGIN
				{
					EXPECTED( NO == [NSThread isMainThread] );
					EXPECTED( 0 == __flag );
					
					__flag = 1;
					
					FOREGROUND_BEGIN
					{
						EXPECTED( YES == [NSThread isMainThread] );
						EXPECTED( 1 == __flag );
						
						__flag = 2;
						
						// done
					}
					FOREGROUND_COMMIT
				}
				BACKGROUND_COMMIT
			}
			FOREGROUND_COMMIT
		}
		BACKGROUND_COMMIT
	});
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

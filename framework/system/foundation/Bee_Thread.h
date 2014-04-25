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

#import "Bee_Precompile.h"
#import "Bee_Package.h"
#import "Bee_Singleton.h"

#pragma mark -

AS_PACKAGE( BeePackage, BeeThread, thread );
AS_PACKAGE( BeePackage, BeeThread, taskQueue );

#pragma mark -

@class BeeThread;
@compatibility_alias BeeTaskQueue BeeThread;

typedef BeeThread * (^BeeThreadBlock)( dispatch_block_t block );

#pragma mark -

#define FOREGROUND_BEGIN		[BeeThread enqueueForeground:^{
#define FOREGROUND_BEGIN_(x)	[BeeThread enqueueForegroundWithDelay:(dispatch_time_t)x block:^{
#define FOREGROUND_COMMIT		}];

#define BACKGROUND_BEGIN		[BeeThread enqueueBackground:^{
#define BACKGROUND_BEGIN_(x)	[BeeThread enqueueBackgroundWithDelay:(dispatch_time_t)x block:^{
#define BACKGROUND_COMMIT		}];

#pragma mark -

@interface BeeThread : NSObject

@property (nonatomic, readonly) BeeThreadBlock	MAIN;
@property (nonatomic, readonly) BeeThreadBlock	FORK;

AS_SINGLETON( BeeThread )

+ (dispatch_queue_t)foreQueue;
+ (dispatch_queue_t)backQueue;

+ (void)enqueueForeground:(dispatch_block_t)block;
+ (void)enqueueBackground:(dispatch_block_t)block;
+ (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;
+ (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;

@end

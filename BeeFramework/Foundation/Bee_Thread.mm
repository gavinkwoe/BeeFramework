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
//  Bee_Thread.m
//

#import <Foundation/Foundation.h>
#import "Bee_Thread.h"
 
#pragma mark -

@implementation BeeTaskQueue

DEF_SINGLETON( BeeTaskQueue )

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

- (dispatch_queue_t)foreQueue
{
	return _foreQueue;
}

- (dispatch_queue_t)backQueue
{
	return _backQueue;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)enqueueForeground:(dispatch_block_t)block
{
	dispatch_async( _foreQueue, block );
}

- (void)enqueueBackground:(dispatch_block_t)block
{
	dispatch_async( _backQueue, block );
}

- (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
	dispatch_after( time, _foreQueue, block );	
}

- (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
	dispatch_after( time, _backQueue, block );	
}

@end

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
//	thanks to http://stackoverflow.com/users/299063/ivanzoid
//  http://stackoverflow.com/questions/8223348/ios-get-cpu-usage-from-application
//

#import "ServiceDebugger_CPUModel.h"
#import "ServiceDebugger_Unit.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#include <mach/mach.h>
#include <malloc/malloc.h>

#pragma mark -

@interface ServiceDebugger_CPUModel()
{
	float				_usage;
	NSMutableArray *	_chartDatas;
	float				_lowerBound;
	float				_upperBound;
}
@end

#pragma mark -

@implementation ServiceDebugger_CPUModel

@synthesize usage = _usage;
@synthesize chartDatas = _chartDatas;
@synthesize lowerBound = _lowerBound;
@synthesize upperBound = _upperBound;

DEF_SINGLETON( ServiceDebugger_CPUModel )

DEF_NOTIFICATION( UPDATED );

- (void)load
{
//	[super load];

	_chartDatas = [[NSMutableArray alloc] init];
//	[_chartDatas addObject:__INT(0)];

	_lowerBound = 0.0f;
	_upperBound = 1.0f;

	[self observeTick];
}

- (void)unload
{
	[self unobserveTick];
	
	[_chartDatas removeAllObjects];
	[_chartDatas release];
	
//	[super unload];
}

ON_TICK( tick )
{
	kern_return_t			kr = { 0 };
	task_info_data_t		tinfo = { 0 };
	mach_msg_type_number_t	task_info_count = TASK_INFO_MAX;
	
	kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
	if ( KERN_SUCCESS != kr )
		return;
	
	task_basic_info_t		basic_info = { 0 };
	thread_array_t			thread_list = { 0 };
	mach_msg_type_number_t	thread_count = { 0 };
	
	thread_info_data_t		thinfo = { 0 };
	thread_basic_info_t		basic_info_th = { 0 };
	
	basic_info = (task_basic_info_t)tinfo;
	
	// get threads in the task
	kr = task_threads( mach_task_self(), &thread_list, &thread_count );
	if ( KERN_SUCCESS != kr )
		return;
	
	long	tot_sec = 0;
	long	tot_usec = 0;
	float	tot_cpu = 0;
	
	for ( int i = 0; i < thread_count; i++ )
	{
		mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
		
		kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
		if ( KERN_SUCCESS != kr )
			return;
		
		basic_info_th = (thread_basic_info_t)thinfo;
		
		if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
		{
			tot_sec		= tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
			tot_usec	= tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
			tot_cpu		= tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
		}
	}
	
	kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
	if ( KERN_SUCCESS != kr )
		return;

	[_chartDatas addObject:[NSNumber numberWithFloat:tot_cpu]];
	[_chartDatas keepTail:MAX_CPU_HISTORY];

//	_lowerBound = _upperBound;
//	_upperBound = 1;

	for ( NSNumber * n in _chartDatas )
	{
		if ( n.intValue > _upperBound )
		{
			_upperBound = n.intValue;

//			if ( _upperBound < _lowerBound )
//			{
//				_lowerBound = _upperBound;
//			}
		}
		else if ( n.intValue < _lowerBound )
		{
			_lowerBound = n.intValue;
		}
	}
	
	_usage = tot_cpu;
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "Bee_Performance.h"
#import "Bee_Log.h"
#import "Bee_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	DEFAULT_PERFORMANCE_VALVE
#define DEFAULT_PERFORMANCE_VALVE	(300.0f)

#undef	MAX_RECORDS
#define MAX_RECORDS		(50)

#pragma mark -

DEF_PACKAGE( BeePackage_System, BeePerformance, performance );

#pragma mark -

@implementation BeePerformanceRecord
@synthesize name = _name;
@synthesize time = _time;
@end

#pragma mark -

@interface BeePerformance()
{
	NSMutableArray *		_records;
	NSMutableDictionary *	_tags;
	NSTimeInterval			_valve;
}
@end

#pragma mark -

@implementation BeePerformance

DEF_SINGLETON( BeePerformance );

@synthesize records = _records;
@synthesize valve = _valve;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_records = [[NSMutableArray alloc] init];
		_tags = [[NSMutableDictionary alloc] init];
		_valve = DEFAULT_PERFORMANCE_VALVE;
	}
	return self;
}

- (void)dealloc
{
	[_tags removeAllObjects];
	[_tags release];
	
	[_records removeAllObjects];
	[_records release];

	[super dealloc];
}

- (double)timestamp
{
	return CACurrentMediaTime();
}

- (double)markTag:(NSString *)tag
{
	double curr = CACurrentMediaTime();
	
	NSNumber * time = [NSNumber numberWithDouble:curr];
	[_tags setObject:time forKey:tag];
	
	PERF( @"\t%@", tag );
	
	return curr;
}

- (double)betweenTag:(NSString *)tag1 andTag:(NSString *)tag2
{
	return [self betweenTag:tag1 andTag:tag2 shouldRemove:YES];
}

- (double)betweenTag:(NSString *)tag1 andTag:(NSString *)tag2 shouldRemove:(BOOL)remove
{
	NSNumber * time1 = [_tags objectForKey:tag1];
	NSNumber * time2 = [_tags objectForKey:tag2];
	
	if ( nil == time1 || nil == time2 )
		return 0.0;
	
	double time = fabs( [time2 doubleValue] - [time1 doubleValue] );
	
	if ( remove )
	{
		[_tags removeObjectForKey:tag1];
		[_tags removeObjectForKey:tag2];
	}
	
	return time;
}

- (void)watchClass:(Class)clazz
{
	[self watchClass:clazz andSelector:nil];
}

- (void)watchClass:(Class)clazz andSelector:(SEL)selector
{
	// TODO: 0.6.0
}

- (void)recordName:(NSString *)name andTime:(NSTimeInterval)time
{
	time = time * 1000.0f;
	
	if ( time >= _valve )
	{
		BeePerformanceRecord * record = [[[BeePerformanceRecord alloc] init] autorelease];
		record.name = name;
		record.time = time;
		[_records pushTail:record];
		[_records keepTail:MAX_RECORDS];
		
		ERROR( @"Time '%@' = %.0f(ms)", name, time );
	}
	else
	{
		PERF( @"Time '%@' = %.0f(ms)", name, time );
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeePerformance )
{
	TIMES( 3 )
	{
		PERF_ENTER
		{
			HERE( "step 1",
			{	
				PERF_ENTER_( step_one )
				{
					TIMES( 10 )
					{
						rand();
					}
				}
				PERF_LEAVE_( step_one )
			});

			HERE( "step 2",
			{
				PERF_ENTER_( step_two )
				{
					TIMES( 10000 )
					{
						rand();
					}
				}
				PERF_LEAVE_( step_two )
			});

			HERE( "step 3",
			{
				PERF_MARK( step_three_1 );
				{
					TIMES( 10000 )
					{
						rand();
					}
				}
				PERF_MARK( step_three_2 );
			});

			HERE( "print time",
			{
				CC( @"step_three = %f", PERF_TIME( step_three_1, step_three_2 ) );
			});
		}
		PERF_LEAVE
	}
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

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

#import "NSArray+BeeActiveRecord.h"
#import "NSDictionary+BeeActiveRecord.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSArray(BeeActiveRecord)

- (BeeDatabaseBoolBlock)SAVE
{
	BeeDatabaseBoolBlock block = ^ BOOL ( void )
	{
		BOOL allSucceed = YES;
		
		for ( NSObject * elem in self )
		{
			if ( [elem isKindOfClass:[BeeActiveRecord class]] )
			{
				BeeActiveRecord * record = (BeeActiveRecord *)elem;
				record.changed = YES;
				BOOL succeed = record.SAVE();
				if ( NO == succeed )
				{
					allSucceed = NO;
				}
			}
		}
		
		return allSucceed;
	};
	
	return [[block copy] autorelease];
}

- (NSArray *)objectToActiveRecord:(Class)clazz
{
	NSMutableArray * array = [NSMutableArray array];
	
	for ( NSObject * obj in self )
	{
		if ( [obj isKindOfClass:[NSDictionary class]] )
		{
			BeeActiveRecord * record = [(NSDictionary *)obj objectToActiveRecord:clazz];
			if ( record )
			{
				[array addObject:record];
			}
		}
	}

	return array;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSArray_BeeActiveRecord )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

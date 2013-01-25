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
//  Bee_ActiveBase.h
//

#import "Bee_Precompile.h"
#import "Bee_Log.h"
#import "Bee_Runtime.h"
#import "Bee_Database.h"
#import "Bee_UnitTest.h"

#import "NSObject+BeeTypeConversion.h"
#import "NSDictionary+BeeExtension.h"
#import "NSNumber+BeeExtension.h"

#include <objc/runtime.h>

#pragma mark -

@implementation BeeTestCase

+ (BOOL)runTests
{
	return YES;
}

@end

#pragma mark -

@implementation BeeUnitTest

static NSUInteger __failedCount = 0;
static NSUInteger __succeedCount = 0;

+ (NSUInteger)failedCount
{
	return __failedCount;
}

+ (NSUInteger)succeedCount
{
	return __succeedCount;
}

+ (BOOL)runTests
{
#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
	
	__failedCount = 0;
	__succeedCount = 0;
	
	NSUInteger	classesCount = 0;
	Class *		classes = objc_copyClassList( &classesCount );

	NSMutableArray * availableCases = [NSMutableArray array];
	
	for ( unsigned int i = 0; i < classesCount; ++i )
	{
		Class classType = classes[i];
		if ( classType == [BeeTestCase class] )
			continue;
		
//		const char * imageName = class_getImageName( classType );
//		CC( @"image = %s", imageName );
		
		if ( NO == class_respondsToSelector( classType, @selector(doesNotRecognizeSelector:) ) )
			continue;
		if ( NO == class_respondsToSelector( classType, @selector(methodSignatureForSelector:) ) )
			continue;
		
		if ( [classType isSubclassOfClass:[BeeTestCase class]] )
		{
			NSString * className = [NSString stringWithUTF8String:class_getName(classType)];
			[availableCases addObject:className];
		}		
	}
	
	CC( @"=====================================" );
	CC( @"Total %d cases", availableCases.count );
	CC( @"=====================================" );
	
	if ( availableCases.count )
	{
		[availableCases sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
		}];
		
		for ( NSString * className in availableCases )
		{
			CC( @"Testing '%@' ...", className );

			Class clazz = NSClassFromString( className );
			if ( clazz )
			{
				BOOL ret = [clazz runTests];
				if ( ret )
				{
					__succeedCount += 1;
				}
				else
				{
					__failedCount += 1;
				}	
			}
		}
	}
	
	CC( @"=====================================" );
	CC( @"succeed(%d), failed(%d)", __succeedCount, __failedCount );
	CC( @"=====================================" );
	
	return __failedCount ? NO : YES;
	
#else	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
	
	return YES;
	
#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
}

@end

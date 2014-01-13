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

#import "Bee_Singleton.h"
#import "Bee_Runtime.h"
#import "Bee_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	__PRELOAD_SINGLETON__
#define __PRELOAD_SINGLETON__	(__OFF__)

#pragma mark -

@implementation BeeSingleton

+ (BOOL)autoLoad
{
#if defined(__PRELOAD_SINGLETON__) && __PRELOAD_SINGLETON__
	
	INFO( @"Loading singletons ..." );
	
	[[BeeLogger sharedInstance] indent];
//	[[BeeLogger sharedInstance] disable];

	NSMutableArray * availableClasses = [NSMutableArray arrayWithArray:[BeeRuntime allSubClassesOf:[NSObject class]]];
	[availableClasses sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [[obj1 description] compare:[obj2 description]];
	}];
	
	for ( Class classType in availableClasses )
	{
		if ( [classType instancesRespondToSelector:@selector(sharedInstance)] )
		{
			[classType sharedInstance];
			
//			[[BeeLogger sharedInstance] enable];
			INFO( @"%@ loaded", [classType description] );
//			[[BeeLogger sharedInstance] disable];
		}
	}

	[[BeeLogger sharedInstance] unindent];
//	[[BeeLogger sharedInstance] enable];

#endif	// #if defined(__PRELOAD_SINGLETON__) && __PRELOAD_SINGLETON__

	return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

@interface SingletonTest : NSObject
AS_SINGLETON( SingletonTest )
@end

@implementation SingletonTest
DEF_SINGLETON( SingletonTest )
@end

TEST_CASE( BeeSingleton )
{
	TIMES( 3 )
	{
		SingletonTest * a = [SingletonTest sharedInstance];
		SingletonTest * b = [SingletonTest sharedInstance];
		
		EXPECTED( nil != a );
		EXPECTED( nil != b );
		EXPECTED( a == b );
	}
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

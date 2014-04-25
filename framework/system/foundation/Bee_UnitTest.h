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
#import "Bee_Log.h"

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#undef	TEST_CASE
#define	TEST_CASE( __name ) \
		@interface TestCase__##__name : BeeTestCase \
		@end \
		@implementation TestCase__##__name \
		+ (NSString *)name { return [NSString stringWithUTF8String:#__name]; } \
		+ (const char *)file { return __FILE__; } \
		+ (unsigned int)line { return __LINE__; } \
		+ (BOOL)runTests { \
			NSAutoreleasePool * __testReleasePool = [[NSAutoreleasePool alloc] init]; \
			BOOL __testCasePassed = YES; \
			@try {

#undef	TEST_CASE_END
#define	TEST_CASE_END \
			} \
			@catch ( NSException * e ) { \
				ERROR( [NSString stringWithFormat:@"%@\n%@", e.reason, e.callStackSymbols] ); \
				__testCasePassed = NO; \
			} \
			@finally { \
			} \
			[__testReleasePool release]; \
			return __testCasePassed; \
		} \
		@end

#undef	HERE
#define HERE( __x, __run ) \
		__run

#undef	EXPECTED
#define EXPECTED( __condition ) \
		if ( NO == (__condition) ) { \
			@throw [NSException exceptionWithName:@"" \
										   reason:[NSString stringWithFormat:@"<%s> @ <%s(#%u)>", #__condition, __FILE__, __LINE__] \
										 userInfo:nil]; \
		}

#undef	TIMES
#define TIMES( __n ) \
		for ( int __i_##__LINE__ = 0; __i_##__LINE__ < __n; ++__i_##__LINE__ )

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

@interface BeeTestCase : NSObject
+ (BOOL)runTests;
@end

#pragma mark -

@interface BeeUnitTest : NSObject
+ (NSUInteger)failedCount;
+ (NSUInteger)succeedCount;
+ (BOOL)runTests;
@end

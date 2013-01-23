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
//  Bee_UnitTest.h
//

#import "Bee_Precompile.h"
#import "Bee_Database.h"
#include <objc/runtime.h>

#undef	TEST_CASE
#define	TEST_CASE( __name ) \
		@interface TestCase##__name : BeeTestCase \
		@end \
		@implementation TestCase##__name \
		+ (BOOL)runTests { \
			BOOL __testCasePassed = NO; \
			@try {

#undef	TEST_CASE_END
#define	TEST_CASE_END \
			} \
			@catch ( NSException * e ) { \
				__testCasePassed = NO; \
			} \
			@finally { \
				__testCasePassed = YES; \
			} \
			return __testCasePassed; \
		} \
		@end

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

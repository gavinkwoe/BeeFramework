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
//  Bee_RuntimeTest.h
//

#import "Bee.h"
#import "Bee_UnitTest.h"

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( runtime )
{
	TIMES( 3 )
	{
		NSString * str = (NSString *)[BeeRuntime allocByClass:[NSString class]];
		EXPECTED( str );
		[str release];

		NSString * str2 = (NSString *)[BeeRuntime allocByClassName:@"NSString"];
		EXPECTED( str2 );
		[str2 release];

		NSArray * emptyStack = [BeeRuntime callstack:0];
		EXPECTED( emptyStack );
		EXPECTED( emptyStack.count == 0 );
		
		NSArray * maxStack = [BeeRuntime callstack:100000];
		EXPECTED( maxStack );
		EXPECTED( maxStack.count );

		NSArray * stack = [BeeRuntime callstack:1];
		EXPECTED( stack && stack.count );
		EXPECTED( [[stack objectAtIndex:0] isKindOfClass:[NSString class]] );
		
		NSArray * emptyFrames = [BeeRuntime callframes:0];
		EXPECTED( emptyFrames );
		EXPECTED( emptyFrames.count == 0 );

		NSArray * maxFrames = [BeeRuntime callframes:100000];
		EXPECTED( maxFrames );
		EXPECTED( maxFrames.count );

		NSArray * frames = [BeeRuntime callframes:1];
		EXPECTED( frames && frames.count );
		EXPECTED( [[frames objectAtIndex:0] isKindOfClass:[BeeCallFrame class]] );

		[BeeRuntime printCallstack:0];
		[BeeRuntime printCallstack:1];
		[BeeRuntime printCallstack:100000];
	}
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

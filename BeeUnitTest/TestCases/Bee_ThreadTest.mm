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
//  Bee_ThreadTest.h
//

#import "Bee.h"
#import "Bee_UnitTest.h"

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( thread )
{
	static int __flag = 0;

// run in background

	BACKGROUND_BEGIN
	{
		EXPECTED( NO == [NSThread isMainThread] );
		EXPECTED( 0 == __flag );
		
		__flag = 1;

	// run in foreground
		
		FOREGROUND_BEGIN
		{
			EXPECTED( YES == [NSThread isMainThread] );
			EXPECTED( 1 == __flag );

			__flag = 0;

		// run in background
			
			BACKGROUND_BEGIN
			{
				EXPECTED( NO == [NSThread isMainThread] );
				EXPECTED( 0 == __flag );
				
				__flag = 1;
				
			// run in foreground
				
				FOREGROUND_BEGIN
				{
					EXPECTED( YES == [NSThread isMainThread] );
					EXPECTED( 1 == __flag );
					
					__flag = 2;
					
					// done
				}
				FOREGROUND_COMMIT
			}
			BACKGROUND_COMMIT
		}
		FOREGROUND_COMMIT
	}
	BACKGROUND_COMMIT
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

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
#import "Bee_SystemConfig.h"
#import "Bee_SystemPackage.h"

#pragma mark -

#if __BEE_DEVELOPMENT__

#undef	ASSERT
#define ASSERT( __expr )	BeeAssert( (__expr) ? YES : NO, #__expr, __PRETTY_FUNCTION__, __FILE__, __LINE__ )

#else	// #if __BEE_DEVELOPMENT__

#undef	ASSERT
#define ASSERT( __expr )

#endif	// #if __BEE_DEVELOPMENT__

#if __cplusplus
extern "C" {
#endif

	void BeeAssertToggle( void );
	void BeeAssertEnable( void );
	void BeeAssertDisable( void );
	void BeeAssert( BOOL flag, const char * expr, const char * function, const char * file, int line );

#if __cplusplus
};
#endif

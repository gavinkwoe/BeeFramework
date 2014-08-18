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
#import "Bee_Package.h"
#import "Bee_Foundation.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

AS_PACKAGE_( BeePackage, BeePackage_UI, ui );

#pragma mark -

#undef	AS_UI
#define	AS_UI( __class, __name ) \
		AS_PACKAGE( BeePackage_UI, __class, __name )

#undef	DEF_UI
#define	DEF_UI( __class, __name ) \
		DEF_PACKAGE( BeePackage_UI, __class, __name )

#undef	AS_SUB_UI
#define	AS_SUB_UI( __parent, __class, __name ) \
		AS_PACKAGE( __parent, __class, __name )

#undef	DEF_SUB_UI
#define	DEF_SUB_UI( __parent, __class, __name ) \
		DEF_PACKAGE( __parent, __class, __name )

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

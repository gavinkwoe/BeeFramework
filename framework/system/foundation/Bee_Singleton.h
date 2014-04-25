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

#pragma mark -

#if __has_feature(objc_instancetype)

	#undef	AS_SINGLETON
	#define AS_SINGLETON

	#undef	AS_SINGLETON
	#define AS_SINGLETON( ... ) \
			- (instancetype)sharedInstance; \
			+ (instancetype)sharedInstance;

	#undef	DEF_SINGLETON
	#define DEF_SINGLETON \
			- (instancetype)sharedInstance \
			{ \
				return [[self class] sharedInstance]; \
			} \
			+ (instancetype)sharedInstance \
			{ \
				static dispatch_once_t once; \
				static id __singleton__; \
				dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
				return __singleton__; \
			}

	#undef	DEF_SINGLETON
	#define DEF_SINGLETON( ... ) \
			- (instancetype)sharedInstance \
			{ \
				return [[self class] sharedInstance]; \
			} \
			+ (instancetype)sharedInstance \
			{ \
				static dispatch_once_t once; \
				static id __singleton__; \
				dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
				return __singleton__; \
			}

#else	// #if __has_feature(objc_instancetype)

	#undef	AS_SINGLETON
	#define AS_SINGLETON( __class ) \
			- (__class *)sharedInstance; \
			+ (__class *)sharedInstance;

	#undef	DEF_SINGLETON
	#define DEF_SINGLETON( __class ) \
			- (__class *)sharedInstance \
			{ \
				return [__class sharedInstance]; \
			} \
			+ (__class *)sharedInstance \
			{ \
				static dispatch_once_t once; \
				static __class * __singleton__; \
				dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
				return __singleton__; \
			}

#endif	// #if __has_feature(objc_instancetype)

#undef	DEF_SINGLETON_AUTOLOAD
#define DEF_SINGLETON_AUTOLOAD( __class ) \
		DEF_SINGLETON( __class ) \
		+ (void)load \
		{ \
			[self sharedInstance]; \
		}

#pragma mark -

@interface BeeSingleton : NSObject
@end

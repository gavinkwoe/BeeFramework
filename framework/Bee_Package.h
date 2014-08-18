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

#undef	AS_NAMESPACE
#define AS_NAMESPACE( __name ) \
		@class BeePackage; \
		extern BeePackage *	__name; \
		@interface __Namespace_##__name : BeePackage \
		AS_SINGLETON( __Namespace_##__name ) \
		@end

#undef	DEF_NAMESPACE
#define DEF_NAMESPACE( __name ) \
		BeePackage * __name = nil; \
		@implementation __Namespace_##__name \
		DEF_SINGLETON( __Namespace_##__name ) \
		+ (void)load \
		{ \
			__name = [__Namespace_##__name sharedInstance]; \
		} \
		@end

#undef	NAMESPACE
#define	NAMESPACE( __name ) \
		__Namespace_##__name

#pragma mark -

#undef	AS_PACKAGE
#define AS_PACKAGE( __parentClass, __class, __propertyName ) \
		@class __class; \
		@interface __parentClass (AutoLoad_##__propertyName) \
		@property (nonatomic, readonly) __class * __propertyName; \
		@end

#undef	DEF_PACKAGE
#define DEF_PACKAGE( __parentClass, __class, __propertyName ) \
		@implementation __parentClass (AutoLoad_##__propertyName) \
		@dynamic __propertyName; \
		- (__class *)__propertyName \
		{ \
			return [__class sharedInstance]; \
		} \
		@end

#undef	AS_PACKAGE_
#define AS_PACKAGE_( __parentClass, __class, __propertyName ) \
		@class __class; \
		@interface __parentClass (AutoLoad_##__propertyName) \
		@property (nonatomic, readonly) __class * __propertyName; \
		@end \
		@interface __class : NSObject \
		AS_SINGLETON( __class ); \
		@end

#undef	DEF_PACKAGE_
#define DEF_PACKAGE_( __parentClass, __class, __propertyName ) \
		@implementation __parentClass (AutoLoad_##__propertyName) \
		@dynamic __propertyName; \
		- (__class *)__propertyName \
		{ \
			return [__class sharedInstance]; \
		} \
		@end \
		@implementation __class \
		DEF_SINGLETON( __class ); \
		@end

#pragma mark -

@interface NSObject(AutoLoading)
+ (BOOL)autoLoad;
@end

#pragma mark -

/**
 * An Objective-C wrapper for android-like package, not thread-safe.
 *
 * It's the base class of all sub-packages, DO NOT use this class directly.
 *
 * Step 1) You must include the files below first:
 *
 @code
 #import "Bee_Precompile.h"
 #import "Bee_Package.h"
 @endcode
 *
 * Step 2) Declare package in .h file:
 *
 @code
 ...
 AS_PACKAGE( BeePackage, BeeCLI, cli );
                         ^^^^^^  ^^^
 ...
 @endcode
 *
 * Step 3) Define package in .m/.mm file:
 *
 @code
 ...
 DEF_PACKAGE( BeePackage, BeeCLI, cli );
                          ^^^^^^  ^^^
 ...
 @endcode
 *
 * Step 4) Once the package was defined, you can use it like this:
 *
 @code
 BeeCLI * instance = bee.cli;
 ASSERT( nil != instance );
 ASSERT( [instance isKindOfClass:[BeeCLI class]] );
 @endcode
 *
 */
@interface BeePackage : NSObject
@property (nonatomic, readonly) NSArray * loadedPackages;
@end

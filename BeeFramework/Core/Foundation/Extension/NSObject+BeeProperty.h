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
//  NSObject+BeeProperty.h
//

#import "Bee_Precompile.h"

#pragma mark -

#undef	AS_STATIC_PROPERTY
#define AS_STATIC_PROPERTY( __name ) \
		@property (nonatomic, readonly) NSString * __name; \
		+ (NSString *)__name;

#if __has_feature(objc_arc)

    #undef	DEF_STATIC_PROPERTY
    #define DEF_STATIC_PROPERTY( __name ) \
			@dynamic __name; \
			- (NSString *)__name \
			{ \
				return (NSString *)[[self class] __name]; \
			} \
			+ (NSString *)__name \
			{ \
				static NSString * __local = nil; \
				if ( nil == __local ) \
				{ \
					__local = [NSString stringWithFormat:@"%s", #__name]; \
				} \
				return __local; \
			}

#else

    #undef	DEF_STATIC_PROPERTY
    #define DEF_STATIC_PROPERTY( __name ) \
			@dynamic __name; \
			- (NSString *)__name \
			{ \
				return (NSString *)[[self class] __name]; \
			} \
			+ (NSString *)__name \
			{ \
				static NSString * __local = nil; \
				if ( nil == __local ) \
				{ \
					__local = [[NSString stringWithFormat:@"%s", #__name] retain]; \
				} \
				return __local; \
			}

#endif

#if __has_feature(objc_arc)

	#undef	DEF_STATIC_PROPERTY2
    #define DEF_STATIC_PROPERTY2( __name, __prefix ) \
			@dynamic __name; \
			- (NSString *)__name \
			{ \
				return (NSString *)[[self class] __name]; \
			} \
			+ (NSString *)__name \
			{ \
				static NSString * __local = nil; \
				if ( nil == __local ) \
				{ \
					__local = [NSString stringWithFormat:@"%@.%s", __prefix, #__name]; \
				} \
				return __local; \
			}

#else

	#undef	DEF_STATIC_PROPERTY2
    #define DEF_STATIC_PROPERTY2( __name, __prefix ) \
			@dynamic __name; \
			- (NSString *)__name \
			{ \
				return (NSString *)[[self class] __name]; \
			} \
			+ (NSString *)__name \
			{ \
				static NSString * __local = nil; \
				if ( nil == __local ) \
				{ \
					__local = [[NSString stringWithFormat:@"%@.%s", __prefix, #__name] retain]; \
				} \
				return __local; \
			}

#endif

#if __has_feature(objc_arc)

	#undef	DEF_STATIC_PROPERTY3
    #define DEF_STATIC_PROPERTY3( __name, __prefix, __prefix2 ) \
			@dynamic __name; \
			- (NSString *)__name \
			{ \
				return (NSString *)[[self class] __name]; \
			} \
			+ (NSString *)__name \
			{ \
				static NSString * __local = nil; \
				if ( nil == __local ) \
				{ \
					__local = [NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__name]; \
				} \
				return __local; \
			}

#else

	#undef	DEF_STATIC_PROPERTY3
    #define DEF_STATIC_PROPERTY3( __name, __prefix, __prefix2 ) \
			@dynamic __name; \
			- (NSString *)__name \
			{ \
				return (NSString *)[[self class] __name]; \
			} \
			+ (NSString *)__name \
			{ \
				static NSString * __local = nil; \
				if ( nil == __local ) \
				{ \
					__local = [[NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__name] retain]; \
				} \
				return __local; \
			}

#endif

#pragma mark -

#undef	AS_STATIC_PROPERTY_INT
#define AS_STATIC_PROPERTY_INT( __name ) \
		@property (nonatomic, readonly) NSInteger __name; \
		+ (NSInteger)__name;

#undef	DEF_STATIC_PROPERTY_INT
#define DEF_STATIC_PROPERTY_INT( __name, __value ) \
		@dynamic __name; \
		- (NSInteger)__name \
		{ \
			return (NSInteger)[[self class] __name]; \
		} \
		+ (NSInteger)__name \
		{ \
			return __value; \
		}

#undef	AS_INT
#define AS_INT	AS_STATIC_PROPERTY_INT

#undef	DEF_INT
#define DEF_INT	DEF_STATIC_PROPERTY_INT

#pragma mark -

#undef	AS_STATIC_PROPERTY_STRING
#define AS_STATIC_PROPERTY_STRING( __name ) \
		@property (nonatomic, readonly) NSString * __name; \
		+ (NSString *)__name;

#undef	DEF_STATIC_PROPERTY_STRING
#define DEF_STATIC_PROPERTY_STRING( __name, __value ) \
		@dynamic __name; \
		- (NSString *)__name \
		{ \
			return [[self class] __name]; \
		} \
		+ (NSString *)__name \
		{ \
			return __value; \
		}

#undef	AS_STRING
#define AS_STRING	AS_STATIC_PROPERTY_STRING

#undef	DEF_STRING
#define DEF_STRING	DEF_STATIC_PROPERTY_STRING

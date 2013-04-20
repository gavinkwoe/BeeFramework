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
//  UIFont+BeeExtension.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "UIFont+BeeExtension.h"

#import <objc/runtime.h>

#pragma mark -

@implementation UIFont(BeeExtension)

static NSString * __fontName = nil;
static NSString * __boldFontName = nil;
static NSString * __italicFontName = nil;

+ (void)swizzle
{
	static BOOL __swizzled = NO;
	if ( NO == __swizzled )
	{
		Method method;
		IMP implement;
		
		method = class_getClassMethod( [UIFont class], @selector(systemFontOfSize:) );
		implement = class_getMethodImplementation( [UIFont class], @selector(mySystemFontOfSize:) );
		method_setImplementation( method, implement );

		method = class_getClassMethod( [UIFont class], @selector(boldSystemFontOfSize:) );
		implement = class_getMethodImplementation( [UIFont class], @selector(myBoldSystemFontOfSize:) );
		method_setImplementation( method, implement );

		method = class_getClassMethod( [UIFont class], @selector(italicSystemFontOfSize:) );
		implement = class_getMethodImplementation( [UIFont class], @selector(myItalicSystemFontOfSize:) );
		method_setImplementation( method, implement );

		__swizzled = YES;
	}
}

+ (UIFont *)mySystemFontOfSize:(CGFloat)fontSize
{
	if ( __fontName && [__fontName length] )
	{
		return [UIFont fontWithName:__fontName size:fontSize];
	}
	else
	{
		return [UIFont systemFontOfSize:fontSize];
	}	
}

+ (UIFont *)myBoldSystemFontOfSize:(CGFloat)fontSize
{
	if ( __boldFontName && [__boldFontName length] )
	{
		return [UIFont fontWithName:__boldFontName size:fontSize];
	}
	else
	{
		return [UIFont systemFontOfSize:fontSize];
	}		
}

+ (UIFont *)myItalicSystemFontOfSize:(CGFloat)fontSize
{
	if ( __italicFontName && [__italicFontName length] )
	{
		return [UIFont fontWithName:__italicFontName size:fontSize];
	}
	else
	{
		return [UIFont systemFontOfSize:fontSize];
	}	
}

+ (void)setFontName:(NSString *)name
{
	[name retain];
	[__fontName release];
	__fontName = name;
	
	[self swizzle];
}

+ (void)setBoldFontName:(NSString *)name
{
	[name retain];
	[__boldFontName release];
	__boldFontName = name;
	
	[self swizzle];
}

+ (void)setItalicFontName:(NSString *)name
{
	[name retain];
	[__italicFontName release];
	__italicFontName = name;
	
	[self swizzle];	
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

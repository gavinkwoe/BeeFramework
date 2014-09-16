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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "UIFont+BeeExtension.h"

#pragma mark -

@interface UIFont(ThemePrivate)
@end

@implementation UIFont(Theme)

static NSString * __fontName = nil;
static NSString * __boldFontName = nil;
static NSString * __italicFontName = nil;

static NSMutableDictionary * __customFonts = nil;

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

- (UIFont *)mySystemFontOfSize:(CGFloat)fontSize
{
	if ( __fontName && [__fontName length] )
	{
		if ( nil == __customFonts )
		{
			__customFonts = [[NSMutableDictionary alloc] init];
		}
		
		UIFont * customFont = [__customFonts objectForKey:__fontName];
		if ( nil == customFont )
		{
			customFont = [UIFont fontWithName:__fontName size:fontSize];
			if ( customFont )
			{
				[__customFonts setObject:customFont forKey:__fontName];
			}
		}
		
		return customFont;
	}
	else
	{
		return [UIFont systemFontOfSize:fontSize];
	}	
}

- (UIFont *)myBoldSystemFontOfSize:(CGFloat)fontSize
{
	if ( __boldFontName && [__boldFontName length] )
	{
		if ( nil == __customFonts )
		{
			__customFonts = [[NSMutableDictionary alloc] init];
		}
		
		UIFont * customFont = [__customFonts objectForKey:__boldFontName];
		if ( nil == customFont )
		{
			customFont = [UIFont fontWithName:__boldFontName size:fontSize];
			if ( customFont )
			{
				[__customFonts setObject:customFont forKey:__boldFontName];
			}
		}
		
		return customFont;
	}
	else
	{
		return [UIFont systemFontOfSize:fontSize];
	}		
}

- (UIFont *)myItalicSystemFontOfSize:(CGFloat)fontSize
{
	if ( __italicFontName && [__italicFontName length] )
	{
		if ( nil == __customFonts )
		{
			__customFonts = [[NSMutableDictionary alloc] init];
		}
		
		UIFont * customFont = [__customFonts objectForKey:__italicFontName];
		if ( nil == customFont )
		{
			customFont = [UIFont fontWithName:__italicFontName size:fontSize];
			if ( customFont )
			{
				[__customFonts setObject:customFont forKey:__italicFontName];
			}
		}
		
		return customFont;
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

+ (UIFont *)fontFromString:(NSString *)font
{
	UIFont * userFont = nil;
	
	NSArray * array = [font componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ( 1 == array.count )
	{
		userFont = [UIFont systemFontOfSize:font.floatValue];
	}
	else
	{
		NSString * size = nil;
		NSString * family = nil;
		NSString * attribute = nil;
		
		if ( array.count >= 3 )
		{
			attribute = ((NSString *)[array objectAtIndex:2]).trim;
		}
		if ( array.count >= 2 )
		{
			NSString * temp = ((NSString *)[array objectAtIndex:1]).trim;
			
			NSComparisonResult result1 = [temp compare:@"bold" options:NSCaseInsensitiveSearch];
			NSComparisonResult result2 = [temp compare:@"italic" options:NSCaseInsensitiveSearch];
			
			if ( NSOrderedSame == result1 || NSOrderedSame == result2 )
			{
				attribute = temp;
			}
			else
			{
				family = temp;
			}
		}
		if ( array.count >= 1 )
		{
			size = ((NSString *)[array objectAtIndex:0]).trim;
		}
		
		BOOL isSystem = YES;
		BOOL isItalic = NO;
		BOOL isBold = NO;
		
		if ( NSOrderedSame != [family compare:@"system" options:NSCaseInsensitiveSearch] )
		{
			isSystem = NO;
		}
		
		if ( NSOrderedSame == [attribute compare:@"bold" options:NSCaseInsensitiveSearch] )
		{
			isBold = YES;
		}
		else if ( NSOrderedSame == [attribute compare:@"italic" options:NSCaseInsensitiveSearch] )
		{
			isItalic = YES;
		}
		
		if ( isSystem )
		{
			if ( isBold )
			{
				userFont = [UIFont boldSystemFontOfSize:size.floatValue];
			}
			else if ( isItalic )
			{
				userFont = [UIFont italicSystemFontOfSize:size.floatValue];
			}
			else
			{
				userFont = [UIFont systemFontOfSize:size.floatValue];
			}
		}
		else
		{
			userFont = [UIFont fontWithName:family size:size.floatValue];
		}
	}
	
	if ( nil == userFont )
	{
		userFont = [UIFont systemFontOfSize:12.0f];
	}
	
	return userFont;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

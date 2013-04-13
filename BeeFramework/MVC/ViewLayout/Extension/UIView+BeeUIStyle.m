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
//  UIView+BeeUIStyle.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UIStyle.h"
#import "UIView+BeeUIStyle.h"
#import "UIView+BeeExtension.h"
#import "NSString+BeeExtension.h"
#import "NSDictionary+BeeExtension.h"
#include <objc/runtime.h>
#include <execinfo.h>

#pragma mark -

@implementation UIView(BeeUIStyle)

@dynamic style;

- (BeeUIStyle *)style
{
	BeeUIStyle * s = [[[BeeUIStyle alloc] init] autorelease];
	s.object = self;
	return s;
}

- (void)applyStyleProperties:(NSDictionary *)properties
{
// setBackgoundColor
	
    NSString * backgroundColor = [properties stringOfAny:@[@"color", @"backgroundColor", @"background-color", @"bgcolor", @"bg-color", @"backcolor", @"back-color"]];
    if ( backgroundColor && backgroundColor.length )
    {
        UIColor * color = [UIColor colorWithString:backgroundColor];
        if ( color )
        {
			[self setBackgroundColor:color];
        }
    }

// setAlpha
	
    NSString * alpha = [properties stringOfAny:@[@"alpha", @"opaque", @"transparency"]];
    if ( alpha && alpha.length )
    {
        [self setAlpha:[alpha floatValue]];
    }
    
// setHidden
	
    NSString * hidden = [properties stringOfAny:@[@"hidden", @"hide"]];
    if ( hidden )
    {
		[self setHidden:hidden.boolValue];
    }
	
	NSString * visible = [properties stringOfAny:@[@"visible", @"show"]];
    if ( visible )
    {
		[self setHidden:visible.boolValue ? NO : YES];
	}

// setText
	
	if ( [self respondsToSelector:@selector(setText:)] )
	{
		NSString * text = [properties stringOfAny:@[@"text", @"content", @"value", @"val"]];
		if ( text )
		{
			[self performSelector:@selector(setText:) withObject:text];
		}	
	}

// setTextColor
	
	if ( [self respondsToSelector:@selector(setTextColor:)] )
	{
		NSString * textColor = [properties stringOfAny:@[@"textColor", @"text-color", @"foregroundColor", @"foreground-Color", @"fgColor", @"fg-Color"]];
		if ( textColor )
		{
			[self performSelector:@selector(setTextColor:) withObject:[UIColor colorWithString:textColor]];
		}
	}

// setFont
	
	if ( [self respondsToSelector:@selector(setFont:)] )
	{
		// 18,system,bold
		// 18,arial
		// 18
		// 18,bold
		// 18,italic

		NSString * font = [properties stringOfAny:@[@"font"]];
		if ( font )
		{
			NSArray * array = [font componentsSeparatedByString:@","];
			if ( 1 == array.count )
			{
				[self performSelector:@selector(setFont:) withObject:[UIFont systemFontOfSize:font.floatValue]];
			}
			else
			{
				UIFont * userFont = nil;
				
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

				if ( nil == userFont )
				{
					userFont = [UIFont systemFontOfSize:14.0f];
				}

				[self performSelector:@selector(setFont:) withObject:userFont];
			}
		}
	}

// setTextAlignment
	
	if ( [self respondsToSelector:@selector(setText:)] )
	{
		NSString * textAlignment = [properties stringOfAny:@[@"align", @"alignment", @"textAlign", @"text-align", @"textAlignment", @"text-alignment"]].trim;
		if ( textAlignment )
		{
			if ( NSOrderedSame == [textAlignment compare:@"left" options:NSCaseInsensitiveSearch] )
			{
				[self setTextAlignment:UITextAlignmentLeft];
			}
			else if ( NSOrderedSame == [textAlignment compare:@"right" options:NSCaseInsensitiveSearch] )
			{
				[self setTextAlignment:UITextAlignmentRight];
			}
			else if ( NSOrderedSame == [textAlignment compare:@"center" options:NSCaseInsensitiveSearch] )
			{
				[self setTextAlignment:UITextAlignmentCenter];
			}			
		}
	}
	
// setLineBreakMode
	
	if ( [self respondsToSelector:@selector(setLineBreakMode:)] )
	{
		NSString * lineBreakMode = [properties stringOfAny:@[@"lineBreak", @"wrap", @"trunk", @"break", @"lineBreakMode"]].trim;
		if ( lineBreakMode )
		{
			if ( NSOrderedSame == [lineBreakMode compare:@"word" options:NSCaseInsensitiveSearch] ||
				NSOrderedSame == [lineBreakMode compare:@"WordWrap" options:NSCaseInsensitiveSearch] ||
				NSOrderedSame == [lineBreakMode compare:@"word-wrap" options:NSCaseInsensitiveSearch] )
			{
				[self setLineBreakMode:UILineBreakModeWordWrap];
			}
			else if ( NSOrderedSame == [lineBreakMode compare:@"char" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"CharacterWrap" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"character-wrap" options:NSCaseInsensitiveSearch] )
			{
				[self setLineBreakMode:UILineBreakModeCharacterWrap];
			}
			else if ( NSOrderedSame == [lineBreakMode compare:@"Clip" options:NSCaseInsensitiveSearch] )
			{
				[self setLineBreakMode:UILineBreakModeClip];
			}
			else if ( NSOrderedSame == [lineBreakMode compare:@"a..." options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"HeadTruncation" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"head-truncation" options:NSCaseInsensitiveSearch] )
			{
				[self setLineBreakMode:UILineBreakModeHeadTruncation];
			}
			else if ( NSOrderedSame == [lineBreakMode compare:@"...a" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"TailTruncation" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"tail-truncation" options:NSCaseInsensitiveSearch] )
			{
				[self setLineBreakMode:UILineBreakModeTailTruncation];
			}
			else if ( NSOrderedSame == [lineBreakMode compare:@"a..b" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"MiddleTruncation" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"middle-truncation" options:NSCaseInsensitiveSearch] )
			{
				[self setLineBreakMode:UILineBreakModeMiddleTruncation];
			}
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

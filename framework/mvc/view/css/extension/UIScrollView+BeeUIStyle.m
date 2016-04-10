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

#import "UIScrollView+BeeUIStyle.h"

#import "Bee_UIStyleParser.h"
#import "Bee_UIConfig.h"

#pragma mark -

@implementation UIScrollView (BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

- (void)applyScrollDirection:(NSMutableDictionary *)properties
{
// scroll-direction: horizonal | vertical

    NSString * orientation = [properties parseStringWithKeys:@[@"orientation", @"direction", @"scroll-direction"] defaultValue:nil];
    if ( orientation )
    {
		if ( [orientation matchAnyOf:@[@"h", @"horizonal"]] )
		{
			if ( [self respondsToSelector:@selector(setHorizontal:)] )
			{
				BOOL i = YES;
                [(BeeUIScrollView *)self setHorizontal:i];
			}
		}
		else
		{
			if ( [self respondsToSelector:@selector(setVertical:)] )
			{
				BOOL i = YES;
                [(BeeUIScrollView *)self setVertical:i];
			}
		}
	}
	else
	{
		if ( [self respondsToSelector:@selector(setVertical:)] )
		{
			BOOL i = YES;
            [(BeeUIScrollView *)self setVertical:i];
		}
	}
}

- (void)applyScrollInsets:(NSMutableDictionary *)properties
{
// scroll-insets: top right bottom left

	if ( [self respondsToSelector:@selector(setExtInsets:)] )
	{
		NSString * scrollInsets = [properties parseStringWithKeys:@[@"insets", @"scroll-insets"] defaultValue:nil];
		if ( scrollInsets )
		{
			if ( [scrollInsets matchAnyOf:@[@"auto"]] )
			{
				UIEdgeInsets insets = [BeeUIConfig sharedInstance].baseInsets;
                [(BeeUIScrollView *)self setExtInsets:insets];
			}
			else
			{
				UIEdgeInsets insets = UIEdgeInsetsFromStringEx( scrollInsets );
                [(BeeUIScrollView *)self setExtInsets:insets];
			}
		}
	}
}

- (void)applyScrollLines:(NSMutableDictionary *)properties
{
	// scroll-lines: 1
	
	if ( [self respondsToSelector:@selector(setLineCount:)] )
	{
		NSString * scrollLines = [properties parseStringWithKeys:@[@"lines", @"scroll-lines"]];
		if ( scrollLines )
		{
			NSInteger lineCount = [scrollLines integerValue];
			if ( 0 == lineCount )
			{
				lineCount = 1;
			}
            [(BeeUIScrollView *)self setLineCount:lineCount];
		}
	}
}

- (void)applyScrollOverflow:(NSMutableDictionary *)properties
{
    NSString * overflow = [properties parseStringWithKeys:@[@"overflow"]];
    if ( overflow && overflow.length )
    {
		if ( [overflow matchAnyOf:@[@"visible"]] )
		{
			self.layer.masksToBounds = NO;
			self.showsHorizontalScrollIndicator = YES;
			self.showsVerticalScrollIndicator = YES;
		}
		else if ( [overflow matchAnyOf:@[@"hidden"]] )
		{
			self.layer.masksToBounds = YES;
			self.showsHorizontalScrollIndicator = NO;
			self.showsVerticalScrollIndicator = NO;
		}
		else if ( [overflow matchAnyOf:@[@"scroll"]] )
		{
			self.layer.masksToBounds = YES;
			self.showsHorizontalScrollIndicator = YES;
			self.showsVerticalScrollIndicator = YES;
		}
		else if ( [overflow matchAnyOf:@[@"auto"]] )
		{
			self.layer.masksToBounds = YES;
			self.showsHorizontalScrollIndicator = YES;
			self.showsVerticalScrollIndicator = YES;
		}
		else
		{
			self.layer.masksToBounds = YES;
//			self.showsHorizontalScrollIndicator = NO;
//			self.showsVerticalScrollIndicator = NO;
		}
    }
	else
	{
		self.layer.masksToBounds = YES;
//		self.showsHorizontalScrollIndicator = NO;
//		self.showsVerticalScrollIndicator = NO;
	}
}

- (void)applyScrollMode:(NSMutableDictionary *)properties
{
// scroll-mode: paging | continue

	NSString * scrollMode = [properties parseStringWithKeys:@[@"mode", @"scroll-mode"] defaultValue:nil];
    if ( scrollMode )
    {
		if ( [scrollMode isEqualToString:@"paging"] )
		{
			self.pagingEnabled = YES;
		}
		else
		{
			self.pagingEnabled = NO;
		}
	}
	else
	{
		self.pagingEnabled = NO;
	}
}

- (void)applyUIStyling:(NSDictionary *)properties
{
	NSMutableDictionary * propertiesCopy = [NSMutableDictionary dictionaryWithDictionary:properties];

	[self applyScrollDirection:propertiesCopy];
	[self applyScrollOverflow:propertiesCopy];
	[self applyScrollInsets:propertiesCopy];
	[self applyScrollLines:propertiesCopy];
	[self applyScrollMode:propertiesCopy];

	[super applyUIStyling:propertiesCopy];
}

@end

#endif	 // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

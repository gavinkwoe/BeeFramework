//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#pragma mark -

@implementation UIScrollView (BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

- (void)resetUIStyleProperties
{
	[super resetUIStyleProperties];
}

- (void)applyUIStyleProperties:(NSDictionary *)properties
{
    [super applyUIStyleProperties:properties];

// scroll-direction: 0 1 2 3
	
    NSString * orientation = [properties stringOfAny:@[@"orientation", @"direction", @"scroll-direction"]];
    if ( orientation )
    {
		if ( [orientation matchAnyOf:@[@"h", @"horizonal"]] )
		{
			if ( [self respondsToSelector:@selector(setHorizontal:)] )
			{
				[self performSelector:@selector(setHorizontal:) withObject:[NSNumber numberWithBool:YES]];
			}
		}
		else if ( [orientation matchAnyOf:@[@"v", @"vertical"]] )
		{
			if ( [self respondsToSelector:@selector(setVertical:)] )
			{
				[self performSelector:@selector(setVertical:) withObject:[NSNumber numberWithBool:YES]];
			}
		}
	}

// scroll-insets: 0 1 2 3
	
	NSString * scrollInsets = [properties stringOfAny:@[@"insets", @"scroll-insets"]];
    if ( scrollInsets )
    {
		scrollInsets = scrollInsets.trim;
		if ( scrollInsets.length )
		{
			UIEdgeInsets insets = UIEdgeInsetsFromStringEx( scrollInsets );
			if ( NO == UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero) )
			{
				if ( [self respondsToSelector:@selector(setBaseInsets:)] )
				{
					[self performSelector:@selector(setBaseInsets:) withObject:scrollInsets];
				}
			}
		}
    }

// scroll-mode: paging | continue
	
	NSString * scrollMode = [properties stringOfAny:@[@"mode", @"scroll-mode"]];
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
}

@end

#endif	 // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

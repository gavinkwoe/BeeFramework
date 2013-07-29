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

#import "UIControl+BeeUIStyle.h"

#pragma mark -

@implementation UIControl(BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

- (void)resetUIStyleProperties
{
	[super resetUIStyleProperties];
}

#pragma mark -

- (void)setContentProperties:(NSDictionary *)properties
{
// align-mode

	NSString * hAlignment = [properties stringOfAny:@[@"content-align"]];
    if ( hAlignment )
    {
		if ( [hAlignment matchAnyOf:@[@"l", @"left"]] )
        {
            [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        }
        else if ( [hAlignment matchAnyOf:@[@"r", @"right"]] )
        {
            [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        }
        else if ( [hAlignment matchAnyOf:@[@"c", @"center"]] )
        {
            [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        }
	}
	
	NSString * vAlignment = [properties stringOfAny:@[@"content-valign", @"content-v-align", @"content-vertical-align"]];
    if ( vAlignment )
    {
		if ( [vAlignment matchAnyOf:@[@"t", @"top"]] )
        {
            [self setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        }
        else if ( [vAlignment matchAnyOf:@[@"b", @"bottom"]] )
        {
            [self setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        }
        else if ( [vAlignment matchAnyOf:@[@"c", @"center"]] )
        {
            [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        }
    }
}

- (void)applyUIStyleProperties:(NSDictionary *)properties
{
	[super applyUIStyleProperties:properties];

	[self setContentProperties:properties];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

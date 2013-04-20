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
//  UIButton+BeeUIStyle.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "UIView+BeeUIStyle.h"
#import "UIButton+BeeUIStyle.h"
#import "NSDictionary+BeeExtension.h"

@implementation UIButton (BeeUIStyle)

- (void)applyStyleProperties:(NSDictionary *)properties
{
    [super applyStyleProperties:properties];

// setImage
	
    NSString * image = [properties stringOfAny:@[@"image", @"image-normal", @"imageNormal"]];
    if ( image )
    {
        [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
	
    NSString * imageHighlighted = [properties stringOfAny:@[@"image-highlighted", @"imageHighlighted"]];
    if ( imageHighlighted )
    {
        [self setImage:[UIImage imageNamed:imageHighlighted] forState:UIControlStateHighlighted];
    }
	
    NSString * imageDisabled = [properties stringOfAny:@[@"image-disabled", @"imageDisabled"]];
    if ( imageDisabled )
    {
        [self setImage:[UIImage imageNamed:imageDisabled] forState:UIControlStateDisabled];
    }
	
    NSString * imageSelected = [properties stringOfAny:@[@"image-selected", @"imageSelected"]];
    if ( imageSelected )
    {
        [self setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    }

// setTitle
	
    NSString * title = [properties stringOfAny:@[@"text", @"title", @"title-normal", @"titleNormal"]];
    if ( title )
    {
        [self setTitle:title forState:UIControlStateNormal];
    }

    NSString * titleHighlighted = [properties stringOfAny:@[@"text-highlighted", @"title-highlighted", @"titleHighlighted"]];
    if ( titleHighlighted )
    {
        [self setTitle:titleHighlighted forState:UIControlStateHighlighted];
    }

    NSString * titleDisabled = [properties stringOfAny:@[@"text-disabled", @"title-disabled", @"titleDisabled"]];
    if ( titleDisabled )
    {
        [self setTitle:titleDisabled forState:UIControlStateDisabled];
    }

    NSString * titleSelected = [properties stringOfAny:@[@"text-selected", @"title-selected", @"titleSelected"]];
    if ( titleSelected )
    {
        [self setTitle:titleSelected forState:UIControlStateSelected];
    }
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

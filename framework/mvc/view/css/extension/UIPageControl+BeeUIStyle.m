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

#import "UIPageControl+BeeUIStyle.h"

#import "Bee_UIStyleParser.h"
#import "Bee_UIConfig.h"

#pragma mark -

@implementation UIPageControl(BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

- (void)applyColors:(NSMutableDictionary *)properties
{
	if ( IOS6_OR_LATER )
	{
		UIColor * colorNormal = [properties parseColorWithKeys:@[@"color", @"dot-color"] defaultValue:self.pageIndicatorTintColor];
		UIColor * colorHighlighted = [properties parseColorWithKeys:@[@"color-highlighted", @"dot-color-highlighted"] defaultValue:self.currentPageIndicatorTintColor];

		if ( colorNormal )
		{
			self.pageIndicatorTintColor = colorNormal;
		}
		
		if ( colorHighlighted )
		{
			self.currentPageIndicatorTintColor = colorHighlighted;
		}
	}
}

- (void)applyImages:(NSMutableDictionary *)properties
{
	UIImage * dotImageNormal = nil;
	UIImage * dotImageHilite = nil;
	UIImage * dotImageLast = nil;

	if ( [self respondsToSelector:@selector(dotImageNormal)] )
	{
		dotImageNormal = [self performSelector:@selector(dotImageNormal)];
	}
	
	if ( [self respondsToSelector:@selector(dotImageHilite)] )
	{
		dotImageHilite = [self performSelector:@selector(dotImageHilite)];
	}

	if ( [self respondsToSelector:@selector(dotImageLast)] )
	{
		dotImageLast = [self performSelector:@selector(dotImageLast)];
	}
	
	if ( [self respondsToSelector:@selector(setDotImageNormal:)] )
	{
		dotImageNormal = [properties parseImageWithKeys:@[@"image", @"dot-image"] defaultValue:dotImageNormal];
		if ( dotImageNormal )
		{
			[self performSelector:@selector(setDotImageNormal:) withObject:dotImageNormal];
		}
	}
	
	if ( [self respondsToSelector:@selector(setDotImageHilite:)] )
	{
		dotImageHilite = [properties parseImageWithKeys:@[@"image-highlighted", @"dot-image-highlighted"] defaultValue:dotImageHilite];
		if ( dotImageHilite )
		{
			[self performSelector:@selector(setDotImageHilite:) withObject:dotImageHilite];
		}
	}
	
	if ( [self respondsToSelector:@selector(setDotImageLast:)] )
	{
		dotImageLast = [properties parseImageWithKeys:@[@"image-last", @"dot-image-last"] defaultValue:dotImageLast];
		if ( dotImageLast )
		{
			[self performSelector:@selector(setDotImageLast:) withObject:dotImageLast];
		}
	}
	
	if ( [self respondsToSelector:@selector(updateDotImages)] )
	{
		[self performSelector:@selector(updateDotImages)];
	}
}

- (void)applySizes:(NSMutableDictionary *)properties
{
	if ( [self respondsToSelector:@selector(setDotSize:)] )
	{
		CGSize dotSize = [properties parseSizeWithKeys:@[@"size", @"dot-size"]];

		if ( NO == CGSizeEqualToSize( dotSize, CGSizeZero ) )
		{
            [(BeeUIPageControl *)self setDotSize:dotSize];
		}
	}
}

- (void)applyUIStyling:(NSDictionary *)properties
{
	NSMutableDictionary * propertiesCopy = [NSMutableDictionary dictionaryWithDictionary:properties];

	[self applyColors:propertiesCopy];
	[self applyImages:propertiesCopy];
	[self applySizes:propertiesCopy];
	
	[super applyUIStyling:propertiesCopy];
}

@end

#endif	 // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

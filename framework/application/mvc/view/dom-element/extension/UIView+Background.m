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

#import "UIView+Background.h"
#import "Bee_UIImageView.h"

#pragma mark -

@interface __BeeBackgroundImageView : BeeUIImageView
@end

#pragma mark -

@implementation __BeeBackgroundImageView
@end

#pragma mark -

@implementation UIView(Background)

@dynamic backgroundImageView;
@dynamic backgroundImage;

- (BeeUIImageView *)backgroundImageView
{
	BeeUIImageView * imageView = nil;
	
	for ( UIView * subView in self.subviews )
	{
		if ( [subView isKindOfClass:[__BeeBackgroundImageView class]] )
		{
			imageView = (BeeUIImageView *)subView;
			break;
		}
	}

	if ( nil == imageView )
	{
		imageView = [[[__BeeBackgroundImageView alloc] initWithFrame:self.bounds] autorelease];
		imageView.autoresizesSubviews = YES;
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		imageView.contentMode = UIViewContentModeScaleToFill;

		[self addSubview:imageView];
		[self sendSubviewToBack:imageView];
	}
	
	return imageView;
}

- (UIImage *)backgroundImage
{
	return self.backgroundImageView.image;
}

- (void)setBackgroundImage:(UIImage *)image
{
	UIImageView * imageView = self.backgroundImageView;
	if ( imageView )
	{
		if ( image )
		{
			imageView.image = image;
			imageView.frame = self.bounds;
			[imageView setNeedsDisplay];
		}
		else
		{
			imageView.image = nil;
			[imageView removeFromSuperview];
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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
//  UIView+BeeBackground.m
//

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_UIImageView.h"
#import "Bee_UILabel.h"
#import "UIView+BeeBackground.h"

#pragma mark -

@interface BeeBackgroundImageView : BeeUIImageView
@end

#pragma mark -

@implementation BeeBackgroundImageView
@end

#pragma mark -

@implementation UIView(BeeBackground)

@dynamic backgroundImageView;

- (BeeUIImageView *)backgroundImageView
{
	return [self __backgroundImageView];
}

- (BeeBackgroundImageView *)__backgroundImageView
{
	BeeBackgroundImageView * result = nil;
	
	for ( UIView * subView in self.subviews )
	{
		if ( [subView isKindOfClass:[BeeBackgroundImageView class]] )
		{
			result = (BeeBackgroundImageView *)subView;
			break;
		}
	}

	return result;
}

- (void)setBackgroundImage:(UIImage *)image
{
	if ( image )
	{
		BeeBackgroundImageView * imageView = [self __backgroundImageView];
		if ( nil == imageView )
		{
			imageView = [[[BeeBackgroundImageView alloc] initWithFrame:self.bounds] autorelease];
			[self addSubview:imageView];
			[self sendSubviewToBack:imageView];
		}

		imageView.image = image;
		imageView.frame = self.bounds;
		[imageView setNeedsDisplay];
	}
	else
	{
		BeeBackgroundImageView * imageView = [self __backgroundImageView];
		if ( imageView )
		{
			[imageView removeFromSuperview];
		}
	}
}

- (void)fitBackgroundFrame
{
	BeeBackgroundImageView * imageView = [self __backgroundImageView];
	if ( imageView )
	{
		imageView.frame = self.bounds;
	}
}

@end

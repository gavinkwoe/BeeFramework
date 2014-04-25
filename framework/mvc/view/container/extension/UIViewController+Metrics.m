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

#import "UIViewController+Metrics.h"

#pragma mark -

@implementation UIViewController(Metrics)

@dynamic frame;
@dynamic bounds;
@dynamic size;
@dynamic width;
@dynamic height;

@dynamic viewFrame;
@dynamic viewBound;
@dynamic viewSize;
@dynamic viewWidth;
@dynamic viewHeight;

#pragma mark -

- (CGRect)frame
{
	return self.viewFrame;
}

- (CGRect)bounds
{
	return self.viewBound;
}

- (CGSize)size
{
	return self.viewSize;
}

- (CGFloat)width
{
	return self.viewWidth;
}

- (CGFloat)height
{
	return self.viewHeight;
}

#pragma mark -

- (CGRect)viewFrame
{
	CGRect bounds = [UIScreen mainScreen].bounds;
	
	if ( UIInterfaceOrientationIsLandscape(self.interfaceOrientation) )
	{
		bounds.origin = CGPointMake( bounds.origin.y, bounds.origin.x );
		bounds.size = CGSizeMake( bounds.size.height, bounds.size.width );
		
		if ( IOS6_OR_EARLIER )
		{
			if ( NO == [UIApplication sharedApplication].statusBarHidden )
			{
				bounds.origin.x += 20;
				bounds.size.width -= 20;
			}

			if ( NO == self.navigationController.navigationBarHidden )
			{
				bounds.size.width -= self.navigationController.navigationBar.bounds.size.width;
			}
		}
	}
	else
	{
		if ( IOS6_OR_EARLIER )
		{
			if ( NO == [UIApplication sharedApplication].statusBarHidden )
			{
				bounds.origin.y += 20;
				bounds.size.height -= 20;
			}

			if ( NO == self.navigationController.navigationBarHidden )
			{
				bounds.size.height -= self.navigationController.navigationBar.bounds.size.height;
			}
		}
	}
	
	return bounds;
}

- (CGRect)viewBound
{
	CGRect bound = self.viewFrame;
	bound.origin = CGPointZero;
	return bound;
}

- (CGSize)viewSize
{
	return self.viewFrame.size;
}

- (CGFloat)viewWidth
{
	return self.viewFrame.size.width;
}

- (CGFloat)viewHeight
{
	return self.viewFrame.size.height;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

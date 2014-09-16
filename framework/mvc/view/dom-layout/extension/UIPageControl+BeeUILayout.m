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

#import "UIPageControl+BeeUILayout.h"

#pragma mark -

@implementation UIPageControl(BeeUILayout)

+ (BOOL)supportForUISizeEstimating
{
	return YES;
}

- (CGSize)estimateUISizeByBound:(CGSize)bound
{
	CGSize result = CGSizeZero;
	result.width = (bound.width <= 0.0f) ? 0.0f : bound.width;
	result.height = (bound.width <= 0.0f) ? 0.0f : bound.height;
	return result;
}

- (CGSize)estimateUISizeByWidth:(CGFloat)width
{
	CGSize result = CGSizeZero;
	result.width = (width <= 0.0f) ? 0.0f : width;
	result.height = 20.0f;
	return result;
}

- (CGSize)estimateUISizeByHeight:(CGFloat)height
{
	CGSize result = CGSizeZero;
	result.width = self.numberOfPages * 20.0f;
	result.height = (height <= 0.0f) ? 0.0f : height;
	return result;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "UIButton+BeeUIStyle.h"

@implementation UIButton(BeeUILayout)

+ (BOOL)supportForUISizeEstimating
{
	return YES;
}

- (CGSize)estimateUISizeByBound:(CGSize)bound
{
	if ( nil == self.currentTitle && nil == self.currentImage && nil == self.currentBackgroundImage )
	{
		return [super estimateUISizeByBound:bound];
	}
	
	CGSize titleSize = [self.currentTitle sizeWithFont:self.font constrainedToSize:bound lineBreakMode:self.lineBreakMode];
	CGSize imageSize = self.currentImage.size;
	CGSize backgroundSize = self.currentBackgroundImage.size;

	CGSize maxSize;
	maxSize.width = fmaxf( fmaxf( titleSize.width, imageSize.width ), backgroundSize.width );
	maxSize.height = fmaxf( fmaxf( titleSize.height, imageSize.height ), backgroundSize.height );
	return maxSize;
}

- (CGSize)estimateUISizeByWidth:(CGFloat)width
{
	if ( nil == self.currentTitle && nil == self.currentImage && nil == self.currentBackgroundImage )
	{
		return [super estimateUISizeByWidth:width];
	}
	
	CGSize titleSize = [self.currentTitle sizeWithFont:self.font constrainedToSize:CGSizeMake(width, 99999) lineBreakMode:self.lineBreakMode];
	CGSize imageSize = self.currentImage.size;
	CGSize backgroundSize = self.currentBackgroundImage.size;
	
	CGSize maxSize;
	maxSize.width = fmaxf( fmaxf( titleSize.width, imageSize.width ), backgroundSize.width );
	maxSize.height = fmaxf( fmaxf( titleSize.height, imageSize.height ), backgroundSize.height );
	
	if ( maxSize.width > width )
	{
		maxSize.width = width;
	}

	return maxSize;
}

- (CGSize)estimateUISizeByHeight:(CGFloat)height
{
	if ( nil == self.currentTitle && nil == self.currentImage && nil == self.currentBackgroundImage )
	{
		return [super estimateUISizeByHeight:height];
	}

	CGSize titleSize = [self.currentTitle sizeWithFont:self.font constrainedToSize:CGSizeMake(99999, height) lineBreakMode:self.lineBreakMode];
	CGSize imageSize = self.currentImage.size;
	CGSize backgroundSize = self.currentBackgroundImage.size;
	
	CGSize maxSize;
	maxSize.width = fmaxf( fmaxf( titleSize.width, imageSize.width ), backgroundSize.width );
	maxSize.height = fmaxf( fmaxf( titleSize.height, imageSize.height ), backgroundSize.height );
	
	if ( maxSize.height > height )
	{
		maxSize.height = height;
	}
	
	return maxSize;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

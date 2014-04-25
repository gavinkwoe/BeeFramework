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

#import "UIView+Screenshot.h"

#pragma mark -

@implementation UIView(Screenshot)

@dynamic screenshot;
@dynamic screenshotOneLayer;

- (UIImage *)screenshot
{
	return [self capture];
}

- (UIImage *)screenshotOneLayer
{
	NSMutableArray * temp = [NSMutableArray nonRetainingArray];
	
	for ( UIView * subview in self.subviews )
	{
		if ( NO == subview.hidden )
		{
			subview.hidden = YES;

			[temp addObject:subview];
		}
	}

	UIImage * image = [self capture];
	
	for ( UIView * subview in temp )
	{
		subview.hidden = NO;
	}
	
	return image;
}

- (UIImage *)capture
{
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	CGRect captureBounds = CGRectZero;
	captureBounds.size = self.bounds.size;
	
	if ( captureBounds.size.width > screenSize.width )
	{
		captureBounds.size.width = screenSize.width;
	}

	if ( captureBounds.size.height > screenSize.height )
	{
		captureBounds.size.height = screenSize.height;
	}
	
	return [self capture:captureBounds];
}

- (UIImage *)capture:(CGRect)frame
{
	UIImage * result = nil;
	
    UIGraphicsBeginImageContextWithOptions( frame.size, NO, 1.0 );

    CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextTranslateCTM( context, -frame.origin.x, -frame.origin.y );
		
//		CGContextScaleCTM(context, 0.5, 0.5);
		[self.layer renderInContext:context];
		
		result = UIGraphicsGetImageFromCurrentImageContext();
	}

    UIGraphicsEndImageContext();
	
    return result;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

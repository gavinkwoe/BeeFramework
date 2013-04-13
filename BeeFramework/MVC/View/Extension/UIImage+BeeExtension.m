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
//  UIImage+BeeExtension.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "UIImage+BeeExtension.h"

#pragma mark -

@implementation UIImage(BeeExtension)

- (UIImage *)alphaImage
{
	CGImageAlphaInfo alpha = CGImageGetAlphaInfo( self.CGImage );
	if ( kCGImageAlphaFirst == alpha ||
		kCGImageAlphaLast == alpha || 
		kCGImageAlphaPremultipliedFirst == alpha ||
		kCGImageAlphaPremultipliedLast == alpha )
	{
		return self;
	}

	CGImageRef imageRef = self.CGImage;
	size_t width = CGImageGetWidth(imageRef);
	size_t height = CGImageGetHeight(imageRef);

	// The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
	CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
														  width,
														  height,
														  8,
														  0,
														  CGImageGetColorSpace(imageRef),
														  kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);

	// Draw the image into the context and retrieve the new image, which will now have an alpha layer
	CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
	UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];

	// Clean up
	CGContextRelease(offscreenContext);
	CGImageRelease(imageRefWithAlpha);

	return imageWithAlpha;
}

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextSetShouldAntialias(context, true);
	CGContextSetAllowsAntialiasing(context, true);
	CGContextAddEllipseInRect(context, rect);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *)rounded
{
    // If the image does not have an alpha layer, add one
    UIImage * image = [self alphaImage];
	CGSize imageSize = image.size;
	imageSize.width = floorf(imageSize.width);
	imageSize.height = floorf(imageSize.height);
	
	CGFloat imageWidth = fminf(imageSize.width, imageSize.height);
	CGFloat imageHeight = imageWidth;
    
    // Build a context that's the same dimensions as the new size
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL,
												 imageWidth,
												 imageHeight,
												 CGImageGetBitsPerComponent(image.CGImage),
												 4 * imageWidth,
												 colorSpace,
												 kCGImageAlphaPremultipliedLast);
	
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
	CGRect circleRect;
	circleRect.origin.x = 0; // (imageSize.width - imageWidth) / 2.0f;
	circleRect.origin.y = 0; // (imageSize.height - imageHeight) / 2.0f;
	circleRect.size.width = imageWidth;
	circleRect.size.height = imageHeight;
	//	circleRect = CGRectInset( circleRect, 4.0f, 4.0f );
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
	
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
	CGRect drawRect;
	drawRect.origin.x = 0; //(imageSize.width - imageWidth) / 2.0f;
	drawRect.origin.y = 0; //(imageSize.height - imageHeight) / 2.0f;
	drawRect.size.width = imageWidth;
	drawRect.size.height = imageHeight;
    CGContextDrawImage(context, drawRect, image.CGImage);
    
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	CGColorSpaceRelease( colorSpace );
	
    // Create a UIImage from the CGImage
    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
	
    return roundedImage;
}

- (UIImage *)rounded:(CGRect)circleRect
{
	// If the image does not have an alpha layer, add one
    UIImage * image = [self alphaImage];
	
    // Build a context that's the same dimensions as the new size
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL,
												 circleRect.size.width,
												 circleRect.size.height,
												 CGImageGetBitsPerComponent(image.CGImage),
												 4 * circleRect.size.width,
												 colorSpace,
												 kCGImageAlphaPremultipliedLast);
	
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
	
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
	CGRect drawRect;
	drawRect.origin.x = 0; //(imageSize.width - imageWidth) / 2.0f;
	drawRect.origin.y = 0; //(imageSize.height - imageHeight) / 2.0f;
	drawRect.size.width = circleRect.size.width;
	drawRect.size.height = circleRect.size.height;
    CGContextDrawImage(context, drawRect, image.CGImage);
	
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
    // Create a UIImage from the CGImage
    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

- (UIImage *)stretched
{
	CGFloat leftCap = floorf(self.size.width / 2.0f);
	CGFloat topCap = floorf(self.size.height / 2.0f);
	return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *)grayscale
{
	CGSize size = self.size;
	CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
	CGColorSpaceRelease(colorSpace);
	
	CGContextDrawImage(context, rect, [self CGImage]);
	CGImageRef grayscale = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	UIImage * image = [UIImage imageWithCGImage:grayscale];
	CFRelease(grayscale);
	
	return image;	
}

- (UIColor *)patternColor
{
	return [UIColor colorWithPatternImage:self];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

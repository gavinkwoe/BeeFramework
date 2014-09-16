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

#import "UIImage+BeeExtension.h"

#pragma mark -

@interface UIImage(ThemePrivate)
- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context;
@end

#pragma mark -

@implementation UIImage(Theme)

- (UIImage *)transprent
{
	CGImageAlphaInfo alpha = CGImageGetAlphaInfo( self.CGImage );
	
	if ( kCGImageAlphaFirst == alpha ||
		kCGImageAlphaLast == alpha ||
		kCGImageAlphaPremultipliedFirst == alpha ||
		kCGImageAlphaPremultipliedLast == alpha )
	{
		return self;
	}

	CGImageRef	imageRef = self.CGImage;
	size_t		width = CGImageGetWidth(imageRef);
	size_t		height = CGImageGetHeight(imageRef);

	CGContextRef context = CGBitmapContextCreate( NULL, width, height, 8, 0, CGImageGetColorSpace(imageRef), kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedFirst);
	CGContextDrawImage( context, CGRectMake(0, 0, width, height), imageRef );

	CGImageRef	resultRef = CGBitmapContextCreateImage( context );
	UIImage *	result = [UIImage imageWithCGImage:resultRef];

	CGContextRelease( context );
	CGImageRelease( resultRef );

	return result;
}

- (UIImage *)resize:(CGSize)newSize
{
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if ( width > newSize.width || height > newSize.height )
	{
        CGFloat ratio = width/height;
        if ( ratio > 1 )
		{
            bounds.size.width = newSize.width;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
		{
            bounds.size.height = newSize.height;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ( orient == UIImageOrientationRight || orient == UIImageOrientationLeft )
	{
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
	{
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage * imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/

- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context
{
    CGContextSaveGState( context );
    CGContextTranslateCTM( context, CGRectGetMinX(rect), CGRectGetMinY(rect) );
	CGContextSetShouldAntialias( context, true );
	CGContextSetAllowsAntialiasing( context, true );
	CGContextAddEllipseInRect( context, rect );
    CGContextClosePath( context );
    CGContextRestoreGState( context );
}

- (UIImage *)rounded
{
    UIImage * image = [self transprent];
	if ( nil == image )
		return nil;
	
	CGSize imageSize = image.size;
	imageSize.width = floorf( imageSize.width );
	imageSize.height = floorf( imageSize.height );
	
	CGFloat imageWidth = fminf(imageSize.width, imageSize.height);
	CGFloat imageHeight = imageWidth;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate( NULL,
												 imageWidth,
												 imageHeight,
												 CGImageGetBitsPerComponent(image.CGImage),
												 imageWidth * 4,
												 colorSpace,
												 CGImageGetBitmapInfo(image.CGImage) );
	
    CGContextBeginPath(context);
	CGRect circleRect;
	circleRect.origin.x = 0;
	circleRect.origin.y = 0;
	circleRect.size.width = imageWidth;
	circleRect.size.height = imageHeight;
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
	
	CGRect drawRect;
	drawRect.origin.x = 0;
	drawRect.origin.y = 0;
	drawRect.size.width = imageWidth;
	drawRect.size.height = imageHeight;
    CGContextDrawImage(context, drawRect, image.CGImage);
    
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	CGColorSpaceRelease( colorSpace );
	
    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
	
    return roundedImage;
}

- (UIImage *)rounded:(CGRect)circleRect
{
    UIImage * image = [self transprent];
	if ( nil == image )
		return nil;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate( NULL,
												 circleRect.size.width,
												 circleRect.size.height,
												 CGImageGetBitsPerComponent( image.CGImage ),
												 circleRect.size.width * 4,
												 colorSpace,
												 kCGBitmapAlphaInfoMask );
	
    CGContextBeginPath(context);
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
	
	CGRect drawRect;
	drawRect.origin.x = 0; //(imageSize.width - imageWidth) / 2.0f;
	drawRect.origin.y = 0; //(imageSize.height - imageHeight) / 2.0f;
	drawRect.size.width = circleRect.size.width;
	drawRect.size.height = circleRect.size.height;
    CGContextDrawImage(context, drawRect, image.CGImage);
	
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
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

- (UIImage *)stretched:(UIEdgeInsets)capInsets
{
    return [self resizableImageWithCapInsets:capInsets];
}

- (UIImage *)rotate:(CGFloat)angle
{
	UIImage *	result = nil;
	CGSize		imageSize = self.size;
	CGSize		canvasSize = CGSizeZero;
	
	angle = fmodf( angle, 360 );

	if ( 90 == angle || 270 == angle )
	{
		canvasSize.width = self.size.height;
		canvasSize.height = self.size.width;
	}
	else if ( 0 == angle || 180 == angle )
	{
		canvasSize.width = self.size.width;
		canvasSize.height = self.size.height;
	}
    
    UIGraphicsBeginImageContext( canvasSize );
	
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( bitmap, canvasSize.width / 2, canvasSize.height / 2 );
    CGContextRotateCTM( bitmap, M_PI / 180 * angle );

    CGContextScaleCTM( bitmap, 1.0, -1.0 );
    CGContextDrawImage( bitmap, CGRectMake( -(imageSize.width / 2), -(imageSize.height / 2), imageSize.width, imageSize.height), self.CGImage );
    
	result = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return result;
}

- (UIImage *)rotateCW90
{
	return [self rotate:270];
}

- (UIImage *)rotateCW180
{
	return [self rotate:180];
}

- (UIImage *)rotateCW270
{
	return [self rotate:90];
}

- (UIImage *)grayscale
{
	CGSize size = self.size;
	CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, CGImageGetBitmapInfo(self.CGImage));
	CGColorSpaceRelease(colorSpace);

	if ( context )
	{
		CGContextDrawImage(context, rect, [self CGImage]);
		CGImageRef grayscale = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		
		if ( grayscale )
		{
			UIImage * image = [UIImage imageWithCGImage:grayscale];
			CFRelease(grayscale);
			return image;
		}
	}
	
	return nil;
}

- (UIImage *)crop:(CGRect)rect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef newImageRef = CGImageCreateWithImageInRect(imageRef, rect);
	
    UIGraphicsBeginImageContext(rect.size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextDrawImage(context, rect, newImageRef);
	
    UIImage * image = [UIImage imageWithCGImage:newImageRef];
	
    UIGraphicsEndImageContext();
	
    CGImageRelease(newImageRef);
	
    return image;
}

- (UIImage *)crop2:(CGRect)rect
{
    if ( !CGRectIsEmpty(rect) )
    {
        float scaleX = self.size.width / rect.size.width;
        float scaleY = self.size.height / rect.size.height;
        
        if ( scaleX > scaleY )
        {
            CGFloat width = self.size.height * rect.size.width / rect.size.height;
            CGFloat height = self.size.height;
            // move to center
            CGRect croppedFrame = CGRectMake( 0, 0, width, height );
            croppedFrame.origin.x = fabsf( (self.size.width - width) / 2.f );
            
            return [self crop:croppedFrame];
        }
        else
        {
            CGFloat width = self.size.width;
            CGFloat height = self.size.width * rect.size.height / rect.size.width;
            // just top
            CGRect croppedFrame = CGRectMake( 0, 0, width, height );
            
            return [self crop:croppedFrame];
        }
    }
    
    return self;
}

- (UIImage *)imageInRect:(CGRect)rect
{
	return [self crop:rect];
}

- (UIColor *)patternColor
{
	return [UIColor colorWithPatternImage:self];
}

+ (UIImage *)imageFromString:(NSString *)name
{
	return [self imageFromString:name atPath:nil];
}

+ (UIImage *)imageFromString:(NSString *)name atPath:(NSString *)path
{
	NSArray *	array = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *	imageName = [array objectAtIndex:0];

	imageName = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
	imageName = imageName.unwrap.trim;

	if ( [imageName hasPrefix:@"url("] && [imageName hasSuffix:@")"] )
	{
		NSRange range = NSMakeRange( 4, imageName.length - 5 );
		imageName = [imageName substringWithRange:range].trim;
	}

	UIImage * image = nil;
	
	if ( NO == [name hasPrefix:@"http://"] && NO == [name hasPrefix:@"https://"] )
	{
		NSString *	extension = [imageName pathExtension];
		NSString *	fullName = [imageName substringToIndex:(imageName.length - extension.length - 1)];

		if ( NSNotFound == [name rangeOfString:@"@"].location )
		{
			NSString *	resPath = nil;
			NSString *	resPath2 = nil;

			if ( [BeeSystemInfo isPhoneRetina4] )
			{
				resPath = [fullName stringByAppendingFormat:@"-568h@2x.%@", extension];
				resPath2 = [fullName stringByAppendingFormat:@"-568h.%@", extension];
			}
			else if ( [BeeSystemInfo isPhoneRetina35] || [BeeSystemInfo isPadRetina] )
			{
				resPath = [fullName stringByAppendingFormat:@"@2x.%@", extension];
			}

			if ( path )
			{
				if ( nil == image && resPath )
				{
					NSString * fullPath = [NSString stringWithFormat:@"%@/%@", path, resPath];
					
					if ( [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
					{
						image = [[[UIImage alloc] initWithContentsOfFile:fullPath] autorelease];
					}
				}

				if ( nil == image && resPath2 )
				{
					NSString * fullPath = [NSString stringWithFormat:@"%@/%@", path, resPath2];
					
					if ( [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
					{
						image = [[[UIImage alloc] initWithContentsOfFile:fullPath] autorelease];
					}
				}
			}

			if ( nil == image && name )
			{
				image = [UIImage imageNamed:name];
			}

			if ( nil == image && resPath2 )
			{
				image = [UIImage imageNamed:resPath2];
			}
		}
	}
	
	if ( nil == image && imageName )
	{
		if ( path )
		{
			NSString * fullPath = [NSString stringWithFormat:@"%@/%@", path, imageName];

			if ( [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
			{
				image = [[[UIImage alloc] initWithContentsOfFile:fullPath] autorelease];
			}
		}

		if ( nil == image )
		{
			image = [UIImage imageNamed:imageName];
		}
	}
	
	if ( nil == image )
	{
		return nil;
	}

	BOOL grayed = NO;
	BOOL rounded = NO;
	BOOL streched = NO;
	
	if ( array.count > 1 )
	{
		for ( NSString * attr in [array subarrayWithRange:NSMakeRange(1, array.count - 1)] )
		{
			attr = attr.trim.unwrap;
			
			if ( NSOrderedSame == [attr compare:@"stretch" options:NSCaseInsensitiveSearch] ||
				NSOrderedSame == [attr compare:@"stretched" options:NSCaseInsensitiveSearch] )
			{
				streched = YES;
			}
			else if ( NSOrderedSame == [attr compare:@"round" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"rounded" options:NSCaseInsensitiveSearch] )
			{
				rounded = YES;
			}
			else if ( NSOrderedSame == [attr compare:@"gray" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"grayed" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"grayScale" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"gray-scale" options:NSCaseInsensitiveSearch] )
			{
				grayed = YES;
			}
		}
	}
	
	if ( image )
	{
		if ( rounded )
		{
			image = image.rounded;
		}

		if ( grayed )
		{
			image = image.grayscale;
		}

		if ( streched )
		{
			image = image.stretched;
		}
	}

	return image;
}

+ (UIImage *)imageFromString:(NSString *)name stretched:(UIEdgeInsets)capInsets
{
	UIImage * image = [self imageFromString:name];
	if ( nil == image )
		return nil;

	return [image resizableImageWithCapInsets:capInsets];
}

+ (UIImage *)imageFromVideo:(NSURL *)videoURL atTime:(CMTime)time scale:(CGFloat)scale
{
	AVURLAsset * asset = [[[AVURLAsset alloc] initWithURL:videoURL options:nil] autorelease];
    AVAssetImageGenerator * generater = [[[AVAssetImageGenerator alloc] initWithAsset:asset] autorelease];
    generater.appliesPreferredTrackTransform = YES;
	generater.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
	generater.maximumSize = [UIScreen mainScreen].bounds.size;

    NSError * error = nil;
	UIImage * thumb = nil;
	
    CGImageRef image = [generater copyCGImageAtTime:time actualTime:NULL error:&error];
	if ( image )
	{
		thumb = [[[UIImage alloc] initWithCGImage:image scale:scale orientation:UIImageOrientationUp] autorelease];
		CGImageRelease(image);
	}
	
    return thumb;
}

+ (UIImage *)merge:(NSArray *)images
{
	UIImage * image = nil;
	
	for ( UIImage * otherImage in images )
	{
		if ( nil == image )
		{
			image = otherImage;
		}
		else
		{
			image = [image merge:otherImage];
		}
	}
	
	return image;
}

- (UIImage *)merge:(UIImage *)image
{
	CGSize canvasSize;
	canvasSize.width = fmaxf( self.size.width, image.size.width );
	canvasSize.height = fmaxf( self.size.height, image.size.height );
	
//	UIGraphicsBeginImageContext( canvasSize );
	UIGraphicsBeginImageContextWithOptions( canvasSize, NO, self.scale );

	CGPoint offset1;
	offset1.x = (canvasSize.width - self.size.width) / 2.0f;
	offset1.y = (canvasSize.height - self.size.height) / 2.0f;

	CGPoint offset2;
	offset2.x = (canvasSize.width - image.size.width) / 2.0f;
	offset2.y = (canvasSize.height - image.size.height) / 2.0f;

	[self drawAtPoint:offset1 blendMode:kCGBlendModeNormal alpha:1.0f];
	[image drawAtPoint:offset2 blendMode:kCGBlendModeNormal alpha:1.0f];

    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return result;
}

- (NSData *)dataWithExt:(NSString *)ext
{
    if ( [ext compare:@"png" options:NSCaseInsensitiveSearch] )
    {
        return UIImagePNGRepresentation(self);
    }
    else if ( [ext compare:@"jpg" options:NSCaseInsensitiveSearch] )
    {
        return UIImageJPEGRepresentation(self, 0);
    }
    else
    {
        return nil;
    }
}

- (UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
	
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
	
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
			
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
			
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
		default:
			break;
    }
	
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
			
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
		default:
			break;
    }
	
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
			
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
	
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

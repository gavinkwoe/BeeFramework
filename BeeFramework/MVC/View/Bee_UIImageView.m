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
//  Bee_UIImageView.m
//

#import <TargetConditionals.h>
#import <QuartzCore/QuartzCore.h>

#import "Bee_UIImageView.h"
#import "Bee_UIActivityIndicatorView.h"
#import "Bee_UISignal.h"
#import "Bee_Sandbox.h"
#import "Bee_SystemInfo.h"

#import "NSString+BeeExtension.h"

#pragma mark -

@implementation BeeImageCache

DEF_SINGLETON( BeeImageCache );

- (id)init
{
	self = [super init];
	if ( self )
	{
		_memoryCache = [[BeeMemoryCache alloc] init];
		_memoryCache.clearWhenMemoryLow = YES;
		
		_fileCache = [[BeeFileCache alloc] init];
		_fileCache.cachePath = [NSString stringWithFormat:@"%@/images/", [BeeSandbox libCachePath]];
		_fileCache.cacheUser = @"";
	}
	
	return self;
}

- (void)dealloc
{
	[_memoryCache release];
	[_fileCache release];
	
    [super dealloc];
}

- (BOOL)hasCachedForURL:(NSString *)string
{
	NSString * cacheKey = [string MD5];
	
	BOOL flag = [_memoryCache hasCached:cacheKey];
	if ( NO == flag )
	{
		flag = [_fileCache hasCached:cacheKey];
	}
	
	return flag;	
}

- (UIImage *)imageForURL:(NSString *)string
{
	NSString * cacheKey = [string MD5];

	NSObject * image = [_memoryCache objectForKey:cacheKey];
	if ( image && [image isKindOfClass:[UIImage class]] )
	{
		return (UIImage *)image;
	}

	NSData * data = [_fileCache dataForKey:cacheKey];
	if ( data )
	{
		return [UIImage imageWithData:data];
	}

	return nil;
}

- (void)saveImage:(UIImage *)image forURL:(NSString *)string
{
	NSString * cacheKey = [string MD5];
	[_memoryCache saveObject:image forKey:cacheKey];
	[_fileCache saveData:UIImagePNGRepresentation(image) forKey:cacheKey];
}

- (void)saveData:(NSData *)data forURL:(NSString *)string
{
	NSString * cacheKey = [string MD5];
	[_fileCache saveData:data forKey:cacheKey];
}

- (void)deleteImageForURL:(NSString *)string
{
	NSString * cacheKey = [string MD5];
	
	[_memoryCache deleteKey:cacheKey];
	[_fileCache deleteKey:cacheKey];
}

- (void)deleteAllImages
{
	[_memoryCache deleteAll];
	[_fileCache deleteAll];	
}

@end

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

@end

#pragma mark -

@interface BeeUIImageView(Private)
- (void)initSelf;
- (void)changeImage:(UIImage *)image;
@end

@implementation BeeUIImageView

DEF_SIGNAL( LOAD_START )
DEF_SIGNAL( LOAD_COMPLETED )
DEF_SIGNAL( LOAD_FAILED )
DEF_SIGNAL( LOAD_CANCELLED )

@synthesize rounded = _rounded;
@synthesize loading = _loading;
@synthesize indicator = _indicator;
@synthesize loadedURL = _loadedURL;

@synthesize url;
@synthesize file;
@synthesize resource;

+ (BeeUIImageView *)spawn
{
	return [[[BeeUIImageView alloc] initWithImage:nil] autorelease];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithImage:(UIImage *)image
{
	self = [super initWithImage:image];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)initSelf
{
	self.hidden = NO;
	self.backgroundColor = [UIColor clearColor];
	self.layer.masksToBounds = YES;
	self.layer.opaque = YES;
	self.contentMode = UIViewContentModeCenter;

	_loading = NO;
}

- (void)GET:(NSString *)string useCache:(BOOL)useCache
{
	[self GET:string useCache:useCache placeHolder:nil];
}

- (void)GET:(NSString *)string useCache:(BOOL)useCache placeHolder:(UIImage *)defaultImage
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	if ( nil == string )
		return;

	if ( NO == [string hasPrefix:@"http://"] )
	{
		string = [NSString stringWithFormat:@"http://%@", string];
	}

	if ( [string isEqualToString:self.loadedURL] )
		return;

	if ( [self requestingURL:string] )
		return;

	[self cancelRequests];

	self.loading = NO;
	self.loadedURL = string;

	if ( useCache && [[BeeImageCache sharedInstance] hasCachedForURL:string] )
	{
		[self changeImage:[[BeeImageCache sharedInstance] imageForURL:string]];
	}
	else
	{
		[self changeImage:defaultImage];
		[self cancelRequests];
		[self GET:string];
	}
}

- (void)setUrl:(NSString *)string
{
	[self GET:string useCache:YES];
}

- (void)setFile:(NSString *)path
{
	UIImage * image = [UIImage imageWithContentsOfFile:path];
	if ( image )
	{
		[self changeImage:image];
	}
}

- (void)setResource:(NSString *)string
{
	UIImage * image = [UIImage imageNamed:string];
	if ( image )
	{
		[self changeImage:image];
	}
}

- (void)setImage:(UIImage *)image
{
	[self changeImage:image];
}

- (void)changeImage:(UIImage *)image
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	if ( nil == image )
	{
		[self cancelRequests];
		
		self.loadedURL = nil;
		self.loading = NO;
		
		[super setImage:nil];
		return;
	}

	if ( image != self.image )
	{
		[self cancelRequests];

		if ( self.rounded )
		{
			image = [image rounded];
		}

		CGAffineTransform transform = CGAffineTransformIdentity;
		UIImageOrientation orientation = image.imageOrientation;
		switch ( orientation )
		{
		case UIImageOrientationDown:           // EXIF = 3
		case UIImageOrientationDownMirrored:   // EXIF = 4
			transform = CGAffineTransformRotate(transform, M_PI);
			break;

		case UIImageOrientationLeft:           // EXIF = 6
		case UIImageOrientationLeftMirrored:   // EXIF = 5
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;
			
		case UIImageOrientationRight:          // EXIF = 8
		case UIImageOrientationRightMirrored:  // EXIF = 7
			transform = CGAffineTransformRotate(transform, -M_PI_2);
			break;
		case UIImageOrientationUp:
		case UIImageOrientationUpMirrored:
			break;
		}

		self.transform = transform;

		[super setImage:image];
	}
	
	[self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];

	if ( _indicator )
	{
		CGRect indicatorFrame;
		indicatorFrame.size.width = 20.0f;
		indicatorFrame.size.height = 20.0f;
		indicatorFrame.origin.x = (frame.size.width - indicatorFrame.size.width) / 2.0f;
		indicatorFrame.origin.y = (frame.size.height - indicatorFrame.size.height) / 2.0f;
		
		_indicator.frame = indicatorFrame;
	}
}

- (void)clear
{
	[self cancelRequests];
	[self changeImage:nil];

	self.loadedURL = nil;
	self.loading = NO;
}

- (void)dealloc
{
	[self cancelRequests];
	
	self.loadedURL = nil;
	self.loading = NO;
	
	SAFE_RELEASE_SUBVIEW( _indicator );

	[super dealloc];
}

- (BeeUIActivityIndicatorView *)indicator
{
	if ( nil == _indicator )
	{
		CGRect indicatorFrame;
		indicatorFrame.size.width = 20.0f;
		indicatorFrame.size.height = 20.0f;
		indicatorFrame.origin.x = (self.frame.size.width - indicatorFrame.size.width) / 2.0f;
		indicatorFrame.origin.y = (self.frame.size.height - indicatorFrame.size.height) / 2.0f;
		
		_indicator = [[BeeUIActivityIndicatorView alloc] initWithFrame:indicatorFrame];
		_indicator.backgroundColor = [UIColor clearColor];
		[self addSubview:_indicator];
	}
	
	return _indicator;
}

#pragma -
#pragma NetworkRequestDelegate

- (void)handleRequest:(BeeRequest *)request
{
	if ( request.sending )
	{
		[_indicator startAnimating];

		[self setLoading:YES];
		[self sendUISignal:BeeUIImageView.LOAD_START];
	}
	else if ( request.sendProgressed )
	{
	}
	else if ( request.recving )
	{
	}
	else if ( request.recvProgressed )
	{
	}
	else if ( request.succeed )
	{
		[_indicator stopAnimating];

		NSData * data = [request responseData];
		if ( data )
		{
			UIImage * image = [UIImage imageWithData:data];
			if ( image )
			{
				[self changeImage:image];
			}

			NSString * string = [request.url absoluteString];
			[[BeeImageCache sharedInstance] saveImage:image forURL:string];
			[[BeeImageCache sharedInstance] saveData:data forURL:string];

			[self setLoading:NO];
			[self sendUISignal:BeeUIImageView.LOAD_COMPLETED];
		}
		else
		{
			[self setLoading:NO];
			[self sendUISignal:BeeUIImageView.LOAD_FAILED];
		}
	}
	else if ( request.failed )
	{
		[_indicator stopAnimating];	
		
		[self setLoading:NO];
		[self sendUISignal:BeeUIImageView.LOAD_FAILED];
	}
	else if ( request.cancelled )
	{
		[_indicator stopAnimating];
		
		[self setLoading:NO];
		[self sendUISignal:BeeUIImageView.LOAD_CANCELLED];
	}
}

@end

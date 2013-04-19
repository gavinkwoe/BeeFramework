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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UIImageView.h"
#import "Bee_UIActivityIndicatorView.h"
#import "Bee_UISignal.h"
#import "Bee_Sandbox.h"
#import "Bee_SystemInfo.h"
#import "Bee_Thread.h"
#import "Bee_Performance.h"

#import "NSString+BeeExtension.h"
#import "UIImage+BeeExtension.h"
#import "UIView+BeeExtension.h"
#import "UIView+BeeUISignal.h"

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
		_fileCache.cachePath = [NSString stringWithFormat:@"%@/BeeImages/", [BeeSandbox libCachePath]];
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
	NSString *	cacheKey = [string MD5];
	UIImage *	image = nil;

	NSObject * object = [_memoryCache objectForKey:cacheKey];
	if ( object && [object isKindOfClass:[UIImage class]] )
	{
		image = (UIImage *)object;
	}

	if ( nil == image )
	{
		NSString * fullPath = [_fileCache cacheFileName:cacheKey];
		if ( fullPath )
		{
			image = [UIImage imageWithContentsOfFile:fullPath];

			UIImage * cachedImage = (UIImage *)[_memoryCache objectForKey:cacheKey];
			if ( nil == cachedImage && image != cachedImage )
			{
				[_memoryCache saveObject:image forKey:cacheKey];
			}
		}
	}

	return image;
}

- (void)saveImage:(UIImage *)image forURL:(NSString *)string
{
	NSString * cacheKey = [string MD5];
	UIImage * cachedImage = (UIImage *)[_memoryCache objectForKey:cacheKey];
	if ( nil == cachedImage && image != cachedImage )
	{
		[_memoryCache saveObject:image forKey:cacheKey];
		[_fileCache saveData:UIImagePNGRepresentation(image) forKey:cacheKey];	
	}	
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

@interface BeeUIImageView(Private)
- (void)initSelf;
- (void)changeImage:(UIImage *)image;
@end

@implementation BeeUIImageView

DEF_SIGNAL( LOAD_START )
DEF_SIGNAL( LOAD_COMPLETED )
DEF_SIGNAL( LOAD_FAILED )
DEF_SIGNAL( LOAD_CANCELLED )

DEF_SIGNAL( WILL_CHANGE )
DEF_SIGNAL( DID_CHANGED )

@synthesize gray = _gray;
@synthesize rounded = _rounded;
@synthesize loading = _loading;
@synthesize indicator = _indicator;
@synthesize loadedURL = _loadedURL;
@synthesize loaded	= _loaded;

@synthesize url;
@synthesize file;
@synthesize resource;

+ (BeeUIImageView *)spawn
{
	return [[[BeeUIImageView alloc] initWithImage:nil] autorelease];
}

+ (BeeUIImageView *)spawn:(NSString *)tagString
{
	BeeUIImageView * view = [[[BeeUIImageView alloc] init] autorelease];
	view.tagString = tagString;
	return view;
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
	_loaded	 = NO;
}

- (void)GET:(NSString *)string useCache:(BOOL)useCache
{
	[self GET:string useCache:useCache placeHolder:nil];
}

- (void)GET:(NSString *)string useCache:(BOOL)useCache placeHolder:(UIImage *)defaultImage
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	if ( nil == string || 0 == string.length )
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
	self.loaded		= NO;

PERF_ENTER
	
	if ( useCache && [[BeeImageCache sharedInstance] hasCachedForURL:string] )
	{
	PERF_ENTER_(1)
		UIImage * image = [[BeeImageCache sharedInstance] imageForURL:string];
	PERF_LEAVE_(1)
		
		if ( image )
		{
		PERF_ENTER_(2)
			[self changeImage:image];
		PERF_LEAVE_(2)
			
		PERF_ENTER_(3)
			self.loaded = YES;
		PERF_LEAVE_(3)

		PERF_LEAVE
			return;
		}
	}

PERF_ENTER_(4)
	[self changeImage:defaultImage];
PERF_ENTER_(4)
	
PERF_ENTER_(5)
	[self cancelRequests];
PERF_ENTER_(5)

	self.HTTP_GET( string );
	
PERF_LEAVE
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
		[super setNeedsDisplay];
		return;
	}

	if ( image != self.image )
	{
		[self sendUISignal:BeeUIImageView.WILL_CHANGE];
		
		[self cancelRequests];

		if ( self.rounded )
		{
			image = [image rounded];
		}

		if ( self.gray )
		{
			image = [image grayscale];
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
		
		[self sendUISignal:BeeUIImageView.DID_CHANGED];
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

- (void)readFromURL:(NSString *)value
{
	self.url = value;
}

- (void)readFromFile:(NSString *)value
{
	self.file = value;
}

- (void)readFromResource:(NSString *)value
{
	self.resource = value;
}

#pragma mark -
#pragma mark NetworkRequestDelegate

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
				NSString * string = [request.url absoluteString];
				[[BeeImageCache sharedInstance] saveImage:image forURL:string];
				[[BeeImageCache sharedInstance] saveData:data forURL:string];

				[self setLoading:NO];
				self.loaded = YES;
				
				[self changeImage:image];

				[self sendUISignal:BeeUIImageView.LOAD_COMPLETED];
			}
			else
			{
				[self setLoading:NO];
				self.loaded = NO;
				
				[self sendUISignal:BeeUIImageView.LOAD_FAILED];
			}
		}
		else
		{
			[self setLoading:NO];
			self.loaded = NO;
			
			[self sendUISignal:BeeUIImageView.LOAD_FAILED];
		}
	}
	else if ( request.failed )
	{
		[_indicator stopAnimating];	
		
		[self setLoading:NO];
		self.loaded = NO;
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

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "Bee_UIImageView.h"
#import "Bee_Cache.h"
#import "Bee_Network.h"
#import "Bee_UIActivityIndicatorView.h"

#import "UIImage+Theme.h"

#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

@interface BeeImageCache()
{
	BeeMemoryCache *	_memoryCache;
	BeeFileCache *		_fileCache;
}
@end

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
	
	BOOL flag = [_memoryCache hasObjectForKey:cacheKey];
	if ( NO == flag )
	{
		flag = [_fileCache hasObjectForKey:cacheKey];
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
		NSString * fullPath = [_fileCache fileNameForKey:cacheKey];
		if ( fullPath )
		{
			image = [UIImage imageWithContentsOfFile:fullPath];

			UIImage * cachedImage = (UIImage *)[_memoryCache objectForKey:cacheKey];
			if ( nil == cachedImage && image != cachedImage )
			{
				[_memoryCache setObject:image forKey:cacheKey];
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
		[_memoryCache setObject:image forKey:cacheKey];
		[_fileCache setObject:UIImagePNGRepresentation(image) forKey:cacheKey];
	}	
}

- (void)saveData:(NSData *)data forURL:(NSString *)string
{
	NSString * cacheKey = [string MD5];
	[_fileCache setObject:data forKey:cacheKey];
}

- (void)deleteImageForURL:(NSString *)string
{
	NSString * cacheKey = [string MD5];
	
	[_memoryCache removeObjectForKey:cacheKey];
	[_fileCache removeObjectForKey:cacheKey];
}

- (void)deleteAllImages
{
	[_memoryCache removeAllObjects];
	[_fileCache removeAllObjects];
}

@end

#pragma mark -

@interface BeeUIImageView()
{
	BOOL							_inited;
	BOOL							_gray;
	BOOL							_round;
	BOOL							_strech;
	UIEdgeInsets					_strechInsets;
	BOOL							_loading;
	BeeUIActivityIndicatorView *	_indicator;
	NSString *						_loadedURL;
	BOOL							_loaded;
}

- (void)initSelf;
- (void)changeImage:(UIImage *)image;

@end

@implementation BeeUIImageView

DEF_SIGNAL( LOAD_START )
DEF_SIGNAL( LOAD_COMPLETED )
DEF_SIGNAL( LOAD_FAILED )
DEF_SIGNAL( LOAD_CANCELLED )
DEF_SIGNAL( LOAD_CACHE )

DEF_SIGNAL( WILL_CHANGE )
DEF_SIGNAL( DID_CHANGED )

@synthesize gray = _gray;
@synthesize round = _round;
@synthesize strech = _strech;
@synthesize strechInsets = _strechInsets;
@synthesize loading = _loading;
@synthesize indicator = _indicator;
@dynamic indicatorStyle;
@synthesize loadedURL = _loadedURL;
@synthesize loaded	= _loaded;

@synthesize url;
@synthesize file;
@synthesize resource;

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
	if ( NO == _inited )
	{
		self.hidden = NO;
		self.backgroundColor = [UIColor clearColor];
		self.layer.masksToBounds = YES;
		self.layer.opaque = YES;
		self.contentMode = UIViewContentModeCenter;

		_loading = NO;
		_loaded	 = NO;
		
		_gray = NO;
		_round = NO;
		_strech = NO;
		_strechInsets = UIEdgeInsetsZero;
		
		_inited = YES;

		[self load];
	}
}

- (void)GET:(NSString *)string useCache:(BOOL)useCache
{
	[self GET:string useCache:useCache placeHolder:nil];
}

- (void)GET:(NSString *)string useCache:(BOOL)useCache placeHolder:(UIImage *)defaultImage
{
	if ( nil == string || 0 == string.length )
	{
		[self changeImage:nil];
		return;
	}

	if ( NO == [string hasPrefix:@"http://"] )
	{
		string = [NSString stringWithFormat:@"http://%@", string];
	}

	if ( [string isEqualToString:self.loadedURL] )
		return;

	if ( [self requestingURL:string] )
		return;

	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	[self cancelRequests];

	self.loading	= NO;
	self.loadedURL	= string;
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
			
			[self sendUISignal:BeeUIImageView.LOAD_CACHE];
			return;
		}
	}

PERF_ENTER_(4)
	[self changeImage:defaultImage];
PERF_ENTER_(4)
	
//PERF_ENTER_(5)
//	[self cancelRequests];
//PERF_ENTER_(5)

	self.HTTP_GET( string ).TIMEOUT( 20.0f );
	
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
	else
	{
		[self changeImage:nil];
	}
}

- (void)setResource:(NSString *)string
{
	UIImage * image = [UIImage imageNamed:string];
	if ( image )
	{
		[self changeImage:image];
	}
	else
	{
		[self changeImage:nil];
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
//		[self sendUISignal:BeeUIImageView.WILL_CHANGE];
		
		[self cancelRequests];

		if ( self.round )
		{
			image = [image rounded];
		}

		if ( self.gray )
		{
			image = [image grayscale];
		}
		
		if ( self.strech )
		{
			if ( NO == UIEdgeInsetsEqualToEdgeInsets(_strechInsets, UIEdgeInsetsZero) )
			{
				image = [image stretched:_strechInsets];
			}
			else
			{
				image = [image stretched];
			}
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
		
//		[self sendUISignal:BeeUIImageView.DID_CHANGED];
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
	[self unload];

	[self cancelRequests];
	
	self.loadedURL = nil;
	self.loading = NO;
	
	[_indicator removeFromSuperview];
	[_indicator release];

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

- (UIActivityIndicatorViewStyle)indicatorStyle
{
	return self.indicator.activityIndicatorViewStyle;
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)value
{
	self.indicator.activityIndicatorViewStyle = value;
}

#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.sending )
	{
		[_indicator startAnimating];

		[self setLoading:YES];
//		[self sendUISignal:BeeUIImageView.LOAD_START];
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

//				[self sendUISignal:BeeUIImageView.LOAD_COMPLETED];
			}
			else
			{
				[self setLoading:NO];
				self.loaded = NO;
				
//				[self sendUISignal:BeeUIImageView.LOAD_FAILED];
			}
		}
		else
		{
			[self setLoading:NO];
			self.loaded = NO;
			
//			[self sendUISignal:BeeUIImageView.LOAD_FAILED];
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
//		[self sendUISignal:BeeUIImageView.LOAD_CANCELLED];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

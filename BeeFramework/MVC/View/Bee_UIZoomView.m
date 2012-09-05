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
//  Bee_UIZoomView.m
//

#import "Bee_UIZoomView.h"
#import "Bee_UISignal.h"
#import "Bee_UIRect.h"
#import "NSNumber+BeeExtension.h"

#pragma mark -

@implementation BeeUIZoomInnerView

@synthesize zoomDelegate = _zoomDelegate;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		
		UITapGestureRecognizer * singleTapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)] autorelease];
		singleTapGesture.numberOfTapsRequired = 1;
		singleTapGesture.numberOfTouchesRequired = 1;
		singleTapGesture.cancelsTouchesInView = YES;
		singleTapGesture.delaysTouchesBegan = YES;
		singleTapGesture.delaysTouchesEnded = YES;
		[self addGestureRecognizer:singleTapGesture];
		
		UITapGestureRecognizer * doubleTapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)] autorelease];
		doubleTapGesture.numberOfTapsRequired = 2;
		doubleTapGesture.numberOfTouchesRequired = 1;
		doubleTapGesture.cancelsTouchesInView = YES;
		[self addGestureRecognizer:doubleTapGesture];
	}
	return self;
}

- (void)setContentSize:(CGSize)size
{
	CGPoint		middlePos;
	CGSize		selfSize = self.frame.size;
	CGSize		contSize = CGSizeZero;
	UIView *	contView = nil;

	if ( _zoomDelegate && [_zoomDelegate respondsToSelector:@selector(zoomContentView:)] )
	{
		contView = [_zoomDelegate zoomContentView:self];
	}

	if ( _zoomDelegate && [_zoomDelegate respondsToSelector:@selector(zoomContentSize:)] )
	{
		contSize = [_zoomDelegate zoomContentSize:self];
	}
	
	if ( nil == contView )
		return;
	
	if ( self.zoomScale >= self.minimumZoomScale )
	{
		float newHeight = contSize.height * self.zoomScale;
		float newWidth = contSize.width * self.zoomScale;
		
		if (newHeight < selfSize.height )
		{
			newHeight = selfSize.height;
		}
		
		if (newWidth < selfSize.width )
		{
			newWidth = selfSize.width;
		}
		
		size.height = newHeight;
		size.width = newWidth;
		
		middlePos = CGPointMake( size.width / 2.0f, size.height / 2.0f );
	}
	else
	{
		middlePos = CGPointMake( selfSize.width / 2.0f, selfSize.height / 2.0f );
	}
	
	contView.center = middlePos;
	[super setContentSize:size];
	
	if ( _zoomDelegate )
	{
		[_zoomDelegate zoomInnerViewChanged:self];
	}
}

- (void)onSingleTap:(UITapGestureRecognizer *)recognizer
{
	if ( UIGestureRecognizerStateEnded == recognizer.state )
	{
		CGPoint location = [recognizer locationInView:self];
		if ( _zoomDelegate )
		{
			[_zoomDelegate zoomInnerViewSingleTapped:self location:location];
		}		
	}	
}

- (void)onDoubleTap:(UITapGestureRecognizer *)recognizer
{
	if ( UIGestureRecognizerStateEnded == recognizer.state )
	{
		CGPoint location = [recognizer locationInView:self];
		if ( _zoomDelegate )
		{
			[_zoomDelegate zoomInnerViewDoubleTapped:self location:location];
		}
	}
}

- (void)dealloc
{
	[super dealloc];
}

@end

#pragma mark -

@interface BeeUIZoomView(Private)
- (void)initSelf:(CGRect)frame;
- (void)whenScalingAnimationStopped;
- (void)onSingleTap:(UIPanGestureRecognizer *) recognizer;
- (void)onDoubleTap:(UIPanGestureRecognizer *) recognizer;
@end

@implementation BeeUIZoomView

DEF_SIGNAL( ZOOMING );
DEF_SIGNAL( ZOOMED );
DEF_SIGNAL( SINGLE_TAPPED );
DEF_SIGNAL( DOUBLE_TAPPED );

@synthesize innerView = _innerView;
@synthesize content = _content;
@synthesize contentSize = _contentSize;

+ (BeeUIZoomView *)spawn
{
	return [[[BeeUIZoomView alloc] init] autorelease];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf:CGRectZero];		
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf:frame];		
	}
	return self;
}

- (void)initSelf:(CGRect)frame
{
	self.alpha = 1.0f;
	self.backgroundColor = [UIColor clearColor];
	
	_innerView = [[BeeUIZoomInnerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	_innerView.backgroundColor = [UIColor clearColor];
	_innerView.zoomScale = 1.0f;
	_innerView.minimumZoomScale = 0.8f;
	_innerView.maximumZoomScale = 4.0f;
	_innerView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	_innerView.contentMode = UIViewContentModeScaleAspectFit;
	_innerView.contentOffset = CGPointZero;
	_innerView.contentSize = CGSizeMake( frame.size.width, frame.size.height );
	_innerView.clipsToBounds = YES;
	_innerView.bouncesZoom = YES;
	_innerView.scrollEnabled = YES;
	_innerView.bouncesZoom = YES;
	_innerView.bounces = YES;
	_innerView.decelerationRate = _innerView.decelerationRate * 0.75f;
	_innerView.showsVerticalScrollIndicator = NO;
	_innerView.showsHorizontalScrollIndicator = NO;
	_innerView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	_innerView.multipleTouchEnabled = YES;
	_innerView.delegate = self;
	_innerView.zoomDelegate = self;
	[self addSubview:_innerView];	}

- (void)resetZoom
{
	_innerView.zoomScale = 1.0f;
}

- (void)layoutContent
{
	_content.frame = AspectFitRect( CGRectMake(0, 0, _contentSize.width, _contentSize.height), self.bounds );
	_innerView.frame = self.bounds;
	_innerView.contentSize = _contentSize;

	[self layoutSubviews];
}

- (void)layoutContentRotated
{
	CGRect bound;
	bound.origin = self.bounds.origin;
	bound.size.width = self.bounds.size.height;
	bound.size.height = self.bounds.size.width;
	
	_content.frame = AspectFitRect( CGRectMake(0, 0, _contentSize.height, _contentSize.width), bound );
	_innerView.frame = bound;
	
	CGSize contSize;
	contSize.width = _contentSize.height;
	contSize.height = _contentSize.width;

	_innerView.contentSize = contSize;
	
	[self layoutSubviews];
}

- (void)setContentSize:(CGSize)size
{
	_contentSize = AspectFitSize( size, self.bounds.size );
}

- (void)setContent:(UIView *)contentView animated:(BOOL)animated
{
	if ( nil == contentView )
		return;
	
	if ( contentView == _content )
		return;
	
	if ( _content )
	{
		[_content removeFromSuperview];
	}

	self.content = contentView;

	if ( _content )
	{
		[_innerView addSubview:_content];

		if ( animated )
		{
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.3f];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(whenScalingAnimationStopped)];
		}

		[self layoutSubviews];		

		if ( animated )
		{
			[UIView commitAnimations];
		}
		else
		{
			[self whenScalingAnimationStopped];
		}
	}
}

- (void)whenScalingAnimationStopped
{
}

- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _content );
	SAFE_RELEASE_SUBVIEW( _innerView );

	[super dealloc];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self sendUISignal:BeeUIZoomView.ZOOMING];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
	[self sendUISignal:BeeUIZoomView.ZOOMED];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self sendUISignal:BeeUIZoomView.ZOOMING];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self sendUISignal:BeeUIZoomView.ZOOMING];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	[self sendUISignal:BeeUIZoomView.ZOOMING];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self sendUISignal:BeeUIZoomView.ZOOMING];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return _content;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{	
	[self sendUISignal:BeeUIZoomView.ZOOMED];
	
	if ( _innerView.zoomScale < 1.0f )
	{
		[_innerView setZoomScale:1.0f animated:YES];
	}
}

#pragma mark -
#pragma mark ZoomInnerViewDelegate

- (CGSize)zoomContentSize:(BeeUIZoomInnerView *)view
{
	return _contentSize;
}

- (UIView *)zoomContentView:(BeeUIZoomInnerView *)view
{
	return _content;
}

- (void)zoomInnerViewChanged:(BeeUIZoomInnerView *)view
{
	[self sendUISignal:BeeUIZoomView.ZOOMING];
}

- (void)zoomInnerViewSingleTapped:(BeeUIZoomInnerView *)view location:(CGPoint)location
{
	NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
						   __FLOAT(location.x), @"x",
						   __FLOAT(location.y), @"y",
						   nil];

	[self sendUISignal:BeeUIZoomView.SINGLE_TAPPED withObject:dict];
}

- (void)zoomInnerViewDoubleTapped:(BeeUIZoomInnerView *)view location:(CGPoint)location
{
    CGRect	zoomRect;
    float	zoomScale = 0.0f;
	
	if ( _innerView.zoomScale < 1.0f )
	{
		zoomScale = 1.0f;
	}
	else if ( _innerView.zoomScale == 1.0f )
	{
		zoomScale = _innerView.maximumZoomScale;
	}
	else if ( _innerView.zoomScale > 1.0f && _innerView.zoomScale < _innerView.maximumZoomScale )
	{
		zoomScale = _innerView.maximumZoomScale;
	}
	else
	{
		zoomScale = 1.0f; // _innerView.minimumZoomScale;
	}
	
	zoomRect.size.width  = _innerView.frame.size.width  / zoomScale;
	zoomRect.size.height = _innerView.frame.size.height / zoomScale;
    zoomRect.origin.x = (self.bounds.size.width - zoomRect.size.width) / 2.0f;
    zoomRect.origin.y = (self.bounds.size.height - zoomRect.size.height) / 2.0f;
	
	[_innerView zoomToRect:zoomRect animated:YES];
	
	[self sendUISignal:BeeUIZoomView.DOUBLE_TAPPED];
}

@end

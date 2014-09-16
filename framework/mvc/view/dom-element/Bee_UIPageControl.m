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

#import "Bee_UIPageControl.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

@interface BeeUIPageControl()
{
	BOOL		_inited;
	UIImage *	_dotImageNormal;
	UIImage *	_dotImageHilite;
	UIImage *	_dotImageLast;
	CGSize		_dotSize;
}

- (void)initSelf;
- (void)updateDotImages;

@end

#pragma mark -

@implementation BeeUIPageControl

@synthesize dotImageNormal = _dotImageNormal;
@synthesize dotImageHilite = _dotImageHilite;
@synthesize dotImageLast = _dotImageLast;
@synthesize dotSize = _dotSize;

- (id)init
{
	self = [super initWithFrame:CGRectZero];
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
		self.numberOfPages = 0;
		self.currentPage = 0;
		self.hidesForSinglePage = NO;
		self.defersCurrentPageDisplay = NO;
		
		_inited = YES;
		
//		[self load];
		[self performLoad];
	}
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	[_dotImageNormal release];
	[_dotImageHilite release];
	[_dotImageLast release];
    
	[super dealloc];
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
	return _dotSize;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	BOOL flag = [super beginTrackingWithTouch:touch withEvent:event];
	if ( flag )
	{
		[self updateDotImages];
	}
	return flag;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	BOOL flag = [super continueTrackingWithTouch:touch withEvent:event];
	if ( flag )
	{
		[self updateDotImages];
	}
	return flag;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self updateDotImages];

	[super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
	[self updateDotImages];

	[super cancelTrackingWithEvent:event];
}

- (void)updateDotImages
{
    NSUInteger index = 0;
	
	for ( UIView * subView in self.subviews )
	{
		if ( IOS6_OR_EARLIER )
		{
			if ( NO == [subView isKindOfClass:[UIImageView class]] )
			{
				continue;
			}
		}

		if ( self.currentPage == index )
		{
			if ( self.dotImageHilite )
			{
				subView.backgroundColor = [UIColor clearColor];
				subView.layer.backgroundColor = [UIColor clearColor].CGColor;
				subView.layer.contents = (id)self.dotImageHilite.CGImage;
			}
			else
			{
				subView.layer.borderColor = [UIColor blackColor].CGColor;
				subView.layer.cornerRadius = subView.frame.size.height / 2.0f;
				subView.layer.masksToBounds = YES;
			}
		}
		else if ( (index + 1) >= self.numberOfPages )
		{
			if ( self.dotImageLast )
			{
				subView.backgroundColor = [UIColor clearColor];
				subView.layer.backgroundColor = [UIColor clearColor].CGColor;
				subView.layer.contents = (id)self.dotImageLast.CGImage;
			}
            else if ( self.dotImageNormal )
			{
				subView.backgroundColor = [UIColor clearColor];
				subView.layer.backgroundColor = [UIColor clearColor].CGColor;
				subView.layer.contents = (id)self.dotImageNormal.CGImage;
			}
			else
			{
				subView.layer.borderColor = [UIColor blackColor].CGColor;
				subView.layer.cornerRadius = subView.frame.size.height / 2.0f;
				subView.layer.masksToBounds = YES;
			}
		}
		else
		{
			if ( self.dotImageNormal )
			{
				subView.backgroundColor = [UIColor clearColor];
				subView.layer.backgroundColor = [UIColor clearColor].CGColor;
				subView.layer.contents = (id)self.dotImageNormal.CGImage;
			}
			else
			{
				subView.layer.borderColor = [UIColor blackColor].CGColor;
				subView.layer.cornerRadius = subView.frame.size.height / 2.0f;
				subView.layer.masksToBounds = YES;
			}
		}
		
		if ( NO == CGSizeEqualToSize( self.dotSize, CGSizeZero ) )
		{
			CGRect imageFrame = subView.frame;
			imageFrame.size.width = self.dotSize.width;
			imageFrame.size.height = self.dotSize.height;
			imageFrame.origin.x = subView.center.x - imageFrame.size.width / 2.0f;
			imageFrame.origin.y = subView.center.y - imageFrame.size.height / 2.0f;
			subView.frame = imageFrame;
		}
		
		index += 1;
	}

	[self setNeedsDisplay];
}

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
	
    [self updateDotImages];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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
//  Bee_UIView.m
//

#import "Bee_UIView.h"
#import "Bee_UISignal.h"
#import "Bee_UIImageView.h"
#import "Bee_UILabel.h"

#pragma mark -

@interface BeeTintView : UIView
{
	BeeUILabel * _label;
}

@property (nonatomic, readonly) BeeUILabel * label;

@end

#pragma mark -

@implementation BeeTintView

@synthesize label = _label;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.alpha = 0.6f;
		self.backgroundColor = [UIColor grayColor];
		self.userInteractionEnabled = NO;
		
		_label = [[BeeUILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
		_label.textColor = [UIColor whiteColor];
		_label.textAlignment = UITextAlignmentCenter;
		_label.font = [UIFont boldSystemFontOfSize:20.0f];
		_label.lineBreakMode = UILineBreakModeClip;
		_label.numberOfLines = 1;
		[self addSubview:_label];
	}
	return self;
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	_label.frame = CGRectMake( 0.0f, 0.0f, frame.size.width, frame.size.height );
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );
		
		CGContextSetStrokeColorWithColor( context, [UIColor colorWithWhite:0.3f alpha:1.0f].CGColor );
		CGContextMoveToPoint( context, 0.0f, 0.0f );
		CGContextAddLineToPoint( context, self.bounds.size.width, self.bounds.size.height );
		CGContextStrokePath( context );

		CGContextSetStrokeColorWithColor( context, [UIColor colorWithWhite:0.3f alpha:1.0f].CGColor );
		CGContextMoveToPoint( context, 0.0f, self.bounds.size.height );
		CGContextAddLineToPoint( context, self.bounds.size.width, 0.0f );
		CGContextStrokePath( context );
		
		CGContextRestoreGState( context );
	}
}

- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _label );

	[super dealloc];
}

@end

#pragma mark -

@implementation UIView(Tint)

- (BeeTintView *)__tintView
{
	BeeTintView * result = nil;
	
	for ( UIView * subView in self.subviews )
	{
		if ( [subView isKindOfClass:[BeeTintView class]] )
		{
			result = (BeeTintView *)subView;
			break;
		}
	}

	return result;
}

- (void)setTintTitle:(NSString *)title
{
	if ( title )
	{
		BeeTintView * tintView = [self __tintView];
		if ( nil == tintView )
		{
			tintView = [[[BeeTintView alloc] initWithFrame:self.bounds] autorelease];
			[self addSubview:tintView];
			[self sendSubviewToBack:tintView];
		}

		tintView.label.text = title;
		tintView.frame = self.bounds;
		[tintView setNeedsDisplay];
	}
	else
	{
		BeeTintView * tintView = [self __tintView];
		if ( tintView )
		{
			[tintView removeFromSuperview];
		}
	}
	
	[self fitTintFrame];
}

- (void)fitTintFrame
{
	BeeTintView * tintView = [self __tintView];
	if ( tintView )
	{
		tintView.frame = self.bounds;
	}
}

@end

#pragma mark -

@interface BeeBackgroundImageView : BeeUIImageView
@end

#pragma mark -

@implementation BeeBackgroundImageView
@end

#pragma mark -

@implementation UIView(Background)

@dynamic backgroundImageView;

- (BeeUIImageView *)backgroundImageView
{
	return [self __backgroundImageView];
}

- (BeeBackgroundImageView *)__backgroundImageView
{
	BeeBackgroundImageView * result = nil;
	
	for ( UIView * subView in self.subviews )
	{
		if ( [subView isKindOfClass:[BeeBackgroundImageView class]] )
		{
			result = (BeeBackgroundImageView *)subView;
			break;
		}
	}

	return result;
}

- (void)setBackgroundImage:(UIImage *)image
{
	if ( image )
	{
		BeeBackgroundImageView * imageView = [self __backgroundImageView];
		if ( nil == imageView )
		{
			imageView = [[[BeeBackgroundImageView alloc] initWithFrame:self.bounds] autorelease];
			[self addSubview:imageView];
			[self sendSubviewToBack:imageView];
		}

		imageView.image = image;
		imageView.frame = self.bounds;
		[imageView setNeedsDisplay];
	}
	else
	{
		BeeBackgroundImageView * imageView = [self __backgroundImageView];
		if ( imageView )
		{
			[imageView removeFromSuperview];
		}
	}
}

- (void)fitBackgroundFrame
{
	BeeBackgroundImageView * imageView = [self __backgroundImageView];
	if ( imageView )
	{
		imageView.frame = self.bounds;
	}
}

@end

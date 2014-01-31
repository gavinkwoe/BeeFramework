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

#import "UIView+Wireframe.h"
#import "UIView+Tag.h"

#pragma mark -

@implementation UIWireframeView

- (void)initSelf
{
	self.autoresizesSubviews = YES;
	self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	
	self.alpha = 0.6f;
	self.backgroundColor = [UIColor darkGrayColor];
	self.userInteractionEnabled = NO;

	self.textColor = [UIColor whiteColor];
	self.textAlignment = UITextAlignmentCenter;
	self.font = [UIFont boldSystemFontOfSize:12.0f];
	self.lineBreakMode = UILineBreakModeClip;
	self.numberOfLines = 1;
}

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

- (void)dealloc
{
	[super dealloc];
}

#pragma mark -

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );

		NSUInteger level = self.superview.inheritanceLevel;
		if ( 0 == level )
		{
			CGContextSetLineWidth( context, 2 );
			CGContextSetStrokeColorWithColor( context, [[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor );
			CGContextStrokeRect( context, rect );

			CGContextSetLineWidth( context, 2 );
			CGContextSetStrokeColorWithColor( context, [[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor );
			CGContextMoveToPoint( context, 1.0f, 1.0f );
			CGContextAddLineToPoint( context, self.bounds.size.width - 1.0f, self.bounds.size.height - 1.0f );
			CGContextStrokePath( context );
			
			CGContextSetLineWidth( context, 2 );
			CGContextSetStrokeColorWithColor( context, [[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor );
			CGContextMoveToPoint( context, 1.0f, self.bounds.size.height - 1.0f );
			CGContextAddLineToPoint( context, self.bounds.size.width - 1.0f, 1.0f );
			CGContextStrokePath( context );
		}
		else
		{
			
		}
		
		CGContextRestoreGState( context );
	}
	
	[super drawRect:rect];
}

@end

#pragma mark -

@interface UIView(WireframePrivate)
- (BOOL)hasHintLabel;
@end

#pragma mark -

@implementation UIView(Wireframe)

@dynamic hintString;
@dynamic hintColor;
@dynamic hintLabel;
@dynamic hintEnabled;

- (BOOL)hasHintLabel
{
	for ( UIView * subView in self.subviews )
	{
		if ( [subView isKindOfClass:[__BeeHintLabel class]] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (NSString *)hintString
{
	return self.hintLabel.text;
}

- (void)setHintString:(NSString *)string
{
	self.hintLabel.text = string;
}

- (UIColor *)hintColor
{
	return self.hintLabel.backgroundColor;
}

- (void)setHintColor:(UIColor *)color
{
	self.hintLabel.backgroundColor = color;
}

- (UILabel *)hintLabel
{
	UILabel * hintLabel = nil;
	
	for ( UIView * subView in self.subviews )
	{
		if ( [subView isKindOfClass:[__BeeHintLabel class]] )
		{
			hintLabel = (UILabel *)subView;
			break;
		}
	}
	
	if ( nil == hintLabel )
	{
		hintLabel = [[[__BeeHintLabel alloc] initWithFrame:self.bounds] autorelease];
		[self addSubview:hintLabel];
		[self sendSubviewToBack:hintLabel];
	}
	
	hintLabel.frame = self.bounds;
	[hintLabel setNeedsDisplay];
	
	return hintLabel;
}

- (BOOL)hintEnabled
{
	if ( NO == [self hasHintLabel] )
	{
		return NO;
	}

	return self.hintLabel.hidden ? NO : YES;
}

- (void)setHintEnabled:(BOOL)flag
{
	if ( NO == [self hasHintLabel] )
		return;

	self.hintLabel.hidden = flag ? NO : YES;
}

- (void)hintAllSubviews
{
	for ( UIView * view in [[self.subviews copy] autorelease] )
	{
		view.hintString = view.tagString;
		view.hintEnabled = YES;
	}
}

- (void)unhintAllSubviews
{
	for ( UIView * view in [[self.subviews copy] autorelease] )
	{
		view.hintEnabled = NO;
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

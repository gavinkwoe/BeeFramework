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

#import "ServiceWireframeView.h"
#import "NSObject+UIWireframe.h"
#import "UIView+UIWireframe.h"

#pragma mark -

@implementation ServiceWireframeView

@synthesize container = _container;

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		
		self.alpha = 1.0f;
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		
		self.lineBreakMode = UILineBreakModeClip;
		self.adjustsFontSizeToFitWidth = YES;
		self.minimumFontSize = 10.0f;
		self.numberOfLines = 1;
		self.textColor = [UIColor whiteColor];
		self.textAlignment = UITextAlignmentCenter;
		self.font = [UIFont systemFontOfSize:13.0f];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

+ (void)showInContainer:(UIView *)container
{
//	if ( [UIApplication sharedApplication].keyWindow != container.window )
//		return;
	
	ServiceWireframeView * placeholder = nil;
	
	for ( UIView * subview in container.subviews )
	{
		if ( [subview isKindOfClass:[ServiceWireframeView class]] )
		{
			placeholder = (ServiceWireframeView *)subview;
			break;
		}
	}

	if ( nil == placeholder )
	{
		placeholder = [[[ServiceWireframeView alloc] init] autorelease];
		placeholder.container = container;
		[container addSubview:placeholder];
	}

//	[container bringSubviewToFront:placeholder];
	[container sendSubviewToBack:placeholder];

	[placeholder setHidden:NO];
	[placeholder setFrame:CGRectMake( 0.0f, 0.0f, container.frame.size.width, container.frame.size.height )];
		
//	[placeholder setNeedsDisplay];
}

+ (void)hideInContainer:(id)container
{
	// TODO:
}

- (void)drawRect:(CGRect)rect
{
	if ( nil == self.container )
		return;
	
	if ( [UIApplication sharedApplication].keyWindow != self.container.window )
		return;
	
	BOOL skipped = NO;

	UIView * that = self.container.superview;
	UIView * this = self.container;
	
	if ( that && this )
	{
		CGRect thatFrame = [that convertRect:that.bounds toView:that];
		CGRect thisFrame = [this convertRect:this.bounds toView:this];
		CGFloat edgeBound = 1;
		
		UIEdgeInsets distance;
		distance.left = fabsf( CGRectGetMinX(thisFrame) - CGRectGetMinX(thatFrame) );
		distance.right = fabsf( CGRectGetMaxX(thisFrame) - CGRectGetMaxX(thatFrame) );
		distance.top = fabsf( CGRectGetMinY(thisFrame) - CGRectGetMinY(thatFrame) );
		distance.bottom = fabsf( CGRectGetMaxY(thisFrame) - CGRectGetMaxY(thatFrame) );
		
		if ( distance.left < edgeBound && distance.right < edgeBound && distance.top < edgeBound && distance.bottom < edgeBound )
		{
			skipped = YES;
		}
	}
	
	if ( NO == skipped )
	{
//		if ( self.container.frame.size.width < 44.0f /*|| self.container.frame.size.height < 44.0f*/ )
//		{
//			[self setText:@""];
//		}
//		else
		{
			if ( self.container.tagString )
			{
				[self setText:[NSString stringWithFormat:@"#%@", self.container.tagString]];
			}
			else
			{
				[self setText:@""];
			}
		}
		
		[self.container renderWireframe:rect];
	}
	else
	{
		[self setText:@""];

		[self.container renderBackground:rect];
		[self.container renderBorder2:rect];
	}
	
	[super drawRect:rect];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

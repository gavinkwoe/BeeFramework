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

#import "UIView+UIWireframe.h"
#import "NSObject+UIWireframe.h"
#import "UIColor+BeeExtension.h"

#pragma mark -

@implementation UIView(UIWireframe)

- (void)renderBackground:(CGRect)rect
{
	UIColor *	bgColor = RGBA( 49, 99, 162, 1.0 );

	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );

		CGContextSetFillColorWithColor( context, bgColor.CGColor );
		CGContextFillRect( context, rect );

		CGContextRestoreGState( context );
	}
}

- (void)renderGrayColor:(CGRect)rect
{
//	UIColor *	bgColor = RGBA( 126, 181, 217, 1.0 );
	UIColor *	bgColor = RGBA( 212, 224, 236, 1.0 );
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );
		
		CGContextSetFillColorWithColor( context, bgColor.CGColor );
		CGContextFillRect( context, rect );
		
		CGContextRestoreGState( context );
	}
}

- (void)renderBlueColor:(CGRect)rect
{
	UIColor *	bgColor = RGBA( 95, 154, 196, 1.0 );
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );
		
		CGContextSetFillColorWithColor( context, bgColor.CGColor );
		CGContextFillRect( context, rect );
		
		CGContextRestoreGState( context );
	}
}

- (void)renderRedColor:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );
		
		CGContextSetFillColorWithColor( context, [UIColor redColor].CGColor );
		CGContextFillRect( context, rect );
		
		CGContextRestoreGState( context );
	}
}

- (void)renderGrids:(CGRect)rect
{
	CGFloat		step = 10.0f;
	UIColor *	lineColor = RGBA( 80, 122, 175, 1.0 );

	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );
		
		for ( int i = 0; i * step < rect.size.width; i += 1 )
		{
			CGContextSetLineWidth( context, 1 );
			CGContextSetStrokeColorWithColor( context, lineColor.CGColor );

			CGContextMoveToPoint( context, i * step, 0.0f );
			CGContextAddLineToPoint( context, i * step, rect.size.height );
			CGContextStrokePath( context );
		}
		
		for ( int j = 0; j * step < rect.size.height; j += 1 )
		{
			CGContextSetLineWidth( context, 1 );
			CGContextSetStrokeColorWithColor( context, lineColor.CGColor );

			CGContextMoveToPoint( context, 0.0f, j * step );
			CGContextAddLineToPoint( context, rect.size.width, j * step );
			CGContextStrokePath( context );
		}
		
		CGContextRestoreGState( context );
	}
}

- (void)renderCross:(CGRect)rect
{
//	UIColor *	lineColor = RGBA( 110, 150, 192, 1.0 );
	UIColor *	lineColor = RGBA( 215, 228, 238, 0.6 );
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );

		CGContextSetLineWidth( context, 1 );
		CGContextSetStrokeColorWithColor( context, lineColor.CGColor );
		CGContextMoveToPoint( context, 0.0f, 0.0f );
		CGContextAddLineToPoint( context, self.bounds.size.width, self.bounds.size.height );
		CGContextStrokePath( context );

		CGContextSetLineWidth( context, 1 );
		CGContextSetStrokeColorWithColor( context, lineColor.CGColor );
		CGContextMoveToPoint( context, 0.0f, self.bounds.size.height );
		CGContextAddLineToPoint( context, self.bounds.size.width, 0.0f );
		CGContextStrokePath( context );

		CGContextRestoreGState( context );
	}
}

- (void)renderBorder:(CGRect)rect
{
	UIColor *	lineColor = RGBA( 215, 228, 238, 1.0 );
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );
		
		CGContextSetLineWidth( context, 2 );
		CGContextSetStrokeColorWithColor( context, lineColor.CGColor );
		CGContextStrokeRect( context, rect );
		
		CGContextRestoreGState( context );
	}
}

- (void)renderBorder2:(CGRect)rect
{
	UIColor *	lineColor = RGBA( 215, 228, 238, 0.6 );
//	UIColor *	lineColor = [UIColor whiteColor];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );
		
		CGContextSetLineWidth( context, 2 );
		CGContextSetStrokeColorWithColor( context, lineColor.CGColor );
		CGContextStrokeRect( context, rect );
		
		CGContextRestoreGState( context );
	}
}

- (void)renderCircle:(CGRect)rect
{
	UIColor *	lineColor = RGBA( 215, 228, 238, 1.0 );
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );
		
		CGContextSetLineWidth( context, 2 );
		CGContextSetStrokeColorWithColor( context, lineColor.CGColor );
		
		CGRect ellipse;
		ellipse.size.width = fminf( rect.size.width, rect.size.height );
		ellipse.size.height = ellipse.size.width;
		ellipse.origin.x = (rect.size.width - ellipse.size.width) / 2.0f;
		ellipse.origin.y = (rect.size.height - ellipse.size.height) / 2.0f;
		ellipse = CGRectInset( ellipse, 2, 2 );
		
		CGContextAddEllipseInRect( context, ellipse );
		CGContextStrokePath( context );
				
		CGContextRestoreGState( context );
	}
}

//[INFO]  renderWireframe: BeeUIScrollView
//[INFO]  renderWireframe: BeeUIBoardView
//[INFO]  renderWireframe: UIViewControllerWrapperView
//[INFO]  renderWireframe: UILayoutContainerView
//[INFO]  renderWireframe: UIStatusBarTimeItemView
//[INFO]  renderWireframe: UIStatusBarBatteryItemView
//[INFO]  renderWireframe: UIStatusBarDataNetworkItemView
//[INFO]  renderWireframe: UIStatusBarServiceItemView
//[INFO]  renderWireframe: UIStatusBarForegroundView
//[INFO]  renderWireframe: UIStatusBarBackgroundView

- (void)renderWireframe:(CGRect)rect
{
	if ( [self isKindOfClass:NSClassFromString(@"UINavigationItemView")] )
	{
//		[self renderBackground:rect];
//		[self renderRedColor:rect];
//		[self renderBorder:rect];
	}
	else if ( [self isKindOfClass:NSClassFromString(@"UIViewControllerWrapperView")] )
	{
//		[self renderBackground:rect];
//		[self renderGrids:rect];
//		[self renderCross:rect];
//		[self renderBorder:rect];
	}
	else if ( [self isKindOfClass:NSClassFromString(@"UILayoutContainerView")] )
	{
//		[self renderBackground:rect];
//		[self renderGrids:rect];
//		[self renderCross:rect];
//		[self renderBorder:rect];
	}
	else if ( [self isKindOfClass:NSClassFromString(@"UIStatusBarBackgroundView")] )
	{
		[self renderBackground:rect];
//		[self renderBlueColor:rect];
		[self renderCross:rect];
		[self renderBorder:rect];
	}
	else if ( [self isKindOfClass:NSClassFromString(@"UIStatusBarForegroundView")] )
	{
		[self renderBackground:rect];
//		[self renderBlueColor:rect];
		[self renderCross:rect];
		[self renderBorder:rect];
	}
	else if ( [self isKindOfClass:NSClassFromString(@"UIStatusBarActivityItemView")] )
	{
//		[self renderBackground:rect];
//		[self renderBlueColor:rect];
//		[self renderGrids:rect];
//		[self renderCross:rect];
		[self renderCircle:rect];
//		[self renderBorder:rect];
	}
	else if ( [self isKindOfClass:NSClassFromString(@"UIStatusBarTimeItemView")] )
	{
//		[self renderBorder:rect];
	}
	else if ( [self isKindOfClass:NSClassFromString(@"UIStatusBarBatteryItemView")] )
	{
//		[self renderBorder:rect];
	}
	else if ( [self isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")] )
	{
//		[self renderBorder:rect];
	}
	else if ( [self isKindOfClass:NSClassFromString(@"UIStatusBarServiceItemView")] )
	{
//		[self renderBorder:rect];
	}
	else if ( [self isKindOfClass:NSClassFromString(@"BeeUIBoardView")] )
	{
		[self renderBackground:rect];
		[self renderGrids:rect];
//		[self renderCross:rect];
		[self renderBorder:rect];
	}
	else if ( [self isKindOfClass:NSClassFromString(@"BeeUICell")] )
	{
		[self renderBackground:rect];
		[self renderGrids:rect];
//		[self renderCross:rect];
		[self renderBorder:rect];
	}
	else
	{
		INFO( @"renderWireframe: %@", [[self class] description] );

		[self renderBackground:rect];
//		[self renderGrids:rect];
//		[self renderCross:rect];
//		[self renderBorder2:rect];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

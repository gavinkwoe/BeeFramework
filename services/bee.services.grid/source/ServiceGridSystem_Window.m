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

#import "ServiceGridSystem_Window.h"
#import "ServiceGridSystem.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@implementation ServiceGridSystem_Window

DEF_SINGLETON( ServiceGridSystem_Window )

- (void)load
{
	CGRect windowFrame = self.frame;
	
	if ( NO == [UIApplication sharedApplication].statusBarHidden )
	{
		if ( UIInterfaceOrientationIsLandscape( [UIApplication sharedApplication].statusBarOrientation ) )
		{
			windowFrame.origin.x += [UIApplication sharedApplication].statusBarFrame.size.width;
			windowFrame.size.width -= [UIApplication sharedApplication].statusBarFrame.size.width;
		}
		else
		{
			windowFrame.origin.y += [UIApplication sharedApplication].statusBarFrame.size.height;
			windowFrame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
		}
	}
	
	self.frame = windowFrame;

	self.hidden = YES;
	self.windowLevel = UIWindowLevelStatusBar + 3.0f;
	self.userInteractionEnabled = NO;
	self.backgroundColor = [UIColor clearColor];
}

- (void)unload
{
}

- (void)drawRect:(CGRect)rect
{
	rect = CGRectMake( 0, 0, self.width, self.height );
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );
		CGContextClearRect( context, rect );

		[[[UIColor blackColor] colorWithAlphaComponent:0.4f] set];
		CGContextFillRect( context, rect );
		
		CGFloat step = 16.0f;
		int		group = 5;

		for ( int i = 0; i * step < rect.size.width; i += 1 )
		{
			if ( 0 == (i % group) )
			{
				CGContextSetLineWidth( context, 2 );
				CGContextSetStrokeColorWithColor( context, [[UIColor cyanColor] colorWithAlphaComponent:0.8f].CGColor );
			}
			else
			{
				CGContextSetLineWidth( context, 1 );
				CGContextSetStrokeColorWithColor( context, [[UIColor cyanColor] colorWithAlphaComponent:0.6f].CGColor );
			}
			
			CGContextMoveToPoint( context, i * step, 0.0f );
			CGContextAddLineToPoint( context, i * step, rect.size.height );
			CGContextStrokePath( context );

			if ( 0 == (i % group) )
			{
				[[UIColor whiteColor] set];

				NSString * text = [NSString stringWithFormat:@"%.0f", i * step];
				[text drawAtPoint:CGPointMake( i * step + 3.0f, 1.0f )
						 withFont:[UIFont boldSystemFontOfSize:10.0f]];
			}
		}

		for ( int j = 0; j * step < rect.size.height; j += 1 )
		{
			if ( 0 == (j % group) )
			{
				CGContextSetLineWidth( context, 2 );
				CGContextSetStrokeColorWithColor( context, [[UIColor cyanColor] colorWithAlphaComponent:0.8f].CGColor );
			}
			else
			{
				CGContextSetLineWidth( context, 1 );
				CGContextSetStrokeColorWithColor( context, [[UIColor cyanColor] colorWithAlphaComponent:0.6f].CGColor );
			}
			
			CGContextMoveToPoint( context, 0.0f, j * step );
			CGContextAddLineToPoint( context, rect.size.width, j * step );
			CGContextStrokePath( context );
			
			if ( 0 == (j % group) )
			{
				[[UIColor whiteColor] set];
				
				NSString * text = [NSString stringWithFormat:@"%.0f", j * step];
				[text drawAtPoint:CGPointMake( 3.0f, j * step + 1.0f )
						 withFont:[UIFont boldSystemFontOfSize:10.0f]];
			}
		}

		CGContextRestoreGState( context );
	}	
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

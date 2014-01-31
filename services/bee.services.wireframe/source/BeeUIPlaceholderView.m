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

#import "BeeUIPlaceholderView.h"
#import "NSObject+UIWireframe.h"

#pragma mark -

@implementation NSObject(UIWireframe)

- (void)renderWireframe:(CGRect)rect
{
	// TODO:
}

@end

#pragma mark -

@implementation BeeUIPlaceholderView

@synthesize container = _container;

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		
		self.alpha = 0.6f;
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

+ (void)showInContainer:(UIView *)container
{
	if ( [UIApplication sharedApplication].keyWindow != container.window )
		return;
	
	BeeUIPlaceholderView * placeholder = nil;
	
	for ( UIView * subview in container.subviews )
	{
		if ( [subview isKindOfClass:[BeeUIPlaceholderView class]] )
		{
			placeholder = (BeeUIPlaceholderView *)subview;
			break;
		}
	}

	if ( nil == placeholder )
	{
		placeholder = [[[BeeUIPlaceholderView alloc] init] autorelease];
		placeholder.container = container;
		[container addSubview:placeholder];
	}
	
	[container sendSubviewToBack:placeholder];
//	[container bringSubviewToFront:placeholder];

	[placeholder setHidden:NO];
	[placeholder setFrame:CGRectMake( 0.0f, 0.0f, container.frame.size.width, container.frame.size.height )];
	[placeholder setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	UIColor *	bgColor = RGBA( 49, 99, 162, 0.6 );
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );

		CGContextSetFillColorWithColor( context, bgColor.CGColor );
		CGContextFillRect( context, rect );

		if ( self.container )
		{
			[self.container renderWireframe:rect];
		}
		
		CGContextRestoreGState( context );
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

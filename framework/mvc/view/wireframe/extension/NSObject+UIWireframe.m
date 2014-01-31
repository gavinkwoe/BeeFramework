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

#import "BeeUIWireframe.h"

#pragma mark -

@interface __UIPlaceholderView : UIView

@property (nonatomic, assign) UIView * container;

+ (void)showInContainer:(id)container;

@end

#pragma mark -

@implementation __UIPlaceholderView

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
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

+ (void)showInContainer:(UIView *)container
{
	__UIPlaceholderView * placeholder = nil;
	
	for ( UIView * subview in container.subviews )
	{
		if ( [subview isKindOfClass:[__UIPlaceholderView class]] )
		{
			placeholder = (__UIPlaceholderView *)subview;
			break;
		}
	}

	if ( nil == placeholder )
	{
		placeholder = [[[__UIPlaceholderView alloc] init] autorelease];
		placeholder.alpha = 0.6f;
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
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextSaveGState( context );

		CGContextSetFillColorWithColor( context, [UIColor darkGrayColor].CGColor );
		CGContextFillRect( context, rect );

		if ( self.container )
		{
			[self.container renderWireframe:rect];
		}
		
		CGContextRestoreGState( context );
	}
}

@end

#pragma mark -

DEF_PACKAGE( BeePackage_UI, BeeUIWireframe, wireframe );

#pragma mark -

@interface NSObject(UIWireframePrivate)

+ (void)__hookDrawRect;
+ (void)__unhookDrawRect;

@end

#pragma mark -

@implementation NSObject(UIWireframe)

static BOOL __swizzled = NO;
static void (*__willMoveToSuperview)( id, SEL, UIView * );

+ (void)__hookInstanceMethod
{
	if ( NO == __swizzled )
	{
		Method method;
		IMP implement;
		
		method = class_getInstanceMethod( [UIView class], @selector(willMoveToSuperview:) );
		__willMoveToSuperview = (void *)method_getImplementation( method );
		
		implement = class_getMethodImplementation( [UIView class], @selector(myWillMoveToSuperview:) );
		method_setImplementation( method, implement );

		__swizzled = YES;
	}
}

+ (void)__unhookInstanceMethod
{
	if ( __swizzled )
	{
		// TODO:
		
		__swizzled = NO;
	}
}

- (void)myWillMoveToSuperview:(UIView *)view
{
	if ( NO == [self isKindOfClass:[__UIPlaceholderView class]] )
	{
		[__UIPlaceholderView showInContainer:self];
	}
	
	if ( __willMoveToSuperview )
	{
		__willMoveToSuperview( self, _cmd, view );
	}
}

- (void)renderWireframe:(CGRect)rect
{
	// TODO:
}

@end

#pragma mark -

@implementation BeeUIWireframe

DEF_SINGLETON( BeeUIWireframe )

@synthesize enabled = _enabled;

- (void)setEnabled:(BOOL)flag
{
	_enabled = flag;
	
	if ( flag )
	{
		[self enable];
	}
	else
	{
		[self disable];
	}
}

- (void)enable
{
	[UIView __hookInstanceMethod];
}

- (void)disable
{
	[UIView __unhookInstanceMethod];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "Bee_UINavigationBar.h"
#import "Bee_UISignalBus.h"

#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

@interface BeeUINavigationBar()
{
	BOOL						_inited;
	UILabel *					_titleLabel;
	UIImage *					_backgroundImage;
	UINavigationController *	_navigationController;
}

- (void)initSelf;
- (void)applyBarStyle;

@end

#pragma mark -

@implementation BeeUINavigationBar

DEF_NOTIFICATION( STYLE_CHANGED )

DEF_INT( LEFT,	0 )
DEF_INT( RIGHT,	1 )

DEF_SIGNAL( LEFT_TOUCHED )
DEF_SIGNAL( RIGHT_TOUCHED )

@dynamic backgroundImage;
@synthesize navigationController = _navigationController;

static UIColor *	__titleColor = nil;
static CGSize		__buttonSize = { 0 };
static UIColor *	__backgroundTintColor = nil;
static UIColor *	__backgroundColor = nil;
static UIImage *	__backgroundImage = nil;

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
		[self observeNotification:self.STYLE_CHANGED];
		[self applyBarStyle];
		
		_inited = YES;
		
//		[self load];
		[self performLoad];
	}
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	[self unobserveAllNotifications];
	
    [_backgroundImage release];
	_backgroundImage = nil;
	
	[_titleLabel removeFromSuperview];
	[_titleLabel release];
	_titleLabel = nil;
	
    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];

	[self applyBarStyle];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
	
	[self applyBarStyle];
}

- (void)applyBarStyle
{
	if ( __backgroundColor )
	{
		[self setBackgroundColor:__backgroundColor];
	}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
	if ( IOS7_OR_LATER )
	{
		if ( __backgroundTintColor )
		{
			[self setTintColor:__backgroundTintColor];
			[self setBarTintColor:__backgroundTintColor];
		}
	}
#endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

	if ( IOS6_OR_LATER )
	{
		if ( __titleColor )
		{
			NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:__titleColor, NSForegroundColorAttributeName, nil];
			[self setTitleTextAttributes:attrs];
		}
		else
		{
			NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil];
			[self setTitleTextAttributes:attrs];
		}
	}

	if ( IOS5_OR_LATER )
	{
		if ( IOS7_OR_LATER )
		{
		#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
			[self setBackgroundImage:(_backgroundImage ? _backgroundImage : __backgroundImage) forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
		#endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
		}
		else
		{
		#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
			[self setBackgroundImage:(_backgroundImage ? _backgroundImage : __backgroundImage) forBarMetrics:UIBarMetricsDefault];
		#endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
		}
	}
	
//	self.layer.shadowOpacity = 0.7f;
//	self.layer.shadowRadius = 1.5f;
//	self.layer.shadowOffset = CGSizeMake(0.0f, 0.6f);
//	self.layer.shadowColor = [UIColor blackColor].CGColor;
//	self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
//	self.layer.shouldRasterize = YES;

//	CAShapeLayer * maskLayer = nil;
//
//	for ( CALayer * layer in self.layer.sublayers )
//	{
//		if ( [layer isKindOfClass:[CAShapeLayer class]] && [layer.name isEqualToString:@"maskLayer"] )
//		{
//			maskLayer = (CAShapeLayer *)layer;
//			break;
//		}
//	}
//
//	if ( nil == maskLayer )
//	{
//		maskLayer = [CAShapeLayer layer];
//		[self.layer addSublayer:maskLayer];
//		[self.layer setMask:maskLayer];
//	}
//
//	CGRect bounds = self.bounds;
//	UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
//													byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
//														  cornerRadii:CGSizeMake(4.0, 4.0)];
//	if ( maskPath && maskLayer )
//	{
//		maskLayer.frame = bounds;
//		maskLayer.path = maskPath.CGPath;
//		maskLayer.name = @"maskLayer";
//	}

	[self setNeedsDisplay];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( _navigationController )
	{
		UIViewController * vc = _navigationController.topViewController;
		if ( vc )
		{
			[signal forward:vc];
		}
	}
	else
	{
		SIGNAL_FORWARD( signal );
	}
}

- (void)handleNotification:(NSNotification *)notification
{
	if ( [notification is:BeeUINavigationBar.STYLE_CHANGED] )
	{
		[self applyBarStyle];
	}
}

- (void)setBackgroundImage:(UIImage *)image
{
	if ( image != _backgroundImage )
	{
		[_backgroundImage release];
		_backgroundImage = [image retain];

		[self applyBarStyle];
	}
}

#pragma mark -

+ (CGSize)buttonSize
{
	return __buttonSize;
}

+ (void)setTitleColor:(UIColor *)color
{
	if ( color != __titleColor )
	{
		[__titleColor release];
		__titleColor = [color retain];

		[[NSNotificationCenter defaultCenter] postNotificationName:self.STYLE_CHANGED object:nil];
	}
}

+ (void)setButtonSize:(CGSize)size
{
	__buttonSize = size;
}

+ (void)setBackgroundColor:(UIColor *)color
{
	if ( color != __backgroundColor )
	{
		[__backgroundColor release];
		__backgroundColor = [color retain];

		[[NSNotificationCenter defaultCenter] postNotificationName:self.STYLE_CHANGED object:nil];
	}
}

+ (void)setBackgroundTintColor:(UIColor *)color
{
	if ( color != __backgroundTintColor )
	{
		[__backgroundTintColor release];
		__backgroundTintColor = [color retain];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:self.STYLE_CHANGED object:nil];
	}
}

+ (void)setBackgroundImage:(UIImage *)image
{
	if ( image != __backgroundImage )
	{
		[__backgroundImage release];
		__backgroundImage = [image retain];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:self.STYLE_CHANGED object:nil];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#import "ServiceInspector_Window.h"
#import "ServiceInspector.h"

#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

#undef	D2R
#define D2R( __degree ) (M_PI / 180.0f * __degree)

#undef	MAX_DEPTH
#define MAX_DEPTH	(36)

#pragma mark -

@interface ServiceInspector_Layer : BeeUIImageView

@property (nonatomic, assign) CGFloat		depth;
@property (nonatomic, assign) CGRect		rect;
@property (nonatomic, assign) UIView *		view;
@property (nonatomic, retain) BeeUILabel *	label;

@end

#pragma mark -

@implementation ServiceInspector_Layer

@synthesize depth = _depth;
@synthesize rect = _rect;
@synthesize view = _view;
@synthesize label = _label;

- (void)load
{
	self.layer.shouldRasterize = YES;
	
	self.label = [[[BeeUILabel alloc] init] autorelease];
	self.label.hidden = NO;
	self.label.textColor = [UIColor whiteColor];
	self.label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
	self.label.font = [UIFont boldSystemFontOfSize:14.0f];
	self.label.textAlignment = UITextAlignmentCenter;
	[self addSubview:self.label];
}

- (void)unload
{
	[self.label removeFromSuperview];
	self.label = nil;
}

- (void)setFrame:(CGRect)f
{
	[super setFrame:f];
	
	CGRect labelFrame;
	labelFrame.size.width = fminf( 200.0f, f.size.width );
	labelFrame.size.height = fminf( 16.0f, f.size.height );
	labelFrame.origin.x = 0;
	labelFrame.origin.y = 0;

	self.label.frame = labelFrame;
}

@end

#pragma mark -

@interface ServiceInspector_Window()
{
	float				_rotateX;
    float				_rotateY;
    float				_distance;
	BOOL				_animating;
	
	CGPoint				_panOffset;
	CGFloat				_pinchOffset;
	
	BeeUIButton *		_showLabel;
	BeeUIButton *		_showBorder;
}

- (void)hide;
- (void)show;

- (void)buildLayers;
- (void)removeLayers;
- (void)transformLayers:(BOOL)flag;

@end

#pragma mark -

@implementation ServiceInspector_Window

DEF_SINGLETON( ServiceInspector_Window )

- (void)load
{
	self.backgroundColor = [UIColor blackColor];
	self.hidden = YES;
	self.windowLevel = UIWindowLevelStatusBar + 1.0f;

	self.pannable = YES;
	self.pinchable = YES;
}

- (void)unload
{
	[self removeLayers];

	self.pannable = NO;
	self.pinchable = NO;
}

- (void)buildSublayersFor:(UIView *)view depth:(CGFloat)depth origin:(CGPoint)origin
{
	if ( depth >= MAX_DEPTH )
		return;
	
	if ( view.hidden )
		return;

	CGRect screenBound = [UIScreen mainScreen].bounds;
	CGRect viewFrame = view.frame;
	
	if ( CGSizeEqualToSize( viewFrame.size, CGSizeZero ) )
		return;

	viewFrame.origin.x = origin.x + view.center.x - view.bounds.size.width / 2.0f;
	viewFrame.origin.y = origin.y + view.center.y - view.bounds.size.height / 2.0f;
	viewFrame.size.width = view.bounds.size.width;
	viewFrame.size.height = view.bounds.size.height;

//	if ( CGRectGetMaxX(viewFrame) < 0.0f || CGRectGetMinX(viewFrame) > screenBound.size.width )
//		return;
//
//	if ( CGRectGetMaxY(viewFrame) < 0.0f || CGRectGetMinY(viewFrame) > screenBound.size.height )
//		return;

//	INFO( @"view = %@", [[view class] description] );
	
	ServiceInspector_Layer * layer = [[ServiceInspector_Layer alloc] init];
	if ( layer )
	{
		NSString * classType = [[view class] description];
		if ( [classType isEqualToString:@"UIWindow"] )
		{
			layer.backgroundColor = RGB( 1, 59, 79 ); // [[UIColor redColor] colorWithAlphaComponent:0.25f];
		}
		else if ( [classType isEqualToString:@"UILayoutContainerView"] )
		{
			layer.backgroundColor = RGB( 2, 84, 112 ); // [[UIColor orangeColor] colorWithAlphaComponent:0.25f];
		}
		else if ( [classType isEqualToString:@"UINavigationTransitionView"] )
		{
			layer.backgroundColor = RGB( 4, 106, 141 ); // [[UIColor orangeColor] colorWithAlphaComponent:0.25f];
		}
		else if ( [classType isEqualToString:@"UIViewControllerWrapperView"] )
		{
			layer.backgroundColor = RGB( 6, 141, 187 ); // [[UIColor orangeColor] colorWithAlphaComponent:0.25f];
		}
		else
		{
			layer.backgroundColor = [UIColor blackColor]; // [UIColor yellowColor];
		}

		layer.layer.borderWidth = 4.0f;
		layer.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:(1.0f - depth / (MAX_DEPTH * 1.0f))].CGColor;
		
		CGPoint anchor;
		anchor.x = (screenBound.size.width / 2.0f - viewFrame.origin.x) / viewFrame.size.width;
		anchor.y = (screenBound.size.height / 2.0f - viewFrame.origin.y) / viewFrame.size.height;

		layer.view = view;
		layer.label.text = [[view class] description];
		layer.rect = viewFrame;
		layer.depth = depth;
		layer.frame = viewFrame;
		layer.image = view.screenshotOneLayer;
		layer.layer.anchorPoint = anchor;
		layer.layer.anchorPointZ = (layer.depth * -1.0f) * 75.0f;
		layer.backgroundColor = [layer.backgroundColor colorWithAlphaComponent:0.1f];
		[self addSubview:layer];

		[layer release];
	}

	for ( UIView * subview in view.subviews )
	{
		[self buildSublayersFor:subview depth:(depth + 1) origin:layer.rect.origin];
	}
}

- (void)buildLayers
{
	[self buildSublayersFor:[UIApplication sharedApplication].keyWindow depth:0 origin:CGPointZero];
}

- (void)removeLayers
{
	NSArray * subviewsCopy = [NSArray arrayWithArray:self.subviews];

	for ( UIView * subview in subviewsCopy )
	{
		if ( [subview isKindOfClass:[ServiceInspector_Layer class]] )
		{
			[subview removeFromSuperview];
		}
	}
}

- (void)transformLayers:(BOOL)setFrames
{
    CATransform3D transform2 = CATransform3DIdentity;
    transform2.m34 = -0.001;
	transform2 = CATransform3DTranslate( transform2, _rotateY * -2.5f, 0, 0 );
	transform2 = CATransform3DTranslate( transform2, 0, _rotateX * 3.5f, 0 );

    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeTranslation( 0, 0, _distance * 1000 );
    transform = CATransform3DConcat( CATransform3DMakeRotation(D2R(_rotateX), 1, 0, 0), transform );
    transform = CATransform3DConcat( CATransform3DMakeRotation(D2R(_rotateY), 0, 1, 0), transform );
    transform = CATransform3DConcat( CATransform3DMakeRotation(D2R(0), 0, 0, 1), transform );
    transform = CATransform3DConcat( transform, transform2 );

	NSArray * subviewsCopy = [NSArray arrayWithArray:self.subviews];

	for ( UIView * subview in subviewsCopy )
	{
		if ( [subview isKindOfClass:[ServiceInspector_Layer class]] )
		{
			ServiceInspector_Layer * layer = (ServiceInspector_Layer *)subview;
			layer.frame = layer.rect;
			
			if ( _animating )
			{
				layer.layer.transform = CATransform3DIdentity;
			}
			else
			{
				layer.layer.transform = transform;
			}
			
			[layer setNeedsDisplay];
		}
	}
}

- (void)prepareShow
{
	[self setHidden:NO];

	[self removeLayers];
	[self buildLayers];

	_rotateX = 0.0f;
	_rotateY = 0.0f;
	_distance = 0.0f;
	_animating = YES;
	
//	[self setAlpha:1.0f];
	[self transformLayers:YES];
}

- (void)show
{
	_rotateX = -17.0f;
	_rotateY = -14.0f;
	_distance = -2.0f;
	_animating = NO;

//	[self setAlpha:1.0f];
	[self transformLayers:NO];
}

- (void)prepareHide
{
	_rotateX = 0.0f;
	_rotateY = 0.0f;
	_distance = 0.0f;
	_animating = YES;

//	[self setAlpha:0.0f];
	[self transformLayers:YES];
}

- (void)hide
{
	_animating = NO;

	[self removeLayers];
	
//	[self setAlpha:0.0f];
	[self setHidden:YES];
}

#pragma mark -

ON_PAN_START( signal )
{
	_panOffset.x = _rotateY;
	_panOffset.y = _rotateX * -1.0f;
}

ON_PAN_CHANGED( signal )
{
	_rotateY = _panOffset.x + self.panOffset.x * 0.5f;
	_rotateX = _panOffset.y * -1.0f - self.panOffset.y * 0.5f;

	[self transformLayers:NO];
}

ON_PINCH_START( signal )
{
	_pinchOffset = _distance;
}

ON_PINCH_CHANGED( signal )
{
    _distance = _pinchOffset + (self.pinchScale - 1);
    _distance = (_distance < -5 ? -5 : (_distance > 0.5 ? 0.5 : _distance));

    [self transformLayers:NO];
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

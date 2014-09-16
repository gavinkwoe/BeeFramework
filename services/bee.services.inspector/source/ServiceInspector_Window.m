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

#import "ServiceInspector_Window.h"
#import "ServiceInspector.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
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
//	self.layer.shouldRasterize = YES;
	
	self.label = [[[BeeUILabel alloc] init] autorelease];
	self.label.hidden = NO;
	self.label.textColor = [UIColor yellowColor];
	self.label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
	self.label.font = [UIFont boldSystemFontOfSize:12.0f];
	self.label.adjustsFontSizeToFitWidth = YES;
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
	BOOL				_labelShown;
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
	self.windowLevel = UIWindowLevelStatusBar + 3.0f;
//	self.layer.shouldRasterize = YES;

	self.pannable = YES;
	self.pinchable = YES;
	
	_labelShown = NO;
	
	CGRect buttonFrame;
	buttonFrame.size.width = 100.0f;
	buttonFrame.size.height = 40.0f;
	buttonFrame.origin.x = 10.0f;
	buttonFrame.origin.y = self.frame.size.height - buttonFrame.size.height - 10.0f;
	
	_showLabel = [[BeeUIButton alloc] initWithFrame:buttonFrame];
	_showLabel.hidden = NO;
	_showLabel.titleColor = [UIColor whiteColor];
	_showLabel.titleFont = [UIFont systemFontOfSize:14.0f];
	_showLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
	_showLabel.layer.cornerRadius = 6.0f;
	_showLabel.layer.borderColor = [UIColor grayColor].CGColor;
	_showLabel.layer.borderWidth = 2.0f;
	_showLabel.title = @"Label (OFF)";
	_showLabel.signal = @"showLabel";
	[self addSubview:_showLabel];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _showLabel );

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

	if ( 0 == view.frame.size.width || 0 == view.frame.size.height )
		return;
	
	CGRect screenBound = [UIScreen mainScreen].bounds;
	CGRect viewFrame;
	
	viewFrame.origin.x = origin.x + view.center.x - view.bounds.size.width / 2.0f;
	viewFrame.origin.y = origin.y + view.center.y - view.bounds.size.height / 2.0f;

	if ( [view isKindOfClass:[UIScrollView class]] || [view isKindOfClass:[UITableView class]] )
	{
		CGPoint viewOrigin = [self convertPoint:CGPointZero toView:view];
		viewFrame.origin.x -= viewOrigin.x;
		viewFrame.origin.y -= viewOrigin.y;
	}
		
	viewFrame.size.width = view.bounds.size.width;
	viewFrame.size.height = view.bounds.size.height;
	
	CGFloat overflowWidth = screenBound.size.width * 1.5;
	CGFloat overflowHeight = screenBound.size.height * 1.5;
	
	if ( CGRectGetMaxX(viewFrame) < -overflowWidth || CGRectGetMinX(viewFrame) > (screenBound.size.width + overflowWidth) )
		return;
	if ( CGRectGetMaxY(viewFrame) < -overflowHeight || CGRectGetMinY(viewFrame) > (screenBound.size.height + overflowHeight) )
		return;

//	INFO( @"view = %@", [[view class] description] );
	
	ServiceInspector_Layer * layer = [[ServiceInspector_Layer alloc] init];
	if ( layer )
	{
		layer.layer.borderWidth = 1.5f;
		layer.layer.borderColor = HEX_RGBA( 0x39b54a, 0.8f ).CGColor;
		layer.backgroundColor = HEX_RGBA( 0x636363, 0.05f );

		CGPoint anchor;
		anchor.x = (screenBound.size.width / 2.0f - viewFrame.origin.x) / viewFrame.size.width;
		anchor.y = (screenBound.size.height / 2.0f - viewFrame.origin.y) / viewFrame.size.height;

		layer.view = view;
		
		if ( view.tagString )
		{
			layer.label.text = [NSString stringWithFormat:@"#%@", view.tagString];
			layer.label.textColor = [UIColor yellowColor];
		}
		else
		{
			layer.label.text =  [[view class] description];
			layer.label.textColor = [UIColor yellowColor];
		}
		
		layer.label.hidden = _labelShown ? NO : YES;
		layer.rect = viewFrame;
		layer.depth = depth;
		layer.frame = viewFrame;
		layer.image = view.screenshotOneLayer;
		layer.layer.anchorPoint = anchor;
		layer.layer.anchorPointZ = (layer.depth * -1.0f) * 75.0f;
		[self addSubview:layer];

		[layer release];
	}

	for ( UIView * subview in view.subviews )
	{
		[self buildSublayersFor:subview depth:(depth + 1 + [view.subviews indexOfObject:subview] * 0.025f) origin:layer.rect.origin];
	}
}

- (void)buildLayers
{
	[self buildSublayersFor:[BeeUIApplication sharedInstance].window depth:0 origin:CGPointZero];
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
    transform2.m34 = -0.002;
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
	_rotateX = 5.0f;
	_rotateY = 30.0f;
	_distance = -1.0f;
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

ON_SIGNAL2( showLabel, signal )
{
	_labelShown = _labelShown ? NO : YES;
	
	if ( _labelShown )
	{
		_showLabel.title = @"Label (ON)";
	}
	else
	{
		_showLabel.title = @"Label (OFF)";
	}

	for ( ServiceInspector_Layer * layer in self.subviews )
	{
		if ( [layer isKindOfClass:[ServiceInspector_Layer class]] )
		{
			layer.label.hidden = _labelShown ? NO : YES;
		}
	}
}

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

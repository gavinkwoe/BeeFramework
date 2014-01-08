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

#import "UIView+Animation.h"

#import "Bee_UIAnimationAlpha.h"
#import "Bee_UIAnimationBounce.h"
#import "Bee_UIAnimationFade.h"
#import "Bee_UIAnimationZoom.h"

#pragma mark -

#undef	KEY_ZOOMED
#define KEY_ZOOMED		"UIView.zoomed"

#undef	KEY_ZOOMEDRECT
#define	KEY_ZOOMEDRECT	"UIView.zoomedRect"

#pragma mark -

@interface UIView(AnimationPrivate)

- (void)hideAnimationDidStop;
- (void)showAnimationDidStop;

@end

#pragma mark -

@implementation UIView(Animation)

@dynamic animating;
@dynamic zoomed;
@dynamic zoomedRect;

#pragma mark -

- (BOOL)animating
{
	// TODO:
	return NO;
}

- (BOOL)zoomed
{
	NSNumber * value = objc_getAssociatedObject( self, KEY_ZOOMED );
	if ( nil == value )
		return NO;
	
	return value.boolValue;
}

- (void)setZoomed:(BOOL)value
{
	objc_setAssociatedObject( self, KEY_ZOOMED, [NSNumber numberWithBool:value], OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (CGRect)zoomedRect
{
	NSValue * value = objc_getAssociatedObject( self, KEY_ZOOMEDRECT );
	if ( nil == value )
		return CGRectZero;

	return value.CGRectValue;
}

- (void)setZoomedRect:(CGRect)rect
{
	objc_setAssociatedObject( self, KEY_ZOOMEDRECT, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

#pragma mark -

- (id)animationWithType:(BeeUIAnimationType)type
{
	BeeUIAnimation * anim = [BeeUIAnimation animationWithType:type];
	if ( anim )
	{
		anim.object = self;
		anim.target = self;
	}
	return anim;
}

- (BeeUIAnimation *)fadeTo:(CGFloat)progress
{
	BeeUIAnimationAlpha * anim = [self animationWithType:BeeUIAnimationTypeAlpha];
	if ( anim )
	{
		anim.to = progress;
		[anim perform];
	}
	return anim;
}

- (BeeUIAnimation *)fadeOut
{
	BeeUIAnimationFadeOut * anim = [self animationWithType:BeeUIAnimationTypeFadeOut];
	if ( anim )
	{
		[anim perform];
	}
	return anim;
}

- (BeeUIAnimation *)fadeIn
{
	[self setHidden:NO];

	BeeUIAnimationAlpha * anim = [self animationWithType:BeeUIAnimationTypeFadeIn];
	if ( anim )
	{
		[anim perform];
	}
	return anim;
}

- (BeeUIAnimation *)fadeToggle
{
	if ( self.hidden )
	{
		return [self fadeIn];
	}
	else
	{
		return [self fadeOut];
	}
}

- (BeeUIAnimation *)bounce
{
	BeeUIAnimationBounce * anim = [self animationWithType:BeeUIAnimationTypeBounce];
	if ( anim )
	{
		anim.from = 0.0f;
		anim.to = 1.0f;
		[anim perform];
	}
	return anim;
}

- (BeeUIAnimation *)dissolve
{
	BeeUIAnimationDissolve * anim = [self animationWithType:BeeUIAnimationTypeDissolve];
	if ( anim )
	{
		[anim perform];
	}
	return anim;	
}

- (BeeUIAnimation *)zoomIn:(CGRect)rect
{
	if ( self.zoomed )
		return nil;
	
	BeeUIAnimationZoomIn * anim = [self animationWithType:BeeUIAnimationTypeZoomIn];
	if ( anim )
	{
		anim.rect = rect;
		[anim perform];
		
		self.zoomed = YES;
	}
	return anim;
}

- (BeeUIAnimation *)zoomOut
{
	if ( NO == self.zoomed )
		return nil;

	BeeUIAnimationZoomOut * anim = [self animationWithType:BeeUIAnimationTypeZoomOut];
	if ( anim )
	{
		[anim perform];
		
		self.zoomed = NO;
	}
	return anim;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

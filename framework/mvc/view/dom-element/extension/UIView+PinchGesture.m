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

#import "UIView+PinchGesture.h"
#import "UIView+BeeUISignal.h"

#import "Bee_UIConfig.h"

#pragma mark -

@interface __PinchGestureRecognizer : UIPinchGestureRecognizer
@end

@implementation __PinchGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
	self = [super initWithTarget:target action:action];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end

#pragma mark -

@interface UIView(PinchGesturePrivate)
- (void)didPinch:(UIPinchGestureRecognizer *)panGesture;
@end

#pragma mark -

@implementation UIView(PinchGesture)

DEF_SIGNAL( PINCH_START )
DEF_SIGNAL( PINCH_STOP )
DEF_SIGNAL( PINCH_CHANGED )
DEF_SIGNAL( PINCH_CANCELLED )

@dynamic pinchable;		// same as pinchEnabled
@dynamic pinchEnabled;
@dynamic pinchScale;
@dynamic pinchVelocity;
@dynamic pinchGesture;

- (BOOL)pinchable
{
	return self.pinchGesture.enabled;
}

- (void)setPinchable:(BOOL)flag
{
	self.pinchGesture.enabled = flag;
}

- (BOOL)pinchEnabled
{
	return self.pinchGesture.enabled;
}

- (void)setPinchEnabled:(BOOL)flag
{
	self.pinchGesture.enabled = flag;
}

- (CGFloat)pinchScale
{
	UIPinchGestureRecognizer * gesture = self.pinchGesture;
	if ( nil == gesture )
	{
		return 1.0f;
	}
	
	return gesture.scale;
}

- (UIPinchGestureRecognizer *)pinchGesture
{
	UIPinchGestureRecognizer * pinchGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__PinchGestureRecognizer class]] )
		{
			pinchGesture = (UIPinchGestureRecognizer *)gesture;
		}
	}
	
	if ( nil == pinchGesture )
	{
		pinchGesture = [[[__PinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)] autorelease];
		[self addGestureRecognizer:pinchGesture];
	}

	return pinchGesture;
}

- (void)didPinch:(UIPinchGestureRecognizer *)pinchGesture
{
	if ( UIGestureRecognizerStateBegan == pinchGesture.state )
	{
		if ( [BeeUIConfig sharedInstance].highPerformance )
		{
//			self.layer.shouldRasterize = YES;
		}

		[self sendUISignal:UIView.PINCH_START];
	}
	else if ( UIGestureRecognizerStateChanged == pinchGesture.state )
	{
		[self sendUISignal:UIView.PINCH_CHANGED];
	}
	else if ( UIGestureRecognizerStateEnded == pinchGesture.state )
	{
		if ( [BeeUIConfig sharedInstance].highPerformance )
		{
//			self.layer.shouldRasterize = NO;
		}

		[self sendUISignal:UIView.PINCH_STOP];
	}
	else if ( UIGestureRecognizerStateCancelled == pinchGesture.state )
	{
		if ( [BeeUIConfig sharedInstance].highPerformance )
		{
//			self.layer.shouldRasterize = NO;
		}

		[self sendUISignal:UIView.PINCH_CANCELLED];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

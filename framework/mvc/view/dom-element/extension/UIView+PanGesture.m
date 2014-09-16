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

#import "UIView+PanGesture.h"
#import "UIView+BeeUISignal.h"

#import "Bee_UIConfig.h"

#pragma mark -

@interface __PanGestureRecognizer : UIPanGestureRecognizer
@end

@implementation __PanGestureRecognizer

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

@interface UIView(PanGesturePrivate)
- (void)didPan:(UIPanGestureRecognizer *)panGesture;
@end

#pragma mark -

@implementation UIView(PanGesture)

DEF_SIGNAL( PAN_START )
DEF_SIGNAL( PAN_STOP )
DEF_SIGNAL( PAN_CHANGED )
DEF_SIGNAL( PAN_CANCELLED )

@dynamic pannable;
@dynamic panEnabled;
@dynamic panOffset;
@dynamic panGesture;

- (BOOL)pannable
{
	return self.panGesture.enabled;
}

- (void)setPannable:(BOOL)flag
{
	self.panGesture.enabled = flag;
}

- (BOOL)panEnabled
{
	return self.panGesture.enabled;
}

- (void)setPanEnabled:(BOOL)flag
{
	self.panGesture.enabled = flag;
}

- (CGPoint)panOffset
{
	return [self.panGesture translationInView:self];
}

- (UIPanGestureRecognizer *)panGesture
{
	UIPanGestureRecognizer * panGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__PanGestureRecognizer class]] )
		{
			panGesture = (UIPanGestureRecognizer *)gesture;
		}
	}
	
	if ( nil == panGesture )
	{
		panGesture = [[[__PanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)] autorelease];
		[self addGestureRecognizer:panGesture];
	}

	return panGesture;
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture
{
	if ( UIGestureRecognizerStateBegan == panGesture.state )
	{
		if ( [BeeUIConfig sharedInstance].highPerformance )
		{
//			self.layer.shouldRasterize = YES;
		}
		
		[self sendUISignal:UIView.PAN_START];
	}
	else if ( UIGestureRecognizerStateChanged == panGesture.state )
	{
		[self sendUISignal:UIView.PAN_CHANGED];
	}
	else if ( UIGestureRecognizerStateEnded == panGesture.state )
	{
		if ( [BeeUIConfig sharedInstance].highPerformance )
		{
//			self.layer.shouldRasterize = NO;
		}

		[self sendUISignal:UIView.PAN_STOP];
	}
	else if ( UIGestureRecognizerStateCancelled == panGesture.state )
	{
		if ( [BeeUIConfig sharedInstance].highPerformance )
		{
//			self.layer.shouldRasterize = NO;
		}

		[self sendUISignal:UIView.PAN_CANCELLED];
	}
	else if ( UIGestureRecognizerStateFailed == panGesture.state )
	{
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

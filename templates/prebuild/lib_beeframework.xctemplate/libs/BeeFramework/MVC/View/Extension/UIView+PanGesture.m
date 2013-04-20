//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  UIView+PanGesture.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_Singleton.h"
#import "Bee_Log.h"
#import "Bee_Performance.h"
#import "UIView+BeeExtension.h"
#import "UIView+PanGesture.h"
#import "UIView+BeeUISignal.h"

#import <objc/runtime.h>

#pragma mark -

@interface __PanGestureRecognizer : UIPanGestureRecognizer
@end
@implementation __PanGestureRecognizer
@end

#pragma mark -

@interface UIView(PanGesturePrivate)
- (__PanGestureRecognizer *)getPanGesture;
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

- (__PanGestureRecognizer *)getPanGesture
{
	__PanGestureRecognizer * panGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__PanGestureRecognizer class]] )
		{
			panGesture = (__PanGestureRecognizer *)gesture;
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
	CGPoint panOffset = [panGesture translationInView:self];
	CC( @"panOffset = (%.0f, %.0f)", panOffset.x, panOffset.y );
	
	if ( UIGestureRecognizerStateBegan == panGesture.state )
	{
		[self sendUISignal:UIView.PAN_START];
	}
	else if ( UIGestureRecognizerStateChanged == panGesture.state )
	{
		[self sendUISignal:UIView.PAN_CHANGED];
	}
	else if ( UIGestureRecognizerStateEnded == panGesture.state )
	{
		[self sendUISignal:UIView.PAN_STOP];
	}
	else if ( UIGestureRecognizerStateCancelled == panGesture.state )
	{
		[self sendUISignal:UIView.PAN_CANCELLED];
	}
}

- (BOOL)pannable
{
	return self.panEnabled;
}

- (void)setPannable:(BOOL)flag
{
	self.panEnabled = flag;
}

- (BOOL)panEnabled
{
	__PanGestureRecognizer * panGesture = [self getPanGesture];
	if ( panGesture )
	{
		return panGesture.enabled;
	}
	
	return NO;
}

- (void)setPanEnabled:(BOOL)flag
{
	__PanGestureRecognizer * panGesture = [self getPanGesture];
	if ( panGesture )
	{
		panGesture.enabled = flag;
	}
}

- (CGPoint)panOffset
{
	__PanGestureRecognizer * panGesture = [self getPanGesture];
	if ( panGesture )
	{
		return [panGesture translationInView:self];
	}

	return CGPointZero;
}

- (UIPanGestureRecognizer *)panGesture
{
	return [self getPanGesture];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

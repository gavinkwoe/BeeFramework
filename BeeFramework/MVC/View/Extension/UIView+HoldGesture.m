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
//  Bee_UISignal.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_Singleton.h"
#import "Bee_Log.h"
#import "Bee_Performance.h"
#import "UIView+BeeExtension.h"
#import "UIView+BeeUISignal.h"
#import "UIView+HoldGesture.h"

#import <objc/runtime.h>

#pragma mark -

@interface __LongPressGestureRecognizer : UILongPressGestureRecognizer
@end

#pragma mark -

@implementation __LongPressGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
	self = [super initWithTarget:target action:action];
	if ( self )
	{
		self.numberOfTapsRequired = 1;
		self.numberOfTouchesRequired = 1;
		self.cancelsTouchesInView = YES;
		self.delaysTouchesBegan = YES;
		self.delaysTouchesEnded = YES;
		self.minimumPressDuration = 1.0f;
		self.allowableMovement = 10;
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end

#pragma mark -

@interface UIView(HoldGesturePrivate)
- (__LongPressGestureRecognizer *)getLongPressGesture;
@end

#pragma mark -

@implementation UIView(HoldGesture)

DEF_SIGNAL( HOLD_START )		// 长按开始
DEF_SIGNAL( HOLD_STOP )		// 长按结束
DEF_SIGNAL( HOLD_CANCELLED )	// 长按取消

@dynamic holdable;		// same as holdEnabled
@dynamic holdEnabled;
@dynamic holdGesture;

- (__LongPressGestureRecognizer *)getLongPressGesture
{
	__LongPressGestureRecognizer * pressGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__LongPressGestureRecognizer class]] )
		{
			pressGesture = (__LongPressGestureRecognizer *)gesture;
		}
	}
	
	if ( nil == pressGesture )
	{
		pressGesture = [[[__LongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)] autorelease];
		[self addGestureRecognizer:pressGesture];
	}

	return pressGesture;
}

- (void)didLongPress:(UILongPressGestureRecognizer *)pressGesture
{
	if ( UIGestureRecognizerStateBegan == pressGesture.state )
	{
		[self sendUISignal:UIView.HOLD_START];
	}
	else if ( UIGestureRecognizerStateEnded == pressGesture.state )
	{
		[self sendUISignal:UIView.HOLD_STOP];
	}
	else if ( UIGestureRecognizerStateCancelled == pressGesture.state )
	{
		[self sendUISignal:UIView.HOLD_CANCELLED];
	}
}

- (BOOL)holdable
{
	return self.holdEnabled;
}

- (void)setHoldable:(BOOL)flag
{
	self.holdEnabled = flag;
}

- (BOOL)holdEnabled
{
	__LongPressGestureRecognizer * pressGesture = [self getLongPressGesture];
	if ( pressGesture )
	{
		return pressGesture.enabled;
	}

	return NO;
}

- (void)setHoldEnabled:(BOOL)flag
{
	__LongPressGestureRecognizer * pressGesture = [self getLongPressGesture];
	if ( pressGesture )
	{
		pressGesture.enabled = flag;
	}
}

- (UILongPressGestureRecognizer *)holdGesture
{
	return [self getLongPressGesture];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

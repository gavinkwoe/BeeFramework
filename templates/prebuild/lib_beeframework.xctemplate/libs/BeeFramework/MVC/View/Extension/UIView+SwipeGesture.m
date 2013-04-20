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
#import "UIView+SwipeGesture.h"

#import <objc/runtime.h>

#pragma mark -

@interface __SwipeGestureRecognizer : UISwipeGestureRecognizer
@end
@implementation __SwipeGestureRecognizer
@end

#pragma mark -

@interface UIView(SwipeGesturePrivate)
- (__SwipeGestureRecognizer *)getSwipeGesture;
- (void)didSwipe:(UISwipeGestureRecognizer *)swipeGesture;
@end

#pragma mark -

@implementation UIView(SwipeGesture)

DEF_SIGNAL( SWIPE_UP )
DEF_SIGNAL( SWIPE_DOWN )
DEF_SIGNAL( SWIPE_LEFT )
DEF_SIGNAL( SWIPE_RIGHT )

@dynamic swipeble;
@dynamic swipeEnabled;
@dynamic swipeDirection;
@dynamic swipeGesture;

- (__SwipeGestureRecognizer *)getSwipeGesture
{
	__SwipeGestureRecognizer * swipeGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__SwipeGestureRecognizer class]] )
		{
			swipeGesture = (__SwipeGestureRecognizer *)gesture;
		}
	}
	
	if ( nil == swipeGesture )
	{
		swipeGesture = [[[__SwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)] autorelease];
		swipeGesture.numberOfTouchesRequired = 1;
		[self addGestureRecognizer:swipeGesture];
	}
	
	return swipeGesture;
}

- (void)didSwipe:(UISwipeGestureRecognizer *)swipeGesture
{
	if ( UIGestureRecognizerStateEnded == swipeGesture.state )
	{
		if ( UISwipeGestureRecognizerDirectionUp == swipeGesture.direction )
		{
			CC( @"swipe up" );
			
			[self sendUISignal:UIView.SWIPE_UP];
		}
		else if ( UISwipeGestureRecognizerDirectionDown == swipeGesture.direction )
		{
			CC( @"swipe down" );
			
			[self sendUISignal:UIView.SWIPE_DOWN];
		}
		else if ( UISwipeGestureRecognizerDirectionLeft == swipeGesture.direction )
		{
			CC( @"swipe left" );
			
			[self sendUISignal:UIView.SWIPE_LEFT];
		}
		else if ( UISwipeGestureRecognizerDirectionRight == swipeGesture.direction )
		{
			CC( @"swipe right" );
			
			[self sendUISignal:UIView.SWIPE_RIGHT];
		}
	}
}

- (BOOL)swipeble
{
	return self.swipeEnabled;
}

- (void)setSwipeble:(BOOL)flag
{
	self.swipeEnabled = flag;
}

- (BOOL)swipeEnabled
{
	__SwipeGestureRecognizer * swipeGesture = [self getSwipeGesture];
	if ( swipeGesture )
	{
		return swipeGesture.enabled;
	}
	
	return NO;
}

- (void)setSwipeEnabled:(BOOL)flag
{
	__SwipeGestureRecognizer * swipeGesture = [self getSwipeGesture];
	if ( swipeGesture )
	{
		swipeGesture.enabled = flag;
	}
}

- (UISwipeGestureRecognizerDirection)direction
{
	__SwipeGestureRecognizer * swipeGesture = [self getSwipeGesture];
	if ( swipeGesture )
	{
		return swipeGesture.direction;
	}
	
	return 0;
}

- (void)setSwipeDirection:(UISwipeGestureRecognizerDirection)direction
{
	__SwipeGestureRecognizer * swipeGesture = [self getSwipeGesture];
	if ( swipeGesture )
	{
		swipeGesture.direction = direction;
	}
}

- (UISwipeGestureRecognizer *)swipeGesture
{
	return [self getSwipeGesture];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

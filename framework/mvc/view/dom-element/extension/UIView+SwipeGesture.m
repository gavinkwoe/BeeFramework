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

#import "UIView+SwipeGesture.h"
#import "UIView+BeeUISignal.h"

#pragma mark -

@interface __SwipeGestureRecognizer : UISwipeGestureRecognizer
@end

#pragma mark -

@implementation __SwipeGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
	self = [super initWithTarget:target action:action];
	if ( self )
	{
		self.numberOfTouchesRequired = 1;
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end

#pragma mark -

@interface UIView(SwipeGesturePrivate)
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

- (BOOL)swipeble
{
	return self.swipeGesture.enabled;
}

- (void)setSwipeble:(BOOL)flag
{
	self.swipeGesture.enabled = flag;
}

- (BOOL)swipeEnabled
{
	return self.swipeGesture.enabled;
}

- (void)setSwipeEnabled:(BOOL)flag
{
	self.swipeGesture.enabled = flag;
}

- (UISwipeGestureRecognizerDirection)direction
{
	return self.swipeGesture.direction;
}

- (void)setSwipeDirection:(UISwipeGestureRecognizerDirection)direction
{
	self.swipeGesture.direction = direction;
}

- (UISwipeGestureRecognizer *)swipeGesture
{
	UISwipeGestureRecognizer * swipeGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__SwipeGestureRecognizer class]] )
		{
			swipeGesture = (UISwipeGestureRecognizer *)gesture;
		}
	}

	if ( nil == swipeGesture )
	{
		swipeGesture = [[[__SwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)] autorelease];
		[self addGestureRecognizer:swipeGesture];
	}
	
	return swipeGesture;
}

- (void)didSwipe:(UISwipeGestureRecognizer *)swipeGesture
{
	if ( UIGestureRecognizerStateEnded == swipeGesture.state )
	{
		if ( UISwipeGestureRecognizerDirectionUp & swipeGesture.direction )
		{
			[self sendUISignal:UIView.SWIPE_UP];
		}
		
		if ( UISwipeGestureRecognizerDirectionDown & swipeGesture.direction )
		{
			[self sendUISignal:UIView.SWIPE_DOWN];
		}
		
		if ( UISwipeGestureRecognizerDirectionLeft & swipeGesture.direction )
		{
			[self sendUISignal:UIView.SWIPE_LEFT];
		}
		
		if ( UISwipeGestureRecognizerDirectionRight & swipeGesture.direction )
		{
			[self sendUISignal:UIView.SWIPE_RIGHT];
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

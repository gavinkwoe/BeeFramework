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
- (UISwipeGestureRecognizer *)swipeGestureForDirection:(UISwipeGestureRecognizerDirection)direction forceCreate:(bool)create;
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

- (BOOL)swipeble
{
	UISwipeGestureRecognizer * gesture1 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionUp forceCreate:NO];
	UISwipeGestureRecognizer * gesture2 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionDown forceCreate:NO];
	UISwipeGestureRecognizer * gesture3 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionLeft forceCreate:NO];
	UISwipeGestureRecognizer * gesture4 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionRight forceCreate:NO];

	if ( gesture1 && gesture1.enabled )
	{
		return YES;
	}

	if ( gesture2 && gesture2.enabled )
	{
		return YES;
	}

	if ( gesture3 && gesture3.enabled )
	{
		return YES;
	}

	if ( gesture4 && gesture4.enabled )
	{
		return YES;
	}

	return NO;
}

- (void)setSwipeble:(BOOL)flag
{
	UISwipeGestureRecognizer * gesture1 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionUp forceCreate:NO];
	UISwipeGestureRecognizer * gesture2 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionDown forceCreate:NO];
	UISwipeGestureRecognizer * gesture3 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionLeft forceCreate:NO];
	UISwipeGestureRecognizer * gesture4 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionRight forceCreate:NO];

	if ( gesture1 )
	{
		gesture1.enabled = flag;
	}
	
	if ( gesture2 )
	{
		gesture2.enabled = flag;
	}
	
	if ( gesture3 )
	{
		gesture3.enabled = flag;
	}
	
	if ( gesture4 )
	{
		gesture4.enabled = flag;
	}
}

- (BOOL)swipeEnabled
{
	return [self swipeble];
}

- (void)setSwipeEnabled:(BOOL)flag
{
	[self setSwipeble:flag];
}

- (UISwipeGestureRecognizerDirection)direction
{
	UISwipeGestureRecognizer * gesture1 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionUp forceCreate:NO];
	UISwipeGestureRecognizer * gesture2 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionDown forceCreate:NO];
	UISwipeGestureRecognizer * gesture3 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionLeft forceCreate:NO];
	UISwipeGestureRecognizer * gesture4 = [self swipeGestureForDirection:UISwipeGestureRecognizerDirectionRight forceCreate:NO];

	return (gesture1.direction|gesture2.direction|gesture3.direction|gesture4.direction);
}

- (void)setSwipeDirection:(UISwipeGestureRecognizerDirection)direction
{
	if ( UISwipeGestureRecognizerDirectionUp & direction )
	{
		[self swipeGestureForDirection:UISwipeGestureRecognizerDirectionUp forceCreate:YES];
	}
	
	if ( UISwipeGestureRecognizerDirectionDown & direction )
	{
		[self swipeGestureForDirection:UISwipeGestureRecognizerDirectionDown forceCreate:YES];
	}
	
	if ( UISwipeGestureRecognizerDirectionLeft & direction )
	{
		[self swipeGestureForDirection:UISwipeGestureRecognizerDirectionLeft forceCreate:YES];
	}
	
	if ( UISwipeGestureRecognizerDirectionRight & direction )
	{
		[self swipeGestureForDirection:UISwipeGestureRecognizerDirectionRight forceCreate:YES];
	}
}

- (UISwipeGestureRecognizer *)swipeGestureForDirection:(UISwipeGestureRecognizerDirection)direction forceCreate:(bool)create
{
	UISwipeGestureRecognizer * swipeGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__SwipeGestureRecognizer class]] )
		{
			UISwipeGestureRecognizer * tempGesture = (UISwipeGestureRecognizer *)gesture;
			if ( tempGesture.direction & direction )
			{
				swipeGesture = tempGesture;
				break;
			}
		}
	}

	if ( nil == swipeGesture && create )
	{
		swipeGesture = [[[__SwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)] autorelease];
		swipeGesture.direction = direction;
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

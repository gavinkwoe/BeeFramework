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

#import "UIView+Transition.h"

#pragma mark -

@implementation UIView(Transition)

+ (NSString *)CATransitionFrom:(BeeUITransitionFrom)from
{
	if ( from == BeeUITransitionFromRight )
	{
		return kCATransitionFromRight;
	}
	else if ( from == BeeUITransitionFromLeft )
	{
		return kCATransitionFromLeft;
	}
	else if ( from == BeeUITransitionFromTop )
	{
		return kCATransitionFromTop;
	}
	else if ( from == BeeUITransitionFromBottom )
	{
		return kCATransitionFromBottom;
	}
	
	return kCATransitionFromRight;
}

- (void)transition:(BeeUITransitionType)type
{
	if ( BeeUITransitionTypeFade == type )
	{
		[self transitionFade];
	}
	else if ( BeeUITransitionTypeCube == type )
	{
		[self transitionFade];
	}
	else if ( BeeUITransitionTypePush == type )
	{
		[self transitionPush];
	}
	else if ( BeeUITransitionTypeFlip == type )
	{
		[self transitionFlip];
	}
}

- (void)transition:(BeeUITransitionType)type from:(BeeUITransitionFrom)from
{
	if ( BeeUITransitionTypeFade == type )
	{
		[self transitionFade:from];
	}
	else if ( BeeUITransitionTypeCube == type )
	{
		[self transitionCube:from];
	}
	else if ( BeeUITransitionTypePush == type )
	{
		[self transitionPush:from];
	}
	else if ( BeeUITransitionTypeFlip == type )
	{
		[self transitionFlip:from];
	}
}

- (void)transitionFade
{
	[self transitionFade:BeeUITransitionFromRight];
}

- (void)transitionFade:(BeeUITransitionFrom)from
{
	CATransition * animation = [CATransition animation];
	if ( animation )
	{
		[animation setDuration:0.6f];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[animation setType:@"fade"];
		[animation setSubtype:[UIView CATransitionFrom:from]];
		[animation setRemovedOnCompletion:YES];

//		[self.layer removeAnimationForKey:@"fade"];
		[self.layer addAnimation:animation forKey:@"fade"];
	}
}

- (void)transitionCube
{
	[self transitionCube:BeeUITransitionFromRight];
}

- (void)transitionCube:(BeeUITransitionFrom)from
{
	CATransition * animation = [CATransition animation];
	if ( animation )
	{
		[animation setDuration:0.6f];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[animation setType:@"cube"];
		[animation setSubtype:[UIView CATransitionFrom:from]];
		[animation setRemovedOnCompletion:YES];

//		[self.layer removeAnimationForKey:@"cube"];
		[self.layer addAnimation:animation forKey:@"cube"];
	}
}

- (void)transitionPush
{
	[self transitionPush:BeeUITransitionFromRight];
}

- (void)transitionPush:(BeeUITransitionFrom)from
{
	CATransition * animation = [CATransition animation];
	if ( animation )
	{
		[animation setDuration:0.6f];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[animation setType:kCATransitionPush];
		[animation setSubtype:[UIView CATransitionFrom:from]];
		[animation setRemovedOnCompletion:YES];
		
//		[self.layer removeAnimationForKey:@"push"];
		[self.layer addAnimation:animation forKey:@"push"];
	}
}

- (void)transitionFlip
{
	[self transitionFlip:BeeUITransitionFromRight];
}

- (void)transitionFlip:(BeeUITransitionFrom)from
{
	CATransition * animation = [CATransition animation];
	if ( animation )
	{
		[animation setDuration:0.6f];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[animation setFillMode:kCAFillModeForwards];
		[animation setType:@"flip"];
		[animation setSubtype:[UIView CATransitionFrom:from]];
		[animation setStartProgress:0.0f];
		[animation setEndProgress:1.0f];
		[animation setRemovedOnCompletion:YES];

//		[self.layer removeAnimationForKey:@"flip"];
		[self.layer addAnimation:animation forKey:@"flip"];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

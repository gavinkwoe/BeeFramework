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

#import "UIView+Transition.h"

#import "Bee_UITransition.h"
#import "Bee_UITransitionCube.h"
#import "Bee_UITransitionFade.h"
#import "Bee_UITransitionFlip.h"
#import "Bee_UITransitionPush.h"

#pragma mark -

#undef	KEY_TRANSITION
#define	KEY_TRANSITION	"UIView.transition"

#pragma mark -

@implementation UIView(Transition)

@dynamic transition;

- (BeeUITransition *)transition
{
	return objc_getAssociatedObject( self, KEY_TRANSITION );
}

- (void)setTransition:(BeeUITransition *)trans
{
	objc_setAssociatedObject( self, KEY_TRANSITION, trans, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (void)transitionType:(BeeUITransitionType)type direction:(BeeUITransitionDirection)from
{
	BeeUITransition * trans = [BeeUITransition transitionWithType:type];
	if ( trans )
	{
		[trans transiteFor:self direction:from];
	}
}

- (void)transitionFade
{
	[self transitionFade:BeeUITransitionDirectionRight];
}

- (void)transitionFade:(BeeUITransitionDirection)from
{
	[[BeeUITransitionFade sharedInstance] transiteFor:self direction:from];
}

- (void)transitionCube
{
	[self transitionCube:BeeUITransitionDirectionRight];
}

- (void)transitionCube:(BeeUITransitionDirection)from
{
	[[BeeUITransitionCube sharedInstance] transiteFor:self direction:from];
}

- (void)transitionPush
{
	[self transitionPush:BeeUITransitionDirectionRight];
}

- (void)transitionPush:(BeeUITransitionDirection)from
{
	[[BeeUITransitionPush sharedInstance] transiteFor:self direction:from];
}

- (void)transitionFlip
{
	[self transitionFlip:BeeUITransitionDirectionRight];
}

- (void)transitionFlip:(BeeUITransitionDirection)from
{
	[[BeeUITransitionFlip sharedInstance] transiteFor:self direction:from];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

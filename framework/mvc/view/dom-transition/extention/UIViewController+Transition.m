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

#import "UIViewController+Transition.h"

#pragma mark -

#undef	KEY_TRANSITION
#define	KEY_TRANSITION	"UIViewController.transition"

#pragma mark -

@implementation UIViewController(Transition)

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
	[self.view transitionType:type direction:from];
}

- (void)transitionFade
{
	[self.view transitionFade];
}

- (void)transitionFade:(BeeUITransitionDirection)from
{
	[self.view transitionFade:from];
}

- (void)transitionCube
{
	[self.view transitionCube];
}

- (void)transitionCube:(BeeUITransitionDirection)from
{
	[self.view transitionCube:from];
}

- (void)transitionPush
{
	[self.view transitionPush];
}

- (void)transitionPush:(BeeUITransitionDirection)from
{
	[self.view transitionPush:from];
}

- (void)transitionFlip
{
	[self.view transitionFlip];
}

- (void)transitionFlip:(BeeUITransitionDirection)from
{
	[self.view transitionFlip:from];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

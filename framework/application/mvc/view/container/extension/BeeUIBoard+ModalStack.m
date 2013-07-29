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

#import "BeeUIBoard+ModalStack.h"
#import "BeeUIBoard+Traversing.h"

#import "UIView+BeeUISignal.h"
#import "UIView+UIViewController.h"
#import "UIViewController+BeeUISignal.h"

#pragma mark -

#undef	ANIMATION_DURATION
#define	ANIMATION_DURATION			(0.3f)

#undef	KEY_MODAL_STACK
#define KEY_MODAL_STACK				"BeeUIBoard.modalStack"

#pragma mark -

@implementation BeeUIBoard(ModalStack)

@dynamic modalStack;

#pragma mark -

- (BeeUIStack *)modalStack
{
	return objc_getAssociatedObject( self, KEY_MODAL_STACK );
}

- (void)setModalStack:(BeeUIStack *)stack
{
	objc_setAssociatedObject( self, KEY_MODAL_STACK, stack, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

#pragma mark -

- (void)presentModalStack:(BeeUIStack *)stack animated:(BOOL)animated
{
	if ( self.modalStack )
		return;

	[self sendUISignal:self.MODALVIEW_WILL_SHOW];

	if ( animated )
	{
		CATransition * transition = [CATransition animation];
		[transition setDuration:0.3f];
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
		[transition setType:kCATransitionFade];
		[transition setSubtype:kCATransitionFromTop];
		[self.view.layer addAnimation:transition forKey:nil];
	}
	
	self.modalStack = stack;
	self.modalStack.view.frame = self.view.bounds;
	[self.view addSubview:self.modalStack.view];
	
	stack.topBoard.parentBoard = self;

	[self sendUISignal:self.MODALVIEW_DID_SHOWN];
}

- (void)dismissModalStackAnimated:(BOOL)animated
{
	if ( nil == self.modalStack )
		return;

	[self sendUISignal:self.MODALVIEW_WILL_HIDE];

	if ( animated )
	{
		CATransition * transition = [CATransition animation];
		[transition setDuration:0.3f];
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear]];
        [transition setType:kCATransitionFade];
		[transition setSubtype:kCATransitionFromBottom];
		[self.view.layer addAnimation:transition forKey:nil];
	}
	
	[self.modalStack.view removeFromSuperview];
	self.modalStack.topBoard.parentBoard = nil;
	self.modalStack = nil;

	[self sendUISignal:self.MODALVIEW_DID_HIDDEN];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

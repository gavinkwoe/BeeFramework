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

#import "BeeUIBoard+ModalView.h"

#import "UIView+BeeUISignal.h"
#import "UIViewController+BeeUISignal.h"

#import "UIView+UIViewController.h"
#import "UIView+Animation.h"

#import "UIView+Transition.h"
#import "UIViewController+Transition.h"

#pragma mark -

#undef	ANIMATION_DURATION
#define	ANIMATION_DURATION			(0.6f)

#undef	KEY_MODAL_VIEW
#define KEY_MODAL_VIEW				"BeeUIBoard.modalView"

#undef	KEY_MODAL_MASK
#define KEY_MODAL_MASK				"BeeUIBoard.modalMask"

#undef	KEY_MODAL_ANIMATION_TYPE
#define KEY_MODAL_ANIMATION_TYPE	"BeeUIBoard.modalAnimationType"

#pragma mark -

@interface BeeUIMaskView : UIButton
@end

#pragma mark -

@implementation BeeUIMaskView
@end

#pragma mark -

@interface BeeUIBoard(ModalViewPrivate)
- (void)didModalMaskTouched;
@end

#pragma mark -

@implementation BeeUIBoard(ModalView)

@dynamic modalMask;
@dynamic modalView;

DEF_SIGNAL( MODALVIEW_WILL_SHOW )	// ModalView将要显示
DEF_SIGNAL( MODALVIEW_DID_SHOWN )	// ModalView已经显示
DEF_SIGNAL( MODALVIEW_WILL_HIDE )	// ModalView将要隐藏
DEF_SIGNAL( MODALVIEW_DID_HIDDEN )	// ModalView已经隐藏

#pragma mark -

- (UIView *)modalView
{
	return objc_getAssociatedObject( self, KEY_MODAL_VIEW );
}

- (void)setModalView:(UIView *)view
{
	objc_setAssociatedObject( self, KEY_MODAL_VIEW, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (UIButton *)modalMask
{
	return objc_getAssociatedObject( self, KEY_MODAL_MASK );
}

- (void)setModalMask:(UIButton *)mask
{
	objc_setAssociatedObject( self, KEY_MODAL_MASK, mask, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

#pragma mark -

- (void)didModalMaskTouched
{
	[self dismissModalViewAnimated:YES];
}

- (void)presentModalView:(UIView *)view animated:(BOOL)animated
{
	[self presentModalView:view animated:animated transition:view.transition];
}

- (void)presentModalView:(UIView *)view animated:(BOOL)animated transitionType:(BeeUITransitionType)type
{
	BeeUITransition * trans = [BeeUITransition transitionWithType:type];
	[self presentModalView:view animated:animated transition:trans];
}

- (void)presentModalView:(UIView *)view animated:(BOOL)animated transition:(BeeUITransition *)trans
{
	if ( self.modalView || view.superview == self.view )
		return;

	[self sendUISignal:BeeUIBoard.MODALVIEW_WILL_SHOW];
	
	if ( nil == self.modalMask )
	{
		self.modalMask = [[[BeeUIMaskView alloc] initWithFrame:self.view.bounds] autorelease];
		[self.modalMask addTarget:self action:@selector(didModalMaskTouched) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:self.modalMask];
	}

	self.modalView = view;
	self.modalView.hidden = YES;
	self.modalMask.hidden = YES;

	[self.view addSubview:self.modalView];
	[self.view bringSubviewToFront:self.modalMask];
	[self.view bringSubviewToFront:self.modalView];

	if ( animated )
	{
		if ( nil == trans )
		{
			trans = [BeeUITransition transitionWithType:BeeUITransitionTypeFade];
		}

		[trans transiteFor:self.view direction:BeeUITransitionDirectionTop];

		self.modalView.transition = trans;
	}

	self.modalMask.alpha = 1.0f;
	self.modalMask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
	self.modalMask.hidden = NO;
	self.modalView.hidden = NO;
	
	[self sendUISignal:BeeUIBoard.MODALVIEW_DID_SHOWN];
}

- (void)dismissModalViewAnimated:(BOOL)animated
{
	BeeUITransition * trans = self.modalView ? self.modalView.transition : nil;
	[self dismissModalViewAnimated:animated transition:trans];
}

- (void)dismissModalViewAnimated:(BOOL)animated transitionType:(BeeUITransitionType)type
{
	BeeUITransition * trans = [BeeUITransition transitionWithType:type];
	[self dismissModalViewAnimated:animated transition:trans];
}

- (void)dismissModalViewAnimated:(BOOL)animated transition:(BeeUITransition *)trans
{
	if ( nil == self.modalView )
		return;

	[self sendUISignal:BeeUIBoard.MODALVIEW_WILL_HIDE];

	if ( animated && trans )
	{
		[trans transiteFor:self.view direction:BeeUITransitionDirectionBottom];
	}

	self.modalMask.hidden = YES;
	self.modalMask = nil;

	self.modalView.transition = nil;
	self.modalView.hidden = YES;
	self.modalView = nil;

	[self sendUISignal:BeeUIBoard.MODALVIEW_DID_HIDDEN];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

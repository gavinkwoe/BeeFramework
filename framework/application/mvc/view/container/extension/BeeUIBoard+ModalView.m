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

#import "BeeUIBoard+ModalView.h"

#import "UIView+BeeUISignal.h"
#import "UIViewController+BeeUISignal.h"

#import "UIView+UIViewController.h"
#import "UIView+Animation.h"

#import "Bee_UIAnimationBounce.h"

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

@interface BeeUIBoard(ModalViewPrivate)
- (void)didModalMaskTouched;
- (void)didAppearingAnimationDone:(BeeUIAnimation *)anim;
- (void)didDisappearingAnimationDone:(BeeUIAnimation *)anim;
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
	[self presentModalView:view animated:animated animationType:BeeUIAnimationTypeFadeIn];
}

- (void)presentModalView:(UIView *)view animated:(BOOL)animated animationType:(BeeUIAnimationType)type
{
	if ( self.modalView || view.superview == self.view )
		return;
		
	[self sendUISignal:self.MODALVIEW_WILL_SHOW];

	if ( nil == self.modalMask )
	{
		UIButton * maskView = [[[UIButton alloc] initWithFrame:self.view.bounds] autorelease];
		[maskView addTarget:self action:@selector(didModalMaskTouched) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:maskView];

		self.modalMask = maskView;
	}

	self.modalMask.hidden = NO;
	self.modalMask.alpha = 1.0f;
	self.modalMask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f];

	self.modalView = view;
	self.modalView.alpha = 1.0f;
	self.modalView.hidden = NO;
	
	[self.view addSubview:self.modalView];
	[self.view bringSubviewToFront:self.modalMask];
	[self.view bringSubviewToFront:self.modalView];

	if ( animated )
	{
		BeeUIAnimation * anim = [self.modalView animationWithType:type];
		if ( anim )
		{
			anim.duration = 0.3f;
			anim.reversed = NO;
			anim.target = self;
			anim.action = @selector(didAppearingAnimationDone:);

			[anim perform];
		}
		else
		{
			[self didAppearingAnimationDone:nil];
		}
	}
	else
	{

		[self didAppearingAnimationDone:nil];
	}
}

- (void)dismissModalViewAnimated:(BOOL)animated
{
	if ( nil == self.modalView )
		return;
	
	self.modalMask.hidden = NO;
	self.modalView.hidden = NO;

	[self sendUISignal:self.MODALVIEW_WILL_HIDE];

	if ( animated )
	{
		BeeUIAnimationBounce * anim = [self.modalView animationWithType:BeeUIAnimationTypeFadeOut];
		if ( anim )
		{
			anim.duration = 0.3f;
			anim.target = self;
			anim.action = @selector(didDisappearingAnimationDone:);

			[anim perform];
		}
		else
		{
			[self didDisappearingAnimationDone:nil];
		}
	}
	else
	{
		[self didDisappearingAnimationDone:nil];
	}
}

- (void)didAppearingAnimationDone:(BeeUIAnimation *)anim
{
	[self sendUISignal:self.MODALVIEW_DID_SHOWN];
}

- (void)didDisappearingAnimationDone:(BeeUIAnimation *)anim
{
	self.modalMask.alpha = 0.0f;
	self.modalMask.hidden = YES;
	self.modalMask = nil;
	
	self.modalView.alpha = 0.0f;
	self.modalView.hidden = YES;
	self.modalView = nil;

	[self sendUISignal:self.MODALVIEW_DID_HIDDEN];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

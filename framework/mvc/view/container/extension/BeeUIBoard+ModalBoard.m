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

#import "BeeUIBoard+ModalBoard.h"
#import "BeeUIBoard+Traversing.h"

#import "UIView+BeeUISignal.h"
#import "UIView+UIViewController.h"
#import "UIViewController+BeeUISignal.h"

#pragma mark -

#undef	ANIMATION_DURATION
#define	ANIMATION_DURATION			(0.6f)

#undef	KEY_MODAL_BOARD
#define KEY_MODAL_BOARD				"BeeUIBoard.modalBoard"

#pragma mark -

@implementation BeeUIBoard(ModalBoard)

@dynamic modalBoard;

#pragma mark -

- (BeeUIBoard *)modalBoard
{
	return objc_getAssociatedObject( self, KEY_MODAL_BOARD );
}

- (void)setModalBoard:(BeeUIBoard *)board
{
	objc_setAssociatedObject( self, KEY_MODAL_BOARD, board, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

#pragma mark -

- (void)presentModalBoard:(BeeUIBoard *)board animated:(BOOL)animated
{
	if ( self.modalBoard )
		return;
	
	[self sendUISignal:BeeUIBoard.MODALVIEW_WILL_SHOW];
	
	if ( animated )
	{
		CATransition * transition = [CATransition animation];
		[transition setDuration:0.2f];
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//		[transition setType:kCATransitionMoveIn];
//		[transition setSubtype:kCATransitionFromBottom];
		[transition setType:kCATransitionFade];
		[self.view.layer addAnimation:transition forKey:nil];
	}

	self.modalBoard = board;
	self.modalBoard.view.frame = self.view.bounds;
	[self.view addSubview:self.modalBoard.view];

	board.parentBoard = (BeeUIBoard *)self;

	[self sendUISignal:BeeUIBoard.MODALVIEW_DID_SHOWN];
}

- (void)dismissModalBoardAnimated:(BOOL)animated
{
	if ( nil == self.modalBoard )
		return;
	
	[self sendUISignal:BeeUIBoard.MODALVIEW_WILL_HIDE];
	
	if ( animated )
	{
		CATransition * transition = [CATransition animation];
		[transition setDuration:0.2f];
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear]];
//		[transition setType:kCATransitionReveal];
//		[transition setSubtype:kCATransitionFromTop];
		[transition setType:kCATransitionFade];
		[self.view.layer addAnimation:transition forKey:nil];
	}
	
	[self.modalBoard.view removeFromSuperview];
	self.modalBoard.parentBoard = nil;
	self.modalBoard = nil;

	[self sendUISignal:BeeUIBoard.MODALVIEW_DID_HIDDEN];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

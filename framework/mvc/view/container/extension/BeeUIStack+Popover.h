//
//  BeeUIStack+Popover.h
//  PushDemo
//
//  Created by mingchen on 14/11/11.
//  Copyright (c) 2014年 森云软件. All rights reserved.
//

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_UIStack.h"

@interface BeeUIStack (Popover)

AS_SIGNAL( POPOVER_WILL_PRESENT )	// Popover将要显示
AS_SIGNAL( POPOVER_DID_PRESENT )	// Popover已经显示
AS_SIGNAL( POPOVER_WILL_DISMISS )	// Popover将要隐藏
AS_SIGNAL( POPOVER_DID_DISMISSED )	// Popover已经隐藏

@property (nonatomic, retain) UIPopoverController *	popover;

- (void)presentPopoverForView:(UIView *)view
                  contentSize:(CGSize)size
                    direction:(UIPopoverArrowDirection)direction
                     animated:(BOOL)animated;

- (void)dismissPopoverAnimated:(BOOL)animated;

@end

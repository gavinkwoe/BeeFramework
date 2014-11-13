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

#import "BeeUIStack+Popover.h"

#import "UIView+BeeUISignal.h"
#import "UIViewController+BeeUISignal.h"

#pragma mark -

#undef	KEY_POPOVER
#define KEY_POPOVER	"BeeUIStack.popover"

#pragma mark -

@implementation BeeUIStack (Popover)

@dynamic popover;

DEF_SIGNAL( POPOVER_WILL_PRESENT )	// Popover将要显示
DEF_SIGNAL( POPOVER_DID_PRESENT )	// Popover已经显示
DEF_SIGNAL( POPOVER_WILL_DISMISS )	// Popover将要隐藏
DEF_SIGNAL( POPOVER_DID_DISMISSED )	// Popover已经隐藏

#pragma mark -

- (UIPopoverController *)popover
{
    return objc_getAssociatedObject( self, KEY_POPOVER );
}

- (void)setPopover:(UIPopoverController *)popover
{
    objc_setAssociatedObject( self, KEY_POPOVER, popover, OBJC_ASSOCIATION_RETAIN );
}

#pragma mark -

- (void)presentPopoverForView:(UIView *)view
                  contentSize:(CGSize)size
                    direction:(UIPopoverArrowDirection)direction
                     animated:(BOOL)animated
{
    if ( nil == self.popover )
    {
        [self sendUISignal:BeeUIBoard.POPOVER_WILL_PRESENT];
        
        self.view.frame = CGRectMake( 0.0f, 0.0f, size.width, size.height );
        
        if (IOS6_OR_EARLIER)
        {
            self.contentSizeForViewInPopover = size;
        }
        else
        {
            self.preferredContentSize = size;
        }
        
        UIPopoverController * controller = [[[UIPopoverController alloc] initWithContentViewController:self] autorelease];
        [controller setDelegate:(id<UIPopoverControllerDelegate>)self];
        [controller setPopoverContentSize:size];
        [controller presentPopoverFromRect:view.frame
                                    inView:view
                  permittedArrowDirections:0
                                  animated:animated];
        
        self.popover = controller;
        
        [self sendUISignal:BeeUIBoard.POPOVER_DID_PRESENT];
    }
}

- (void)dismissPopoverAnimated:(BOOL)animated
{
    [self.popover dismissPopoverAnimated:animated];
    self.popover = nil;
}

#pragma mark -

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    if ([[self topBoard] isEqual:[[self boards] safeObjectAtIndex:0]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self sendUISignal:BeeUIBoard.POPOVER_DID_DISMISSED];
    self.popover = nil;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

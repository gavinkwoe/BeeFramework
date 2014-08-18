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

#import "Bee_UIAlertView.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

@interface BeeUIAlertView()
{
	UIView *			_parentView;
	NSMutableArray *	_actions;
	NSObject *			_userData;
}
@end

#pragma mark -

@implementation BeeUIAlertView

DEF_SIGNAL( WILL_PRESENT )
DEF_SIGNAL( DID_PRESENT )
DEF_SIGNAL( WILL_DISMISS )
DEF_SIGNAL( DID_DISMISS )

@synthesize parentView = _parentView;
@synthesize userData = _userData;

+ (BeeUIAlertView *)showMessage:(NSString *)message cancelTitle:(NSString *)title
{
	BeeUIAlertView * alert = [[[BeeUIAlertView alloc] init] autorelease];
	[alert setMessage:message];
	[alert addCancelTitle:title];
	[alert show];
	return alert;
}

- (id)init
{
	self = [super init];
//	self = [super initWithTitle:nil message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	if ( self )
	{
		self.delegate = self;
		self.title = nil;

		if ( nil == _actions )
		{
			_actions = [[NSMutableArray alloc] init];
		}
		
//		[self load];
		[self performLoad];
	}
	return self;
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	[_userData release];
	
	[_actions removeAllObjects];
	[_actions release];

	[_parentView release];
	
	[super dealloc];
}

- (void)showInView:(UIView *)view
{
	self.parentView = view;

	[self show];
}

- (void)showInViewController:(UIViewController *)controller
{
	self.parentView = controller.view;

	[self show];
}

- (void)presentForController:(UIViewController *)controller
{
	self.parentView = controller.view;
	
	[self show];
}

- (void)dismissAnimated:(BOOL)animated
{
	[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:animated];
}

- (void)addCancelTitle:(NSString *)title
{
	self.cancelButtonIndex = [self addButtonWithTitle:title];	
}

- (void)addCancelTitle:(NSString *)title signal:(NSString *)signal
{
	[self addCancelTitle:title signal:signal object:nil];
}

- (void)addCancelTitle:(NSString *)title signal:(NSString *)signal object:(id)object
{
	if ( nil == signal )
	{
		signal = @"";
	}
	
	self.cancelButtonIndex = [self addButtonWithTitle:title];
	[_actions addObject:[NSArray arrayWithObjects:title, [NSNumber numberWithInt:self.cancelButtonIndex], signal, object, nil]];
}

- (void)addButtonTitle:(NSString *)title signal:(NSString *)signal
{
	[self addButtonTitle:title signal:signal object:nil];
}

- (void)addButtonTitle:(NSString *)title signal:(NSString *)signal object:(id)object
{
	if ( nil == signal )
	{
		signal = @"";
	}

	NSInteger index = [self addButtonWithTitle:title];
	[_actions addObject:[NSArray arrayWithObjects:title, [NSNumber numberWithInt:index], signal, object, nil]];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//	NSString * selectTitle = [alertView buttonTitleAtIndex:buttonIndex];

	for ( NSArray * array in _actions )
	{
//		NSString * actionTitle = [array objectAtIndex:0];
//		if ( NO == [actionTitle isEqualToString:selectTitle] )
//			continue;

		NSNumber * index = [array objectAtIndex:1];
		if ( [index intValue] == buttonIndex )
		{
			NSString * signal = [array objectAtIndex:2];
			if ( signal && [signal length] )
			{
				NSObject * object = ([array count] >= 4) ? [array objectAtIndex:3] : nil;
				[_parentView sendUISignal:signal
							   withObject:object
									 from:self];
			}
			else if ( buttonIndex != self.cancelButtonIndex )
			{
				[self dismissWithClickedButtonIndex:buttonIndex animated:YES];
			}

			break;
		}
	}
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView
{	
}

// before animation and showing view
- (void)willPresentAlertView:(UIAlertView *)alertView
{
	[self sendUISignal:BeeUIAlertView.WILL_PRESENT
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// after animation
- (void)didPresentAlertView:(UIAlertView *)alertView;
{
	[self sendUISignal:BeeUIAlertView.DID_PRESENT
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// before animation and hiding view
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self sendUISignal:BeeUIAlertView.WILL_DISMISS
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// after animation
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self sendUISignal:BeeUIAlertView.DID_DISMISS
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
	return YES;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

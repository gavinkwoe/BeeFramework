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

#import "Bee_UIActionSheet.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

@interface BeeUIActionSheet()
{
	UIView *				_parentView;
	NSMutableArray *		_actions;
	NSObject *				_userData;
}
@end

#pragma mark -

@implementation BeeUIActionSheet

DEF_SIGNAL( WILL_PRESENT )
DEF_SIGNAL( DID_PRESENT )
DEF_SIGNAL( WILL_DISMISS )
DEF_SIGNAL( DID_DISMISS )

@synthesize parentView = _parentView;
@synthesize userData = _userData;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.delegate = self;
		self.title = nil;
		self.actionSheetStyle = UIActionSheetStyleBlackTranslucent;

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

- (void)showFromToolbar:(UIToolbar *)view
{
	self.parentView = view;
	
	[super showFromToolbar:view];
}

- (void)showFromTabBar:(UITabBar *)view
{
	self.parentView = view;
	
	[super showFromTabBar:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
	if ( item.target && [item.target isKindOfClass:[UIView class]] )
	{
		self.parentView = item.target;
	}
	
	[super showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
	self.parentView = view;
	
	[super showFromRect:rect inView:view animated:animated];
}

- (void)showInView:(UIView *)view
{
	self.parentView = view;
	
	[super showInView:view];
}
			 
- (void)showInViewController:(UIViewController *)controller
{
	[self presentForController:controller];
}

- (void)presentForController:(UIViewController *)controller
{
	self.parentView = controller.view;

	[self showInView:controller.view];
}

- (void)dismissAnimated:(BOOL)animated
{
	[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:animated];
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
	
	if ( nil == object )
	{
		object = [NSDictionary dictionary];
	}

	NSInteger index = [self addButtonWithTitle:title];
	[_actions addObject:[NSArray arrayWithObjects:title, [NSNumber numberWithInt:index], signal, object, nil]];
}

- (void)addCancelTitle:(NSString *)title
{
	self.cancelButtonIndex = [self addButtonWithTitle:title];	
}

- (void)addCancelTitle:(NSString *)title signal:(NSString *)signal object:(id)object
{
	if ( nil == signal )
	{
		signal = @"";
	}
	
	if ( nil == object )
	{
		object = [NSDictionary dictionary];
	}	
	
	self.cancelButtonIndex = [self addButtonWithTitle:title];
	[_actions addObject:[NSArray arrayWithObjects:title, [NSNumber numberWithInt:self.cancelButtonIndex], signal, object, nil]];
}

- (void)addDestructiveTitle:(NSString *)title signal:(NSString *)signal
{
	[self addDestructiveTitle:title signal:signal object:nil];
}

- (void)addDestructiveTitle:(NSString *)title signal:(NSString *)signal object:(id)object
{
	if ( nil == signal )
	{
		signal = @"";
	}
	
	if ( nil == object )
	{
		object = [NSDictionary dictionary];
	}	

	self.destructiveButtonIndex = [self addButtonWithTitle:title];
	[_actions addObject:[NSArray arrayWithObjects:title, [NSNumber numberWithInt:self.destructiveButtonIndex], signal, object, nil]];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//	NSString * selectTitle = [actionSheet buttonTitleAtIndex:buttonIndex];

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
				
				[self sendUISignal:signal
						withObject:object
								to:(_parentView ? _parentView : self)];
			}
			else if ( buttonIndex != self.cancelButtonIndex && buttonIndex != self.destructiveButtonIndex )
			{
				[self dismissWithClickedButtonIndex:buttonIndex animated:YES];
			}

			break;
		}
	}
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{	
}

// before animation and showing view
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
	[self sendUISignal:BeeUIActionSheet.WILL_PRESENT
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// after animation
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	[self sendUISignal:BeeUIActionSheet.DID_PRESENT
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// before animation and hiding view
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self sendUISignal:BeeUIActionSheet.WILL_DISMISS
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

// after animation
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self sendUISignal:BeeUIActionSheet.DID_DISMISS
			withObject:nil
					to:(_parentView ? _parentView : self)];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  Bee_UIActionSheet.m
//

#import "Bee_UIActionSheet.h"
#import "Bee_UISignal.h"

#pragma mark -

@implementation BeeUIActionSheet

DEF_SIGNAL( WILL_PRESENT )
DEF_SIGNAL( DID_PRESENT )
DEF_SIGNAL( WILL_DISMISS )
DEF_SIGNAL( DID_DISMISS )

@synthesize parentController = _parentController;
@synthesize userData = _userData;

+ (BeeUIActionSheet *)spawn
{
	return [[[BeeUIActionSheet alloc] init] autorelease];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.delegate = self;
		self.title = nil;
		self.actionSheetStyle = UIActionSheetStyleBlackTranslucent;

		_actions = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_userData release];
	
	[_actions removeAllObjects];
	[_actions release];
	
	[super dealloc];
}

- (void)presentForController:(UIViewController *)controller
{
	_parentController = controller;

	[self showInView:controller.view];
}

- (void)addButtonTitle:(NSString *)title signal:(NSString *)signal object:(NSObject *)object
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

- (void)addCancelTitle:(NSString *)title signal:(NSString *)signal object:(NSObject *)object
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

- (void)addDestructiveTitle:(NSString *)title signal:(NSString *)signal object:(NSObject *)object
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
				[_parentController sendUISignal:signal
									 withObject:object
										   from:self];
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
	[_parentController sendUISignal:BeeUIActionSheet.WILL_PRESENT withObject:nil from:self];
}

// after animation
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	[_parentController sendUISignal:BeeUIActionSheet.DID_PRESENT withObject:nil from:self];	
}

// before animation and hiding view
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[_parentController sendUISignal:BeeUIActionSheet.WILL_DISMISS withObject:nil from:self];
}

// after animation
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[_parentController sendUISignal:BeeUIActionSheet.DID_DISMISS withObject:nil from:self];
}

@end

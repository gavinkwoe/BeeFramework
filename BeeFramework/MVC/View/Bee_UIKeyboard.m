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
//  Bee_UIKeyboard.m
//

#import <UIKit/UIKit.h>
#import "Bee_UIKeyboard.h"
#import "Bee_UISignal.h"

#pragma mark -

#if defined(__IPHONE_5_0)
UIKIT_EXTERN
NSString * const UIKeyboardWillChangeFrameNotification;
#else
NSString * const UIKeyboardWillChangeFrameNotification = @"UIKeyboardWillChangeFrameNotification";
#endif

#undef	DEFAULT_KEYBOARD_HEIGHT
#define	DEFAULT_KEYBOARD_HEIGHT	(216.0f)

#pragma mark -

@implementation BeeUIKeyboard

DEF_SINGLETON( BeeUIKeyboard )

DEF_NOTIFICATION( SHOWN );
DEF_NOTIFICATION( HIDDEN );
DEF_NOTIFICATION( HEIGHT_CHANGED );

@synthesize shown = _shown;
@synthesize height = _height;

- (id)init
{
	self = [super init];
	if (self)
	{
		_shown = NO;
		_height = DEFAULT_KEYBOARD_HEIGHT;

		_accessorFrame = CGRectZero;
		_accessor = nil;
		
		[self observeNotification:UIKeyboardDidShowNotification];
		[self observeNotification:UIKeyboardDidHideNotification];
		[self observeNotification:UIKeyboardWillChangeFrameNotification];
	}
	return self;
}

- (void)handleNotification:(NSNotification *)notification
{
	BOOL animated = YES;
	
	if ( [notification is:UIKeyboardDidShowNotification] )
	{			
		if ( NO == _shown )
		{
			_shown = YES;
			[self postNotification:BeeUIKeyboard.SHOWN];
		}		
		
		NSValue * value = [(NSDictionary *)[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
		if ( value )
		{
			CGRect keyboardEndFrame = [value CGRectValue];
			CGFloat _keyboardHeight = ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) ? keyboardEndFrame.size.height : keyboardEndFrame.size.width;
			if ( _keyboardHeight != _height )
			{
				_height = _keyboardHeight;
				[self postNotification:BeeUIKeyboard.HEIGHT_CHANGED];
				
				animated = NO;
			}
		}
	}
	else if ( [notification is:UIKeyboardWillChangeFrameNotification] )
	{
#if 0
		NSValue * value1 = [(NSDictionary *)[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];		
		NSValue * value2 = [(NSDictionary *)[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];		
		if ( value1 && value2 )
		{
			CGRect rect1 = [value1 CGRectValue];
			CGRect rect2 = [value2 CGRectValue];

			if ( rect1.origin.y >= [UIScreen mainScreen].bounds.size.height )
			{
				if ( NO == _shown )
				{
					_shown = YES;
					[self postNotification:BeeUIKeyboard.SHOWN];
				}
			
				if ( rect2.size.height != _height )
				{
					_height = rect2.size.height;
					[self postNotification:BeeUIKeyboard.HEIGHT_CHANGED];
				}
			}
			else if ( rect2.origin.y >= [UIScreen mainScreen].bounds.size.height )
			{
				if ( rect2.size.height != _height )
				{
					_height = rect2.size.height;
					[self postNotification:BeeUIKeyboard.HEIGHT_CHANGED];
				}

				if ( _shown )
				{
					_shown = NO;
					[self postNotification:BeeUIKeyboard.HIDDEN];		
				}
			}
		}
#endif		
	}
	else if ( [notification is:UIKeyboardDidHideNotification] )
	{
		if ( _shown )
		{
			_shown = NO;		
		}
		
		NSValue * value = [(NSDictionary *)[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
		if ( value )
		{
			CGRect keyboardEndFrame = [value CGRectValue];
			CGFloat _keyboardHeight = ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) ? keyboardEndFrame.size.height : keyboardEndFrame.size.width;
			if ( _keyboardHeight != _height )
			{
				_height = _keyboardHeight;
			//	[self postNotification:BeeUIKeyboard.HEIGHT_CHANGED];
				animated = NO;
			}
		}
		
		[self postNotification:BeeUIKeyboard.HIDDEN];
	}

	[self updateAccessorAnimated:animated];
}

- (void)dealloc
{
	[self unobserveAllNotifications];

    [super dealloc];
}

- (void)showAccessor:(UIView *)view animated:(BOOL)animated
{
	_accessor = view;
	_accessorFrame = view.frame;
	
	[self updateAccessorAnimated:animated];
}

- (void)hideAccessor:(UIView *)view animated:(BOOL)animated
{
	if ( _accessor == view )
	{	
		BOOL isShown = _shown;
		
		_shown = NO;
		[self updateAccessorAnimated:animated];
		_shown = isShown;
		
		_accessor = nil;
		_accessorFrame = CGRectZero;
	}
}

- (void)updateAccessorAnimated:(BOOL)animated
{
	if ( nil == _accessor )
		return;
	
	if ( animated )
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.25f];
		[UIView setAnimationBeginsFromCurrentState:YES];
	}
	
	if ( _shown )
	{
		CGFloat containerHeight = _accessor.superview.bounds.size.height;
		CGRect newFrame = _accessorFrame;
		newFrame.origin.y = containerHeight - (_accessorFrame.size.height + _height);
		_accessor.frame = newFrame;
	}
	else
	{
		_accessor.frame = _accessorFrame;
	}

	if ( animated )
	{
		[UIView commitAnimations];
	}
}

@end

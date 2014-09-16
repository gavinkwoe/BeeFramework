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

#import "Bee_Precompile.h"
#import "Bee_UIKeyboard.h"
#import "Bee_UISignal.h"

#pragma mark -

#undef	DEFAULT_KEYBOARD_HEIGHT
#define	DEFAULT_KEYBOARD_HEIGHT	(216.0f)

#pragma mark -

DEF_PACKAGE( BeePackage_UI, BeeUIKeyboard, keyboard );

#pragma mark -

@interface BeeUIKeyboard()
{
	BOOL		_shown;
	BOOL		_animating;
	CGFloat		_height;
	
	CGRect		_accessorFrame;
	UIView *	_accessor;
	
	NSTimeInterval			_animationDuration;
	UIViewAnimationCurve	_animationCurve;
}
@end

#pragma mark -

@implementation BeeUIKeyboard

DEF_SINGLETON( BeeUIKeyboard )

DEF_NOTIFICATION( SHOWN );
DEF_NOTIFICATION( HIDDEN );
DEF_NOTIFICATION( HEIGHT_CHANGED );

@synthesize shown = _shown;
@synthesize animating = _animating;
@synthesize height = _height;
@synthesize accessor = _accessor;

@synthesize animationDuration = _animationDuration;
@synthesize animationCurve = _animationCurve;

+ (BOOL)autoLoad
{
    [BeeUIKeyboard sharedInstance];
	return YES;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		_shown = NO;
		_animating = NO;
		_height = DEFAULT_KEYBOARD_HEIGHT;

		_accessorFrame = CGRectZero;
		_accessor = nil;

		[self observeNotification:UIKeyboardDidShowNotification];
		[self observeNotification:UIKeyboardDidHideNotification];
		[self observeNotification:@"UIKeyboardWillChangeFrameNotification"];
	}
	return self;
}

- (void)handleNotification:(NSNotification *)notification
{
	BOOL animated = YES;
	
	NSDictionary * userInfo = (NSDictionary *)[notification userInfo];
	if ( userInfo )
	{
		[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_animationCurve];
		[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_animationDuration];	
	}
	
	if ( [notification is:UIKeyboardDidShowNotification] )
	{
		if ( NO == _shown )
		{
			_shown = YES;
			[self postNotification:self.SHOWN];
		}		
		
		NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
		if ( value )
		{
			CGRect	keyboardEndFrame = [value CGRectValue];
//			CGFloat	keyboardHeight = ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) ? keyboardEndFrame.size.height : keyboardEndFrame.size.width;
			CGFloat	keyboardHeight = keyboardEndFrame.size.height;
			
			if ( keyboardHeight != _height )
			{
				_height = keyboardHeight;
				
				[self postNotification:self.HEIGHT_CHANGED];
				animated = NO;
			}
		}
	}
	else if ( [notification is:@"UIKeyboardWillChangeFrameNotification"] )
	{
		NSValue * value1 = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];		
		NSValue * value2 = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];		
		if ( value1 && value2 )
		{
			CGRect rect1 = [value1 CGRectValue];
			CGRect rect2 = [value2 CGRectValue];

			if ( rect1.origin.y >= [UIScreen mainScreen].bounds.size.height )
			{
				if ( NO == _shown )
				{
					_shown = YES;
					[self postNotification:self.SHOWN];
				}
			
				if ( rect2.size.height != _height )
				{
					_height = rect2.size.height;
					[self postNotification:self.HEIGHT_CHANGED];
				}
			}
			else if ( rect2.origin.y >= [UIScreen mainScreen].bounds.size.height )
			{
				if ( rect2.size.height != _height )
				{
					_height = rect2.size.height;
					[self postNotification:self.HEIGHT_CHANGED];
				}

				if ( _shown )
				{
					_shown = NO;
					
					[self postNotification:self.HIDDEN];
				}
			}
		}
	}
	else if ( [notification is:UIKeyboardDidHideNotification] )
	{
		NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
		if ( value )
		{
			CGRect	keyboardEndFrame = [value CGRectValue];
//			CGFloat	keyboardHeight = ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) ? keyboardEndFrame.size.height : keyboardEndFrame.size.width;
			CGFloat	keyboardHeight = keyboardEndFrame.size.height;
			
			if ( keyboardHeight != _height )
			{
				_height = keyboardHeight;
				
			//	[self postNotification:self.HEIGHT_CHANGED];
				animated = NO;
			}
		}
	
		if ( _shown )
		{
			_shown = NO;
			
			[self postNotification:self.HIDDEN];
		}
	}

	[self updateAccessorAnimated:animated];
}

- (void)dealloc
{
	[self unobserveAllNotifications];

    [super dealloc];
}

- (void)setAccessor:(UIView *)view
{
	_accessor = view;
	_accessorFrame = view.frame;
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
		[UIView setAnimationDuration:_animationDuration];
		[UIView setAnimationCurve:_animationCurve];
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

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

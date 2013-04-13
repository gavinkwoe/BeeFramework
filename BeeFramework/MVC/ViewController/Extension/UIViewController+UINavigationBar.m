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
//  Bee_UIBoard.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Log.h"
#import "Bee_UISignal.h"
#import "UIViewController+UINavigationBar.h"
#import "UIViewController+BeeUISignal.h"

#pragma mark -

@implementation UINavigationBar(UINavigationBar)

DEF_SIGNAL( BACK_BUTTON_TOUCHED )
DEF_SIGNAL( DONE_BUTTON_TOUCHED )

DEF_INT( BARBUTTON_LEFT,	0 )
DEF_INT( BARBUTTON_RIGHT,	1 )

@end

#pragma mark -

@interface UIViewController(UINavigationBarPrivate)
- (void)didLeftBarButtonTouched;
- (void)didRightBarButtonTouched;
@end

#pragma mark -

@implementation UIViewController(UINavigationBar)

- (void)showNavigationBarAnimated:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)hideNavigationBarAnimated:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didLeftBarButtonTouched
{
	[self sendUISignal:UINavigationBar.BACK_BUTTON_TOUCHED];
}

- (void)didRightBarButtonTouched
{
	[self sendUISignal:UINavigationBar.DONE_BUTTON_TOUCHED];
}

- (void)showBarButton:(NSInteger)position title:(NSString *)name
{
	if ( UINavigationBar.BARBUTTON_LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:name
																				  style:UIBarButtonItemStylePlain
																				 target:self
																				 action:@selector(didLeftBarButtonTouched)] autorelease];
	}
	else
	{
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:name
																				   style:UIBarButtonItemStylePlain
																				  target:self
																				  action:@selector(didRightBarButtonTouched)] autorelease];
	}
}

- (void)showBarButton:(NSInteger)position image:(UIImage *)image
{
	CGRect buttonFrame = CGRectMake(0, 0, image.size.width + 10.0f, self.navigationController.navigationBar.frame.size.height);

	if ( buttonFrame.size.width <= 24.0f )
	{
		buttonFrame.size.width = 24.0f;
	}

	if ( buttonFrame.size.height <= 24.0f )
	{
		buttonFrame.size.height = 24.0f;
	}

	UIButton * button = [[[UIButton alloc] initWithFrame:buttonFrame] autorelease];
	button.contentMode = UIViewContentModeScaleAspectFit;
	button.backgroundColor = [UIColor clearColor];
	[button setImage:image forState:UIControlStateNormal];

	if ( UINavigationBar.BARBUTTON_LEFT == position )
	{
		[button addTarget:self action:@selector(didLeftBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	}
	else
	{
		[button addTarget:self action:@selector(didRightBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	}
}

- (void)showBarButton:(NSInteger)position system:(UIBarButtonSystemItem)index
{
	if ( UINavigationBar.BARBUTTON_LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
																							   target:self
																							   action:@selector(didLeftBarButtonTouched)] autorelease];
	}
	else
	{
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
																								target:self
																								action:@selector(didRightBarButtonTouched)] autorelease];
	}		
}

- (void)showBarButton:(NSInteger)position custom:(UIView *)view
{
	if ( UINavigationBar.BARBUTTON_LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
	}
	else
	{
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
	}
}

- (void)hideBarButton:(NSInteger)position
{
	if ( UINavigationBar.BARBUTTON_LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = nil;
	}
	else
	{
		self.navigationItem.rightBarButtonItem = nil;
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

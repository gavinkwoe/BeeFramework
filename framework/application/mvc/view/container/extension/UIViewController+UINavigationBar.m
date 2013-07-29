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

#import "UIViewController+UINavigationBar.h"
#import "UIViewController+BeeUISignal.h"
#import "Bee_UINavigationBar.h"
#import "Bee_UISignal.h"
#import "Bee_UIButton.h"
#import "Bee_UIImageView.h"
#import "UIImage+Theme.h"

#pragma mark -

#undef	BUTTON_MIN_WIDTH
#define	BUTTON_MIN_WIDTH	(24.0f)

#undef	BUTTON_MIN_HEIGHT
#define	BUTTON_MIN_HEIGHT	(24.0f)

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
	[self sendUISignal:BeeUINavigationBar.LEFT_TOUCHED];
}

- (void)didRightBarButtonTouched
{
	[self sendUISignal:BeeUINavigationBar.RIGHT_TOUCHED];
}

- (void)showBarButton:(NSInteger)position title:(NSString *)name
{
	if ( BeeUINavigationBar.LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:name
																				  style:UIBarButtonItemStylePlain
																				 target:self
																				 action:@selector(didLeftBarButtonTouched)] autorelease];
	}
	else if ( BeeUINavigationBar.RIGHT == position )
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

	if ( buttonFrame.size.width <= BUTTON_MIN_WIDTH )
	{
		buttonFrame.size.width = BUTTON_MIN_WIDTH;
	}

	if ( buttonFrame.size.height <= BUTTON_MIN_HEIGHT )
	{
		buttonFrame.size.height = BUTTON_MIN_HEIGHT;
	}

	BeeUIButton * button = [[[BeeUIButton alloc] initWithFrame:buttonFrame] autorelease];
	button.contentMode = UIViewContentModeScaleAspectFit;
	button.backgroundColor = [UIColor clearColor];
	button.titleFont = [UIFont boldSystemFontOfSize:13.0f];
	button.titleColor = [UIColor whiteColor];
	button.titleShadowColor = [UIColor darkGrayColor];
	button.image = image;

	if ( BeeUINavigationBar.LEFT == position )
	{
		[button addTarget:self action:@selector(didLeftBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	}
	else if ( BeeUINavigationBar.RIGHT == position )
	{
		[button addTarget:self action:@selector(didRightBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	}
}

- (void)showBarButton:(NSInteger)position image:(UIImage *)image image:(UIImage *)image2
{
	[self showBarButton:position image:[image merge:image2]];
}

- (void)showBarButton:(NSInteger)position title:(NSString *)title image:(UIImage *)image
{
	CGRect buttonFrame = CGRectMake(0, 0, image.size.width + 10.0f, self.navigationController.navigationBar.frame.size.height);
	
	if ( buttonFrame.size.width <= BUTTON_MIN_WIDTH )
	{
		buttonFrame.size.width = BUTTON_MIN_WIDTH;
	}
	
	if ( buttonFrame.size.height <= BUTTON_MIN_HEIGHT )
	{
		buttonFrame.size.height = BUTTON_MIN_HEIGHT;
	}

	BeeUIButton * button = [[[BeeUIButton alloc] initWithFrame:buttonFrame] autorelease];
	button.contentMode = UIViewContentModeScaleAspectFit;
	button.backgroundColor = [UIColor clearColor];
	button.image = image;
	button.title = title;
	button.titleFont = [UIFont boldSystemFontOfSize:13.0f];
	button.titleColor = [UIColor whiteColor];
	button.titleShadowColor = [UIColor darkGrayColor];
	
	if ( BeeUINavigationBar.LEFT == position )
	{
		[button addTarget:self action:@selector(didLeftBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	}
	else if ( BeeUINavigationBar.RIGHT == position )
	{
		[button addTarget:self action:@selector(didRightBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	}
}

- (void)showBarButton:(NSInteger)position system:(UIBarButtonSystemItem)index
{
	if ( BeeUINavigationBar.LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
																							   target:self
																							   action:@selector(didLeftBarButtonTouched)] autorelease];
	}
	else if ( BeeUINavigationBar.RIGHT == position )
	{
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
																								target:self
																								action:@selector(didRightBarButtonTouched)] autorelease];
	}		
}

- (void)showBarButton:(NSInteger)position custom:(UIView *)view
{
	if ( BeeUINavigationBar.LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
	}
	else if ( BeeUINavigationBar.RIGHT == position )
	{
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
	}
}

- (void)hideBarButton:(NSInteger)position
{
	if ( BeeUINavigationBar.LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = nil;
	}
	else if ( BeeUINavigationBar.RIGHT == position )
	{
		self.navigationItem.rightBarButtonItem = nil;
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

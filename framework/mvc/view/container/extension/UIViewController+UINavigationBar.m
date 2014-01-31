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

#import "UIViewController+UINavigationBar.h"
#import "UIViewController+BeeUISignal.h"
#import "Bee_UINavigationBar.h"
#import "Bee_UISignal.h"
#import "Bee_UIMetrics.h"
#import "Bee_UIButton.h"
#import "Bee_UIImageView.h"
#import "Bee_UICapability.h"
#import "UIImage+BeeExtension.h"

#pragma mark -

#undef	BUTTON_MIN_WIDTH
#define	BUTTON_MIN_WIDTH	(34.0f)

#undef	BUTTON_MIN_HEIGHT
#define	BUTTON_MIN_HEIGHT	(34.0f)

#pragma mark -

@interface UIViewController(UINavigationBarPrivate)
- (void)didLeftBarButtonTouched;
- (void)didRightBarButtonTouched;

- (void)setBarButton:(id)content position:(NSUInteger)position;
@end

#pragma mark -

@implementation UIViewController(UINavigationBar)

@dynamic leftBarButton;
@dynamic rightBarButton;

@dynamic navigationBarShown;
@dynamic navigationBarLeft;
@dynamic navigationBarRight;

- (void)showNavigationBarAnimated:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)hideNavigationBarAnimated:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (BOOL)navigationBarShown
{
	return self.navigationController.navigationBarHidden ? NO : YES;
}

- (void)setNavigationBarShown:(BOOL)flag
{
	if ( [self isViewLoaded] && self.view.window )
	{
		if ( flag )
		{
			[self showNavigationBarAnimated:YES];
		}
		else
		{
			[self hideNavigationBarAnimated:YES];
		}
	}
	else
	{
		if ( flag )
		{
			[self showNavigationBarAnimated:NO];
		}
		else
		{
			[self hideNavigationBarAnimated:NO];
		}
	}
}

- (void)setNavigationBarLeft:(id)content
{
	[self setBarButton:content position:BeeUINavigationBar.LEFT];
}

- (void)setNavigationBarRight:(id)content
{
	[self setBarButton:content position:BeeUINavigationBar.RIGHT];
}

- (void)setBarButton:(id)content position:(NSUInteger)position
{
	if ( nil == content )
	{
		[self hideBarButton:position];
	}
	else
	{
		if ( [content isKindOfClass:[NSString class]] )
		{
			[self showBarButton:position title:(NSString *)content];
		}
		else if ( [content isKindOfClass:[UIImage class]] )
		{
			[self showBarButton:position image:(UIImage *)content];
		}
		else if ( [content isKindOfClass:[NSNumber class]] )
		{
			[self showBarButton:position system:(UIBarButtonSystemItem)[content intValue]];
		}
		else if ( [content isKindOfClass:[UIView class]] )
		{
			[self showBarButton:position custom:(UIView *)content];
		}
		else if ( [content isKindOfClass:[UIViewController class]] )
		{
			[self showBarButton:position custom:((UIViewController *)content).view];
		}
		else if ( [content isKindOfClass:[NSArray class]] )
		{
			NSString *	title = nil;
			UIImage *	image = nil;
			
			for ( id obj in (NSArray *)content )
			{
				if ( [obj isKindOfClass:[NSString class]] )
				{
					title = obj;
				}
				else if ( [obj isKindOfClass:[UIImage class]] )
				{
					if ( image )
					{
						image = [image merge:obj];
					}
					else
					{
						image = obj;
					}
				}
			}
			
			if ( title && image )
			{
				[self showBarButton:position title:title image:image];
			}
			else if ( title )
			{
				[self showBarButton:position title:title];
			}
			else if ( image )
			{
				[self showBarButton:position image:image];
			}
		}
	}
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
	CGRect buttonFrame = CGRectZero;
	
	if ( NO == CGSizeEqualToSize( [BeeUINavigationBar buttonSize], CGSizeZero ) )
	{
		buttonFrame = CGSizeMakeBound( [BeeUINavigationBar buttonSize] );
	}
	else
	{
		CGSize barSize = self.navigationController.navigationBar.frame.size;
		CGSize titleSize = [name sizeWithFont:[UIFont systemFontOfSize:13.0f] byHeight:barSize.height];

		if ( IOS7_OR_LATER )
		{
			buttonFrame = CGRectMake(0, 0, titleSize.width, barSize.height);
		}
		else
		{
			buttonFrame = CGRectMake(0, 0, titleSize.width + 10.0f, barSize.height);
		}

		if ( buttonFrame.size.width <= BUTTON_MIN_WIDTH )
		{
			buttonFrame.size.width = BUTTON_MIN_WIDTH;
		}
		
		if ( buttonFrame.size.height <= BUTTON_MIN_HEIGHT )
		{
			buttonFrame.size.height = BUTTON_MIN_HEIGHT;
		}
	}
	
	BeeUIButton * button = [[[BeeUIButton alloc] initWithFrame:buttonFrame] autorelease];
	button.contentMode = UIViewContentModeScaleAspectFit;
	button.backgroundColor = [UIColor clearColor];
	button.titleFont = [UIFont systemFontOfSize:13.0f];
	button.titleColor = [UIColor whiteColor];
	button.titleShadowColor = [UIColor darkGrayColor];
	button.title = name;
	
	if ( BeeUINavigationBar.LEFT == position )
	{
		[button addTarget:self action:@selector(didLeftBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
		self.navigationItem.leftBarButtonItem.width = buttonFrame.size.width;
	}
	else if ( BeeUINavigationBar.RIGHT == position )
	{
		[button addTarget:self action:@selector(didRightBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
		self.navigationItem.rightBarButtonItem.width = buttonFrame.size.width;
	}
}

- (void)showBarButton:(NSInteger)position image:(UIImage *)image
{
	CGRect buttonFrame = CGRectZero;
	
	if ( NO == CGSizeEqualToSize( [BeeUINavigationBar buttonSize], CGSizeZero ) )
	{
		buttonFrame = CGSizeMakeBound( [BeeUINavigationBar buttonSize] );
	}
	else
	{
		CGSize barSize = self.navigationController.navigationBar.frame.size;

		if ( IOS7_OR_LATER )
		{
			buttonFrame = CGRectMake(0, 0, image.size.width, barSize.height);
		}
		else
		{
			buttonFrame = CGRectMake(0, 0, image.size.width + 10.0f, barSize.height);
		}

		if ( buttonFrame.size.width <= BUTTON_MIN_WIDTH )
		{
			buttonFrame.size.width = BUTTON_MIN_WIDTH;
		}
		
		if ( buttonFrame.size.height <= BUTTON_MIN_HEIGHT )
		{
			buttonFrame.size.height = BUTTON_MIN_HEIGHT;
		}
	}
	
	BeeUIButton * button = [[[BeeUIButton alloc] initWithFrame:buttonFrame] autorelease];
	button.contentMode = UIViewContentModeScaleAspectFit;
	button.backgroundColor = [UIColor clearColor];
	button.titleFont = [UIFont systemFontOfSize:13.0f];
	button.titleColor = [UIColor whiteColor];
	button.titleShadowColor = [UIColor darkGrayColor];
	button.image = image;

	if ( BeeUINavigationBar.LEFT == position )
	{
		[button addTarget:self action:@selector(didLeftBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
		self.navigationItem.leftBarButtonItem.width = buttonFrame.size.width;
	}
	else if ( BeeUINavigationBar.RIGHT == position )
	{
		[button addTarget:self action:@selector(didRightBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
		self.navigationItem.rightBarButtonItem.width = buttonFrame.size.width;
	}
}

- (void)showBarButton:(NSInteger)position image:(UIImage *)image image:(UIImage *)image2
{
	[self showBarButton:position image:[image merge:image2]];
}

- (void)showBarButton:(NSInteger)position title:(NSString *)title image:(UIImage *)image
{
	CGRect buttonFrame = CGRectZero;

	if ( NO == CGSizeEqualToSize( [BeeUINavigationBar buttonSize], CGSizeZero ) )
	{
		buttonFrame = CGSizeMakeBound( [BeeUINavigationBar buttonSize] );
	}
	else
	{
		CGSize barSize = self.navigationController.navigationBar.frame.size;
		CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:13.0f] byHeight:barSize.height];

		if ( IOS7_OR_LATER )
		{
			buttonFrame = CGRectMake(0, 0, fmaxf( titleSize.width, image.size.width ), barSize.height);
		}
		else
		{
			buttonFrame = CGRectMake(0, 0, fmaxf( titleSize.width + 10.0f, image.size.width + 10.0f ), barSize.height);
		}

		if ( buttonFrame.size.width <= BUTTON_MIN_WIDTH )
		{
			buttonFrame.size.width = BUTTON_MIN_WIDTH;
		}

		if ( buttonFrame.size.height <= BUTTON_MIN_HEIGHT )
		{
			buttonFrame.size.height = BUTTON_MIN_HEIGHT;
		}
	}

	BeeUIButton * button = [[[BeeUIButton alloc] initWithFrame:buttonFrame] autorelease];
	button.contentMode = UIViewContentModeScaleAspectFit;
	button.backgroundColor = [UIColor clearColor];
	button.image = image;
	button.title = title;
	button.titleFont = [UIFont systemFontOfSize:13.0f];
	button.titleColor = [UIColor whiteColor];
	button.titleShadowColor = [UIColor darkGrayColor];

	if ( BeeUINavigationBar.LEFT == position )
	{
		[button addTarget:self action:@selector(didLeftBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
		self.navigationItem.leftBarButtonItem.width = buttonFrame.size.width;
	}
	else if ( BeeUINavigationBar.RIGHT == position )
	{
		[button addTarget:self action:@selector(didRightBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
		self.navigationItem.rightBarButtonItem.width = buttonFrame.size.width;
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
	if ( view )
	{
		CGRect buttonFrame = CGRectZero;

		if ( NO == CGSizeEqualToSize( [BeeUINavigationBar buttonSize], CGSizeZero ) )
		{
			buttonFrame = CGSizeMakeBound( [BeeUINavigationBar buttonSize] );
		}
		else
		{
			CGSize barSize = self.navigationController.navigationBar.frame.size;
			CGSize buttonSize = [[view class] estimateUISizeByBound:CGSizeMake(BUTTON_MIN_WIDTH, BUTTON_MIN_HEIGHT) forData:nil];

			if ( IOS7_OR_LATER )
			{
				buttonFrame = CGRectMake(0, 0, buttonSize.width, fminf(barSize.height, buttonSize.height));
			}
			else
			{
				buttonFrame = CGRectMake(0, 0, buttonSize.width, fminf(barSize.height, buttonSize.height));
			}

			if ( buttonFrame.size.width <= BUTTON_MIN_WIDTH )
			{
				buttonFrame.size.width = BUTTON_MIN_WIDTH;
			}
			
			if ( buttonFrame.size.height <= BUTTON_MIN_HEIGHT )
			{
				buttonFrame.size.height = BUTTON_MIN_HEIGHT;
			}
		}

		view.frame = buttonFrame;

		if ( BeeUINavigationBar.LEFT == position )
		{
			self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
			self.navigationItem.leftBarButtonItem.width = buttonFrame.size.width;
		}
		else if ( BeeUINavigationBar.RIGHT == position )
		{
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
			self.navigationItem.rightBarButtonItem.width = buttonFrame.size.width;
		}
	}
	else
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

- (UIView *)leftBarButton
{
	return self.navigationItem.leftBarButtonItem.customView;
}

- (UIView *)rightBarButton
{
	return self.navigationItem.rightBarButtonItem.customView;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

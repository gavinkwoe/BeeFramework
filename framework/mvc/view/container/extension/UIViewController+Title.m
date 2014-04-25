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

#import "UIViewController+Title.h"
#import "UIView+UIViewController.h"

#pragma mark -

@implementation UIViewController(Title)

@dynamic titleString;
@dynamic titleImage;
@dynamic titleView;
@dynamic titleViewController;

@dynamic navigationBarTitle;

- (NSString *)titleString
{
	return self.navigationItem.title ? self.navigationItem.title : self.title;
}

- (void)setTitleString:(NSString *)text
{
	self.navigationItem.title = text;
}

- (UIImage *)titleImage
{
	UIImageView * imageView = (UIImageView *)self.navigationItem.titleView;
	if ( imageView && [imageView isKindOfClass:[UIImageView class]] )
	{
		return imageView.image;
	}
	
	return nil;
}

- (void)setTitleImage:(UIImage *)image
{
	UIImageView * imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.navigationItem.titleView = imageView;
}

- (UIView *)titleView
{
	return self.navigationItem.titleView;
}

- (void)setTitleView:(UIView *)view
{
	self.navigationItem.titleView = view;
}

- (UIViewController *)titleViewController
{
	if ( nil == self.navigationItem.titleView )
		return nil;

	return [self.navigationItem.titleView viewController];
}

- (void)setTitleViewController:(UIViewController *)vc
{
	if ( vc )
	{
		self.navigationItem.titleView = vc.view;
	}
	else
	{
		self.navigationItem.titleView = nil;
	}
}

- (void)setNavigationBarTitle:(id)content
{
	if ( content )
	{
		if ( [content isKindOfClass:[NSString class]] )
		{
			[self setTitleString:content];
		}
		else if ( [content isKindOfClass:[UIImage class]] )
		{
			[self setTitleImage:content];
		}
		else if ( [content isKindOfClass:[UIView class]] )
		{
			[self setTitleView:content];
		}
		else if ( [content isKindOfClass:[UIViewController class]] )
		{
			[self setTitleViewController:content];
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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
//  UIView+BeeBackground.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "UIView+BeeExtension.h"
#import "UIViewController+BeeExtension.h"
#include <objc/runtime.h>
#include <execinfo.h>

#pragma mark -

@implementation UIViewController(BeeExtension)

@dynamic titleString;
@dynamic titleView;

- (NSString *)titleString
{
	return self.navigationItem.title ? self.navigationItem.title : self.title;
}

- (void)setTitleString:(NSString *)text
{
	self.navigationItem.title = text;
}

- (UIView *)titleView
{
	return self.navigationItem.titleView;
}

- (void)setTitleView:(UIView *)view
{
	self.navigationItem.titleView = view;
}

- (UIView *)viewIfLoaded
{
	if ( NO == self.isViewLoaded )
		return nil;
	
	return self.view;
}

- (UIView *)viewWithTagString:(NSString *)value
{
	if ( NO == self.isViewLoaded )
		return nil;
	
	return [self.view viewWithTagString:value];
}

- (UIView *)viewAtPath:(NSString *)path
{
	if ( NO == self.isViewLoaded )
		return nil;
	
	return [self.view viewAtPath:path];
}

- (UIView *)subview:(NSString *)name
{
	if ( NO == self.isViewLoaded )
		return nil;
	
	return [self.view subview:name];
}

- (CGRect)viewFrame
{
	CGRect bounds = [UIScreen mainScreen].bounds;
	
//	UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
//	CGRect applicationframe = [UIScreen mainScreen].applicationFrame;
	
	if ( UIInterfaceOrientationIsLandscape(self.interfaceOrientation) )
	{
		bounds.origin = CGPointMake( bounds.origin.y, bounds.origin.x );
		bounds.size = CGSizeMake( bounds.size.height, bounds.size.width );
	}
	
	if ( NO == [UIApplication sharedApplication].statusBarHidden )
	{
		bounds.origin.y += 20;
		bounds.size.height -= 20;
	}
	
	if ( NO == self.navigationController.navigationBarHidden )
	{
		bounds.size.height -= self.navigationController.navigationBar.bounds.size.height;
	}
	
	return bounds;
}

- (CGRect)viewBound
{
	CGRect bound = self.viewFrame;
	bound.origin = CGPointZero;
	return bound;
}

- (CGSize)viewSize
{
	return self.viewFrame.size;
}

- (CGFloat)viewWidth
{
	return self.viewFrame.size.width;
}

- (CGFloat)viewHeight
{
	return self.viewFrame.size.height;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "Bee_UIWindow.h"

#import "NSObject+BeeMessage.h"
#import "NSObject+BeeHTTPRequest.h"

#import "UIView+Manipulation.h"
#import "UIView+BeeUISignal.h"
#import "UIView+UIViewController.h"
#import "UIViewController+BeeUISignal.h"
#import "UIViewController+LifeCycle.h"
#import "UIViewController+Traversing.h"

#import "Bee_UINavigationBar.h"
#import "Bee_UITemplate.h"
#import "UIView+BeeUITemplate.h"

#import "UIView+SwipeGesture.h"
#import "UIView+UINavigationController.h"

#import "UIViewController+BeeUITemplate.h"
#import "UIViewController+UINavigationController.h"

#import "Bee_UILayout.h"
#import "UIView+BeeUILayout.h"
#import "UIView+BeeUISignal.h"

#import "Bee_UICapability.h"
#import "NSObject+UIPropertyMapping.h"

#pragma mark -

@interface BeeUIWindow()
{
	BOOL	_inited;
}

- (void)initSelf;

@end

#pragma mark -

@implementation BeeUIWindow

IS_CONTAINABLE( YES )

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)initSelf
{
	if ( NO == _inited )
	{
		[self applyTransform];
		[self applyFrame];

		_inited = YES;

//		[self load];
		[self performLoad];
	}
}

//- (void)setFrame:(CGRect)frame
//{
//	[super setFrame:frame];
//	[self applyTransform];
//}

//- (void)layoutSubviews
//{
//	[super layoutSubviews];
//	[self applyTransform];
//}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	[super dealloc];
}

- (void)applyFrame
{
	UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
	if ( UIInterfaceOrientationPortraitUpsideDown == orient )
	{
		CGRect windowFrame;
		windowFrame.origin.x = 0.0f;
		windowFrame.origin.y = 0.0f;
		windowFrame.size.width = [UIScreen mainScreen].bounds.size.height;
		windowFrame.size.height = [UIScreen mainScreen].bounds.size.width;
		self.frame = [UIScreen mainScreen].bounds;
	}
	else if ( UIInterfaceOrientationLandscapeLeft == orient )
	{
		CGRect windowFrame;
		windowFrame.size.width = [UIScreen mainScreen].bounds.size.height;
		windowFrame.size.height = [UIScreen mainScreen].bounds.size.width;
		windowFrame.origin.x = 0.0f;
		windowFrame.origin.y = windowFrame.size.width - windowFrame.size.height;
		self.frame = windowFrame;
	}
	else if ( UIInterfaceOrientationLandscapeRight == orient )
	{
		CGRect windowFrame;
		windowFrame.size.width = [UIScreen mainScreen].bounds.size.height;
		windowFrame.size.height = [UIScreen mainScreen].bounds.size.width;
		windowFrame.origin.x = -(windowFrame.size.width - windowFrame.size.height);
		windowFrame.origin.y = 0.0f;
		self.frame = windowFrame;
	}
	else
	{
		self.frame = [UIScreen mainScreen].bounds;
	}
}

- (void)applyTransform
{
	UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
	if ( UIInterfaceOrientationPortraitUpsideDown == orient )
	{
		self.transform = CGAffineTransformMakeRotation( M_PI );
	}
	else if ( UIInterfaceOrientationLandscapeLeft == orient )
	{
		self.transform = CGAffineTransformMakeRotation( M_PI / 2.0f * 3.0f );
	}
	else if ( UIInterfaceOrientationLandscapeRight == orient )
	{
		self.transform = CGAffineTransformMakeRotation( M_PI / 2.0f );
	}
	else
	{
		self.transform = CGAffineTransformIdentity;
	}
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	self.RELAYOUT();
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.RELAYOUT();
}

- (void)load
{
}

- (void)unload
{
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

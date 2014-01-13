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

#import "UIView+UIViewController.h"
#import "Bee_UIBoard.h"

#pragma mark -

@implementation UIView(UIViewController)

@dynamic board;
@dynamic viewController;

- (BeeUIBoard *)board
{
//	UIView * topView = self;
//	
//	while ( topView.superview )
//	{
//		topView = topView.superview;
//		
//		if ( [topView isKindOfClass:[UIWindow class]] )
//		{
//			break;
//		}
//		else if ( [topView isKindOfClass:[BeeUIBoardView class]] )
//		{
//			break;
//		}
//	}
//	
//	UIViewController * controller = [topView viewController];
//	
//	if ( controller && [controller isKindOfClass:[BeeUIBoard class]] )
//	{
//		return (BeeUIBoard *)controller;
//	}
//	else
//	{
//		return nil;
//	}
	
	UIViewController * controller = [self viewController];

	if ( controller && [controller isKindOfClass:[BeeUIBoard class]] )
	{
		return (BeeUIBoard *)controller;
	}

	return nil;
}

- (UIViewController *)viewController
{
	UIView * view = self;
	
//	while ( nil != view )
//	{
//		if ( nil == view.superview )
//			break;
//
//		view = view.superview;
//	}

	UIResponder * nextResponder = [view nextResponder];

	if ( nextResponder && [nextResponder isKindOfClass:[UIViewController class]] )
	{
		return (UIViewController *)nextResponder;
	}
	
	return nil;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

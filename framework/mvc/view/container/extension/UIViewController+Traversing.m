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

#import "UIViewController+Traversing.h"
#import "UIView+Traversing.h"
#import "UIView+Tag.h"

#import "Bee_UIBoard.h"

#pragma mark -

@implementation UIViewController(Traversing)

@dynamic previousViewController;
@dynamic nextViewController;

@dynamic previousBoard;
@dynamic nextBoard;

- (UIViewController *)previousViewController
{
	UINavigationController * nav = self.navigationController;
	if ( nav )
	{
		NSArray * controllers = nav.viewControllers;
		if ( 0 == controllers.count )
			return nil;

		NSInteger index = [controllers indexOfObject:self];
		if ( NSNotFound == index )
			return nil;
			
		if ( index > 0 )
		{
			return [controllers objectAtIndex:(index - 1)];
		}
	}

	return nil;
}

- (UIViewController *)nextViewController
{
	UINavigationController * nav = self.navigationController;
	if ( nav )
	{
		NSArray *	controllers = nav.viewControllers;
		NSInteger	index = [controllers indexOfObject:self];
		
		if ( controllers.count > 1 && (index + 1) < controllers.count )
		{
			return [controllers objectAtIndex:(index + 1)];
		}
	}

	return nil;
}

- (BeeUIBoard *)previousBoard
{
	UIViewController * controller = self.previousViewController;
	
	while ( controller )
	{
		if ( [controller isKindOfClass:[BeeUIBoard class]] )
		{
			return (BeeUIBoard *)controller;
		}
		
		controller = controller.previousViewController;
	}
	
	return nil;
}

- (BeeUIBoard *)nextBoard
{
	UIViewController * controller = self.nextViewController;

	while ( controller )
	{
		if ( [controller isKindOfClass:[BeeUIBoard class]] )
		{
			return (BeeUIBoard *)controller;
		}

		controller = controller.nextViewController;
	}
	
	return nil;
}

- (UIView *)viewWithTagString:(NSString *)value
{
	if ( NO == self.isViewLoaded )
		return nil;
	
	return [self.view viewWithTagString:value];
}

- (UIView *)viewWithTagPath:(NSString *)value
{
	if ( NO == self.isViewLoaded )
		return nil;
	
	return [self.view viewWithTagPath:value];
}

- (NSArray *)viewWithTagMatchRegex:(NSString *)regex
{
	if ( NO == self.isViewLoaded )
		return nil;
	
	return [self.view viewWithTagMatchRegex:regex];	
}

- (UIView *)viewAtPath:(NSString *)path
{
	if ( NO == self.isViewLoaded )
		return nil;
	
	return [self.view viewAtPath:path];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

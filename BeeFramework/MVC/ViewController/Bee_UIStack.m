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
//  Bee_UIStack.m
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "Bee_UIBoard.h"
#import "Bee_UIStack.h"
#import "Bee_Runtime.h"

#pragma mark -

#undef	UNUSED
#define UNUSED( __x )	(void)(__x)

#pragma mark -

@implementation BeeUIStack

@synthesize name = _name;
@synthesize parentBoard = _parentBoard;
@synthesize boards = _boards;
@synthesize topBoard = _topBoard;

+ (BeeUIStack *)stack
{
	return [[[BeeUIStack alloc] initWithName:nil andFirstBoard:nil] autorelease];
}

+ (BeeUIStack *)stack:(NSString *)name
{
	return [[[BeeUIStack alloc] initWithName:name andFirstBoard:nil] autorelease];
}

+ (BeeUIStack *)stack:(NSString *)name firstBoardClass:(Class)clazz
{
	BeeUIBoard * board = [[(BeeUIBoard *)[BeeRuntime allocByClass:clazz] init] autorelease];
	return [[[BeeUIStack alloc] initWithName:name andFirstBoard:board] autorelease];
}

+ (BeeUIStack *)stack:(NSString *)name firstBoard:(BeeUIBoard *)board
{
	return [[[BeeUIStack alloc] initWithName:name andFirstBoard:board] autorelease];
}

+ (BeeUIStack *)stackWithFirstBoardClass:(Class)clazz
{
	return [BeeUIStack stack:nil firstBoardClass:clazz];
}

+ (BeeUIStack *)stackWithFirstBoard:(BeeUIBoard *)board
{
	return [BeeUIStack stack:nil firstBoard:board];
}

- (BeeUIStack *)initWithName:(NSString *)name andFirstBoardClass:(Class)clazz
{
	BeeUIBoard * board = [[(BeeUIBoard *)[BeeRuntime allocByClass:clazz] init] autorelease];
	self = [super initWithRootViewController:board];
	if ( self )
	{
		self.name = name ? name : [clazz description];
		self.navigationBarHidden = YES;
		self.navigationBar.barStyle = UIBarStyleBlackOpaque;
	}
	return self;
}

- (BeeUIStack *)initWithName:(NSString *)name andFirstBoard:(BeeUIBoard *)board
{
	self = [super initWithRootViewController:board];
	if ( self )
	{
		self.name = name ? name : [[board class] description];
		self.navigationBarHidden = YES;
		self.navigationBar.barStyle = UIBarStyleBlackOpaque;
	}
	return self;
}

- (void)dealloc
{	
	[_name release];	
	[super dealloc];
}

- (NSArray *)boards
{
	NSMutableArray * array = [NSMutableArray array];
	
	for ( UIViewController * controller in self.viewControllers )
	{
		if ( [controller isKindOfClass:[BeeUIBoard class]] )
		{
			[array addObject:controller];
		}
	}
	
	return array;
}

- (BeeUIBoard *)topBoard
{
	UIViewController * controller = self.topViewController;
	if ( controller && [controller isKindOfClass:[BeeUIBoard class]] )
	{
		BeeUIBoard * board = (BeeUIBoard *)controller;
		UNUSED(board.view);
		return board;
	}
	else
	{
		return nil;
	}
}

- (void)pushBoard:(BeeUIBoard *)newBoard animated:(BOOL)animated
{
	[super pushViewController:newBoard animated:animated];
	UNUSED(newBoard.view);	// load view
}

- (void)popBoardAnimated:(BOOL)animated
{
	[super popViewControllerAnimated:animated];
}

- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated
{
	return [super popToViewController:board animated:animated];
}

- (NSArray *)popToFirstBoardAnimated:(BOOL)animated
{
	return [super popToRootViewControllerAnimated:animated];
}

- (void)__enterBackground
{
	for ( UIViewController * viewController in self.viewControllers )
	{
		if ( [viewController isKindOfClass:[BeeUIBoard class]] )
		{
			BeeUIBoard * board = (BeeUIBoard *)viewController;
			[board __enterBackground];
		}
	}
}

- (void)__enterForeground
{
	for ( UIViewController * viewController in self.viewControllers )
	{
		if ( [viewController isKindOfClass:[BeeUIBoard class]] )
		{
			BeeUIBoard * board = (BeeUIBoard *)viewController;
			[board __enterForeground];
		}
	}
}

// Called when the view is about to made visible. Default does nothing
- (void)viewWillAppear:(BOOL)animated
{	
	[super viewWillAppear:animated];
	
	if ( self.topViewController && [self.topViewController isKindOfClass:[BeeUIBoard class]] )
	{
		BeeUIBoard * board = (BeeUIBoard *)self.topViewController;
		[board viewWillAppear:animated];
	}
}

// Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if ( self.topViewController && [self.topViewController isKindOfClass:[BeeUIBoard class]] )
	{
		BeeUIBoard * board = (BeeUIBoard *)self.topViewController;
		[board viewDidAppear:animated];
	}
}

// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if ( self.topViewController && [self.topViewController isKindOfClass:[BeeUIBoard class]] )
	{
		BeeUIBoard * board = (BeeUIBoard *)self.topViewController;
		[board viewWillDisappear:animated];
	}
}

// Called after the view was dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	if ( self.topViewController && [self.topViewController isKindOfClass:[BeeUIBoard class]] )
	{
		BeeUIBoard * board = (BeeUIBoard *)self.topViewController;
		[board viewDidDisappear:animated];
	}
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( signal.source != self )
	{
		BeeUIBoard * board = self.topBoard;
		if ( board )
		{
			[signal forward:board];
		}
		return;
	}	
	else
	{
		// TODO: 自己发给自己的
	}
}

@end

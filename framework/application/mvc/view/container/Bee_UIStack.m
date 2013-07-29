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

#import "Bee_UIStack.h"
#import "Bee_UIBoard.h"
#import "Bee_UINavigationBar.h"

#import "BeeUIBoard+Popover.h"

#pragma mark -

#undef	UNUSED
#define UNUSED( __x )	(void)(__x)

#pragma mark -

@interface BeeUIStack()
{
	NSString *				_name;
	NSMutableDictionary *	_animationTypes;
}
@end

#pragma mark -

@implementation BeeUIStack

@synthesize name = _name;
@dynamic boards;
@dynamic topBoard;

#pragma mark -

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

- (BeeUIStack *)init
{
	self = [super init];
	if ( self )
	{
		self.navigationBarHidden = YES;
		
		[self initSelf];
	}
	return self;
}

- (BeeUIStack *)initWithName:(NSString *)name andFirstBoardClass:(Class)clazz
{
	BeeUIBoard * board = [[(BeeUIBoard *)[BeeRuntime allocByClass:clazz] init] autorelease];
	self = [super initWithRootViewController:board];
	if ( self )
	{
		self.name = name ? name : [clazz description];
		self.navigationBarHidden = YES;
		
		[self initSelf];
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
	
//		board.view;
		
		[self initSelf];
	}
	return self;
}

- (void)initSelf
{
	_animationTypes = [[NSMutableDictionary nonRetainingDictionary] retain];	
}

- (void)dealloc
{	
	[_name release];
	
	[_animationTypes removeAllObjects];
	[_animationTypes release];
	
	[super dealloc];
}

#pragma mark -

- (NSArray *)boards
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	
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
		UNUSED( board.view ); // force to load
		return board;
	}
	else
	{
		return nil;
	}
}

#pragma mark -

- (void)pushBoard:(BeeUIBoard *)board animated:(BOOL)animated
{
	[super pushViewController:board animated:animated];
}

- (void)pushBoard:(BeeUIBoard *)newBoard animated:(BOOL)animated animationType:(BeeUITransitionType)type
{
	if ( newBoard.view )
	{
		newBoard.popover = self.topBoard.popover;

		[_animationTypes setObject:[NSNumber numberWithInt:type] forKey:newBoard.name];
		
		if ( animated )
		{
			[self.view transition:type from:BeeUITransitionFromRight];
		}

		[super pushViewController:newBoard animated:NO];
	}
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[super pushViewController:viewController animated:animated];
}

- (UIViewController *)popBoardAnimated:(BOOL)animated
{
	if ( self.viewControllers.count <= 1 )
		return nil;
	
	NSNumber * animType = [_animationTypes objectForKey:self.topBoard.name];
	if ( animType )
	{
		[_animationTypes removeObjectForKey:self.topBoard.name];

		return [self popBoardAnimated:animated animationType:animType.intValue];
	}
	else
	{
		return [super popViewControllerAnimated:animated];
	}
}
	
- (UIViewController *)popBoardAnimated:(BOOL)animated animationType:(BeeUITransitionType)animType
{
	if ( self.viewControllers.count <= 1 )
		return nil;

	[_animationTypes removeObjectForKey:self.topBoard.name];

	if ( animated )
	{
		[self.view transition:animType from:BeeUITransitionFromLeft];
	}

	return [super popViewControllerAnimated:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
	return [self popBoardAnimated:animated];
}

- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated
{
	NSNumber * animType = [_animationTypes objectForKey:board.name];
	if ( animType )
	{
		return [self popToBoard:board animated:animated animationType:animType.intValue];
	}
	else
	{
		return [super popToViewController:board animated:animated];
	}
}

- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated animationType:(BeeUITransitionType)animType
{
	NSArray * controllers = [super popToViewController:board animated:animated];
	for ( UIViewController * controller in controllers )
	{
		if ( [controller isKindOfClass:[BeeUIBoard class]] )
		{
			BeeUIBoard * board = (BeeUIBoard *)controller;
			[_animationTypes removeObjectForKey:board.name];
		}
	}

	if ( animated )
	{
		[self.view transition:animType from:BeeUITransitionFromLeft];
	}

	return controllers;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ( [viewController isKindOfClass:[BeeUIBoard class]] )
	{
		return [self popToBoard:(BeeUIBoard *)viewController animated:YES];
	}
	else
	{
		return [super popToViewController:viewController animated:animated];
	}
}

- (NSArray *)popToFirstBoardAnimated:(BOOL)animated
{
	NSNumber * animType = [_animationTypes objectForKey:self.topBoard.name];
	if ( animType )
	{
		return [self popToFirstBoardAnimated:animated animationType:animType.intValue];
	}
	else
	{
		return [super popToRootViewControllerAnimated:animated];
	}
}

- (NSArray *)popToFirstBoardAnimated:(BOOL)animated animationType:(BeeUITransitionType)animType
{
	NSArray * controllers = [super popToRootViewControllerAnimated:NO];
	for ( UIViewController * controller in controllers )
	{
		if ( [controller isKindOfClass:[BeeUIBoard class]] )
		{
			BeeUIBoard * board = (BeeUIBoard *)controller;
			[_animationTypes removeObjectForKey:board.name];
		}
	}

	if ( animated )
	{
		[self.view transition:animType from:BeeUITransitionFromLeft];
	}
	
	return controllers;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
	return [self popToFirstBoardAnimated:animated];
}

- (void)popAllBoards
{
	[_animationTypes removeAllObjects];

	self.viewControllers = [NSArray array];
}

- (BOOL)existsBoard:(BeeUIBoard *)board
{
	for ( UIViewController * controller in self.viewControllers )
	{
		if ( NO == [controller isKindOfClass:[BeeUIBoard class]] )
			continue;

		if ( controller == board )
			return YES;
	}

	return NO;
}

#pragma mark -

- (void)loadView
{
	[super loadView];

	BeeUINavigationBar * bar = [[BeeUINavigationBar alloc] init];
	bar.navigationController = self;
	[self setValue:bar forKey:@"navigationBar"];
	[bar release];
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

#pragma mark -

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

#pragma mark -

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( signal.source != self )
	{
		BeeUIBoard * board = self.topBoard;
		if ( board )
		{
			[signal forward:board];
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

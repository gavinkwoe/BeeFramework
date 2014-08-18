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

#import "Bee_UIStack.h"
#import "Bee_UIBoard.h"
#import "Bee_UINavigationBar.h"
#import "Bee_UIConfig.h"

#import "BeeUIBoard+Popover.h"

#import "UIView+Transition.h"
#import "UIViewController+Transition.h"

#pragma mark -

#undef	UNUSED
#define UNUSED( __x )	(void)(__x)

#pragma mark -

@interface BeeUIStack()
{
	BOOL		_inited;
	NSString *	_name;
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
	if ( IOS4_OR_EARLIER )
	{
		self = [super init];
	}
	else
	{
		self = [super initWithNavigationBarClass:[BeeUINavigationBar class] toolbarClass:nil];
	}
	
	if ( self )
	{
		self.navigationBarHidden = YES;
		
		[self initSelf];
	}
	return self;
}

- (BeeUIStack *)initWithName:(NSString *)name andFirstBoardClass:(Class)clazz
{
	if ( IOS4_OR_EARLIER )
	{
		self = [super init];
	}
	else
	{
		self = [super initWithNavigationBarClass:[BeeUINavigationBar class] toolbarClass:nil];
	}
	
	if ( self )
	{
		self.name = name ? name : [clazz description];
		self.navigationBarHidden = YES;
		
		[self initSelf];
		
		self.viewControllers = [NSArray arrayWithObject:[[[clazz alloc] init] autorelease]];
//		board.view;
	}
	return self;
}

- (BeeUIStack *)initWithName:(NSString *)name andFirstBoard:(BeeUIBoard *)board
{
	if ( IOS4_OR_EARLIER )
	{
		self = [super init];
	}
	else
	{
		self = [super initWithNavigationBarClass:[BeeUINavigationBar class] toolbarClass:nil];
	}
	
	if ( self )
	{
		self.name = name ? name : [[board class] description];
		self.navigationBarHidden = YES;
	
		[self initSelf];
		
		self.viewControllers = [NSArray arrayWithObject:board];
//		board.view;
	}
	return self;
}

- (void)initSelf
{
	if ( NO == _inited )
	{
		// TODO:
		self.view.backgroundColor = [UIColor clearColor];
		
		_inited = YES;
	}
}

- (void)dealloc
{	
	[_name release];
	
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
	[self pushBoard:board animated:animated transition:board.transition];
}

- (void)pushBoard:(BeeUIBoard *)board animated:(BOOL)animated transitionType:(BeeUITransitionType)type
{
	BeeUITransition * trans = [BeeUITransition transitionWithType:type];
	[self pushBoard:board animated:animated transition:trans];
}

- (void)pushBoard:(BeeUIBoard *)board animated:(BOOL)animated transition:(BeeUITransition *)trans
{
	if ( board.view )
	{
		board.popover = self.topBoard.popover;
		board.transition = trans;

		if ( animated && trans )
		{
			[trans transiteFor:self.view direction:BeeUITransitionDirectionRight];
		}

	PERF_ENTER
		
		[super pushViewController:board animated:animated];
		
	PERF_LEAVE
	}
}

- (UIViewController *)popBoardAnimated:(BOOL)animated
{
	BeeUITransition * trans = self.topBoard ? self.topBoard.transition : nil;
	return [self popBoardAnimated:animated transition:trans];
}
	
- (UIViewController *)popBoardAnimated:(BOOL)animated transitionType:(BeeUITransitionType)type
{
	BeeUITransition * trans = [BeeUITransition transitionWithType:type];
	return [self popBoardAnimated:animated transition:trans];
}

- (UIViewController *)popBoardAnimated:(BOOL)animated transition:(BeeUITransition *)trans
{
	if ( self.viewControllers.count <= 1 )
		return nil;
	
	BeeUIBoard * topBoard = self.topBoard;
	if ( topBoard )
	{
		topBoard.disableLayout = YES;
	}
	
	if ( animated && trans )
	{
		[trans transiteFor:self.view direction:BeeUITransitionDirectionLeft];
	}

	UIViewController * controller = [super popViewControllerAnimated:animated];
	if ( controller )
	{
		controller.transition = nil;
	}
	
	return controller;
}

- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated
{
	BeeUITransition * trans = self.topBoard ? self.topBoard.transition : nil;
	return [self popToBoard:board animated:animated transition:trans];
}

- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated transitionType:(BeeUITransitionType)type
{
	BeeUITransition * trans = [BeeUITransition transitionWithType:type];
	return [self popToBoard:board animated:animated transition:trans];
}

- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated transition:(BeeUITransition *)trans
{
	if ( animated && trans )
	{
		[trans transiteFor:self.view direction:BeeUITransitionDirectionLeft];
	}

	NSArray * controllers = [super popToViewController:board animated:animated];
	
	if ( controllers )
	{
		for ( UIViewController * controller in controllers )
		{
			controller.transition = nil;
		}
	}

	return controllers;
}

- (NSArray *)popToFirstBoardAnimated:(BOOL)animated
{
	BeeUITransition * trans = self.topBoard ? self.topBoard.transition : nil;
	return [self popToFirstBoardAnimated:animated transition:trans];
}

- (NSArray *)popToFirstBoardAnimated:(BOOL)animated transitionType:(BeeUITransitionType)type
{
	BeeUITransition * trans = [BeeUITransition transitionWithType:type];
	return [self popToFirstBoardAnimated:animated transition:trans];
}

- (NSArray *)popToFirstBoardAnimated:(BOOL)animated transition:(BeeUITransition *)trans
{
	if ( animated && trans )
	{
		[trans transiteFor:self.view direction:BeeUITransitionDirectionLeft];
	}

	NSArray * controllers = [super popToRootViewControllerAnimated:animated];

	if ( controllers )
	{
		for ( UIViewController * controller in controllers )
		{
			controller.transition = nil;
		}
	}

	return controllers;
}

- (void)popAllBoards
{
	for ( UIViewController * controller in self.viewControllers )
	{
		controller.transition = nil;
	}

	self.viewControllers = [NSArray array];
}

- (BOOL)existsBoard:(BeeUIBoard *)board
{
	for ( UIViewController * controller in self.viewControllers )
	{
		if ( controller == board )
			return YES;
	}

	return NO;
}

- (BOOL)existsBoardClass:(Class)boardClazz
{
	for ( UIViewController * controller in self.viewControllers )
	{
		if ( [controller isKindOfClass:boardClazz] )
			return YES;
	}
	
	return NO;
}

#pragma mark -

- (void)loadView
{
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];

	if ( IOS6_OR_EARLIER )
	{
		BeeUINavigationBar * bar = [[BeeUINavigationBar alloc] init];
		if ( bar )
		{
			bar.navigationController = self;
			[self setValue:bar forKey:@"navigationBar"];
			[bar release];
		}
	}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
	if ( IOS7_OR_LATER )
	{
		if ( [BeeUIConfig sharedInstance].iOS6Mode )
		{
			self.edgesForExtendedLayout = UIRectEdgeNone;
			self.extendedLayoutIncludesOpaqueBars = NO;
			self.modalPresentationCapturesStatusBarAppearance = NO;
		}
		else
		{
			self.edgesForExtendedLayout = UIRectEdgeAll;
			self.extendedLayoutIncludesOpaqueBars = YES;
			self.modalPresentationCapturesStatusBarAppearance = YES;
		}
	}
#endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#if defined(__IPHONE_6_0)

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
	return YES;
}

#endif	// #if defined(__IPHONE_6_0)

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if ( self.topViewController )
	{
		[self.topViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if ( self.topViewController )
	{
		[self.topViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
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

#pragma mark -

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

- (UIStatusBarStyle)preferredStatusBarStyle
{
	if ( IOS7_OR_LATER )
	{
		if ( [BeeUIConfig sharedInstance].iOS6Mode )
		{
			return UIStatusBarStyleBlackTranslucent;
		}
		else
		{
			return UIStatusBarStyleLightContent;
		}
	}
	else
	{
		return UIStatusBarStyleDefault;
	}
}

#endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

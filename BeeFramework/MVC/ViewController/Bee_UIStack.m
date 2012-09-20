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
#import "Bee_UINavigationBar.h"

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

- (void)pushBoard:(BeeUIBoard *)board animated:(BOOL)animated
{
	[self pushBoard:board animated:animated animationType:BEE_UISTACK_ANIMATION_DEFAULT];
}

- (void)pushBoard:(BeeUIBoard *)newBoard animated:(BOOL)animated animationType:(BeeUIStackAnimationType)type
{
	newBoard.popover = self.topBoard.popover;
	newBoard.stackAnimationType = type;

	if ( NO == animated )
	{
		[super pushViewController:newBoard animated:NO];
	}
	else
	{
		if ( BEE_UISTACK_ANIMATION_DEFAULT == type )
		{
			[super pushViewController:newBoard animated:YES];
		}
		else if ( BEE_UISTACK_ANIMATION_CUBE == type )
		{
			CATransition *animation = [CATransition animation];
			[animation setDuration:0.6f];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
			[animation setType:@"cube"];
			[animation setRemovedOnCompletion:YES];
			[animation setSubtype:kCATransitionFromTop];
			[self.view.layer addAnimation:animation forKey:@"cube"];

			[super pushViewController:newBoard animated:NO];
		}
		else if ( BEE_UISTACK_ANIMATION_FADE == type )
		{
			CATransition *animation = [CATransition animation];
			[animation setDuration:0.6f];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
			[animation setType:@"fade"];
			[animation setSubtype:kCATransitionFromRight];
			[animation setRemovedOnCompletion:YES];
			
			[self.view.layer addAnimation:animation forKey:@"fade"];
			
			[super pushViewController:newBoard animated:NO];
		}
		else if ( BEE_UISTACK_ANIMATION_PAGING == type )
		{
			CATransition * animation = [CATransition animation];
			[animation setDuration:0.6f];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
			[animation setType:kCATransitionReveal];
			[animation setSubtype:kCATransitionFromTop];
			[animation setRemovedOnCompletion:YES];
			
			[self.view.layer removeAnimationForKey:@"paging_in"];
			[self.view.layer addAnimation:animation forKey:@"paging_in"];

			[super pushViewController:newBoard animated:NO];

			newBoard.view.layer.transform = CATransform3DMakeScale( 0.9f, 0.9f, 1.0f );
			newBoard.view.alpha = 0.0f;

			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.6f];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationBeginsFromCurrentState:NO];

			newBoard.view.layer.transform = CATransform3DIdentity;
			newBoard.view.alpha = 1.0f;

			[UIView commitAnimations];
		}
	}
		
	UNUSED(newBoard.view);	// load view
}

- (void)popBoardAnimated:(BOOL)animated
{
	BeeUIStackAnimationType animType = self.topBoard.stackAnimationType;
	
	if ( NO == animated )
	{
		[super popViewControllerAnimated:NO];
	}
	else
	{
		if ( BEE_UISTACK_ANIMATION_DEFAULT == animType )
		{
			[super popViewControllerAnimated:YES];
		}
		else if ( BEE_UISTACK_ANIMATION_CUBE == animType )
		{
			[super popViewControllerAnimated:NO];
			
			CATransition *animation = [CATransition animation];
			[animation setDuration:0.6f];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			[animation setType:@"cube"];
			[animation setRemovedOnCompletion:YES];
			[animation setSubtype:kCATransitionFromBottom];

			[self.view.layer addAnimation:animation forKey:@"cube"];			
		}
		else if ( BEE_UISTACK_ANIMATION_FADE == animType )
		{
			[super popViewControllerAnimated:NO];
			
			CATransition *animation = [CATransition animation];
			[animation setDuration:0.6f];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			[animation setType:@"fade"];
			[animation setSubtype:kCATransitionFromLeft];
			[animation setRemovedOnCompletion:YES];
			
			[self.view.layer addAnimation:animation forKey:@"fade"];
		}
		else if ( BEE_UISTACK_ANIMATION_PAGING == animType )
		{
			UIView * topView = [self.topBoard.view retain];
			[super popViewControllerAnimated:NO];
			UIView * bottomView = self.topBoard.view;

			[topView removeFromSuperview];
			[self.view addSubview:topView];

			bottomView.layer.transform = CATransform3DMakeTranslation( 0.0f, -bottomView.bounds.size.height, 0.0f);
			bottomView.alpha = 1.0f;

			[UIView animateWithDuration:0.4f
							 animations:^{
								 bottomView.layer.transform = CATransform3DIdentity;
								 bottomView.alpha = 1.0f;

								 topView.layer.transform = CATransform3DMakeScale( 0.9f, 0.9f, 1.0f );
								 topView.alpha = 0.0f;
							 }
							 completion:^(BOOL finished) {
								 topView.alpha = 0.0f;
								 topView.layer.transform = CATransform3DIdentity;
								 
								 [topView removeFromSuperview];
								 [topView release];
							 }];
		}
	}
}

- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated
{
	NSArray * result = nil;
	
	BeeUIStackAnimationType animType = self.topBoard.stackAnimationType;
	
	if ( NO == animated )
	{
		result = [super popToViewController:board animated:NO];
	}
	else
	{
		if ( BEE_UISTACK_ANIMATION_DEFAULT == animType )
		{
			result = [super popToViewController:board animated:YES];
		}
		else if ( BEE_UISTACK_ANIMATION_CUBE == animType )
		{
			result = [super popToViewController:board animated:NO];
			
			CATransition *animation = [CATransition animation];
			[animation setDuration:0.6f];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			[animation setType:@"cube"];
			[animation setRemovedOnCompletion:YES];
			[animation setSubtype:kCATransitionFromTop];

			[self.view.layer addAnimation:animation forKey:@"cube"];			
		}
		else if ( BEE_UISTACK_ANIMATION_FADE == animType )
		{
			result = [super popToViewController:board animated:NO];
			
			CATransition *animation = [CATransition animation];
			[animation setDuration:0.6f];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			[animation setType:@"fade"];
			[animation setSubtype:kCATransitionFromLeft];
			[animation setRemovedOnCompletion:YES];
			
			[self.view.layer addAnimation:animation forKey:@"fade"];
		}
		else if ( BEE_UISTACK_ANIMATION_PAGING == animType )
		{
			UIView * topView = [self.topBoard.view retain];
			result = [super popToViewController:board animated:NO];
			UIView * bottomView = self.topBoard.view;
			
			[topView removeFromSuperview];
			[self.view addSubview:topView];
			
			bottomView.layer.transform = CATransform3DMakeTranslation( 0.0f, -bottomView.bounds.size.height, 0.0f);
			bottomView.alpha = 1.0f;
			
			[UIView animateWithDuration:0.4f
							 animations:^{
								 bottomView.layer.transform = CATransform3DIdentity;
								 bottomView.alpha = 1.0f;
								 
								 topView.layer.transform = CATransform3DMakeScale( 0.9f, 0.9f, 1.0f );
								 topView.alpha = 0.0f;
							 }
							 completion:^(BOOL finished) {
								 topView.alpha = 0.0f;
								 topView.layer.transform = CATransform3DIdentity;
								 
								 [topView removeFromSuperview];
								 [topView release];
							 }];			
		}
	}
	
	return result;
}

- (NSArray *)popToFirstBoardAnimated:(BOOL)animated
{
	NSArray * result = nil;
	
	BeeUIStackAnimationType animType = self.topBoard.stackAnimationType;
	
	if ( NO == animated )
	{
		result = [super popToRootViewControllerAnimated:NO];
	}
	else
	{
		if ( BEE_UISTACK_ANIMATION_DEFAULT == animType )
		{
			result = [super popToRootViewControllerAnimated:YES];
		}
		else if ( BEE_UISTACK_ANIMATION_CUBE == animType )
		{
			result = [super popToRootViewControllerAnimated:NO];
			
			CATransition *animation = [CATransition animation];
			[animation setDuration:0.6f];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			[animation setType:@"cube"];
			[animation setRemovedOnCompletion:YES];
			[animation setSubtype:kCATransitionFromTop];

			[self.view.layer addAnimation:animation forKey:@"cube"];			
		}
		else if ( BEE_UISTACK_ANIMATION_FADE == animType )
		{
			result = [super popToRootViewControllerAnimated:NO];
			
			CATransition *animation = [CATransition animation];
			[animation setDuration:0.6f];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			[animation setType:@"fade"];
			[animation setSubtype:kCATransitionFromLeft];
			[animation setRemovedOnCompletion:YES];
			
			[self.view.layer addAnimation:animation forKey:@"fade"];
		}
		else if ( BEE_UISTACK_ANIMATION_PAGING == animType )
		{
			UIView * topView = [self.topBoard.view retain];
			result = [super popToRootViewControllerAnimated:NO];
			UIView * bottomView = self.topBoard.view;
			
			[topView removeFromSuperview];
			[self.view addSubview:topView];
			
			bottomView.layer.transform = CATransform3DMakeTranslation( 0.0f, -bottomView.bounds.size.height, 0.0f);
			bottomView.alpha = 1.0f;
			
			[UIView animateWithDuration:0.4f
							 animations:^{
								 bottomView.layer.transform = CATransform3DIdentity;
								 bottomView.alpha = 1.0f;
								 
								 topView.layer.transform = CATransform3DMakeScale( 0.9f, 0.9f, 1.0f );
								 topView.alpha = 0.0f;
							 }
							 completion:^(BOOL finished) {
								 topView.alpha = 0.0f;
								 topView.layer.transform = CATransform3DIdentity;
								 
								 [topView removeFromSuperview];
								 [topView release];
							 }];
		}
	}
	
	return result;
}

- (void)popAllBoards
{
	self.viewControllers = [NSArray array];
}

- (BOOL)existsBoard:(BeeUIBoard *)board
{
	for ( UIViewController * controller in self.viewControllers )
	{
		if ( [controller isKindOfClass:[BeeUIBoard class]] && (BeeUIBoard *)controller == board )
		{
			return YES;
		}
	}
	
	return NO;
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

- (void)loadView
{
	[super loadView];

	[self setValue:[BeeUINavigationBar spawn] forKey:@"navigationBar"];
}

- (void)setBarBackgroundImage:(UIImage *)image
{
	UINavigationBar * navBar = self.navigationBar;
	if ( navBar && [navBar isKindOfClass:[BeeUINavigationBar class]] )
	{
		[(BeeUINavigationBar *)navBar setBackgroundImage:image];
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

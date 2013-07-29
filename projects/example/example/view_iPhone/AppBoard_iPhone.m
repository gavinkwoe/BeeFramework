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

#import "AppBoard_iPhone.h"
#import "SplashBoard_iPhone.h"

#import "MenuBoard_iPhone.h"
#import "AboutBoard_iPhone.h"
#import "DribbbleBoard_iPhone.h"
#import "TeamBoard_iPhone.h"
#import "TutorialBoard_iPhone.h"

#import "dribbble.h"

#pragma mark -

#undef	MENU_BOUNDS
#define	MENU_BOUNDS	(80.0f)

#pragma mark -

@implementation AppBoard_iPhone
{
	MenuBoard_iPhone *	_menu;
	BeeUIRouter *		_router;
	BeeUIButton *		_mask;
	UIWindow *			_splash;
	CGRect				_origFrame;
}

DEF_SINGLETON( AppBoard_iPhone )

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		[BeeUITipsCenter setDefaultContainerView:self.view];
		[BeeUITipsCenter setDefaultBubble:[UIImage imageNamed:@"alertBox.png"]];
		[BeeUITipsCenter setDefaultMessageIcon:[UIImage imageNamed:@"index-new-league-icon.png"]];
		[BeeUITipsCenter setDefaultSuccessIcon:[UIImage imageNamed:@"index-new-league-icon.png"]];
		[BeeUITipsCenter setDefaultFailureIcon:[UIImage imageNamed:@"index-new-league-icon.png"]];
		
		[BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar.png"]];
		
		self.view.backgroundColor = [UIColor blackColor];

		_menu = [MenuBoard_iPhone sharedInstance];
		_menu.parentBoard = self;
		_menu.view.backgroundColor = RGB(15, 15, 15);
		_menu.view.hidden = YES;
		[self.view addSubview:_menu.view];

		_router = [BeeUIRouter sharedInstance];
		_router.parentBoard = self;
		_router.view.alpha = 0.0f;
		[_router map:@"demo" toClass:[DribbbleBoard_iPhone class]];
		[_router map:@"tutor" toClass:[TutorialBoard_iPhone class]];
		[_router map:@"team" toClass:[TeamBoard_iPhone class]];
		[_router map:@"about" toClass:[AboutBoard_iPhone class]];
		[self.view addSubview:_router.view];

		_mask = [BeeUIButton new];
		_mask.hidden = YES;
		_mask.signal = @"mask";
		[self.view addSubview:_mask];

		_splash = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		_splash.rootViewController = [SplashBoard_iPhone board];
		_splash.windowLevel = UIWindowLevelStatusBar + 1;
		[_splash makeKeyAndVisible];

		[self observeNotification:SplashBoard_iPhone.PLAY_DONE];
		[self observeNotification:BeeUIRouter.STACK_WILL_CHANGE];
		[self observeNotification:BeeUIRouter.STACK_DID_CHANGED];
		
		[_router open:@"demo" animated:NO];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		_menu = nil;
		_router = nil;
		_mask = nil;
		_splash = nil;

		[self unobserveAllNotifications];
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
	}
	else if ( [signal is:BeeUIBoard.DID_APPEAR] )
	{
		_router.view.pannable = YES;
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
		_router.view.pannable = NO;
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{
	}
}

ON_SIGNAL2( UIView, signal )
{
    if ( [signal is:UIView.PAN_START]  )
    {
        _origFrame = _router.view.frame;

        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_CHANGED]  )
    {
        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_STOP] || [signal is:UIView.PAN_CANCELLED] )
    {
        [self syncPanPosition];

		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3f];

		CGFloat left = _router.view.left;
		CGFloat edge = MENU_BOUNDS;

		if ( left <= edge )
		{
			_router.view.left = 0;
			
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didMenuHidden)];
		}
		else
		{
			_router.view.left = 62.0f;
			
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didMenuShown)];
		}
		
		[UIView commitAnimations];
    }
}

ON_SIGNAL2( mask, signal )
{
	[self hideMenu];
}

ON_SIGNAL3( BeeUIRouter, WILL_CHANGE, signal )
{
}

ON_SIGNAL3( BeeUIRouter, DID_CHANGED, signal )
{
	[_menu selectItem:_router.currentStack.name animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, tutor, signal )
{
	[_router open:@"tutor" animated:YES];
	
	[self hideMenu];
}

ON_SIGNAL3( MenuBoard_iPhone, demo, signal )
{
	[_router open:@"demo" animated:YES];
	
	[self hideMenu];
}

ON_SIGNAL3( MenuBoard_iPhone, about, signal )
{
	[_router open:@"about" animated:YES];
	
	[self hideMenu];
}

ON_SIGNAL3( MenuBoard_iPhone, team, signal )
{
	[_router open:@"team" animated:YES];
	
	[self hideMenu];
}

- (void)didMenuHidden
{
	_mask.hidden = YES;
}

- (void)didMenuShown
{
	_mask.frame = CGRectMake( 60, 0.0, _router.bounds.size.width - 60.0f, _router.bounds.size.height );
	_mask.hidden = NO;
}

- (void)syncPanPosition
{
	_router.view.frame = CGRectOffset( _origFrame, _router.view.panOffset.x, 0 );
}

- (void)showMenu
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didMenuShown)];

	_router.view.left = 62.0f;
	
	[UIView commitAnimations];
}

- (void)hideMenu
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didMenuHidden)];

	_router.view.left = 0.0f;
	
	[UIView commitAnimations];
}

ON_NOTIFICATION3( SplashBoard_iPhone, PLAY_DONE, notification )
{
	[_splash removeFromSuperview];
	[_splash release];
	_splash = nil;

	_menu.view.frame = self.bounds;
	_router.view.frame = self.bounds;

	_router.view.backgroundColor = [UIColor blackColor];
	_router.view.alpha = 0.0f;

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(ready)];
	
	_router.view.backgroundColor = [UIColor whiteColor];
	_router.view.alpha = 1.0f;
	
	[UIView commitAnimations];
}

- (void)ready
{
	_menu.view.hidden = NO;

	[self showMenu];
}

@end

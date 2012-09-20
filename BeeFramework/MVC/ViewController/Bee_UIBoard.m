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
//  Bee_UIBoard.m
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "Bee_UIBoard.h"
#import "Bee_UIStack.h"
#import "Bee_Runtime.h"
#import "Bee_Log.h"
#import "Bee_UIFont.h"
#import "Bee_UIView.h"

#import "Bee_Network.h"
#import "Bee_Controller.h"

#import "NSObject+BeeNotification.h"
#import "NSObject+BeeTicker.h"
#import "NSArray+BeeExtension.h"

#pragma mark -

#undef	MODAL_ANIMATION_DURATION
#define	MODAL_ANIMATION_DURATION	(0.6f)

#undef	UNUSED
#define UNUSED( __x )	(void)(__x)

#pragma mark -

@interface BeeUIBoardView : UIView
{
	BeeUIBoard * _owner;
}
@property (nonatomic, assign) BeeUIBoard * owner;
@end

#pragma mark -

@implementation UIView(BeeView)

- (BeeUIBoard *)board
{
	UIView * topView = self;
	while ( topView.superview )
	{
		topView = topView.superview;
		if ( [topView isKindOfClass:[UIWindow class]] )
		{
			break;
		}
		else if ( [topView isKindOfClass:[BeeUIBoardView class]] )
		{
			break;
		}
	}

	UIViewController * controller = [topView viewController];
	if ( controller && [controller isKindOfClass:[BeeUIBoard class]] )
	{
		return (BeeUIBoard *)controller;
	}
	else
	{
		return nil;
	}
}

- (BeeUIStack *)stack
{
	UINavigationController * controller = [self navigationController];
	if ( controller && [controller isKindOfClass:[BeeUIStack class]] )
	{
		return (BeeUIStack *)controller;
	}
	else
	{
		return nil;
	}
}

- (UIViewController *)viewController
{   
	id nextResponder = [self nextResponder];   
	if ( [nextResponder isKindOfClass:[UIViewController class]] )
	{
		return (UIViewController *)nextResponder;
	}
	else
	{   
		return nil;   
	}   
} 

- (UINavigationController *)navigationController
{
	UIViewController * controller = [self viewController];
	if ( controller )
	{
		return controller.navigationController;
	}
	else
	{
		return nil;
	}
}

- (UIView *)subview:(NSString *)name
{
	if ( nil == name || 0 == [name length] )
		return nil;
	
	NSObject * view = [self valueForKey:name];
	if ( [view isKindOfClass:[UIView class]] )
	{
		return (UIView *)view;
	}
	else
	{
		return nil;
	}
}

@end

#pragma mark -

@implementation UIViewController(BeeExtension)

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

- (CGRect)screenBound
{
	return [UIScreen mainScreen].bounds;
}

@end

#pragma mark -

@implementation BeeUIBoardView

@synthesize owner = _owner;

- (void)setFrame:(CGRect)rect
{	
	CGRect prevFrame = self.frame;
	
	[super setFrame:rect];
	
	[self fitBackgroundFrame];
	
	if ( _owner && NO == CGRectEqualToRect(prevFrame, rect) )
	{
		[_owner sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
//	if ( _owner )
//	{
//		[_owner sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
//	}
}

- (void)dealloc
{	
	[super dealloc];
}

- (UIViewController *)viewController
{
	return _owner ? _owner : [super viewController];
}

- (void)handleUISignal:(BeeUISignal *)signal
{	
	if ( _owner )
	{
		[signal forward:_owner];
	}
	else
	{
		[super handleUISignal:signal];
	}
}	

@end

#pragma mark -

@interface BeeUIBoard(Private)
- (void)createViews;
- (void)deleteViews;
- (void)loadDatas;
- (void)freeDatas;
- (void)enableUserInteraction;
- (void)disableUserInteraction;

- (void)changeStateDeactivated;
- (void)changeStateDeactivating;
- (void)changeStateActivated;
- (void)changeStateActivating;

- (void)didModalMaskTouched;

- (void)didAppearingAnimationDone;
- (void)didDisappearingAnimationDone;

- (void)bounce1ForAppearingAnimationStopped;
- (void)bounce2ForAppearingAnimationStopped;

- (void)resignFirstResponderWalkThrough:(UIView *)rootView;
- (void)becomeFirstResponderWalkThrough:(UIView *)rootView;

- (void)didLeftBarButtonTouched;
- (void)didRightBarButtonTouched;

- (void)didPan:(UIPanGestureRecognizer *)panGesture;
- (void)enablePanGesture;
- (void)disablePanGesture;

- (void)didSwipe:(UISwipeGestureRecognizer *)swipeGesture;
- (void)enableSwipeGesture;
- (void)disableSwipeGesture;

@end

#pragma mark -

@implementation BeeUIBoard

@synthesize popover = _popover;
@synthesize stackAnimationType = _stackAnimationType;

@synthesize lastSleep = _lastSleep;
@synthesize lastWeekup = _lastWeekup;
@synthesize parentBoard = _parentBoard;

@synthesize firstEnter = _firstEnter;
@synthesize presenting = _presenting;
@synthesize viewBuilt = _viewBuilt;
@synthesize dataLoaded = _dataLoaded;
@synthesize state = _state;

@synthesize createDate = _createDate;

@synthesize modalMaskView = _modalMaskView;
@synthesize modalContentView = _modalContentView;
@synthesize modalBoard = _modalBoard;

@synthesize panEnabled;
@synthesize panGesture = _panGesture;
@synthesize panOffset = _panOffset;

@synthesize swipeEnabled;
@synthesize swipeDirection;
@synthesize swipeGesture = _swipeGesture;

@synthesize deactivated;
@synthesize deactivating;
@synthesize activating;
@synthesize activated;

@dynamic sleepDuration;
@dynamic weekDuration;
@dynamic stack;
@dynamic previousBoard;
@dynamic nextBoard;

@synthesize titleString;
@synthesize titleView;

#ifdef __BEE_DEVELOPMENT__
@synthesize signalSeq = _signalSeq;
@synthesize signals = _signals;
@synthesize callstack = _callstack;
#endif	// #ifdef __BEE_DEVELOPMENT__

DEF_SIGNAL( CREATE_VIEWS )			// 创建视图
DEF_SIGNAL( DELETE_VIEWS )			// 释放视图
DEF_SIGNAL( LAYOUT_VIEWS )			// 布局视图
DEF_SIGNAL( LOAD_DATAS )			// 加载数据
DEF_SIGNAL( FREE_DATAS )			// 释放数据
DEF_SIGNAL( WILL_APPEAR )			// 将要显示
DEF_SIGNAL( DID_APPEAR )			// 已经显示
DEF_SIGNAL( WILL_DISAPPEAR )		// 将要隐藏
DEF_SIGNAL( DID_DISAPPEAR )			// 已经隐藏
DEF_SIGNAL( ORIENTATION_CHANGED )	// 方向变化

DEF_SIGNAL( MODALVIEW_WILL_SHOW )	// ModalView将要显示
DEF_SIGNAL( MODALVIEW_DID_SHOWN )	// ModalView已经显示
DEF_SIGNAL( MODALVIEW_WILL_HIDE )	// ModalView将要隐藏
DEF_SIGNAL( MODALVIEW_DID_HIDDEN )	// ModalView已经隐藏

DEF_SIGNAL( POPOVER_WILL_PRESENT )	// Popover将要显示
DEF_SIGNAL( POPOVER_DID_PRESENT )	// Popover已经显示
DEF_SIGNAL( POPOVER_WILL_DISMISS )	// Popover将要隐藏
DEF_SIGNAL( POPOVER_DID_DISMISSED )	// Popover已经隐藏

DEF_SIGNAL( BACK_BUTTON_TOUCHED )	// NavigationBar左按钮被点击
DEF_SIGNAL( DONE_BUTTON_TOUCHED )	// NavigationBar右按钮被点击

DEF_SIGNAL( PAN_START )				// 左右滑动手势开始
DEF_SIGNAL( PAN_STOP )				// 左右滑动手势结束
DEF_SIGNAL( PAN_CHANGED )			// 左右滑动手势位置变化
DEF_SIGNAL( PAN_CANCELLED )			// 左右滑动手势取消

DEF_SIGNAL( SWIPE_UP )				// 手势：瞬间向上滑动
DEF_SIGNAL( SWIPE_DOWN )			// 手势：瞬间向下滑动
DEF_SIGNAL( SWIPE_LEFT )			// 手势：瞬间向左滑动
DEF_SIGNAL( SWIPE_RIGHT )			// 手势：瞬间向右滑动

static NSMutableArray * __allBoards;

+ (NSArray *)allBoards
{
	return __allBoards;
}

+ (BeeUIBoard *)board
{
	return [[(BeeUIBoard *)[BeeRuntime allocByClass:[self class]] init] autorelease];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		if ( nil == __allBoards )
		{
			__allBoards = [[NSMutableArray alloc] init];
		}
		
		[__allBoards addObjectNoRetain:self];
		
		_lastSleep = [NSDate timeIntervalSinceReferenceDate];
		_lastWeekup = [NSDate timeIntervalSinceReferenceDate];
		
		_firstEnter = YES;
		_presenting = NO;
		_viewBuilt = NO;
		_dataLoaded = NO;
		_state = BEE_UIBOARD_STATE_DEACTIVATED;
		
		_createDate = [[NSDate date] retain];
		
		_modalAnimationType = BEE_UIBOARD_ANIMATION_ALPHA;
		
	#ifdef __BEE_DEVELOPMENT__
		_signalSeq = 0;
		_signals = [[NSMutableArray alloc] init];

		_callstack = [[NSMutableArray alloc] init];
		[_callstack addObjectsFromArray:[BeeRuntime callstack:16]];
	#endif
		
		[self load];
	}
	return self;
}

- (void)load
{
	
}

- (void)unload
{
}

- (void)dealloc
{	
	[self unload];
		
	[self cancelMessages];
	[self cancelRequests];
	
	[self unobserveTick];
	[self unobserveAllNotifications];
	
	[self freeDatas];
	[self deleteViews];
	
#ifdef __BEE_DEVELOPMENT__
	[_signals removeAllObjects];
	[_signals release];
	
	[_callstack removeAllObjects];
	[_callstack release];
#endif
	
	[_createDate release];
	[_panGesture release];
	[_swipeGesture release];
	
	if ( _modalBoard.viewBuilt )
	{
		[_modalBoard.view removeFromSuperview];
		[_modalBoard release];
		_modalBoard = nil;
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	[__allBoards removeObjectNoRelease:self];

	[super dealloc];
}

- (void)changeStateDeactivated
{
	if ( BEE_UIBOARD_STATE_DEACTIVATED != _state )
	{
		_state = BEE_UIBOARD_STATE_DEACTIVATED;
		
		[self sendUISignal:BeeUIBoard.DID_DISAPPEAR];
	}
}

- (void)changeStateDeactivating
{
	if ( BEE_UIBOARD_STATE_DEACTIVATING != _state )
	{
		_state = BEE_UIBOARD_STATE_DEACTIVATING;
		
		[self sendUISignal:BeeUIBoard.WILL_DISAPPEAR];
	}
}

- (void)changeStateActivated
{
	if ( BEE_UIBOARD_STATE_ACTIVATED != _state )
	{
		_state = BEE_UIBOARD_STATE_ACTIVATED;
		
		[self sendUISignal:BeeUIBoard.DID_APPEAR];
	}
}

- (void)changeStateActivating
{
	if ( BEE_UIBOARD_STATE_ACTIVATING != _state )
	{
		_state = BEE_UIBOARD_STATE_ACTIVATING;
		
		[self sendUISignal:BeeUIBoard.WILL_APPEAR];
	}
}

// Called when the view is about to made visible. Default does nothing
- (void)viewWillAppear:(BOOL)animated
{	
	if ( NO == _viewBuilt )
		return;
	
	_presenting = YES;
	
	[super viewWillAppear:animated];
	
	[self createViews];
	[self loadDatas];
	
	[self disableUserInteraction];
	[self changeStateActivating];
	
	_lastWeekup = [NSDate timeIntervalSinceReferenceDate];
}

// Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewDidAppear:(BOOL)animated
{
	if ( NO == _viewBuilt )
		return;
	
	[super viewDidAppear:animated];
	
	[self enableUserInteraction];
	[self changeStateActivated];
	
	_firstEnter = NO;	
}

// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewWillDisappear:(BOOL)animated
{
	if ( NO == _viewBuilt )
		return;
	
	[super viewWillDisappear:animated];
	
	[self disableUserInteraction];
	[self changeStateDeactivating];
}

// Called after the view was dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidDisappear:(BOOL)animated
{
	if ( NO == _viewBuilt )
		return;
	
	[super viewDidDisappear:animated];
	
	_presenting = NO;
	
	[self disableUserInteraction];
	[self changeStateDeactivated];
	
	_lastSleep = [NSDate timeIntervalSinceReferenceDate];
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
#if __BEE_DEVELOPMENT__
	CC( @"[%@] presentModalViewController", [[self class] description] );
#endif
	
	[super presentModalViewController:modalViewController animated:animated];	
	
	//	[self viewWillDisappear:animated];
	//	[self viewDidDisappear:animated];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
#if __BEE_DEVELOPMENT__
	CC( @"[%@] dismissModalViewControllerAnimated", [[self class] description] );
#endif
	
	[super dismissModalViewControllerAnimated:animated];
	
	//	[self viewWillAppear:animated];	
	//	[self viewDidAppear:animated];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
#if __BEE_DEVELOPMENT__
	CC( @"[%@] loadView", [[self class] description] );
#endif

	CGRect boardViewBound = [UIScreen mainScreen].bounds;
	BeeUIBoardView * boardView = [[[BeeUIBoardView alloc] initWithFrame:boardViewBound] autorelease];
	boardView.owner = self;

	self.view = boardView;
	self.view.userInteractionEnabled = NO;
	self.view.backgroundColor = [UIColor clearColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
#if __BEE_DEVELOPMENT__
	CC( @"[%@] viewDidLoad", [[self class] description] );
#endif
	
    [super viewDidLoad];
	
	[self createViews];
	[self loadDatas];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations.
//	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
							   duration:(NSTimeInterval)duration
{
	if ( NO == _viewBuilt )
	{
//		[self sendUISignal:BeeUIBoard.CREATE_VIEWS];
		[self sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
		[self sendUISignal:BeeUIBoard.ORIENTATION_CHANGED];
		
		_viewBuilt = YES;
	}
}

- (void)didReceiveMemoryWarning
{
#if __BEE_DEVELOPMENT__
	CC( @"%p(%@) didReceiveMemoryWarning", self, [[self class] description] );
#endif
	
    // Releases the view if it doesn't have a superview.
	if ( YES == _viewBuilt )
	{
		[super didReceiveMemoryWarning];
	}
	
// Release any cached data, images, etc. that aren't in use.
//	if ( NO == _presenting )
//	{
//		[self freeDatas];
//		[self deleteViews];
//
//		self.view = nil;
//	}
//	else
//	{
//	}
}

- (void)viewDidUnload
{
#if __BEE_DEVELOPMENT__
	CC( @"[%@] viewDidUnload", [[self class] description] );
#endif
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[self deleteViews];
	[self freeDatas];
	
    [super viewDidUnload];
}

- (NSTimeInterval)sleepDuration
{
	if ( YES == _presenting )
	{
		return 0.0f;
	}
	else
	{
		return [NSDate timeIntervalSinceReferenceDate] - _lastSleep;
	}
}

- (NSTimeInterval)weekupDuration
{
	if ( YES == _presenting )
	{
		return [NSDate timeIntervalSinceReferenceDate] - _lastWeekup;
	}
	else
	{
		return 0.0f;
	}
}

- (void)createViews
{
	if ( NO == _viewBuilt )
	{
		[self sendUISignal:BeeUIBoard.CREATE_VIEWS];
		[self sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
		
		_viewBuilt = YES;
	}
}

- (void)deleteViews
{	
	if ( YES == _viewBuilt )
	{		
		[self sendUISignal:BeeUIBoard.DELETE_VIEWS];

		_viewBuilt = NO;
	}
}

- (void)loadDatas
{
	if ( NO == _dataLoaded )
	{
		[self sendUISignal:BeeUIBoard.LOAD_DATAS];
		
		_dataLoaded = YES;
	}
}

- (void)reloadBoardDatas
{
	[self freeDatas];
	[self loadDatas];
}

- (void)freeDatas
{
	if ( YES == _dataLoaded )
	{
		[self sendUISignal:BeeUIBoard.FREE_DATAS];
		
		_dataLoaded = NO;
	}
}

- (void)enableUserInteraction
{
	if ( _viewBuilt )
	{
		self.view.userInteractionEnabled = YES;
	}
}

- (void)disableUserInteraction
{
	if ( _viewBuilt )
	{
		self.view.userInteractionEnabled = NO;
	}
}

- (void)__enterBackground
{
	[self freeDatas];
}

- (void)__enterForeground
{
	[self loadDatas];
}

- (BeeUIStack *)stack
{
	if ( self.navigationController )
	{
		return (BeeUIStack *)self.navigationController;
	}
	else
	{
		return nil;
	}	
}

- (BeeUIBoard *)previousBoard
{
	BeeUIStack * stack = [self stack];
	if ( stack )
	{
		NSArray * boards = stack.boards;
		NSInteger index = [boards indexOfObject:self];
		if ( index <= 0 )
			return nil;

		return [boards objectAtIndex:index - 1];
	}
	
	return nil;
}

- (BeeUIBoard *)nextBoard
{
	BeeUIStack * stack = [self stack];
	if ( stack )
	{
		NSArray * boards = stack.boards;
		if ( [boards count] <= 1 )
			return nil;

		NSInteger index = [boards indexOfObject:self];
		if ( index >= ([boards count] - 1) )
			return nil;
		
		return [boards objectAtIndex:index + 1];
	}
	
	return nil;
}

- (void)handleUISignal:(BeeUISignal *)signal
{
#ifdef __BEE_DEVELOPMENT__
	_signalSeq += 1;
	
	[_signals insertObject:signal atIndex:0];
	[_signals keepHead:20];
#endif

	[super handleUISignal:signal];
		
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{			
			self.view.backgroundColor = [UIColor clearColor];
//			self.navigationController.navigationBarHidden = YES;
			
			_modalMaskView = [[UIButton alloc] initWithFrame:self.view.bounds];
			_modalMaskView.hidden = YES;
			_modalMaskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
			[_modalMaskView addTarget:self action:@selector(didModalMaskTouched) forControlEvents:UIControlEventTouchUpInside];
			[self.view addSubview:_modalMaskView];
			
			if ( _panEnabled )
			{
				[self enablePanGesture];
			}

			if ( _swipeEnabled )
			{
				[self enableSwipeGesture];
			}
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{		
			[self disablePanGesture];
			[self disableSwipeGesture];
			
			SAFE_RELEASE_SUBVIEW( _modalMaskView );
			SAFE_RELEASE_SUBVIEW( _modalContentView );
		}
		else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
		{
			self.modalMaskView.frame = self.view.bounds;
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
			[self.view bringSubviewToFront:_modalMaskView];
			[self.view bringSubviewToFront:_modalContentView];
			
			if ( _panEnabled )
			{
				[self enablePanGesture];
			}
			
			if ( _swipeEnabled )
			{
				[self enableSwipeGesture];
			}
		}
		else if ( [signal is:BeeUIBoard.DID_APPEAR] )
		{
		}
		else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
		{
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{
		}
	}
	
	if ( self.parentBoard )
	{
		[signal forward:self.parentBoard.view];
	}
}

- (void)showNavigationBarAnimated:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)hideNavigationBarAnimated:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didModalMaskTouched
{
	[self dismissModalViewAnimated:YES];
}

- (void)presentModalView:(UIView *)view animated:(BOOL)animated
{
	[self presentModalView:view animated:animated animationType:BEE_UIBOARD_ANIMATION_BOUNCE];
}

- (void)presentModalView:(UIView *)view animated:(BOOL)animated animationType:(BeeUIBoardAnimationType)type
{
	if ( self.modalContentView || view.superview == self.view )
		return;
	
	[self sendUISignal:BeeUIBoard.MODALVIEW_WILL_SHOW];
	
	self.modalMaskView.hidden = NO;
	self.modalMaskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
	
	self.modalContentView = view;
	self.modalContentView.hidden = NO;
	
	[self.view addSubview:self.modalContentView];
	[self.view bringSubviewToFront:self.modalMaskView];
	[self.view bringSubviewToFront:self.modalContentView];
	
	_modalAnimationType = type;
	
	if ( animated )
	{		
		if ( BEE_UIBOARD_ANIMATION_ALPHA == type )
		{
			self.modalMaskView.alpha = 0.0f;
			self.modalContentView.alpha = 0.0f;

			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:MODAL_ANIMATION_DURATION];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationDone)];	
			
			self.modalMaskView.alpha = 1.0f;
			self.modalContentView.alpha = 1.0f;
			
			[UIView commitAnimations];				
		}
		else if ( BEE_UIBOARD_ANIMATION_BOUNCE == type )
		{
			self.modalMaskView.alpha = 0.0f;
			self.modalContentView.alpha = 0.0f;
			self.modalContentView.transform = CGAffineTransformScale( CGAffineTransformIdentity, 0.001, 0.001 );
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:(MODAL_ANIMATION_DURATION / 4.0f)];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(bounce1ForAppearingAnimationStopped)];
			
			self.modalContentView.transform = CGAffineTransformScale( CGAffineTransformIdentity, 1.05, 1.05 );
			self.modalMaskView.alpha = 1.0f;
			self.modalContentView.alpha = 1.0f;
			
			[UIView commitAnimations];
		}
	}
	else
	{
		self.modalMaskView.alpha = 1.0f;
		self.modalContentView.alpha = 1.0f;

		[self didAppearingAnimationDone];
	}	
}

- (void)bounce1ForAppearingAnimationStopped
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:(MODAL_ANIMATION_DURATION / 4.0f)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2ForAppearingAnimationStopped)];
	
	self.modalContentView.transform = CGAffineTransformScale( CGAffineTransformIdentity, 0.95, 0.95 );
	
	[UIView commitAnimations];
}

- (void)bounce2ForAppearingAnimationStopped
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:(MODAL_ANIMATION_DURATION / 4.0f)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationDone)];
	
	self.modalContentView.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
}

- (void)didAppearingAnimationDone
{
	[self sendUISignal:BeeUIBoard.MODALVIEW_DID_SHOWN];
}

- (void)dismissModalViewAnimated:(BOOL)animated
{
	if ( nil == self.modalContentView )
		return;
	
	[self sendUISignal:BeeUIBoard.MODALVIEW_WILL_HIDE];
	
	if ( animated )
	{
		if ( BEE_UIBOARD_ANIMATION_ALPHA == _modalAnimationType )
		{
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:MODAL_ANIMATION_DURATION];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didDisappearingAnimationDone)];	
			
			self.modalMaskView.alpha = 0.0f;
			self.modalContentView.alpha = 0.0f;
			
			[UIView commitAnimations];				
		}
		else if ( BEE_UIBOARD_ANIMATION_BOUNCE == _modalAnimationType )
		{
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:(MODAL_ANIMATION_DURATION / 4.0f)];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didDisappearingAnimationDone)];
			
			self.modalMaskView.alpha = 0.0f;
			self.modalContentView.alpha = 0.0f;
			self.modalContentView.transform = CGAffineTransformScale( CGAffineTransformIdentity, 0.001, 0.001 );
			
			[UIView commitAnimations];
		}
	}
	else
	{
		[self didDisappearingAnimationDone];
	}
}

- (void)didDisappearingAnimationDone
{
	self.modalMaskView.hidden = YES;	
	SAFE_RELEASE_SUBVIEW( _modalContentView );

	[self sendUISignal:BeeUIBoard.MODALVIEW_DID_HIDDEN];
}

- (void)presentModalBoard:(BeeUIBoard *)board animated:(BOOL)animated
{
	if ( self.modalBoard )
		return;
	
	if ( animated )
	{
		CATransition * transition = [CATransition animation];
		[transition setDuration:0.2f];
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//		[transition setType:kCATransitionMoveIn];
//		[transition setSubtype:kCATransitionFromBottom];
		[transition setType:kCATransitionFade];
		[self.view.layer addAnimation:transition forKey:nil];
	}
	
	self.modalBoard = board;
	[self.view addSubview:self.modalBoard.view];
	
	board.parentBoard = self;
}

- (void)dismissModalBoardAnimated:(BOOL)animated
{
	if ( animated )
	{
		CATransition * transition = [CATransition animation];
		[transition setDuration:0.2f];
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear]];
//		[transition setType:kCATransitionReveal];
//		[transition setSubtype:kCATransitionFromTop];
		[transition setType:kCATransitionFade];
		[self.view.layer addAnimation:transition forKey:nil];		
	}
	
	[self.modalBoard.view removeFromSuperview];
	self.modalBoard.parentBoard = nil;
	self.modalBoard = nil;
}

- (void)resignFirstResponderWalkThrough:(UIView *)rootView
{
	for ( UIView * subview in rootView.subviews )
	{
		if ( [subview isKindOfClass:[UITextField class]] )
		{
			UITextField * textField = (UITextField *)subview;
			[textField resignFirstResponder];
		}
		else if ( [subview isKindOfClass:[UITextView class]] )
		{
			UITextView * textView = (UITextView *)subview;
			[textView resignFirstResponder];
		}
		else
		{
			[self resignFirstResponderWalkThrough:subview];
		}
	}
}

- (BOOL)resignFirstResponder
{
	[self resignFirstResponderWalkThrough:self.view];
	return YES;
}

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

- (void)didLeftBarButtonTouched
{
	[self sendUISignal:BeeUIBoard.BACK_BUTTON_TOUCHED];
}

- (void)didRightBarButtonTouched
{
	[self sendUISignal:BeeUIBoard.DONE_BUTTON_TOUCHED];
}

- (void)showBarButton:(BeeUIBoardBarButtonPosition)position title:(NSString *)name
{
	if ( BEE_UIBOARD_BARBUTTON_LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:name
																				  style:UIBarButtonItemStylePlain
																				 target:self
																				 action:@selector(didLeftBarButtonTouched)] autorelease];
	}
	else
	{
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:name
																				   style:UIBarButtonItemStylePlain
																				  target:self
																				  action:@selector(didRightBarButtonTouched)] autorelease];
	}
}

- (void)showBarButton:(BeeUIBoardBarButtonPosition)position image:(UIImage *)image
{
	UIButton * button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)] autorelease];
	button.contentMode = UIViewContentModeScaleAspectFit;
	button.backgroundColor = [UIColor clearColor];
	[button setImage:image forState:UIControlStateNormal];

	if ( BEE_UIBOARD_BARBUTTON_LEFT == position )
	{
		[button addTarget:self action:@selector(didLeftBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	}
	else
	{
		[button addTarget:self action:@selector(didRightBarButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	}

//	if ( BEE_UIBOARD_BARBUTTON_LEFT == position )
//	{		
//		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:image
//																				  style:UIBarButtonItemStylePlain
//																				 target:self
//																				 action:@selector(didLeftBarButtonTouched)] autorelease];
//	}
//	else
//	{
//		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:image
//																				   style:UIBarButtonItemStylePlain
//																				  target:self
//																				  action:@selector(didRightBarButtonTouched)] autorelease];
//	}	
}

- (void)showBarButton:(BeeUIBoardBarButtonPosition)position system:(UIBarButtonSystemItem)index
{
	if ( BEE_UIBOARD_BARBUTTON_LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
																							   target:self
																							   action:@selector(didLeftBarButtonTouched)] autorelease];
	}
	else
	{
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
																								target:self
																								action:@selector(didRightBarButtonTouched)] autorelease];
	}		
}

- (void)showBarButton:(BeeUIBoardBarButtonPosition)position custom:(UIView *)view
{
	if ( BEE_UIBOARD_BARBUTTON_LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
	}
	else
	{
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
	}
}

- (void)hideBarButton:(BeeUIBoardBarButtonPosition)position
{
	if ( BEE_UIBOARD_BARBUTTON_LEFT == position )
	{
		self.navigationItem.leftBarButtonItem = nil;
	}
	else
	{
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (BOOL)deactivated
{
	return BEE_UIBOARD_STATE_DEACTIVATED == _state ? YES : NO;
}

- (BOOL)deactivating
{
	return BEE_UIBOARD_STATE_DEACTIVATING == _state ? YES : NO;
}

- (BOOL)activating
{
	return BEE_UIBOARD_STATE_ACTIVATING == _state ? YES : NO;
}

- (BOOL)activated
{
	return BEE_UIBOARD_STATE_ACTIVATED == _state ? YES : NO;
}

- (BOOL)panEnabled
{
	return _panEnabled;
}

- (void)setPanEnabled:(BOOL)flag
{
	if ( flag == _panEnabled )
		return;

	if ( flag )
	{
		[self enablePanGesture];
	}
	else
	{
		[self disablePanGesture];
	}
	
	_panEnabled = flag;
}

- (void)enablePanGesture
{
	if ( nil == _panGesture )
	{
		_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
		_panGesture.delegate = self;
	}

	if ( _viewBuilt )
	{
		[self.view removeGestureRecognizer:_panGesture];
		[self.view addGestureRecognizer:_panGesture];			
	}
}

- (void)disablePanGesture
{
	if ( _panGesture )
	{
		if ( _viewBuilt )
		{
			[self.view removeGestureRecognizer:_panGesture];		
		}
	}
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture
{
	if ( NO == _panEnabled )
		return;

	_panOffset = [panGesture translationInView:self.view];

	CC( @"panOffset = (%.0f, %.0f)", _panOffset.x, _panOffset.y );

	if ( UIGestureRecognizerStateBegan == panGesture.state )
	{
		[self sendUISignal:BeeUIBoard.PAN_START];
	}
	else if ( UIGestureRecognizerStateChanged == panGesture.state )
	{
		[self sendUISignal:BeeUIBoard.PAN_CHANGED];
	}
	else if ( UIGestureRecognizerStateEnded == panGesture.state )
	{		
		[self sendUISignal:BeeUIBoard.PAN_STOP];
		
		_panOffset = CGPointZero;
	}
	else if ( UIGestureRecognizerStateCancelled == panGesture.state )
	{
		[self sendUISignal:BeeUIBoard.PAN_CANCELLED];
		
		_panOffset = CGPointZero;
	}
}

- (BOOL)swipeEnabled
{
	return _swipeEnabled;
}

- (void)setSwipeEnabled:(BOOL)flag
{
	if ( flag == _swipeEnabled )
		return;
	
	if ( flag )
	{
		[self enableSwipeGesture];
	}
	else
	{
		[self disableSwipeGesture];
	}
	
	_swipeEnabled = flag;
}

- (UISwipeGestureRecognizerDirection)direction
{
	return _swipeGesture ? _swipeGesture.direction : 0;
}

- (void)setSwipeDirection:(UISwipeGestureRecognizerDirection)direction
{
	_swipeGesture.direction = direction;
}

- (void)enableSwipeGesture
{
	if ( nil == _swipeGesture )
	{
		_swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
		_swipeGesture.numberOfTouchesRequired = 1;
		_swipeGesture.delegate = self;		
	}

	if ( _viewBuilt )
	{
		[self.view removeGestureRecognizer:_swipeGesture];
		[self.view addGestureRecognizer:_swipeGesture];			
	}
}

- (void)disableSwipeGesture
{
	if ( _swipeGesture )
	{
		if ( _viewBuilt )
		{
			[self.view removeGestureRecognizer:_swipeGesture];		
		}
	}
}

- (void)didSwipe:(UISwipeGestureRecognizer *)swipeGesture
{
	if ( NO == _swipeEnabled )
		return;
	
	if ( UIGestureRecognizerStateEnded == swipeGesture.state )
	{		
		if ( UISwipeGestureRecognizerDirectionUp == swipeGesture.direction )
		{
			CC( @"swipe up" );
			
			[self sendUISignal:BeeUIBoard.SWIPE_UP];
		}
		else if ( UISwipeGestureRecognizerDirectionDown == swipeGesture.direction )
		{
			CC( @"swipe down" );
			
			[self sendUISignal:BeeUIBoard.SWIPE_DOWN];
		}
		else if ( UISwipeGestureRecognizerDirectionLeft == swipeGesture.direction )
		{
			CC( @"swipe left" );
			
			[self sendUISignal:BeeUIBoard.SWIPE_LEFT];
		}
		else if ( UISwipeGestureRecognizerDirectionRight == swipeGesture.direction )
		{
			CC( @"swipe right" );
			
			[self sendUISignal:BeeUIBoard.SWIPE_RIGHT];
		}
	}
}

- (void)presentPopoverForView:(UIView *)view
				  contentSize:(CGSize)size
					direction:(UIPopoverArrowDirection)direction
					 animated:(BOOL)animated
{
	self.view.frame = CGRectMake( 0.0f, 0.0f, size.width, size.height );

	self.popover = [[[UIPopoverController alloc] initWithContentViewController:[BeeUIStack stackWithFirstBoard:self]] autorelease];
	self.popover.delegate = self;
    self.contentSizeForViewInPopover = size;
	
	[self sendUISignal:BeeUIBoard.POPOVER_WILL_PRESENT];
	
	[self.popover presentPopoverFromRect:view.frame
								  inView:view.superview
				permittedArrowDirections:direction
								animated:animated];
	
	[self sendUISignal:BeeUIBoard.POPOVER_DID_PRESENT];
}

- (void)dismissPopoverAnimated:(BOOL)animated
{
	[self.popover dismissPopoverAnimated:animated];
	self.popover = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
	[self sendUISignal:BeeUIBoard.POPOVER_WILL_DISMISS];
	return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	[self sendUISignal:BeeUIBoard.POPOVER_DID_DISMISSED];
	self.popover = nil;
}

@end

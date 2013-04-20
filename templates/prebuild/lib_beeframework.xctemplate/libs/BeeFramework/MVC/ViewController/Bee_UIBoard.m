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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UIBoard.h"
#import "Bee_UIStack.h"
#import "Bee_Runtime.h"
#import "Bee_SystemInfo.h"
#import "Bee_Log.h"

#import "Bee_Network.h"
#import "Bee_Controller.h"
#import "Bee_SystemInfo.h"

#import "NSObject+BeeMessage.h"
#import "NSObject+BeeRequest.h"

#import "UIView+BeeExtension.h"
#import "UIFont+BeeExtension.h"
#import "NSObject+BeeNotification.h"
#import "NSObject+BeeTicker.h"
#import "NSArray+BeeExtension.h"
#import "UIViewController+BeeExtension.h"
#import "UIView+BeeUISignal.h"
#import "UIViewController+BeeUISignal.h"

#pragma mark -

#undef	MODAL_ANIMATION_DURATION
#define	MODAL_ANIMATION_DURATION	(0.6f)

#undef	UNUSED
#define UNUSED( __x )	(void)(__x)

#undef	MAX_SIGNALS
#define MAX_SIGNALS		(50)

//// thanks to @inonomori
//#undef	ORIENTATIONMASK
//#define ORIENTATIONMASK( __x )		( 1 << __x )

#pragma mark -

@interface BeeUIBoardView : UIView
{
	BeeUIBoard * _owner;
}

@property (nonatomic, assign) BeeUIBoard * owner;

@end

#pragma mark -

@implementation UIView(BeeUIBoard)

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

@end

#pragma mark -

@implementation BeeUIBoardView

@synthesize owner = _owner;

- (void)setFrame:(CGRect)rect
{
//	if ( CGRectEqualToRect(rect, super.frame) )
//	{
		[super setFrame:rect];

		if ( _owner )
		{
			[_owner sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
		}
//	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	if ( _owner )
	{
		[_owner sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
	}
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

@implementation BeeUIBoard

@synthesize containedPopover = _containedPopover;
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

@synthesize modalBoard = _modalBoard;
@synthesize modalMaskView = _modalMaskView;
@synthesize modalContentView = _modalContentView;
@synthesize modalAnimationType = _modalAnimationType;

@synthesize zoomed = _zoomed;
@synthesize zoomRect = _zoomRect;
@synthesize animationBlock = _animationBlock;

@synthesize deactivated;
@synthesize deactivating;
@synthesize activating;
@synthesize activated;

@dynamic sleepDuration;
@dynamic weekDuration;
@dynamic stack;
@dynamic previousBoard;
@dynamic nextBoard;

@synthesize allowedPortrait = _allowedPortrait;
@synthesize allowedLandscape = _allowedLandscape;

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
@synthesize createSeq = _createSeq;
@synthesize signalSeq = _signalSeq;
@synthesize signals = _signals;
@synthesize callstack = _callstack;
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

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

DEF_SIGNAL( ANIMATION_BEGIN )		// 动画开始
DEF_SIGNAL( ANIMATION_FINISH )		// 动画结束

DEF_SIGNAL( MODALVIEW_WILL_SHOW )	// ModalView将要显示
DEF_SIGNAL( MODALVIEW_DID_SHOWN )	// ModalView已经显示
DEF_SIGNAL( MODALVIEW_WILL_HIDE )	// ModalView将要隐藏
DEF_SIGNAL( MODALVIEW_DID_HIDDEN )	// ModalView已经隐藏

DEF_SIGNAL( POPOVER_WILL_PRESENT )	// Popover将要显示
DEF_SIGNAL( POPOVER_DID_PRESENT )	// Popover已经显示
DEF_SIGNAL( POPOVER_WILL_DISMISS )	// Popover将要隐藏
DEF_SIGNAL( POPOVER_DID_DISMISSED )	// Popover已经隐藏

DEF_INT( STATE_DEACTIVATED,			0 )
DEF_INT( STATE_DEACTIVATING,		1 )
DEF_INT( STATE_ACTIVATING,			2 )
DEF_INT( STATE_ACTIVATED,			3 )

DEF_INT( ANIMATION_TYPE_DEFAULT,	0 )
DEF_INT( ANIMATION_TYPE_ALPHA,		0 )
DEF_INT( ANIMATION_TYPE_BOUNCE,		1 )

DEF_INT( BARBUTTON_LEFT,			UINavigationBar.BARBUTTON_LEFT )
DEF_INT( BARBUTTON_RIGHT,			UINavigationBar.BARBUTTON_RIGHT )

static NSUInteger				__createSeed = 0;
static NSMutableArray *			__allBoards;

+ (NSArray *)allBoards
{
	return __allBoards;
}

+ (BeeUIBoard *)board
{
	return [[(BeeUIBoard *)[BeeRuntime allocByClass:[self class]] init] autorelease];
}

+ (BeeUIBoard *)boardWithNibName:(NSString *)nibNameOrNil
{
	return [[[self alloc] initWithNibName:nibNameOrNil bundle:nil] autorelease];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		if ( nil == __allBoards )
		{
			__allBoards = [[NSMutableArray nonRetainingArray] retain];
		}

		[__allBoards insertObject:self atIndex:0];
		
		_lastSleep = [NSDate timeIntervalSinceReferenceDate];
		_lastWeekup = [NSDate timeIntervalSinceReferenceDate];
		
		_zoomed = NO;
		_zoomRect = CGRectZero;

		_firstEnter = YES;
		_presenting = NO;
		_viewBuilt = NO;
		_dataLoaded = NO;
		_state = BeeUIBoard.STATE_DEACTIVATED;
		
		_createDate = [[NSDate date] retain];
		
		_modalAnimationType = BeeUIBoard.ANIMATION_TYPE_ALPHA;
		
		_allowedPortrait = YES;
		_allowedLandscape = NO;

	#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
		_createSeq = __createSeed++;
		_signalSeq = 0;
		_signals = [[NSMutableArray alloc] init];

		_callstack = [[NSMutableArray alloc] init];
		[_callstack addObjectsFromArray:[BeeRuntime callstack:16]];
	#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
		
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
	
	self.animationBlock = nil;
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	[_signals removeAllObjects];
	[_signals release];
	
	[_callstack removeAllObjects];
	[_callstack release];
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
	[_createDate release];
	
	if ( _modalBoard.viewBuilt )
	{
		[_modalBoard.view removeFromSuperview];
		[_modalBoard release];
		_modalBoard = nil;
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	[__allBoards removeObject:self];

	[super dealloc];
}

- (void)changeStateDeactivated
{
	if ( BeeUIBoard.STATE_DEACTIVATED != _state )
	{
		_state = BeeUIBoard.STATE_DEACTIVATED;
		
		[self sendUISignal:BeeUIBoard.DID_DISAPPEAR];
	}
}

- (void)changeStateDeactivating
{
	if ( BeeUIBoard.STATE_DEACTIVATING != _state )
	{
		_state = BeeUIBoard.STATE_DEACTIVATING;
		
		[self sendUISignal:BeeUIBoard.WILL_DISAPPEAR];
	}
}

- (void)changeStateActivated
{
	if ( BeeUIBoard.STATE_ACTIVATED != _state )
	{
		_state = BeeUIBoard.STATE_ACTIVATED;
		
		[self sendUISignal:BeeUIBoard.DID_APPEAR];
	}
}

- (void)changeStateActivating
{
	if ( BeeUIBoard.STATE_ACTIVATING != _state )
	{
		_state = BeeUIBoard.STATE_ACTIVATING;
		
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
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"[%@] presentModalViewController", [[self class] description] );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
	[super presentModalViewController:modalViewController animated:animated];	
	
	//	[self viewWillDisappear:animated];
	//	[self viewDidDisappear:animated];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"[%@] dismissModalViewControllerAnimated", [[self class] description] );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
	[super dismissModalViewControllerAnimated:animated];
	
	//	[self viewWillAppear:animated];	
	//	[self viewDidAppear:animated];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"[%@] loadView", [[self class] description] );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

	if ( self.nibName )
	{
		[super loadView];
		return;
	}

	CGRect boardViewBound = [UIScreen mainScreen].bounds;
	BeeUIBoardView * boardView = [[BeeUIBoardView alloc] initWithFrame:boardViewBound];
	boardView.owner = self;

	self.view = boardView;
	self.view.userInteractionEnabled = NO;
	self.view.backgroundColor = [UIColor clearColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [boardView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"[%@] viewDidLoad", [[self class] description] );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
    [super viewDidLoad];
	
	[self createViews];
	[self loadDatas];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ( interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
	{
		return _allowedPortrait ? YES : NO;
	}
	else if ( interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight )
	{
		return _allowedLandscape ? YES : NO;
	}
	
	return NO;	
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
							   duration:(NSTimeInterval)duration
{
	if ( _viewBuilt )
	{
		[self sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
		[self sendUISignal:BeeUIBoard.ORIENTATION_CHANGED];
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if ( _viewBuilt )
	{
		[self sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
		[self sendUISignal:BeeUIBoard.ORIENTATION_CHANGED];
	}
}

#if defined(__IPHONE_6_0)

-(NSUInteger)supportedInterfaceOrientations
{
	NSUInteger orientation = 0;

	if ( _allowedPortrait )
	{
		orientation |= UIInterfaceOrientationMaskPortrait;
	}

	if ( _allowedLandscape )
	{
		orientation |= UIInterfaceOrientationMaskLandscape;
	}

	return orientation;
}

- (BOOL)shouldAutorotate
{
	if ( _allowedLandscape )
	{
		return YES;
	}
	
	if ( _allowedPortrait )
	{
		return YES;
	}
	
	return NO;
}

#endif	// #if defined(__IPHONE_6_0)

- (void)didReceiveMemoryWarning
{
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"%p(%@) didReceiveMemoryWarning", self, [[self class] description] );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
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
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	CC( @"[%@] viewDidUnload", [[self class] description] );
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
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
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	_signalSeq += 1;
	
	[_signals addObject:signal];
	[_signals keepTail:MAX_SIGNALS];	
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
	[super handleUISignal:signal];
		
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			self.view.backgroundColor = [UIColor clearColor];
//			self.navigationController.navigationBarHidden = YES;

			if ( _zoomed )
			{
				[self transformZoom:_zoomRect];
			}

			_modalMaskView = [[UIButton alloc] initWithFrame:self.viewBound];
			_modalMaskView.hidden = YES;
			_modalMaskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
			[_modalMaskView addTarget:self action:@selector(didModalMaskTouched) forControlEvents:UIControlEventTouchUpInside];
			[self.view addSubview:_modalMaskView];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{		
			SAFE_RELEASE_SUBVIEW( _modalMaskView );
			SAFE_RELEASE_SUBVIEW( _modalContentView );
		}
		else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
		{
			self.modalMaskView.frame = self.viewBound;
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
			[self.view bringSubviewToFront:_modalMaskView];
			[self.view bringSubviewToFront:_modalContentView];
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
	
	if ( self.parentBoard && NO == [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		[signal forward:self.parentBoard.view];
	}
}

- (void)didModalMaskTouched
{
	[self dismissModalViewAnimated:YES];
}

- (void)presentModalView:(UIView *)view animated:(BOOL)animated
{
	[self presentModalView:view animated:animated animationType:BeeUIBoard.ANIMATION_TYPE_BOUNCE];
}

- (void)presentModalView:(UIView *)view animated:(BOOL)animated animationType:(NSInteger)type
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
		if ( BeeUIBoard.ANIMATION_TYPE_ALPHA == type )
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
		else if ( BeeUIBoard.ANIMATION_TYPE_BOUNCE == type )
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
	
	self.modalMaskView.hidden = NO;
	self.modalContentView.hidden = NO;
	
	[self sendUISignal:BeeUIBoard.MODALVIEW_WILL_HIDE];
	
	if ( animated )
	{
		if ( BeeUIBoard.ANIMATION_TYPE_ALPHA == _modalAnimationType )
		{
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:MODAL_ANIMATION_DURATION];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didDisappearingAnimationDone)];	
			
			self.modalMaskView.alpha = 0.0f;
			self.modalContentView.alpha = 0.0f;
			
			[UIView commitAnimations];				
		}
		else if ( BeeUIBoard.ANIMATION_TYPE_BOUNCE == _modalAnimationType )
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
		if ( [subview respondsToSelector:@selector(resignFirstResponder)] )
		{
			[subview performSelector:@selector(resignFirstResponder)];
		}

		[self resignFirstResponderWalkThrough:subview];
	}
}

- (BOOL)resignFirstResponder
{
	[self resignFirstResponderWalkThrough:self.view];
	return YES;
}

- (BOOL)deactivated
{
	return BeeUIBoard.STATE_DEACTIVATED == _state ? YES : NO;
}

- (BOOL)deactivating
{
	return BeeUIBoard.STATE_DEACTIVATING == _state ? YES : NO;
}

- (BOOL)activating
{
	return BeeUIBoard.STATE_ACTIVATING == _state ? YES : NO;
}

- (BOOL)activated
{
	return BeeUIBoard.STATE_ACTIVATED == _state ? YES : NO;
}

- (void)presentPopoverForView:(UIView *)view
				  contentSize:(CGSize)size
					direction:(UIPopoverArrowDirection)direction
					 animated:(BOOL)animated
{
	self.view.frame = CGRectMake( 0.0f, 0.0f, size.width, size.height );

	self.containedPopover = [[[UIPopoverController alloc] initWithContentViewController:[BeeUIStack stackWithFirstBoard:self]] autorelease];
	self.containedPopover.delegate = self;
    self.contentSizeForViewInPopover = size;
	[self.containedPopover setPopoverContentSize:size];

	[self sendUISignal:BeeUIBoard.POPOVER_WILL_PRESENT];

	[self.containedPopover presentPopoverFromRect:view.frame
										   inView:view.superview
						 permittedArrowDirections:direction
										 animated:animated];
	
	[self sendUISignal:BeeUIBoard.POPOVER_DID_PRESENT];
}

- (void)dismissPopoverAnimated:(BOOL)animated
{
	[self.containedPopover dismissPopoverAnimated:animated];
	self.containedPopover = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
	[self sendUISignal:BeeUIBoard.POPOVER_WILL_DISMISS];
	return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	[self sendUISignal:BeeUIBoard.POPOVER_DID_DISMISSED];
	self.containedPopover = nil;
}

- (void)beginAnimation
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
}

- (void)changeAnimationCurve:(UIViewAnimationCurve)curve
{
	[UIView setAnimationCurve:curve];
}

- (void)changeAnimationDuration:(NSTimeInterval)duration
{
	[UIView setAnimationDuration:duration];
}

- (void)changeAnimationDelay:(NSTimeInterval)delay
{
	[UIView setAnimationDelay:delay];
}

- (void)didAnimationDone
{
	[self sendUISignal:self.ANIMATION_FINISH];

	if ( self.animationBlock )
	{
		self.animationBlock();
	}
}

- (void)commitAnimation:(BeeUIBoardBlock)block
{
	self.animationBlock = block;

	[self sendUISignal:self.ANIMATION_BEGIN];
	
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAnimationDone)];
	[UIView commitAnimations];
}

- (void)transformZoom:(CGRect)rect
{
	CGPoint center1 = CGPointMake( self.view.bounds.origin.x + (self.view.bounds.size.width / 2.0f), self.view.bounds.origin.y + (self.view.bounds.size.height / 2.0f) );
	CGPoint center2 = CGPointMake( rect.origin.x + (rect.size.width / 2.0f), rect.origin.y + (rect.size.height / 2.0f) );
	
	CGFloat depthZ = rect.size.width;
	CGFloat transZ = rect.size.width * ((self.view.bounds.size.width - rect.size.width) / self.view.bounds.size.width);
	CGFloat transX = center1.x - center2.x;
	CGFloat transY = center1.y - center2.y;
	
	CATransform3D transform = self.view.layer.transform;
	transform.m34 = -(1.0f / depthZ);
	transform = CATransform3DTranslate( transform, transX, transY, transZ );
	self.view.layer.transform = transform;
	
	_zoomRect = rect;
	_zoomed = YES;
}

- (void)transformReset
{
	[UIView setAnimationBeginsFromCurrentState:NO];
	
	self.view.layer.transform = CATransform3DIdentity;
	
	_zoomRect = CGRectZero;
	_zoomed = NO;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

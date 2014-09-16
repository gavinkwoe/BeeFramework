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

#import "Bee_UIBoard.h"
#import "Bee_UIStack.h"
#import "Bee_UIConfig.h"
#import "Bee_UISignalBus.h"

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

#undef	MAX_SIGNALS
#define MAX_SIGNALS		(50)

#pragma mark -

@interface BeeUIBoardView : UIView
{
	BOOL _layouting;
}
@end

#pragma mark -

@implementation BeeUIBoardView

IS_CONTAINABLE( YES )

- (void)setFrame:(CGRect)rect
{
	CGRect prevRect = [self frame];
	
	[super setFrame:rect];

	BeeUIBoard * receiver = self.signalReceiver;
	if ( receiver )
	{
		if ( NO == _layouting )
		{
			BOOL changed = NO;
			
			if ( NO == CGSizeEqualToSize(rect.size, CGSizeZero) && NO == CGSizeEqualToSize(prevRect.size, rect.size) )
			{
				changed = YES;
			}
			
			if ( changed )
			{
				_layouting = YES;

				[receiver sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
				
				_layouting = NO;
			}
		}
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
	BeeUIBoard * receiver = self.signalReceiver;
	if ( receiver )
	{
		if ( NO == _layouting )
		{
			BOOL changed = NO;
            
			if ( NO == CGSizeEqualToSize( self.frame.size, CGSizeZero ) )
			{
				changed = YES;
			}
            
			if ( changed )
			{
				_layouting = YES;
                
				[receiver sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
				
				_layouting = NO;
			}
		}
	}
}

#pragma mark -

- (void)handleUISignal:(BeeUISignal *)signal
{
	BeeUIBoard * receiver = self.signalReceiver;
	if ( receiver )
	{
		[signal forward:receiver];
	}
	else
	{
		SIGNAL_FORWARD( signal );
	}
}

@end

#pragma mark -

@interface BeeUIBoard()
{
	BeeUIBoard *				_parent;
	NSString *					_name;
	
	BOOL						_inited;
	BOOL						_firstEnter;
	BOOL						_presenting;
	BOOL						_viewBuilt;
	BOOL						_dataLoaded;
	NSInteger					_state;

	NSDate *					_createDate;
	NSTimeInterval				_lastSleep;
	NSTimeInterval				_lastWeekup;
	
	BOOL						_allowedPortrait;
	BOOL						_allowedLandscape;
	BOOL						_allowedSwipeToBack;
	BOOL						_disableLayout;
	
	UISwipeGestureRecognizer *	_swipeGesture;
	
#if __BEE_DEVELOPMENT__
	NSUInteger					_createSeq;
	NSUInteger					_signalSeq;
	NSMutableArray *			_signals;
	NSMutableArray *			_callstack;
#endif	// #if __BEE_DEVELOPMENT__
}

+ (NSString *)generateName;

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

- (void)resignFirstResponderWalkThrough:(UIView *)rootView;
//- (void)becomeFirstResponderWalkThrough:(UIView *)rootView;

@end

#pragma mark -

@implementation BeeUIBoard

DEF_SIGNAL( CREATE_VIEWS )
DEF_SIGNAL( DELETE_VIEWS )
DEF_SIGNAL( LAYOUT_VIEWS )
DEF_SIGNAL( LOAD_DATAS )
DEF_SIGNAL( FREE_DATAS )
DEF_SIGNAL( WILL_APPEAR )
DEF_SIGNAL( DID_APPEAR )
DEF_SIGNAL( WILL_DISAPPEAR )
DEF_SIGNAL( DID_DISAPPEAR )

DEF_SIGNAL( ORIENTATION_WILL_CHANGE )
DEF_SIGNAL( ORIENTATION_DID_CHANGED )

DEF_INT( STATE_DEACTIVATED,		0 )
DEF_INT( STATE_DEACTIVATING,	1 )
DEF_INT( STATE_ACTIVATING,		2 )
DEF_INT( STATE_ACTIVATED,		3 )

@synthesize parentBoard = _parent;
@synthesize name = _name;

@synthesize firstEnter = _firstEnter;
@synthesize presenting = _presenting;
@synthesize viewBuilt = _viewBuilt;
@synthesize dataLoaded = _dataLoaded;
@synthesize state = _state;

@synthesize createDate = _createDate;
@synthesize lastSleep = _lastSleep;
@synthesize lastWeekup = _lastWeekup;
@dynamic sleepDuration;
@dynamic weekupDuration;

@dynamic deactivated;
@dynamic deactivating;
@dynamic activating;
@dynamic activated;

@synthesize allowedPortrait = _allowedPortrait;
@synthesize allowedLandscape = _allowedLandscape;
@dynamic allowedSwipeToBack;
@synthesize disableLayout = _disableLayout;

#if __BEE_DEVELOPMENT__
@synthesize createSeq = _createSeq;
@synthesize signalSeq = _signalSeq;
@synthesize signals = _signals;
@synthesize callstack = _callstack;
#endif	// #if __BEE_DEVELOPMENT__

#if __BEE_DEVELOPMENT__
static NSUInteger			__createSeed = 0;
static NSMutableArray *		__allBoards = nil;
#endif	// #if __BEE_DEVELOPMENT__

#pragma mark -

+ (NSString *)generateName
{
	static NSUInteger __seed = 0;
	return [NSString stringWithFormat:@"board_%u", __seed++];
}

+ (NSArray *)allBoards
{
#if __BEE_DEVELOPMENT__
	return __allBoards;
#else	// #if __BEE_DEVELOPMENT__
	return nil;
#endif	// #if __BEE_DEVELOPMENT__
}

+ (id)board
{
	return [[[[self class] alloc] init] autorelease];
}

+ (id)boardWithNibName:(NSString *)nibNameOrNil
{
	return [[[self alloc] initWithNibName:nibNameOrNil bundle:nil] autorelease];
}

- (void)initSelf
{
	if ( NO == _inited )
	{
		_inited = YES;
		
#if __BEE_DEVELOPMENT__
		if ( nil == __allBoards )
		{
			__allBoards = [[NSMutableArray nonRetainingArray] retain];
		}
		
		[__allBoards insertObject:self atIndex:0];
#endif	// #if __BEE_DEVELOPMENT__
		
		_firstEnter = YES;
		_presenting = NO;
		_viewBuilt = NO;
		_dataLoaded = NO;
		_state = self.STATE_DEACTIVATED;
		
		_createDate = [[NSDate date] retain];
		_lastSleep = [NSDate timeIntervalSinceReferenceDate];
		_lastWeekup = [NSDate timeIntervalSinceReferenceDate];
		
		_allowedPortrait = YES;
		_allowedLandscape = YES;
		_allowedSwipeToBack = YES;
		
#if __BEE_DEVELOPMENT__
		_createSeq = __createSeed++;
		_signalSeq = 0;
		_signals = [[NSMutableArray alloc] init];
		
		_callstack = [[NSMutableArray alloc] init];
		[_callstack addObjectsFromArray:[BeeRuntime callstack:16]];
#endif	// #if __BEE_DEVELOPMENT__
		
		self.name = [BeeUIBoard generateName];
		
//		[self load];
		[self performLoad];
	}
}

- (id)init
{
//	self = [super init];
	self = [super initWithNibName:nil bundle:nil];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];

	[self cancelMessages];
	[self cancelRequests];
	
	[self unobserveTick];
	[self unobserveAllNotifications];
	
	[self freeDatas];
	[self deleteViews];

#if __BEE_DEVELOPMENT__
	[_signals removeAllObjects];
	[_signals release];
	
	[_callstack removeAllObjects];
	[_callstack release];
#endif	// #if __BEE_DEVELOPMENT__
	
	self.createDate = nil;
	self.name = nil;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

#if __BEE_DEVELOPMENT__
	[__allBoards removeObject:self];
#endif	// #if __BEE_DEVELOPMENT__

	[super dealloc];
}

#pragma mark -

- (BOOL)allowedSwipeToBack
{
	return _allowedSwipeToBack;
}

- (void)setAllowedSwipeToBack:(BOOL)flag
{
	_allowedSwipeToBack = flag;

	if ( _allowedSwipeToBack )
	{
		if ( nil == _swipeGesture )
		{
			_swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipedRight:)];
			_swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
			[self.view addGestureRecognizer:_swipeGesture];
		}
	}
	else
	{
		if ( _swipeGesture )
		{
			[self.view removeGestureRecognizer:_swipeGesture];
		
			[_swipeGesture setDelegate:nil];
			[_swipeGesture release];
			_swipeGesture = nil;
		}
	}
}

- (void)didSwipedRight:(UISwipeGestureRecognizer *)swipeGesture
{
	if ( UIGestureRecognizerStateEnded == swipeGesture.state )
	{
		if ( _allowedSwipeToBack )
		{
			[self.stack popBoardAnimated:YES];
		}
	}
}

#pragma mark -

- (void)changeStateDeactivated
{
	if ( self.STATE_DEACTIVATED != _state )
	{
		_state = self.STATE_DEACTIVATED;
		
		[self sendUISignal:BeeUIBoard.DID_DISAPPEAR];
	}
}

- (void)changeStateDeactivating
{
	if ( self.STATE_DEACTIVATING != _state )
	{
		_state = self.STATE_DEACTIVATING;
		
		[self sendUISignal:BeeUIBoard.WILL_DISAPPEAR];
	}
}

- (void)changeStateActivated
{
	if ( self.STATE_ACTIVATED != _state )
	{
		_state = self.STATE_ACTIVATED;
		
		[self sendUISignal:BeeUIBoard.DID_APPEAR];
	}
}

- (void)changeStateActivating
{
	if ( self.STATE_ACTIVATING != _state )
	{
		_state = self.STATE_ACTIVATING;
		
		[self sendUISignal:BeeUIBoard.WILL_APPEAR];
	}
}

#pragma mark -

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
//	INFO( @"'%@' loadView", [[self class] description] );
	
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

	if ( self.nibName )
	{
		[super loadView];
		
		self.view.signalReceiver = self;
	}
	else
	{
		self.view = [[[BeeUIBoardView alloc] initWithFrame:CGRectZero] autorelease];
		self.view.signalReceiver = self;
//		self.view.userInteractionEnabled = YES;
		self.view.backgroundColor = [UIColor clearColor];
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
//	INFO( @"'%@' viewDidLoad", [[self class] description] );
	
	[self createViews];
	[self loadDatas];

    [super viewDidLoad];
}

- (void)viewDidUnload
{
//	INFO( @"'%@' viewDidUnload", [[self class] description] );
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

	if ( _viewBuilt )
	{
		[self.view removeAllSubviews];
		self.view = nil;
	}

	[self deleteViews];
	[self freeDatas];
	
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
//	INFO( @"'%@' didReceiveMemoryWarning", [[self class] description] );
	
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

// Called when the view is about to made visible. Default does nothing
- (void)viewWillAppear:(BOOL)animated
{	
	if ( NO == _viewBuilt )
		return;
	
	_presenting = YES;
	
//	self.view.layer.shouldRasterize = YES;

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
	
//	self.view.layer.shouldRasterize = NO;
	
	[super viewDidAppear:animated];
	
	[self enableUserInteraction];
	[self changeStateActivated];
	
	_firstEnter = NO;
	
	[self setAllowedSwipeToBack:_allowedSwipeToBack];
}

// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewWillDisappear:(BOOL)animated
{
	if ( NO == _viewBuilt )
		return;
	
//	self.view.layer.shouldRasterize = YES;

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
	
//	self.view.layer.shouldRasterize = NO;
	
	_presenting = NO;
	
	[self disableUserInteraction];
	[self changeStateDeactivated];
	
	_lastSleep = [NSDate timeIntervalSinceReferenceDate];
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

#pragma mark -

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

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if ( _viewBuilt )
	{
		[self sendUISignal:BeeUIBoard.ORIENTATION_WILL_CHANGE];
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if ( _viewBuilt )
	{
		[self sendUISignal:BeeUIBoard.ORIENTATION_DID_CHANGED];
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
	return YES;
	
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

#pragma mark -

- (void)createViews
{
	if ( NO == _viewBuilt )
	{
		[self sendUISignal:BeeUIBoard.CREATE_VIEWS];
//		[self sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
		
		_viewBuilt = YES;
	}
}

- (void)deleteViews
{
	if ( YES == _viewBuilt )
	{
		[self.view removeGestureRecognizer:_swipeGesture];

		[self sendUISignal:BeeUIBoard.DELETE_VIEWS];

		_viewBuilt = NO;
	}
	
	[_swipeGesture setDelegate:nil];
	[_swipeGesture release];
	_swipeGesture = nil;
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
//		self.view.userInteractionEnabled = YES;
	}
}

- (void)disableUserInteraction
{
	if ( _viewBuilt )
	{
//		self.view.userInteractionEnabled = NO;
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

#pragma mark -

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
	return self.STATE_DEACTIVATED == _state ? YES : NO;
}

- (BOOL)deactivating
{
	return self.STATE_DEACTIVATING == _state ? YES : NO;
}

- (BOOL)activating
{
	return self.STATE_ACTIVATING == _state ? YES : NO;
}

- (BOOL)activated
{
	return self.STATE_ACTIVATED == _state ? YES : NO;
}

- (BeeUIBoardBlock)RELAYOUT
{
	BeeUIBoardBlock block = ^ BeeUIBoard * ( void )
	{
		[self sendUISignal:BeeUIBoard.LAYOUT_VIEWS withObject:[NSNumber numberWithBool:YES]];
		return self;
	};

	return [[block copy] autorelease];
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

#pragma mark -

- (void)handleUISignal:(BeeUISignal *)signal
{
#if __BEE_DEVELOPMENT__
	_signalSeq += 1;
	
	[_signals addObject:signal];
	[_signals keepTail:MAX_SIGNALS];
#endif	// #if __BEE_DEVELOPMENT__

	SIGNAL_FORWARD( signal );

	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			if ( nil == self.view.layout )
			{
				self.view.FROM_NAME( [self UIResourceName] );
			}

			if ( nil == self.view.layout )
			{
				Class boardClass = [self class];
				for ( ;; )
				{
					if ( [boardClass supportForUIResourceLoading] )
					{
						self.view.FROM_NAME( [boardClass description] );
						if ( nil != self.view.layout )
							break;
					}
					
					boardClass = class_getSuperclass( boardClass );
					if ( nil == boardClass || boardClass == [UIResponder class] )
						break;
				}
			}

			if ( nil == self.view.layout )
			{
				Class boardClass = [self.view class];
				for ( ;; )
				{
					if ( [boardClass supportForUIResourceLoading] )
					{
						self.view.FROM_NAME( [boardClass description] );
						if ( nil != self.view.layout )
							break;
					}
					
					boardClass = class_getSuperclass( boardClass );
					if ( nil == boardClass || boardClass == [UIResponder class] )
						break;
				}
			}

			self.view.autoresizesSubviews = YES;
			self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
			
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			if ( self.viewBuilt )
			{
				self.view.signalReceiver = nil;

				NSArray * array = [[self.view.subviews copy] autorelease];
				for ( UIView * view in array )
				{
					[view removeFromSuperview];
				}
			}
			
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
		{
			if ( self.viewBuilt )
			{
				if ( NO == _disableLayout )
				{
					self.view.RELAYOUT();
				}
			}
			
			UIView * titleView	= self.navigationItem.titleView;
			UIView * leftView	= self.navigationItem.leftBarButtonItem.customView;
			UIView * rightView	= self.navigationItem.rightBarButtonItem.customView;

			if ( titleView )
			{
				CGRect	titleFrame;
				CGSize	boundSize = titleView.superview.frame.size;

				titleFrame.size = [titleView estimateUISizeByBound:boundSize];

				if ( 0 == titleFrame.size.width )
				{
					titleFrame.size.width = boundSize.width * 0.625f;
				}

				if ( 0 == titleFrame.size.height )
				{
					titleFrame.size.height = boundSize.height;
				}

				titleFrame.origin.y = (boundSize.height - titleFrame.size.height) / 2.0f;
				titleFrame.origin.x = (boundSize.width - titleFrame.size.width) / 2.0f;
				
				titleView.frame = titleFrame;
			}

			if ( leftView )
			{
				CGRect	leftFrame;
				CGSize	boundSize = [BeeUINavigationBar buttonSize];

				leftFrame.origin = leftView.frame.origin;
				leftFrame.size = [leftView estimateUISizeByBound:[BeeUINavigationBar buttonSize]];

				if ( 0 == leftFrame.size.width )
				{
					leftFrame.size.width = boundSize.width;
				}
				
				if ( 0 == leftFrame.size.height )
				{
					leftFrame.size.height = boundSize.height;
				}

				leftView.frame = leftFrame;
			}

			if ( rightView )
			{
				CGRect	rightFrame;
				CGSize	boundSize = [BeeUINavigationBar buttonSize];

				rightFrame.origin = rightView.frame.origin;
				rightFrame.size = [rightView estimateUISizeByBound:[BeeUINavigationBar buttonSize]];

				if ( 0 == rightFrame.size.width )
				{
					rightFrame.size.width = boundSize.width;
				}

				if ( 0 == rightFrame.size.height )
				{
					rightFrame.size.height = boundSize.height;
				}

				rightView.frame = rightFrame;
			}
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.DID_APPEAR] )
		{
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
		{
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{
			// TODO:
		}
	}
	else
	{
		if ( self.parentBoard )
		{
			[signal forward:self.parentBoard.view];
		}
	}
}

#pragma mark -

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault;

//	if ( IOS7_OR_LATER )
//	{
//		if ( [BeeUIConfig sharedInstance].iOS6Mode )
//		{
//			return UIStatusBarStyleBlackTranslucent;
//		}
//		else
//		{
//			return UIStatusBarStyleLightContent;
//		}
//	}
//	else
//	{
//		return UIStatusBarStyleDefault;
//	}
}

#endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "Bee_UIScrollView.h"
#import "Bee_UISignalBus.h"

#import "Bee_UIPullLoader.h"
#import "Bee_UIFootLoader.h"
#import "Bee_UIConfig.h"

#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

#undef	MIN_ORDER
#define MIN_ORDER			(0)

#undef	MAX_ORDER
#define MAX_ORDER			(1000)

#undef	MAX_LINES
#define MAX_LINES			(128)

#undef	MAX_QUEUED_ITEMS
#define	MAX_QUEUED_ITEMS	(32)

#undef	ANIMATION_DURATION
#define	ANIMATION_DURATION	(0.3f)

#pragma mark -

@interface BeeUIScrollItem()
{
	BOOL					_visible;
	NSInteger				_line;
	CGFloat					_scale;
	NSInteger				_columns;
	CGRect					_rect;
    
	BeeUIScrollLayoutRule	_rule;
	NSInteger				_order;
	NSInteger				_section;
	NSInteger				_index;
	
	NSString *				_name;
	UIView *				_view;
	id						_data;
	Class					_clazz;
	UIEdgeInsets			_insets;
	CGSize					_size;
}

@property (nonatomic, assign) BOOL					visible;
@property (nonatomic, assign) NSInteger				line;
@property (nonatomic, assign) NSInteger				columns;
@property (nonatomic, assign) CGFloat				scale;
@property (nonatomic, assign) CGRect				rect;

@end

#pragma mark -

@implementation BeeUIScrollItem

@synthesize rule = _rule;
@synthesize order = _order;
@synthesize section = _section;
@synthesize index = _index;
@synthesize name = _name;

@synthesize view = _view;
@synthesize data = _data;
@synthesize clazz = _clazz;
@synthesize insets = _insets;
@synthesize size = _size;

@dynamic viewData;
@dynamic viewClass;
@dynamic viewInsets;
@dynamic viewSize;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_visible = NO;
		_line = 0;
		_scale = 1.0f;
		_columns = 1;
		_rect = CGRectAuto;
		
		_rule = BeeUIScrollLayoutRuleVertical;
		_order = MIN_ORDER;
		_section = 0;
		_index = 0;
        
		_view = nil;
		_data = nil;
		_clazz = nil;
		_insets = UIEdgeInsetsZero;
		_size = CGSizeAuto;
	}
	return self;
}

- (void)dealloc
{
	[_view removeFromSuperview];
	[_view release];
	
	[_name release];
    
	[super dealloc];
}

- (id)viewData
{
	return self.data;
}

- (void)setViewData:(id)d
{
	self.data = d;
}

- (Class)viewClass
{
	return self.clazz;
}

- (void)setViewClass:(Class)c
{
	self.clazz = c;
}

- (UIEdgeInsets)viewInsets
{
	return self.insets;
}

- (void)setViewInsets:(UIEdgeInsets)i
{
	self.insets = i;
}

- (CGSize)viewSize
{
	return self.size;
}

- (void)setViewSize:(CGSize)s
{
	self.size = s;
}

@end

#pragma mark -

@implementation BeeUIScrollSection

@synthesize viewClass = _viewClass;
@synthesize viewInsets = _viewInsets;
@synthesize name = _name;
@synthesize rule = _rule;

- (void)dealloc
{
	self.viewClass = nil;
	self.name = nil;
	
	[super dealloc];
}

@end

#pragma mark -

@interface BeeUIScrollView()
{
	BOOL						_inited;
    
	id							_dataSource;
	NSInteger					_direction;
	CGFloat						_animationDuration;
    
	NSInteger					_visibleStart;
	NSInteger					_visibleEnd;
    
	NSInteger					_lineCount;
	CGFloat						_lineHeights[MAX_LINES];
	
	NSInteger					_index;
	NSInteger					_total;
	NSMutableArray *			_items;
	NSMutableArray *			_sections;
	NSMutableDictionary *		_sectionDatas;
    
	BOOL						_autoReload;
	BOOL						_shouldNotify;
	BOOL						_reloaded;
	BOOL						_reloading;
	UIEdgeInsets				_baseInsets;
	UIEdgeInsets				_extInsets;
	
	BOOL						_reachTop;
	BOOL						_reachEnd;
	BOOL						_reuseEnable;
	NSMutableArray *			_reuseQueue;
	
	CGPoint						_scrollSpeed;
	CGPoint						_lastScrollOffset;
	NSTimeInterval				_lastScrollTime;
    
	Class						_headerClass;
	Class						_footerClass;
    
	BeeUIPullLoader *			_headerLoader;
	BeeUIFootLoader *			_footerLoader;
	
	BeeUIScrollViewBlock		_whenReloading;
	BeeUIScrollViewBlock		_whenReloaded;
	BeeUIScrollViewBlock		_whenLayouting;
	BeeUIScrollViewBlock		_whenlayouted;
	BeeUIScrollViewBlock		_whenAnimating;
	BeeUIScrollViewBlock		_whenAnimated;
	BeeUIScrollViewBlockI		_whenDequeue;
	BeeUIScrollViewBlock		_whenScrolling;
	BeeUIScrollViewBlock		_whenDragged;
	BeeUIScrollViewBlock		_whenStop;
	BeeUIScrollViewBlock		_whenReachTop;
	BeeUIScrollViewBlock		_whenReachBottom;
	BeeUIScrollViewBlock		_whenHeaderRefresh;
	BeeUIScrollViewBlock		_whenFooterRefresh;
}

- (void)initSelf;

- (void)recalcItems:(BOOL)force;
- (void)reloadItems:(BOOL)force;
- (void)reloadSections;
- (BOOL)recalcRange;

- (UIEdgeInsets)calcInsets;
- (void)applyInsets;

- (void)syncPositionsIfNeeded;
- (void)syncCellPositions;
- (void)syncPullPositions;
- (void)syncPullInsets;

- (NSInteger)getShortestLine;
- (NSInteger)getLongestLine;

- (void)operateReloadData;
- (void)internalReloadData;

- (void)enqueueItem:(BeeUIScrollItem *)item;
- (void)dequeueItem:(BeeUIScrollItem *)item;

- (void)notifyReloading;
- (void)notifyReloaded;
- (void)notifyLayouting;
- (void)notifyLayouted;
- (void)notifyAnimating;
- (void)notifyAnimated;
- (void)notifyReachTop;
- (void)notifyReachBottom;
- (void)notifyHeaderRefresh;
- (void)notifyFooterRefresh;

@end

#pragma mark -

@implementation BeeUIScrollView

IS_CONTAINABLE( YES )

DEF_INT( DIRECTION_HORIZONTAL,	0 )
DEF_INT( DIRECTION_VERTICAL,	1 )

DEF_INT( STYLE_DEFAULT,			0 )
DEF_INT( STYLE_AUTOBREAK,		1 )
DEF_INT( STYLE_AUTOFILLING,		2 )
DEF_INT( STYLE_AUTOSHIFT,		3 )

DEF_SIGNAL( RELOADING )
DEF_SIGNAL( RELOADED )
DEF_SIGNAL( LAYOUTING )
DEF_SIGNAL( LAYOUTED )
DEF_SIGNAL( ANIMATING )
DEF_SIGNAL( ANIMATED )
DEF_SIGNAL( REACH_TOP )
DEF_SIGNAL( REACH_BOTTOM )

DEF_SIGNAL( DID_DRAG )
DEF_SIGNAL( DID_STOP )
DEF_SIGNAL( DID_SCROLL )

DEF_SIGNAL( HEADER_REFRESH )
DEF_SIGNAL( FOOTER_REFRESH )

@synthesize dataSource = _dataSource;
@synthesize animationDuration = _animationDuration;

@dynamic horizontal;
@dynamic vertical;
@dynamic headerShown;
@dynamic footerShown;

@dynamic visibleStart;
@dynamic visibleEnd;

@dynamic visibleRange;
@dynamic visiblePageIndex;

@synthesize autoReload = _autoReload;
@synthesize reloaded = _reloaded;
@synthesize reloading = _reloading;

@synthesize reuseEnable = _reuseEnable;
@synthesize reuseQueue = _reuseQueue;

@synthesize scrollSpeed = _scrollSpeed;
@dynamic scrollPercent;

@dynamic pageCount;
@dynamic pageIndex;
@dynamic baseInsets;
@dynamic extInsets;

@dynamic lineSize;
@synthesize lineCount = _lineCount;

@dynamic total;
@dynamic datas;
@dynamic items;
@dynamic firstItem;
@dynamic nextItem;
@dynamic lastItem;
@dynamic visibleItems;
@synthesize enableAllEvents = _enableAllEvents;

@synthesize headerClass = _headerClass;
@synthesize footerClass = _footerClass;

@synthesize headerLoader = _headerLoader;
@synthesize footerLoader = _footerLoader;

@dynamic headerLoading;
@dynamic footerLoading;
@dynamic footerMore;

@synthesize whenReloading = _whenReloading;
@synthesize whenReloaded = _whenReloaded;
@synthesize whenLayouting = _whenLayouting;
@synthesize whenLayouted = _whenlayouted;
@synthesize whenAnimating = _whenAnimating;
@synthesize whenAnimated = _whenAnimated;
@synthesize whenScrolling = _whenScrolling;
@synthesize whenDragged = _whenDragged;
@synthesize whenStop = _whenStop;
@synthesize whenReachTop = _whenReachTop;
@synthesize whenReachBottom = _whenReachBottom;
@synthesize whenHeaderRefresh = _whenHeaderRefresh;
@synthesize whenFooterRefresh = _whenFooterRefresh;

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

// thanks to @ilikeido
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if ( self )
    {
		[self initSelf];
    }
    return self;
}

- (void)initSelf
{
	if ( NO == _inited )
	{
		_animationDuration = ANIMATION_DURATION;
        
		_direction = self.DIRECTION_VERTICAL;
		_shouldNotify = YES;
		_reloaded = NO;
		
		_lineCount = 1;
		
		_total = 0;
		_items = [[NSMutableArray alloc] init];
		_sections = [[NSMutableArray alloc] init];
		_sectionDatas = [[NSMutableDictionary alloc] init];
        
		_reuseEnable = YES;
		_reuseQueue = [[NSMutableArray nonRetainingArray] retain];
        
		_visibleStart = 0;
		_visibleEnd = 0;
		
		_reachTop = NO;
		_reachEnd = NO;
		_baseInsets = UIEdgeInsetsZero;
		_extInsets = UIEdgeInsetsZero;
		
        //		self.headerClass = [BeeUIPullLoader class];
        //		self.footerClass = [BeeUIFootLoader class];
        
		self.backgroundColor = [UIColor clearColor];
		self.contentSize = self.frame.size;
		self.contentInset = _baseInsets;
		self.alwaysBounceVertical = YES;
		self.alwaysBounceHorizontal = NO;
		self.directionalLockEnabled = YES;
		self.bounces = YES;
		self.scrollEnabled = YES;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.indicatorStyle = UIScrollViewIndicatorStyleDefault;
		self.alpha = 1.0f;
		self.delegate = self;
		self.layer.masksToBounds = YES;
		
		if ( [BeeUIConfig sharedInstance].highPerformance )
		{
			self.decelerationRate = self.decelerationRate * 0.995f;
		}
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
		if ( IOS7_OR_LATER )
		{
            //			self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
		}
#endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        //		[self load];
		[self performLoad];
	}
}

- (void)dealloc
{
    //	[self unload];
	[self performUnload];
    
	for ( BeeUIScrollItem * item in _items )
	{
		if ( item.view )
		{
			[item.view removeFromSuperview];
			item.view = nil;
		}
	}
    
	self.headerClass = nil;
	self.footerClass = nil;
    
	self.whenReloading = nil;
	self.whenReloaded = nil;
	self.whenLayouting = nil;
	self.whenLayouted = nil;
	self.whenAnimating = nil;
	self.whenAnimated = nil;
	self.whenScrolling = nil;
	self.whenStop = nil;
    
	SAFE_RELEASE_SUBVIEW( _headerLoader );
	SAFE_RELEASE_SUBVIEW( _footerLoader );
    
	[_reuseQueue removeAllObjects];
	[_reuseQueue release];
	_reuseQueue = nil;
    
	[_sectionDatas removeAllObjects];
	[_sectionDatas release];
	_sectionDatas = nil;
	
	[_sections removeAllObjects];
	[_sections release];
	_sections = nil;
    
	[_items removeAllObjects];
	[_items release];
	_items = nil;
    
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateReloadData) object:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
    
	[super dealloc];
}

- (void)removeFromSuperview
{
	_dataSource = nil;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
    
	[super removeFromSuperview];
}

- (BOOL)horizontal
{
	return self.DIRECTION_HORIZONTAL == _direction ? YES : NO;
}

- (void)setHorizontal:(BOOL)horizonal
{
	if ( horizonal )
	{
		_direction = self.DIRECTION_HORIZONTAL;
		
		self.alwaysBounceHorizontal = YES;
		self.alwaysBounceVertical = NO;
		
        //		self.showsHorizontalScrollIndicator = NO;
        //		self.showsVerticalScrollIndicator = NO;
	}
}

- (BOOL)vertical
{
	return self.DIRECTION_VERTICAL == _direction ? YES : NO;
}

- (void)setVertical:(BOOL)vertical
{
	if ( vertical )
	{
		_direction = self.DIRECTION_VERTICAL;
		
		self.alwaysBounceVertical = YES;
		self.alwaysBounceHorizontal = NO;
		
        //		self.showsVerticalScrollIndicator = NO;
        //		self.showsHorizontalScrollIndicator = NO;
	}
}

- (NSInteger)visibleStart
{
	return _visibleStart;
}

- (NSInteger)visibleEnd
{
	return _visibleEnd;
}

- (NSRange)visibleRange
{
	return NSMakeRange( _visibleStart, _visibleEnd - _visibleStart );
}

- (NSUInteger)visiblePageIndex
{
	// special thanks to @Royall
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		return (NSUInteger)floorf( _total - ((self.contentSize.width - self.contentOffset.x) / self.frame.size.width) + 0.5f );
	}
	else
	{
		return (NSUInteger)floorf( _total - ((self.contentSize.height - self.contentOffset.y) / self.frame.size.height) + 0.5f );
	}
}

- (CGFloat)scrollPercent
{
	CGFloat percent = 0.0f;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		percent = self.contentOffset.x / self.contentSize.width;
	}
	else
	{
		percent = self.contentOffset.y / self.contentSize.height;
	}
    
	return percent;
}

- (NSInteger)pageCount
{
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		return (self.contentSize.width + self.frame.size.width - 1) / self.frame.size.width;
	}
	else
	{
		return (self.contentSize.height + self.frame.size.height - 1) / self.frame.size.height;
	}
}

- (NSInteger)pageIndex
{
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		return self.contentOffset.x / self.frame.size.width;
	}
	else
	{
		return self.contentOffset.y / self.frame.size.height;
	}
}

- (void)setPageIndex:(NSInteger)index
{
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		self.contentOffset = CGPointMake( self.frame.size.width * index, self.contentOffset.y );
	}
	else
	{
		self.contentOffset = CGPointMake( self.contentOffset.x, self.frame.size.height * index );
	}
}

- (void)setBaseInsets:(UIEdgeInsets)insets
{
	_baseInsets = insets;
	
	[self applyInsets];
}

- (UIEdgeInsets)baseInsets
{
	return _baseInsets;
}

- (void)setExtInsets:(UIEdgeInsets)insets
{
	_extInsets = insets;
	
	[self applyInsets];
}

- (UIEdgeInsets)extInsets
{
	return _extInsets;
}

- (UIEdgeInsets)calcInsets
{
	UIEdgeInsets insets = UIEdgeInsetsZero;
	
	insets.top = _baseInsets.top + _extInsets.top;
	insets.left = _baseInsets.left + _extInsets.left;
	insets.right = _baseInsets.right + _extInsets.right;
	insets.bottom = _baseInsets.bottom + _extInsets.bottom;
    
	return insets;
}

- (void)applyInsets
{
	self.contentInset = [self calcInsets];
	
	[self syncPullPositions];
	[self syncPullInsets];
}

- (NSInteger)total
{
	return _total;
}

- (void)setTotal:(NSInteger)tot
{
	for ( NSInteger t = _total; t < tot; ++t )
	{
		if ( _items.count >= tot )
			break;
        
		BeeUIScrollItem * item = [[BeeUIScrollItem alloc] init];
		if ( item  )
		{
			item.index = _items.count;
			[_items addObject:item];
			[item release];
		}
	}
	
	_total = tot;
}

- (NSDictionary *)datas
{
	return _sectionDatas;
}

- (void)setDatas:(NSDictionary *)d
{
	[_sectionDatas setDictionary:d];
	
	[self reloadSections];
}

- (NSArray *)items
{
	return _items;
}

- (BeeUIScrollItem *)firstItem
{
	_index = 0;
	
	[self setTotal:1];

	return [_items firstObject];
}

- (BeeUIScrollItem *)nextItem
{
	_index += 1;
	
	[self setTotal:(_index + 1)];

	return [_items objectAtIndex:_index];
}

- (BeeUIScrollItem *)lastItem
{
	return [_items lastObject];
}

- (NSArray *)visibleItems
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
    
	if ( _items.count > 0 )
	{
		for ( NSInteger l = _visibleStart; l < _visibleEnd; ++l )
		{
			if ( l >= _items.count )
				break;
			
			BeeUIScrollItem * item = [_items objectAtIndex:l];
			[array addObject:item];
		}
	}
	
	return array;
}

- (void)notifyLayouting
{
    PERF_ENTER
	
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.LAYOUTING];
		}
        
		if ( self.whenLayouting )
		{
			self.whenLayouting();
		}
	}
	
    PERF_LEAVE
}

- (void)notifyLayouted
{
    PERF_ENTER
	
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.LAYOUTED];
		}
		
		if ( self.whenLayouted )
		{
			self.whenLayouted();
		}
	}
	
    PERF_LEAVE
}

- (void)notifyReloading
{
    PERF_ENTER
	
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.RELOADING];
		}
		
		if ( self.whenReloading )
		{
			self.whenReloading();
		}
	}
	
    PERF_LEAVE
}

- (void)notifyReloaded
{
    PERF_ENTER
	
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.RELOADED];
		}
		
		if ( self.whenReloaded )
		{
			self.whenReloaded();
		}
	}
	
    PERF_LEAVE
}

- (void)notifyAnimating
{
    PERF_ENTER
	
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.ANIMATING];
		}
		
		if ( self.whenAnimating )
		{
			self.whenAnimating();
		}
	}
	
    PERF_LEAVE
}

- (void)notifyAnimated
{
    PERF_ENTER
	
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.ANIMATED];
		}
		
		if ( self.whenAnimated )
		{
			self.whenAnimated();
		}
	}
	
    PERF_LEAVE
}

- (void)notifyReachTop
{
    PERF_ENTER
	
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.REACH_TOP];
		}
        
		if ( self.whenReachTop )
		{
			self.whenReachTop();
		}
	}
	
    PERF_LEAVE
}

- (void)notifyReachBottom
{
    PERF_ENTER
	
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.REACH_BOTTOM];
		}
		
		if ( self.whenReachBottom )
		{
			self.whenReachBottom();
		}
	}
	
    PERF_LEAVE
}

- (void)notifyHeaderRefresh
{
    PERF_ENTER
    
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.HEADER_REFRESH];
		}
		
		if ( self.whenHeaderRefresh )
		{
			self.whenHeaderRefresh();
		}
	}
	
    PERF_LEAVE
}

- (void)notifyFooterRefresh
{
    PERF_ENTER
	
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.FOOTER_REFRESH];
		}
		
		if ( self.whenFooterRefresh )
		{
			self.whenFooterRefresh();
		}
	}
    
    PERF_LEAVE
}

- (void)recalcFrames
{
	[self recalcFramesAnimated:YES];
}

- (void)recalcFramesAnimated:(BOOL)animated
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateReloadData) object:nil];
    
	[self notifyReloading];
    
	if ( _dataSource && [_dataSource respondsToSelector:@selector(numberOfLinesInScrollView:)] )
	{
		_lineCount = [_dataSource numberOfLinesInScrollView:self];
	}
	
	if ( _dataSource && [_dataSource respondsToSelector:@selector(numberOfViewsInScrollView:)] )
	{
		_total = [_dataSource numberOfViewsInScrollView:self];
	}
    
    //	[self reloadItems:NO];
	[self reloadItems:NO];
    //	[self recalcRange];
	
	[self notifyLayouting];
	
	_reloaded = YES;
    
	if ( animated )
	{
		[self notifyAnimating];
        
		[UIView beginAnimations:nil context:nil];
        //		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:self.animationDuration];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(didAnimationStop)];
	}
    
	[self syncCellPositions];
	[self syncPullPositions];
	[self syncPullInsets];
    
	if ( animated )
	{
		[UIView commitAnimations];
	}
    
	[self notifyLayouted];
	[self notifyReloaded];
	
    //	[self setNeedsDisplay];
}

- (void)reloadData
{
	[self syncReloadData];
}

- (void)syncReloadData
{
	PERF( @"UIScrollView %p, reloadData", self );
	
	self.userInteractionEnabled = NO;
	
	[self cancelReloadData];
	_reloading = YES;
	[self operateReloadData];
	
	self.userInteractionEnabled = YES;
}

- (void)asyncReloadData
{
	PERF( @"UIScrollView %p, reloadData", self );
	
	if ( NO == _reloading )
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateReloadData) object:nil];
		[self performSelector:@selector(operateReloadData) withObject:nil afterDelay:0.1f];
		_reloading = YES;
	}
}

- (void)cancelReloadData
{
	if ( YES == _reloading )
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateReloadData) object:nil];
		_reloading = NO;
	}
}

- (void)operateReloadData
{
	if ( YES == _reloading )
	{
		_reloading = NO;
		
		[self internalReloadData];
	}
}

- (void)internalReloadData
{
	[self notifyReloading];
    
	if ( _dataSource && [_dataSource respondsToSelector:@selector(numberOfLinesInScrollView:)] )
	{
		_lineCount = [_dataSource numberOfLinesInScrollView:self];
	}
    
	if ( _dataSource && [_dataSource respondsToSelector:@selector(numberOfViewsInScrollView:)] )
	{
		_total = [_dataSource numberOfViewsInScrollView:self];
	}
    
	_visibleStart = 0;
	_visibleEnd = 0;
    
	[self reloadItems:YES];
	[self recalcRange];
	[self recalcItems:YES];
    
	[self notifyLayouting];
    
	[self syncCellPositions];
	[self syncPullPositions];
	[self syncPullInsets];
	
	[self notifyLayouted];
    
	_reloaded = YES;
	
	[self notifyReloaded];
	
	[self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
	_shouldNotify = NO;
	
	[super setFrame:frame];
    
    if ( CGRectEqualToRect(frame, CGRectZero) )
        return;
    
	if ( CGSizeEqualToSize(self.contentSize, CGSizeZero) )
	{
		self.contentSize = frame.size;
		self.contentInset = [self calcInsets];
	}
	
	_shouldNotify = YES;
	
    //	if ( NO == _reloaded )
    //	{
    //		[self syncReloadData];
    //	}
    //	else
	{
		[self asyncReloadData];
	}
    
	[self syncPullPositions];
	[self syncPullInsets];
}

- (void)setHidden:(BOOL)flag
{
    if ( self.hidden == flag )
        return;
        
	_shouldNotify = NO;
    
	[super setHidden:flag];

	_shouldNotify = YES;
    
    //	if ( NO == _reloaded )
    //	{
    //		[self syncReloadData];
    //	}
    //	else
	{
		[self asyncReloadData];
	}
    
	[self syncPullPositions];
	[self syncPullInsets];
}

- (void)scrollToFirstPage:(BOOL)animated
{
	CGPoint offset;
    
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		offset.x = -1.0f * [self calcInsets].left;
		offset.y = self.contentOffset.y;
	}
	else
	{
		offset.x = self.contentOffset.x;
		offset.y = -1.0f * [self calcInsets].top;
	}
    
    //	if ( animated )
    //	{
    //		[UIView beginAnimations:nil context:NULL];
    //		[UIView setAnimationBeginsFromCurrentState:YES];
    //		[UIView setAnimationDuration:self.animationDuration];
    //	}
	
	[self setContentOffset:offset animated:animated];
	
    //	if ( animated )
    //	{
    //		[UIView commitAnimations];
    //	}
}

- (void)scrollToLastPage:(BOOL)animated
{
	CGPoint offset;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		offset.x = self.contentOffset.x + self.contentSize.width + 1.0f * [self calcInsets].right;
		offset.y = self.contentOffset.y;
	}
	else
	{
		offset.x = self.contentOffset.x;
		offset.y = self.contentOffset.y + self.contentSize.height + 1.0f * [self calcInsets].bottom;
	}
    
    //	if ( animated )
    //	{
    //		[UIView beginAnimations:nil context:NULL];
    //		[UIView setAnimationBeginsFromCurrentState:YES];
    //		[UIView setAnimationDuration:self.animationDuration];
    //	}
	
	[self setContentOffset:offset animated:animated];
	
    //	if ( animated )
    //	{
    //		[UIView commitAnimations];
    //	}
}

- (void)scrollToPrevPage:(BOOL)animated
{
	CGPoint offset;
	UIEdgeInsets insets = [self calcInsets];
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		if ( self.contentSize.width < self.frame.size.width )
			return;
		
		offset.x = self.contentOffset.x - self.frame.size.width;
		offset.y = self.contentOffset.y;
		
		if ( offset.x < -1.0f * insets.left )
		{
			offset.x = -1.0f * insets.left;
		}
	}
	else
	{
		if ( self.contentSize.height < self.frame.size.height )
			return;
		
		offset.x = self.contentOffset.x;
		offset.y = self.contentOffset.y - self.frame.size.height;
		
		if ( offset.x < -1.0f * insets.top )
		{
			offset.x = -1.0f * insets.top;
		}
	}
    
    //	if ( animated )
    //	{
    //		[UIView beginAnimations:nil context:NULL];
    //		[UIView setAnimationBeginsFromCurrentState:YES];
    //		[UIView setAnimationDuration:self.animationDuration];
    //	}
    
	[self setContentOffset:offset animated:animated];
	
    //	if ( animated )
    //	{
    //		[UIView commitAnimations];
    //	}
}

- (void)scrollToNextPage:(BOOL)animated
{
	CGPoint offset;
	UIEdgeInsets insets = [self calcInsets];
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		if ( self.contentSize.width < self.frame.size.width )
			return;
		
		offset.x = self.contentOffset.x + self.frame.size.width;
		offset.y = self.contentOffset.y;
		
		CGFloat rightBound = self.contentOffset.x + self.contentSize.width + 1.0f * insets.right;
		
		if ( self.contentSize.width > self.frame.size.width )
		{
			if (self.contentOffset.x < (self.contentSize.width - self.frame.size.width)  )
			{
				offset.x = rightBound - self.frame.size.width;
			}
			else
			{
				offset.x =  (self.contentSize.width - self.frame.size.width + 1.0f * insets.right);
			}
		}
		else
		{
			offset.x =  (self.contentSize.width - self.frame.size.width + 1.0f * insets.right);
		}
	}
	else
	{
		if ( self.contentSize.height < self.frame.size.height )
			return;
		
		offset.x = self.contentOffset.x;
		offset.y = self.contentOffset.y + self.frame.size.height;
        
		CGFloat bottomBound = self.contentOffset.y + self.contentSize.height + 1.0f * insets.bottom;
		
		if ( offset.y > bottomBound )
		{
			offset.y = bottomBound - self.frame.size.height;
		}
	}
	
    //	if ( animated )
    //	{
    //		[UIView beginAnimations:nil context:NULL];
    //		[UIView setAnimationBeginsFromCurrentState:YES];
    //		[UIView setAnimationDuration:self.animationDuration];
    //	}
	
	[self setContentOffset:offset animated:animated];
	
    //	if ( animated )
    //	{
    //		[UIView commitAnimations];
    //	}
}

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated
{
	if ( 0 == _total || index >= _total )
		return;
	
	UIEdgeInsets insets = [self calcInsets];
    
	if ( self.DIRECTION_VERTICAL == _direction )
	{
		CGFloat contentHeight = self.contentSize.height + insets.top + insets.bottom;
		
		if ( contentHeight <= self.frame.size.height )
		{
			return;
		}
	}
	else if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		CGFloat contentWidth = self.contentSize.width + insets.left + insets.right;
		
		if ( contentWidth <= self.frame.size.width )
		{
			return;
		}
	}
    
	CGRect frame = ((BeeUIScrollItem *)[_items objectAtIndex:index]).rect;
    
	if ( CGRectEqualToRect(frame, CGRectZero) )
	{
		return;
	}
    
	CGFloat	margin = 0.0f;
	CGPoint	offset = CGPointZero;
    
	if ( self.DIRECTION_VERTICAL == _direction )
	{
		if ( [BeeUIConfig sharedInstance].iOS7Mode && IOS7_OR_LATER )
		{
			if ( NO == [UIApplication sharedApplication].statusBarHidden )
			{
				margin = (self.frame.size.height - 44.0f - 20.0f - frame.size.height) / 2.0f;
			}
			else
			{
				margin = (self.frame.size.height - 44.0f - frame.size.height) / 2.0f;
			}
		}
		else
		{
			margin = (self.frame.size.height - frame.size.height) / 2.0f;
		}
		
		offset.x = self.contentOffset.x;
		offset.y = frame.origin.y - margin;
		
		if ( offset.y < 0.0f )
		{
			offset.y = 0.0f;
		}
		else if ( offset.y + self.frame.size.height > self.contentSize.height )
		{
			offset.y = self.contentSize.height - self.frame.size.height;
		}
		
		offset.y -= insets.top;
	}
	else if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		if ( [BeeUIConfig sharedInstance].iOS7Mode && IOS7_OR_LATER )
		{
			if ( NO == [UIApplication sharedApplication].statusBarHidden )
			{
				margin = (self.frame.size.width - 44.0f - 20.0f - frame.size.width) / 2.0f;
			}
			else
			{
				margin = (self.frame.size.width - 44.0f - frame.size.width) / 2.0f;
			}
		}
		else
		{
			margin = (self.frame.size.width - frame.size.width) / 2.0f;
		}
        
		offset.x = frame.origin.x - margin;
		offset.y = self.contentOffset.y;
		
		if ( offset.x < 0.0f )
		{
			offset.x = 0.0f;
		}
		else if ( offset.x + self.frame.size.width > self.contentSize.width )
		{
			offset.x = self.contentSize.width - self.frame.size.width;
		}
		
		offset.x -= insets.left;
	}
	
    //	if ( animated )
    //	{
    //		[UIView beginAnimations:nil context:NULL];
    //		[UIView setAnimationBeginsFromCurrentState:YES];
    //		[UIView setAnimationDuration:self.animationDuration];
    //	}
	
	[self setContentOffset:offset animated:animated];
	
    //	if ( animated )
    //	{
    //		[UIView commitAnimations];
    //	}
}

- (void)scrollToView:(UIView *)view animated:(BOOL)animated
{
	for ( BeeUIScrollItem * item in _items )
	{
		if ( item.view == view )
		{
			[self scrollToIndex:item.index animated:animated];
			break;
		}
	}
}

- (id)dequeueWithContentClass:(Class)clazz
{
    PERF_ENTER
    
    PERF_ENTER_( _______reuse )
	
	if ( _reuseEnable )
	{
		for ( UIView * reuseView in _reuseQueue )
		{
			if ( [reuseView isKindOfClass:clazz] )
			{
				PERF( @"UIScrollView %p, dequeue '%@' %p", self, [[reuseView class] description], reuseView );
                
				[_reuseQueue removeObject:reuseView];
				return reuseView;
			}
		}
	}
	
    PERF_LEAVE_( _______reuse )
    PERF_ENTER_( _______alloc )
	
    PERF_ENTER_( _______alloc1 )
	UIView * newView = (UIView *)[BeeRuntime allocByClass:clazz];
    PERF_LEAVE_( _______alloc1 )
	
	if ( newView )
	{
        PERF_ENTER_( _______alloc2 )
		newView = [[newView initWithFrame:CGRectZero] autorelease];
        PERF_LEAVE_( _______alloc2 )
		
		PERF( @"UIScrollView %p, create '%@' %p", self, [clazz description], newView );
	}
    
    PERF_LEAVE_( _______alloc )
    
    PERF_LEAVE
	
	return newView;
}

- (void)enqueueItem:(BeeUIScrollItem *)item
{
	if ( nil == item.view )
		return;
	
	PERF( @"UIScrollView %p, enqueueItem %d => '%@'", self, item.index, [item.clazz description] );
	
	BOOL shouldRemove = YES;
    
    PERF_ENTER
    
	if ( _reuseEnable )
	{
		if ( _reuseQueue.count < MAX_QUEUED_ITEMS )
		{
			[_reuseQueue insertObject:item.view atIndex:0];
            
			shouldRemove = NO;
		}
	}
	
	if ( item.view && [item.view respondsToSelector:@selector(unbindData)] )
	{
		[item.view performSelector:@selector(unbindData) withObject:nil];
	}
	
	if ( item.visible )
	{
		if ( [item.view respondsToSelector:@selector(viewWillDisappear)] )
		{
			[item.view performSelector:@selector(viewWillDisappear) withObject:nil];
		}
        
		item.visible = NO;
		item.view.hidden = YES;
        
		if ( [item.view respondsToSelector:@selector(viewDidDisappear)] )
		{
			[item.view performSelector:@selector(viewDidDisappear) withObject:nil];
		}
	}
    
    item.view.hidden = YES;
    
	if ( shouldRemove )
	{
		[item.view removeFromSuperview];
	}

	item.view = nil;
	
    PERF_LEAVE
}

- (void)dequeueItem:(BeeUIScrollItem *)item
{
	PERF( @"UIScrollView %p, dequeueItem %d => '%@'", self, item.index, [item.clazz description] );
	
	PERF_ENTER
    PERF_ENTER_( _______dequeueItem1 )
	
	if ( item.view )
	{
		if ( item.clazz && NO == [item.view isKindOfClass:item.clazz] )
		{
			BOOL shouldRemove = YES;
			
			if ( _reuseEnable )
			{
				if ( _reuseQueue.count < MAX_QUEUED_ITEMS )
				{
					[_reuseQueue insertObject:item.view atIndex:0];
					
					shouldRemove = NO;
				}
			}
			
			if ( item.view && [item.view respondsToSelector:@selector(unbindData)] )
			{
				[item.view performSelector:@selector(unbindData) withObject:nil];
			}
			
			if ( shouldRemove )
			{
				[item.view removeFromSuperview];
			}
			
			item.view.hidden = YES;
			item.view = nil;
		}
	}
	
    PERF_LEAVE_( _______dequeueItem1 )
    PERF_ENTER_( _______dequeueItem2 )
    
	if ( nil == item.view )
	{
		if ( _dataSource )
		{
            PERF_ENTER_( step1 )
			
			if ( [_dataSource respondsToSelector:@selector(scrollView:viewForIndex:scale:)] )
			{
				item.view = [_dataSource scrollView:self viewForIndex:item.index scale:item.scale];
			}
			else if ( [_dataSource respondsToSelector:@selector(scrollView:viewForIndex:)] )
			{
				item.view = [_dataSource scrollView:self viewForIndex:item.index];
			}
			
            PERF_LEAVE_( step1 )
		}
		
		if ( nil == item.view )
		{
            PERF_ENTER_( step2 )
			
			if ( item.clazz )
			{
                PERF_ENTER_( step2_1 )
                
				item.view = [self dequeueWithContentClass:item.clazz];
				
                PERF_LEAVE_( step2_1 )
				
				if ( nil == item.view )
				{
                    PERF_ENTER_( step2_2 )
					
					item.view = [[[item.clazz alloc] init] autorelease];
					
                    PERF_LEAVE_( step2_2 )
				}
			}
			
            PERF_LEAVE_( step2 )
		}
        
		if ( item.view )
		{
            PERF_ENTER_( step3 )
            
			if ( nil == item.view.superview )
			{
				[self addSubview:item.view];
			}
			else if ( item.view.superview != self )
			{
				[item.view retain];
				[item.view removeFromSuperview];
				[self addSubview:item.view];
				[item.view release];
			}
			
            PERF_LEAVE_( step3 )
		}
	}
	
    PERF_LEAVE_( _______dequeueItem2 )
    PERF_ENTER_( _______dequeueItem3 )
    
	if ( item.view )
	{
		if ( item.data )
		{
			if ( [item.view respondsToSelector:@selector(bindData:)] )
			{
				[item.view performSelector:@selector(bindData:) withObject:item.data];
			}
		}
		else
		{
			if ( [item.view respondsToSelector:@selector(unbindData)] )
			{
				[item.view performSelector:@selector(unbindData) withObject:nil];
			}
		}
        
		if ( NO == item.visible )
		{
			if ( [item.view respondsToSelector:@selector(viewWillAppear)] )
			{
				[item.view performSelector:@selector(viewWillAppear) withObject:nil];
			}
			
			item.visible = YES;
			item.view.hidden = NO;
			
			if ( [item.view respondsToSelector:@selector(viewDidAppear)] )
			{
				[item.view performSelector:@selector(viewDidAppear) withObject:nil];
			}
		}
		
        //		[item.view setNeedsDisplay];
	}
	
    PERF_LEAVE_( _______dequeueItem3 )
    PERF_LEAVE
}

- (void)syncPositionsIfNeeded
{
    //	BOOL		needed = NO;
    //	CGPoint		offset = self.contentOffset;
    //	CGSize		size = self.frame.size;
    //
    //	offset.x += self.contentInset.left;
    //	offset.y += self.contentInset.top;
    //
    //	NSInteger	shortestLine = [self getShortestLine];
    //	CGFloat		shortestLineHeight = _lineHeights[shortestLine];
    //
    //	CGRect visibleStartRect = ((BeeUIScrollItem *)_items[_visibleStart]).rect;
    //	CGRect visibleEndRect = ((BeeUIScrollItem *)_items[_visibleEnd]).rect;
    //
    //	if ( self.DIRECTION_VERTICAL == _direction )
    //	{
    //		if ( offset.y < CGRectGetMinY(visibleStartRect) )
    //		{
    //			needed = YES;
    //		}
    //		else if ( offset.y + size.height > fminf( CGRectGetMaxY(visibleEndRect), shortestLineHeight ) )
    //		{
    //			needed = YES;
    //		}
    //	}
    //	else if ( self.DIRECTION_HORIZONTAL == _direction )
    //	{
    //		if ( offset.x < CGRectGetMinX(visibleStartRect) )
    //		{
    //			needed = YES;
    //		}
    //		else if ( offset.x + size.width > fminf( CGRectGetMaxX(visibleEndRect), shortestLineHeight ) )
    //		{
    //			needed = YES;
    //		}
    //	}
    //
    //	if ( needed )
	{
        PERF_ENTER_( ______________syncPositionsIfNeeded )
		
		BOOL changed = [self recalcRange];
		if ( changed )
		{
            PERF_ENTER_( ______________syncPositionsIfNeeded2 )
            PERF_ENTER_( ______________recalcItems )
			
			[self recalcItems:NO];
			
            PERF_LEAVE_( ______________recalcItems )
			
            //			[self notifyLayouting];
            
            PERF_ENTER_( ______________syncCellPositions )
			
			[self syncCellPositions];
			
            PERF_LEAVE_( ______________syncCellPositions )
            PERF_ENTER_( ______________syncPullPositions )
			
			[self syncPullPositions];
			
            PERF_LEAVE_( ______________syncPullPositions )
            PERF_LEAVE_( ______________syncPositionsIfNeeded2 )
			
            //			[self notifyLayouted];
		}
		
        PERF_LEAVE_( ______________syncPositionsIfNeeded )
	}
}

- (BOOL)recalcRange
{
	if ( 0 == _total || 0 == _lineCount )
	{
		return NO;
	}
    
	NSUInteger	oldVisibleStart	= _visibleStart;
	NSUInteger	oldVisibleEnd	= _visibleEnd;
    
    PERF_ENTER
	
	NSInteger	lineFits = 0;
	CGFloat		linePixels[MAX_LINES] = { 0.0f };
    
	_visibleStart = 0;
	_visibleEnd = 0;
    
    PERF_ENTER_( a )
	
	for ( NSInteger i = 0; i < _total; ++i )
	{
		BeeUIScrollItem * item = [_items objectAtIndex:i];
        
		// 先找起始INDEX
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			if ( CGRectGetMaxX(item.rect) >= self.contentOffset.x )
			{
				_visibleStart = i;
				break;
			}
		}
		else
		{
			if ( CGRectGetMaxY(item.rect) >= self.contentOffset.y )
			{
				_visibleStart = i;
				break;
			}
		}
	}
	
    PERF_LEAVE_( a )
    
    //	CGFloat rightEdge = self.contentOffset.x + (self.contentInset.left + self.contentInset.right) + self.frame.size.width;
    //	CGFloat bottomEdge = self.contentOffset.y + (self.contentInset.top + self.contentInset.bottom) + self.frame.size.height;
	
    PERF_ENTER_( b )
	
	for ( NSInteger j = _visibleStart; j < _total; ++j )
	{
        //		BOOL itemVisible = NO;
        
		BeeUIScrollItem * item = [_items objectAtIndex:j];
        
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			if ( linePixels[item.line] <= self.frame.size.width )
			{
                //				itemVisible = YES;
				
				if ( item.rect.origin.x < self.contentOffset.x )
				{
					linePixels[item.line] += item.rect.origin.x + item.rect.size.width - self.contentOffset.x;
				}
                //				else if ( item.rect.origin.x > rightEdge )
                //				{
                //					linePixels[item.line] += 0.0f;
                //				}
				else
				{
					linePixels[item.line] += item.rect.size.width;
				}
                
				if ( linePixels[item.line] >= self.frame.size.width )
				{
					lineFits += 1;
				}
			}
			
			if ( CGRectGetMinX(item.rect) < (self.contentOffset.x + self.frame.size.width) )
			{
				_visibleEnd = j + 1;
			}
		}
		else
		{
			if ( linePixels[item.line] <= self.frame.size.height )
			{
                //				itemVisible = YES;
				
				if ( item.rect.origin.y < self.contentOffset.y )
				{
					linePixels[item.line] += item.rect.origin.y + item.rect.size.height - self.contentOffset.y;
				}
                //				else if ( item.rect.origin.y > bottomEdge )
                //				{
                //					linePixels[item.line] += 0.0f;
                //				}
				else
				{
					linePixels[item.line] += item.rect.size.height;
				}
                
				if ( linePixels[item.line] >= self.frame.size.height )
				{
					lineFits += 1;
				}
			}
            
			if ( CGRectGetMinY(item.rect) < (self.contentOffset.y + self.frame.size.height) )
			{
				_visibleEnd = j + 1;
			}
		}
		
		if ( lineFits >= _lineCount )
		{
			_visibleEnd = j + 1;
			break;
		}
	}
	
    PERF_LEAVE_( b )
    
	if ( 0 == _visibleEnd )
	{
		_visibleEnd = _total;
	}
    
    PERF_LEAVE
	
	if (  oldVisibleStart != _visibleStart || oldVisibleEnd != _visibleEnd )
	{
		PERF( @"visibleStart %d => %d", oldVisibleStart, _visibleStart );
		PERF( @"visibleEnd %d => %d", oldVisibleEnd, _visibleEnd );
		
		return YES;
	}
	
	return NO;
}

- (void)recalcItems:(BOOL)force
{
	for ( NSInteger i = 0; i < _total; ++i )
	{
		BeeUIScrollItem * item = [_items objectAtIndex:i];
        
		if ( i >= _visibleStart && i < _visibleEnd )
		{
			if ( force )
			{
				[self enqueueItem:item];
			}
			
			[self dequeueItem:item];
		}
		else
		{
			[self enqueueItem:item];
		}
	}
	
	for ( NSInteger j = _total; j < _items.count; ++j )
	{
		BeeUIScrollItem * item = [_items objectAtIndex:j];
        
		[self enqueueItem:item];
	}
}

- (void)didAnimationStop
{
	[self reloadData];
    
	[self notifyAnimated];
}

- (void)syncCellPositions
{
	if ( 0 == _total )
		return;
	
    PERF_ENTER
	
	BOOL reachTop = (0 == _visibleStart) ? YES : NO;
	BOOL reachEnd = NO;
    
	if ( reachTop )
	{
		if ( NO == _reachTop )
		{
			[self notifyReachTop];
			
			_reachTop = YES;
		}
	}
	else
	{
		_reachTop = NO;
	}
    
	UIEdgeInsets		insets = [self calcInsets];
	BeeUIScrollItem *	endItem = (_visibleEnd ? [_items objectAtIndex:(_visibleEnd - 1)] : nil);
	
	if ( endItem )
	{
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			CGFloat endEdge1 = self.contentOffset.x + self.frame.size.width + 1.0f * insets.right;
			CGFloat endEdge2 = self.contentSize.width + 1.0f * insets.right;
            
			if ( CGRectGetMaxX(endItem.rect) >= fmaxf(endEdge1, endEdge2) )
			{
				reachEnd = YES;
			}
		}
		else
		{
			CGFloat endEdge1 = self.contentOffset.y + self.frame.size.height + 1.0f * insets.bottom;
			CGFloat endEdge2 = self.contentSize.height + 1.0f * insets.bottom;
            
			if ( CGRectGetMaxY(endItem.rect) >= fmaxf(endEdge1, endEdge2) )
			{
				reachEnd = YES;
			}
		}
	}
    
	if ( NO == reachEnd )
	{
		reachEnd = ((_visibleEnd + _lineCount) > _total) ? YES : NO;
	}
    
	if ( reachEnd )
	{
		if ( NO == _reachEnd )
		{
			[self notifyReachBottom];
            
			if ( _footerLoader && NO == _footerLoader.hidden )
			{
				if ( NO == _footerLoader.loading && _footerLoader.more )
				{
					_footerLoader.loading = YES;
					
					[self notifyFooterRefresh];
				}
				else
				{
					_footerLoader.loading = NO;
				}
                
                //				[UIView beginAnimations:nil context:NULL];
                //				[UIView setAnimationDuration:0.3f];
                //				[UIView setAnimationBeginsFromCurrentState:YES];
                //
                //				[self syncPullPositions];
                //				[self syncPullInsets];
                //
                //				[UIView commitAnimations];
			}
            
			_reachEnd = YES;
		}
	}
	else
	{
		_reachEnd = NO;
	}
    
	NSMutableArray * orderedItems = [NSMutableArray nonRetainingArray];
	[orderedItems addObjectsFromArray:_items];
	[orderedItems sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		BeeUIScrollItem * item1 = obj1;
		BeeUIScrollItem * item2 = obj2;
		
		return item1.order > item2.order;
	}];
	
	for ( BeeUIScrollItem * orderedItem in orderedItems )
	{
		[self bringSubviewToFront:orderedItem.view];
	}
    
	for ( NSInteger i = _visibleStart; i < _visibleEnd; ++i )
	{
		BeeUIScrollItem * item = [_items objectAtIndex:i];
		if ( item.view )
		{
			CGRect itemFrame = item.rect;
			itemFrame.origin.x += item.insets.left;
			itemFrame.origin.y += item.insets.top;
			itemFrame.size.width -= (item.insets.left + item.insets.right);
			itemFrame.size.height -= (item.insets.top + item.insets.bottom);
            
			item.view.frame = itemFrame;
		}
	}
	
	CGPoint			currentOffset = self.contentOffset;
    NSTimeInterval	currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval	timeDiff = currentTime - _lastScrollTime;
	
    if ( timeDiff > 0.1 )
	{
		_scrollSpeed.x = -((currentOffset.x - _lastScrollOffset.x) / 1000.0f);
		_scrollSpeed.y = -((currentOffset.y - _lastScrollOffset.y) / 1000.0f);
        
        _lastScrollOffset = currentOffset;
        _lastScrollTime = currentTime;
    }
    
    PERF_LEAVE
}

- (void)reloadSections
{
	NSInteger total = 0;
	
	for ( BeeUIScrollSection * section in _sections )
	{
		id data = [_sectionDatas objectForKey:section.name];
		if ( nil == data )
			continue;
		
		if ( [data isKindOfClass:[NSArray class]] )
		{
			NSArray * array = data;
			for ( id elem in array )
			{
				total += 1;
				
				self.total = total;
				
				BeeUIScrollItem * lastItem = self.lastItem;
				lastItem.data = elem;
				lastItem.name = section.name;
				lastItem.rule = section.rule;
				lastItem.clazz = section.viewClass;
				lastItem.insets = section.viewInsets;
			}
		}
		else
		{
			total += 1;
			
			self.total = total;
			
			BeeUIScrollItem * lastItem = self.lastItem;
			lastItem.data = data;
			lastItem.name = section.name;
			lastItem.rule = section.rule;
			lastItem.clazz = section.viewClass;
			lastItem.insets = section.viewInsets;
		}
	}
}

- (void)reloadItems:(BOOL)force
{
	if ( force )
	{
		for ( BeeUIScrollItem * item in _items )
		{
			[self enqueueItem:item];
		}
	}
    
	if ( 0 == _lineCount )
		return;
    
    PERF_ENTER
	
	CGFloat itemPixels = 0.0f;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		
		itemPixels = self.frame.size.height / _lineCount;
	}
	else
	{
		itemPixels = self.frame.size.width / _lineCount;
	}
	
	for ( NSInteger i = 0; i < _total; ++i )
	{
		BeeUIScrollItem * item = [_items safeObjectAtIndex:i];
        
		if ( nil == item )
		{
			item = [[BeeUIScrollItem alloc] init];
			item.index = i;
			[_items addObject:item];
			[item release];
		}
        
        //		item.line = 0;
        //		item.rect = CGRectAuto;
        //		item.insets = UIEdgeInsetsZero;
        //		item.scale = 1.0f;
        
		if ( _dataSource && [_dataSource respondsToSelector:@selector(scrollView:orderForIndex:)] )
		{
			item.order = [_dataSource scrollView:self orderForIndex:i];
		}
        
		if ( _dataSource && [_dataSource respondsToSelector:@selector(scrollView:sizeForIndex:)] )
		{
			item.size = [_dataSource scrollView:self sizeForIndex:i];
		}
		else
		{
			if ( CGSizeEqualToSize(item.size, CGSizeAuto) )
			{
				if ( [item.clazz supportForUISizeEstimating] )
				{
					if ( BeeUIScrollLayoutRuleHorizontal == item.rule )
					{
						if ( self.DIRECTION_HORIZONTAL == _direction )
						{
							item.size = [item.clazz estimateUISizeByHeight:self.frame.size.height forData:item.data];
						}
						else
						{
							item.size = [item.clazz estimateUISizeByWidth:self.frame.size.width forData:item.data];
						}
					}
					else
					{
						if ( self.DIRECTION_HORIZONTAL == _direction )
						{
							item.size = [item.clazz estimateUISizeByHeight:self.lineSize forData:item.data];
						}
						else
						{
							item.size = [item.clazz estimateUISizeByWidth:self.lineSize forData:item.data];
						}
					}
				}
			}
		}
        
		if ( _dataSource && [_dataSource respondsToSelector:@selector(scrollView:ruleForIndex:)] )
		{
			item.rule = [_dataSource scrollView:self ruleForIndex:i];
		}
        
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			item.columns = floorf( (item.size.height + itemPixels - 1) / itemPixels );
		}
		else
		{
			item.columns = floorf( (item.size.width + itemPixels - 1) / itemPixels );
		}
        
		if ( item.columns > _lineCount )
		{
			item.columns = _lineCount;
		}
		
		if ( 0 == item.columns )
		{
			item.columns = 1;
		}
	}
    
	for ( NSInteger i = 0; i < MAX_LINES; ++i )
	{
		_lineHeights[i] = 0.0f;
	}
    
	BeeUIScrollItem *		prevItem = nil;
	BeeUIScrollItem *		currItem = nil;
	NSInteger				baseIndex = 0;
    
	for ( NSInteger i = 0; i < _total; ++i )
	{
		prevItem = currItem;
		currItem = [_items objectAtIndex:i];
        
		if ( prevItem && prevItem.section != currItem.section )
		{
			baseIndex = currItem.index;
		}
        
		NSUInteger	shortestLine = [self getShortestLine];
		NSInteger	longestLine = [self getLongestLine];
        
		if ( BeeUIScrollLayoutRuleVertical == currItem.rule )
		{
			if ( currItem.columns <= 1 )
			{
				currItem.line = (currItem.index - baseIndex) % _lineCount;
				
				if ( self.DIRECTION_HORIZONTAL == _direction )
				{
					CGRect itemRect;
					itemRect.origin.x = _lineHeights[currItem.line];
					itemRect.origin.y = currItem.line * itemPixels;
					itemRect.size.width = currItem.size.width;
					itemRect.size.height = itemPixels * currItem.columns;
					
					currItem.rect = itemRect;
					currItem.scale = 1.0f;
					
					for ( NSInteger k = 0; k < currItem.columns; ++k )
					{
						NSInteger itemLine = currItem.line + k;
						if ( itemLine >= _lineCount )
							break;
						
						_lineHeights[itemLine] = CGRectGetMaxX(itemRect);
					}
				}
				else
				{
					CGRect itemRect;
					itemRect.origin.x = currItem.line * itemPixels;
					itemRect.origin.y = _lineHeights[currItem.line];
					itemRect.size.width = itemPixels * currItem.columns;
					itemRect.size.height = currItem.size.height;
					
					currItem.rect = itemRect;
					currItem.scale = 1.0f;
					
					for ( NSInteger k = 0; k < currItem.columns; ++k )
					{
						NSInteger itemLine = currItem.line + k;
						if ( itemLine >= _lineCount )
							break;
						
						_lineHeights[itemLine] = CGRectGetMaxY(itemRect);
					}
				}
			}
			else
			{
				if ( shortestLine + currItem.columns >= _lineCount )
				{
					currItem.line = _lineCount - currItem.columns;
				}
				else
				{
					currItem.line = shortestLine;
				}
				
				if ( currItem.line < 0 )
				{
					currItem.line = 0;
				}
				
				if ( self.DIRECTION_HORIZONTAL == _direction )
				{
					CGRect itemRect;
					itemRect.origin.x = _lineHeights[shortestLine];
					itemRect.origin.y = currItem.line * itemPixels;
					itemRect.size.width = currItem.size.width;
					itemRect.size.height = itemPixels * currItem.columns;
					
					currItem.rect = itemRect;
					currItem.scale = 1.0f;
					
					for ( NSInteger k = 0; k < currItem.columns; ++k )
					{
						NSInteger itemLine = currItem.line + k;
						if ( itemLine >= _lineCount )
							break;
						
						_lineHeights[itemLine] = CGRectGetMaxX(currItem.rect);
					}
				}
				else
				{
					CGRect itemRect;
					itemRect.origin.x = currItem.line * itemPixels;
					itemRect.origin.y = _lineHeights[shortestLine];
					itemRect.size.width = itemPixels * currItem.columns;
					itemRect.size.height = currItem.size.height;
					
					itemRect.origin.x += currItem.insets.left;
					itemRect.origin.y += currItem.insets.top;
					itemRect.size.width -= (currItem.insets.left + currItem.insets.right);
					itemRect.size.height -= (currItem.insets.top + currItem.insets.bottom);
					
					currItem.rect = itemRect;
					currItem.scale = 1.0f;
					
					for ( NSInteger k = 0; k < currItem.columns; ++k )
					{
						NSInteger itemLine = currItem.line + k;
						if ( itemLine >= _lineCount )
							break;
						
						_lineHeights[itemLine] = CGRectGetMaxY(currItem.rect);
					}
				}
				
				for ( NSInteger j = 0; j < i; ++j )
				{
					BeeUIScrollItem * item2 = [_items objectAtIndex:j];
					
					if ( item2.line >= currItem.line && item2.line < (currItem.line + currItem.columns) )
					{
						if ( self.DIRECTION_HORIZONTAL == _direction )
						{
							if ( CGRectGetMaxX(item2.rect) > CGRectGetMinX(currItem.rect) )
							{
								CGRect itemRect = item2.rect;
								itemRect.origin.x = CGRectGetMaxX( currItem.rect );
								item2.rect = itemRect;
							}
							
							if ( CGRectGetMaxX(item2.rect) > _lineHeights[item2.line] )
							{
								_lineHeights[item2.line] = CGRectGetMaxX(item2.rect);
							}
						}
						else
						{
							if ( CGRectGetMaxY(item2.rect) > CGRectGetMinY(currItem.rect) )
							{
								CGRect itemRect = item2.rect;
								itemRect.origin.y = CGRectGetMaxY( currItem.rect );
								item2.rect = itemRect;
							}
							
							if ( CGRectGetMaxY(item2.rect) > _lineHeights[item2.line] )
							{
								_lineHeights[item2.line] = CGRectGetMaxY(item2.rect);
							}
						}
					}
				}
			}
		}
		else if ( BeeUIScrollLayoutRuleHorizontal == currItem.rule )
		{
			currItem.line = 0;
			currItem.columns = _lineCount;
			
			if ( self.DIRECTION_HORIZONTAL == _direction )
			{
				CGRect itemRect;
				itemRect.origin.x = _lineHeights[longestLine];
				itemRect.origin.y = currItem.line * itemPixels;
				itemRect.size.width = currItem.size.width;
				itemRect.size.height = itemPixels * currItem.columns;
                
				currItem.rect = itemRect;
				currItem.scale = 1.0f;
			}
			else
			{
				CGRect itemRect;
				itemRect.origin.x = currItem.line * itemPixels;
				itemRect.origin.y = _lineHeights[longestLine];
				itemRect.size.width = itemPixels * currItem.columns;
				itemRect.size.height = currItem.size.height;
                
				currItem.rect = itemRect;
				currItem.scale = 1.0f;
			}
            
			for ( NSUInteger m = 0; m < _lineCount; ++m )
			{
				if ( self.DIRECTION_HORIZONTAL == _direction )
				{
					_lineHeights[m] = CGRectGetMaxX( currItem.rect );
				}
				else
				{
					_lineHeights[m] = CGRectGetMaxY( currItem.rect );
				}
			}
		}
	}
    
	NSInteger bottomLine = [self getLongestLine];
    
	if ( bottomLine < _lineCount )
	{
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			self.contentSize = CGSizeMake( _lineHeights[bottomLine], self.frame.size.height );
		}
		else
		{
			self.contentSize = CGSizeMake( self.frame.size.width, _lineHeights[bottomLine] );
		}
	}
	else
	{
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			self.contentSize = CGSizeMake( 0.0f, self.frame.size.height );
		}
		else
		{
			self.contentSize = CGSizeMake( self.frame.size.width, 0.0f );
		}
	}
	
    PERF_LEAVE
}

- (CGFloat)lineSize
{
	if ( 0 == self.lineCount )
	{
		return 0.0f;
	}
    
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		return self.frame.size.height / self.lineCount;
	}
	else
	{
		return self.frame.size.width / self.lineCount;
	}
}

- (NSInteger)getLongestLine
{
	if ( 0 == _total )
	{
		return _lineCount + 1;
	}
	
	NSInteger longest = 0;
    
	for ( NSInteger i = 0; i < _lineCount; ++i )
	{
		if ( _lineHeights[i] > _lineHeights[longest] )
		{
			longest = i;
		}
	}
	
	return longest;
}

- (NSInteger)getShortestLine
{
	if ( 0 == _total )
	{
		return _lineCount + 1;
	}
	
	NSInteger shortest = 0;
    
	for ( NSInteger i = 0; i < _lineCount; ++i )
	{
		if ( _lineHeights[i] < _lineHeights[shortest] )
		{
			shortest = i;
		}
	}
	
	return shortest;
}

- (BOOL)headerShown
{
	if ( _headerLoader && NO == _headerLoader.hidden )
	{
		return YES;
	}
	
	return NO;
}

- (void)setHeaderShown:(BOOL)flag
{
	[self showHeaderLoader:flag animated:YES];
}

- (BOOL)footerShown
{
	if ( _footerLoader && NO == _footerLoader.hidden )
	{
		return YES;
	}
	
	return NO;
}

- (void)setFooterShown:(BOOL)flag
{
	[self showFooterLoader:flag animated:YES];
}

- (void)showHeaderLoader:(BOOL)flag animated:(BOOL)animated
{
	if ( nil == _headerLoader )
	{
		if ( self.headerClass )
		{
			_headerLoader = [[self.headerClass alloc] init];
			_headerLoader.frame = CGRectMake( 0, 0, self.width, 50.0f );
		}
		else
		{
			_headerLoader = [[BeeUIPullLoader spawn] retain];
		}
        
		_headerLoader.hidden = YES;
        //		_headerLoader.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
		if ( _direction == self.DIRECTION_HORIZONTAL )
		{
			_headerLoader.transform = CGAffineTransformMakeRotation( M_PI / 2.0f * 3.0f );
		}
		else
		{
			_headerLoader.transform = CGAffineTransformIdentity;
		}
        
		[self addSubview:_headerLoader];
		[self bringSubviewToFront:_headerLoader];
	}
	
	if ( flag )
	{
		_headerLoader.hidden = NO;
	}
	else
	{
		_headerLoader.hidden = YES;
	}
	
	[self syncPullPositions];
	[self syncPullInsets];
}

- (void)showFooterLoader:(BOOL)flag animated:(BOOL)animated
{
	if ( nil == _footerLoader )
	{
		if ( self.footerClass )
		{
			_footerLoader = [[self.footerClass alloc] init];
			_footerLoader.hidden = YES;
			_footerLoader.frame = CGRectMake( 0, 0, self.width, 44.f );
		}
		else
		{
			_footerLoader = [[BeeUIFootLoader spawn] retain];
			_footerLoader.hidden = YES;
		}
        
        //		_footerLoader.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
		[self addSubview:_footerLoader];
		[self bringSubviewToFront:_footerLoader];
	}
    
	if ( flag ) // TODO: ( flag && _total )
	{
		_footerLoader.hidden = NO;
	}
	else
	{
		_footerLoader.hidden = YES;
	}
	
	[self syncPullPositions];
	[self syncPullInsets];
}

- (void)setHeaderLoading:(BOOL)en
{
	if ( en == _headerLoader.loading )
		return;
	
	if ( _headerLoader )
	{
		if ( en )
		{
			if ( NO == _headerLoader.loading )
			{
				_headerLoader.loading = YES;
				
				[self syncPullInsets];
				
				if ( _direction == self.DIRECTION_HORIZONTAL )
				{
					if ( self.contentOffset.x <= 0.0f )
					{
						[self setContentOffset:CGPointMake(-self.contentInset.left, 0) animated:NO];
					}
				}
				else
				{
					if ( self.contentOffset.y <= 0.0f )
					{
						[self setContentOffset:CGPointMake(0, -self.contentInset.top) animated:NO];
					}
				}
			}
		}
		else
		{
			if ( _headerLoader.loading )
			{
				_headerLoader.loading = NO;
                
				[self syncPullInsets];
			}
			else if ( _headerLoader.pulling )
			{
				_headerLoader.pulling = NO;
				
				[self syncPullInsets];
			}
		}
	}
}

- (void)setFooterLoading:(BOOL)en
{
	if ( en == _footerLoader.loading )
		return;
    
	if ( _footerLoader && NO == _footerLoader.hidden )
	{
		_footerLoader.loading = en;
        
		[self syncPullInsets];
	}
	else
	{
		_footerLoader.loading = en;
	}
}

- (void)setFooterMore:(BOOL)en
{
	if ( _footerLoader && NO == _footerLoader.hidden )
	{
		_footerLoader.more = en;
        
		[self syncPullInsets];
	}
	else
	{
		_footerLoader.more = en;
	}
}

- (void)syncPullPositions
{
    PERF_ENTER
	
	if ( _headerLoader )
	{
		CGRect pullFrame;
		UIEdgeInsets insets = [self calcInsets];
        
		if ( _direction == self.DIRECTION_HORIZONTAL )
		{
			if ( [BeeUIConfig sharedInstance].iOS6Mode )
			{
				pullFrame.origin.x = - _headerLoader.bounds.size.width - insets.left;
			}
			else
			{
				pullFrame.origin.x = - _headerLoader.bounds.size.width;
			}
            
			pullFrame.origin.y = 0.0f;
			pullFrame.size.width = _headerLoader.bounds.size.width;
			pullFrame.size.height = self.frame.size.height;
		}
		else
		{
			pullFrame.origin.x = 0.0f;
			
			if ( [BeeUIConfig sharedInstance].iOS6Mode )
			{
				pullFrame.origin.y = - _headerLoader.bounds.size.height - insets.top;
			}
			else
			{
				pullFrame.origin.y = - _headerLoader.bounds.size.height;
			}
            
			pullFrame.size.width = self.frame.size.width;
			pullFrame.size.height = _headerLoader.bounds.size.height;
		}
        
		_headerLoader.frame = pullFrame;
        
        //		PERF( @"headerLoader, frame = (%f,%f,%f,%f), insets = (%f,%f,%f,%f)",
        //		   _headerLoader.frame.origin.x, _headerLoader.frame.origin.y,
        //		   _headerLoader.frame.size.width, _headerLoader.frame.size.height,
        //		   self.contentInset.top, self.contentInset.left,
        //		   self.contentInset.bottom, self.contentInset.right
        //		   );
	}
    
	if ( _footerLoader && NO == _footerLoader.hidden )
	{
		CGRect footFrame;
        
		if ( _direction == self.DIRECTION_HORIZONTAL )
		{
			footFrame.origin.x = self.contentSize.width;
			footFrame.origin.y = 0.0f;
			footFrame.size.width = _footerLoader.bounds.size.width;
			footFrame.size.height = self.frame.size.height;
		}
		else
		{
			footFrame.origin.x = 0.0f;
			footFrame.origin.y = self.contentSize.height;
			footFrame.size.width = self.frame.size.width;
			footFrame.size.height = _footerLoader.bounds.size.height;
		}
        
		_footerLoader.frame = footFrame;
        
        //		PERF( @"footerLoader, frame = (%f,%f,%f,%f), insets = (%f,%f,%f,%f)",
        //		   _footerLoader.frame.origin.x, _footerLoader.frame.origin.y,
        //		   _footerLoader.frame.size.width, _footerLoader.frame.size.height,
        //		   self.contentInset.top, self.contentInset.left,
        //		   self.contentInset.bottom, self.contentInset.right
        //		   );
	}
	
    PERF_LEAVE
}

- (void)syncPullInsets
{
    PERF_ENTER
	
	UIEdgeInsets insets = [self calcInsets];
	
	if ( _headerLoader && NO == _headerLoader.hidden )
	{
		if ( _headerLoader.loading )
		{
			if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				insets.left += _headerLoader.bounds.size.width;
			}
			else
			{
				insets.top += _headerLoader.bounds.size.height;
			}
		}
	}
	
	if ( _footerLoader && NO == _footerLoader.hidden )
	{
		if ( NO == _footerLoader.hidden )
		{
			if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				insets.right += _footerLoader.bounds.size.width;
			}
			else
			{
				insets.bottom += _footerLoader.bounds.size.height;
			}
		}
	}
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:self.animationDuration];
	
	self.contentInset = insets;
    
	[UIView commitAnimations];
	
    PERF_LEAVE
}

#pragma mark -

- (void)appendSection:(BeeUIScrollSection *)section
{
	[_sections addObject:section];
}

- (void)removeSection:(NSString *)name
{
	NSArray * copiedSections = [[_sections copy] autorelease];
	
	for ( BeeUIScrollSection * section in copiedSections )
	{
		if ( [section.name isEqualToString:name] )
		{
			[_sections removeAllObjects];
		}
	}
}

- (void)removeAllSections
{
	[_sections removeAllObjects];
}

- (id)objectAtIndexedSubscript:(NSUInteger)index
{
	BeeUIScrollItem * item = [_items safeObjectAtIndex:index];
	if ( item )
	{
		return item.data;
	}
	
	return nil;
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index
{
	BeeUIScrollItem * item = [_items safeObjectAtIndex:index];
	if ( item )
	{
		item.data = obj;
	}
}

- (id)objectForKeyedSubscript:(id)key
{
	return [_sectionDatas objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[_sectionDatas setObject:obj forKey:key];
	
	[self reloadSections];
}

#pragma mark -
#pragma mark BeeUIScrollViewDelegate

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 0;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	return 0;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index
{
	return nil;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return CGSizeZero;
}

- (NSInteger)scrollView:(BeeUIScrollView *)scrollView orderForIndex:(NSInteger)index
{
	return index;
}

- (BeeUIScrollLayoutRule)scrollView:(BeeUIScrollView *)scrollView ruleForIndex:(NSInteger)index
{
	return BeeUIScrollLayoutRuleVertical;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //	if ( [BeeUIConfig sharedInstance].highPerformance )
    //	{
    //		self.layer.shouldRasterize = YES;
    //	}
	
	if ( scrollView.dragging )
	{
		// header loader
		
		UIEdgeInsets insets = [self calcInsets];
		
		if ( _headerLoader && NO == _headerLoader.hidden && NO == _headerLoader.loading )
		{
			if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				CGFloat offset = scrollView.contentOffset.x;
				CGFloat boundX = -(insets.left + _headerLoader.bounds.size.width);
                
				if ( offset < boundX )
				{
					if ( NO == _headerLoader.pulling )
					{
						_headerLoader.pulling = YES;
					}
				}
				else if ( offset < 0.0f )
				{
					if ( _headerLoader.loading )
					{
						_headerLoader.loading = NO;
					}
					else if ( _headerLoader.pulling )
					{
						_headerLoader.pulling = NO;
					}
				}
			}
			else
			{
				CGFloat offset = scrollView.contentOffset.y;
				CGFloat boundY = -(insets.top + _headerLoader.bounds.size.height);
                
				if ( offset < boundY )
				{
					if ( NO == _headerLoader.pulling )
					{
						_headerLoader.pulling = YES;
					}
				}
				else if ( offset < 0.0f )
				{
					if ( _headerLoader.loading )
					{
						_headerLoader.loading = NO;
					}
					else if ( _headerLoader.pulling )
					{
						_headerLoader.pulling = NO;
					}
				}
			}
		}
	}
    
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.DID_SCROLL];
		}
        
		if ( self.whenScrolling )
		{
			self.whenScrolling();
		}
	}
	
	[self syncPositionsIfNeeded];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //	if ( [BeeUIConfig sharedInstance].highPerformance )
    //	{
    //		self.layer.shouldRasterize = NO;
    //	}
    
	[self syncPositionsIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //	if ( [BeeUIConfig sharedInstance].highPerformance )
    //	{
    //		self.layer.shouldRasterize = NO;
    //	}
    
	if ( decelerate )
	{
		// header loader
		
		if ( _headerLoader && NO == _headerLoader.hidden && NO == _headerLoader.loading )
		{
			UIEdgeInsets insets = [self calcInsets];
			
			if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				CGFloat offset = scrollView.contentOffset.x;
				CGFloat boundY = -(insets.left + _headerLoader.bounds.size.width);
				
				if ( offset <= boundY )
				{
					if ( NO == _headerLoader.loading )
					{
						_headerLoader.loading = YES;
                        
						[self notifyHeaderRefresh];
					}
				}
				else
				{
					if ( _headerLoader.loading )
					{
						_headerLoader.loading = NO;
					}
					else if ( _headerLoader.pulling )
					{
						_headerLoader.pulling = NO;
					}
				}
			}
			else
			{
				CGFloat offset = scrollView.contentOffset.y;
				CGFloat boundY = -(insets.top + _headerLoader.bounds.size.height);
				
				if ( offset <= boundY )
				{
					if ( NO == _headerLoader.loading )
					{
						_headerLoader.loading = YES;
						
						[self notifyHeaderRefresh];
					}
				}
				else
				{
					if ( _headerLoader.loading )
					{
						_headerLoader.loading = NO;
					}
					else if ( _headerLoader.pulling )
					{
						_headerLoader.pulling = NO;
					}
				}
			}
            
			[self syncPullPositions];
			[self syncPullInsets];
		}
	}
    
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.DID_DRAG];
            //			[self sendUISignal:BeeUIScrollView.DID_STOP];
		}
        
		if ( self.whenScrolling )
		{
			self.whenScrolling();
		}
		
		if ( self.whenDragged )
		{
			self.whenDragged();
		}
	}
	
	[self syncPositionsIfNeeded];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //	if ( [BeeUIConfig sharedInstance].highPerformance )
    //	{
    //		self.layer.shouldRasterize = YES;
    //	}
    
	[self syncPositionsIfNeeded];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //	if ( [BeeUIConfig sharedInstance].highPerformance )
    //	{
    //		self.layer.shouldRasterize = NO;
    //	}
    
	if ( _shouldNotify )
	{
		if ( self.enableAllEvents )
		{
			[self sendUISignal:BeeUIScrollView.DID_STOP];
		}
        
		if ( self.whenStop )
		{
			self.whenStop();
		}
	}
    
	[self syncPositionsIfNeeded];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //	if ( [BeeUIConfig sharedInstance].highPerformance )
    //	{
    //		self.layer.shouldRasterize = NO;
    //	}
    
	[self syncPositionsIfNeeded];
}

#pragma mark -

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( [signal is:BeeUIFootLoader.TOUCHED] )
	{
		[self notifyFooterRefresh];
	}
	else
	{
		SIGNAL_FORWARD( signal );
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

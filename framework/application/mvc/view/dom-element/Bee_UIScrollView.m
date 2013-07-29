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

#import "Bee_UIScrollView.h"
#import "Bee_UIPullLoader.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

#undef	MAX_LINES
#define MAX_LINES			(128)

#undef	MAX_QUEUED_ITEMS
#define	MAX_QUEUED_ITEMS	(32)

#undef	ANIMATION_DURATION
#define	ANIMATION_DURATION	(0.3f)

#pragma mark -

@interface BeeUIScrollItem : NSObject
{
	BOOL		_visible;
	NSInteger	_index;
	NSInteger	_line;
	CGFloat		_scale;
	CGSize		_size;
	CGRect		_rect;
	UIView *	_view;
}

@property (nonatomic, assign) BOOL			visible;
@property (nonatomic, assign) NSInteger		index;
@property (nonatomic, assign) NSInteger		line;
@property (nonatomic, assign) CGFloat		scale;
@property (nonatomic, assign) CGSize		size;
@property (nonatomic, assign) CGRect		rect;
@property (nonatomic, assign) UIView *		view;

@end

#pragma mark -

@implementation BeeUIScrollItem

@synthesize visible = _visible;
@synthesize	index = _index;
@synthesize line = _line;
@synthesize scale = _scale;
@synthesize	size = _size;
@synthesize rect = _rect;
@synthesize	view = _view;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_visible = NO;
		_index = 0;
		_line = 0;
		_scale = 1.0f;
		_size = CGSizeZero;
		_rect = CGRectZero;
		_view = nil;
	}
	return self;
}

- (void)dealloc
{
	[_view removeFromSuperview];
	[_view release];
	
	[super dealloc];
}

@end

#pragma mark -

@interface BeeUIScrollView()
{
	BOOL						_inited;
	
	id							_dataSource;
	NSInteger					_direction;
	
	NSInteger					_visibleStart;
	NSInteger					_visibleEnd;
	
	NSInteger					_lineCount;
	CGFloat						_lineHeights[MAX_LINES];
	
	NSInteger					_total;
	NSMutableArray *			_items;
	
	BOOL						_shouldNotify;
	BOOL						_reloaded;
	BOOL						_reloading;
	UIEdgeInsets				_baseInsets;
	
	BOOL						_reachTop;
	BOOL						_reachEnd;
	NSMutableArray *			_reuseQueue;
	
	CGPoint						_scrollSpeed;
	CGPoint						_lastOffset;
	NSTimeInterval				_lastOffsetCapture;
	
	BeeUIPullLoader *			_headerLoader;
	BeeUIPullLoader *			_footerLoader;
}

- (void)initSelf;

- (void)syncPositions;
- (void)calcPositions;

- (void)syncPullPositions;
- (void)syncPullInsets;

- (void)releaseAllViews;
- (void)releaseViewsBefore:(NSInteger)index;
- (void)releaseViewsAfter:(NSInteger)index;

- (NSInteger)getShortestLine;
- (NSInteger)getLongestLine;

- (void)operateReloadData;
- (void)internalReloadData;

@end

#pragma mark -

@implementation BeeUIScrollView

DEF_INT( DIRECTION_HORIZONTAL,	0 )
DEF_INT( DIRECTION_VERTICAL,	1 )

DEF_SIGNAL( RELOADED )			// 数据重新加载
DEF_SIGNAL( REACH_TOP )			// 触顶
DEF_SIGNAL( REACH_BOTTOM )		// 触底

DEF_SIGNAL( DID_DRAG )
DEF_SIGNAL( DID_STOP )
DEF_SIGNAL( DID_SCROLL )

DEF_SIGNAL( HEADER_REFRESH )	// 下拉刷新
DEF_SIGNAL( FOOTER_REFRESH )	// 上拉刷新

@synthesize dataSource = _dataSource;

@dynamic horizontal;
@dynamic vertical;

@dynamic visibleStart;
@dynamic visibleEnd;

@dynamic visibleRange;
@dynamic visiblePageIndex;

@synthesize reloaded = _reloaded;
@synthesize reloading = _reloading;
@synthesize reuseQueue = _reuseQueue;

@synthesize scrollSpeed = _scrollSpeed;
@dynamic scrollPercent;
@dynamic height;

@dynamic pageCount;
@dynamic pageIndex;
@dynamic baseInsets;
@synthesize lineCount = _lineCount;

@synthesize headerLoader = _headerLoader;
@synthesize footerLoader = _footerLoader;

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
		_direction = self.DIRECTION_VERTICAL;
		_dataSource = self;
		
		_shouldNotify = YES;
		_reloaded = NO;
		_lineCount = 0;
		
		_total = 0;
		_items = [[NSMutableArray alloc] init];
		_reuseQueue = [[NSMutableArray alloc] init];
		
		_visibleStart = 0;
		_visibleEnd = 0;
		
		_reachTop = NO;
		_reachEnd = NO;
		_baseInsets = UIEdgeInsetsZero;	

		self.backgroundColor = [UIColor clearColor];
		self.contentSize = self.bounds.size;
		self.contentInset = _baseInsets;
		self.alwaysBounceVertical = YES;
		self.alwaysBounceHorizontal = NO;
		self.directionalLockEnabled = YES;
		self.bounces = YES;
		self.scrollEnabled = YES;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.alpha = 1.0f;
		self.delegate = self;
		self.layer.masksToBounds = YES;

		_inited = YES;

		[self load];
	}
}

- (void)dealloc
{
	[self unload];

	[self releaseAllViews];
	
	[_reuseQueue removeAllObjects];
	[_reuseQueue release];
	_reuseQueue = nil;
	
	[_items removeAllObjects];
	[_items release];
	_items = nil;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateReloadData) object:nil];	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	[super dealloc];
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
		self.showsHorizontalScrollIndicator = NO;
		
		self.alwaysBounceVertical = NO;
		self.showsVerticalScrollIndicator = NO;
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
		self.showsVerticalScrollIndicator = NO;

		self.alwaysBounceHorizontal = NO;
		self.showsHorizontalScrollIndicator = NO;		
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
		return (NSUInteger)floorf(_total - ((self.contentSize.width - self.contentOffset.x) / self.bounds.size.width) + 0.5);
	}
	else
	{
		return (NSUInteger)floorf(_total - ((self.contentSize.height - self.contentOffset.y) / self.bounds.size.height) + 0.5);
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

	INFO( @"percent = %0.2f", percent );
	return percent;
}

- (NSInteger)pageCount
{
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		return (self.contentSize.width + self.bounds.size.width - 1) / self.bounds.size.width;
	}
	else
	{
		return (self.contentSize.height + self.bounds.size.height - 1) / self.bounds.size.height;
	}
}

- (NSInteger)pageIndex
{
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		return self.contentOffset.x / self.bounds.size.width;
	}
	else
	{
		return self.contentOffset.y / self.bounds.size.height;
	}
}

- (void)setPageIndex:(NSInteger)index
{
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		self.contentOffset = CGPointMake( self.bounds.size.width * index, self.contentOffset.y );
	}
	else
	{
		self.contentOffset = CGPointMake( self.contentOffset.x, self.bounds.size.height * index );
	}
}

- (void)setBaseInsets:(UIEdgeInsets)insets
{
	_baseInsets = insets;
	self.contentInset = insets;

	[self syncPullPositions];
	[self syncPullInsets];
}

- (UIEdgeInsets)baseInsets
{
	return _baseInsets;
}

- (void)reloadData
{
	[self syncReloadData];
}

- (void)syncReloadData
{
	self.userInteractionEnabled = NO;
	
	[self cancelReloadData];
	_reloading = YES;
	[self operateReloadData];
	
	self.userInteractionEnabled = YES;		
}

- (void)asyncReloadData
{
	if ( NO == _reloading )
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateReloadData) object:nil];
		[self performSelector:@selector(operateReloadData) withObject:nil afterDelay:0.01f];
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
		
		if ( _shouldNotify )
		{
			[self sendUISignal:BeeUIScrollView.RELOADED];
		}
	}
}

- (void)internalReloadData
{
	if ( nil == _dataSource )
		return;
	
	if ( [_dataSource respondsToSelector:@selector(numberOfLinesInScrollView:)] )
	{
		_lineCount = [_dataSource numberOfLinesInScrollView:self];
	}
	else
	{
		if ( _lineCount <= 0 )
		{
			_lineCount = 1;
		}
	}
	
	for ( NSInteger i = 0; i < MAX_LINES; ++i )
	{
		_lineHeights[i] = 0.0f;
	}

	if ( [_dataSource respondsToSelector:@selector(numberOfViewsInScrollView:)] )
	{
		_total = [_dataSource numberOfViewsInScrollView:self];
	}
	else
	{
		_total = 0;
	}

	[self releaseAllViews];
	[self calcPositions];
	[self syncPositions];
	[self syncPullPositions];
	[self syncPullInsets];
	
	_reloaded = YES;
}

- (void)setFrame:(CGRect)frame
{
	_shouldNotify = NO;
	
	[super setFrame:frame];

	if ( CGSizeEqualToSize(self.contentSize, CGSizeZero) )
	{
		self.contentSize = frame.size;
		self.contentInset = _baseInsets;
	}
	
	_shouldNotify = YES;
	
	if ( NO == _reloaded )
	{
		[self syncReloadData];
	}
	else
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
		offset.x = -1.0f * _baseInsets.left;
		offset.y = self.contentOffset.y;
	}
	else
	{
		offset.x = self.contentOffset.x;
		offset.y = -1.0f * _baseInsets.top;
	}

	[self setContentOffset:offset animated:animated];	
}

- (void)scrollToLastPage:(BOOL)animated
{
	CGPoint offset;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		offset.x = self.contentOffset.x + self.contentSize.width + 1.0f * _baseInsets.right;
		offset.y = self.contentOffset.y;
	}
	else
	{
		offset.x = self.contentOffset.x;
		offset.y = self.contentOffset.y + self.contentSize.height + 1.0f * _baseInsets.bottom;
	}

	[self setContentOffset:offset animated:animated];		
}

- (void)scrollToPrevPage:(BOOL)animated
{
	CGPoint offset;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		if ( self.contentSize.width < self.bounds.size.width )
			return;
		
		offset.x = self.contentOffset.x - self.bounds.size.width;
		offset.y = self.contentOffset.y;
		
		if ( offset.x < -1.0f * _baseInsets.left )
		{
			offset.x = -1.0f * _baseInsets.left;
		}
	}
	else
	{
		if ( self.contentSize.height < self.bounds.size.height )
			return;
		
		offset.x = self.contentOffset.x;
		offset.y = self.contentOffset.y - self.bounds.size.height;
		
		if ( offset.x < -1.0f * _baseInsets.top )
		{
			offset.x = -1.0f * _baseInsets.top;
		}
	}

	[self setContentOffset:offset animated:animated];
}

- (void)scrollToNextPage:(BOOL)animated
{	
	CGPoint offset;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		if ( self.contentSize.width < self.bounds.size.width )
			return;
		
		offset.x = self.contentOffset.x + self.bounds.size.width;
		offset.y = self.contentOffset.y;
		
		CGFloat rightBound = self.contentOffset.x + self.contentSize.width + 1.0f * _baseInsets.right;
		
		if ( self.contentSize.width > self.bounds.size.width )
		{
			if (self.contentOffset.x < (self.contentSize.width - self.bounds.size.width)  )
			{
				offset.x = rightBound - self.bounds.size.width;
			}
			else
			{
				offset.x =  (self.contentSize.width - self.bounds.size.width + 1.0f * _baseInsets.right);
			}
		}
		else
		{
			offset.x =  (self.contentSize.width - self.bounds.size.width + 1.0f * _baseInsets.right);
		}
	}
	else
	{
		if ( self.contentSize.height < self.bounds.size.height )
			return;
		
		offset.x = self.contentOffset.x;
		offset.y = self.contentOffset.y + self.bounds.size.height;

		CGFloat bottomBound = self.contentOffset.y + self.contentSize.height + 1.0f * _baseInsets.bottom;
		
		if ( offset.y > bottomBound )
		{
			offset.y = bottomBound - self.bounds.size.height;
		}
	}
	
	[self setContentOffset:offset animated:animated];
}

- (id)dequeueWithContentClass:(Class)clazz
{
	for ( UIView * reuseView in _reuseQueue )
	{
		if ( [reuseView isKindOfClass:clazz] )
		{
			INFO( @"UIScrollView, dequeue <= (%p)", reuseView );
			
			[reuseView retain];
			[_reuseQueue removeObject:reuseView];
//			return reuseView;
			return [reuseView autorelease];
		}
	}
	
	UIView * newView = (UIView *)[BeeRuntime allocByClass:clazz];
	return [[newView initWithFrame:CGRectZero] autorelease];
}

- (void)syncPositions
{
//	INFO( @"UIScrollView, subviews = %d", [self.subviews count] );
	
	NSInteger lineFits = 0;
	CGFloat linePixels[MAX_LINES] = { 0.0f };
	
	_visibleStart = 0;
	_visibleEnd = 0;
	
	for ( NSInteger i = 0; i < _total; ++i )
	{
		BeeUIScrollItem * item = [_items objectAtIndex:i];
		item.visible = NO;

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
				
		if ( item.view )
		{
			if ( _reuseQueue.count >= MAX_QUEUED_ITEMS )
			{
				[_reuseQueue removeObject:[_reuseQueue objectAtIndex:0]];
			}

			INFO( @"UIScrollView, enqueue '%@' %p", [[item.view class] description], item.view );
			[_reuseQueue addObject:item.view];
			
			[item.view removeFromSuperview];
			item.view = nil;
		}
	}

//	CGFloat rightEdge = self.contentOffset.x + (self.contentInset.left + self.contentInset.right) + self.bounds.size.width;
//	CGFloat bottomEdge = self.contentOffset.y + (self.contentInset.top + self.contentInset.bottom) + self.bounds.size.height;
	
	for ( NSInteger j = _visibleStart; j < _total; ++j )
	{
		BOOL itemFlag = NO;
		BeeUIScrollItem * item = [_items objectAtIndex:j];
				
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			if ( linePixels[item.line] < self.bounds.size.width )
			{
				item.visible = YES;
				
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

				if ( linePixels[item.line] >= self.bounds.size.width )
				{
					lineFits += 1;
				}
				
				itemFlag = YES;
			}
		}
		else
		{
			if ( linePixels[item.line] < self.bounds.size.height )
			{
				item.visible = YES;
				
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

				if ( linePixels[item.line] >= self.bounds.size.height )
				{
					lineFits += 1;
				}		
				
				itemFlag = YES;
			}
		}
		
		if ( NO == itemFlag )
		{
			item.visible = NO;
			
			if ( item.view )
			{
				if ( _reuseQueue.count >= MAX_QUEUED_ITEMS )
				{
					[_reuseQueue removeObject:[_reuseQueue objectAtIndex:0]];
				}

				INFO( @"UIScrollView, enqueue '%@' %p", [[item.view class] description], item.view );
				[_reuseQueue addObject:item.view];

				[item.view removeFromSuperview];
				item.view = nil;
			}
		}

		// 再找终止INDEX
		if ( lineFits >= _lineCount )
		{
			_visibleEnd = j;
			break;
		}
	}

	if ( 0 == _visibleEnd )
	{
		_visibleEnd = (_total > 0) ? (_total - 1) : 0;
	}
	
	for ( NSInteger k = _visibleEnd + 1; k < _total; ++k )
	{
		BeeUIScrollItem * item = [_items objectAtIndex:k];
		item.visible = NO;

		if ( item.view )
		{
			if ( _reuseQueue.count >= MAX_QUEUED_ITEMS )
			{
				[_reuseQueue removeObject:[_reuseQueue objectAtIndex:0]];
			}

			INFO( @"UIScrollView, enqueue '%@' %p", [[item.view class] description], item.view );
			[_reuseQueue addObject:item.view];
			
			[item.view removeFromSuperview];
			item.view = nil;
		}
	}
	
//	INFO( @"start = %d, end = %d", _visibleStart, _visibleEnd );
	
//	if ( BEE_SCROLL_DIRECTION_HORIZONTAL == _direction )
//	{
//		CGFloat offset = self.contentOffset.x + self.bounds.size.width;
//		CGFloat bound = self.contentSize.width;
//		
//		if ( offset <= bound )
//		{
//			if ( _reachEnd )
//			{
//				_reachEnd = NO;
//			}
//		}
//	}
//	else
//	{
//		CGFloat offset = self.contentOffset.y + self.bounds.size.height;
//		CGFloat bound = self.contentSize.height;
//		
//		if ( offset <= bound )
//		{
//			if ( _reachEnd )
//			{
//				_reachEnd = NO;
//			}
//		}
//	}
	
	if ( _total > 0 )
	{
		for ( NSInteger l = _visibleStart; l <= _visibleEnd; ++l )
		{
			BeeUIScrollItem * item = [_items objectAtIndex:l];		
			if ( NO == item.visible )
				continue;
			
			if ( nil == item.view )
			{
				if ( [_dataSource respondsToSelector:@selector(scrollView:viewForIndex:scale:)] )
				{
					item.view = [_dataSource scrollView:self viewForIndex:l scale:item.scale];
				}
				else if ( [_dataSource respondsToSelector:@selector(scrollView:viewForIndex:)] )
				{
					item.view = [_dataSource scrollView:self viewForIndex:l];
				}

				if ( item.view )
				{
					item.view.frame = item.rect;
				}
			}

			if ( item.view )
			{
//				[item.view retain];
				if ( item.view.superview && item.view.superview != self )
				{
					[item.view removeFromSuperview];
				}
				[self addSubview:item.view];
//				[item.view release];
			}
			
//			INFO( @"%p, (%f, %f), (%f, %f)",
//				  item.view,
//				  item.rect.origin.x, item.rect.origin.y,
//				  item.rect.size.width, item.rect.size.height );
		}		
		
		BOOL reachTop = (0 == _visibleStart) ? YES : NO;
		if ( reachTop )
		{
			if ( NO == _reachTop )
			{
				if ( _shouldNotify )
				{
					[self sendUISignal:BeeUIScrollView.REACH_TOP];
				}
				
				_reachTop = YES;
			}			
		}
		else
		{
			_reachTop = NO;
		}
		
		BOOL reachEnd = (_visibleEnd + 1 >= _total) ? YES : NO;
		if ( reachEnd )
		{
			if ( NO == _reachEnd )
			{
				if ( _shouldNotify )
				{
					[self sendUISignal:BeeUIScrollView.REACH_BOTTOM];
				}
				
				_reachEnd = YES;
			}
		}
		else
		{
			_reachEnd = NO;
		}
	}
	
	CGPoint			currentOffset = self.contentOffset;
    NSTimeInterval	currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval	timeDiff = currentTime - _lastOffsetCapture;
	
    if ( timeDiff > 0.1 )
	{
		_scrollSpeed.x = -((currentOffset.x - _lastOffset.x) / 1000.0f);
		_scrollSpeed.y = -((currentOffset.y - _lastOffset.y) / 1000.0f);
		
        _lastOffset = currentOffset;
        _lastOffsetCapture = currentTime;
    }
	
//	INFO( @"scrollSpeed = (%f, %f)", _scrollSpeed.x, _scrollSpeed.y );
}

- (void)calcPositions
{
	if ( 0 == _total )
		return;
	
	CGRect bounds = self.bounds;
	CGFloat itemPixels = 0.0f;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		itemPixels = bounds.size.height / _lineCount;
	}
	else
	{
		itemPixels = bounds.size.width / _lineCount;
	}

	BeeUIScrollItem * item = nil;
	
	for ( NSInteger i = 0; i < _total; ++i )
	{
		if ( i >= [_items count] )
		{
			item = [[BeeUIScrollItem alloc] init];
			item.index = i;
			[_items addObject:item];
			[item release];
			
		//	INFO( @"%@", [item description] );
		}
		else
		{
			item = [_items objectAtIndex:i];
		}
		
		item.size = [_dataSource scrollView:self sizeForIndex:i];
		item.line = [self getShortestLine];
		
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			item.scale = (0.0f == item.size.height) ? 1.0f : (itemPixels / item.size.height);
			item.rect = CGRectMake( _lineHeights[item.line], item.line * itemPixels, item.size.width * item.scale, itemPixels );
			
			if ( item.line < _lineCount )
			{
				_lineHeights[item.line] += item.rect.size.width;
			}
			else
			{
				_lineHeights[item.line] += 0.0f;
			}
		}
		else
		{
			item.scale = (0.0f == item.size.width) ? 1.0f : (itemPixels / item.size.width);
			item.rect = CGRectMake( item.line * itemPixels, _lineHeights[item.line], itemPixels, item.size.height * item.scale );
			
			if ( item.line < _lineCount )
			{
				_lineHeights[item.line] += item.rect.size.height;
			}
			else
			{
				_lineHeights[item.line] += 0.0f;
			}
		}		
	}

	NSInteger line = [self getLongestLine];
	if ( line < _lineCount )
	{
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			self.contentSize = CGSizeMake( _lineHeights[line], self.bounds.size.height );
		}
		else
		{
			self.contentSize = CGSizeMake( self.bounds.size.width, _lineHeights[line] );
		}		
	}
	else
	{
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			self.contentSize = CGSizeMake( 0.0f, self.bounds.size.height );
		}
		else
		{
			self.contentSize = CGSizeMake( self.bounds.size.width, 0.0f );
		}
	}
	
	for ( BeeUIScrollItem * item in _items )
	{
		INFO( @"index = %d, visible = %d, line = %d, rect = (%.1f,%.1f, %.1f,%.1f)",
		   item.index, item.visible, item.line,
		   item.rect.origin.x, item.rect.origin.y,
		   item.rect.size.width, item.rect.size.height );
	}
}

- (CGFloat)height
{
	NSInteger line = [self getLongestLine];
	if ( line < _total )
	{
		return _lineHeights[line];
	}
	else
	{
		return 0.0f;
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

- (void)releaseAllViews
{
	if ( _items )
	{
		for ( BeeUIScrollItem * item in _items )
		{
			if ( item.view )
			{
				INFO( @"UIScrollView, enqueue '%@' %p", [[item.view class] description], item.view );

				[_reuseQueue pushTail:item.view];
				[_reuseQueue keepTail:MAX_QUEUED_ITEMS];

				[item.view removeFromSuperview];
				item.view = nil;
			}
		}

		[_items removeAllObjects];		
	}

//	if ( _reuseQueue )
//	{
//		[_reuseQueue removeAllObjects];
//	}	
}

- (void)releaseViewsBefore:(NSInteger)index
{
}

- (void)releaseViewsAfter:(NSInteger)index
{
}

- (void)showHeaderLoader:(BOOL)flag animated:(BOOL)animated
{
	if ( nil == _headerLoader )
	{
		_headerLoader = [[BeeUIPullLoader spawn] retain];
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
		_footerLoader = [[BeeUIPullLoader spawn] retain];
		_footerLoader.hidden = YES;
//		_footerLoader.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		
		if ( _direction == self.DIRECTION_HORIZONTAL )
		{
			_footerLoader.transform = CGAffineTransformMakeRotation( M_PI / 2.0f );
		}
		else
		{
			_footerLoader.transform = CGAffineTransformMakeRotation( M_PI );
		}

		[self addSubview:_footerLoader];
		[self bringSubviewToFront:_footerLoader];
	}
	
	if ( flag )
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
	if ( _headerLoader )
	{
		if ( en )
		{
			if ( BeeUIPullLoader.STATE_LOADING != _headerLoader.state )
			{
				[_headerLoader changeState:BeeUIPullLoader.STATE_LOADING animated:YES];

				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:ANIMATION_DURATION];
				[self syncPullInsets];
				[UIView commitAnimations];
			}
		}
		else
		{
			if ( BeeUIPullLoader.STATE_NORMAL != _headerLoader.state )
			{
				[_headerLoader changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];

				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:ANIMATION_DURATION];
				[self syncPullInsets];
				[UIView commitAnimations];
			}
		}
	}
}

- (void)setFooterLoading:(BOOL)en
{
	if ( _footerLoader )
	{
		if ( en )
		{
			if ( BeeUIPullLoader.STATE_LOADING != _footerLoader.state )
			{
				[_footerLoader changeState:BeeUIPullLoader.STATE_LOADING animated:YES];

				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:ANIMATION_DURATION];
				[self syncPullInsets];
				[UIView commitAnimations];
			}
		}
		else
		{
			if ( BeeUIPullLoader.STATE_NORMAL != _footerLoader.state )
			{
				[_footerLoader changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];

				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:ANIMATION_DURATION];
				[self syncPullInsets];				
				[UIView commitAnimations];
			}
		}
	}
}

- (void)syncPullPositions
{
	if ( _headerLoader )
	{
		CGRect pullFrame;

		if ( _direction == self.DIRECTION_HORIZONTAL )
		{
			pullFrame.origin.x = - _headerLoader.bounds.size.width - _baseInsets.left;
			pullFrame.origin.y = 0.0f;
			pullFrame.size.width = _headerLoader.bounds.size.width;
			pullFrame.size.height = self.bounds.size.height;
		}
		else
		{
			pullFrame.origin.x = 0.0f;
			pullFrame.origin.y = - _headerLoader.bounds.size.height - _baseInsets.top;
			pullFrame.size.width = self.bounds.size.width;
			pullFrame.size.height = _headerLoader.bounds.size.height;
		}

		_headerLoader.frame = pullFrame;
		
		INFO( @"headerLoader, frame = (%f,%f,%f,%f), insets = (%f,%f,%f,%f)",
		   _headerLoader.frame.origin.x, _headerLoader.frame.origin.y,
		   _headerLoader.frame.size.width, _headerLoader.frame.size.height,
		   self.contentInset.top, self.contentInset.left,
		   self.contentInset.bottom, self.contentInset.right
		   );
	}

	if ( _footerLoader )
	{
		CGRect pullFrame;
		
		if ( _direction == self.DIRECTION_HORIZONTAL )
		{
			pullFrame.origin.x = _baseInsets.left + _baseInsets.right + self.contentSize.width;
			pullFrame.origin.y = 0.0f;
			pullFrame.size.width = _headerLoader.bounds.size.width;
			pullFrame.size.height = self.bounds.size.height;
		}
		else
		{
			pullFrame.origin.x = 0.0f;
			pullFrame.origin.y = _baseInsets.top + _baseInsets.bottom + self.contentSize.height;
			pullFrame.size.width = self.bounds.size.width;
			pullFrame.size.height = _headerLoader.bounds.size.height;
		}

		_footerLoader.frame = pullFrame;
	}
}

- (void)syncPullInsets
{
	UIEdgeInsets insets = _baseInsets;
	
	if ( _headerLoader )
	{
		if ( BeeUIPullLoader.STATE_LOADING == _headerLoader.state )
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
		
		INFO( @"headerLoader, frame = (%f,%f,%f,%f), insets = (%f,%f,%f,%f)",
		   _headerLoader.frame.origin.x, _headerLoader.frame.origin.y,
		   _headerLoader.frame.size.width, _headerLoader.frame.size.height,
		   self.contentInset.top, self.contentInset.left,
		   self.contentInset.bottom, self.contentInset.right
		   );
	}
	
	if ( _footerLoader )
	{
		if ( BeeUIPullLoader.STATE_LOADING == _footerLoader.state )
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

	self.contentInset = insets;
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

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if ( scrollView.dragging )
	{
		// header loader
		
		if ( NO == _headerLoader.hidden && BeeUIPullLoader.STATE_LOADING != _headerLoader.state )
		{
			if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				CGFloat offset = scrollView.contentOffset.x;
				CGFloat boundX = -(_baseInsets.left + _headerLoader.bounds.size.width);
				
				if ( offset < boundX )
				{
					if ( BeeUIPullLoader.STATE_PULLING != _headerLoader.state )
					{
						[_headerLoader changeState:BeeUIPullLoader.STATE_PULLING animated:YES];
					}
				}
				else if ( offset < 0.0f )
				{
					if ( BeeUIPullLoader.STATE_NORMAL != _headerLoader.state )
					{
						[_headerLoader changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];
					}
				}
			}
			else
			{
				CGFloat offset = scrollView.contentOffset.y;
				CGFloat boundY = -(_baseInsets.top + _headerLoader.bounds.size.height);
				
				if ( offset < boundY )
				{
					if ( BeeUIPullLoader.STATE_PULLING != _headerLoader.state )
					{
						[_headerLoader changeState:BeeUIPullLoader.STATE_PULLING animated:YES];
					}
				}
				else if ( offset < 0.0f )
				{
					if ( BeeUIPullLoader.STATE_NORMAL != _headerLoader.state )
					{
						[_headerLoader changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];
					}
				}
			}
		}
		
		// TODO: footer loader
		
        if ( NO == _footerLoader.hidden && BeeUIPullLoader.STATE_LOADING != _footerLoader.state)
        {
            if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				CGFloat offset = scrollView.contentOffset.x;
				CGFloat boundX = (_baseInsets.right + _footerLoader.bounds.size.width);
				
				if ( offset > boundX )
				{
					if ( BeeUIPullLoader.STATE_PULLING != _footerLoader.state )
					{
						[_footerLoader changeState:BeeUIPullLoader.STATE_PULLING animated:YES];
					}
				}
				else if ( offset > scrollView.contentSize.width )
				{
					if ( BeeUIPullLoader.STATE_NORMAL != _footerLoader.state )
					{
						[_footerLoader changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];
					}
				}
			}
			else
			{
				CGFloat offset = scrollView.contentOffset.y;
				CGFloat boundY = (_baseInsets.bottom + _footerLoader.bounds.size.height);
				
				if ( offset > boundY )
				{
					if ( BeeUIPullLoader.STATE_PULLING != _footerLoader.state )
					{
						[_footerLoader changeState:BeeUIPullLoader.STATE_PULLING animated:YES];
					}
				}
				else if ( offset > scrollView.contentSize.height )
				{
					if ( BeeUIPullLoader.STATE_NORMAL != _footerLoader.state )
					{
						[_footerLoader changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];
					}
				}
			}
        }
	}

	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.DID_SCROLL];
	}
	
	[self syncPositions];
	[self syncPullPositions];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self syncPositions];
	[self syncPullPositions];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if ( decelerate )
	{
		// header loader
		
		if ( NO == _headerLoader.hidden && BeeUIPullLoader.STATE_LOADING != _headerLoader.state )
		{
			if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				CGFloat offset = scrollView.contentOffset.x;
				CGFloat boundY = -(_baseInsets.left + _headerLoader.bounds.size.width);
				
				if ( offset <= boundY )
				{
					if ( BeeUIPullLoader.STATE_LOADING != _headerLoader.state )
					{
						[_headerLoader changeState:BeeUIPullLoader.STATE_LOADING animated:YES];
	
						[self sendUISignal:BeeUIScrollView.HEADER_REFRESH];
					}
				}
				else
				{
					if ( BeeUIPullLoader.STATE_NORMAL != _headerLoader.state )
					{
						[_headerLoader changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];
					}
				}
			}
			else
			{
				CGFloat offset = scrollView.contentOffset.y;
				CGFloat boundY = -(_baseInsets.top + _headerLoader.bounds.size.height);
				
				if ( offset <= boundY )
				{
					if ( BeeUIPullLoader.STATE_LOADING != _headerLoader.state )
					{
						[_headerLoader changeState:BeeUIPullLoader.STATE_LOADING animated:YES];

						[self sendUISignal:BeeUIScrollView.HEADER_REFRESH];
					}
				}
				else
				{
					if ( BeeUIPullLoader.STATE_NORMAL != _headerLoader.state )
					{
						[_headerLoader changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];
					}
				}
			}
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:ANIMATION_DURATION];
			[self syncPullPositions];
			[self syncPullInsets];
			[UIView commitAnimations];
		}
		
		// TODO: footer loader
		
        if ( NO == _footerLoader.hidden && BeeUIPullLoader.STATE_LOADING != _footerLoader.state)
        {
            if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				CGFloat offset = scrollView.contentOffset.x;
				CGFloat boundX = (_baseInsets.right + _footerLoader.bounds.size.width);
				
				if ( offset > boundX )
				{
					if ( BeeUIPullLoader.STATE_LOADING != _footerLoader.state )
					{
						[_footerLoader changeState:BeeUIPullLoader.STATE_LOADING animated:YES];
						
                        [self sendUISignal:self.FOOTER_REFRESH];
					}
				}
				else if ( offset > scrollView.contentSize.width )
				{
					if ( BeeUIPullLoader.STATE_NORMAL != _footerLoader.state )
					{
						[_footerLoader changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];
					}
				}
			}
			else
			{
				CGFloat offset = scrollView.contentOffset.y;
				CGFloat boundY = (_baseInsets.bottom + _footerLoader.bounds.size.height);
				
				if ( offset > boundY )
				{
					if ( BeeUIPullLoader.STATE_LOADING != _footerLoader.state )
					{
						[_footerLoader changeState:BeeUIPullLoader.STATE_LOADING animated:YES];
						
                        [self sendUISignal:self.FOOTER_REFRESH];
					}
				}
				else if ( offset > scrollView.contentSize.height )
				{
					if ( BeeUIPullLoader.STATE_NORMAL != _footerLoader.state )
					{
						[_footerLoader changeState:BeeUIPullLoader.STATE_NORMAL animated:YES];
					}
				}
			}
            
            [UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3f];
			[UIView setAnimationBeginsFromCurrentState:YES];
			
			CC( @"pulled" );
			
			[self syncPullPositions];
			[self syncPullInsets];
            
			[UIView commitAnimations];
        }
	}

	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.DID_DRAG];
//		[self sendUISignal:BeeUIScrollView.DID_STOP];
	}
	
	[self syncPositions];
	[self syncPullPositions];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	[self syncPositions];
	[self syncPullPositions];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.DID_STOP];
	}

	[self syncPositions];
	[self syncPullPositions];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self syncPositions];
	[self syncPullPositions];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

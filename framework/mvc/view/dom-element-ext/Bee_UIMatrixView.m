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

#import "Bee_UIMatrixView.h"
#import "Bee_UICapability.h"

#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

#undef	MAX_QUEUED_ITEMS
#define	MAX_QUEUED_ITEMS	(32)

#pragma mark -

@interface BeeUIMatrixCol : NSObject
{
	BOOL				_visible;
	NSInteger			_index;
	CGRect				_rect;
	UIView *			_view;
}

@property (nonatomic, assign) BOOL				visible;
@property (nonatomic, assign) NSInteger			index;
@property (nonatomic, assign) CGRect			rect;
@property (nonatomic, assign) UIView *			view;

@end

#pragma mark -

@implementation BeeUIMatrixCol

@synthesize visible = _visible;
@synthesize index = _index;
@synthesize rect = _rect;
@synthesize	view = _view;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_visible = NO;
		_index = 0;
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

@interface BeeUIMatrixRow : NSObject
{
	BOOL				_visible;
	NSInteger			_index;
	NSMutableArray *	_cols;
	CGRect				_rect;
}

@property (nonatomic, assign) BOOL				visible;
@property (nonatomic, assign) NSInteger			index;
@property (nonatomic, retain) NSMutableArray *	cols;
@property (nonatomic, assign) CGRect			rect;

@end

#pragma mark -

@implementation BeeUIMatrixRow

@synthesize visible = _visible;
@synthesize index = _index;
@synthesize rect = _rect;
@synthesize	cols = _cols;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_visible = NO;
		_index = 0;
		_rect = CGRectZero;
		_cols = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_cols removeAllObjects];
	[_cols release];
	
	[super dealloc];
}

@end

#pragma mark -

@interface BeeUIMatrixView()
{
	BOOL						_inited;
	id							_dataSource;
	
	NSInteger					_rowTotal;
	NSInteger					_colTotal;
	CGSize						_itemSize;
	
	NSRange						_rowVisibleRange;
	NSRange						_colVisibleRange;
	
	NSMutableArray *			_items;
	
	BOOL						_shouldNotify;
	BOOL						_reachTop;
	BOOL						_reachBottom;
	BOOL						_reachLeft;
	BOOL						_reachRight;
	
	BOOL						_reloaded;
	BOOL						_reloading;
	UIEdgeInsets				_baseInsets;
	
	NSMutableArray *			_reuseQueue;
	
	CGPoint						_scrollSpeed;
	CGPoint						_lastOffset;
	NSTimeInterval				_lastOffsetCapture;
}

- (void)initSelf;

- (void)syncPositions;
- (void)calcPositions;
- (void)operateReloadData;
- (void)internalReloadData;

@end

#pragma mark -

@implementation BeeUIMatrixView

IS_CONTAINABLE( YES )

DEF_SIGNAL( RELOADED )		// 数据重新加载
DEF_SIGNAL( REACH_TOP )		// 触顶
DEF_SIGNAL( REACH_BOTTOM )	// 触底
DEF_SIGNAL( REACH_LEFT )	// 触左边
DEF_SIGNAL( REACH_RIGHT )	// 触右边

DEF_SIGNAL( DID_STOP )
DEF_SIGNAL( DID_SCROLL )

@synthesize dataSource = _dataSource;

@synthesize rowTotal = _rowTotal;
@synthesize colTotal = _colTotal;

@dynamic rowVisibleRange;
@dynamic colVisibleRange;

@synthesize items = _items;

@synthesize reachTop = _reachTop;
@synthesize reachBottom = _reachBottom;
@synthesize reachLeft = _reachLeft;
@synthesize reachRight = _reachRight;

@synthesize reloaded = _reloaded;
@synthesize reloading = _reloading;
@synthesize reuseQueue = _reuseQueue;

@synthesize scrollSpeed = _scrollSpeed;
@dynamic baseInsets;

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

- (void)initSelf
{
	if ( NO == _inited )
	{
		_dataSource = self;
		
		_reloaded = NO;
		_shouldNotify = YES;

		[_items release];
		_items = [[NSMutableArray alloc] init];
		
		[_reuseQueue release];
		_reuseQueue = [[NSMutableArray alloc] init];
		
		_rowTotal = 0;
		_colTotal = 0;
		_itemSize = CGSizeZero;

		_rowVisibleRange = NSMakeRange( 0, 0 );
		_colVisibleRange = NSMakeRange( 0, 0 );
		
		_reachTop = NO;
		_reachBottom = NO;
		_reachLeft = NO;
		_reachRight = NO;

		_baseInsets = UIEdgeInsetsZero;	

		self.backgroundColor = [UIColor clearColor];
		self.contentSize = self.bounds.size;
		self.contentInset = _baseInsets;
		self.alwaysBounceVertical = YES;
		self.alwaysBounceHorizontal = YES;
		self.bounces = YES;
		self.scrollEnabled = YES;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.alpha = 1.0f;
		self.delegate = self;
		self.directionalLockEnabled = YES;
		self.layer.masksToBounds = YES;
		
//		[self load];
		[self performLoad];
		
		_inited = YES;
	}
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];

	[_reuseQueue removeAllObjects];
	[_reuseQueue release];
	_reuseQueue = nil;
	
	[_items removeAllObjects];
	[_items release];
	_items = nil;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	[super dealloc];
}

- (void)setBaseInsets:(UIEdgeInsets)insets
{
	_baseInsets = insets;
	self.contentInset = insets;
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
			[self sendUISignal:BeeUIMatrixView.RELOADED];
		}
	}
}

- (void)internalReloadData
{
	CGSize		newItemSize = [_dataSource sizeOfViewForMatrixView:self];
	NSInteger	newRowTotal = [_dataSource numberOfRowsInMatrixView:self];
	NSInteger	newColTotal = [_dataSource numberOfColsInMatrixView:self];

	BOOL changed = NO;
	
	if ( NO == CGSizeEqualToSize(newItemSize, _itemSize) )
	{
		changed = YES;
	}
	else if ( newRowTotal != _rowTotal )
	{
		changed = YES;
	}
	else if ( newColTotal != _colTotal )
	{
		changed = YES;
	}

	if ( changed )
	{
		_itemSize = newItemSize;
		_rowTotal = newRowTotal;
		_colTotal = newColTotal;

		CGSize contSize = CGSizeZero;
		contSize.width = _itemSize.width * newColTotal;
		contSize.height = _itemSize.height * newRowTotal;
		self.contentSize = contSize;
		
		[_items removeAllObjects];

		for ( NSInteger i = 0; i < _rowTotal; ++i )
		{
			CGRect rowRect;
			rowRect.size.width = _itemSize.width * _colTotal;
			rowRect.size.height = _itemSize.height;
			rowRect.origin.x = 0.0f;
			rowRect.origin.y = _itemSize.height * i;

			BeeUIMatrixRow * row = [[[BeeUIMatrixRow alloc] init] autorelease];
			row.index = i;
			row.rect = rowRect;

			for ( NSInteger j = 0; j < _colTotal; ++j )
			{
				CGRect colRect;
				colRect.size.width = _itemSize.width;
				colRect.size.height = _itemSize.height;
				colRect.origin.x = rowRect.origin.x + _itemSize.width * j;
				colRect.origin.y = rowRect.origin.y;

				BeeUIMatrixCol * col = [[[BeeUIMatrixCol alloc] init] autorelease];
				col.index = j;
				col.rect = colRect;

				[row.cols addObject:col];
			}

			[_items addObject:row];
		}

		[self calcPositions];
		[self syncPositions];
	}

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
}

- (id)dequeueWithContentClass:(Class)clazz
{
	for ( UIView * reuseView in _reuseQueue )
	{
		if ( [reuseView isKindOfClass:clazz] )
		{
			INFO( @"UIMatrixView, dequeue <= (%p)", reuseView );

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
//	if ( self.contentOffset.x < 0 || self.contentOffset.x + self.bounds.size.width > self.contentSize.width )
//	{
//		if ( _colVisibleRange.length > 0 )
//			return;
//	}
//
//	if ( self.contentOffset.y < 0 || self.contentOffset.y + self.bounds.size.height > self.contentSize.height )
//	{
//		if ( _rowVisibleRange.length > 0 )
//			return;
//	}

	INFO( @"UIMatrixView, subviews = %d", [self.subviews count] );

PERF_ENTER

	CGRect visibleRect;
	visibleRect.origin = self.contentOffset;
	visibleRect.size = self.bounds.size;

	NSInteger rowVisibleBegin = 0;
	NSInteger rowVisibleEnd = 0;

	NSInteger colVisibleBegin = 0;
	NSInteger colVisibleEnd = 0;

	for ( BeeUIMatrixRow * row in _items )
	{
	PERF_ENTER_( row_visible )
		row.visible = CGRectIntersectsRect( row.rect, visibleRect );
	PERF_LEAVE_( row_visible )

		if ( row.visible )
		{
			if ( rowVisibleBegin < 0 )
			{
				rowVisibleBegin = row.index;
			}
			
			rowVisibleEnd = row.index;
		}
		
		for ( BeeUIMatrixCol * col in row.cols )
		{
		PERF_ENTER_( row_visible )
			col.visible = row.visible ? CGRectIntersectsRect(col.rect, visibleRect) : NO;
		PERF_LEAVE_( col_visible )

			if ( col.visible )
			{
				if ( colVisibleBegin < 0 )
				{
					colVisibleBegin = col.index;
				}
				
				colVisibleEnd = col.index;
			}
			
		//	INFO( @"UIMatrixView, syncPositions(%d, %d), %@", row.index, col.index, col.visible ? @"visible" : @"" );
			
			if ( NO == col.visible )
			{
			PERF_ENTER_( enqueue )
				if ( col.view )
				{
					if ( _reuseQueue.count >= MAX_QUEUED_ITEMS )
					{
						[_reuseQueue removeObject:[_reuseQueue objectAtIndex:0]];
					}
					
					INFO( @"UIMatrixView, enqueue '%@' %p", [[col.view class] description], col.view );
					[_reuseQueue addObject:col.view];
					
					[col.view removeFromSuperview];
					col.view = nil;
				}
			PERF_LEAVE_( enqueue )
			}
			else
			{
			PERF_ENTER_( dequeue )
				if ( nil == col.view )
				{
					col.view = [_dataSource matrixView:self row:row.index col:col.index];
					col.view.frame = col.rect;
				}

				if ( col.view && col.view.superview != self )
				{
	//				[col.view retain];
					[col.view removeFromSuperview];
					[self addSubview:col.view];	
	//				[col.view release];
				}

//				INFO( @"%p, (%f, %f), (%f, %f)",
//				  col.view,
//				  col.rect.origin.x, col.rect.origin.y,
//				  col.rect.size.width, col.rect.size.height );
			PERF_LEAVE_( dequeue )
			}			
		}
	}
	
PERF_ENTER_( signal )
	
	_colVisibleRange = NSMakeRange( colVisibleBegin, colVisibleEnd - colVisibleBegin + 1 );
	_rowVisibleRange = NSMakeRange( rowVisibleBegin, rowVisibleEnd - rowVisibleBegin + 1 );

	BOOL reachTop = (0 == _rowVisibleRange.location) ? YES : NO;
	if ( reachTop )
	{
		if ( NO == _reachTop )
		{
			if ( _shouldNotify )
			{
				[self sendUISignal:BeeUIMatrixView.REACH_TOP];
			}
			
			_reachTop = YES;
		}			
	}
	else
	{
		_reachTop = NO;
	}
	
	BOOL reachBottom = (_rowVisibleRange.location + _rowVisibleRange.length >= _rowTotal - 1) ? YES : NO;
	if ( reachBottom )
	{
		if ( NO == _reachBottom )
		{
			if ( _shouldNotify )
			{
				[self sendUISignal:BeeUIMatrixView.REACH_BOTTOM];
			}
			
			_reachBottom = YES;
		}
	}
	else
	{
		_reachBottom = NO;
	}
	
	BOOL reachLeft = (0 == _colVisibleRange.location) ? YES : NO;
	if ( reachLeft )
	{
		if ( NO == _reachLeft )
		{
			if ( _shouldNotify )
			{
				[self sendUISignal:BeeUIMatrixView.REACH_LEFT];
			}
			
			_reachLeft = YES;
		}
	}
	else
	{
		_reachLeft = NO;
	}

	BOOL reachRight = (_colVisibleRange.location + _colVisibleRange.length >= _colTotal - 1) ? YES : NO;
	if ( reachRight )
	{
		if ( NO == _reachRight )
		{
			if ( _shouldNotify )
			{
				[self sendUISignal:BeeUIMatrixView.REACH_RIGHT];
			}
			
			_reachRight = YES;
		}
	}
	else
	{
		_reachRight = NO;
	}
	
PERF_LEAVE_( signal )
PERF_LEAVE
}

- (void)calcPositions
{
}

#pragma mark -
#pragma mark BeeUIScrollViewDelegate

- (CGSize)sizeOfViewForMatrixView:(BeeUIMatrixView *)matrixView
{
	return CGSizeZero;
}

- (NSInteger)numberOfRowsInMatrixView:(BeeUIMatrixView *)matrixView
{
	return 0;
}

- (NSInteger)numberOfColsInMatrixView:(BeeUIMatrixView *)matrixView
{
	return 0;
}

- (UIView *)matrixView:(BeeUIMatrixView *)matrixView row:(NSInteger)row col:(NSInteger)col
{
	return nil;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//	if ( scrollView.dragging )
//	{
//		if ( NO == _pullLoader.hidden && BeeUIScrollView.STATE_LOADING != _pullLoader.state )
//		{
//			if ( BeeUIScrollView.STATE_NORMAL == _pullLoader.state )
//			{
//				_baseInsets = scrollView.contentInset;
//			}
//			
//			CGFloat offset = scrollView.contentOffset.y;
//			CGFloat boundY = -(_baseInsets.top + 60.0f);
//			
//			if ( offset < boundY )
//			{
//				if ( BeeUIScrollView.STATE_PULLING != _pullLoader.state )
//				{
//					[_pullLoader changeState:BeeUIScrollView.STATE_PULLING animated:YES];
//				}				
//			}
//			else if ( offset < 0.0f )
//			{
//				if ( BeeUIScrollView.STATE_NORMAL != _pullLoader.state )
//				{
//					[_pullLoader changeState:BeeUIScrollView.STATE_NORMAL animated:YES];
//				}				
//			}
//		}
//	}

	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIMatrixView.DID_SCROLL];
	}
	
	[self syncPositions];

	CGPoint			currentOffset = self.contentOffset;
    NSTimeInterval	currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval	timeDiff = currentTime - _lastOffsetCapture;

    if ( timeDiff > 0.1 )
	{
		_scrollSpeed.x = ((currentOffset.x - _lastOffset.x) / 1000.0f);
		_scrollSpeed.y = ((currentOffset.y - _lastOffset.y) / 1000.0f);
		
        _lastOffset = currentOffset;
        _lastOffsetCapture = currentTime;
    }

//	INFO( @"scrollSpeed = (%f, %f)", _scrollSpeed.x, _scrollSpeed.y );
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self syncPositions];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//	if ( decelerate )
//	{
//		if ( NO == _pullLoader.hidden && BeeUIScrollView.STATE_LOADING != _pullLoader.state )
//		{
//			CGFloat offset = scrollView.contentOffset.y;
//			CGFloat boundY = -(_baseInsets.top + 80.0f);
//			
//			if ( offset <= boundY )
//			{
//				if ( BeeUIScrollView.STATE_LOADING != _pullLoader.state )
//				{
//					[UIView beginAnimations:nil context:NULL];
//					[UIView setAnimationDuration:0.3f];
//					UIEdgeInsets insets = _baseInsets;
//					insets.top += _pullLoader.bounds.size.height;
//					scrollView.contentInset = insets;
//					[UIView commitAnimations];
//					
//					[_pullLoader changeState:BeeUIScrollView.STATE_LOADING animated:YES];
//					
//					[self sendUISignal:BeeUIFlowBoard.PULL_REFRESH];
//				}
//			}
//			else
//			{
//				if ( BeeUIScrollView.STATE_NORMAL != _pullLoader.state )
//				{
//					[UIView beginAnimations:nil context:NULL];
//					[UIView setAnimationDuration:0.3f];
//					scrollView.contentInset = _baseInsets;				
//					[UIView commitAnimations];
//					
//					[_pullLoader changeState:BeeUIScrollView.STATE_NORMAL animated:YES];
//				}
//			}
//		}
//	}
	
	if ( NO == decelerate )
	{
		if ( _shouldNotify )
		{
			[self sendUISignal:BeeUIMatrixView.DID_STOP];
		}

		if ( self.contentOffset.x < 0 )
		{
			_reachLeft = NO;
		}
		
		if ( self.contentOffset.x + self.bounds.size.width >= self.contentSize.width )
		{
			_reachRight = NO;
		}
		
		if ( self.contentOffset.y < 0 )
		{
			_reachTop = NO;
		}
		
		if ( self.contentOffset.y + self.bounds.size.height >= self.contentSize.height )
		{
			_reachBottom = NO;
		}
	}
	
	[self syncPositions];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	[self syncPositions];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIMatrixView.DID_STOP];
	}
	
	[self syncPositions];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self syncPositions];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

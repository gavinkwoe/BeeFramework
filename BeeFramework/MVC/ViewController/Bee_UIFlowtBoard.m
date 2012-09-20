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
//  Bee_UIFlowBoard.m
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "Bee_UIFlowBoard.h"
#import "Bee_Runtime.h"
#import "Bee_Log.h"

#pragma mark -

@interface BeeUIFlowItem : NSObject
{
	BOOL		_visible;
	NSInteger	_index;
	NSInteger	_column;
	CGFloat		_scale;
	CGSize		_size;
	CGRect		_rect;
	UIView *	_view;
}

@property (nonatomic, assign) BOOL			visible;
@property (nonatomic, assign) NSInteger		index;
@property (nonatomic, assign) NSInteger		column;
@property (nonatomic, assign) CGFloat		scale;
@property (nonatomic, assign) CGSize		size;
@property (nonatomic, assign) CGRect		rect;
@property (nonatomic, assign) UIView *		view;

@end

#pragma mark -

@implementation BeeUIFlowItem

@synthesize visible = _visible;
@synthesize	index = _index;
@synthesize column = _column;
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
		_column = 0;
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

@interface BeeUIFlowBoard(Private)
- (void)syncPositions;
- (void)calcPositions;

- (void)releaseAllViews;
- (void)releaseViewsBefore:(NSInteger)index;
- (void)releaseViewsAfter:(NSInteger)index;

- (NSInteger)getShortestColumn;
- (NSInteger)getLongestColumn;

- (void)operateReloadData;
- (void)internalReloadData;
@end

#pragma mark -

@implementation BeeUIFlowBoard

DEF_SIGNAL( RELOADED )		// 数据重新加载
DEF_SIGNAL( PULL_REFRESH )	// 刷新
DEF_SIGNAL( REACH_TOP )		// 触顶
DEF_SIGNAL( REACH_BOTTOM )	// 触底

@synthesize reloading = _reloading;
@synthesize pullLoader = _pullLoader;
@synthesize scrollView = _scrollView;
@synthesize reuseQueue = _reuseQueue;

- (void)load
{
	_colCount = 0;
	
	_total = 0;
	_items = [[NSMutableArray alloc] init];
	_reuseQueue = [[NSMutableArray alloc] init];
	
	_visibleStart = 0;
	_visibleEnd = 0;
	
	_reachTop = NO;
	_reachEnd = NO;		
	_baseInsets = UIEdgeInsetsZero;
}

- (void)unload
{
	[self releaseAllViews];

	[_reuseQueue removeAllObjects];
	[_reuseQueue release];
	_reuseQueue = nil;
	
	[_items removeAllObjects];
	[_items release];
	_items = nil;

	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (float)getScrollPercent
{
	float height = _scrollView.contentSize.height;
	float offset = _scrollView.contentOffset.y;
	float percent = (offset / height);

	CC( @"height = %0.2f, offset = %0.2f, percent = %0.2f", height, offset, percent );
	return percent;
}

- (void)setBaseInsets:(UIEdgeInsets)insets
{
	_baseInsets = insets;
	_scrollView.contentInset = insets;
}

- (UIEdgeInsets)getBaseInsets
{
	return _baseInsets;
}

- (void)reloadData
{
	[self syncReloadData];
}

- (void)syncReloadData
{
	if ( _scrollView )
	{
		_scrollView.userInteractionEnabled = NO;
		
		[self cancelReloadData];
		_reloading = YES;
		[self operateReloadData];
		
		_scrollView.userInteractionEnabled = YES;		
	}
}

- (void)asyncReloadData
{
	if ( NO == _reloading )
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateReloadData) object:nil];
		[self performSelector:@selector(operateReloadData) withObject:nil afterDelay:0.2f];
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
		[self sendUISignal:BeeUIFlowBoard.RELOADED];
	}
}

- (void)showPullLoader:(BOOL)en animated:(BOOL)animated
{
	if ( en )
	{
		_pullLoader.hidden = NO;
	}
	else
	{
		_pullLoader.hidden = YES;
	}
}

- (void)setPullLoading:(BOOL)en
{
	if ( en )
	{
		if ( BEE_UIPULLLOADER_STATE_LOADING != _pullLoader.state )
		{
			if ( BEE_UIPULLLOADER_STATE_NORMAL == _pullLoader.state )
			{
				_baseInsets = _scrollView.contentInset;
			}
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3f];
			UIEdgeInsets insets = _baseInsets;
			insets.top += _pullLoader.bounds.size.height;
			_scrollView.contentInset = insets;
			[UIView commitAnimations];

			[_pullLoader changeState:BEE_UIPULLLOADER_STATE_LOADING animated:YES];
		}
	}
	else
	{
		if ( BEE_UIPULLLOADER_STATE_NORMAL != _pullLoader.state )
		{
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3f];
			_scrollView.contentInset = _baseInsets;
			[UIView commitAnimations];

			[_pullLoader changeState:BEE_UIPULLLOADER_STATE_NORMAL animated:YES];
		}
	}
}

- (void)scrollToTop:(BOOL)animated
{
	CGPoint offset;
	offset.x = 0.0f;
	offset.y = -1.0f * _baseInsets.top;

	[_scrollView setContentOffset:offset animated:animated];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			CGRect bounds = self.viewBound;

			_scrollView = [[UIScrollView alloc] initWithFrame:bounds];
			_scrollView.backgroundColor = [UIColor clearColor];
			_scrollView.contentSize = bounds.size;
			_scrollView.contentInset = _baseInsets;
	//		_scrollView.decelerationRate = _scrollView.decelerationRate * 0.25f;
			_scrollView.alwaysBounceVertical = YES;
			_scrollView.bounces = YES;
			_scrollView.scrollEnabled = YES;
			_scrollView.showsVerticalScrollIndicator = NO;
			_scrollView.showsHorizontalScrollIndicator = NO;
			_scrollView.alpha = 1.0f;
			_scrollView.delegate = self;
			_scrollView.layer.masksToBounds = NO;
			[self.view addSubview:_scrollView];

			CGRect pullFrame;
			pullFrame.origin.x = 0.0f;
			pullFrame.origin.y = -60.0f;
			pullFrame.size.width = bounds.size.width;
			pullFrame.size.height = 60.0f;

			_pullLoader = [[BeeUIPullLoader alloc] initWithFrame:pullFrame];
			_pullLoader.hidden = YES;
			_pullLoader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			[_scrollView addSubview:_pullLoader];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			[self releaseAllViews];
			
			SAFE_RELEASE_SUBVIEW( _scrollView );
			SAFE_RELEASE_SUBVIEW( _pullLoader );
		}
		else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
		{
		}
		else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
		{
			[self asyncReloadData];
		}
		else if ( [signal is:BeeUIBoard.FREE_DATAS] )
		{
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
			[self syncReloadData];
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
}

- (void)internalReloadData
{
	_colCount = [self numberOfColumns];

	for ( NSInteger i = 0; i < FLOW_MAX_COLUMNS; ++i )
	{
		_colHeights[i] = 0.0f;
	}
	
	_total = [self numberOfViews];

	[self releaseAllViews];
	[self calcPositions];
	[self syncPositions];
}

- (UIView *)dequeueWithContentClass:(Class)clazz
{
	for ( UIView * reuseView in _reuseQueue )
	{
		if ( [reuseView isKindOfClass:clazz] )
		{
			CC( @"FlowBoard, dequeue <= (%p)", reuseView );

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
	CC( @"FlowBoard, subviews = %d", [self.scrollView.subviews count] );
	
	NSInteger columnFits = 0;
	CGFloat columnHeights[FLOW_MAX_COLUMNS] = { 0.0f };

	_visibleStart = 0;
	_visibleEnd = 0;

	for ( NSInteger i = 0; i < _total; ++i )
	{
		BeeUIFlowItem * item = [_items objectAtIndex:i];
		item.visible = NO;

		// 先找起始INDEX
		if ( CGRectGetMaxY(item.rect) >= _scrollView.contentOffset.y )
		{
			_visibleStart = i;
			break;
		}

		if ( item.view )
		{
			CC( @"FlowBoard, enqueue => (%p)", item.view );
			[_reuseQueue addObject:item.view];

			[item.view removeFromSuperview];
			item.view = nil;
		}
	}

	for ( NSInteger j = _visibleStart; j < _total; ++j )
	{
		BeeUIFlowItem * item = [_items objectAtIndex:j];

		if ( columnHeights[item.column] < _scrollView.bounds.size.height )
		{
			item.visible = YES;

			if ( item.rect.origin.y < _scrollView.contentOffset.y )
			{
				columnHeights[item.column] += item.rect.origin.y + item.rect.size.height - _scrollView.contentOffset.y;
			}
			else if ( item.rect.origin.y > (_scrollView.contentOffset.y + _scrollView.bounds.size.height) )
			{
				columnHeights[item.column] += 0.0f;
			}
			else
			{
				columnHeights[item.column] += item.rect.size.height;
			}

			if ( columnHeights[item.column] >= _scrollView.bounds.size.height )
			{
				columnFits += 1;
			}					
		}
		else
		{
			item.visible = NO;
			
			if ( item.view )
			{
				CC( @"FlowBoard, enqueue => (%p)", item.view );
				[_reuseQueue addObject:item.view];

				[item.view removeFromSuperview];
				item.view = nil;
			}
		}

		// 再找终止INDEX
//		if ( CGRectGetMaxY( item.rect ) > _scrollView.contentOffset.y + _scrollView.bounds.size.height )
		if ( columnFits >= _colCount )
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
		BeeUIFlowItem * item = [_items objectAtIndex:k];
		item.visible = NO;

		if ( item.view )
		{
			CC( @"FlowBoard, enqueue => (%p)", item.view );
			[_reuseQueue addObject:item.view];

			[item.view removeFromSuperview];
			item.view = nil;
		}
	}

	CC( @"start = %d, end = %d", _visibleStart, _visibleEnd );
		
	if ( _total > 0 )
	{
		for ( NSInteger l = _visibleStart; l <= _visibleEnd; ++l )
		{
			BeeUIFlowItem * item = [_items objectAtIndex:l];		
			if ( NO == item.visible )
				continue;
			
			if ( nil == item.view )
			{
				item.view = [self viewForIndex:l scale:item.scale];
				item.view.frame = item.rect;
			}

			if ( item.view && item.view.superview != _scrollView )
			{
//				[item.view retain];
				[item.view removeFromSuperview];
				[_scrollView addSubview:item.view];	
//				[item.view release];
			}

//			CC( @"%p, (%f, %f), (%f, %f)",
//				  item.view,
//				  item.rect.origin.x, item.rect.origin.y,
//				  item.rect.size.width, item.rect.size.height );
		}		
		
		BOOL reachTop = (0 == _visibleStart) ? YES : NO;
		if ( reachTop )
		{
			if ( NO == _reachTop )
			{
				[self sendUISignal:BeeUIFlowBoard.REACH_TOP];
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
				[self sendUISignal:BeeUIFlowBoard.REACH_BOTTOM];
				_reachEnd = YES;			
			}
		}
		else
		{
			_reachEnd = NO;
		}
	}
}

- (void)calcPositions
{
	if ( 0 == _total )
		return;
	
	CGRect bounds = _scrollView.bounds;
	CGFloat itemWidth = bounds.size.width / _colCount;
	BeeUIFlowItem * item = nil;

	for ( NSInteger i = 0; i < _total; ++i )
	{
		if ( i >= [_items count] )
		{
			item = [[BeeUIFlowItem alloc] init];
			item.index = i;
			[_items addObject:item];
			[item release];

		//	CC( @"%@", [item description] );
		}
		else
		{
			item = [_items objectAtIndex:i];
		}

		item.size = [self sizeForIndex:i];
		item.column = [self getShortestColumn];
		item.scale = (0.0f == item.size.width) ? 1.0f : (itemWidth / item.size.width);
		item.rect = CGRectMake( item.column * itemWidth, _colHeights[item.column], itemWidth, item.size.height * item.scale );

		if ( item.column < _colCount )
		{
			_colHeights[item.column] += item.rect.size.height;
		}
		else
		{
			_colHeights[item.column] += 0.0f;
		}
	}

	NSInteger column = [self getLongestColumn];
	if ( column < _colCount )
	{
		_scrollView.contentSize = CGSizeMake( _scrollView.bounds.size.width, _colHeights[column] );
	}
	else
	{
		_scrollView.contentSize = CGSizeMake( _scrollView.bounds.size.width, 0.0f );
	}

	for ( BeeUIFlowItem * item in _items )
	{
		CC( @"index = %d, visible = %d, column = %d, rect = (%.1f,%.1f, %.1f,%.1f)",
			  item.index, item.visible, item.column,
			  item.rect.origin.x, item.rect.origin.y,
			  item.rect.size.width, item.rect.size.height );
	}
}

- (float)getHeight
{
	NSInteger column = [self getLongestColumn];
	if ( column < _total )
	{
		return _colHeights[column];
	}
	else
	{
		return 0.0f;
	}
}

- (NSInteger)getLongestColumn
{
	if ( 0 == _total )
	{
		return _colCount + 1;
	}

	NSInteger longest = 0;

	for ( NSInteger i = 0; i < _colCount; ++i )
	{
		if ( _colHeights[i] > _colHeights[longest] )
		{
			longest = i;
		}
	}

	return longest;	
}

- (NSInteger)getShortestColumn
{
	if ( 0 == _total )
	{
		return _colCount + 1;
	}

	NSInteger shortest = 0;

	for ( NSInteger i = 0; i < _colCount; ++i )
	{
		if ( _colHeights[i] < _colHeights[shortest] )
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
		for ( BeeUIFlowItem * item in _items )
		{
			[item.view removeFromSuperview];
			item.view = nil;
		}
		
		[_items removeAllObjects];		
	}
	
	if ( _reuseQueue )
	{
		[_reuseQueue removeAllObjects];
	}	
}

- (void)releaseViewsBefore:(NSInteger)index
{
}

- (void)releaseViewsAfter:(NSInteger)index
{
}

#pragma mark -
#pragma mark FlowBoardDelegate

- (void)didScrollToBottom
{
	
}

#pragma mark -
#pragma mark FlowBoardDataSource

- (NSInteger)numberOfColumns
{
	return 0;
}

- (NSInteger)numberOfViews
{
	return 0;
}

- (UIView *)viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	return nil;
}

- (CGSize)sizeForIndex:(NSInteger)index
{
	return CGSizeZero;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if ( scrollView.dragging )
	{
		if ( NO == _pullLoader.hidden && BEE_UIPULLLOADER_STATE_LOADING != _pullLoader.state )
		{
			if ( BEE_UIPULLLOADER_STATE_NORMAL == _pullLoader.state )
			{
				_baseInsets = scrollView.contentInset;
			}

			CGFloat offset = scrollView.contentOffset.y;
			CGFloat boundY = -(_baseInsets.top + 60.0f);
			
			if ( offset < boundY )
			{
				if ( BEE_UIPULLLOADER_STATE_PULLING != _pullLoader.state )
				{
					[_pullLoader changeState:BEE_UIPULLLOADER_STATE_PULLING animated:YES];
				}				
			}
			else if ( offset < 0.0f )
			{
				if ( BEE_UIPULLLOADER_STATE_NORMAL != _pullLoader.state )
				{
					[_pullLoader changeState:BEE_UIPULLLOADER_STATE_NORMAL animated:YES];
				}				
			}
		}
	}
	
	[self syncPositions];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self syncPositions];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if ( decelerate )
	{
		if ( NO == _pullLoader.hidden && BEE_UIPULLLOADER_STATE_LOADING != _pullLoader.state )
		{
			CGFloat offset = scrollView.contentOffset.y;
			CGFloat boundY = -(_baseInsets.top + 80.0f);
			
			if ( offset <= boundY )
			{
				if ( BEE_UIPULLLOADER_STATE_LOADING != _pullLoader.state )
				{
					[UIView beginAnimations:nil context:NULL];
					[UIView setAnimationDuration:0.3f];
					UIEdgeInsets insets = _baseInsets;
					insets.top += _pullLoader.bounds.size.height;
					scrollView.contentInset = insets;
					[UIView commitAnimations];

					[_pullLoader changeState:BEE_UIPULLLOADER_STATE_LOADING animated:YES];

					[self sendUISignal:BeeUIFlowBoard.PULL_REFRESH];
				}
			}
			else
			{
				if ( BEE_UIPULLLOADER_STATE_NORMAL != _pullLoader.state )
				{
					[UIView beginAnimations:nil context:NULL];
					[UIView setAnimationDuration:0.3f];
					scrollView.contentInset = _baseInsets;				
					[UIView commitAnimations];
					
					[_pullLoader changeState:BEE_UIPULLLOADER_STATE_NORMAL animated:YES];
				}
			}
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
	[self syncPositions];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self syncPositions];
}

@end

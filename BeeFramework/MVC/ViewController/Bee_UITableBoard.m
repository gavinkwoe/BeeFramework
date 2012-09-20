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
//  Bee_UITableBoard.m
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "Bee_UITableBoard.h"
#import "Bee_UIKeyboard.h"
#import "Bee_Runtime.h"
#import "Bee_Log.h"
#import "Bee_UIRect.h"

#pragma mark -

#undef	SEARCH_BAR_HEIGHT
#define	SEARCH_BAR_HEIGHT	(44.0f)

#pragma mark -

@implementation BeeUITableViewCell

@synthesize innerCell = _innerCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.accessoryType = UITableViewCellAccessoryNone;
		self.editingAccessoryType = UITableViewCellAccessoryNone;
		self.showsReorderControl = NO;
		self.shouldIndentWhileEditing = NO;
		self.indentationLevel = 0;
		self.indentationWidth = 0.0f;
		self.alpha = 1.0f;
		self.layer.masksToBounds = YES;
		self.layer.opaque = YES;

		self.contentView.layer.masksToBounds = YES;
		self.contentView.layer.opaque = YES;
	}
	return self;
}

- (void)bindCell:(BeeUIGridCell *)cell
{
	if ( cell != self.innerCell )
	{
		if ( cell.superview != self.contentView )
		{
			[cell.superview removeFromSuperview];
		}

		self.innerCell = cell;
		self.innerCell.category = self.reuseIdentifier;

		[self.contentView addSubview:self.innerCell];
	}
}

- (void)bindData:(NSObject *)data
{
	[_innerCell bindData:data];
}

- (void)setFrame:(CGRect)rc
{
	[super setFrame:CGRectZeroNan(rc)];	

	[_innerCell setFrame:self.bounds];
//	[_innerCell layoutAllSubcells];
}

- (void)setCenter:(CGPoint)pt
{
	[super setCenter:pt];
	
	[_innerCell setFrame:self.bounds];
//	[_innerCell layoutAllSubcells];
}

// if the cell is reusable (has a reuse identifier),
// this is called just before the cell is returned from the table view method
// dequeueReusableCellWithIdentifier:.  If you override, you MUST call super.
- (void)prepareForReuse
{
	[super prepareForReuse];

	[_innerCell clearData];	
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
	self.showsReorderControl = NO;
	self.shouldIndentWhileEditing = NO;
	self.indentationLevel = 0;
	self.indentationWidth = 0.0f;
	
	[_innerCell layoutAllSubcells];
}

- (void)didTransitionToState:(UITableViewCellStateMask)state
{
	self.showsReorderControl = NO;
	self.shouldIndentWhileEditing = NO;
	self.indentationLevel = 0;
	self.indentationWidth = 0.0f;
	
	[_innerCell layoutAllSubcells];
}

- (void)dealloc
{
	[_innerCell removeFromSuperview];
	_innerCell = nil;

	[super dealloc];
}

@end

#pragma mark -

@interface BeeUITableBoard(Private)
- (void)disableScrollsToTopPropertyOnAllSubviewsOf:(UIView *)view;
- (void)enableScrollsToTopPropertyOnAllSubviewsOf:(UIView *)view;
- (void)operateReloadData;
- (void)layoutViews:(BOOL)animated;
- (void)didSearchMaskHidden;
- (void)syncScrollPosition;
@end

#pragma mark -

@implementation BeeUITableBoard

@synthesize reloading = _reloading;
@synthesize updating = _updating;
@synthesize searching = _searching;
@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;
@synthesize pullLoader = _pullLoader;
@synthesize searchBarStyle = _searchBarStyle;

@synthesize lastScrollPosition = _lastScrollPosition;
@synthesize currentScrollPosition = _currentScrollPosition;

DEF_SIGNAL( RELOADED )				// 数据重新加载
DEF_SIGNAL( PULL_REFRESH )			// 下拉刷新
DEF_SIGNAL( SEARCH_ACTIVE )			// 搜索开始
DEF_SIGNAL( SEARCH_UPDATE )			// 搜索更新
DEF_SIGNAL( SEARCH_DEACTIVE )		// 搜索结束
DEF_SIGNAL( SEARCH_COMMIT )			// 搜索提交
//DEF_SIGNAL( SCROLL_START )			// 滚动开始
//DEF_SIGNAL( SCROLL_UPDATE )			// 滚动更新
//DEF_SIGNAL( SCROLL_STOP )			// 滚动结束
//DEF_SIGNAL( SCROLL_REACH_TOP )		// 触顶
//DEF_SIGNAL( SCROLL_REACH_BOTTOM )	// 触底

- (void)load
{
	_baseInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
	
	_lastScrollPosition = CGPointZero;
	_currentScrollPosition = CGPointZero;

	_searchBarStyle = BEE_UITABLEBOARD_SEARCHBAR_STYLE_BOTTOM;
}

- (void)unload
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (BeeUITableViewCell *)dequeueWithContentClass:(Class)clazz
{
	NSString * clazzName = [NSString stringWithUTF8String:class_getName(clazz)];
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:clazzName];
	if ( nil == cell )
	{
		cell = [[[BeeUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clazzName] autorelease];
		
		BeeUIGridCell * innerCell = [(BeeUIGridCell *)[[BeeRuntime allocByClass:clazz] init] autorelease];
		[cell bindCell:innerCell];
		
		//		NSAssert( nil != cell.innerCell, @"out of memory" );
	}
	
	return cell;
}

- (BeeUITableViewCell *)dequeueWithContentCell:(BeeUIGridCell *)innerCell
{
	NSString * clazzName = [[innerCell class] description];
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:clazzName];
	if ( nil == cell )
	{
		cell = [[[BeeUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clazzName] autorelease];
		[cell bindCell:innerCell];
		
//		NSAssert( nil != cell.innerCell, @"out of memory" );
	}
	
	return cell;	
}

- (BeeUIGridCell *)contentForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
	if ( cell )
	{
		return cell.innerCell;
	}
	
	return nil;
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			CGRect bounds = self.viewBound;
			
			_tableView = [[UITableView alloc] initWithFrame:bounds];
			_tableView.delegate = self;
			_tableView.dataSource = self;
			_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
			_tableView.backgroundColor = [UIColor clearColor];
			_tableView.rowHeight = 44;
			_tableView.contentInset = _baseInsets;
//			_tableView.decelerationRate = _tableView.decelerationRate * 0.98f;
			_tableView.showsVerticalScrollIndicator = YES;
			_tableView.showsHorizontalScrollIndicator = NO;
			_tableView.bounces = YES;
//			_tableView.scrollsToTop = YES;
			[self.view addSubview:_tableView];	
			
			CGRect searchFrame;
			searchFrame.origin.x = 0.0f;
			searchFrame.origin.y = 0.0f; // bounds.size.height - SEARCH_BAR_HEIGHT;
			searchFrame.size.width = bounds.size.width;
			searchFrame.size.height = SEARCH_BAR_HEIGHT;
			
			_searchBar = [[UISearchBar alloc] initWithFrame:searchFrame];
			_searchBar.delegate = self;
			_searchBar.barStyle = UIBarStyleDefault; // UIBarStyleBlackTranslucent;
//			_searchBar.tintColor = [UIColor colorWithRed:242.0f/255.0f green:81.0f/255.0f blue:134.0f/255.0f alpha:1.0f];
			_searchBar.hidden = YES;
			_searchBar.backgroundColor = [UIColor clearColor];
			_searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			[self.view addSubview:_searchBar];
			
			[[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
			for ( UIView * subview in _searchBar.subviews ) 
			{  
				if ( [subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")] )
				{  
					[subview removeFromSuperview];  
					break;  
				}	
			}		
			
			CGRect pullFrame;
			pullFrame.origin.x = 0.0f;
			pullFrame.origin.y = -60.0f;
			pullFrame.size.width = bounds.size.width;
			pullFrame.size.height = 60.0f;
			
			_pullLoader = [[BeeUIPullLoader alloc] initWithFrame:pullFrame];
			_pullLoader.hidden = YES;
			_pullLoader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			_pullLoader.backgroundColor = [UIColor clearColor];
			[_tableView addSubview:_pullLoader];
			
			[self layoutViews:NO];
			[self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			SAFE_RELEASE_SUBVIEW( _tableView );
			SAFE_RELEASE_SUBVIEW( _searchBar );
			SAFE_RELEASE_SUBVIEW( _pullLoader );
			
			[self unobserveAllNotifications];
		}
		else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
		{
			[self asyncReloadData];
		}
		else if ( [signal is:BeeUIBoard.FREE_DATAS] )
		{
		}
		else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
		{
			if ( BEE_UITABLEBOARD_SEARCHBAR_STYLE_BOTTOM == _searchBarStyle )
			{
				CGRect bounds = self.view.bounds;
				CGRect searchFrame;
				searchFrame.origin.x = 0.0f;
				searchFrame.origin.y = bounds.size.height - SEARCH_BAR_HEIGHT;
				searchFrame.size.width = bounds.size.width;
				searchFrame.size.height = SEARCH_BAR_HEIGHT;
				
				if ( [BeeUIKeyboard sharedInstance].shown )
				{
					searchFrame.origin.y -= [BeeUIKeyboard sharedInstance].height;
				}
				
				_searchBar.frame = searchFrame;			
			}
			else
			{
				CGRect bounds = self.view.bounds;
				CGRect searchFrame;
				searchFrame.origin.x = 0.0f;
				searchFrame.origin.y = 0.0f; // bounds.size.height - SEARCH_BAR_HEIGHT;
				searchFrame.size.width = bounds.size.width;
				searchFrame.size.height = SEARCH_BAR_HEIGHT;
				
				_searchBar.frame = searchFrame;			
			}
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{		
			[self layoutViews:YES];		
			[self asyncReloadData];
						
//			[self disableScrollsToTopPropertyOnAllSubviewsOf:_tableView];
		}
		else if ( [signal is:BeeUIBoard.DID_APPEAR] )
		{
			[_tableView flashScrollIndicators];
			[_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];

//			[self enableScrollsToTopPropertyOnAllSubviewsOf:_tableView];
		}
		else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
		{
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{
		}
	}
}

- (void)handleNotification:(NSNotification *)notification
{
	if ( [notification is:BeeUIKeyboard.HEIGHT_CHANGED] )
	{
		
		NSTimeInterval animationDuration;
		UIViewAnimationCurve animationCurve;
		
		NSDictionary * userInfo =  (NSDictionary *)[notification userInfo];
		[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
		[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
				
		// Animate up or down
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:animationDuration];
		[UIView setAnimationCurve:animationCurve];
		//[self sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
		
		[UIView commitAnimations];
	}
}

#pragma mark -

- (float)getScrollPercent
{
	float height = _tableView.contentSize.height;
	float offset = _tableView.contentOffset.y;
	float percent = (offset / height);

	CC( @"height = %0.2f, offset = %0.2f, percent = %0.2f", height, offset, percent );
	return percent;
}

- (float)getScrollSpeed
{
	float speed = _lastScrollPosition.y - _currentScrollPosition.y;
	float normalizedSpeed = fabsf( fmaxf( -1.0f, fminf( 1.0f, speed / 20.0f ) ) );
	return normalizedSpeed;
}

- (void)setBaseInsets:(UIEdgeInsets)insets
{
	if ( _tableView.tableHeaderView && NO == _tableView.tableHeaderView.hidden )
	{
		insets.top -= 20.0f;		
	}

	if ( _tableView.tableFooterView && NO == _tableView.tableFooterView.hidden )
	{
		insets.bottom -= 20.0f;		
	}
	
	_baseInsets = insets;
	_tableView.contentInset = insets;
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
	if ( nil == _tableView )
		return;

	_tableView.userInteractionEnabled = NO;
	
	[self cancelReloadData];
	_reloading = YES;
	[self operateReloadData];
	
	_tableView.userInteractionEnabled = YES;	
}

- (void)updateRowHeights
{
	_updating = YES;
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
	if ( nil == _tableView )
		return;

	if ( YES == _reloading )
	{
		_reloading = NO;		
		
//		if ( _updating )
//		{
//			[_tableView beginUpdates];
//		}
				
		[_tableView reloadData];
		
//		if ( _updating )
//		{
//			[_tableView endUpdates];
			_updating = NO;
//		}				
		
		[self sendUISignal:BeeUITableBoard.RELOADED];
	}
}

- (void)showSearchBar:(BOOL)en animated:(BOOL)animated
{
	if ( en )
	{
		_searchBar.hidden = NO;
	}
	else
	{
		_searchBar.hidden = YES;
	}
	
	[self layoutViews:animated];
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
	
	[self layoutViews:animated];	
}

- (void)setPullLoading:(BOOL)en
{
	if ( en )
	{
		if ( BEE_UIPULLLOADER_STATE_LOADING != _pullLoader.state )
		{
			if ( BEE_UIPULLLOADER_STATE_NORMAL == _pullLoader.state )
			{
				_baseInsets = _tableView.contentInset;
			}

			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3f];
			UIEdgeInsets insets = _baseInsets;
			insets.top += _pullLoader.bounds.size.height;
			_tableView.contentInset = insets;
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
			_tableView.contentInset = _baseInsets;
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
	
	[_tableView setContentOffset:offset animated:animated];
}

- (void)scrollToSection:(NSInteger)index animated:(BOOL)animated
{
	NSInteger rowCount = [self tableView:_tableView numberOfRowsInSection:index];
	if ( rowCount > 0 )
	{
		[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
	}
}

- (void)scrollToSection:(NSInteger)index row:(NSInteger)row animated:(BOOL)animated
{
	NSInteger rowCount = [self tableView:_tableView numberOfRowsInSection:index];
	if ( row < rowCount )
	{
		[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:index] atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
	}	
}

- (void)disableScrollsToTopPropertyOnAllSubviewsOf:(UIView *)view
{
    for ( UIView * subview in view.subviews )
	{
        if ( [subview isKindOfClass:[UIScrollView class]] )
		{
            ((UIScrollView *)subview).scrollsToTop = NO;
        }
		
        [self disableScrollsToTopPropertyOnAllSubviewsOf:subview];
    }
}

- (void)enableScrollsToTopPropertyOnAllSubviewsOf:(UIView *)view
{
    for ( UIView *subview in view.subviews )
	{
        if ( [subview isKindOfClass:[UIScrollView class]] )
		{
            ((UIScrollView *)subview).scrollsToTop = YES;
        }
		
        [self enableScrollsToTopPropertyOnAllSubviewsOf:subview];
    }
}

- (UITableViewCell *)visibleFirstCell
{
	NSArray * cells = [self.tableView visibleCells];
	if ( cells && [cells count] > 0 )
	{
		return (UITableViewCell *)[cells objectAtIndex:0];
	}
	else
	{
		return nil;
	}
}

- (UITableViewCell *)visibleLastCell
{
	NSArray * cells = [self.tableView visibleCells];
	if ( cells && [cells count] > 0 )
	{
		return (UITableViewCell *)[cells lastObject];
	}
	else
	{
		return nil;
	}	
}

- (NSRange)visibleRange
{
	NSArray * cells = [self.tableView visibleCells];
	if ( cells && [cells count] > 0 )
	{
		UITableViewCell * firstCell = [cells objectAtIndex:0];
		UITableViewCell * lastCell = [cells lastObject];
		
		NSRange range;
		
		if ( firstCell == lastCell )
		{
			range.location = [self.tableView indexPathForCell:firstCell].row;
			range.length = 1;
		}
		else
		{
			range.location = [self.tableView indexPathForCell:firstCell].row;
			range.length = [self.tableView indexPathForCell:lastCell].row - range.location + 1;
		}
		
//		if ( range.location > 0 )
//		{
//			range.location -= 1;
//		}
//
//		range.length += 1;

		return range;
	}
	else
	{
		return NSMakeRange( 0, 0 );
	}
}

- (NSArray *)visibleCells
{
	NSArray * cells = [self.tableView visibleCells];
	if ( cells && [cells count] > 0 )
	{
		return cells;
	}
	else
	{
		return [NSArray array];
	}
}

- (void)layoutViews:(BOOL)animated
{
	if ( animated )
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3f];	
	}
	
	CGRect bounds = self.view.bounds;
	
	if ( BEE_UITABLEBOARD_SEARCHBAR_STYLE_TOP == _searchBarStyle )
	{
		self.tableView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);			
	}
	else
	{
		if ( _searchBar.hidden )
		{
			self.tableView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);			
		}
		else
		{
			self.tableView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height - SEARCH_BAR_HEIGHT);
		}		
	}
	
	if ( animated )
	{
		[UIView commitAnimations];		
	}
	
	[self sendUISignal:BeeUIBoard.LAYOUT_VIEWS];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//	float normalizedSpeed = [self getScrollSpeed];
//
//	cell.layer.opacity = (normalizedSpeed > 0.0f ? (1.0f - normalizedSpeed) : 1.0f);
//
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3f];
//
//	cell.layer.transform = CATransform3DIdentity;
//	cell.layer.opacity = 1.0f;
//
//	[UIView commitAnimations];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return nil;
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 0;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//	[self sendUISignal:BeeUITableBoard.SCROLL_START];
//	[self sendUISignal:BeeUITableBoard.SCROLL_UPDATE];

	[self syncScrollPosition];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
//	[self sendUISignal:BeeUITableBoard.SCROLL_UPDATE];

	[self syncScrollPosition];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
//	CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;

	if ( scrollView.dragging )
	{
		if ( NO == _pullLoader.hidden && BEE_UIPULLLOADER_STATE_LOADING != _pullLoader.state )
		{
			if ( BEE_UIPULLLOADER_STATE_NORMAL == _pullLoader.state )
			{
				_baseInsets = _tableView.contentInset;
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

	_lastScrollPosition = _currentScrollPosition;
    _currentScrollPosition = [scrollView contentOffset];
	
//	[self sendUISignal:BeeUITableBoard.SCROLL_UPDATE];
	[self syncScrollPosition];
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
					_tableView.contentInset = insets;
					[UIView commitAnimations];
					
					[_pullLoader changeState:BEE_UIPULLLOADER_STATE_LOADING animated:YES];

					[self sendUISignal:BeeUITableBoard.PULL_REFRESH];
				}
			}
			else
			{
				if ( BEE_UIPULLLOADER_STATE_NORMAL != _pullLoader.state )
				{
					[UIView beginAnimations:nil context:NULL];
					[UIView setAnimationDuration:0.3f];
					_tableView.contentInset = _baseInsets;				
					[UIView commitAnimations];
					
					[_pullLoader changeState:BEE_UIPULLLOADER_STATE_NORMAL animated:YES];
				}
			}
		}
	}
	
//	[self sendUISignal:BeeUITableBoard.SCROLL_UPDATE];
	[self syncScrollPosition];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//	[self sendUISignal:BeeUITableBoard.SCROLL_STOP];
	[self syncScrollPosition];
}

- (void)syncScrollPosition
{
//	CGFloat offset = _tableView.contentOffset.y + _tableView.contentInset.top;
//	CC( @"offset = %f", offset );

//	if ( offset <= _baseInsets.top )
//	{
//		[self sendUISignal:BeeUITableBoard.SCROLL_REACH_TOP];
//		return;
//	}
//
//	CGFloat bottom = _tableView.contentSize.height + _baseInsets.top + _baseInsets.bottom;
//	if ( offset >= bottom )
//	{
//		[self sendUISignal:BeeUITableBoard.SCROLL_REACH_BOTTOM];
//		return;
//	}
}

#pragma mark -
#pragma mark SearchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{	
	[self.view bringSubviewToFront:_searchBar];
	
	[UIView beginAnimations:nil context:NULL];		
	[UIView setAnimationDuration:0.3f];
	
	CGRect bounds = self.view.bounds;
	
	_tableView.frame = CGRectMake(0, 0, bounds.size.width, 225);
	_searchBar.frame = CGRectMake(0, 225, bounds.size.width, 40);
	
	[UIView commitAnimations];
	
	_searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	[_searchBar setShowsCancelButton:YES animated:YES];
	
//	_searchBar.text = @"";
	_searching = YES;

	[self sendUISignal:BeeUITableBoard.SEARCH_ACTIVE];
	[self searchBar:nil	textDidChange:@""];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	[UIView beginAnimations:nil context:NULL];		
	[UIView setAnimationDuration:0.3f];

	CGRect bounds = self.view.bounds;

	_tableView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height - 40);
	_searchBar.frame = CGRectMake(0, bounds.size.height - 40.0f, bounds.size.width, 40);
	
	[self sendUISignal:BeeUITableBoard.SEARCH_DEACTIVE];
	[UIView commitAnimations];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self sendUISignal:BeeUITableBoard.SEARCH_COMMIT];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[_searchBar setShowsCancelButton:NO animated:YES];
	[_searchBar resignFirstResponder];

//	_searchBar.text = @"";
	_searching = NO;	

	[self sendUISignal:BeeUITableBoard.SEARCH_DEACTIVE];
	[self syncReloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	_searching = YES;

	[self sendUISignal:BeeUITableBoard.SEARCH_UPDATE];
	[self syncReloadData];
}

@end

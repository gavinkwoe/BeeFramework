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
//  Bee_UITableBoard.h
//

#import "Bee_UIGridCell.h"
#import "Bee_UIPullLoader.h"
#import "Bee_UIBoard.h"
#import "Bee_UISignal.h"

#pragma mark -

typedef enum
{
	BEE_UITABLEBOARD_SEARCHBAR_STYLE_BOTTOM,
	BEE_UITABLEBOARD_SEARCHBAR_STYLE_TOP
} BeeUITableBoardSearchBarStyle;

#pragma mark -

@interface BeeUITableViewCell : UITableViewCell
{
	BeeUIGridCell *	_innerCell;
}

@property (nonatomic, retain) BeeUIGridCell *	innerCell;

- (void)bindData:(NSObject *)data;
- (void)bindCell:(BeeUIGridCell *)cell;

@end

#pragma mark -

@interface BeeUITableBoard : BeeUIBoard<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
	BOOL							_reloading;
	BOOL							_updating;
	BOOL							_searching;
	UITableView *					_tableView;
	UISearchBar *					_searchBar;	
	BeeUIPullLoader *				_pullLoader;
	UIEdgeInsets					_baseInsets;
	BeeUITableBoardSearchBarStyle	_searchBarStyle;

	CGPoint							_lastScrollPosition;
	CGPoint							_currentScrollPosition;
}

@property (nonatomic, assign) BOOL							reloading;
@property (nonatomic, assign) BOOL							updating;
@property (nonatomic, assign) BOOL							searching;
@property (nonatomic, retain) UITableView *					tableView;
@property (nonatomic, retain) UISearchBar *					searchBar;
@property (nonatomic, retain) BeeUIPullLoader *				pullLoader;
@property (nonatomic, assign) BeeUITableBoardSearchBarStyle	searchBarStyle;

@property (nonatomic, assign) CGPoint						lastScrollPosition;
@property (nonatomic, assign) CGPoint						currentScrollPosition;

AS_SIGNAL( RELOADED )				// 数据重新加载
AS_SIGNAL( PULL_REFRESH )			// 下拉刷新
AS_SIGNAL( SEARCH_ACTIVE )			// 搜索开始
AS_SIGNAL( SEARCH_UPDATE )			// 搜索更新
AS_SIGNAL( SEARCH_DEACTIVE )		// 搜索结束
AS_SIGNAL( SEARCH_COMMIT )			// 搜索提交
//AS_SIGNAL( SCROLL_START )			// 滚动开始
//AS_SIGNAL( SCROLL_UPDATE )			// 滚动更新
//AS_SIGNAL( SCROLL_STOP )			// 滚动结束
//AS_SIGNAL( SCROLL_REACH_TOP )		// 触顶
//AS_SIGNAL( SCROLL_REACH_BOTTOM )	// 触底

- (BeeUITableViewCell *)dequeueWithContentClass:(Class)clazz;
- (BeeUITableViewCell *)dequeueWithContentCell:(BeeUIGridCell *)cell;
- (BeeUIGridCell *)contentForRowAtIndexPath:(NSIndexPath *)indexPath;

- (float)getScrollPercent;
- (float)getScrollSpeed;

- (void)setBaseInsets:(UIEdgeInsets)insets;
- (UIEdgeInsets)getBaseInsets;

- (void)reloadData;
- (void)syncReloadData;
- (void)asyncReloadData;
- (void)cancelReloadData;

- (void)showSearchBar:(BOOL)en animated:(BOOL)animated;
- (void)showPullLoader:(BOOL)en animated:(BOOL)animated;

- (void)setBaseInsets:(UIEdgeInsets)insets;
- (void)setPullLoading:(BOOL)en;

- (void)scrollToTop:(BOOL)animated;
- (void)scrollToSection:(NSInteger)index animated:(BOOL)animated;
- (void)scrollToSection:(NSInteger)index row:(NSInteger)row animated:(BOOL)animated;

- (UITableViewCell *)visibleFirstCell;
- (UITableViewCell *)visibleLastCell;
- (NSRange)visibleRange;
- (NSArray *)visibleCells;

@end

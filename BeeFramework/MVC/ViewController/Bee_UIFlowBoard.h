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
//  Bee_UIFlowBoard.h
//

#import "Bee_UISignal.h"
#import "Bee_UIGridCell.h"
#import "Bee_UIPullLoader.h"
#import "Bee_UIBoard.h"

#undef	FLOW_MAX_COLUMNS
#define FLOW_MAX_COLUMNS	(6)

#pragma mark -

@protocol BeeUIFlowBoardDataSource
- (NSInteger)numberOfColumns;
- (NSInteger)numberOfViews;
- (UIView *)viewForIndex:(NSInteger)index scale:(CGFloat)scale;
- (CGSize)sizeForIndex:(NSInteger)index;
@end

#pragma mark -

@interface BeeUIFlowBoard : BeeUIBoard<UIScrollViewDelegate, BeeUIFlowBoardDataSource>
{
	NSInteger			_visibleStart;
	NSInteger			_visibleEnd;
	
	NSInteger			_colCount;
	CGFloat				_colHeights[FLOW_MAX_COLUMNS];
	NSInteger			_total;
	NSMutableArray *	_items;
	UIScrollView *		_scrollView;

	BOOL				_reloading;
	BeeUIPullLoader *	_pullLoader;
	UIEdgeInsets		_baseInsets;

	BOOL				_reachTop;
	BOOL				_reachEnd;
	NSMutableArray *	_reuseQueue;
}

@property (nonatomic, assign) BOOL				reloading;
@property (nonatomic, retain) BeeUIPullLoader *	pullLoader;
@property (nonatomic, retain) UIScrollView *	scrollView;
@property (nonatomic, retain) NSMutableArray *	reuseQueue;

AS_SIGNAL( RELOADED )		// 数据重新加载
AS_SIGNAL( PULL_REFRESH )	// 刷新
AS_SIGNAL( REACH_TOP )		// 触顶
AS_SIGNAL( REACH_BOTTOM )	// 触底

- (UIView *)dequeueWithContentClass:(Class)clazz;

- (float)getScrollPercent;
- (float)getHeight;

- (void)setBaseInsets:(UIEdgeInsets)insets;
- (UIEdgeInsets)getBaseInsets;

- (void)reloadData;
- (void)syncReloadData;
- (void)asyncReloadData;
- (void)cancelReloadData;

- (void)showPullLoader:(BOOL)en animated:(BOOL)animated;
- (void)setBaseInsets:(UIEdgeInsets)insets;

- (void)setPullLoading:(BOOL)en;
- (void)scrollToTop:(BOOL)animated;

@end

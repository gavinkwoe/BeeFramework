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

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"
#import "Bee_UISignal.h"
#import "Bee_UICapability.h"

#pragma mark -

@class BeeUIScrollView;
@class BeeUIPullLoader;
@class BeeUIFootLoader;
@class BeeUIScrollItem;

typedef	void (^BeeUIScrollViewBlock)( void );
typedef	void (^BeeUIScrollViewBlockN)( id first, ... );
typedef	void (^BeeUIScrollViewBlockI)( BeeUIScrollItem * item );

#pragma mark -

typedef enum
{
	BeeUIScrollLayoutRuleVertical = 0,
	BeeUIScrollLayoutRuleHorizontal,
	
	// Backward compatible
	BeeUIScrollLayoutRule_Tile = BeeUIScrollLayoutRuleVertical,
	BeeUIScrollLayoutRule_Fall = BeeUIScrollLayoutRuleVertical,
	BeeUIScrollLayoutRule_Fill = BeeUIScrollLayoutRuleVertical,
	BeeUIScrollLayoutRule_Line = BeeUIScrollLayoutRuleHorizontal,
	BeeUIScrollLayoutRule_Inject = BeeUIScrollLayoutRuleVertical
} BeeUIScrollLayoutRule;

#pragma mark -

@interface BeeUIScrollItem : NSObject

@property (nonatomic, assign) BeeUIScrollLayoutRule	rule;
@property (nonatomic, assign) NSInteger				order;
@property (nonatomic, assign) NSInteger				section;
@property (nonatomic, assign) NSInteger				index;

@property (nonatomic, retain) NSString *			name;
@property (nonatomic, assign) UIView *				view;

@property (nonatomic, retain) id					data;
@property (nonatomic, retain) Class					clazz;
@property (nonatomic, assign) UIEdgeInsets			insets;
@property (nonatomic, assign) CGSize				size;

@property (nonatomic, retain) id					viewData;	// equals to 'data'
@property (nonatomic, retain) Class					viewClass;	// equals to 'clazz'
@property (nonatomic, assign) UIEdgeInsets			viewInsets;	// equals to 'insets'
@property (nonatomic, assign) CGSize				viewSize;	// equals to 'size'

@end

#pragma mark -

@interface BeeUIScrollSection : NSObject

@property (nonatomic, retain) Class					viewClass;
@property (nonatomic, assign) UIEdgeInsets			viewInsets;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, assign) BeeUIScrollLayoutRule	rule;

@end

#pragma mark -

@protocol BeeUIScrollViewDataSource
- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView;
- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView;
- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale;	// optional
- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index;
- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index;
- (NSInteger)scrollView:(BeeUIScrollView *)scrollView orderForIndex:(NSInteger)index;
- (BeeUIScrollLayoutRule)scrollView:(BeeUIScrollView *)scrollView ruleForIndex:(NSInteger)index;
@end

#pragma mark -

@interface BeeUIScrollView : UIScrollView<BeeUIScrollViewDataSource, UIScrollViewDelegate>

AS_INT( DIRECTION_HORIZONTAL )
AS_INT( DIRECTION_VERTICAL )

AS_SIGNAL( RELOADING )		// 数据正在加载
AS_SIGNAL( RELOADED )		// 数据重新加载
AS_SIGNAL( LAYOUTING )		// 正在布局
AS_SIGNAL( LAYOUTED )		// 已经布局
AS_SIGNAL( ANIMATING )		// 开始动画
AS_SIGNAL( ANIMATED )		// 结束动画
AS_SIGNAL( REACH_TOP )		// 触顶
AS_SIGNAL( REACH_BOTTOM )	// 触底

AS_SIGNAL( DID_DRAG )
AS_SIGNAL( DID_STOP )
AS_SIGNAL( DID_SCROLL )

AS_SIGNAL( HEADER_REFRESH )	// 下拉刷新
AS_SIGNAL( FOOTER_REFRESH )	// 上拉刷新

@property (nonatomic, assign) id					dataSource;
@property (nonatomic, assign) BOOL					horizontal;
@property (nonatomic, assign) BOOL					vertical;
@property (nonatomic, assign) BOOL					headerShown;
@property (nonatomic, assign) BOOL					footerShown;
@property (nonatomic, assign) CGFloat				animationDuration;

@property (nonatomic, readonly) NSInteger			visibleStart;
@property (nonatomic, readonly) NSInteger			visibleEnd;

@property (nonatomic, readonly) NSRange				visibleRange;
@property (nonatomic, readonly) NSUInteger			visiblePageIndex;

@property (nonatomic, assign) BOOL					autoReload;
@property (nonatomic, assign) BOOL					reloaded;
@property (nonatomic, readonly) BOOL				reloading;

@property (nonatomic, assign) BOOL					reuseEnable;
@property (nonatomic, retain) NSMutableArray *		reuseQueue;

@property (nonatomic, readonly) CGPoint				scrollSpeed;
@property (nonatomic, readonly) CGFloat				scrollPercent;

@property (nonatomic, readonly) NSInteger			pageCount;
@property (nonatomic, assign) NSInteger				pageIndex;
@property (nonatomic, assign) UIEdgeInsets			baseInsets;
@property (nonatomic, assign) UIEdgeInsets			extInsets;

@property (nonatomic, assign) CGFloat				lineSize;
@property (nonatomic, assign) NSInteger				lineCount;

@property (nonatomic, assign) NSInteger				total;
@property (nonatomic, retain) NSDictionary *		datas;
@property (nonatomic, readonly) NSArray *			items;
@property (nonatomic, readonly) BeeUIScrollItem *	firstItem;
@property (nonatomic, readonly) BeeUIScrollItem *	nextItem;
@property (nonatomic, readonly) BeeUIScrollItem *	lastItem;
@property (nonatomic, readonly) NSArray *			visibleItems;
@property (nonatomic, assign) BOOL					enableAllEvents;

@property (nonatomic, readonly) BeeUIPullLoader *	headerLoader;
@property (nonatomic, readonly) BeeUIFootLoader *	footerLoader;

@property (nonatomic, retain) Class					headerClass;
@property (nonatomic, assign) BOOL					headerLoading;

@property (nonatomic, retain) Class					footerClass;
@property (nonatomic, assign) BOOL					footerLoading;
@property (nonatomic, assign) BOOL					footerMore;

@property (nonatomic, copy) BeeUIScrollViewBlock	whenReloading;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenReloaded;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenLayouting;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenLayouted;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenAnimating;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenAnimated;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenScrolling;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenDragged;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenStop;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenReachTop;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenReachBottom;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenHeaderRefresh;
@property (nonatomic, copy) BeeUIScrollViewBlock	whenFooterRefresh;

- (id)dequeueWithContentClass:(Class)clazz;

- (void)scrollToFirstPage:(BOOL)animated;
- (void)scrollToLastPage:(BOOL)animated;
- (void)scrollToPrevPage:(BOOL)animated;
- (void)scrollToNextPage:(BOOL)animated;
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)scrollToView:(UIView *)view animated:(BOOL)animated;

- (void)recalcFrames;
- (void)recalcFramesAnimated:(BOOL)animated;

- (void)reloadData;
- (void)syncReloadData;
- (void)asyncReloadData;
- (void)cancelReloadData;

- (void)showHeaderLoader:(BOOL)flag animated:(BOOL)animated;
- (void)showFooterLoader:(BOOL)flag animated:(BOOL)animated;
- (void)setHeaderLoading:(BOOL)en;
- (void)setFooterLoading:(BOOL)en;
- (void)setFooterMore:(BOOL)en;

#pragma mark - section

- (void)appendSection:(BeeUIScrollSection *)section;
- (void)removeSection:(NSString *)name;
- (void)removeAllSections;

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id)key;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

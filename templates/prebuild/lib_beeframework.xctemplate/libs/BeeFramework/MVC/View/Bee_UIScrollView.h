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
//  Bee_UITabBar.h
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_UIPullLoader.h"

#pragma mark -

#undef	BEE_SCROLL_MAX_LINES
#define BEE_SCROLL_MAX_LINES	(128)

#pragma mark -

@class BeeUIScrollView;

@protocol BeeUIScrollViewDataSource
- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView;
- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView;
- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale;
- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index;
@end

@interface BeeUIScrollView : UIScrollView<BeeUIScrollViewDataSource, UIScrollViewDelegate>
{
	id							_dataSource;
	NSInteger					_direction;

	NSInteger					_visibleStart;
	NSInteger					_visibleEnd;

	NSInteger					_lineCount;
	CGFloat						_lineHeights[BEE_SCROLL_MAX_LINES];

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

AS_INT( DIRECTION_HORIZONTAL )
AS_INT( DIRECTION_VERTICAL )

@property (nonatomic, assign) id				dataSource;
@property (nonatomic, assign) BOOL				horizontal;
@property (nonatomic, assign) BOOL				vertical;

@property (nonatomic, readonly) NSInteger		visibleStart;
@property (nonatomic, readonly) NSInteger		visibleEnd;

@property (nonatomic, readonly) NSRange			visibleRange;
@property (nonatomic, readonly) NSUInteger		visiblePageIndex;

@property (nonatomic, assign) BOOL				reloaded;
@property (nonatomic, readonly) BOOL			reloading;
@property (nonatomic, retain) NSMutableArray *	reuseQueue;

@property (nonatomic, readonly) CGPoint				scrollSpeed;
@property (nonatomic, readonly) CGFloat			scrollPercent;
@property (nonatomic, readonly) CGFloat			height;

@property (nonatomic, readonly) BeeUIPullLoader *	headerLoader;
@property (nonatomic, readonly) BeeUIPullLoader *	footerLoader;

AS_SIGNAL( RELOADED )		// 数据重新加载
AS_SIGNAL( REACH_TOP )		// 触顶
AS_SIGNAL( REACH_BOTTOM )	// 触底

AS_SIGNAL( DID_DRAG )
AS_SIGNAL( DID_STOP )
AS_SIGNAL( DID_SCROLL )

AS_SIGNAL( HEADER_REFRESH )	// 下拉刷新
AS_SIGNAL( FOOTER_REFRESH )	// 上拉刷新

+ (BeeUIScrollView *)spawn;
+ (BeeUIScrollView *)spawn:(NSString *)tagString;

- (id)dequeueWithContentClass:(Class)clazz;

- (void)scrollToFirstPage:(BOOL)animated;
- (void)scrollToLastPage:(BOOL)animated;
- (void)scrollToPrevPage:(BOOL)animated;
- (void)scrollToNextPage:(BOOL)animated;

- (void)setBaseInsets:(UIEdgeInsets)insets;
- (UIEdgeInsets)getBaseInsets;

- (void)reloadData;
- (void)syncReloadData;
- (void)asyncReloadData;
- (void)cancelReloadData;

- (void)showHeaderLoader:(BOOL)flag animated:(BOOL)animated;
- (void)showFooterLoader:(BOOL)flag animated:(BOOL)animated;
- (void)setHeaderLoading:(BOOL)en;
- (void)setFooterLoading:(BOOL)en;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bee_UISignal.h"

#pragma mark -

typedef enum
{
	BEE_SCROLL_DIRECTION_HORIZONTAL = 0,
	BEE_SCROLL_DIRECTION_VERTICAL
} BeeScrollDirection;

#undef	BEE_SCROLL_MAX_LINES
#define BEE_SCROLL_MAX_LINES	(16)

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
	BeeScrollDirection			_direction;

	NSInteger					_visibleStart;
	NSInteger					_visibleEnd;

	NSInteger					_lineCount;
	CGFloat						_lineHeights[BEE_SCROLL_MAX_LINES];

	NSInteger					_total;
	NSMutableArray *			_items;

	BOOL						_reloading;
	UIEdgeInsets				_baseInsets;

	BOOL						_reachTop;
	BOOL						_reachEnd;
	NSMutableArray *			_reuseQueue;
}

@property (nonatomic, assign) id				dataSource;
@property (nonatomic, assign) BOOL				horizontal;
@property (nonatomic, assign) BOOL				vertical;

@property (nonatomic, readonly) NSInteger		visibleStart;
@property (nonatomic, readonly) NSInteger		visibleEnd;

@property (nonatomic, readonly) NSRange			visibleRange;
@property (nonatomic, readonly) NSUInteger		visiblePageIndex;

@property (nonatomic, readonly) BOOL			reloading;
@property (nonatomic, retain) NSMutableArray *	reuseQueue;

@property (nonatomic, readonly) CGFloat			scrollPercent;
@property (nonatomic, readonly) CGFloat			height;

AS_SIGNAL( RELOADED )		// 数据重新加载
AS_SIGNAL( REACH_TOP )		// 触顶
AS_SIGNAL( REACH_BOTTOM )	// 触底

+ (BeeUIScrollView *)spawn;

- (UIView *)dequeueWithContentClass:(Class)clazz;

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

@end

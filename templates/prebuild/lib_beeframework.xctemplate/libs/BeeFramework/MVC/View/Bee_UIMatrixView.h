//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2013 BEE creators
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
//  Bee_UIMatrixView.h
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"

#pragma mark -

@class BeeUIMatrixView;

@protocol BeeUIMatrixViewDataSource
- (CGSize)sizeOfViewForMatrixView:(BeeUIMatrixView *)matrixView;
- (NSInteger)numberOfRowsInMatrixView:(BeeUIMatrixView *)matrixView;
- (NSInteger)numberOfColsInMatrixView:(BeeUIMatrixView *)matrixView;
- (UIView *)matrixView:(BeeUIMatrixView *)matrixView row:(NSInteger)row col:(NSInteger)col;
@end

@interface BeeUIMatrixView : UIScrollView<BeeUIMatrixViewDataSource, UIScrollViewDelegate>
{
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

@property (nonatomic, assign) id					dataSource;

@property (nonatomic, readonly) NSInteger			rowTotal;
@property (nonatomic, readonly) NSInteger			colTotal;

@property (nonatomic, readonly) NSRange				rowVisibleRange;
@property (nonatomic, readonly) NSRange				colVisibleRange;

@property (nonatomic, readonly) NSMutableArray *	items;

@property (nonatomic, readonly) BOOL				reachTop;
@property (nonatomic, readonly) BOOL				reachBottom;
@property (nonatomic, readonly) BOOL				reachLeft;
@property (nonatomic, readonly) BOOL				reachRight;

@property (nonatomic, assign) BOOL					reloaded;
@property (nonatomic, readonly) BOOL				reloading;
@property (nonatomic, retain) NSMutableArray *		reuseQueue;

@property (nonatomic, readonly) CGPoint				scrollSpeed;

AS_SIGNAL( RELOADED )		// 数据重新加载
AS_SIGNAL( REACH_TOP )		// 触顶
AS_SIGNAL( REACH_BOTTOM )	// 触底
AS_SIGNAL( REACH_LEFT )		// 触左边
AS_SIGNAL( REACH_RIGHT )	// 触右边

AS_SIGNAL( DID_STOP )
AS_SIGNAL( DID_SCROLL )

+ (BeeUIMatrixView *)spawn;
+ (BeeUIMatrixView *)spawn:(NSString *)tagString;

- (id)dequeueWithContentClass:(Class)clazz;

- (void)setBaseInsets:(UIEdgeInsets)insets;
- (UIEdgeInsets)getBaseInsets;

- (void)reloadData;
- (void)syncReloadData;
- (void)asyncReloadData;
- (void)cancelReloadData;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

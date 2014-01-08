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

#pragma mark -

@class BeeUIBoard;
@class BeeUIStack;
@class BeeUIStackGroup;

typedef BeeUIBoard *	(^BeeUIBoardBlock)( void );
typedef BeeUIBoard *	(^BeeUIBoardBlockN)( id first, ... );

#pragma mark -

@interface BeeUIBoard : UIViewController<UIGestureRecognizerDelegate>

AS_SIGNAL( CREATE_VIEWS )			// 创建视图
AS_SIGNAL( DELETE_VIEWS )			// 释放视图
AS_SIGNAL( LAYOUT_VIEWS )			// 布局视图
AS_SIGNAL( LOAD_DATAS )				// 加载数据
AS_SIGNAL( FREE_DATAS )				// 释放数据
AS_SIGNAL( WILL_APPEAR )			// 将要显示
AS_SIGNAL( DID_APPEAR )				// 已经显示
AS_SIGNAL( WILL_DISAPPEAR )			// 将要隐藏
AS_SIGNAL( DID_DISAPPEAR )			// 已经隐藏

AS_SIGNAL( ORIENTATION_WILL_CHANGE )	// 方向变化
AS_SIGNAL( ORIENTATION_DID_CHANGED )	// 方向变化

AS_INT( STATE_DEACTIVATED )			// 隐藏
AS_INT( STATE_DEACTIVATING )		// 将要隐藏
AS_INT( STATE_ACTIVATING )			// 将要显示
AS_INT( STATE_ACTIVATED )			// 显示

@property (nonatomic, assign) BeeUIBoard *					parentBoard;
@property (nonatomic, retain) NSString *					name;

@property (nonatomic, assign) BOOL							firstEnter;
@property (nonatomic, assign) BOOL							presenting;
@property (nonatomic, assign) BOOL							viewBuilt;
@property (nonatomic, assign) BOOL							dataLoaded;
@property (nonatomic, assign) NSInteger						state;

@property (nonatomic, readonly) BOOL						deactivated;
@property (nonatomic, readonly) BOOL						deactivating;
@property (nonatomic, readonly) BOOL						activating;
@property (nonatomic, readonly) BOOL						activated;

@property (nonatomic, retain) NSDate *						createDate;
@property (nonatomic, assign) NSTimeInterval				lastSleep;
@property (nonatomic, assign) NSTimeInterval				lastWeekup;
@property (nonatomic, readonly) NSTimeInterval				sleepDuration;
@property (nonatomic, readonly) NSTimeInterval				weekupDuration;

@property (nonatomic, assign) BOOL							allowedPortrait;
@property (nonatomic, assign) BOOL							allowedLandscape;
@property (nonatomic, assign) BOOL							allowedSwipeToBack;
@property (nonatomic, assign) BOOL							disableLayout;
@property (nonatomic, readonly) BeeUIBoardBlock				RELAYOUT;

#if __BEE_DEVELOPMENT__
@property (nonatomic, readonly) NSUInteger					createSeq;
@property (nonatomic, readonly) NSUInteger					signalSeq;
@property (nonatomic, readonly) NSMutableArray *			signals;
@property (nonatomic, readonly) NSMutableArray *			callstack;
#endif	// #if __BEE_DEVELOPMENT__

+ (NSArray *)allBoards;

+ (id)board;
+ (id)boardWithNibName:(NSString *)nibNameOrNil;

// life-cycle

- (void)__enterBackground;
- (void)__enterForeground;

@end

#pragma mark -

#undef	ON_CREATE_VIEWS
#define ON_CREATE_VIEWS( signal )				ON_SIGNAL3( BeeUIBoard, CREATE_VIEWS, signal )

#undef	ON_DELETE_VIEWS
#define ON_DELETE_VIEWS( signal )				ON_SIGNAL3( BeeUIBoard, DELETE_VIEWS, signal )

#undef	ON_LAYOUT_VIEWS
#define ON_LAYOUT_VIEWS( signal )				ON_SIGNAL3( BeeUIBoard, LAYOUT_VIEWS, signal )

#undef	ON_LOAD_DATAS
#define ON_LOAD_DATAS( signal )					ON_SIGNAL3( BeeUIBoard, LOAD_DATAS, signal )

#undef	ON_FREE_DATAS
#define ON_FREE_DATAS( signal )					ON_SIGNAL3( BeeUIBoard, FREE_DATAS, signal )

#undef	ON_WILL_APPEAR
#define ON_WILL_APPEAR( signal )				ON_SIGNAL3( BeeUIBoard, WILL_APPEAR, signal )

#undef	ON_DID_APPEAR
#define ON_DID_APPEAR( signal )					ON_SIGNAL3( BeeUIBoard, DID_APPEAR, signal )

#undef	ON_WILL_DISAPPEAR
#define ON_WILL_DISAPPEAR( signal )				ON_SIGNAL3( BeeUIBoard, WILL_DISAPPEAR, signal )

#undef	ON_DID_DISAPPEAR
#define ON_DID_DISAPPEAR( signal )				ON_SIGNAL3( BeeUIBoard, DID_DISAPPEAR, signal )

#undef	ON_ORIENTATION_WILL_CHANGE
#define ON_ORIENTATION_WILL_CHANGE( signal )	ON_SIGNAL3( BeeUIBoard, ORIENTATION_WILL_CHANGE, signal )

#undef	ON_ORIENTATION_DID_CHANGED
#define ON_ORIENTATION_DID_CHANGED( signal )	ON_SIGNAL3( BeeUIBoard, ORIENTATION_DID_CHANGED, signal )

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

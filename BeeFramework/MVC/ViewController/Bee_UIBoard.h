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
//  Bee_UIBoard.h
//

#import "Bee_UISignal.h"

#pragma mark -

@class BeeUIBoard;
@class BeeUIStack;
@class BeeUIStackGroup;
@class BeeUIMetrics;

#pragma mark -

typedef enum
{
	BEE_UIBOARD_STATE_DEACTIVATED = 0,
	BEE_UIBOARD_STATE_DEACTIVATING,
	BEE_UIBOARD_STATE_ACTIVATING,
	BEE_UIBOARD_STATE_ACTIVATED
} BeeUIBoardState;

typedef enum
{
	BEE_UIBOARD_BARBUTTON_LEFT = 0,
	BEE_UIBOARD_BARBUTTON_RIGHT
} BeeUIBoardBarButtonPosition;

typedef enum
{
	BEE_UIBOARD_ANIMATION_NONE = 0,
	BEE_UIBOARD_ANIMATION_ALPHA,
	BEE_UIBOARD_ANIMATION_BOUNCE
} BeeUIBoardAnimationType;

#pragma mark -

@interface UIView(BeeView)
- (BeeUIBoard *)board;
- (BeeUIStack *)stack;
- (UIViewController *)viewController;
- (UINavigationController *)navigationController;
- (UIView *)subview:(NSString *)name;
@end

#pragma mark -

@interface UIViewController(BeeExtension)
- (CGRect)viewFrame;
- (CGRect)viewBound;
- (CGSize)viewSize;
- (CGRect)screenBound;
@end

#pragma mark -

typedef void (^BeeUIBoardBlock)( BeeUIBoard * board );

@interface BeeUIBoard : UIViewController<UIGestureRecognizerDelegate>
{
	NSTimeInterval				_lastSleep;
	NSTimeInterval				_lastWeekup;
	BeeUIBoard *				_parentBoard;
	
	BOOL						_firstEnter;
	BOOL						_presenting;
	BOOL						_viewBuilt;
	BOOL						_dataLoaded;
	BeeUIBoardState				_state;
	
	NSDate *					_createDate;

	UIButton *					_modalMaskView;
	UIView *					_modalContentView;
	BeeUIBoard *				_modalBoard;

	BOOL						_panEnabled;
	UIPanGestureRecognizer *	_panGesture;
	CGPoint						_panOffset;

#ifdef __BEE_DEVELOPMENT__
	NSUInteger					_signalSeq;
	NSMutableArray *			_signals;
	NSMutableArray *			_callstack;
#endif	// #ifdef __BEE_DEVELOPMENT__
}

@property (nonatomic, assign) NSTimeInterval			lastSleep;
@property (nonatomic, assign) NSTimeInterval			lastWeekup;
@property (nonatomic, assign) BeeUIBoard *				parentBoard;

@property (nonatomic, assign) BOOL						firstEnter;
@property (nonatomic, assign) BOOL						presenting;
@property (nonatomic, assign) BOOL						viewBuilt;
@property (nonatomic, assign) BOOL						dataLoaded;
@property (nonatomic, assign) BeeUIBoardState			state;

@property (nonatomic, retain) NSDate *					createDate;

@property (nonatomic, retain) UIButton *				modalMaskView;
@property (nonatomic, retain) UIView *					modalContentView;
@property (nonatomic, retain) BeeUIBoard *				modalBoard;

@property (nonatomic, assign) BOOL						panEnabled;
@property (nonatomic, retain) UIPanGestureRecognizer *	panGesture;
@property (nonatomic, assign) CGPoint					panOffset;


@property (nonatomic, readonly) BOOL					deactivated;
@property (nonatomic, readonly) BOOL					deactivating;
@property (nonatomic, readonly) BOOL					activating;
@property (nonatomic, readonly) BOOL					activated;

@property (nonatomic, assign) NSString *				titleString;
@property (nonatomic, assign) UIView *					titleView;

#ifdef __BEE_DEVELOPMENT__
@property (nonatomic, readonly) NSUInteger				signalSeq;
@property (nonatomic, readonly) NSMutableArray *		signals;
@property (nonatomic, readonly) NSMutableArray *		callstack;
#endif	// #ifdef __BEE_DEVELOPMENT__

AS_SIGNAL( CREATE_VIEWS )			// 创建视图
AS_SIGNAL( DELETE_VIEWS )			// 释放视图
AS_SIGNAL( LAYOUT_VIEWS )			// 布局视图
AS_SIGNAL( LOAD_DATAS )				// 加载数据
AS_SIGNAL( FREE_DATAS )				// 释放数据
AS_SIGNAL( WILL_APPEAR )			// 将要显示
AS_SIGNAL( DID_APPEAR )				// 已经显示
AS_SIGNAL( WILL_DISAPPEAR )			// 将要隐藏
AS_SIGNAL( DID_DISAPPEAR )			// 已经隐藏

AS_SIGNAL( MODALVIEW_WILL_SHOW )	// ModalView将要显示
AS_SIGNAL( MODALVIEW_DID_SHOWN )	// ModalView已经显示
AS_SIGNAL( MODALVIEW_WILL_HIDE )	// ModalView将要隐藏
AS_SIGNAL( MODALVIEW_DID_HIDDEN )	// ModalView已经隐藏

AS_SIGNAL( BACK_BUTTON_TOUCHED )	// NavigationBar左按钮被点击
AS_SIGNAL( DONE_BUTTON_TOUCHED )	// NavigationBar右按钮被点击

AS_SIGNAL( PAN_START )				// 左右滑动手势开始
AS_SIGNAL( PAN_STOP )				// 左右滑动手势结束
AS_SIGNAL( PAN_CHANGED )			// 左右滑动手势位置变化
AS_SIGNAL( PAN_CANCELLED )			// 左右滑动手势取消

+ (NSArray *)allBoards;

+ (BeeUIBoard *)board;

- (void)load;
- (void)unload;

- (NSTimeInterval)sleepDuration;
- (NSTimeInterval)weekupDuration;

- (BeeUIStack *)stack;
- (BeeUIBoard *)prevBoard;	// 沿Stack路径找前一个
- (BeeUIBoard *)nextBoard;	// 沿Stack路径找后一个

- (void)showNavigationBarAnimated:(BOOL)animated;
- (void)hideNavigationBarAnimated:(BOOL)animated;

- (void)presentModalView:(UIView *)view animationType:(BeeUIBoardAnimationType)type;
- (void)presentModalViewInBlack:(UIView *)view animationType:(BeeUIBoardAnimationType)type;
- (void)presentModalViewInBlack:(UIView *)view animationType:(BeeUIBoardAnimationType)type alpha:(CGFloat)alpha;
- (void)dismissModalViewAnimated:(BOOL)animated;

- (void)presentModalBoard:(BeeUIBoard *)board animated:(BOOL)animated;
- (void)dismissModalBoardAnimated:(BOOL)animated;

- (void)showBarButton:(BeeUIBoardBarButtonPosition)position title:(NSString *)name;
- (void)showBarButton:(BeeUIBoardBarButtonPosition)position image:(UIImage *)image;
- (void)showBarButton:(BeeUIBoardBarButtonPosition)position system:(UIBarButtonSystemItem)index;
- (void)showBarButton:(BeeUIBoardBarButtonPosition)position custom:(UIView *)view;
- (void)hideBarButton:(BeeUIBoardBarButtonPosition)position;

@end

#pragma mark -

@interface BeeUIBoard(InternalUseOnly)
- (void)__enterBackground;
- (void)__enterForeground;
@end

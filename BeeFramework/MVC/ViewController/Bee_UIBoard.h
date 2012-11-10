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
#import "Bee_UILabel.h"
#import "Bee_UIStack.h"

#import "NSObject+BeeProperty.h"

#pragma mark -

@class BeeUIBoard;
@class BeeUIStack;
@class BeeUIStackGroup;
@class BeeUIMetrics;

#pragma mark -

@interface UIView(BeeUIBoard)
- (BeeUIBoard *)board;
- (UIViewController *)viewController;
@end

#pragma mark -

@interface UIViewController(BeeExtension)
- (CGRect)viewFrame;
- (CGRect)viewBound;
- (CGSize)viewSize;
- (CGRect)screenBound;
@end

#pragma mark -

@interface BeeUIBoard : UIViewController<UIGestureRecognizerDelegate, UIPopoverControllerDelegate>
{
	UIPopoverController *		_popover;
	NSInteger					_stackAnimationType;

	NSTimeInterval				_lastSleep;
	NSTimeInterval				_lastWeekup;
	BeeUIBoard *				_parentBoard;
		
	BOOL						_firstEnter;
	BOOL						_presenting;
	BOOL						_viewBuilt;
	BOOL						_dataLoaded;
	NSInteger					_state;

	NSDate *					_createDate;

	UIButton *					_modalMaskView;
	UIView *					_modalContentView;
	BeeUIBoard *				_modalBoard;
	NSInteger					_modalAnimationType;

	BOOL						_panEnabled;
	UIPanGestureRecognizer *	_panGesture;
	CGPoint						_panOffset;

	BOOL						_swipeEnabled;
	UISwipeGestureRecognizer *	_swipeGesture;

	UIInterfaceOrientation		_allowedOrientation;

#ifdef __BEE_DEVELOPMENT__
	NSUInteger					_signalSeq;
	NSMutableArray *			_signals;
	NSMutableArray *			_callstack;
#endif	// #ifdef __BEE_DEVELOPMENT__
}

@property (nonatomic, assign) UIPopoverController *			popover;
@property (nonatomic, assign) NSInteger						stackAnimationType;

@property (nonatomic, assign) NSTimeInterval				lastSleep;
@property (nonatomic, assign) NSTimeInterval				lastWeekup;
@property (nonatomic, assign) BeeUIBoard *					parentBoard;

@property (nonatomic, assign) BOOL							firstEnter;
@property (nonatomic, assign) BOOL							presenting;
@property (nonatomic, assign) BOOL							viewBuilt;
@property (nonatomic, assign) BOOL							dataLoaded;
@property (nonatomic, assign) NSInteger						state;

@property (nonatomic, retain) NSDate *						createDate;

@property (nonatomic, retain) UIButton *					modalMaskView;
@property (nonatomic, retain) UIView *						modalContentView;
@property (nonatomic, retain) BeeUIBoard *					modalBoard;

@property (nonatomic, assign) BOOL							panEnabled;
@property (nonatomic, retain) UIPanGestureRecognizer *		panGesture;
@property (nonatomic, assign) CGPoint						panOffset;

@property (nonatomic, assign) BOOL								swipeEnabled;
@property (nonatomic, assign) UISwipeGestureRecognizerDirection	swipeDirection;
@property (nonatomic, retain) UISwipeGestureRecognizer *		swipeGesture;

@property (nonatomic, readonly) BOOL						deactivated;
@property (nonatomic, readonly) BOOL						deactivating;
@property (nonatomic, readonly) BOOL						activating;
@property (nonatomic, readonly) BOOL						activated;

@property (nonatomic, readonly) NSTimeInterval				sleepDuration;
@property (nonatomic, readonly) NSTimeInterval				weekDuration;
@property (nonatomic, readonly) BeeUIStack *				stack;
@property (nonatomic, readonly) BeeUIBoard *				previousBoard;
@property (nonatomic, readonly) BeeUIBoard *				nextBoard;

@property (nonatomic, assign) NSString *					titleString;
@property (nonatomic, assign) UIView *						titleView;

@property (nonatomic, assign) UIInterfaceOrientation		allowedOrientation;

#ifdef __BEE_DEVELOPMENT__
@property (nonatomic, readonly) NSUInteger					signalSeq;
@property (nonatomic, readonly) NSMutableArray *			signals;
@property (nonatomic, readonly) NSMutableArray *			callstack;
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
AS_SIGNAL( ORIENTATION_CHANGED )	// 方向变化

AS_SIGNAL( MODALVIEW_WILL_SHOW )	// ModalView将要显示
AS_SIGNAL( MODALVIEW_DID_SHOWN )	// ModalView已经显示
AS_SIGNAL( MODALVIEW_WILL_HIDE )	// ModalView将要隐藏
AS_SIGNAL( MODALVIEW_DID_HIDDEN )	// ModalView已经隐藏

AS_SIGNAL( POPOVER_WILL_PRESENT )	// Popover将要显示
AS_SIGNAL( POPOVER_DID_PRESENT )	// Popover已经显示
AS_SIGNAL( POPOVER_WILL_DISMISS )	// Popover将要隐藏
AS_SIGNAL( POPOVER_DID_DISMISSED )	// Popover已经隐藏

AS_SIGNAL( BACK_BUTTON_TOUCHED )	// NavigationBar左按钮被点击
AS_SIGNAL( DONE_BUTTON_TOUCHED )	// NavigationBar右按钮被点击

AS_SIGNAL( PAN_START )				// 手势：左右滑动开始
AS_SIGNAL( PAN_STOP )				// 手势：左右滑动结束
AS_SIGNAL( PAN_CHANGED )			// 手势：左右滑动位置变化
AS_SIGNAL( PAN_CANCELLED )			// 手势：左右滑动取消

AS_SIGNAL( SWIPE_UP )				// 手势：瞬间向上滑动
AS_SIGNAL( SWIPE_DOWN )				// 手势：瞬间向下滑动
AS_SIGNAL( SWIPE_LEFT )				// 手势：瞬间向左滑动
AS_SIGNAL( SWIPE_RIGHT )			// 手势：瞬间向右滑动


AS_INT( STATE_DEACTIVATED )		// 隐藏
AS_INT( STATE_DEACTIVATING )	// 将要隐藏
AS_INT( STATE_ACTIVATING )		// 将要显示
AS_INT( STATE_ACTIVATED )		// 显示

AS_INT( BARBUTTON_LEFT )		// 左按钮
AS_INT( BARBUTTON_RIGHT )		// 右按钮

AS_INT( ANIMATION_TYPE_ALPHA )
AS_INT( ANIMATION_TYPE_BOUNCE )
AS_INT( ANIMATION_TYPE_DEFAULT )


+ (NSArray *)allBoards;
+ (BeeUIBoard *)board;

- (void)load;
- (void)unload;

- (void)showNavigationBarAnimated:(BOOL)animated;
- (void)hideNavigationBarAnimated:(BOOL)animated;

- (void)presentModalView:(UIView *)view animated:(BOOL)animated;
- (void)presentModalView:(UIView *)view animated:(BOOL)animated animationType:(NSInteger)type;
- (void)dismissModalViewAnimated:(BOOL)animated;

- (void)presentPopoverForView:(UIView *)view
				  contentSize:(CGSize)size
					direction:(UIPopoverArrowDirection)direction
					 animated:(BOOL)animated;
- (void)dismissPopoverAnimated:(BOOL)animated;

- (void)presentModalBoard:(BeeUIBoard *)board animated:(BOOL)animated;
- (void)dismissModalBoardAnimated:(BOOL)animated;

- (void)showBarButton:(NSInteger)position title:(NSString *)name;
- (void)showBarButton:(NSInteger)position image:(UIImage *)image;
- (void)showBarButton:(NSInteger)position system:(UIBarButtonSystemItem)index;
- (void)showBarButton:(NSInteger)position custom:(UIView *)view;
- (void)hideBarButton:(NSInteger)position;

@end

#pragma mark -

@interface BeeUIBoard(InternalUseOnly)
- (void)__enterBackground;
- (void)__enterForeground;
@end

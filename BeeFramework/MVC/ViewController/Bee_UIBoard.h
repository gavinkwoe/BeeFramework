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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_UILabel.h"
#import "Bee_UIStack.h"

#import "NSObject+BeeProperty.h"

#pragma mark -

@class BeeUIBoard;
@class BeeUIStack;
@class BeeUIStackGroup;

#pragma mark -

@interface UIView(BeeUIBoard)
- (BeeUIBoard *)board;
@end

typedef void (^BeeUIBoardBlock)( void );

#pragma mark -

@interface BeeUIBoard : UIViewController<UIGestureRecognizerDelegate, UIPopoverControllerDelegate>
{
	NSTimeInterval				_lastSleep;
	NSTimeInterval				_lastWeekup;
	BeeUIBoard *				_parentBoard;
		
	BOOL						_firstEnter;
	BOOL						_presenting;
	BOOL						_viewBuilt;
	BOOL						_dataLoaded;
	NSInteger					_state;
	NSDate *					_createDate;

	BeeUIBoard *				_modalBoard;
	UIButton *					_modalMaskView;
	UIView *					_modalContentView;
	NSInteger					_modalAnimationType;
	NSInteger					_stackAnimationType;
	UIPopoverController *		_containedPopover;

	BOOL						_allowedPortrait;
	BOOL						_allowedLandscape;

	BOOL						_zoomed;
	CGRect						_zoomRect;
	BeeUIBoardBlock				_animationBlock;
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	NSUInteger					_createSeq;
	NSUInteger					_signalSeq;
	NSMutableArray *			_signals;
	NSMutableArray *			_callstack;
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
}

@property (nonatomic, assign) NSTimeInterval				lastSleep;
@property (nonatomic, assign) NSTimeInterval				lastWeekup;
@property (nonatomic, assign) BeeUIBoard *					parentBoard;

@property (nonatomic, assign) BOOL							firstEnter;
@property (nonatomic, assign) BOOL							presenting;
@property (nonatomic, assign) BOOL							viewBuilt;
@property (nonatomic, assign) BOOL							dataLoaded;
@property (nonatomic, assign) NSInteger						state;
@property (nonatomic, retain) NSDate *						createDate;

@property (nonatomic, assign) UIPopoverController *			containedPopover;
@property (nonatomic, assign) NSInteger						stackAnimationType;

@property (nonatomic, retain) BeeUIBoard *					modalBoard;
@property (nonatomic, retain) UIButton *					modalMaskView;
@property (nonatomic, retain) UIView *						modalContentView;
@property (nonatomic, assign) NSInteger						modalAnimationType;

@property (nonatomic, readonly) BOOL						deactivated;
@property (nonatomic, readonly) BOOL						deactivating;
@property (nonatomic, readonly) BOOL						activating;
@property (nonatomic, readonly) BOOL						activated;

@property (nonatomic, readonly) NSTimeInterval				sleepDuration;
@property (nonatomic, readonly) NSTimeInterval				weekDuration;
@property (nonatomic, readonly) BeeUIStack *				stack;
@property (nonatomic, readonly) BeeUIBoard *				previousBoard;
@property (nonatomic, readonly) BeeUIBoard *				nextBoard;

@property (nonatomic, assign) BOOL							allowedPortrait;
@property (nonatomic, assign) BOOL							allowedLandscape;

@property (nonatomic, assign) BOOL							zoomed;
@property (nonatomic, assign) CGRect						zoomRect;
@property (nonatomic, copy) BeeUIBoardBlock					animationBlock;

#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
@property (nonatomic, readonly) NSUInteger					createSeq;
@property (nonatomic, readonly) NSUInteger					signalSeq;
@property (nonatomic, readonly) NSMutableArray *			signals;
@property (nonatomic, readonly) NSMutableArray *			callstack;
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__

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

AS_SIGNAL( ANIMATION_BEGIN )		// 动画开始
AS_SIGNAL( ANIMATION_FINISH )		// 动画结束

AS_SIGNAL( MODALVIEW_WILL_SHOW )	// ModalView将要显示
AS_SIGNAL( MODALVIEW_DID_SHOWN )	// ModalView已经显示
AS_SIGNAL( MODALVIEW_WILL_HIDE )	// ModalView将要隐藏
AS_SIGNAL( MODALVIEW_DID_HIDDEN )	// ModalView已经隐藏

AS_SIGNAL( POPOVER_WILL_PRESENT )	// Popover将要显示
AS_SIGNAL( POPOVER_DID_PRESENT )	// Popover已经显示
AS_SIGNAL( POPOVER_WILL_DISMISS )	// Popover将要隐藏
AS_SIGNAL( POPOVER_DID_DISMISSED )	// Popover已经隐藏

AS_INT( STATE_DEACTIVATED )			// 隐藏
AS_INT( STATE_DEACTIVATING )		// 将要隐藏
AS_INT( STATE_ACTIVATING )			// 将要显示
AS_INT( STATE_ACTIVATED )			// 显示

AS_INT( ANIMATION_TYPE_ALPHA )		// 渐隐动画
AS_INT( ANIMATION_TYPE_BOUNCE )		// 跳动动画
AS_INT( ANIMATION_TYPE_DEFAULT )	// 默认动画

AS_INT( BARBUTTON_LEFT )			// 左按钮
AS_INT( BARBUTTON_RIGHT )			// 右按钮

+ (NSArray *)allBoards;
+ (BeeUIBoard *)board;
+ (BeeUIBoard *)boardWithNibName:(NSString *)nibNameOrNil;

- (void)load;
- (void)unload;

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

- (void)beginAnimation;
- (void)commitAnimation:(BeeUIBoardBlock)block;

- (void)changeAnimationCurve:(UIViewAnimationCurve)curve;
- (void)changeAnimationDuration:(NSTimeInterval)duration;
- (void)changeAnimationDelay:(NSTimeInterval)duration;

- (void)transformZoom:(CGRect)rect;
- (void)transformReset;

@end

#pragma mark -

@interface BeeUIBoard(InternalUseOnly)
- (void)__enterBackground;
- (void)__enterForeground;
@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

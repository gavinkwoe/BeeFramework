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

#import <Foundation/Foundation.h>
#import "Bee_UISignal.h"
#import "Bee_Singleton.h"

#pragma mark -

@class BeeUITipsView;

@interface NSObject(BeeUITipsView)

- (BeeUITipsView *)presentingTips;

- (BeeUITipsView *)presentMessageTips:(NSString *)message;
- (BeeUITipsView *)presentSuccessTips:(NSString *)message;
- (BeeUITipsView *)presentFailureTips:(NSString *)message;
- (BeeUITipsView *)presentLoadingTips:(NSString *)message;
- (BeeUITipsView *)presentProgressTips:(NSString *)message;

- (void)dismissTips;

@end

#pragma mark -

@interface BeeUITipsView : UIView

AS_SIGNAL( WILL_APPEAR );		// 将要显示
AS_SIGNAL( DID_APPEAR );		// 已经显示
AS_SIGNAL( WILL_DISAPPEAR );	// 将要隐藏
AS_SIGNAL( DID_DISAPPEAR );		// 已经隐藏

@property (nonatomic, assign) NSTimeInterval			timerSeconds;
@property (nonatomic, assign) BOOL						useMask;
@property (nonatomic, assign) BOOL						useScaling;
@property (nonatomic, assign) BOOL						useBounces;
@property (nonatomic, assign) BOOL						interrupt;
@property (nonatomic, assign) BOOL						timeLimit;
@property (nonatomic, assign) BOOL						exclusive;
@property (nonatomic, assign) BOOL						fullScreen;

- (void)present;
- (void)presentInView:(UIView *)view;
- (void)dismiss;

@end

#pragma mark -

@interface BeeUIMessageTipsView : BeeUITipsView
@property (nonatomic, retain) UIImageView *				bubbleView;
@property (nonatomic, retain) UIImageView *				iconView;
@property (nonatomic, retain) UILabel *					labelView;
@end

#pragma mark -

@interface BeeUILoadingTipsView : BeeUITipsView
@property (nonatomic, retain) UIImageView *				bubbleView;
@property (nonatomic, retain) UIActivityIndicatorView *	indicator;
@property (nonatomic, retain) UILabel *					labelView;
@end

#pragma mark -

@interface BeeUIProgressTipsView : BeeUITipsView
@property (nonatomic, retain) UIImageView *				bubbleView;
@property (nonatomic, retain) UIProgressView *			progressView;
@property (nonatomic, retain) UIActivityIndicatorView *	indicator;
@property (nonatomic, retain) UILabel *					labelView;
@property (nonatomic, assign) CGFloat					percent;
@end

#pragma mark -

@interface BeeUITipsCenter : NSObject

@property (nonatomic, assign) UIView *					defaultContainerView;
@property (nonatomic, retain) UIView *					maskView;
@property (nonatomic, retain) BeeUITipsView *			tipsAppear;
@property (nonatomic, retain) BeeUITipsView *			tipsDisappear;

@property (nonatomic, retain) UIImage *					bubble;
@property (nonatomic, retain) UIImage *					messageIcon;
@property (nonatomic, retain) UIImage *					successIcon;
@property (nonatomic, retain) UIImage *					failureIcon;

AS_SINGLETON( BeeUITipsCenter )

+ (void)setDefaultContainerView:(UIView *)view;
+ (void)setDefaultMessageIcon:(UIImage *)image;
+ (void)setDefaultSuccessIcon:(UIImage *)image;
+ (void)setDefaultFailureIcon:(UIImage *)image;
+ (void)setDefaultBubble:(UIImage *)image;

- (void)dismissTips;
- (void)dismissTipsByOwner:(UIView *)parentView;

- (BeeUITipsView *)presentMessageTips:(NSString *)message inView:(UIView *)view;
- (BeeUITipsView *)presentSuccessTips:(NSString *)message inView:(UIView *)view;
- (BeeUITipsView *)presentFailureTips:(NSString *)message inView:(UIView *)view;
- (BeeUITipsView *)presentLoadingTips:(NSString *)message inView:(UIView *)view;
- (BeeUITipsView *)presentProgressTips:(NSString *)message inView:(UIView *)view;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

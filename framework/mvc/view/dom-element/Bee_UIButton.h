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

@class BeeUIButton;

@interface BeeUIButtonState : NSObject

@property (nonatomic, assign) BeeUIButton *		button;
@property (nonatomic, assign) UIControlState	state;
@property (nonatomic, assign) NSString *		title;
@property (nonatomic, assign) UIColor *			titleColor;
@property (nonatomic, assign) UIColor *			titleShadowColor;
@property (nonatomic, assign) UIImage *			image;
@property (nonatomic, assign) UIImage *			backgroundImage;

@end

#pragma mark -

@interface BeeUIButton : UIButton

AS_SIGNAL( TOUCH_DOWN )			// 按下
AS_SIGNAL( TOUCH_DOWN_LONG )	// 长按
AS_SIGNAL( TOUCH_DOWN_REPEAT )	// 长按
AS_SIGNAL( TOUCH_UP_INSIDE )	// 抬起（击中）
AS_SIGNAL( TOUCH_UP_OUTSIDE )	// 抬起（未击中）
AS_SIGNAL( TOUCH_UP_CANCEL )	// 撤销

AS_SIGNAL( DRAG_INSIDE )		// 拖出
AS_SIGNAL( DRAG_OUTSIDE )		// 拖入
AS_SIGNAL( DRAG_ENTER )			// 进入
AS_SIGNAL( DRAG_EXIT )			// 退出

@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) UIColor *				titleColor;
@property (nonatomic, retain) UIColor *				titleShadowColor;
@property (nonatomic, retain) UIFont *				titleFont;
@property (nonatomic, assign) UIEdgeInsets			titleInsets;
@property (nonatomic, assign) UITextAlignment		titleTextAlignment;
@property (nonatomic, retain) UIImage *				image;
@property (nonatomic, retain) UIImage *				backgroundImage;
@property (nonatomic, retain) NSString *			signal;
@property (nonatomic, assign) BOOL					enableAllEvents;

@property (nonatomic, readonly) BeeUIButtonState *	stateNormal;
@property (nonatomic, readonly) BeeUIButtonState *	stateHighlighted;
@property (nonatomic, readonly) BeeUIButtonState *	stateDisabled;
@property (nonatomic, readonly) BeeUIButtonState *	stateSelected;

- (void)addSignal:(NSString *)signal forControlEvents:(UIControlEvents)controlEvents;
- (void)addSignal:(NSString *)signal forControlEvents:(UIControlEvents)controlEvents object:(NSObject *)object;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

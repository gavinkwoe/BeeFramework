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

@interface BeeUIDatePicker : UIActionSheet<UIActionSheetDelegate>

AS_SIGNAL( WILL_PRESENT )	// 将要显示
AS_SIGNAL( DID_PRESENT )	// 已经显示
AS_SIGNAL( WILL_DISMISS )	// 将要隐藏
AS_SIGNAL( DID_DISMISS )	// 已经隐藏
AS_SIGNAL( CHANGED )		// 日期改变
AS_SIGNAL( CONFIRMED )		// 确认

@property (nonatomic, retain) NSObject *		userData;
@property (nonatomic, retain) UIView *			parentView;

@property (nonatomic, retain) NSDate *			date;
@property (nonatomic, assign) UIDatePickerMode	datePickerMode;
@property (nonatomic, assign) NSLocale *		locale;
@property (nonatomic, assign) NSCalendar *		calendar;
@property (nonatomic, assign) NSTimeZone *		timeZone;
@property (nonatomic, assign) NSDate *			minimumDate;
@property (nonatomic, assign) NSDate *			maximumDate;
@property (nonatomic, assign) NSTimeInterval	countDownDuration;
@property (nonatomic, assign) NSInteger			minuteInterval;

- (void)showInViewController:(UIViewController *)controller;	// samw as presentForController:
- (void)presentForController:(UIViewController *)controller;
- (void)dismissAnimated:(BOOL)animated;

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

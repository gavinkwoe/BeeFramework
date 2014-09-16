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

#undef	ON_LEFT_BUTTON_TOUCHED
#define ON_LEFT_BUTTON_TOUCHED( signal )	ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )

#undef	ON_RIGHT_BUTTON_TOUCHED
#define ON_RIGHT_BUTTON_TOUCHED( signal )	ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )

#pragma mark -

@interface BeeUINavigationBar : UINavigationBar

AS_INT( LEFT )	// 左按钮
AS_INT( RIGHT )	// 右按钮

AS_SIGNAL( LEFT_TOUCHED )	// 左按钮被点击
AS_SIGNAL( RIGHT_TOUCHED )	// 右按钮被点击

AS_NOTIFICATION( STYLE_CHANGED )

@property (nonatomic, retain) UIImage *					backgroundImage;
@property (nonatomic, assign) UINavigationController *	navigationController;

+ (CGSize)buttonSize;
+ (UIFont *)buttonFont;
+ (UIColor *)buttonColor;

+ (void)setTitleShadowColor:(UIColor *)color;
+ (void)setTitleColor:(UIColor *)color;
+ (void)setTitleFont:(UIFont *)font;

+ (void)setButtonSize:(CGSize)size;
+ (void)setButtonFont:(UIFont *)font;
+ (void)setButtonColor:(UIColor *)color;

+ (void)setBackgroundTintColor:(UIColor *)color;
+ (void)setBackgroundColor:(UIColor *)color;
+ (void)setBackgroundImage:(UIImage *)image;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

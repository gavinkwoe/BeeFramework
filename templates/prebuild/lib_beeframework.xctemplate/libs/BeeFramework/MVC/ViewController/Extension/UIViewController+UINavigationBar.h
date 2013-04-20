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

@interface UINavigationBar(UINavigationBar)

AS_INT( BARBUTTON_LEFT )			// 左按钮
AS_INT( BARBUTTON_RIGHT )			// 右按钮

AS_SIGNAL( BACK_BUTTON_TOUCHED )	// NavigationBar左按钮被点击
AS_SIGNAL( DONE_BUTTON_TOUCHED )	// NavigationBar右按钮被点击

#define BARBUTTON_LEFT_TOUCHED	BACK_BUTTON_TOUCHED
#define BARBUTTON_RIGHT_TOUCHED	DONE_BUTTON_TOUCHED

@end

#pragma mark -

@interface UIViewController(UINavigationBar)

- (void)showNavigationBarAnimated:(BOOL)animated;
- (void)hideNavigationBarAnimated:(BOOL)animated;

- (void)showBarButton:(NSInteger)position title:(NSString *)name;
- (void)showBarButton:(NSInteger)position image:(UIImage *)image;
- (void)showBarButton:(NSInteger)position system:(UIBarButtonSystemItem)index;
- (void)showBarButton:(NSInteger)position custom:(UIView *)view;
- (void)hideBarButton:(NSInteger)position;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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
#import "Bee_ViewPackage.h"

#import "Bee_UISignal.h"
#import "Bee_UICapability.h"

#pragma mark -

AS_PACKAGE( BeePackage_UI, BeeUIKeyboard, keyboard );

#pragma mark -

@interface BeeUIKeyboard : NSObject

AS_NOTIFICATION( SHOWN )			// 键盘弹出
AS_NOTIFICATION( HIDDEN )			// 键盘收起
AS_NOTIFICATION( HEIGHT_CHANGED )	// 输入法切换

AS_SINGLETON( BeeUIKeyboard )

@property (nonatomic, readonly) BOOL					shown;
@property (nonatomic, readonly) BOOL					animating;
@property (nonatomic, readonly) CGFloat					height;
@property (nonatomic, assign) UIView *					accessor;

@property (nonatomic, readonly) NSTimeInterval			animationDuration;
@property (nonatomic, readonly) UIViewAnimationCurve	animationCurve;

- (void)setAccessor:(UIView *)view;
- (void)showAccessor:(UIView *)view animated:(BOOL)animated;
- (void)hideAccessor:(UIView *)view animated:(BOOL)animated;
- (void)updateAccessorAnimated:(BOOL)animated;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

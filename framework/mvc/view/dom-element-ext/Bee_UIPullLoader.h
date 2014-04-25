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

@interface BeeUIPullLoader : UIView

AS_SIGNAL( STATE_CHANGED )		// 状态改变
AS_SIGNAL( FRAME_CHANGED )		// 布局改变

AS_INT( STATE_NORMAL )
AS_INT( STATE_PULLING )
AS_INT( STATE_LOADING )

@property (nonatomic, assign) NSUInteger	state;
@property (nonatomic, assign) BOOL			pulling;
@property (nonatomic, assign) BOOL			loading;
@property (nonatomic, assign) BOOL			animated;

+ (BeeUIPullLoader *)spawn;

+ (Class)defaultClass;
+ (CGSize)defaultSize;

+ (void)setDefaultClass:(Class)clazz;
+ (void)setDefaultSize:(CGSize)size;

- (void)changeFrame:(CGRect)frame animated:(BOOL)animated;
- (void)changeState:(NSInteger)state animated:(BOOL)animated;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

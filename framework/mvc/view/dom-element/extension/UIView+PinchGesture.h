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
#import "Bee_UISignal.h"

#pragma mark -

@interface UIView(PinchGesture)

AS_SIGNAL( PINCH_START )			// 左右滑动开始
AS_SIGNAL( PINCH_STOP )				// 左右滑动结束
AS_SIGNAL( PINCH_CHANGED )			// 左右滑动位置变化
AS_SIGNAL( PINCH_CANCELLED )		// 左右滑动取消

@property (nonatomic, assign) BOOL								pinchable;		// same as pinchEnabled
@property (nonatomic, assign) BOOL								pinchEnabled;
@property (nonatomic, readonly) CGFloat							pinchScale;
@property (nonatomic, readonly) CGFloat							pinchVelocity;
@property (nonatomic, readonly) UIPinchGestureRecognizer *		pinchGesture;

@end

#pragma mark -

#undef	ON_PINCH_START
#define ON_PINCH_START( signal )		ON_SIGNAL3( UIView, PINCH_START, signal )

#undef	ON_PINCH_STOP
#define ON_PINCH_STOP( signal )			ON_SIGNAL3( UIView, PINCH_STOP, signal )

#undef	ON_PINCH_CHANGED
#define ON_PINCH_CHANGED( signal )		ON_SIGNAL3( UIView, PINCH_CHANGED, signal )

#undef	ON_PINCH_CANCELLED
#define ON_PINCH_CANCELLED( signal )	ON_SIGNAL3( UIView, PINCH_CANCELLED, signal )

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

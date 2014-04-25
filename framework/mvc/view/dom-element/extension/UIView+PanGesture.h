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

@interface UIView(PanGesture)

AS_SIGNAL( PAN_START )				// 左右滑动开始
AS_SIGNAL( PAN_STOP )				// 左右滑动结束
AS_SIGNAL( PAN_CHANGED )			// 左右滑动位置变化
AS_SIGNAL( PAN_CANCELLED )			// 左右滑动取消

@property (nonatomic, assign) BOOL								pannable;	// same as panEnabled 
@property (nonatomic, assign) BOOL								panEnabled;
@property (nonatomic, readonly) CGPoint							panOffset;
@property (nonatomic, readonly) UIPanGestureRecognizer *		panGesture;

@end

#pragma mark -

#undef	ON_PAN_START
#define ON_PAN_START( signal )		ON_SIGNAL3( UIView, PAN_START, signal )

#undef	ON_PAN_STOP
#define ON_PAN_STOP( signal )		ON_SIGNAL3( UIView, PAN_STOP, signal )

#undef	ON_PAN_CHANGED
#define ON_PAN_CHANGED( signal )	ON_SIGNAL3( UIView, PAN_CHANGED, signal )

#undef	ON_PAN_CANCELLED
#define ON_PAN_CANCELLED( signal )	ON_SIGNAL3( UIView, PAN_CANCELLED, signal )

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

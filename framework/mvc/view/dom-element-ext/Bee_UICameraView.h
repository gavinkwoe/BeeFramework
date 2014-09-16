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

#if TARGET_IPHONE_SIMULATOR

#undef	AVCaptureSession
#define	AVCaptureSession			NSObject

#undef	AVCaptureVideoPreviewLayer
#define	AVCaptureVideoPreviewLayer	NSObject

#undef	AVCaptureVideoOrientation
#define	AVCaptureVideoOrientation	NSInteger

#endif	// #if TARGET_IPHONE_SIMULATOR

#pragma mark -

@interface BeeUICameraView : UIView
#if !TARGET_IPHONE_SIMULATOR
<AVCaptureVideoDataOutputSampleBufferDelegate>
#endif	// #if !TARGET_IPHONE_SIMULATOR

AS_INT( TORCH_MODE_NONE )	// 闪光灯不可用
AS_INT( TORCH_MODE_OFF )	// 闪光灯关
AS_INT( TORCH_MODE_ON )		// 闪光灯开
AS_INT( TORCH_MODE_AUTO )	// 闪光灯自动

AS_INT( POSITION_FRONT )	// 前置
AS_INT( POSITION_BACK )		// 后置

@property (nonatomic, retain) AVCaptureSession *			captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *	previewLayer;	
@property (nonatomic, assign) AVCaptureVideoOrientation		previewOrientation;

@property (nonatomic, retain) UIImage *						previewImage;

@property (nonatomic, assign) BOOL							running;
@property (nonatomic, assign) NSInteger						torchMode;
@property (nonatomic, assign) NSInteger						position;

@property (nonatomic, readonly) BOOL						focusing;
@property (nonatomic, readonly) CGPoint						focusPoint;
@property (nonatomic, readonly) CGPoint						focusPointWithViewCorrdinates;

@property (nonatomic, assign) CGPoint						autoFocusAt;
@property (nonatomic, assign) CGPoint						continuousFocusAt;

AS_SIGNAL( MANUAL_FOCUS )	// 用户触屏手动对焦

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

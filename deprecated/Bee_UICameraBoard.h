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
//  Bee_UICameraBoard.h
//

#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

#import "Bee.h"

#pragma mark -

@interface BeeUICameraBoard : BeeUIBoard
#if !TARGET_IPHONE_SIMULATOR
<AVCaptureVideoDataOutputSampleBufferDelegate>
#endif	// #if !TARGET_IPHONE_SIMULATOR
{
#if !TARGET_IPHONE_SIMULATOR
	AVCaptureSession *				_captureSession;
    AVCaptureDevice *				_captureDevice;
	AVCaptureDeviceInput *			_videoInput;
	AVCaptureVideoDataOutput *		_videoOutput;
	AVCaptureVideoPreviewLayer *	_previewLayer;
	AVCaptureVideoOrientation		_previewOrientation;
	dispatch_queue_t				_videoQueue;
#endif	// #if !TARGET_IPHONE_SIMULATOR

	UIImage *						_previewImage;
	BOOL							_running;
}

AS_INT( TORCH_MODE_NONE )	// 闪光灯不可用
AS_INT( TORCH_MODE_OFF )	// 闪光灯关
AS_INT( TORCH_MODE_ON )		// 闪光灯开
AS_INT( TORCH_MODE_AUTO )	// 闪光灯自动

AS_INT( POSITION_FRONT )	// 前置
AS_INT( POSITION_BACK )		// 后置

#if !TARGET_IPHONE_SIMULATOR
@property (nonatomic, retain) AVCaptureSession *			captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *	previewLayer;	
@property (nonatomic, assign) AVCaptureVideoOrientation		previewOrientation;
#endif	// #if !TARGET_IPHONE_SIMULATOR

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

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

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

#import "Bee_UISignal.h"
#import "Bee_UIGridCell.h"
#import "Bee_UIBoard.h"

typedef enum
{
	CAMERA_TORCH_NONE = 0,
	CAMERA_TORCH_OFF,
	CAMERA_TORCH_ON,
	CAMERA_TORCH_AUTO
} BeeUICameraTorchMode;

typedef enum
{
	CAMERA_POSITION_FRONT = 0,
	CAMERA_POSITION_BACK
} BeeUICameraPosition;

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

#if !TARGET_IPHONE_SIMULATOR
@property (nonatomic, retain) AVCaptureSession *			captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *	previewLayer;	
@property (nonatomic, assign) AVCaptureVideoOrientation		previewOrientation;
#endif	// #if !TARGET_IPHONE_SIMULATOR

@property (nonatomic, retain) UIImage *						previewImage;

@property (nonatomic, assign) BOOL							running;
@property (nonatomic, assign) BeeUICameraTorchMode			torchMode;
@property (nonatomic, assign) BeeUICameraPosition			position;

@property (nonatomic, readonly) BOOL						focusing;
@property (nonatomic, readonly) CGPoint						focusPoint;
@property (nonatomic, readonly) CGPoint						focusPointWithViewCorrdinates;

@property (nonatomic, assign) CGPoint						autoFocusAt;
@property (nonatomic, assign) CGPoint						continuousFocusAt;

AS_SIGNAL( MANUAL_FOCUS )	// 用户触屏手动对焦

@end

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

#import "Bee_UICameraView.h"
#import "Bee_UIAccelerometer.h"
#import "Bee_UISignal.h"
#import "UIView+BeeUISignal.h"

#pragma mark -

@interface BeeUICameraView()
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	AVCaptureSession *				_captureSession;
    AVCaptureDevice *				_captureDevice;
	AVCaptureDeviceInput *			_videoInput;
	AVCaptureVideoDataOutput *		_videoOutput;
	AVCaptureVideoPreviewLayer *	_previewLayer;
	AVCaptureVideoOrientation		_previewOrientation;
	dispatch_queue_t				_videoQueue;
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
	
	BOOL		_inited;
	UIImage *	_previewImage;
	BOOL		_running;
}

#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position;

- (void)updateCaptureOutput:(UIImage *)image;
- (void)updatePreviewOrientation:(NSNumber *)orientation;

+ (CGSize)sizeForGravity:(NSString *)gravity frameSize:(CGSize)frameSize apertureSize:(CGSize)apertureSize;
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates;
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE

- (void)initSelf;

@end

#pragma mark -

@implementation BeeUICameraView

DEF_INT( TORCH_MODE_NONE,	0 )
DEF_INT( TORCH_MODE_OFF,	1 )
DEF_INT( TORCH_MODE_ON,		2 )
DEF_INT( TORCH_MODE_AUTO,	3 )

DEF_INT( POSITION_FRONT,	0 )
DEF_INT( POSITION_BACK,		1 )

#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
@synthesize captureSession = _captureSession;
@synthesize previewOrientation = _previewOrientation;
@synthesize previewLayer = _previewLayer;
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE

@synthesize previewImage = _previewImage;

@dynamic running;
@dynamic torchMode;
@dynamic position;
@dynamic focusing;
@dynamic focusPoint;
@dynamic focusPointWithViewCorrdinates;
@dynamic autoFocusAt;
@dynamic continuousFocusAt;

DEF_SIGNAL( MANUAL_FOCUS )	// 用户触屏手动对焦

- (void)initSelf
{
	if ( NO == _inited )
	{
//		[[BeeUIAccelerometer sharedInstance] startTracking];

	#if TARGET_OS_IPHONE
	#if !TARGET_IPHONE_SIMULATOR
		
		_videoQueue = dispatch_queue_create( "com.bee.processingQueue", NULL );
		
		NSError * error = nil;
		NSArray * devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
		for (AVCaptureDevice * device in devices)
		{
			if ( [device position] == AVCaptureDevicePositionBack )
			{
				_captureDevice = device;
			}
		}

		_captureSession = [[AVCaptureSession alloc] init];
		[_captureSession beginConfiguration];
		
		_videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_captureDevice error:&error];
		if ( [_captureSession canAddInput:_videoInput] ) 
		{
			[_captureSession addInput:_videoInput];
		}
		else
		{
			CC( @"Couldn't add video input" );
		}

		// Add the video frame output	
		_videoOutput = [[AVCaptureVideoDataOutput alloc] init];
		[_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
		[_videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
		[_videoOutput setSampleBufferDelegate:self queue:_videoQueue];
		
		if ( [_captureSession canAddOutput:_videoOutput] )
		{
			[_captureSession addOutput:_videoOutput];
		}
		else
		{
			CC( @"Couldn't add video output" );
		}

		if ( [_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh] )
		{
			[_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
		}
		else if ( [_captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto] )
		{
			[_captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
		}
		else if ( [_captureSession canSetSessionPreset:AVCaptureSessionPresetMedium] )
		{
			[_captureSession setSessionPreset:AVCaptureSessionPresetMedium];
		}
		else if ( [_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480] )
		{
			[_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
		}
		
		[_captureSession commitConfiguration];

		if ( [_captureDevice lockForConfiguration:nil] )
		{
			if ( [_captureDevice isFocusModeSupported:AVCaptureFocusModeLocked] )
			{
				_captureDevice.focusMode = AVCaptureFocusModeLocked;
			}

			if ( [_captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure] )
			{
				_captureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
			}
			else
			if ( [_captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose] )
			{
				_captureDevice.exposureMode = AVCaptureExposureModeAutoExpose;
			}
			else if ( [_captureDevice isExposureModeSupported:AVCaptureExposureModeLocked] )
			{
				_captureDevice.exposureMode = AVCaptureExposureModeLocked;
			}

			if ( [_captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance] )
			{
				_captureDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
			}
			else if ( [_captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance] )
			{
				_captureDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
			}
			else if ( [_captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked] )
			{
				_captureDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeLocked;
			}
			
			[_captureDevice unlockForConfiguration];
		}

		_previewLayer = [[AVCaptureVideoPreviewLayer layerWithSession:_captureSession] retain];
		_previewLayer.frame = CGRectZero;
		_previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
		[self.layer addSublayer:_previewLayer];
        
		[self setContinuousFocusAt:CGPointMake( 0.5f, 0.5f )];
        
        [self applyOrientationTransform];
        
        [self observeNotification:UIDeviceOrientationDidChangeNotification];

	#endif	// #if !TARGET_IPHONE_SIMULATOR
	#endif	// #if TARGET_OS_IPHONE
		
		_inited = YES;
	}
}

- (void)deinitSelf
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	
	if ( [_captureSession isRunning] )
    {
        [_captureSession stopRunning];
    }

	[_previewLayer removeFromSuperlayer];
	[_previewLayer release];

	[_captureSession removeInput:_videoInput];
    [_captureSession removeOutput:_videoOutput];
	
	if ( _videoQueue )
    {
        dispatch_release( _videoQueue );
    }

    [self unobserveNotification:UIDeviceOrientationDidChangeNotification];
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE

//	[_previewImage release];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)dealloc
{
	[self deinitSelf];
	[super dealloc];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];

#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	_previewLayer.frame = CGRectMake( 0, 0, frame.size.width, frame.size.height );
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
}

- (BOOL)running
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	return self.captureSession.running;
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
	
	return NO;
}

- (void)setRunning:(BOOL)run
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	if ( run )
	{
        [[BeeUIAccelerometer sharedInstance] startTracking];
		[self.captureSession startRunning];
	}
	else
	{		
		[self.captureSession stopRunning];
        [[BeeUIAccelerometer sharedInstance] stopTracking];
	}
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
}

- (NSInteger)torchMode
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	
	AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if ( [device hasTorch] )
	{
		AVCaptureTorchMode mode = [device torchMode];
		if ( AVCaptureTorchModeOff == mode )
		{	
			return self.TORCH_MODE_OFF;
		}
		else if ( AVCaptureTorchModeOn == mode )
		{
			return self.TORCH_MODE_ON;
		}
		else if ( AVCaptureTorchModeAuto == mode )
		{
			return self.TORCH_MODE_AUTO;
		}
	}
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE

	return self.TORCH_MODE_NONE;
}

- (void)setTorchMode:(NSInteger)mode
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if ( [device hasTorch] )
	{		
		if ( [device lockForConfiguration:nil] )
		{
			if ( self.TORCH_MODE_OFF == mode )
			{
				[device setTorchMode:AVCaptureTorchModeOff];
			}
			else if ( self.TORCH_MODE_ON == mode )
			{
				[device setTorchMode:AVCaptureTorchModeOn];
			}
			else if ( self.TORCH_MODE_AUTO == mode )
			{
				[device setTorchMode:AVCaptureTorchModeAuto];
			}		
			
			[device unlockForConfiguration];			
		}

		[self.captureSession startRunning];
	}
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
}

- (NSInteger)position
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	NSArray * inputs = self.captureSession.inputs;
	for ( AVCaptureDeviceInput * input in inputs )
	{
		AVCaptureDevice * device = input.device;
		if ( [device hasMediaType:AVMediaTypeVideo] )
		{
			if ( device.position == AVCaptureDevicePositionBack )
			{
				return self.POSITION_BACK;
			}
			else
			{
				return self.POSITION_FRONT;
			}
		}
	}
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
	
	return self.POSITION_BACK;
}

- (void)setPosition:(NSInteger)pos
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	NSArray * inputs = self.captureSession.inputs;
	for ( AVCaptureDeviceInput * input in inputs )
	{
		AVCaptureDevice * device = input.device;
		if ( [device hasMediaType:AVMediaTypeVideo] )
		{
			AVCaptureDevice * newCamera = nil;
			AVCaptureDeviceInput * newInput = nil;
			
			if ( pos == self.POSITION_BACK )
			{
				newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];				
			}
			else
			{
				newCamera = [ self cameraWithPosition:AVCaptureDevicePositionFront];				
			}

			newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
			
			[self.captureSession beginConfiguration];
			[self.captureSession removeInput:input];
			[self.captureSession addInput:newInput];
			[self.captureSession commitConfiguration];
			break;
		}
	} 
	
	[self.captureSession startRunning];
	
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
}

#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)pos
{
    NSArray * devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice * device in devices )
	{
        if ( device.position == pos )
            return device;		
	}

    return nil;
}
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE

- (void)updateCaptureOutput:(UIImage *)image
{
	self.previewImage = image;
}

- (void)updatePreviewOrientation:(NSNumber *)orientation
{
	self.previewOrientation = [orientation intValue];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];

#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	
	UITouch * touch = [[touches allObjects] objectAtIndex:0];		
	if ( touch )
	{
		CGPoint location = [touch locationInView:self];
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:location];
		[self setContinuousFocusAt:convertedFocusPoint];
		[self sendUISignal:BeeUICameraView.MANUAL_FOCUS
				withObject:[NSDictionary dictionaryWithObjectsAndKeys:
							[NSNumber numberWithFloat:location.x], @"x",
							[NSNumber numberWithFloat:location.y], @"y",
							nil]];
	}
	
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
}

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates 
{
    CGPoint pointOfInterest = CGPointMake(0.5f, 0.5f);
	
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR   
	
    CGSize frameSize = self.frame.size;

    if ( [_previewLayer isMirrored] )
	{
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }    
	
    if ( [[_previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) 
	{
		if ( frameSize.height > 0 && frameSize.width > 0 )
		{
			pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
		}
    }
	else 
	{
        CGRect cleanAperture = CGRectZero;

        for ( AVCaptureInputPort *port in [_videoInput ports] ) 
		{
            if ( [port mediaType] == AVMediaTypeVideo )
			{
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);

                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
				
                CGFloat apertureRatio = 0;
				if (apertureSize.width > 0) 
				{
					apertureRatio = apertureSize.height / apertureSize.width;
				}
				
                CGFloat viewRatio = 0;
				if (frameSize.height > 0) 
				{
					viewRatio = frameSize.width / frameSize.height;
				}
				
                CGFloat xc = 0.5f;
                CGFloat yc = 0.5f;
                
                if ( [[_previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) 
				{
                    if ( viewRatio > apertureRatio ) 
					{
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;

                        if ( point.x >= blackBar && point.x <= blackBar + x2 ) 
						{
							if ( y2 > 0 ) 
							{
								xc = point.y / y2;
							}
							
							if ( x2 > 0 ) 
							{
								yc = 1.f - ((point.x - blackBar) / x2);
							}
							
                        }
                    } 
					else 
					{
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
						
                        if ( point.y >= blackBar && point.y <= blackBar + y2 )
						{
							if ( y2 > 0 ) 
							{
								xc = ((point.y - blackBar) / y2);
							}
							if ( x2 > 0 ) 
							{
								yc = 1.f - (point.x / x2);
							}
                        }
                    }
                } 
				else if ( [[_previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill] ) 
				{
                    if ( viewRatio > apertureRatio ) 
					{
                        CGFloat y2 = 0;
						if (apertureSize.height > 0) 
						{
							y2 = apertureSize.width * (frameSize.width / apertureSize.height);
						}
						
						if (y2 > 0) 
						{
							 xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
						}
						if (frameSize.width > 0) 
						{
							yc = (frameSize.width - point.x) / frameSize.width;
						}
                        
                    } 
					else 
					{
                        CGFloat x2 =  0;
						if (apertureSize.width > 0) 
						{
							x2 = apertureSize.height * (frameSize.height / apertureSize.width);
						}
						
						if (x2 > 0) 
						{
							yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
						}
                        
						if (frameSize.height > 0) 
						{
							xc = point.y / frameSize.height;
						}
                        
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
	
#endif    
#endif	// #if TARGET_OS_IPHONE
	
    return pointOfInterest;
}

- (BOOL)focusing
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	return _captureDevice.adjustingFocus;
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
	
	return NO;
}

- (CGPoint)focusPoint
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	CGPoint point;
	point.x = self.frame.size.width * _captureDevice.focusPointOfInterest.x;
	point.y = self.frame.size.height * _captureDevice.focusPointOfInterest.y;
	return point;
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
	
	return CGPointZero;
}

- (CGPoint)focusPointWithViewCorrdinates
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	
	CGPoint pointOfInterest = _captureDevice.focusPointOfInterest;
	CGSize frameSize = self.frame.size;
	CGPoint point = CGPointZero;

	if ([_previewLayer isMirrored]) 
	{
		pointOfInterest.x = 1 -pointOfInterest.x;
	}
	
	CGRect cleanAperture = CGRectZero;

    for ( AVCaptureInputPort * port in [_videoInput ports] )
	{
        if ( [port mediaType] == AVMediaTypeVideo )
		{
            cleanAperture = CMVideoFormatDescriptionGetCleanAperture( [port formatDescription], YES );
            break;
        }
    }

	CGSize apertureSize = cleanAperture.size;
	CGFloat apertureRatio = 0;
	
	if (apertureSize.width > 0)
	{
		apertureRatio = apertureSize.height / apertureSize.width ;
	}
	
	CGFloat viewRatio = 0;
	if (frameSize.height > 0) 
	{
		viewRatio = frameSize.width/frameSize.height;
	}
	
	if ([[_previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill])
	{
		if (viewRatio > apertureRatio) 
		{
			CGFloat y2 = 0;
			if (apertureSize.height > 0) 
			{
				y2 = apertureSize.width * (frameSize.width / apertureSize.height);
			}
			point.y = pointOfInterest.x*y2 - ((y2 - frameSize.height) / 2.f)  ;
			point.x = frameSize.width - pointOfInterest.y*frameSize.width ;
		} 
		else 
		{
			CGFloat x2 = 0;
			if (apertureSize.width > 0) 
			{
				x2 = apertureSize.height * (frameSize.height / apertureSize.width);
			}
			point.x = x2*(1.f - pointOfInterest.y) - ((x2 - frameSize.width) / 2);
			point.y = frameSize.height*pointOfInterest.x ;
		}
		return point;
	}
	
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
	
	return CGPointZero;
}

+ (CGSize)sizeForGravity:(NSString *)gravity frameSize:(CGSize)frameSize apertureSize:(CGSize)apertureSize
{
	CGFloat apertureRatio = 0;
	if (apertureSize.width > 0) 
	{
		apertureRatio = apertureSize.height / apertureSize.width;
	}
	
	CGFloat viewRatio = 0;
	if (frameSize.height > 0) 
	{
		viewRatio = frameSize.width / frameSize.height;
	}
	
	CGSize size = CGSizeZero;
	if ([gravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) 
	{
		if (viewRatio > apertureRatio) 
		{
			size.width = frameSize.width;
			if (apertureSize.height > 0) 
			{
				size.height = apertureSize.width * (frameSize.width / apertureSize.height);
			}
		} 
		else 
		{
			if (apertureSize.width > 0) 
			{
				size.width = apertureSize.height * (frameSize.height / apertureSize.width);
			}
			
			size.height = frameSize.height;
		}
	} else if ([gravity isEqualToString:AVLayerVideoGravityResizeAspect]) 
	{
		if (viewRatio > apertureRatio) 
		{
			if (apertureSize.width > 0) 
			{
				size.width = apertureSize.height * (frameSize.height / apertureSize.width);
			}
			size.height = frameSize.height;
		} 
		else 
		{
			if (apertureSize.height > 0) 
			{
				size.height = apertureSize.width * (frameSize.width / apertureSize.height);
			}
			size.width = frameSize.width;
		}
	} else if ([gravity isEqualToString:AVLayerVideoGravityResize]) 
	{
		size.width = frameSize.width;
		size.height = frameSize.height;
	}
	
	return size;
}

- (void)setAutoFocusAt:(CGPoint)point
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	
	if ( _captureDevice.adjustingFocus )
		return;
	
    if ( [_captureDevice isFocusPointOfInterestSupported] && [_captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus] )
	{
		NSError * error = nil;		
		if ( [_captureDevice lockForConfiguration:&error] )
		{
            [_captureDevice setFocusPointOfInterest:point];
            [_captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
            [_captureDevice unlockForConfiguration];
		}
    }
	
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
}

// Switch to continuous auto focus mode at the specified point
- (void)setContinuousFocusAt:(CGPoint)point
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
	
	if ( _captureDevice.adjustingFocus )
		return;
	
    if ([_captureDevice isFocusPointOfInterestSupported] && [_captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
	{
		NSError *error;
		if ([_captureDevice lockForConfiguration:&error]) 
		{
			[_captureDevice setFocusPointOfInterest:point];
			[_captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
			[_captureDevice unlockForConfiguration];
		} 
	}
	
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
}

- (void)applyOrientationTransform
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
    
	UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    
    switch ( orient )
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            _previewLayer.transform = CATransform3DMakeRotation( M_PI , 0, 0, 1);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            _previewLayer.transform = CATransform3DMakeRotation( M_PI / 2.0f , 0, 0, 1);
            break;
        case UIInterfaceOrientationLandscapeRight:
            _previewLayer.transform = CATransform3DMakeRotation( M_PI / 2.0f * 3.0f , 0, 0, 1);
            break;
        case UIInterfaceOrientationPortrait:
            _previewLayer.transform = CATransform3DIdentity;
            break;
    }
    
//    CATransform3D currentTrans = _previewLayer.transform;
//    
//    switch ( orient )
//    {
//        case UIInterfaceOrientationPortraitUpsideDown:
//            _previewLayer.transform = CATransform3DRotate( currentTrans, M_PI, 0, 0, 1 );
//            break;
//        case UIInterfaceOrientationLandscapeLeft:
//            _previewLayer.transform = CATransform3DRotate( currentTrans, M_PI / 2.0f * 3.0f, 0, 0, 1 );
//            break;
//        case UIInterfaceOrientationLandscapeRight:
//            _previewLayer.transform = CATransform3DRotate( currentTrans, M_PI / 2.0f, 0, 0, 1 );
//            break;
//        case UIInterfaceOrientationPortrait:
//            _previewLayer.transform = CATransform3DIdentity;
//            break;
//    }
    
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
}

#pragma mark -
#pragma mark UIDeviceOrientationDidChangeNotification

- (void)handleNotification:(NSNotification *)notification
{
#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR
    
    if ( [notification.name isEqualToString:UIDeviceOrientationDidChangeNotification] )
    {
        [self applyOrientationTransform];
    }
    
#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE
}

#pragma mark -
#pragma mark AVCaptureSession delegate

#if TARGET_OS_IPHONE
#if !TARGET_IPHONE_SIMULATOR

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
	   fromConnection:(AVCaptureConnection *)connection 
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
    CVPixelBufferLockBaseAddress(imageBuffer,0); 

    uint8_t * baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer); 
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
    size_t width = CVPixelBufferGetWidth(imageBuffer); 
    size_t height = CVPixelBufferGetHeight(imageBuffer);  

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    CGContextRef newContext = CGBitmapContextCreate(baseAddress,
													width,
													height,
													8,
													bytesPerRow,
													colorSpace,
													kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
	
    CGImageRef newImage = CGBitmapContextCreateImage(newContext); 
	
    CGContextRelease(newContext); 
    CGColorSpaceRelease(colorSpace);

	UIImage * image = nil;
	
	UIDeviceOrientation oriention = [UIDevice currentDevice].orientation;	
	
	if ( connection.isVideoMirrored )
	{
		switch ( oriention )
		{
			case UIDeviceOrientationPortraitUpsideDown:
				image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
				break;
			case UIDeviceOrientationLandscapeLeft:
				image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationUpMirrored];
				break;
			case UIDeviceOrientationLandscapeRight:
				image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationDownMirrored];
				break;
			case UIDeviceOrientationPortrait:
			case UIDeviceOrientationFaceUp:
			case UIDeviceOrientationFaceDown:
			default:
				image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRightMirrored];
				break;
		}
	}
	else 
	{
		switch ( oriention )
		{
			case UIDeviceOrientationPortraitUpsideDown:
				image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationLeft];
				break;
			case UIDeviceOrientationLandscapeLeft:
				image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationUp];
				break;
			case UIDeviceOrientationLandscapeRight:
				image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationDown];
				break;
			case UIDeviceOrientationPortrait:
			case UIDeviceOrientationFaceUp:
			case UIDeviceOrientationFaceDown:
			default:
				image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
				break;
		}
	}

	[self performSelectorOnMainThread:@selector(updateCaptureOutput:) withObject:image waitUntilDone:YES];
	[self performSelectorOnMainThread:@selector(updatePreviewOrientation:) withObject:[NSNumber numberWithInt:connection.videoOrientation] waitUntilDone:YES];

	CVPixelBufferUnlockBaseAddress( imageBuffer, 0 );
	CGImageRelease(newImage);

	[pool drain];
}

#endif	// #if !TARGET_IPHONE_SIMULATOR
#endif	// #if TARGET_OS_IPHONE

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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
//  Bee_UICameraBoard.m
//

#import <TargetConditionals.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "Bee_UICameraBoard.h"
#import "Bee_UIOrientation.h"
#import "Bee_Runtime.h"
#import "Bee_Log.h"

#pragma mark -

@interface BeeUICameraBoard(Private)
#if !TARGET_IPHONE_SIMULATOR
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position;
- (void)updateCaptureOutput:(UIImage *)image;
- (void)updatePreviewOrientation:(NSNumber *)orientation;
+ (CGRect)cleanApertureFromPorts:(NSArray *)ports;
+ (CGSize)sizeForGravity:(NSString *)gravity frameSize:(CGSize)frameSize apertureSize:(CGSize)apertureSize;
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates;
#endif	// #if !TARGET_IPHONE_SIMULATOR
@end

@implementation BeeUICameraBoard

#if !TARGET_IPHONE_SIMULATOR
@synthesize captureSession = _captureSession;
@synthesize previewOrientation = _previewOrientation;
@synthesize previewLayer = _previewLayer;
#endif	// #if !TARGET_IPHONE_SIMULATOR

@synthesize previewImage = _previewImage;

@synthesize running;
@synthesize torchMode;
@synthesize position;
@synthesize focusing;
@synthesize focusPoint;
@synthesize focusPointWithViewCorrdinates;
@synthesize autoFocusAt;
@synthesize continuousFocusAt;

DEF_SIGNAL( MANUAL_FOCUS )	// 用户触屏手动对焦

- (void)load
{
	[super load];

	[[BeeUIOrientation sharedInstance] startTrack];

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

	if ( [_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480] ) 
	{
		[_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
	}
	else if ( [_captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto] )
	{
		[_captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
	}
	else if ( [_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh] )
	{
		[_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
	}
	else if ( [_captureSession canSetSessionPreset:AVCaptureSessionPresetMedium] )
	{
		[_captureSession setSessionPreset:AVCaptureSessionPresetMedium];
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

	_previewOrientation = AVCaptureVideoOrientationPortrait;
#endif	// #if !TARGET_IPHONE_SIMULATOR
}

- (void)unload
{
#if !TARGET_IPHONE_SIMULATOR
	if ( [_captureSession isRunning] )
    {
        [_captureSession stopRunning];
    }
	
	[_captureSession removeInput:_videoInput];
    [_captureSession removeOutput:_videoOutput];
	
	if ( _videoQueue )
    {
        dispatch_release( _videoQueue );
    }

#endif	// #if !TARGET_IPHONE_SIMULATOR

//	[_previewImage release];

	[[BeeUIOrientation sharedInstance] stopTrack];

	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
		#if !TARGET_IPHONE_SIMULATOR
			_previewLayer = [[AVCaptureVideoPreviewLayer layerWithSession:_captureSession] retain];
			_previewLayer.frame = CGRectZero;
			_previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;		
			[self.view.layer addSublayer:_previewLayer];
		#endif	// #if TARGET_IPHONE_SIMULATOR
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			[self setRunning:NO];
			
		#if !TARGET_IPHONE_SIMULATOR
			[_previewLayer removeFromSuperlayer];
			[_previewLayer release];
			_previewLayer = nil;
		#endif	// #if !TARGET_IPHONE_SIMULATOR		
		}
		else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
		{
		#if !TARGET_IPHONE_SIMULATOR
			_previewLayer.frame = self.viewBound;
		#endif	// #if !TARGET_IPHONE_SIMULATOR
		}
		else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
		{
		}
		else if ( [signal is:BeeUIBoard.FREE_DATAS] )
		{
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
		#if !TARGET_IPHONE_SIMULATOR
			[self setContinuousFocusAt:CGPointMake( 0.5f, 0.5f )];
		#endif	// #if !TARGET_IPHONE_SIMULATOR
		}
		else if ( [signal is:BeeUIBoard.DID_APPEAR] )
		{
		}
		else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
		{	
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{
		}
	}
}

- (BOOL)running
{
#if !TARGET_IPHONE_SIMULATOR
	return self.captureSession.running;
#else	// #if !TARGET_IPHONE_SIMULATOR
	return NO;
#endif	// #if !TARGET_IPHONE_SIMULATOR
}

- (void)setRunning:(BOOL)run
{
#if !TARGET_IPHONE_SIMULATOR
	if ( run )
	{
		[self.captureSession startRunning];
	}
	else
	{		
		[self.captureSession stopRunning];
	}
#endif	// #if !TARGET_IPHONE_SIMULATOR
}

- (BeeUICameraTorchMode)torchMode
{
#if !TARGET_IPHONE_SIMULATOR
	AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if ( [device hasTorch] )
	{
		AVCaptureTorchMode mode = [device torchMode];
		if ( AVCaptureTorchModeOff == mode )
		{	
			return CAMERA_TORCH_OFF;
		}
		else if ( AVCaptureTorchModeOn == mode )
		{
			return CAMERA_TORCH_ON;
		}
		else if ( AVCaptureTorchModeAuto == mode )
		{
			return CAMERA_TORCH_AUTO;
		}
	}
#endif	// #if !TARGET_IPHONE_SIMULATOR

	return CAMERA_TORCH_NONE;
}

- (void)setTorchMode:(BeeUICameraTorchMode)mode
{
#if !TARGET_IPHONE_SIMULATOR
	AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if ( [device hasTorch] )
	{		
		if ( [device lockForConfiguration:nil] )
		{
			if ( CAMERA_TORCH_OFF == mode )
			{
				[device setTorchMode:AVCaptureTorchModeOff];
			}
			else if ( CAMERA_TORCH_ON == mode )
			{
				[device setTorchMode:AVCaptureTorchModeOn];
			}
			else if ( CAMERA_TORCH_AUTO == mode )
			{
				[device setTorchMode:AVCaptureTorchModeAuto];
			}		
			
			[device unlockForConfiguration];			
		}

		[self.captureSession startRunning];
	}
#endif	// #if !TARGET_IPHONE_SIMULATOR
}

- (BeeUICameraPosition)position
{
#if !TARGET_IPHONE_SIMULATOR
	NSArray * inputs = self.captureSession.inputs;
	for ( AVCaptureDeviceInput * input in inputs )
	{
		AVCaptureDevice * device = input.device;
		if ( [device hasMediaType:AVMediaTypeVideo] )
		{
			if ( device.position == AVCaptureDevicePositionBack )
			{
				return CAMERA_POSITION_BACK;
			}
			else
			{
				return CAMERA_POSITION_FRONT;
			}
		}
	}
#endif	// #if !TARGET_IPHONE_SIMULATOR
	
	return CAMERA_POSITION_BACK;
}

- (void)setPosition:(BeeUICameraPosition)pos
{
#if !TARGET_IPHONE_SIMULATOR
	NSArray * inputs = self.captureSession.inputs;
	for ( AVCaptureDeviceInput * input in inputs )
	{
		AVCaptureDevice * device = input.device;
		if ( [device hasMediaType:AVMediaTypeVideo] )
		{
			AVCaptureDevice * newCamera = nil;
			AVCaptureDeviceInput * newInput = nil;
			
			if ( pos == CAMERA_POSITION_BACK )
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
}

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

- (void)updateCaptureOutput:(UIImage *)image
{
	self.previewImage = image;
}

- (void)updatePreviewOrientation:(NSNumber *)orientation
{
#if !TARGET_IPHONE_SIMULATOR
	self.previewOrientation = [orientation intValue];
#endif	// #if !TARGET_IPHONE_SIMULATOR
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];

#if !TARGET_IPHONE_SIMULATOR
	UITouch * touch = [[touches allObjects] objectAtIndex:0];		
	if ( touch )
	{
		CGPoint location = [touch locationInView:self.view];
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:location];
		[self setContinuousFocusAt:convertedFocusPoint];
		[self sendUISignal:BeeUICameraBoard.MANUAL_FOCUS
				withObject:[NSDictionary dictionaryWithObjectsAndKeys:
							[NSNumber numberWithFloat:location.x], @"x",
							[NSNumber numberWithFloat:location.y], @"y",
							nil]];
	}
#endif
}

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates 
{
    CGPoint pointOfInterest = CGPointMake(0.5f, 0.5f);
	
#if !TARGET_IPHONE_SIMULATOR   
    CGSize frameSize = [self.view frame].size;	

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
	
    return pointOfInterest;
}

- (BOOL)focusing
{
#if !TARGET_IPHONE_SIMULATOR
	return _captureDevice.adjustingFocus;
#else	// #if !TARGET_IPHONE_SIMULATOR
	return NO;
#endif	// #if !TARGET_IPHONE_SIMULATOR	
}

- (CGPoint)focusPoint
{
#if !TARGET_IPHONE_SIMULATOR
	CGPoint point;
	point.x = self.view.bounds.size.width * _captureDevice.focusPointOfInterest.x;
	point.y = self.view.bounds.size.height * _captureDevice.focusPointOfInterest.y;
	return point;
//	return _captureDevice.focusPointOfInterest;
#else	// #if !TARGET_IPHONE_SIMULATOR
	return CGPointZero;
#endif	// #if !TARGET_IPHONE_SIMULATOR
}

-(CGPoint)focusPointWithViewCorrdinates
{
#if !TARGET_IPHONE_SIMULATOR
	CGPoint pointOfInterest = _captureDevice.focusPointOfInterest;
	CGSize frameSize = self.view.frame.size;
	CGPoint point = CGPointZero;

	if ([_previewLayer isMirrored]) 
	{
		pointOfInterest.x = 1 -pointOfInterest.x;
	}
	
	CGRect cleanAperture = [BeeUICameraBoard cleanApertureFromPorts:[_videoInput ports]];
	CGSize apertureSize = cleanAperture.size;
	CGFloat apertureRatio = 0;
	if (apertureSize.width > 0)
	{
		apertureRatio = apertureSize.height/apertureSize.width ;
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
#endif	
	
	return CGPointZero;
}

+ (CGRect)cleanApertureFromPorts:(NSArray *)ports
{
#if !TARGET_IPHONE_SIMULATOR
    CGRect cleanAperture = CGRectZero;
    for (AVCaptureInputPort *port in ports) 
	{
        if ([port mediaType] == AVMediaTypeVideo) 
		{
            cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
            break;
        }
    }
    return cleanAperture;
#else	// #if !TARGET_IPHONE_SIMULATOR
	return CGRectZero;
#endif	// #if !TARGET_IPHONE_SIMULATOR
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
}

// Switch to continuous auto focus mode at the specified point
- (void)setContinuousFocusAt:(CGPoint)point
{
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
}

#pragma mark -
#pragma mark AVCaptureSession delegate

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
	if ( _previewLayer.mirrored )
	{
		if (oriention == UIDeviceOrientationLandscapeLeft ) 
		{
			image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationDownMirrored];
		}
		else if( oriention == UIDeviceOrientationLandscapeRight)
		{
			image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationUpMirrored];
		}
		else if(oriention == UIDeviceOrientationPortraitUpsideDown)
		{
			image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRightMirrored];
		}
		else 
		{
			image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
		}
	}
	else 
	{
		if (oriention == UIDeviceOrientationLandscapeLeft ) 
		{
			image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationUp];
		}
		else if( oriention == UIDeviceOrientationLandscapeRight)
		{
			image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationDown];
		}
		else if(oriention == UIDeviceOrientationPortraitUpsideDown)
		{
			image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationLeft];
		}
		else 
		{
			image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
		}
	}

	[self performSelectorOnMainThread:@selector(updateCaptureOutput:) withObject:image waitUntilDone:YES];
	[self performSelectorOnMainThread:@selector(updatePreviewOrientation:) withObject:[NSNumber numberWithInt:connection.videoOrientation] waitUntilDone:YES];

	CVPixelBufferUnlockBaseAddress( imageBuffer, 0 );
	CGImageRelease(newImage);

	[pool drain];
} 
#endif	// #if !TARGET_IPHONE_SIMULATOR

@end


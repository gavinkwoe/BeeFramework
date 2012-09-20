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
//  Bee_Orientation.m
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Bee_UIOrientation.h"
#import "Bee_UISignal.h"
#import "Bee_Log.h"

#pragma mark -

@implementation BeeUIOrientation

DEF_SINGLETON( BeeUIOrientation );

DEF_NOTIFICATION( ANGLE_CHANGED );
DEF_NOTIFICATION( DIRECTION_CHANGED );

@synthesize orientation = _orientation;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_orientation = UIInterfaceOrientationPortrait;

		[UIAccelerometer sharedAccelerometer].updateInterval = 0.1f;
	}
	return self;
}

- (void)startTrack
{
	[UIAccelerometer sharedAccelerometer].delegate = self;	
}

- (void)stopTrack
{
	[UIAccelerometer sharedAccelerometer].delegate = nil;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	#define kFilterFactor 0.05f

	/*
	static float prevX = 0;
	static float prevY = 0;
	static float prevZ = 0;
	
	float accelX = (float)acceleration.x * kFilterFactor + (1.0f - kFilterFactor) * prevX;
	float accelY = (float)acceleration.y * kFilterFactor + (1.0f - kFilterFactor) * prevY;
	float accelZ = (float)acceleration.z * kFilterFactor + (1.0f - kFilterFactor) * prevZ;
	
	prevX = accelX;
	prevY = accelY;
	prevZ = accelZ;

	CC( @"accelerometer, x = %f, y = %f, z = %f", accelX, accelY, accelZ );
	*/
	
	// Get the current device angle
	float xxx = -[acceleration x];
	float yyy = [acceleration y];
	float angle = atan2(yyy, xxx); 

	UIInterfaceOrientation newOrient;

	CC( @"accelerometer, angel = %f", angle );
	
	// Read my blog for more details on the angles. It should be obvious that you
	// could fire a custom shouldAutorotateToInterfaceOrientation-event here.
	if ( angle >= -2.25 && angle <= -0.75 )
	{
		newOrient = UIInterfaceOrientationPortrait;
	}
	else if ( angle >= -0.75 && angle <= 0.75 )
	{
		newOrient = UIInterfaceOrientationLandscapeRight;
	}
	else if ( angle >= 0.75 && angle <= 2.25 )
	{
		newOrient = UIInterfaceOrientationPortraitUpsideDown;
	}
	else if ( angle <= -2.25 || angle >= 2.25 )
	{
		newOrient = UIInterfaceOrientationLandscapeLeft;
	}
	else
	{
		newOrient = UIInterfaceOrientationPortrait;
	}

	[self postNotification:BeeUIOrientation.ANGLE_CHANGED
				withObject:[NSNumber numberWithFloat:angle]];

	if ( newOrient != _orientation )
	{		
		_orientation = newOrient;

		[self postNotification:BeeUIOrientation.DIRECTION_CHANGED
					withObject:[NSNumber numberWithFloat:angle]];
	}
}

- (void)dealloc
{
	[UIAccelerometer sharedAccelerometer].delegate = nil;

	[super dealloc];
}

@end

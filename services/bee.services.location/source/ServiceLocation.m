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

#import "ServiceLocation.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceLocation
{
	CLLocationManager *		_locationManager;
	CLLocation *			_location;
	BOOL					_enabled;
	BeeServiceBlock			_whenUpdate;
}

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( NO )

@synthesize locationManager = _locationManager;
@synthesize location = _location;
@synthesize enabled = _enabled;
@synthesize whenUpdate = _whenUpdate;

- (void)load
{
	self.enabled = YES;
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.distanceFilter = 50.0f;
}

- (void)unload
{
	[self.locationManager stopUpdatingLocation];
	self.locationManager.delegate = nil;
	self.locationManager = nil;
	
	self.location = nil;
}

- (void)powerOn
{
	[self.locationManager startUpdatingLocation];

	self.location = self.locationManager.location;
	
    if ( self.enabled )
	{
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
	}
}

- (void)powerOff
{
	[self.locationManager stopUpdatingLocation];
}

- (void)serviceWillActive
{
}

- (void)serviceDidActived
{
}

- (void)serviceWillDeactive
{
}

- (void)serviceDidDeactived
{
}

#pragma mark -

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	if ( nil == newLocation )
		return;

	self.location = newLocation;

    if ( self.enabled )
	{
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "ServiceLogger.h"
#import "ServiceLogger_Dock.h"
#import "ServiceLogger_Window.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@implementation ServiceLogger
{
	BOOL _showing;
}

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( YES )

- (void)load
{
	[self observeNotification:ServiceLogger_Dock.OPEN];
	[self observeNotification:ServiceLogger_Dock.CLOSE];
}

- (void)unload
{
}

#pragma mark -

- (void)powerOn
{
	[ServiceLogger_Dock sharedInstance].hidden = NO;
	[ServiceLogger_Window sharedInstance].hidden = YES;
}

- (void)powerOff
{
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

- (void)didClose
{
	[ServiceLogger_Window sharedInstance].hidden = YES;
}

ON_NOTIFICATION3( ServiceLogger_Dock, OPEN, notification )
{
	[ServiceLogger_Window sharedInstance].hidden = NO;
	
	CATransform3D transform;
	
	transform = [ServiceLogger_Window sharedInstance].layer.transform;
	transform.m34 = -(1.0f / 2500.0f);
	transform = CATransform3DTranslate( transform, 0, 0, 200.0f );
	[ServiceLogger_Window sharedInstance].alpha = 0.0f;
	[ServiceLogger_Window sharedInstance].layer.transform = transform;
	
//	[BeeUIApplication sharedInstance].window.alpha = 1.0f;
//	[BeeUIApplication sharedInstance].window.layer.transform = CATransform3DIdentity;
	
	[UIView beginAnimations:@"OPEN" context:nil];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
//	transform = [BeeUIApplication sharedInstance].window.layer.transform;
//	transform.m34 = -(1.0f / 2500.0f);
//	transform = CATransform3DTranslate( transform, 0, 0, -200.0f );
//	
//	[BeeUIApplication sharedInstance].window.alpha = 0.0f;
//	[BeeUIApplication sharedInstance].window.layer.transform = transform;
	
	[ServiceLogger_Window sharedInstance].alpha = 1.0f;
	[ServiceLogger_Window sharedInstance].layer.transform = CATransform3DIdentity;
	
	[UIView commitAnimations];
	
	_showing = YES;
}

ON_NOTIFICATION3( ServiceLogger_Dock, CLOSE, notification )
{
	[UIView beginAnimations:@"CLOSE" context:nil];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didClose)];

//	[BeeUIApplication sharedInstance].window.alpha = 1.0f;
//	[BeeUIApplication sharedInstance].window.layer.transform = CATransform3DIdentity;
	
	CATransform3D transform;
	transform = [ServiceLogger_Window sharedInstance].layer.transform;
	transform.m34 = -(1.0f / 2500.0f);
	transform = CATransform3DTranslate( transform, 0, 0, 200.0f );
	
	[ServiceLogger_Window sharedInstance].alpha = 0.0f;
	[ServiceLogger_Window sharedInstance].layer.transform = transform;
	
	[UIView commitAnimations];
	
	_showing = NO;
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

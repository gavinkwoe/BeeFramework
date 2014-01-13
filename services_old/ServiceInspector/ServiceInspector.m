//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#import "ServiceInspector.h"
#import "ServiceInspector_Dock.h"
#import "ServiceInspector_Window.h"
#import "ServiceInspector_WindowHook.h"

#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@interface ServiceInspector()
{
	BOOL	_inspecting;
}
@end

#pragma mark -

@implementation ServiceInspector

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( YES )

- (void)load
{
	[super load];

	[self observeNotification:BeeUIApplication.LAUNCHED];
	[self observeNotification:BeeUIApplication.TERMINATED];

	[self observeNotification:ServiceInspector_Dock.OPEN];
	[self observeNotification:ServiceInspector_Dock.CLOSE];

	[self observeNotification:UIWindow.TOUCH_BEGAN];
	[self observeNotification:UIWindow.TOUCH_MOVED];
	[self observeNotification:UIWindow.TOUCH_ENDED];
}

- (void)unload
{
	[self unobserveAllNotifications];
	
	[super unload];
}

- (void)powerOn
{
	[UIWindow hook];
	[ServiceInspector_Dock sharedInstance].hidden = NO;
}

- (void)powerOff
{
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
	if ( [notification is:BeeUIApplication.LAUNCHED] )
	{
		[self powerOn];
	}
	else if ( [notification is:BeeUIApplication.TERMINATED] )
	{
		[self powerOff];
	}
	else if ( [notification is:ServiceInspector_Dock.OPEN] )
	{
		[[ServiceInspector_Window sharedInstance] prepareShow];
		
		[UIView beginAnimations:@"OPEN" context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:1.0f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(didOpen)];
		
		[[ServiceInspector_Window sharedInstance] show];
		
		[UIApplication sharedApplication].keyWindow.alpha = 0.0f;
		
		[UIView commitAnimations];
	}
	else if ( [notification is:ServiceInspector_Dock.CLOSE] )
	{
		[UIView beginAnimations:@"CLOSE" context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:1.0f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(didClose)];

		[UIApplication sharedApplication].keyWindow.alpha = 1.0f;
		[UIApplication sharedApplication].keyWindow.layer.transform = CATransform3DIdentity;

		[[ServiceInspector_Window sharedInstance] prepareHide];
		
		[UIView commitAnimations];
	}
}

- (void)didOpen
{	
	_inspecting = YES;
}

- (void)didClose
{
	[[ServiceInspector_Window sharedInstance] hide];

	_inspecting = NO;
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "ServiceGridSystem.h"
#import "ServiceGridSystem_Dock.h"
#import "ServiceGridSystem_Window.h"

#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@implementation ServiceGridSystem

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( NO )

- (void)load
{
	[super load];

	[self observeNotification:BeeSkeleton.LAUNCHED];
	[self observeNotification:BeeSkeleton.TERMINATED];

	[self observeNotification:ServiceGridSystem_Dock.OPEN];
	[self observeNotification:ServiceGridSystem_Dock.CLOSE];
}

- (void)unload
{
	[self unobserveAllNotifications];
	
	[super unload];
}

- (void)powerOn
{
	[ServiceGridSystem_Dock sharedInstance].hidden = NO;
}

- (void)powerOff
{
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
	if ( [notification is:BeeSkeleton.LAUNCHED] )
	{
		[self powerOn];
	}
	else if ( [notification is:BeeSkeleton.TERMINATED] )
	{
		[self powerOff];
	}
	else if ( [notification is:ServiceGridSystem_Dock.OPEN] )
	{
		[[ServiceGridSystem_Window sharedInstance] setHidden:NO];
		[[ServiceGridSystem_Window sharedInstance] setAlpha:0.0f];

		[UIView beginAnimations:@"OPEN" context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

		[[ServiceGridSystem_Window sharedInstance] setAlpha:1.0f];
		[[ServiceGridSystem_Window sharedInstance] setNeedsDisplay];
		
		[UIView commitAnimations];
	}
	else if ( [notification is:ServiceGridSystem_Dock.CLOSE] )
	{
		[UIView beginAnimations:@"CLOSE" context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(didClose)];

		[[ServiceGridSystem_Window sharedInstance] setAlpha:0.0f];

		[UIView commitAnimations];
	}
}

- (void)didClose
{
	[[ServiceGridSystem_Window sharedInstance] setHidden:YES];
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

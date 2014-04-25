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

#import "ServiceDebugger.h"
#import "ServiceDebugger_Dock.h"
#import "ServiceDebugger_Window.h"
#import "ServiceDebugger_StatusBar.h"
#import "ServiceDebugger_PlotsView.h"
#import "ServiceDebugger_CPUModel.h"
#import "ServiceDebugger_MemoryModel.h"
#import "ServiceDebugger_MessageModel.h"
#import "ServiceDebugger_NetworkModel.h"

#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@interface ServiceDebugger()
{
	BOOL	_debugging;
}
@end

#pragma mark -

@implementation ServiceDebugger

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( NO )

- (void)load
{
	[super load];

	[BeeUITemplateParserXML map:@"plots" toClass:[ServiceDebugger_PlotsView class]];

	[ServiceDebugger_CPUModel sharedInstance];
	[ServiceDebugger_MemoryModel sharedInstance];
	[ServiceDebugger_MessageModel sharedInstance];
	[ServiceDebugger_NetworkModel sharedInstance];

	[self observeNotification:BeeSkeleton.LAUNCHED];
	[self observeNotification:BeeSkeleton.TERMINATED];

	[self observeNotification:ServiceDebugger_Dock.OPEN];
	[self observeNotification:ServiceDebugger_Dock.CLOSE];
}

- (void)unload
{
	[self unobserveAllNotifications];
	
	[super unload];
}

- (void)powerOn
{
	if ( NO == [UIApplication sharedApplication].statusBarHidden )
	{
		[ServiceDebugger_StatusBar sharedInstance].hidden = NO;
	}
	
	[ServiceDebugger_Dock sharedInstance].hidden = NO;
	[ServiceDebugger_Window sharedInstance].hidden = YES;
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
	else if ( [notification is:ServiceDebugger_Dock.OPEN] )
	{
		if ( NO == [UIApplication sharedApplication].statusBarHidden )
		{
			[ServiceDebugger_StatusBar sharedInstance].hidden = YES;
		}

		[ServiceDebugger_Window sharedInstance].hidden = NO;

//		CATransform3D transform;
//
//		transform = [ServiceDebugger_Window sharedInstance].layer.transform;
//		transform.m34 = -(1.0f / 2500.0f);
//		transform = CATransform3DTranslate( transform, 0, 0, 200.0f );
//		[ServiceDebugger_Window sharedInstance].alpha = 0.0f;
//		[ServiceDebugger_Window sharedInstance].layer.transform = transform;
//		
//		[UIApplication sharedApplication].keyWindow.alpha = 1.0f;
//		[UIApplication sharedApplication].keyWindow.layer.transform = CATransform3DIdentity;
//		
//		[UIView beginAnimations:@"OPEN" context:nil];
//		[UIView setAnimationDuration:0.3f];
//		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
//				
//		transform = [UIApplication sharedApplication].keyWindow.layer.transform;
//		transform.m34 = -(1.0f / 2500.0f);
//		transform = CATransform3DTranslate( transform, 0, 0, -200.0f );
//		
//		[UIApplication sharedApplication].keyWindow.alpha = 0.0f;
//		[UIApplication sharedApplication].keyWindow.layer.transform = transform;
//
//		[ServiceDebugger_Window sharedInstance].alpha = 1.0f;
//		[ServiceDebugger_Window sharedInstance].layer.transform = CATransform3DIdentity;
//
//		[UIView commitAnimations];
		
		_debugging = YES;
	}
	else if ( [notification is:ServiceDebugger_Dock.CLOSE] )
	{
//		[UIView beginAnimations:@"CLOSE" context:nil];
//		[UIView setAnimationDuration:0.3f];
//		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
//		[UIView setAnimationDelegate:self];
//		[UIView setAnimationDidStopSelector:@selector(didClose)];
//		
//		[UIApplication sharedApplication].keyWindow.alpha = 1.0f;
//		[UIApplication sharedApplication].keyWindow.layer.transform = CATransform3DIdentity;
//
//		CATransform3D transform;
//		transform = [ServiceDebugger_Window sharedInstance].layer.transform;
//		transform.m34 = -(1.0f / 2500.0f);
//		transform = CATransform3DTranslate( transform, 0, 0, 200.0f );
//
//		[ServiceDebugger_Window sharedInstance].alpha = 0.0f;
//		[ServiceDebugger_Window sharedInstance].layer.transform = transform;
//
//		[UIView commitAnimations];
		
		[self didClose];

		_debugging = NO;
	}
}

- (void)didClose
{
	[ServiceDebugger_Window sharedInstance].hidden = YES;
	
	if ( NO == [UIApplication sharedApplication].statusBarHidden )
	{
		[ServiceDebugger_StatusBar sharedInstance].hidden = NO;
	}
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

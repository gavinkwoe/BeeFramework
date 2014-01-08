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

#import "ServicePush.h"

#pragma mark -

@interface ServicePush()
{
	BOOL						_registered;
	BOOL						_received;
	NSMutableArray *			_notifications;
	NSString *					_token;
}
@end

#pragma mark -

@implementation ServicePush

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( NO )

@synthesize received = _received;
@dynamic lastNotification;
@synthesize notifications = _notifications;
@synthesize token = _token;

DEF_NOTIFICATION( READY )
DEF_NOTIFICATION( UPDATED )

- (void)load
{
	[super load];
	
	self.notifications = [NSMutableArray array];
	
	[self observeNotification:BeeUIApplication.LAUNCHED];
	[self observeNotification:BeeUIApplication.TERMINATED];
	[self observeNotification:BeeUIApplication.STATE_CHANGED];
	[self observeNotification:BeeUIApplication.LOCAL_NOTIFICATION];
	[self observeNotification:BeeUIApplication.REMOTE_NOTIFICATION];
	[self observeNotification:BeeUIApplication.APS_REGISTERED];
	[self observeNotification:BeeUIApplication.APS_ERROR];
}

- (void)unload
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[self unobserveAllNotifications];

	self.notifications = nil;
	self.token = nil;
	
	[super unload];
}

- (BOOL)running
{
	return _registered;
}

- (void)powerOn
{
	if ( NO == _registered )
	{
		UIRemoteNotificationType types = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert;
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
	}
}

- (void)powerOff
{
	if ( _registered )
	{		
		[[UIApplication sharedApplication] unregisterForRemoteNotifications];

		_registered = NO;
	}
}

- (ServicePush_Notification *)lastNotification
{
	if ( 0 == _notifications.count )
		return nil;
	
	return [_notifications objectAtIndex:0];
}

- (void)checkUpdate
{
	if ( 0 == _notifications.count )
		return;

	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self performSelector:@selector(checkUpdateDelayed) withObject:nil afterDelay:0.1f];
}

- (void)checkUpdateDelayed
{
	if ( 0 == self.notifications.count )
		return;

	ServicePush_Notification * notify = [self.notifications safeObjectAtIndex:0];
	if ( notify )
	{
		[self postNotification:ServicePush.UPDATED withObject:notify];
	}
}

- (void)clear
{
	[self.notifications removeAllObjects];
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
	else if ( [notification is:BeeUIApplication.STATE_CHANGED] )
	{
		[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	}
	else if ( [notification is:BeeUIApplication.LOCAL_NOTIFICATION] || [notification is:BeeUIApplication.REMOTE_NOTIFICATION] )
	{
		NSDictionary * dict = (NSDictionary *)notification.object;
		if ( dict && [dict isKindOfClass:[NSDictionary class]] )
		{
			ServicePush_Notification * notify = [[[ServicePush_Notification alloc] init] autorelease];
			notify.remote = [notification is:BeeUIApplication.REMOTE_NOTIFICATION] ? YES : NO;
			notify.inApp = ((NSNumber *)[dict objectForKey:@"inApp"]).boolValue;
			notify.content = (NSDictionary *)[dict objectForKey:@"userInfo"];
			[self.notifications insertObject:notify atIndex:0];
			
			[self checkUpdateDelayed];
		}
	}
	else if ( [notification is:BeeUIApplication.APS_REGISTERED] )
	{
		self.token = notification.object;
		INFO( @"push token = %@", self.token );
		
		[self postNotification:ServicePush.READY];
		
		_registered = YES;
	}
	else if ( [notification is:BeeUIApplication.APS_ERROR] )
	{
//	#if (!TARGET_IPHONE_SIMULATOR)
//		BeeUIAlertView * alert = [BeeUIAlertView spawn];
//		alert.title = @"提示";
//		alert.message = @"无法启用推送通知，请手动开启";
//		[alert addCancelTitle:@"确定"];
//		[alert show];
//	#endif	// #if (!TARGET_IPHONE_SIMULATOR)

		_registered = NO;
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

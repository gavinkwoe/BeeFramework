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

#import "ServicePush.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServicePush
{
	BOOL				_registered;
	BOOL				_received;
	NSMutableArray *	_notifications;
	NSString *			_token;
}

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( NO )

@synthesize registered = _registered;
@synthesize received = _received;
@synthesize notifications = _notifications;
@synthesize token = _token;

@dynamic lastNotification;

@synthesize whenRegistered = _whenRegistered;
@synthesize whenReceived = _whenReceived;

@dynamic CHECK;
@dynamic CLEAR;

DEF_NOTIFICATION( REGISTERED )
DEF_NOTIFICATION( RECEIVED )

- (void)load
{
	self.notifications = [NSMutableArray array];
	
	[self observeNotification:BeeUIApplication.STATE_CHANGED];
	[self observeNotification:BeeUIApplication.LOCAL_NOTIFICATION];
	[self observeNotification:BeeUIApplication.REMOTE_NOTIFICATION];
	[self observeNotification:BeeUIApplication.APS_REGISTERED];
	[self observeNotification:BeeUIApplication.APS_ERROR];
}

- (void)unload
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	self.whenReceived = nil;
	self.whenRegistered = nil;
	self.notifications = nil;
	self.token = nil;
}

- (void)powerOn
{
	if ( _registered )
		return;

#if TARGET_IPHONE_SIMULATOR && __BEE_DEVELOPMENT__

	[self postNotification:BeeUIApplication.APS_REGISTERED withObject:@"<YOUR_UDID>"];
	
	NSString * localResPath = [[NSBundle mainBundle] pathForResource:@"push_local" ofType:@"json"];
	NSString * localResString = [NSString stringWithContentsOfFile:localResPath encoding:NSUTF8StringEncoding error:NULL];
	
	if ( localResString )
	{
		NSDictionary * userInfo = [localResString objectFromJSONString];
		if ( userInfo )
		{
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
			[self postNotification:BeeUIApplication.LOCAL_NOTIFICATION withObject:dict];
		}
	}
	
	NSString * remoteResPath = [[NSBundle mainBundle] pathForResource:@"push_remote" ofType:@"json"];
	NSString * remoteResString = [NSString stringWithContentsOfFile:remoteResPath encoding:NSUTF8StringEncoding error:NULL];
	
	if ( remoteResString )
	{
		NSDictionary * userInfo = [remoteResString objectFromJSONString];
		if ( userInfo )
		{
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
			[self postNotification:BeeUIApplication.REMOTE_NOTIFICATION withObject:dict];
		}
	}

#else	// #if TARGET_IPHONE_SIMULATOR && __BEE_DEVELOPMENT__
	
	UIRemoteNotificationType types = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];

#endif	// #if TARGET_IPHONE_SIMULATOR && __BEE_DEVELOPMENT__
}

- (void)powerOff
{
	if ( _registered )
	{		
		[[UIApplication sharedApplication] unregisterForRemoteNotifications];

		_registered = NO;
	}
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

- (PushNotification *)lastNotification
{
	if ( 0 == _notifications.count )
		return nil;
	
	return [_notifications objectAtIndex:0];
}

- (void)checkUpdateDelayed
{
	if ( 0 == self.notifications.count )
		return;
	
	PushNotification * notify = [self.notifications safeObjectAtIndex:0];
	if ( notify )
	{
		[self postNotification:ServicePush.RECEIVED withObject:notify];
		
		if ( self.whenReceived )
		{
			self.whenReceived();
		}
	}
}

- (BeeServiceBlock)CHECK
{
	BeeServiceBlock block = ^ void ( void )
	{
		if ( _notifications.count )
		{
			[NSObject cancelPreviousPerformRequestsWithTarget:self];
			[self performSelector:@selector(checkUpdateDelayed) withObject:nil afterDelay:0.1f];
		}
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)CLEAR
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self.notifications removeAllObjects];
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

ON_NOTIFICATION3( BeeUIApplication, STATE_CHANGED, notification )
{
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

ON_NOTIFICATION3( BeeUIApplication, LOCAL_NOTIFICATION, notification )
{
	NSDictionary * dict = (NSDictionary *)notification.object;
	if ( dict && [dict isKindOfClass:[NSDictionary class]] )
	{
		PushNotification * notify = [[[PushNotification alloc] init] autorelease];
		notify.isRemote = NO;
		notify.inApp = ((NSNumber *)[dict objectForKey:@"inApp"]).boolValue;
		notify.content = (NSDictionary *)[dict objectForKey:@"userInfo"];
		[self.notifications insertObject:notify atIndex:0];

		[self checkUpdateDelayed];
	}
}

ON_NOTIFICATION3( BeeUIApplication, REMOTE_NOTIFICATION, notification )
{
	NSDictionary * dict = (NSDictionary *)notification.object;
	if ( dict && [dict isKindOfClass:[NSDictionary class]] )
	{
		PushNotification * notify = [[[PushNotification alloc] init] autorelease];
		notify.isRemote = YES;
		notify.inApp = ((NSNumber *)[dict objectForKey:@"inApp"]).boolValue;
		notify.content = (NSDictionary *)[dict objectForKey:@"userInfo"];
		[self.notifications insertObject:notify atIndex:0];

		[self checkUpdateDelayed];
	}
}

ON_NOTIFICATION3( BeeUIApplication, APS_REGISTERED, notification )
{
	_registered = YES;

	self.token = notification.object;
	[self postNotification:ServicePush.REGISTERED];
	
	if ( self.whenRegistered )
	{
		self.whenRegistered();
	}
}

ON_NOTIFICATION3( BeeUIApplication, APS_ERROR, notification )
{
	_registered = NO;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

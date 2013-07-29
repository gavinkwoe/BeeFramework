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

#import "Bee_Skeleton.h"
#import "Bee_View.h"

#pragma mark -

@interface BeeSkeleton()
{
	UIWindow * _window;
}
@end

#pragma mark -

@implementation BeeSkeleton

DEF_NOTIFICATION( LAUNCHED )		// did launched
DEF_NOTIFICATION( TERMINATED )		// will terminate

DEF_NOTIFICATION( STATE_CHANGED )	// state changed
DEF_NOTIFICATION( MEMORY_WARNING )	// memory warning

DEF_NOTIFICATION( LOCAL_NOTIFICATION )
DEF_NOTIFICATION( REMOTE_NOTIFICATION )

DEF_NOTIFICATION( APS_REGISTERED )
DEF_NOTIFICATION( APS_ERROR )

@synthesize window = _window;

static BeeSkeleton * __skeleton = nil;

+ (BeeSkeleton *)sharedInstance
{
	return __skeleton;
}

- (void)load
{
	
}

- (void)unload
{
	
}

- (void)dealloc
{
	[self unload];
	
	[_window release];
	_window = nil;
	
    [super dealloc];
}

#pragma mark -

- (void)initWindow
{
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//	self.window.rootViewController = [BeeUIRouter sharedInstance];
	[self.window makeKeyAndVisible];
}

#pragma mark -

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	INFO( @"applicationDidFinishLaunching" );
	
	[self application:application didFinishLaunchingWithOptions:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	INFO( @"application:didFinishLaunchingWithOptions:" );
	
	__skeleton = self;

	[self initWindow];
	[self load];
	
	if ( self.window.rootViewController )
	{
		UIView * rootView = self.window.rootViewController.view;
		if ( rootView )
		{
			[self.window makeKeyAndVisible];
		}
	}

    if ( nil != launchOptions ) // 从通知启动
	{
		NSURL *		url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
		NSString *	bundleID = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];

		if ( url || bundleID )
		{
			NSMutableDictionary * params = [NSMutableDictionary dictionary];
			params.APPEND( @"url", url );
			params.APPEND( @"source", bundleID );

			[self postNotification:self.LAUNCHED withObject:params];
		}
		else
		{
			[self postNotification:self.LAUNCHED];
		}

		UILocalNotification * localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
		if ( localNotification )
		{
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:localNotification.userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
			[self postNotification:self.LOCAL_NOTIFICATION withObject:dict];
		}

		NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if ( remoteNotification )
		{
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:remoteNotification, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
			[self postNotification:self.REMOTE_NOTIFICATION withObject:dict];
		}
	}
	else
	{
		[self postNotification:self.LAUNCHED];
	}
	
//#if (__ON__ == __BEE_DEVELOPMENT__)
//	{
//		NSString * localResPath = [[NSBundle mainBundle] pathForResource:@"local" ofType:@"json"];
//		NSString * localResString = [NSString stringWithContentsOfFile:localResPath encoding:NSUTF8StringEncoding error:NULL];
//
//		if ( localResString )
//		{
//			NSDictionary * userInfo = [localResString objectFromJSONString];
//			if ( userInfo )
//			{
//				NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
//				[self postNotification:self.LOCAL_NOTIFICATION withObject:dict];
//			}
//		}
//
//		NSString * remoteResPath = [[NSBundle mainBundle] pathForResource:@"remote" ofType:@"json"];
//		NSString * remoteResString = [NSString stringWithContentsOfFile:remoteResPath encoding:NSUTF8StringEncoding error:NULL];
//		
//		if ( remoteResString )
//		{
//			NSDictionary * userInfo = [remoteResString objectFromJSONString];
//			if ( userInfo )
//			{
//				NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
//				[self postNotification:self.REMOTE_NOTIFICATION withObject:dict];
//			}
//		}
//	}
//#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

    return YES;
}

// Will be deprecated at some point, please replace with application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	return [self application:application openURL:url sourceApplication:nil annotation:nil];
}

// no equiv. notification. return NO if the application can't open for some reason
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	if ( url || sourceApplication )
	{
		NSMutableDictionary * params = [NSMutableDictionary dictionary];
		params.APPEND( @"url", url );
		params.APPEND( @"source", sourceApplication );

		[self postNotification:self.LAUNCHED withObject:params];
	}
	else
	{
		[self postNotification:self.LAUNCHED];
	}

	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	INFO( @"applicationDidBecomeActive" );

	[self.window.rootViewController viewWillAppear:NO];
	[self.window.rootViewController viewDidAppear:NO];

	[self postNotification:self.STATE_CHANGED];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	INFO( @"applicationWillResignActive" );

	[self.window.rootViewController viewWillDisappear:NO];
	[self.window.rootViewController viewDidDisappear:NO];

	[self postNotification:self.STATE_CHANGED];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	INFO( @"applicationDidReceiveMemoryWarning" );
	
	[self postNotification:self.MEMORY_WARNING];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	INFO( @"applicationWillTerminate" );
	
	[self postNotification:self.TERMINATED];
}

#pragma mark -

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
{
	
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
{
	
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
	
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
	
}

#pragma mark -

// one of these will be called after calling -registerForRemoteNotifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSString * token = [deviceToken description];
	token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	[self postNotification:self.APS_REGISTERED withObject:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	[self postNotification:self.APS_ERROR withObject:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	UIApplicationState state = [UIApplication sharedApplication].applicationState;
	if ( UIApplicationStateInactive == state || UIApplicationStateBackground == state )
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
		[self postNotification:self.REMOTE_NOTIFICATION withObject:dict];
	}
	else
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:YES], @"inApp", nil];
		[self postNotification:self.REMOTE_NOTIFICATION withObject:dict];
	}
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	UIApplicationState state = [UIApplication sharedApplication].applicationState;
	if ( UIApplicationStateInactive == state || UIApplicationStateBackground == state )
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:notification.userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
		[self postNotification:self.LOCAL_NOTIFICATION withObject:dict];
	}
	else
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:notification.userInfo, @"userInfo", [NSNumber numberWithBool:YES], @"inApp", nil];
		[self postNotification:self.LOCAL_NOTIFICATION withObject:dict];
	}
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	INFO( @"applicationDidEnterBackground" );
	
	[self postNotification:self.STATE_CHANGED];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	INFO( @"applicationWillEnterForeground" );
	
	[self postNotification:self.STATE_CHANGED];
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application
{
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application
{
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

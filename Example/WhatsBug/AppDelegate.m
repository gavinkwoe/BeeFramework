//
//  BugAppDelegate.m
//  WhatsBug
//

#import "AppDelegate.h"
#import "CatelogBoard.h"
#import "DribbbleController.h"

#import "Bee.h"
#import "Bee_Debug.h"

#pragma mark -
#pragma mark UnitTest

@implementation AppDelegate

@synthesize window = _window;

- (void)onCrash_divByZero
{
	int zeroDivisor = 0;
	int result = 10 / zeroDivisor;
#pragma unused(result)
}

- (void) onCrash_deallocatedObject
{
	// Note: EXC_BAD_ACCESS errors tend to cause the app to close stdout,
	// which means you won't see the trace on your console.
	// It is, however, stored to the error log file.
	NSObject* object = [[NSObject alloc] init];
	[object release];
	NSLog(@"%@", object);
}

- (void) onCrash_outOfBounds
{
	NSArray* array = [NSArray arrayWithObject:[[[NSObject alloc] init] autorelease]];
	NSLog(@"%@", [array objectAtIndex:100]);
}

- (void) onCrash_unimplementedSelector
{
	id notAViewController = [NSData data];
	[notAViewController presentModalViewController:nil animated:NO];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
	[BeeUnitTest runTests];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
	self.window.rootViewController = [BeeUIStackGroup stackGroupWithFirstStack:[BeeUIStack stackWithFirstBoard:[CatelogBoard board]]];
    [self.window makeKeyAndVisible];
	
	[BeeDebugger show];
	
//	[self onCrash_unimplementedSelector];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

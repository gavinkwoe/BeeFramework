//
//  ServiceWizard_Model.m
//  SplashService
//
//  Created by QFish on 8/14/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "ServiceWizard_Model.h"

@implementation ServiceWizard_Model

DEF_SINGLETON(ServiceWizard_Model);

+ (BOOL)shown
{
    [[self sharedInstance] restore];
    
	NSNumber * shown = [ServiceWizard_Model sharedInstance].lastShown;
	NSString * version = [ServiceWizard_Model sharedInstance].lastVersion;
	
	if ( NSOrderedSame != [version compare:[BeeSystemInfo appVersion] options:NSCaseInsensitiveSearch] )
	{
		[ServiceWizard_Model sharedInstance].lastShown = @NO;
		[ServiceWizard_Model sharedInstance].lastVersion = [BeeSystemInfo appVersion];
		[[ServiceWizard_Model sharedInstance] store];
		
		return NO;
	}
	
	return shown ? shown.boolValue : NO;
}

+ (void)setShown:(BOOL)flag
{
	if ( flag )
	{
		[ServiceWizard_Model sharedInstance].lastShown = @YES;
		[ServiceWizard_Model sharedInstance].lastVersion = [BeeSystemInfo appVersion];
	}
	else
	{
		[ServiceWizard_Model sharedInstance].lastShown = @NO;
		[ServiceWizard_Model sharedInstance].lastVersion = [BeeSystemInfo appVersion];
	}
	
	[[ServiceWizard_Model sharedInstance] store];
}

- (void)store
{
    [self userDefaultsWrite:self.lastShown forKey:@"lastShown"];
    [self userDefaultsWrite:self.lastVersion forKey:@"lastVersion"];
}

- (void)restore
{
    self.lastShown = [self userDefaultsRead:@"lastShown"];
    self.lastVersion = [self userDefaultsRead:@"lastVersion"];
}

@end

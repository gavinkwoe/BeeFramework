//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceWizard.h"
#import "ServiceWizard_Window.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface ServiceWizard()
- (void)saveCache;
- (void)loadCache;
- (BOOL)checkShown;
@end

#pragma mark -

@implementation ServiceWizard
{
	BOOL				_shown;
	NSString *			_shownVersion;

	BeeServiceBlock		_whenShown;
	BeeServiceBlock		_whenSkipped;
}

SERVICE_AUTO_LOADING( YES );
SERVICE_AUTO_POWERON( YES );

@synthesize shown = _shown;
@synthesize shownVersion = _shownVersion;

@dynamic config;

@synthesize whenShown = _whenShown;
@synthesize whenSkipped = _whenSkipped;

- (void)load
{
	[self loadCache];
}

- (void)unload
{
    [self saveCache];
	
	self.whenShown = nil;
	self.whenSkipped = nil;

	self.shownVersion = nil;
}

#pragma mark -

- (void)powerOn
{
	if ( 0 == self.config.splashes.count )
		return;

	BOOL flag = [self checkShown];
	if ( NO == flag )
	{
		[[ServiceWizard_Window sharedInstance] open];
	}
}

- (void)powerOff
{
	[[ServiceWizard_Window sharedInstance] close];
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

- (ServiceWizard_Config *)config
{
	return [ServiceWizard_Config sharedInstance];
}

- (void)notifyShown
{
	if ( self.whenShown )
	{
		self.whenShown();
	}
}

- (void)notifySkipped
{
	self.shown = YES;
	self.shownVersion = [BeeSystemInfo appVersion];
	[self saveCache];

	if ( self.whenSkipped )
	{
		self.whenSkipped();
	}
}

#pragma mark -

- (void)saveCache
{
	[self userDefaultsWrite:[NSNumber numberWithBool:self.shown] forKey:@"shown"];
	[self userDefaultsWrite:self.shownVersion forKey:@"shownVersion"];
}

- (void)loadCache
{
	self.shown = [[self userDefaultsRead:@"shown"] boolValue];
    self.shownVersion = [self userDefaultsRead:@"shownVersion"];
}

- (BOOL)checkShown
{
	NSString * currentVersion = [BeeSystemInfo appVersion];

	if ( nil == self.shownVersion )
	{
		self.shown = NO;
		self.shownVersion = currentVersion;
		[self saveCache];

		return NO;
	}
	
	if ( NSOrderedSame != [self.shownVersion compare:currentVersion options:NSCaseInsensitiveSearch] )
	{
		self.shown = NO;
		self.shownVersion = currentVersion;
		[self saveCache];

		return NO;
	}
	
	return self.shown;
}

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

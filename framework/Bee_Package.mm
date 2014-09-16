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

#import "Bee_Package.h"
#import "Bee_Singleton.h"
#import "Bee_SystemInfo.h"
#import "NSArray+BeeExtension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

BeePackage * bee = nil;

#pragma mark -

@implementation NSObject(AutoLoading)

+ (BOOL)autoLoad
{
	return YES;
}

@end

#pragma mark -

@interface BeePackage()
{
	NSMutableArray * _loadedPackages;
}

AS_SINGLETON( BeePackage )

@end

#pragma mark -

@implementation BeePackage

DEF_SINGLETON( BeePackage )

@synthesize loadedPackages = _loadedPackages;

+ (void)load
{
	[BeePackage sharedInstance];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_loadedPackages = [[NSMutableArray nonRetainingArray] retain];

		[self loadClasses];
		
		bee = self;
	}
	return self;
}

- (void)dealloc
{
	[_loadedPackages removeAllObjects];
	[_loadedPackages release];
	
	[super dealloc];
}

- (void)loadClasses
{
	const char * autoLoadClasses[] = {
		"BeeLogger",
		"BeeMsc",

	#if (TARGET_OS_MAC)
		"BeeCLI",
	#endif	// #if (TARGET_OS_MAC)
		
		"BeeReachability",
		"BeeHTTPServerConfig",
		"BeeHTTPClientConfig",
		"BeeActiveRecord",
		"BeeModel",
		"BeeController",
		"BeeLanguageSetting",

	#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
		"BeeUIStyleManager",
		"BeeUITemplateParser",
		"BeeUITemplateManager",
		"BeeUIKeyboard",
	#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

		// TODO: ADD MORE CLASSES HERE

		"BeeUnitTest",
		"BeeSingleton",
		"BeeService",

		NULL
	};
	
	NSUInteger total = 0;
	
	for ( NSInteger i = 0;; ++i )
	{
		const char * className = autoLoadClasses[i];
		if ( NULL == className )
			break;
		
		Class classType = NSClassFromString( [NSString stringWithUTF8String:className] );
		if ( classType )
		{
			BOOL succeed = [classType autoLoad];
			if ( succeed )
			{
				[_loadedPackages addObject:classType];
			}
		}
		
		total += 1;
	}
}

@end

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

#import "Bee.h"

#pragma mark -

#undef	__PRINT_LOGO__
#define	__PRINT_LOGO__	(__ON__)

#pragma mark -

@implementation NSObject(AutoLoading)

+ (BOOL)autoLoad
{
	return NO;
}

@end

#pragma mark -

@implementation BeeAutoLoader

static NSMutableArray * __loadedClasses = nil;

+ (void)load
{
#if (__ON__ == __PRINT_LOGO__)
	
	fprintf( stderr, "    												\n" );
	fprintf( stderr, "    												\n" );
	fprintf( stderr, "    	 ______    ______    ______					\n" );
	fprintf( stderr, "    	/\\  __ \\  /\\  ___\\  /\\  ___\\			\n" );
	fprintf( stderr, "    	\\ \\  __<  \\ \\  __\\_ \\ \\  __\\_		\n" );
	fprintf( stderr, "    	 \\ \\_____\\ \\ \\_____\\ \\ \\_____\\		\n" );
	fprintf( stderr, "    	  \\/_____/  \\/_____/  \\/_____/			\n" );
	fprintf( stderr, "    												\n" );
	fprintf( stderr, "    												\n" );
	fprintf( stderr, "    												\n" );
	fprintf( stderr, "    	version %s									\n", [BEE_VERSION UTF8String] );
	fprintf( stderr, "    												\n" );
	fprintf( stderr, "    	copyright (c) 2013-2014, {Bee} community	\n" );
	fprintf( stderr, "    	http://www.bee-framework.com				\n" );
	fprintf( stderr, "    												\n" );
	fprintf( stderr, "    												\n" );
	
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
	fprintf( stderr, "    	%s	\n", [BeeSystemInfo OSVersion].UTF8String );
	fprintf( stderr, "    	%s	\n", [BeeSystemInfo deviceModel].UTF8String );
	fprintf( stderr, "    	UUID: %s	\n", [BeeSystemInfo deviceUUID].UTF8String );
	fprintf( stderr, "    	Home: %s	\n", [NSBundle mainBundle].bundlePath.UTF8String );
	fprintf( stderr, "    												\n" );
	fprintf( stderr, "    												\n" );	

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#endif	// #if (__ON__ == __PRINT_LOGO__)
	
	const char * autoLoadClasses[] = {
		"BeeHTTPMockServer",
		"BeeActiveRecord",
		"BeeModel",
		"BeeController",
		"BeeService",
		"BeeUITemplate",
		// ADD CLASS BEFLOW THIS LINE!!!!
		
		// here
		
		// DO NOT MODIFY
		"BeeUnitTest",
		"BeeSingleton",
		NULL
	};
	
	if ( nil == __loadedClasses )
	{
		__loadedClasses = [[NSMutableArray nonRetainingArray] retain];
	}
	
	for ( NSInteger i = 0;; ++i )
	{
		const char * className = autoLoadClasses[i];
		if ( NULL == className )
			break;
		
		Class classType = NSClassFromString( [NSString stringWithUTF8String:className] );
		if ( classType )
		{
//			CC( @"Loading '%@' ...", [classType description] );

			BOOL succeed = [classType autoLoad];
			if ( succeed )
			{
				[__loadedClasses addObject:classType];
			}
		}
	}
	
	fprintf( stderr, "\n" );
}

+ (NSArray *)loadedClasses
{
	return __loadedClasses;
}

@end

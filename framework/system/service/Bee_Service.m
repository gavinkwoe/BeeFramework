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

#import "Bee_Service.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#import "Bee_UIApplication.h"
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE_( BeePackage, BeePackage_Service, services );

#pragma mark -

#undef	__PRELOAD_SERVICES__
#define __PRELOAD_SERVICES__	(__ON__)

#pragma mark -

@interface BeeService()
{
	BOOL					_running;
	BOOL					_activating;
	
	NSString *				_name;
	NSBundle *				_bundle;
	NSDictionary *			_launchParameters;
}

- (void)initSelf;

@end

#pragma mark -

@implementation BeeService

@synthesize name = _name;
@synthesize bundle = _bundle;
@synthesize launchParameters = _launchParameters;

@synthesize running = _running;
@synthesize activating = _activating;

@dynamic ON;
@dynamic OFF;

static NSMutableDictionary * __services = nil;

+ (BOOL)autoLoad
{
#if defined(__PRELOAD_SERVICES__) && __PRELOAD_SERVICES__
	
	INFO( @"Loading services ..." );

	[[BeeLogger sharedInstance] indent];
//	[[BeeLogger sharedInstance] disable];

	NSArray * availableClasses = [BeeRuntime allSubClassesOf:[BeeService class]];
	
	for ( Class classType in availableClasses )
	{
		if ( [classType serviceAutoLoading] )
		{
			BeeService * service = [classType sharedInstance];
			if ( service )
			{
//				[[BeeLogger sharedInstance] enable];
				INFO( @"Service '%@' loaded", [classType description] );
//				[[BeeLogger sharedInstance] disable];
			}
		}
	}

	[[BeeLogger sharedInstance] unindent];
//	[[BeeLogger sharedInstance] enable];

#endif	// #if defined(__PRELOAD_SERVICES__) && __PRELOAD_SERVICES__
	
	return YES;
}

+ (instancetype)sharedInstance
{
	BeeService * service = [__services objectForKey:self.description];
	if ( nil == service )
	{
		BOOL succeed = [self servicePreLoad];
		if ( succeed )
		{
			BeeService * service = [[[self alloc] init] autorelease];
			if ( service )
			{				
				[self serviceDidLoad];

			#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
				if ( [self serviceAutoPowerOn] )
				{
					service.ON();
				}
			#endif	// #if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
			}
		}
	}

	return service;
}

+ (BOOL)serviceAutoLoading
{
	return NO;
}

+ (BOOL)serviceAutoPowerOn
{
	return NO;
}

+ (BOOL)serviceHasUI
{
	return NO;
}

+ (BOOL)serviceHasDock
{
	return NO;
}

+ (BOOL)servicePreLoad
{
	return YES;
}

+ (void)serviceDidLoad
{
}

- (void)initSelf
{
	self.name = [[self class] description];

	Class serviceClass = [self class];
	for ( ;; )
	{
		NSString * bundlePath = [[NSBundle mainBundle] pathForResource:[serviceClass description] ofType:@"bundle"];
		NSBundle * bundle = [NSBundle bundleWithPath:bundlePath];
		
		if ( nil != bundle )
		{
			self.bundle = bundle;
			break;
		}
		
		serviceClass = class_getSuperclass( serviceClass );
		if ( nil == serviceClass || serviceClass == [NSObject class] )
			break;
	}

	if ( nil == __services )
	{
		__services = [[NSMutableDictionary alloc] init];
	}
	
	[__services setObject:self forKey:[[self class] description]];
	
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	[self observeNotification:BeeUIApplication.LAUNCHED];
	[self observeNotification:BeeUIApplication.STATE_CHANGED];
	[self observeNotification:BeeUIApplication.TERMINATED];
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
//		[self load];
		[self performLoad];
	}
	return self;
}

- (void)dealloc
{
	if ( _running )
	{
		[self powerOff];
	}

//	[self unload];
	[self performUnload];
	
	self.name = nil;
	self.bundle = nil;
	
	[self unobserveAllNotifications];
	
	[super dealloc];
}

- (void)load
{
}

- (void)unload
{
}

- (NSArray *)loadedServices
{
	return __services.allValues;
}

- (BOOL)running
{
	return _running;
}

- (void)powerOn
{
}

- (void)powerOff
{
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

- (BeeServiceBlock)ON
{
	BeeServiceBlock block = ^ void ( void )
	{
		if ( NO == _running )
		{
			[self powerOn];
			
			_running = YES;
		}
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)OFF
{
	BeeServiceBlock block = ^ void ( void )
	{
		if ( _running )
		{
			[self powerOff];
			
			_running = NO;
		}
	};
	
	return [[block copy] autorelease];
}

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

ON_NOTIFICATION3( BeeUIApplication, STATE_CHANGED, notification )
{
	if ( [BeeUIApplication sharedInstance].inBackground )
	{
		INFO( @"Service '%@' deactivating", [[self class] description] );
		
		if ( _activating )
		{
			[self serviceWillDeactive];
			
			_activating = NO;
			
			[self serviceDidDeactived];
		}
	}
	else
	{
		INFO( @"Service '%@' activating", [[self class] description] );
		
		if ( NO == _activating )
		{
			[self serviceWillActive];
			
			_activating = YES;
			
			[self serviceDidActived];
		}
	}
}

ON_NOTIFICATION3( BeeUIApplication, LAUNCHED, notification )
{
	if ( [notification.object isKindOfClass:[NSDictionary class]] )
	{
		self.launchParameters = [NSDictionary dictionaryWithDictionary:(NSDictionary *)notification.object];
	}
	else
	{
		self.launchParameters = nil;
	}

	if ( [[self class] serviceAutoPowerOn] )
	{
		self.ON();
	}
}

ON_NOTIFICATION3( BeeUIApplication, TERMINATED, notification )
{
	self.OFF();
}

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeService )
{
	// TODO:
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

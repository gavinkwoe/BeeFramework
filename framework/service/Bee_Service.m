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

#import "Bee_Service.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	__PRELOAD_SERVICES__
#define __PRELOAD_SERVICES__	(__ON__)

#pragma mark -

@interface BeeService()
{
	NSString *	_name;
	NSBundle *	_bundle;
}

- (void)initSelf;

@end

#pragma mark -

@implementation BeeService

@synthesize name = _name;
@synthesize bundle = _bundle;

static NSMutableDictionary * __services = nil;

+ (BOOL)autoLoad
{
#if defined(__PRELOAD_SERVICES__) && __PRELOAD_SERVICES__
	
	INFO( @"Loading services ..." );
		
	[[BeeLogger sharedInstance] indent];
	[[BeeLogger sharedInstance] disable];

	NSArray * availableClasses = [BeeRuntime allSubClassesOf:[BeeService class]];
	
	for ( Class classType in availableClasses )
	{
		if ( [classType serviceAutoLoading] )
		{
			BeeService * service = [classType sharedInstance];
			if ( service )
			{
				[[BeeLogger sharedInstance] enable];
				PROGRESS( [classType description], @"OK" );
				[[BeeLogger sharedInstance] disable];
			}
		}
	}

	[[BeeLogger sharedInstance] unindent];
	[[BeeLogger sharedInstance] enable];

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

				if ( [self serviceAutoPowerOn] )
				{
					[service powerOn];
				}
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

+ (BOOL)servicePreLoad
{
	return YES;
}

+ (void)serviceDidLoad
{
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
		[self load];
	}
	return self;
}

- (void)initSelf
{
	self.name = [[self class] description];

	NSString * bundlePath = [[NSBundle mainBundle] pathForResource:[[self class] description] ofType:@"bundle"];
	NSBundle * bundle = [NSBundle bundleWithPath:bundlePath];

//	if ( [bundle load] )
//	{
		self.bundle = bundle;
//	}
//	else
//	{
//		self.bundle = nil;	// default bundle
//	}

	if ( nil == __services )
	{
		__services = [[NSMutableDictionary alloc] init];
	}
	
	[__services setObject:self forKey:[[self class] description]];
}

- (void)dealloc
{
	[self unload];
	
	self.name = nil;
	self.bundle = nil;
	
	[super dealloc];
}

- (void)load
{
}

- (void)unload
{
}

- (BOOL)running
{
	return YES;
}

- (void)powerOn
{
}

- (void)powerOff
{
}

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

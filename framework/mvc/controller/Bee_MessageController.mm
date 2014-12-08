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

#import "Bee_MessageController.h"
#import "Bee_Message.h"
#import "Bee_MessageQueue.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	__PRELOAD_CONTROLLERS__
#define __PRELOAD_CONTROLLERS__	(__ON__)

#pragma mark -

@interface BeeMessageController()
{
	NSString *				_prefix;
	NSMutableDictionary *	_mapping;
}

+ (BeeMessageController *)prepareInstanceForClass:(Class)rtti;

@end

#pragma mark -

@implementation BeeMessageController

static NSMutableArray * __subControllers = nil;

@synthesize prefix = _prefix;
@synthesize mapping = _mapping;

+ (BOOL)autoLoad
{
#if defined(__PRELOAD_CONTROLLERS__) && __PRELOAD_CONTROLLERS__
	
	INFO( @"Loading controllers ..." );
	
	[[BeeLogger sharedInstance] indent];
//	[[BeeLogger sharedInstance] disable];
	
	NSArray * availableClasses = [BeeRuntime allSubClassesOf:[BeeMessageController class]];
	
	for ( Class classType in availableClasses )
	{
		[self prepareInstanceForClass:classType];
		
//		[[BeeLogger sharedInstance] enable];
		INFO( @"%@ loaded", [classType description] );
//		[[BeeLogger sharedInstance] disable];
	}
	
	[[BeeLogger sharedInstance] unindent];
//	[[BeeLogger sharedInstance] enable];
	
#endif	// #if defined(__PRELOAD_CONTROLLERS__) && __PRELOAD_CONTROLLERS__
	
	return YES;
}

+ (NSString *)MESSAGE
{
	return [self MESSAGE];
}

+ (NSString *)MESSAGE_TYPE
{
	return [NSString stringWithFormat:@"message.%@", [self description]];
}

+ (BeeMessageController *)prepareInstanceForClass:(Class)rtti
{
    BeeMessageController * controller = nil;
    
    if ( [rtti respondsToSelector:@selector(sharedInstance)] )
    {
        controller = (BeeMessageController *)[rtti sharedInstance];
    }
    else
    {
        controller = [[[rtti alloc] init] autorelease];
    }

	if ( controller )
	{		
		if ( NO == [__subControllers containsObject:controller] )
		{
			[__subControllers addObject:controller];
		}
	}
	
	return controller;
}

+ (BeeMessageController *)routes:(NSString *)message
{
	BeeMessageController * controller = nil;

	if ( __subControllers.count )
	{
		for ( BeeMessageController * subController in __subControllers )
		{
			if ( [message hasPrefix:subController.prefix] )
			{
				controller = subController;
				break;
			}
		}
	}

	if ( nil == controller )
	{
		NSArray * array = [message componentsSeparatedByString:@"."];
		if ( array && array.count > 1 )
		{
//			NSString * prefix = (NSString *)[array objectAtIndex:0];
			NSString * clazz = (NSString *)[array objectAtIndex:1];

			Class rtti = NSClassFromString( clazz );
			if ( rtti )
			{
				controller = [self prepareInstanceForClass:rtti];
				if ( controller )
				{
					NSAssert( [message hasPrefix:controller.prefix], @"wrong prefix" );
				}
			}
		}
	}
	
	return controller;
}

+ (NSArray *)allControllers
{
	return __subControllers;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{		
		if ( nil == __subControllers )
		{
			__subControllers = [[NSMutableArray alloc] init];
		}

		if ( NO == [__subControllers containsObject:self] )
		{
			[__subControllers addObject:self];
		}

		self.mapping = [NSMutableDictionary dictionary];
		self.prefix = [NSString stringWithFormat:@"message.%@", [[self class] description]];

//		[self load];
		[self performLoad];
	}
	
	return self;
}

- (void)dealloc
{	
	if ( [__subControllers containsObject:self] )
	{	
		[__subControllers removeObject:self];
	}

//	[self unload];
	[self performUnload];

	self.mapping = nil;
	self.prefix = nil;
	
	[super dealloc];
}

- (void)load
{
}

- (void)unload
{	
}

- (BOOL)prehandle:(BeeMessage *)msg
{
	return YES;
}

- (void)posthandle:(BeeMessage *)msg
{
	
}

- (void)index:(BeeMessage *)msg
{
	ERROR( @"unknown message '%@'", msg.message );

	[msg setLastError:BeeMessage.ERROR_CODE_ROUTES
			   domain:BeeMessage.ERROR_DOMAIN_UNKNOWN
				 desc:@"No routes"];
}

- (void)route:(BeeMessage *)msg
{
	NSArray * array = [_mapping objectForKey:msg.message];
	if ( array && [array count] )
	{
		BeeMessageController *	target = (BeeMessageController *)[array objectAtIndex:0];
		SEL						action = (SEL)[[array objectAtIndex:1] unsignedIntValue];

		BOOL flag = [target prehandle:msg];
		if ( flag )
		{
			[target performSelector:action withObject:msg];
//			[target performSelectorInBackground:action withObject:msg];

			[target posthandle:msg];
		}
	}
	else
	{
		BOOL flag = [self prehandle:msg];
		if ( flag )
		{
			BOOL handled = NO;
			
			NSArray * parts = [msg.message componentsSeparatedByString:@"."];
			if ( parts && parts.count )
			{
				NSString * methodName = parts.lastObject;
				if ( methodName && methodName.length )
				{
					NSString *	selectorName = [methodName stringByAppendingString:@":"];
					SEL			selector = NSSelectorFromString(selectorName);
					
					if ( [self respondsToSelector:selector] )
					{
						[self performSelector:selector withObject:msg];
						handled = YES;
					}
				}
			}
			
			if ( NO == handled )
			{
				[self index:msg];
			}
			
			[self posthandle:msg];
		}
	}
}

- (void)map:(NSString *)name action:(SEL)action
{
	[self map:name action:action target:self];
}

- (void)map:(NSString *)name action:(SEL)action target:(id)target
{
	NSArray * array = [NSArray arrayWithObjects:target, [NSNumber numberWithUnsignedLongLong:(NSUInteger)action], nil];
	[_mapping setObject:array forKey:name];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( BeeMessageController )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

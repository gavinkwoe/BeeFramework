//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  Bee_Controller.h
//

#import "Bee_Precompile.h"
#import "Bee_Core.h"
#import "Bee_Message.h"
#import "Bee_MessageQueue.h"
#import "Bee_Controller.h"

#import "JSONKit.h"
#import <objc/runtime.h>

#pragma mark -

@implementation BeeController

static NSMutableArray * __subControllers = nil;

@synthesize prefix = _prefix;
@synthesize mapping = _mapping;

DEF_SINGLETON( BeeController );

+ (NSString *)MESSAGE
{
	return [self MESSAGE];
}

+ (NSString *)MESSAGE_TYPE
{
	return [NSString stringWithFormat:@"message.%@", [self description]];
}

+ (BeeController *)routes:(NSString *)message
{
	BeeController * controller = nil;

	if ( __subControllers.count )
	{
		for ( BeeController * subController in __subControllers )
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
				if ( class_respondsToSelector( rtti, @selector(sharedInstance) ) )
				{
					controller = [rtti sharedInstance];
				}
				else
				{
					controller = [[[rtti alloc] init] autorelease];
				}
				
				if ( controller )
				{
					NSAssert( [message hasPrefix:controller.prefix], @"wrong prefix" );
					
					if ( NO == [__subControllers containsObject:controller] )
					{
						[__subControllers addObject:controller];
					}
				}
			}
		}
	}
	
	if ( nil == controller )
	{
		controller = [BeeController sharedInstance];
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

		self.mapping = [NSMutableDictionary dictionary];
		self.prefix = [NSString stringWithFormat:@"message.%@", [[self class] description]];

		[self load];

		if ( NO == [__subControllers containsObject:self] )
		{
			[__subControllers addObject:self];			
		}
	}
	
	return self;
}

- (void)dealloc
{	
	if ( [__subControllers containsObject:self] )
	{	
		[__subControllers removeObject:self];
	}

	[self unload];

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

- (void)index:(BeeMessage *)msg
{
	CC( @"unknown message '%@'", msg.message );

	[msg setLastError:BeeMessage.ERROR_CODE_ROUTES
			   domain:BeeMessage.ERROR_DOMAIN_UNKNOWN
				 desc:@"No routes"];
}

- (void)route:(BeeMessage *)msg
{
	NSArray * array = [_mapping objectForKey:msg.message];
	if ( array && [array count] )
	{
		id target = [array objectAtIndex:0];
		SEL action = (SEL)[[array objectAtIndex:1] unsignedIntValue];
		
		[target performSelector:action withObject:msg];
//		[target performSelectorInBackground:action withObject:msg];
	}
	else
	{
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
					return;
				}
			}
		}

		[self index:msg];
	}
}

- (void)map:(NSString *)name action:(SEL)action
{
	[self map:name action:action target:self];
}

- (void)map:(NSString *)name action:(SEL)action target:(id)target
{
	NSArray * array = [NSArray arrayWithObjects:target, [NSNumber numberWithUnsignedInt:(NSUInteger)action], nil];
	[_mapping setObject:array forKey:name];
}

@end

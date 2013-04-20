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
//  NSObject+BeeNotification.m
//

#import "Bee_Precompile.h"
#import "Bee_Log.h"
#import "NSObject+BeeNotification.h"

#pragma mark -

@implementation NSNotification(BeeNotification)

- (BOOL)is:(NSString *)name
{
	return [self.name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
	return [self.name hasPrefix:prefix];
}

@end

#pragma mark -

@implementation NSObject(BeeNotification)

+ (NSString *)NOTIFICATION
{
	return [self NOTIFICATION_TYPE];
}

+ (NSString *)NOTIFICATION_TYPE
{
	return [NSString stringWithFormat:@"notify.%@.", [self description]];
}

- (void)handleNotification:(NSNotification *)notification
{
}

- (void)observeNotification:(NSString *)name
{
	NSArray * array = [name componentsSeparatedByString:@"."];
	if ( array && array.count > 1 )
	{
//		NSString * prefix = (NSString *)[array objectAtIndex:0];
		NSString * clazz = (NSString *)[array objectAtIndex:1];
		NSString * name = (NSString *)[array objectAtIndex:2];

	#if defined(__BEE_SELECTOR_STYLE2__) && __BEE_SELECTOR_STYLE2__
		{
			NSString * selectorName;
			SEL selector;

			selectorName = [NSString stringWithFormat:@"handleNotification_%@_%@:", clazz, name];
			selector = NSSelectorFromString(selectorName);
			
			if ( [self respondsToSelector:selector] )
			{
				[[NSNotificationCenter defaultCenter] addObserver:self
														 selector:selector
															 name:name
														   object:nil];
				return;
			}

			selectorName = [NSString stringWithFormat:@"handleNotification_%@:", clazz];
			selector = NSSelectorFromString(selectorName);
			
			if ( [self respondsToSelector:selector] )
			{
				[[NSNotificationCenter defaultCenter] addObserver:self
														 selector:selector
															 name:name
														   object:nil];
				return;
			}
		}
	#endif	// #if defined(__BEE_SMART_SELECTOR2__) && __BEE_SMART_SELECTOR2__
		
	#if defined(__BEE_SELECTOR_STYLE1__) && __BEE_SELECTOR_STYLE1__
		{
			// TODO:
		}
	#endif	// #if defined(__BEE_SMART_SELECTOR1__) && __BEE_SMART_SELECTOR1__
	}

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleNotification:)
												 name:name
											   object:nil];
}

- (void)unobserveNotification:(NSString *)name
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:name
												  object:nil];
}

- (void)unobserveAllNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)postNotification:(NSString *)name
{
	CC( @"notification, %@", name );
	
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
	return YES;
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
	return YES;
}

@end

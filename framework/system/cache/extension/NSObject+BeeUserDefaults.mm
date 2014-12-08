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

#import "NSObject+BeeUserDefaults.h"
#import "Bee_UserDefaults.h"
#import "Bee_SystemInfo.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(BeeUserDefaults)

+ (NSString *)persistenceKey:(NSString *)key
{
	if ( key )
	{
		key = [NSString stringWithFormat:@"%@.%@", [self description], key];
	}
	else
	{
		key = [NSString stringWithFormat:@"%@", [self description]];
	}
	
	key = [key stringByReplacingOccurrencesOfString:@"." withString:@"_"];
	key = [key stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
	key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	
	return key.uppercaseString;
}

+ (id)userDefaultsRead:(NSString *)key
{
	if ( nil == key )
		return nil;

	key = [self persistenceKey:key];
	
	return [[BeeUserDefaults sharedInstance] objectForKey:key];
}

+ (void)userDefaultsWrite:(id)value forKey:(NSString *)key
{
	if ( nil == key || nil == value )
		return;
	
	key = [self persistenceKey:key];
	
	[[BeeUserDefaults sharedInstance] setObject:value forKey:key];
}

+ (void)userDefaultsRemove:(NSString *)key
{
	if ( nil == key )
		return;

	key = [self persistenceKey:key];
	
	[[BeeUserDefaults sharedInstance] removeObjectForKey:key];
}

- (id)userDefaultsRead:(NSString *)key
{
	return [[self class] userDefaultsRead:key];
}

- (void)userDefaultsWrite:(id)value forKey:(NSString *)key
{
	[[self class] userDefaultsWrite:value forKey:key];
}

- (void)userDefaultsRemove:(NSString *)key
{
	[[self class] userDefaultsRemove:key];
}

+ (id)readObject
{
	return [self readObjectForKey:nil];
}

+ (id)readObjectForKey:(NSString *)key
{
	key = [self persistenceKey:key];
	
	id value = [[BeeUserDefaults sharedInstance] objectForKey:key];
	if ( value )
	{
		return [self objectFromAny:value];
	}

	return nil;
}

+ (void)saveObject:(id)obj
{
	[self saveObject:obj forKey:nil];
}

+ (void)saveObject:(id)obj forKey:(NSString *)key
{
	if ( nil == obj )
		return;
	
	key = [self persistenceKey:key];
	
	NSString * value = [obj objectToString];
	if ( value && value.length )
	{
		[[BeeUserDefaults sharedInstance] setObject:value forKey:key];
	}
	else
	{
		[[BeeUserDefaults sharedInstance] removeObjectForKey:key];
	}
}

+ (void)removeObject
{
	[self removeObjectForKey:nil];
}

+ (void)removeObjectForKey:(NSString *)key
{
	key = [self persistenceKey:key];

	[[BeeUserDefaults sharedInstance] removeObjectForKey:key];
}

+ (id)readFromUserDefaults:(NSString *)key
{
	if ( nil == key )
		return nil;
	
	NSString * jsonString = [self userDefaultsRead:key];
	if ( nil == jsonString || NO == [jsonString isKindOfClass:[NSString class]] )
		return nil;

	NSObject * decodedObject = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:nil];
	if ( nil == decodedObject )
		return nil;
	
	return [self objectFromAny:decodedObject];
}

- (id)readFromUserDefaults:(NSString *)key
{
	id object = [[self class] readFromUserDefaults:key];
	if ( nil == object )
	{
		return self;
	}
	
	if ( [self isKindOfClass:[NSNumber class]] )
	{
		return object;
	}
	else if ( [self isKindOfClass:[NSString class]] )
	{
		return object;
	}
	else if ( [self isKindOfClass:[NSArray class]] )
	{
		return object;
	}
	else if ( [self isKindOfClass:[NSDictionary class]] )
	{
		return object;
	}
	else if ( [self isKindOfClass:[NSDate class]] )
	{
		return object;
	}
	else if ( [self isKindOfClass:[NSObject class]] )
	{
		return object;
	}
	else if ( [self isKindOfClass:[NSMutableArray class]] )
	{
		NSMutableArray * mutableArray = (NSMutableArray *)self;
		[mutableArray addObjectsFromArray:object];
		return self;
	}
	else if ( [self isKindOfClass:[NSMutableDictionary class]] )
	{
		NSMutableDictionary * mutableDict = (NSMutableDictionary *)self;
		[mutableDict addEntriesFromDictionary:object];
		return self;
	}
	else
	{
		[self copyPropertiesFrom:object];
		return self;
	}
}

- (void)saveToUserDefaults:(NSString *)key
{
	if ( nil == key )
		return;
	
	NSString * jsonString = [self objectToString];
	if ( nil == jsonString || 0 == jsonString.length )
		return;

	[self userDefaultsWrite:jsonString forKey:key];
}

- (void)removeFromUserDefaults:(NSString *)key
{
	[[self class] userDefaultsRemove:key];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSObject_BeeUserDefaults )
{
	[self userDefaultsWrite:@"value" forKey:@"key"];
	
	NSString * value = [self userDefaultsRead:@"key"];
	ASSERT( nil != value && [value isEqualToString:@"value"] );

	[self userDefaultsRemove:@"key"];

	NSString * value2 = [self userDefaultsRead:@"key"];
	ASSERT( nil == value2 );
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

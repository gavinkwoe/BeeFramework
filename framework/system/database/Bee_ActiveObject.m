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

#import "Bee_Precompile.h"
#import "Bee_ActiveObject.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	__ID_AS_KEY__
#define __ID_AS_KEY__			(__ON__)	// 默认使用.id做为主键

#undef	__AUTO_PRIMARY_KEY__
#define __AUTO_PRIMARY_KEY__	(__ON__)	// 默认使用第一个NSNumber类型的字段做为主键

#pragma mark -

@implementation BeeNonValue

+ (BeeNonValue *)value
{
	static BeeNonValue * __value = nil;
	
	if ( nil == __value )
	{
		__value = [[BeeNonValue alloc] init];
	}
	
	return __value;
}

@end

#pragma mark -

@implementation BeeActiveObject : NSObject

- (NSString *)description
{
	NSMutableString * desc = [NSMutableString string];
	
	Class rootClass = [BeeActiveObject class];

	for ( Class clazzType = [self class];; )
	{
		if ( clazzType == rootClass )
			break;
		
		unsigned int		propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
		
		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			NSObject *		propertyValue = [self valueForKey:propertyName];

			[desc appendString:[propertyValue description]];
			[desc appendString:@"\n"];
		}

		free( properties );
		
		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}
	
	return [super description];
}

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark -

@interface NSObject(BeeActiveObjectPrivate)

+ (NSString *)keyPathFromString:(NSString *)path;

+ (void)addProtperty:(NSString *)name
			  atPath:(NSString *)path
			forClass:(NSString *)className
		 associateTo:(NSString *)domain
		defaultValue:(id)value
				 key:(BOOL)key
			 isArray:(BOOL)isArray
		isDictionary:(BOOL)isDictionary;

@end

#pragma mark -

@implementation NSObject(BeeActiveObject)

static NSMutableDictionary * __primaryKeys = nil;
static NSMutableDictionary * __properties = nil;
static NSMutableDictionary * __usingAI = nil;
static NSMutableDictionary * __usingUN = nil;
static NSMutableDictionary * __usingJSON = nil;
static NSMutableDictionary * __mapped = nil;

#pragma mark -

+ (NSString *)keyPathFromString:(NSString *)path
{
	NSString *	keyPath = [path stringByReplacingOccurrencesOfString:@"/" withString:@"."];
	NSRange		range = NSMakeRange( 0, 1 );
	
	if ( [[keyPath substringWithRange:range] isEqualToString:@"."] )
	{
		keyPath = [keyPath substringFromIndex:1];
	}
	
	return keyPath;
}

#pragma mark -

+ (BOOL)isRelationMapped
{
	if ( nil == __mapped )
		return NO;
	
	NSString * className = [self description];
	NSNumber * mapped = [__mapped objectForKey:className];
	if ( mapped && mapped.boolValue )
		return YES;

	return NO;
}

+ (void)mapRelation
{
	[self mapRelationForClass:self];
}

+ (void)mapRelationForClass:(Class)rootClass
{
	if ( self == rootClass )
		return;
	
	if ( nil == __mapped )
	{
		__mapped = [[NSMutableDictionary alloc] init];
	}

	NSString * className = [self description];
	NSNumber * mapped = [__mapped objectForKey:className];
	if ( mapped && mapped.boolValue )
		return;

#if (__ON__ == __ID_AS_KEY__)
	BOOL foundPrimaryKey = NO;
#endif	// #if (__ON__ == __ID_AS_KEY__)
	
	for ( Class clazzType = self; clazzType != rootClass; )
	{
		unsigned int		propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
		
		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			
			if ( [propertyName hasSuffix:@"_"] )
				continue;
			
			const char *	attr = property_getAttributes(properties[i]);
			NSUInteger		type = [BeeTypeEncoding typeOf:attr];
			
			if ( BeeTypeEncoding.NSNUMBER == type )
			{
				BOOL isPrimaryKey = NO;
				
			#if (__ON__ == __ID_AS_KEY__)
				if ( NO == foundPrimaryKey && NSOrderedSame == [propertyName compare:@"id" options:NSCaseInsensitiveSearch] )
				{
					isPrimaryKey = YES;
					foundPrimaryKey = YES;
				}
			#endif	// #if (__ON__ == __ID_AS_KEY__)
				
			#if (__ON__ == __AUTO_PRIMARY_KEY__ )
				if ( NO == foundPrimaryKey )
				{
					isPrimaryKey = YES;
					foundPrimaryKey = YES;
				}
			#endif	// #if (__ON__ == __AUTO_PRIMARY_KEY__ )
				
				if ( isPrimaryKey )
				{
					[self mapPropertyAsKey:propertyName];
				}
				else
				{
					[self mapProperty:propertyName defaultValue:__INT(0)];
				}
			}
			else if ( BeeTypeEncoding.NSSTRING == type )
			{
				[self mapProperty:propertyName defaultValue:@""];
			}
			else if ( BeeTypeEncoding.NSDATE == type )
			{
				[self mapProperty:propertyName defaultValue:[NSDate dateWithTimeIntervalSince1970:0]];
			}
			else if ( BeeTypeEncoding.NSDICTIONARY == type )
			{
				[self mapPropertyAsDictionary:propertyName defaultValue:[NSMutableDictionary dictionary]];
			}
			else if ( BeeTypeEncoding.NSARRAY == type )
			{
				[self mapPropertyAsArray:propertyName defaultValue:[NSMutableArray array]];
			}
			else if ( BeeTypeEncoding.OBJECT == type )
			{
				NSString * attrClassName = [BeeTypeEncoding classNameOfAttribute:attr];
				if ( attrClassName )
				{
					Class class = NSClassFromString( attrClassName );
					if ( class )
					{
						if ( [class isSubclassOfClass:rootClass] )
						{
							[self mapProperty:propertyName forClass:attrClassName defaultValue:nil];
						}
						else
						{
							[self mapProperty:propertyName forClass:attrClassName defaultValue:@""];
						}
					}
				}
			}
		}
		
		free( properties );

		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}
	
	[__mapped setObject:[NSNumber numberWithBool:YES]
				 forKey:className];	
}

+ (void)mapPropertyAsKey:(NSString *)name
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:nil
				   key:YES
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapPropertyAsKey:(NSString *)name defaultValue:(id)value
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:value
				   key:YES
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapPropertyAsKey:(NSString *)name atPath:(NSString *)path
{
	[self addProtperty:name
				atPath:path
			  forClass:nil
		   associateTo:nil
		  defaultValue:nil
				   key:YES
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapPropertyAsKey:(NSString *)name atPath:(NSString *)path defaultValue:(id)value
{
	[self addProtperty:name
				atPath:path
			  forClass:nil
		   associateTo:nil
		  defaultValue:value
				   key:YES
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapProperty:(NSString *)name
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:nil
				   key:NO
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapProperty:(NSString *)name defaultValue:(id)value
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:value
				   key:NO
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapProperty:(NSString *)name atPath:(NSString *)path
{
	[self addProtperty:name
				atPath:path
			  forClass:nil
		   associateTo:nil
		  defaultValue:nil
				   key:NO
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapProperty:(NSString *)name atPath:(NSString *)path defaultValue:(id)value
{
	[self addProtperty:name
				atPath:path
			  forClass:nil
		   associateTo:nil
		  defaultValue:value
				   key:NO
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapProperty:(NSString *)name forClass:(NSString *)className
{
	[self addProtperty:name
				atPath:nil
			  forClass:className
		   associateTo:nil
		  defaultValue:nil
				   key:NO
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapProperty:(NSString *)name forClass:(NSString *)className defaultValue:(id)value
{
	[self addProtperty:name
				atPath:nil
			  forClass:className
		   associateTo:nil
		  defaultValue:value
				   key:NO
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapProperty:(NSString *)name forClass:(NSString *)className atPath:(NSString *)path
{
	[self addProtperty:name
				atPath:path
			  forClass:className
		   associateTo:nil
		  defaultValue:nil
				   key:NO
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapProperty:(NSString *)name forClass:(NSString *)className atPath:(NSString *)path defaultValue:(id)value
{
	[self addProtperty:name
				atPath:path
			  forClass:className
		   associateTo:nil
		  defaultValue:value
				   key:NO
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapProperty:(NSString *)name associateTo:(NSString *)domain
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:domain
		  defaultValue:nil
				   key:NO
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapProperty:(NSString *)name associateTo:(NSString *)domain defaultValue:(id)value
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:domain
		  defaultValue:value
				   key:NO
			   isArray:NO
		  isDictionary:NO];
}

+ (void)mapPropertyAsArray:(NSString *)name forClass:(NSString *)className
{
	[self addProtperty:name
				atPath:nil
			  forClass:className
		   associateTo:nil
		  defaultValue:nil
				   key:NO
			   isArray:YES
		  isDictionary:NO];
}

+ (void)mapPropertyAsArray:(NSString *)name forClass:(NSString *)className defaultValue:(id)value
{
	[self addProtperty:name
				atPath:nil
			  forClass:className
		   associateTo:nil
		  defaultValue:value
				   key:NO
			   isArray:YES
		  isDictionary:NO];
}

+ (void)mapPropertyAsArray:(NSString *)name
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:nil
				   key:NO
			   isArray:YES
		  isDictionary:NO];
}

+ (void)mapPropertyAsArray:(NSString *)name defaultValue:(id)value
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:value
				   key:NO
			   isArray:YES
		  isDictionary:NO];	
}

+ (void)mapPropertyAsDictionary:(NSString *)name
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:nil
				   key:NO
			   isArray:NO
		  isDictionary:YES];
}

+ (void)mapPropertyAsDictionary:(NSString *)name defaultValue:(id)value
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:value
				   key:NO
			   isArray:NO
		  isDictionary:YES];
}

+ (void)addProtperty:(NSString *)name
			  atPath:(NSString *)path
			forClass:(NSString *)className
		 associateTo:(NSString *)domain
		defaultValue:(id)value
				 key:(BOOL)key
			 isArray:(BOOL)isArray
		isDictionary:(BOOL)isDictionary
{
	// add primary key

	if ( key )
	{
		if ( nil == __primaryKeys )
		{
			__primaryKeys = [[NSMutableDictionary alloc] init];
		}
		
		[__primaryKeys setObject:name forKey:[self description]];
	}

	// add property
	
	if ( nil == __properties )
	{
		__properties = [[NSMutableDictionary alloc] init];
	}

	NSMutableDictionary * propertySet = self.activePropertySet;
	if ( propertySet )
	{
		NSMutableDictionary * property = [propertySet objectForKey:name];
		if ( nil == property )
		{
			property = [NSMutableDictionary dictionary];
			[propertySet setObject:property forKey:name];
		}
		
		if ( property )
		{
			[property setObject:name forKey:@"name"];			
			[property setObject:(key ? @"YES" : @"NO") forKey:@"key"];
			[property setObject:[self fieldNameForIdentifier:name] forKey:@"field"];
			[property setObject:[self description] forKey:@"byClass"];
			
			if ( domain )
			{
				NSArray * components = [domain componentsSeparatedByString:@"."];
				if ( components.count >= 2 )
				{
					NSString * className = [components objectAtIndex:0];
					NSString * propertyName = [components objectAtIndex:1];
					
					[property setObject:className forKey:@"associateClass"];
					[property setObject:propertyName forKey:@"associateProperty"];
				}
				else
				{
					[property setObject:domain forKey:@"associateClass"];
				}
			}

			if ( className )
			{
				[property setObject:className forKey:@"className"];
			}

			path = path ? [self keyPathFromString:path] : name;
			if ( path )
			{
				[property setObject:path forKey:@"path"];
			}

			if ( value )
			{
				[property setObject:value forKey:@"value"];
			}
			else
			{
				[property setObject:[BeeNonValue value] forKey:@"value"];
			}
			
			if ( isArray )
			{
				[property setObject:__BOOL(YES) forKey:@"isArray"];
			}

			if ( isDictionary )
			{
				[property setObject:__BOOL(YES) forKey:@"isDictionary"];
			}
		}
	}
}

#pragma mark -

+ (NSString *)mapTableName
{
	return [NSString stringWithUTF8String:class_getName(self)];
}

#pragma mark -

+ (void)useAutoIncrement
{
	[self useAutoIncrementFor:self];
}

+ (void)useAutoIncrementFor:(Class)clazz
{
	if ( nil == __usingAI )
	{
		__usingAI = [[NSMutableDictionary alloc] init];
	}
	
	[__usingAI setObject:__INT(YES) forKey:[clazz description]];
}

+ (BOOL)usingAutoIncrement
{
	return [self usingAutoIncrementFor:self];
}

+ (BOOL)usingAutoIncrementFor:(Class)clazz
{
	if ( nil == __usingAI )
		return NO;
	
	NSNumber * flag = [__usingAI objectForKey:[clazz description]];
	if ( flag )
		return flag.boolValue;
	
	return NO;
}

+ (void)useAutoIncrementFor:(Class)clazz andProperty:(NSString *)name
{
	if ( nil == __usingAI )
	{
		__usingAI = [[NSMutableDictionary alloc] init];
	}
	
	NSString * key = [NSString stringWithFormat:@"%@.%@", [clazz description], name];
	[__usingAI setObject:__INT(YES) forKey:key];
}

+ (BOOL)usingAutoIncrementFor:(Class)clazz andProperty:(NSString *)name
{
	if ( nil == __usingAI )
		return NO;

	NSString * key = [NSString stringWithFormat:@"%@.%@", [clazz description], name];
	NSNumber * flag = [__usingAI objectForKey:key];
	if ( flag )
		return flag.boolValue;

	return NO;
}

+ (void)useAutoIncrementForProperty:(NSString *)name
{
	return [self useAutoIncrementFor:self andProperty:name];
}

+ (BOOL)usingAutoIncrementForProperty:(NSString *)name
{
	return [self usingAutoIncrementFor:self andProperty:name];
}

+ (void)useUniqueFor:(Class)clazz andProperty:(NSString *)name
{
	if ( nil == __usingUN )
	{
		__usingUN = [[NSMutableDictionary alloc] init];
	}

	NSString * key = [NSString stringWithFormat:@"%@.%@", [clazz description], name];
	[__usingUN setObject:__INT(YES) forKey:key];
}

+ (BOOL)usingUniqueFor:(Class)clazz andProperty:(NSString *)name
{
	if ( nil == __usingUN )
		return NO;

	NSString * key = [NSString stringWithFormat:@"%@.%@", [clazz description], name];
	NSNumber * flag = [__usingUN objectForKey:key];
	if ( flag )
		return flag.boolValue;

	return NO;
}

+ (void)useUniqueForProperty:(NSString *)name
{
	[self useUniqueFor:self andProperty:name];
}

+ (BOOL)usingUniqueForProperty:(NSString *)name
{
	return [self usingUniqueFor:self andProperty:name];
}

+ (void)useJSON
{
	[self useJSONFor:self];
}

+ (void)useJSONFor:(Class)clazz
{
	if ( nil == __usingJSON )
	{
		__usingJSON = [[NSMutableDictionary alloc] init];
	}
	
	[__usingJSON setObject:__INT(YES) forKey:[clazz description]];
}

+ (BOOL)usingJSON
{
	return [self usingJSONFor:self];
}

+ (BOOL)usingJSONFor:(Class)clazz
{
	if ( nil == __usingJSON )
		return NO;
	
	NSNumber * flag = [__usingJSON objectForKey:[clazz description]];
	return flag ? flag.boolValue : NO;
}

#pragma mark -

- (NSString *)activePrimaryKey
{
	return [[self class] activePrimaryKey];
}

+ (NSString *)activePrimaryKey
{
	return [self activePrimaryKeyFor:self];
}

+ (NSString *)activePrimaryKeyFor:(Class)clazz
{
	if ( __primaryKeys )
	{
		NSString * key = [clazz description];
		NSString * value = (NSString *)[__primaryKeys objectForKey:key];
		if ( value )
			return value;
	}
	
	return nil;
}

- (NSString *)activeJSONKey
{
	return [[self class] activeJSONKey];
}

+ (NSString *)activeJSONKey
{
	return [self activeJSONKeyFor:self];
}

+ (NSString *)activeJSONKeyFor:(Class)clazz
{
	return nil;
}

- (NSMutableDictionary *)activePropertySet
{
	return [[self class] activePropertySet];
}

+ (NSMutableDictionary *)activePropertySet
{
	return [self activePropertySetFor:self];
}

+ (NSMutableDictionary *)activePropertySetFor:(Class)clazz
{
	if ( nil == __properties )
	{
		__properties = [[NSMutableDictionary alloc] init];
	}
	
	NSString * className = [clazz description];
	NSMutableDictionary * propertySet = [__properties objectForKey:className];
	if ( nil == propertySet )
	{
		propertySet = [NSMutableDictionary dictionary];
		[__properties setObject:propertySet forKey:className];
	}
	
	return propertySet;
}

#pragma mark -

+ (NSString *)fieldNameForIdentifier:(NSString *)string
{
	//	return [string stringByAppendingString:@"_"];
	return string;
}

+ (NSString *)identifierForFieldName:(NSString *)string
{
	//	if ( [string hasSuffix:@"_"] )
	//	{
	//		return [string substringToIndex:string.length - 1];
	//	}
	return string;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeActiveObject )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

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
//  Bee_ActiveBase.h
//

#import "Bee_Precompile.h"
#import "Bee_Log.h"
#import "Bee_Runtime.h"
#import "Bee_Database.h"
#import "Bee_ActiveBase.h"

#import "NSObject+BeeTypeConversion.h"
#import "NSDictionary+BeeExtension.h"
#import "NSNumber+BeeExtension.h"
#import "NSObject+BeeDatabase.h"

#include <objc/runtime.h>

#pragma mark -

@interface NSObject(BeeActiveBasePrivate)
+ (NSString *)keyPath:(NSString *)path;
+ (void)addProtperty:(NSString *)name
			  atPath:(NSString *)path
			forClass:(NSString *)className
		 associateTo:(NSString *)domain
		defaultValue:(id)value
				 key:(BOOL)key;
@end

@implementation NSObject(BeeActiveBase)

static NSMutableDictionary * __primaryKeys = nil;
static NSMutableDictionary * __properties = nil;
static NSMutableDictionary * __usingAI = nil;
static NSMutableDictionary * __usingUN = nil;
static NSMutableDictionary * __usingJSON = nil;
static NSMutableDictionary * __flags = nil;

+ (void)mapRelation
{
}

+ (NSString *)mapTableName
{
	return [NSString stringWithUTF8String:class_getName(self)];
}

+ (void)mapPropertyAsKey:(NSString *)name
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:nil
				   key:YES];
}

+ (void)mapPropertyAsKey:(NSString *)name defaultValue:(id)value
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:value
				   key:YES];
}

+ (void)mapPropertyAsKey:(NSString *)name atPath:(NSString *)path
{
	[self addProtperty:name
				atPath:path
			  forClass:nil
		   associateTo:nil
		  defaultValue:nil
				   key:YES];
}

+ (void)mapPropertyAsKey:(NSString *)name atPath:(NSString *)path defaultValue:(id)value
{
	[self addProtperty:name
				atPath:path
			  forClass:nil
		   associateTo:nil
		  defaultValue:value
				   key:YES];
}

+ (void)mapProperty:(NSString *)name
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:nil
				   key:NO];
}

+ (void)mapProperty:(NSString *)name defaultValue:(id)value
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:nil
		  defaultValue:value
				   key:NO];
}

+ (void)mapProperty:(NSString *)name atPath:(NSString *)path
{
	[self addProtperty:name
				atPath:path
			  forClass:nil
		   associateTo:nil
		  defaultValue:nil
				   key:NO];
}

+ (void)mapProperty:(NSString *)name atPath:(NSString *)path defaultValue:(id)value
{
	[self addProtperty:name
				atPath:path
			  forClass:nil
		   associateTo:nil
		  defaultValue:value
				   key:NO];
}

+ (void)mapProperty:(NSString *)name forClass:(NSString *)className
{
	[self addProtperty:name
				atPath:nil
			  forClass:className
		   associateTo:nil
		  defaultValue:nil
				   key:NO];
}

+ (void)mapProperty:(NSString *)name forClass:(NSString *)className defaultValue:(id)value
{
	[self addProtperty:name
				atPath:nil
			  forClass:className
		   associateTo:nil
		  defaultValue:value
				   key:NO];
}

+ (void)mapProperty:(NSString *)name forClass:(NSString *)className atPath:(NSString *)path
{
	[self addProtperty:name
				atPath:path
			  forClass:className
		   associateTo:nil
		  defaultValue:nil
				   key:NO];
}

+ (void)mapProperty:(NSString *)name forClass:(NSString *)className atPath:(NSString *)path defaultValue:(id)value
{
	[self addProtperty:name
				atPath:path
			  forClass:className
		   associateTo:nil
		  defaultValue:value
				   key:NO];
}

+ (void)mapProperty:(NSString *)name associateTo:(NSString *)domain
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:domain
		  defaultValue:nil
				   key:NO];
}

+ (void)mapProperty:(NSString *)name associateTo:(NSString *)domain defaultValue:(id)value
{
	[self addProtperty:name
				atPath:nil
			  forClass:nil
		   associateTo:domain
		  defaultValue:value
				   key:NO];
}

+ (void)addProtperty:(NSString *)name
			  atPath:(NSString *)path
			forClass:(NSString *)className
		 associateTo:(NSString *)domain
		defaultValue:(id)value
				 key:(BOOL)key
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
			[property setObject:[BeeDatabase fieldNameForIdentifier:name] forKey:@"field"];
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

			path = path ? [self keyPath:path] : name;
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
				[property setObject:[NonValue value] forKey:@"value"];
			}
		}
	}
}

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

+ (NSString *)keyPath:(NSString *)path
{
	NSString *	keyPath = [path stringByReplacingOccurrencesOfString:@"/" withString:@"."];
	NSRange		range = NSMakeRange( 0, 1 );
	
	if ( [[keyPath substringWithRange:range] isEqualToString:@"."] )
	{
		keyPath = [keyPath substringFromIndex:1];
	}
	
	return keyPath;
}

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

+ (void)prepareOnceWithRootClass:(Class)rootClass
{
	if ( nil == __flags )
	{
		__flags = [[NSMutableDictionary alloc] init];
	}
	
	NSString * className = [self description];
	NSNumber * flag = [__flags objectForKey:className];
	if ( nil == flag || NO == flag.boolValue )
	{
	// Step1, map relation between property and field
		
		[self mapRelation];
		
	// Step2, create table
		
		[NSObject DB]
		.TABLE( self.tableName )
		.FIELD( self.activePrimaryKey, @"INTEGER" ).UNIQUE().PRIMARY_KEY();

		if ( [self usingAutoIncrement] )
		{
			[NSObject DB].AUTO_INREMENT();
		}

		if ( [self usingJSON] )
		{
			[NSObject DB]
			.TABLE( self.tableName )
			.FIELD( self.activeJSONKey, @"TEXT" ).DEFAULT( @"" );
		}

		NSDictionary * propertySet = self.activePropertySet;
		if ( propertySet && propertySet.count )
		{
			for ( Class clazzType = [self class];; )
			{
				if ( clazzType == rootClass )
					break;
				
				NSUInteger			propertyCount = 0;
				objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
				
				for ( NSUInteger i = 0; i < propertyCount; i++ )
				{
					const char *	name = property_getName(properties[i]);
					NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
					
					NSMutableDictionary * property = [propertySet objectForKey:propertyName];
					if ( property )
					{
						const char *	attr = property_getAttributes(properties[i]);
						NSUInteger		type = [BeeTypeEncoding typeOf:attr];
						
						NSString *		field = [property objectForKey:@"field"];
						NSObject *		value = [property objectForKey:@"value"];
						
						if ( BeeTypeEncoding.NSNUMBER == type )
						{
							[NSObject DB].FIELD( field, @"INTEGER" );
						}
						else if ( BeeTypeEncoding.NSSTRING == type )
						{
							[NSObject DB].FIELD( field, @"TEXT" );
						}
						else if ( BeeTypeEncoding.NSDATE == type )
						{
							[NSObject DB].FIELD( field, @"TEXT" );
						}
//						else if ( BeeTypeEncoding.NSARRAY == type )
//						{
//							[NSObject DB].FIELD( field, @"TEXT" );
//						}
//						else if ( BeeTypeEncoding.NSDICTIONARY == type )
//						{
//							[NSObject DB].FIELD( field, @"TEXT" );
//						}
						else if ( BeeTypeEncoding.OBJECT == type )
						{
							// AR对象只存它的主键

							[NSObject DB].FIELD( field, @"INTEGER" );
						}
						else
						{
							[NSObject DB].FIELD( field, @"INTEGER" );
						}

						if ( [self usingAutoIncrementFor:clazzType andProperty:field] )
						{
							[NSObject DB].AUTO_INREMENT();
						}

						if ( value && NO == [value isKindOfClass:[NonValue class]] )
						{
							[NSObject DB].DEFAULT( value );
						}

						[property setObject:__INT(type) forKey:@"type"];
					}
				}
				
				free( properties );
				
				clazzType = class_getSuperclass( clazzType );
				if ( nil == clazzType )
					break;
			}
		}
			
		[NSObject DB]
		.CREATE_IF_NOT_EXISTS();

	// Step3, do migration if needed

//		"pragma table_info(\"test\")";
//		"alter table \"test\" add column name";

	// Step4, create index
		
		[NSObject DB]
		.TABLE( self.tableName )
		.INDEX_ON( self.activePrimaryKey, nil );
		
	// done
		
		[__flags setObject:__INT(YES) forKey:className];
	}
}

+ (void)resetPrepareFlags
{
	[__flags removeAllObjects];
}

@end

#pragma mark -

@implementation NonValue

+ (NonValue *)value
{
	static NonValue * __value = nil;

	if ( nil == __value )
	{
		__value = [[NonValue alloc] init];
	}

	return __value;
}

@end

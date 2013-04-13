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
//  Bee_ActiveRecord.h
//

#import "Bee_Precompile.h"
#import "Bee_Log.h"
#import "Bee_Runtime.h"

#import "NSObject+BeeTypeConversion.h"
#import "NSDictionary+BeeExtension.h"
#import "NSNumber+BeeExtension.h"
#import "NSObject+BeeDatabase.h"

#import "Bee_Database.h"
#import "Bee_ActiveBase.h"
#import "Bee_ActiveRecord.h"

#import "JSONKit.h"

#include <objc/runtime.h>

#pragma mark -

#undef	__USE_ID_AS_KEY__
#define __USE_ID_AS_KEY__		(1)		// 默认使用.id做为主键

#undef	__USE_FIRST_AS_KEY__
#define __USE_FIRST_AS_KEY__	(1)		// 默认使用第一个NSNumber类型的字段做为主键

#undef	__USE_JSON_DEFAULT__
#define __USE_JSON_DEFAULT__	(1)		// 默认保存JSON

#pragma mark -

@interface BeeActiveRecord()
- (void)initSelf;
- (void)setObservers;
- (void)resetProperties;
- (void)setPropertiesFrom:(NSDictionary *)dict;
+ (void)setAssociateConditions;
+ (void)setHasConditions;
@end

#pragma mark -

@implementation BeeActiveRecord

@dynamic primaryKey;
@dynamic primaryID;

@dynamic EXISTS;
@dynamic LOAD;
@dynamic SAVE;
@dynamic INSERT;
@dynamic UPDATE;
@dynamic DELETE;

@dynamic inserted;
@synthesize changed = _changed;
@synthesize deleted = _deleted;

@dynamic JSON;
@dynamic JSONData;
@dynamic JSONString;

+ (BeeDatabase *)DB
{
	[self prepareOnceWithRootClass:[BeeActiveRecord class]];
	
	return super.DB.CLASS_TYPE( self );
}

+ (NSString *)activePrimaryKeyFor:(Class)clazz
{
	NSString * key = [super activePrimaryKeyFor:clazz];
	if ( nil == key )
	{
		key = @"id";
	}

	return key;
}

+ (NSString *)activeJSONKeyFor:(Class)clazz
{
	NSString * key = [super activeJSONKeyFor:clazz];
	if ( nil == key )
	{
		key = @"JSON";
	}

	return key;
}

+ (void)mapRelation
{
#if defined(__USE_ID_AS_KEY__) && __USE_ID_AS_KEY__
	BOOL foundPrimaryKey = NO;
#endif	// #if defined(__USE_ID_AS_KEY__) && __USE_ID_AS_KEY__
	
	for ( Class clazzType = self;; )
	{
		NSUInteger			propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
		
		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];

			if ( [propertyName hasSuffix:@"_"] )
				continue;

			const char *	attr = property_getAttributes(properties[i]);
			NSUInteger		type = [BeeTypeEncoding typeOf:attr];
			
			NSString *		className = nil;
			BOOL			isActiveRecord = NO;
			
			NSObject *		defaultValue = nil;
			BOOL			isPrimaryKey = NO;

			if ( BeeTypeEncoding.NSNUMBER == type )
			{
			#if defined(__USE_ID_AS_KEY__) && __USE_ID_AS_KEY__
				if ( NO == foundPrimaryKey && NSOrderedSame == [propertyName compare:@"id" options:NSCaseInsensitiveSearch] )
				{
					isPrimaryKey = YES;
					foundPrimaryKey = YES;
				}
			#endif	// #if defined(__USE_ID_AS_KEY__) && __USE_ID_AS_KEY__

			#if defined(__USE_FIRST_AS_KEY__) && __USE_FIRST_AS_KEY__
				if ( NO == foundPrimaryKey )
				{
					isPrimaryKey = YES;
					foundPrimaryKey = YES;					
				}
			#endif	// #if defined(__USE_FIRST_AS_KEY__) && __USE_FIRST_AS_KEY__
				
				if ( isPrimaryKey )
				{
					defaultValue = nil; // __INT(-1);
				}
				else
				{
					defaultValue = __INT(0);
				}
			}
			else if ( BeeTypeEncoding.NSSTRING == type )
			{
				defaultValue = @"";
			}
			else if ( BeeTypeEncoding.NSDATE == type )
			{
				defaultValue = [NSDate dateWithTimeIntervalSince1970:0];
			}
//			else if ( BeeTypeEncoding.NSARRAY == type )
//			{
//				defaultValue = @"";
//			}
//			else if ( BeeTypeEncoding.NSDICTIONARY == type )
//			{
//				defaultValue = @"";
//			}
			else if ( BeeTypeEncoding.OBJECT == type )
			{
				defaultValue = __INT(0); // 嵌套的AR对象的主键

				className = [BeeTypeEncoding classNameOf:attr];
				
				Class class = NSClassFromString( className );
				if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
				{
					isActiveRecord = YES;
				}
			}
			else
			{
				defaultValue = @"";
			}

			if ( isActiveRecord )
			{
				[self mapProperty:propertyName forClass:className atPath:nil defaultValue:defaultValue];
			}
			else
			{
				if ( isPrimaryKey )
				{
					[self mapPropertyAsKey:propertyName atPath:nil defaultValue:defaultValue];
				}
				else
				{
					[self mapProperty:propertyName atPath:nil defaultValue:defaultValue];
				}
			}
		}
		
		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType || clazzType == [BeeActiveRecord class] )
			break;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( _deleted )
		return;
	
	NSDictionary * property = (NSDictionary *)context;
	if ( nil == property )
		return;

	static BOOL __enterred = NO;
	if ( NO == __enterred )
	{
		__enterred = YES;

		NSObject * obj1 = [change objectForKey:@"new"];
		NSObject * obj2 = [change objectForKey:@"old"];
		
		if ( NO == [obj1 isEqual:obj2] )
		{
			_changed = YES;
		}

		NSString * name = [property objectForKey:@"name"];
		NSString * path = [property objectForKey:@"path"];
		NSNumber * type = [property objectForKey:@"type"];

		NSObject * value = [change objectForKey:@"new"]; // [self valueForKey:name];

		if ( object == self )
		{
			// sync property to JSON

	//		NSObject * value = [self valueForKey:name];
			if ( value && NO == [value isKindOfClass:[NonValue class]] )
			{
				if ( BeeTypeEncoding.NSNUMBER == type.intValue )
				{
					value = [value asNSNumber];
				}
				else if ( BeeTypeEncoding.NSSTRING == type.intValue )
				{
					value = [value asNSString];
				}
				else if ( BeeTypeEncoding.NSDATE == type.intValue )
				{
					value = [value asNSString];
				}
				else if ( BeeTypeEncoding.OBJECT == type.intValue )
				{
					// 如果嵌套的AR对象变了，对应替换掉整个JSON
					
					if ( [value isKindOfClass:[BeeActiveRecord class]] )
					{
						value = [(BeeActiveRecord *)value JSON];
					}
					else
					{
						value = nil;
					}
				}
			}

			if ( path && value )
			{
				[_JSON setObject:value atPath:path];
			}
		}
		else if ( object == _JSON )
		{
			// sync JSON to property
			
	//		NSObject * value = [_JSON objectAtPath:path];
			if ( value )
			{
				if ( BeeTypeEncoding.NSNUMBER == type.intValue )
				{
					value = [value asNSNumber];
				}
				else if ( BeeTypeEncoding.NSSTRING == type.intValue )
				{
					value = [value asNSString];
				}
				else if ( BeeTypeEncoding.NSDATE == type.intValue )
				{
					value = [value asNSDate];
				}
				else if ( BeeTypeEncoding.OBJECT == type.intValue )
				{
					// 如果嵌套的JSON对象变了，对应替换AR对象

					NSString * className = [property objectForKey:@"className"];
					if ( className )
					{
						Class class = NSClassFromString( className );
						if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
						{
							value = [class recordWithObject:value];
						}
						else
						{
							value = nil;
						}
					}
					else
					{
						value = nil;
					}
				}
			}

			[self setValue:value forKey:name];
		}
				
		__enterred = NO;
	}
}

- (void)initSelf
{
	[[self class] prepareOnceWithRootClass:[BeeActiveRecord class]];

#if !defined(__USE_JSON_DEFAULT__) || (!__USE_JSON_DEFAULT__)
	if ( [[self class] usingJSON] )
#endif	// #if !defined(__USE_JSON_DEFAULT__) || (!__USE_JSON_DEFAULT__)
	{
		_JSON = [[NSMutableDictionary alloc] init];
	}

	[self resetProperties];
}

- (void)resetProperties
{
	_changed = NO;
	_deleted = NO;
	
	NSMutableDictionary * propertySet = self.activePropertySet;
	if ( nil == propertySet )
		return;
	
	NSString * primaryKey = self.activePrimaryKey;
	if ( primaryKey )
	{
		[self setValue:[NSNumber numberWithInt:-1] forKey:primaryKey];
	}
	
	NSString * JSONKey = self.activeJSONKey;
	if ( _JSON )
	{
		[_JSON removeAllObjects];

		NSDictionary * property = [propertySet objectForKey:JSONKey];
		if ( property )
		{
			NSString * path = [property objectForKey:@"path"];
			[_JSON setObject:[NSNumber numberWithInt:-1] atPath:path];
		}
	}
	
	if ( propertySet && propertySet.count )
	{
		for ( NSString * key in propertySet.allKeys )
		{
			NSDictionary * property = [propertySet objectForKey:key];
			
			NSString * name = [property objectForKey:@"name"];
			NSString * path = [property objectForKey:@"path"];
			NSNumber * type = [property objectForKey:@"type"];
			
			NSObject * json = nil;
			NSObject * value = [property objectForKey:@"value"];
			if ( value && NO == [value isKindOfClass:[NonValue class]] )
			{
				if ( value )
				{
					if ( BeeTypeEncoding.NSNUMBER == type.intValue )
					{
						value = [value asNSNumber];
						json = value;
					}
					else if ( BeeTypeEncoding.NSSTRING == type.intValue )
					{
						value = [value asNSString];
						json = value;
					}
					else if ( BeeTypeEncoding.NSDATE == type.intValue )
					{
						value = [value asNSString];
						json = value;
					}
					else if ( BeeTypeEncoding.OBJECT == type.intValue )
					{
						BeeActiveRecord * arValue = nil;
						
						// 尝试创建默认的AR对象
						NSString * className = [property objectForKey:@"className"];
						if ( className )
						{
							Class class = NSClassFromString( className );
							if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
							{
								NSNumber * primaryKey = [value asNSNumber];
								if ( primaryKey && primaryKey.unsignedIntValue )
								{
									arValue = [class recordWithKey:[value asNSNumber]];
								}
								else
								{
									arValue = [class record];
								}
							}
						}
						
						value = arValue;
						json = [arValue JSON];
					}
				}
				
				[self setValue:value forKey:name];
				
				if ( json )
				{
					[_JSON setObject:json atPath:path];
				}
//				else
//				{
//					[_JSON setObject:nil atPath:path];
//				}
			}
		}
	}
}

- (void)setObservers
{
	NSMutableDictionary * propertySet = self.activePropertySet;
	if ( propertySet && propertySet.count )
	{
		for ( NSString * key in propertySet.allKeys )
		{
			NSDictionary * property = [propertySet objectForKey:key];

			NSString * name = [property objectForKey:@"name"];
			NSString * path = [property objectForKey:@"path"];

			[self addObserver:self
				   forKeyPath:name
					  options:NSKeyValueObservingOptionNew//|NSKeyValueObservingOptionOld
					  context:property];

			[_JSON addObserver:self
					forKeyPath:path
					   options:NSKeyValueObservingOptionNew//|NSKeyValueObservingOptionOld
					   context:property];
		}
	}	
}

- (void)removeObservers
{
	NSMutableDictionary * propertySet = self.activePropertySet;
	if ( propertySet && propertySet.count )
	{
		for ( NSString * key in propertySet.allKeys )
		{
			NSDictionary * property = [propertySet objectForKey:key];
			
			NSString * name = [property objectForKey:@"name"];
			NSString * path = [property objectForKey:@"path"];
			
			[self removeObserver:self forKeyPath:name];
			[_JSON removeObserver:self forKeyPath:path];
		}
	}
}

- (id)init
{
	[BeeDatabase scopeEnter];

	self = [super init];
	if ( self )
	{
		[self initSelf];
		
		_changed = NO;
		_deleted = NO;

		[self setObservers];
		[self load];
	}
	
	[BeeDatabase scopeLeave];

	return self;
}

- (id)initWithObject:(NSObject *)object
{
	[BeeDatabase scopeEnter];

	self = [super init];
	if ( self )
	{
		[self initSelf];
		[self setPrimaryID:[NSNumber numberWithInt:-1]];

		if ( [object isKindOfClass:[NSNumber class]] )
		{
			NSString * primaryKey = self.primaryKey;
			if ( primaryKey )
			{
				BeeDatabase * db = [self class].DB;
				if ( db )
				{
					db.WHERE( self.primaryKey, object ).GET();
					if ( db.succeed )
					{
						NSObject * obj = [db.resultArray objectAtIndex:0];
						if ( [obj isKindOfClass:[NSDictionary class]] )
						{
							[self setDictionary:(NSDictionary *)obj];
							[self setPrimaryID:(NSNumber *)object];
						}
					}
				}
			}
		}
		else if ( [object isKindOfClass:[NSString class]] )
		{
			NSString * json = [(NSString *)object stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
			NSObject * dict = [json objectFromJSONString];
			if ( dict && [dict isKindOfClass:[NSDictionary class]] )
			{
				[self setDictionary:(NSDictionary *)dict];
			}
		}
		else if ( [object isKindOfClass:[NSData class]] )
		{
			NSObject * dict = [(NSData *)object objectFromJSONData];
			if ( dict && [dict isKindOfClass:[NSDictionary class]] )
			{
				[self setDictionary:(NSDictionary *)dict];
			}
		}
		else if ( [object isKindOfClass:[NSDictionary class]] )
		{
			[self setDictionary:(NSDictionary *)object];
		}
		else if ( [object isKindOfClass:[BeeActiveRecord class]] )
		{
			[self setDictionary:((BeeActiveRecord *)object).JSON];
		}
		else
		{
			CC( @"Unknown object type" );
		}

		_changed = NO;
		_deleted = NO;

		[self setObservers];
		[self load];
	}
	
	[BeeDatabase scopeLeave];
	
	return self;
}

- (id)initWithDictionary:(NSDictionary *)otherDictionary
{
	[BeeDatabase scopeEnter];

	self = [super init];
	if ( self )
	{
		[self initSelf];
		[self setDictionary:otherDictionary];

		_changed = NO;
		_deleted = NO;

		[self setObservers];
		[self load];
	}
	
	[BeeDatabase scopeLeave];

	return self;
}

- (id)initWithJSONData:(NSData *)data
{
	[BeeDatabase scopeEnter];
	
	self = [super init];
	if ( self )
	{
		[self initSelf];
		
		NSObject * object = [data objectFromJSONData];
		if ( object && [object isKindOfClass:[NSDictionary class]] )
		{
			[self setDictionary:(NSDictionary *)object];
		}

		_changed = NO;
		_deleted = NO;

		[self setObservers];
		[self load];
	}
	
	[BeeDatabase scopeLeave];
	
	return self;
}

- (id)initWithJSONString:(NSString *)string
{
	[BeeDatabase scopeEnter];
	
	self = [super init];
	if ( self )
	{
		[self initSelf];

		NSObject * object = [string objectFromJSONString];
		if ( object && [object isKindOfClass:[NSDictionary class]] )
		{
			[self setDictionary:(NSDictionary *)object];
		}

		_changed = NO;
		_deleted = NO;

		[self setObservers];
		[self load];
	}
	
	[BeeDatabase scopeLeave];
	
	return self;	
}

+ (id)record
{
	return [[[[self class] alloc] init] autorelease];
}

+ (id)record:(NSObject *)otherObject
{
	if ( [otherObject isKindOfClass:[NSNull class]] )
		return nil;
	
	return [[[[self class] alloc] initWithObject:otherObject] autorelease];
}

+ (id)recordWithKey:(NSNumber *)key
{
	if ( nil == key )
		return nil;

	return [[[[self class] alloc] initWithObject:key] autorelease];
}

+ (id)recordWithObject:(NSObject *)otherObject
{
	if ( [otherObject isKindOfClass:[NSNull class]] )
		return nil;

	return [[[[self class] alloc] initWithObject:otherObject] autorelease];
}

+ (id)recordWithDictionary:(NSDictionary *)dict
{
	return [[[[self class] alloc] initWithDictionary:dict] autorelease];
}

+ (id)recordWithJSONData:(NSData *)data
{
	return [[[[self class] alloc] initWithJSONData:data] autorelease];
}

+ (id)recordWithJSONString:(NSString *)string
{
	return [[[[self class] alloc] initWithJSONString:string] autorelease];
}

- (void)load
{
	
}

- (void)unload
{
	
}

- (void)dealloc
{
//	[self update];

	[self unload];
	[self removeObservers];
	
	[_JSON release];
	
	[super dealloc];
}

- (id)valueForUndefinedKey:(NSString *)key
{
	return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	CC( @"[ERROR] undefined key '%@'", key );
}

- (NSString *)description
{
	NSMutableString *		desc = [NSMutableString string];
	NSMutableDictionary *	propertySet = self.activePropertySet;
	
	[desc appendFormat:@"%s(%p) = { ", class_getName( [self class] ), self];

	BOOL first = YES;
	
	for ( NSString * key in propertySet.allKeys )
	{
		NSDictionary * property = [propertySet objectForKey:key];
		
		NSString * name = [property objectForKey:@"name"];
		NSNumber * type = [property objectForKey:@"type"];
		
		NSObject * value = [self valueForKey:name];
		if ( value && NO == [value isKindOfClass:[NonValue class]] )
		{
			if ( NO == first )
			{
				[desc appendFormat:@", "];
			}

			if ( BeeTypeEncoding.NSNUMBER == type.intValue )
			{
				value = [value asNSNumber];
				
				[desc appendFormat:@"'%@' : %@", name, value];
			}
			else if ( BeeTypeEncoding.NSSTRING == type.intValue )
			{
				value = [value asNSString];
				
				[desc appendFormat:@"'%@' : '%@'", name, value];
			}
			else if ( BeeTypeEncoding.NSDATE == type.intValue )
			{
				value = [value asNSDate];
				
				[desc appendFormat:@"'%@' : '%@'", name, value];
			}
			else
			{
//				value = [value asNSNumber];

				[desc appendFormat:@"'%@' : <%@>", name, value];
			}
			
			first = NO;
		}
	}
	
	[desc appendFormat:@" }"];

	return desc;
}

+ (void)setAssociateConditions
{
	NSMutableDictionary * propertySet = [[self class] activePropertySet];
	
	for ( NSString * key in propertySet.allKeys )
	{
		NSDictionary * property = [propertySet objectForKey:key];
		
		NSString * name = [property objectForKey:@"name"];
		NSNumber * type = [property objectForKey:@"type"];
		
		NSString * associateClass = [property objectForKey:@"associateClass"];
		NSString * associateProperty = [property objectForKey:@"associateProperty"];

		NSMutableArray * values = [NSMutableArray array];

		if ( associateClass )
		{
			Class classType = NSClassFromString( associateClass );
			if ( classType )
			{
				NSArray * objs = [super.DB associateObjectsFor:classType];
				for ( NSObject * obj in objs )
				{
					if ( associateProperty )
					{
						NSObject * value = [obj valueForKey:associateProperty];
						[values addObject:value];
					}
					else
					{
						NSObject * value = [obj valueForKey:classType.activePrimaryKey];
						[values addObject:value];
					}
				}
			}
		}

		for ( NSObject * value in values )
		{
			if ( value && NO == [value isKindOfClass:[NonValue class]] )
			{
				if ( BeeTypeEncoding.NSNUMBER == type.intValue )
				{
					value = [value asNSNumber];
				}
				else if ( BeeTypeEncoding.NSSTRING == type.intValue )
				{
					value = [value asNSString];
				}
				else if ( BeeTypeEncoding.NSDATE == type.intValue )
				{
					value = [[value asNSDate] description];
				}
				else
				{
	//				value = [value asNSNumber];
				}
				
				super.DB.WHERE( name, value );
			}
		}
	}
}

+ (void)setHasConditions
{
	NSArray * objs = [super.DB hasObjects];
	for ( NSObject * obj in objs )
	{
		// TODO:

//		Class clazz = [obj class];
//		super.DB.WHERE( name, value );
	}
}

- (void)setPropertiesFrom:(NSDictionary *)dict
{
// set properties

	NSMutableDictionary * propertySet = self.activePropertySet;
	for ( NSString * key in propertySet.allKeys )
	{
		NSDictionary * property = [propertySet objectForKey:key];
		
		NSString * name = [property objectForKey:@"name"];
		NSString * path = [property objectForKey:@"path"];
		NSNumber * type = [property objectForKey:@"type"];
		
		NSString * associateClass = [property objectForKey:@"associateClass"];
		NSString * associateProperty = [property objectForKey:@"associateProperty"];

		NSMutableArray * values = [NSMutableArray array];

		if ( associateClass )
		{
			Class classType = NSClassFromString( associateClass );
			if ( classType )
			{
				NSArray * objs = [super.DB associateObjectsFor:classType];
				for ( NSObject * obj in objs )
				{
					if ( associateProperty )
					{
						NSObject * value = [obj valueForKey:associateProperty];
						[values addObject:value];
					}
					else
					{
						NSObject * value = [obj valueForKey:classType.activePrimaryKey];
						[values addObject:value];
					}
				}
			}			
		}

		NSObject * value = values.count ? values.lastObject : nil;

		if ( nil == value )
		{
			value = [dict objectAtPath:path];
		}
		
		if ( value && NO == [value isKindOfClass:[NonValue class]] )
		{
			if ( BeeTypeEncoding.NSNUMBER == type.intValue )
			{
				value = [value asNSNumber];
			}
			else if ( BeeTypeEncoding.NSSTRING == type.intValue )
			{
				value = [value asNSString];
			}
			else if ( BeeTypeEncoding.NSDATE == type.intValue )
			{
				value = [value asNSDate];
			}
			else if ( BeeTypeEncoding.OBJECT == type.intValue )
			{
			// set inner AR objects
				
				BeeActiveRecord * record = nil;
				
				NSString * className = [property objectForKey:@"className"];
				if ( className )
				{
					Class class = NSClassFromString( className );
					if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
					{
						record = [class recordWithObject:value];
					}
				}

				value = record;
			}
			else
			{
//				value = [value asNSNumber];
			}

			if ( name && value )
			{
				[self setValue:value forKey:name];
			}
		}
	}
		
// reset flags

	_changed = YES;
	_deleted = NO;
}

- (void)setDictionary:(NSDictionary *)dict
{
	[self resetProperties];
	[self setPropertiesFrom:dict];
	
	[_JSON setDictionary:dict];
}

- (NSDictionary *)JSON
{
	return _JSON;
}

- (void)setJSON:(NSMutableDictionary *)JSON
{
	[self setDictionary:JSON];
}

- (NSData *)JSONData
{
	return [_JSON JSONData];
}

- (void)setJSONData:(NSData *)data
{
	NSObject * object = [data objectFromJSONData];
	if ( object && [object isKindOfClass:[NSDictionary class]] )
	{
		[self setDictionary:(NSDictionary *)object];
	}
}

- (NSString *)JSONString
{
	NSString * json = [_JSON JSONString];
	
	if ( json )
	{
		json = [json stringByReplacingOccurrencesOfString:@"\\\\\\\"" withString:@"\""];
		json = [json stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
	}

	return json;
}

- (void)setJSONString:(NSString *)string
{
	NSObject * object = [string objectFromJSONString];
	if ( object && [object isKindOfClass:[NSDictionary class]] )
	{
		[self setDictionary:(NSDictionary *)object];
	}
}

- (NSDictionary *)JSONDictionary
{
	return [NSMutableDictionary dictionaryWithDictionary:self.JSON];
}

- (NSString *)primaryKey
{
	return self.activePrimaryKey;
}

- (NSNumber *)primaryID
{
	return [self valueForKey:self.activePrimaryKey];
}

- (void)setPrimaryID:(NSNumber *)pid
{
	[self setValue:(pid ? pid : [NSNumber numberWithInt:-1])
			forKey:self.activePrimaryKey];
}

- (BOOL)inserted
{
	NSNumber * number = self.primaryID;
	if ( number && number.intValue >= 0 )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)get
{
	NSString * primaryKey = self.activePrimaryKey;
	if ( nil == primaryKey )
		return NO;
	
	NSNumber * primaryID = [self valueForKey:primaryKey];
	if ( nil == primaryID || primaryID.intValue < 0 )
		return NO;

	super.DB
	.FROM( self.tableName )
	.WHERE( primaryKey, [self valueForKey:primaryKey] )
	.LIMIT( 1 )
	.GET();
	
	if ( super.DB.succeed )
	{
		NSDictionary * dict = [super.DB.resultArray objectAtIndex:0];
		if ( dict )
		{
			[self resetProperties];
			[self setPropertiesFrom:dict];

			NSString * json = [dict objectForKey:self.activeJSONKey];
			if ( json && json.length )
			{
				NSObject * object = [json objectFromJSONString];
				if ( object && [object isKindOfClass:[NSDictionary class]] )
				{
					[_JSON removeAllObjects];
					[_JSON setDictionary:(NSDictionary *)object];
				}
			}
			
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)exists
{
	NSString * primaryKey = self.activePrimaryKey;
	if ( nil == primaryKey )
		return NO;
	
	NSNumber * primaryID = [self valueForKey:primaryKey];
	if ( nil == primaryID || primaryID.intValue < 0 )
		return NO;

	super.DB
	.FROM( self.tableName )
	.WHERE( primaryKey, [self valueForKey:primaryKey] )
	.LIMIT( 1 )
	.COUNT();

	if ( super.DB.succeed && super.DB.resultCount > 0 )
	{
		return YES;
	}

	return NO;
}

- (BOOL)insert
{
	if ( _deleted )
		return NO;
	
// if already inserted into table, no nessecery insert again

	NSString *		primaryKey = self.activePrimaryKey;
//	NSNumber *		primaryID = [self valueForKey:primaryKey];
//	
//	if ( primaryID && primaryID.intValue >= 0 )
//		return NO;

	NSString *		JSONKey = self.activeJSONKey;
	NSDictionary *	propertySet = self.activePropertySet;

// step 1, save inner AR objects
	
	for ( NSString * key in propertySet.allKeys )
	{
		NSDictionary *	property = [propertySet objectForKey:key];
		NSNumber *		type = [property objectForKey:@"type"];
		
		if ( BeeTypeEncoding.OBJECT == type.intValue )
		{
			NSString *	name = [property objectForKey:@"name"];
			NSObject *	value = [self valueForKey:name];
			
			if ( value && [value isKindOfClass:[BeeActiveRecord class]] )
			{
				BeeActiveRecord * record = (BeeActiveRecord *)value;
				[record exists] ? [record update] : [record insert];
			}
		}
	}

// step 2, save this object

	super.DB.FROM( self.tableName );

	for ( NSString * key in propertySet.allKeys )
	{
		NSDictionary * property = [propertySet objectForKey:key];
		
		NSString * name = [property objectForKey:@"name"];
		NSNumber * type = [property objectForKey:@"type"];
		
		NSString * byClass = [property objectForKey:@"byClass"];
		if ( byClass )
		{
			Class byClassType = NSClassFromString( byClass );
			if ( byClassType && [NSObject usingAutoIncrementFor:byClassType andProperty:name] )
			{
				continue;
			}
		}

		if ( [name isEqualToString:JSONKey] )
			continue;

		NSObject * value = [self valueForKey:name];
		if ( value )
		{
			if ( BeeTypeEncoding.NSNUMBER == type.intValue )
			{
				value = [value asNSNumber];

				// bug fix
				if ( [name isEqualToString:primaryKey] && [(NSNumber *)value integerValue] < 0 )
				{
					continue;
				}
			}
			else if ( BeeTypeEncoding.NSSTRING == type.intValue )
			{
				value = [value asNSString];
			}
			else if ( BeeTypeEncoding.NSDATE == type.intValue )
			{
				value = [[value asNSDate] description];
			}
			else if ( BeeTypeEncoding.OBJECT == type.intValue )
			{
				if ( [value isKindOfClass:[BeeActiveRecord class]] )
				{
					BeeActiveRecord * record = (BeeActiveRecord *)value;
					NSString * primaryKey = [value class].activePrimaryKey;
					
					value = [record valueForKey:primaryKey];
				}
				else
				{
					value = nil;
				}
			}
			else
			{
//				value = [value asNSNumber];
			}
			
			if ( name && value )
			{
				super.DB.SET( name, value );
			}
		}
	}
	
	if ( [[self class] usingJSON] )
	{
		super.DB.SET( self.activeJSONKey, self.JSONString );
	}
	
	super.DB.INSERT();

	if ( super.DB.succeed )
	{
		_changed = NO;

		if ( primaryKey )
		{
			[self setValue:[NSNumber numberWithInt:super.DB.insertID] forKey:primaryKey];
		}
		
		return YES;
	}
	
	return NO;
}

- (BOOL)update
{
	if ( _deleted || NO == _changed )
		return NO;

// if already inserted into table, no nessecery insert again

	NSString * primaryKey = self.activePrimaryKey;
	if ( nil == primaryKey )
		return NO;
	
	NSNumber * primaryID = [self valueForKey:primaryKey];
	if ( primaryID && primaryID.intValue < 0 )
		return NO;

	NSString *		JSONKey = self.activeJSONKey;
	NSDictionary *	propertySet = self.activePropertySet;

// step 1, update inner AR objects

	for ( NSString * key in propertySet.allKeys )
	{
		NSDictionary *	property = [propertySet objectForKey:key];
		NSNumber *		type = [property objectForKey:@"type"];
		
		if ( BeeTypeEncoding.OBJECT == type.intValue )
		{
			NSString *	name = [property objectForKey:@"name"];
			NSObject *	value = [self valueForKey:name];
			
			if ( value && [value isKindOfClass:[BeeActiveRecord class]] )
			{
				BeeActiveRecord * record = (BeeActiveRecord *)value;
				[record exists] ? [record update] : [record insert];
			}
		}
	}

// step 2, update this object

	super.DB
	.FROM( self.tableName )
	.WHERE( primaryKey, primaryID );

	for ( NSString * key in propertySet.allKeys )
	{
		NSDictionary * property = [propertySet objectForKey:key];
		
		NSString * name = [property objectForKey:@"name"];
		NSNumber * type = [property objectForKey:@"type"];

		if ( [name isEqualToString:JSONKey] || [name isEqualToString:primaryKey] )
			continue;
		
		NSObject * value = [self valueForKey:name];
		if ( value )
		{
			if ( BeeTypeEncoding.NSNUMBER == type.intValue )
			{
				value = [value asNSNumber];
			}
			else if ( BeeTypeEncoding.NSSTRING == type.intValue )
			{
				value = [value asNSString];
			}
			else if ( BeeTypeEncoding.NSDATE == type.intValue )
			{
				value = [[value asNSDate] description];
			}
			else if ( BeeTypeEncoding.OBJECT == type.intValue )
			{
				if ( [value isKindOfClass:[BeeActiveRecord class]] )
				{
					BeeActiveRecord * record = (BeeActiveRecord *)value;
					NSString * primaryKey = [value class].activePrimaryKey;
					if ( primaryKey )
					{
						value = [record valueForKey:primaryKey];
					}
					else
					{
						value = nil;
					}
				}
				else
				{
					value = nil;
				}
			}
			else
			{
//				value = [value asNSNumber];
			}
			
			super.DB.SET( name, value );
		}
	}

	if ( [[self class] usingJSON] )
	{
		super.DB.SET( self.activeJSONKey, self.JSONString );
	}
	
	super.DB.UPDATE();
	
	if ( super.DB.succeed )
	{
		_changed = NO;
		return YES;
	}

	return NO;
}

- (BOOL)delete
{
	if ( _deleted )
		return NO;
	
	NSString * primaryKey = self.activePrimaryKey;
	if ( nil == primaryKey )
		return NO;
	
	NSObject * primaryID = [self valueForKey:primaryKey];
	if ( nil == primaryID )
		return NO;

	super.DB
	.FROM( self.tableName )
	.WHERE( primaryKey, primaryID )
	.DELETE();

	if ( super.DB.succeed )
	{
		NSString *		JSONKey = self.activeJSONKey;
		NSDictionary *	propertySet = self.activePropertySet;

		[self setValue:[NSNumber numberWithInt:-1] forKey:primaryKey];
		
		for ( NSString * key in propertySet.allKeys )
		{
			NSDictionary * property = [propertySet objectForKey:key];

			NSString * name = [property objectForKey:@"name"];
			if ( [name isEqualToString:JSONKey] )
				continue;

			NSObject * value = [property objectForKey:@"value"];
			if ( value && NO == [value isKindOfClass:[NonValue class]] )
			{
				[self setValue:value forKey:name];
			}
			else
			{
				[self setValue:nil forKey:name];
			}
		}

		[_JSON removeAllObjects];

		_changed = NO;
		_deleted = YES;

//		// 将嵌套的AR对象也删一遍
//		
//		for ( NSString * key in propertySet.allKeys )
//		{
//			NSDictionary *	property = [propertySet objectForKey:key];
//			NSNumber *		type = [property objectForKey:@"type"];
//			
//			if ( BeeTypeEncoding.OBJECT == type.intValue )
//			{
//				NSString *	name = [property objectForKey:@"name"];
//				NSObject *	value = [self valueForKey:name];
//				
//				if ( value && [value isKindOfClass:[BeeActiveRecord class]] )
//				{
//					BeeActiveRecord * record = (BeeActiveRecord *)value;
//					[record delete];
//				}
//			}
//		}

		return YES;
	}
		
	return NO;
}

- (BeeDatabaseBoolBlock)EXISTS
{
	BeeDatabaseBoolBlock block = ^ BOOL ( void )
	{
		return [self exists];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBoolBlock)INSERT
{
	BeeDatabaseBoolBlock block = ^ BOOL ( void )
	{
		return [self insert];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBoolBlock)UPDATE
{
	BeeDatabaseBoolBlock block = ^ BOOL ( void )
	{
		return [self update];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBoolBlock)DELETE
{
	BeeDatabaseBoolBlock block = ^ BOOL ( void )
	{
		return [self delete];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBoolBlock)LOAD
{
	BeeDatabaseBoolBlock block = ^ BOOL ( void )
	{
		return [self get];
		
		return YES;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBoolBlock)SAVE
{
	BeeDatabaseBoolBlock block = ^ BOOL ( void )
	{
		BOOL ret = [self exists];
		if ( NO == ret )
		{
			ret = [self insert];
		}
		else
		{
			ret = [self update];
		}
		return ret;
	};

	return [[block copy] autorelease];
}

@end

#pragma mark -

@implementation NSArray(BeeActiveRecord)

- (NSArray *)activeRecordsFromArray:(Class)clazz
{
	NSMutableArray * array = [NSMutableArray array];
	
	for ( NSObject * obj in self )
	{
		if ( [obj isKindOfClass:[NSDictionary class]] )
		{
			BeeActiveRecord * record = [(NSDictionary *)obj activeRecordFromDictionary:clazz];
			if ( record )
			{
				[array addObject:record];
			}
		}
	}

	return array;
}

@end

#pragma mark -

@implementation NSDictionary(BeeActiveRecord)

- (BeeActiveRecord *)activeRecordFromDictionary:(Class)clazz
{
	if ( NO == [clazz isSubclassOfClass:[BeeActiveRecord class]] )
		return nil;

	return [[[clazz alloc] initWithDictionary:self] autorelease];
}

@end

#pragma mark -

@implementation BeeDatabase(BeeActiveRecord)

@dynamic SAVE;
@dynamic SAVE_DATA;
@dynamic SAVE_STRING;
@dynamic SAVE_ARRAY;
@dynamic SAVE_DICTIONARY;

@dynamic GET_RECORDS;
@dynamic FIRST_RECORD;
@dynamic FIRST_RECORD_BY_ID;
@dynamic LAST_RECORD;
@dynamic LAST_RECORD_BY_ID;

- (BeeDatabaseBlockN)SAVE
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		if ( [first isKindOfClass:[NSArray class]] )
		{
			return [self saveArray:(NSArray *)first];
		}
		else if ( [first isKindOfClass:[NSDictionary class]] )
		{
			return [self saveDictionary:(NSDictionary *)first];
		}
		else if ( [first isKindOfClass:[NSString class]] )
		{
			return [self saveString:(NSString *)first];
		}
		else if ( [first isKindOfClass:[NSData class]] )
		{
			return [self saveData:(NSData *)first];
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SAVE_DATA
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self saveData:(NSData *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SAVE_STRING
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self saveString:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SAVE_ARRAY
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self saveArray:(NSArray *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SAVE_DICTIONARY
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self saveDictionary:(NSDictionary *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseArrayBlock)GET_RECORDS
{
	BeeDatabaseArrayBlock block = ^ NSArray * ( void )
	{
		return [self getRecords];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseObjectBlock)FIRST_RECORD
{
	BeeDatabaseObjectBlock block = ^ NSArray * ( void )
	{
		return [self firstRecord];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseObjectBlockN)FIRST_RECORD_BY_ID
{
	BeeDatabaseObjectBlockN block = ^ NSArray * ( id first, ... )
	{
		return [self firstRecord:nil byID:first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseObjectBlock)LAST_RECORD
{
	BeeDatabaseObjectBlock block = ^ NSArray * ( void )
	{
		return [self lastRecord];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseObjectBlockN)LAST_RECORD_BY_ID
{
	BeeDatabaseObjectBlockN block = ^ NSArray * ( id first, ... )
	{
		return [self lastRecord:nil byID:first];
	};
	
	return [[block copy] autorelease];
}

- (id)saveData:(NSData *)data
{
	NSObject * obj = [data objectFromJSONData];
	if ( nil == obj )
		return self;
	
	if ( [obj isKindOfClass:[NSArray class]] )
	{
		return [self saveArray:(NSArray *)obj];
	}
	else if ( [obj isKindOfClass:[NSDictionary class]] )
	{
		return [self saveDictionary:(NSDictionary *)obj];
	}
	
	return self;
}

- (id)saveString:(NSString *)string
{
	if ( string && [string rangeOfString:@"'"].length > 0 )
	{
		string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"\""];	
	}
		
	NSObject * obj = [string objectFromJSONString];
	if ( nil == obj )
		return self;
	
	if ( [obj isKindOfClass:[NSArray class]] )
	{
		return [self saveArray:(NSArray *)obj];
	}
	else if ( [obj isKindOfClass:[NSDictionary class]] )
	{
		return [self saveDictionary:(NSDictionary *)obj];
	}
	
	return self;
}

- (id)saveArray:(NSArray *)array
{
	self.BATCH_BEGIN();
	
	for ( NSObject * obj in array )
	{
		if ( NO == [obj isKindOfClass:[NSDictionary class]] )
			continue;
		
		[self saveDictionary:(NSDictionary *)obj];
	}

	self.BATCH_END();
	
	return self;
}

- (id)saveDictionary:(NSDictionary *)dict
{
	Class classType = self.classType;
	if ( NO == [classType isSubclassOfClass:[BeeActiveRecord class]] )
		return self;
	
	BeeActiveRecord * record = [dict activeRecordFromDictionary:classType];
	if ( record )
	{
		record.SAVE();
	}

	return self;
}

- (id)firstRecord
{
	return [self firstRecord:nil];
}

- (id)firstRecord:(NSString *)table
{
	NSArray * array = [self getRecords:table limit:1 offset:0];
	if ( array && array.count )
	{
		return [array objectAtIndex:0];
	}

	return nil;
}

- (id)firstRecordByID:(id)key
{
	return [self firstRecord:nil byID:key];
}

- (id)firstRecord:(NSString *)table byID:(id)key
{
	if ( nil == key )
		return nil;
	
	[self __internalResetResult];

	Class classType = [self classType];
	if ( NULL == classType )
		return nil;

	NSString * primaryKey = [BeeActiveRecord activePrimaryKeyFor:classType];
	if ( nil == primaryKey )
		return nil;
	
	[classType setAssociateConditions];
	[classType setHasConditions];
	
	self.WHERE( primaryKey, key ).OFFSET( 0 ).LIMIT( 1 ).GET();
	if ( NO == self.succeed )
		return nil;

	NSArray * array = self.resultArray;
	if ( nil == array || 0 == array.count )
		return nil;
	
	NSDictionary * dict = [array objectAtIndex:0];
	if ( dict )
	{
		return [[[classType alloc] initWithDictionary:dict] autorelease];
	}
	
	return nil;
}

- (id)lastRecord
{
	return [self lastRecord:nil];
}

- (id)lastRecord:(NSString *)table
{
	NSArray * array = [self getRecords:table limit:1 offset:0];
	if ( array && array.count )
	{
		return array.lastObject;
	}
	
	return nil;
}

- (id)lastRecordByID:(id)key
{
	return [self lastRecord:nil byID:key];
}

- (id)lastRecord:(NSString *)table byID:(id)key
{
	if ( nil == key )
		return nil;

	[self __internalResetResult];
	
	Class classType = [self classType];
	if ( NULL == classType )
		return nil;
	
	NSString * primaryKey = [BeeActiveRecord activePrimaryKeyFor:classType];
	if ( nil == primaryKey )
		return nil;
	
	[classType setAssociateConditions];
	[classType setHasConditions];
	
	self.WHERE( primaryKey, key ).OFFSET( 0 ).LIMIT( 1 ).GET();
	if ( NO == self.succeed )
		return nil;
	
	NSArray * array = self.resultArray;
	if ( nil == array || 0 == array.count )
		return nil;
	
	NSDictionary * dict = array.lastObject;
	if ( dict )
	{
		return [[[classType alloc] initWithDictionary:dict] autorelease];
	}
	
	return nil;
}

- (NSArray *)getRecords
{
	return [self getRecords:nil limit:0 offset:0];
}

- (NSArray *)getRecords:(NSString *)table
{
	return [self getRecords:table limit:0 offset:0];
}

- (NSArray *)getRecords:(NSString *)table limit:(NSUInteger)limit
{
	return [self getRecords:table limit:limit offset:0];
}

- (NSArray *)getRecords:(NSString *)table limit:(NSUInteger)limit offset:(NSUInteger)offset
{
	[self __internalResetResult];
	
	Class classType = [self classType];
	if ( NULL == classType )
		return [NSArray array];
	
	NSString * primaryKey = [BeeActiveRecord activePrimaryKeyFor:classType];
	if ( nil == primaryKey )
		return [NSArray array];
	
	self.FROM( table );
	
	if ( offset )
	{
		self.OFFSET( offset );
	}
	
	if ( limit )
	{
		self.LIMIT( limit );
	}

	[classType setAssociateConditions];
	[classType setHasConditions];

	self.GET();
	if ( NO == self.succeed )
		return [NSArray array];
	
	NSArray * array = self.resultArray;
	if ( nil == array || 0 == array.count )
		return [NSArray array];

	NSMutableArray * activeRecords = [[NSMutableArray alloc] init];
	
	for ( NSDictionary * dict in array )
	{
		BeeActiveRecord * object = [[[classType alloc] initWithDictionary:dict] autorelease];
		[activeRecords addObject:object];
	}

	[_resultArray removeAllObjects];
	[_resultArray addObjectsFromArray:activeRecords];
	
	_resultCount = activeRecords.count;
	
	[activeRecords release];
	
	return _resultArray;
}

@end

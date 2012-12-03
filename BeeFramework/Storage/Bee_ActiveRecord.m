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
#import "Bee_ActiveRecord.h"
#import "Bee_Database.h"
#import "NSNumber+BeeExtension.h"

#include <objc/runtime.h>

#pragma mark -

@implementation BeeBaseActiveRecord

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self load];
	}
	return self;
}

- (id)initWithDict:(NSDictionary *)dict
{
	self = [super init];
	if ( self )
	{
		[self load];
	}
	return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	CC( @"[ERROR] undefined key '%@'", key );
}

- (void)bindDict:(NSDictionary *)dict
{
	if ( nil == dict )
		return;
	
	NSArray * allKeys = [dict allKeys];
	for ( NSString * key in allKeys )
	{
		NSObject * value = [dict objectForKey:key];
		if ( value && NO == [value isKindOfClass:[NSNull class]] )
		{
			[self setValue:value forKey:key];	
		}
	}
}

- (void)dealloc
{
	[self unload];
	[super dealloc];
}

- (void)load
{
	
}

- (void)unload
{
	
}

- (BOOL)insert
{
	return NO;
}

- (BOOL)update
{
	return NO;
}

- (BOOL)delete
{
	return NO;
}

@end

#pragma mark -

#define ATTR_TYPE_UNKNOWN	(0)
#define ATTR_TYPE_NUMBER	(2)
#define ATTR_TYPE_TEXT		(3)

#pragma mark -

@interface NonValue : NSObject
+ (NonValue *)value;
@end

@implementation NonValue
+ (NonValue *)value
{
	return [[[NonValue alloc] init] autorelease];
}
@end

#pragma mark -

@interface BeeActiveRecord(Private)

- (void)initSelf;
- (void)bindDict:(NSDictionary *)dict;

+ (BOOL)prepareTableOnce;
+ (BOOL)prepareLayoutOnce;
+ (void)prepare;

+ (NSString *)primaryKey;
+ (NSUInteger)attributeType:(const char *)attr;

+ (NSString *)tableName;
+ (NSArray *)properties;

@end

#pragma mark -

@implementation BeeActiveRecord

@synthesize ID = _ID;

@dynamic INSERT;
@dynamic UPDATE;
@dynamic DELETE;

static NSMutableDictionary * __tableCache = nil;
static NSMutableDictionary * __layoutCache = nil;

static NSMutableDictionary * __primaryKeys = nil;
static NSMutableDictionary * __userProperties = nil;

+ (BeeDatabase *)DB
{
	[self prepare];

	return [super DB].CLASS( self );
}

+ (void)mapRelation
{
}

+ (void)mapPropertyAsKey:(NSString *)name
{
	if ( nil == __primaryKeys )
	{
		__primaryKeys = [[NSMutableDictionary alloc] init];
	}
	
	[__primaryKeys setObject:name forKey:[self description]];
	
	[self mapProperty:name];
}

+ (void)mapProperty:(NSString *)name
{
	[self mapProperty:name defaultValue:nil];
}

+ (void)mapProperty:(NSString *)name defaultValue:(id)value
{
	if ( nil == __userProperties )
	{
		__userProperties = [[NSMutableDictionary alloc] init];
	}

	NSMutableDictionary * relation = (NSMutableDictionary *)[__userProperties objectForKey:[self description]];
	if ( nil == relation )
	{
		relation = [NSMutableDictionary dictionary];
		[__userProperties setObject:relation forKey:[self description]];
	}

	[relation setObject:(value ? value : [NonValue value]) forKey:name];	
}

+ (NSString *)primaryKey
{
	if ( __primaryKeys )
	{
		return (NSString *)[__primaryKeys objectForKey:[self description]];
	}

	return @"id";
}

+ (NSString *)tableNameFor:(Class)clazz
{
	return [NSString stringWithFormat:@"table_%@",[clazz description].lowercaseString];
}

+ (NSString *)tableName
{
	return [NSString stringWithFormat:@"table_%@",[self description].lowercaseString];
}

+ (NSUInteger)attributeType:(const char *)attr
{
	NSAssert( attr[0] == 'T', @"" );
	
	const char * type = &attr[1];
	if ( type[0] == '@' )
	{
		if ( type[1] != '"' )
			return ATTR_TYPE_UNKNOWN;
		
		char typeClazz[64] = { 0 };
		
		const char * clazz = &type[2];
		const char * clazzEnd = strchr( clazz, '"' );
		
		if ( clazzEnd && clazz != clazzEnd )
		{	
			unsigned int size = (unsigned int)(clazzEnd - clazz);
			strncpy( &typeClazz[0], clazz, size );
		}
		
		if ( 0 == strcmp((const char *)typeClazz, "NSNumber") )
		{
			return ATTR_TYPE_NUMBER;
		}
		else if ( 0 == strcmp((const char *)typeClazz, "NSString") )
		{
			return ATTR_TYPE_TEXT;
		}
	}
	else if ( type[0] == '[' )
	{
		return ATTR_TYPE_UNKNOWN;
	}
	else if ( type[0] == '{' )
	{
		return ATTR_TYPE_UNKNOWN;
	}
	else
	{
		if ( type[0] == 'c' || type[0] == 'C' )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else if ( type[0] == 'i' || type[0] == 's' || type[0] == 'l' || type[0] == 'q' )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else if ( type[0] == 'I' || type[0] == 'S' || type[0] == 'L' || type[0] == 'Q' )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else if ( type[0] == 'f' )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else if ( type[0] == 'd' )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else if ( type[0] == 'B' )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else if ( type[0] == 'v' )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else if ( type[0] == '*' )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else if ( type[0] == ':' )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else if ( 0 == strcmp(type, "bnum") )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else if ( type[0] == '^' )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else if ( type[0] == '?' )
		{
			return ATTR_TYPE_UNKNOWN;
		}
		else
		{
			return ATTR_TYPE_UNKNOWN;
		}
	}
	
	return ATTR_TYPE_UNKNOWN;
}

+ (NSArray *)properties
{
	if ( nil == __layoutCache )
		return nil;

	NSDictionary * dict = (NSDictionary *)[__layoutCache objectForKey:[self description]];
	if ( nil == dict )
		return nil;

	return dict.allKeys;
}

+ (BOOL)prepareTableOnce
{
	if ( nil == __tableCache )
	{
		__tableCache = [[NSMutableDictionary alloc] init];
	}

	NSNumber * status = [__tableCache objectForKey:self.tableName];
	if ( nil == status || 0 == status.intValue )
	{
		NSString * className = [self description];
		
		NSDictionary * layout = (NSDictionary *)[__layoutCache objectForKey:className];
		if ( nil == layout )
			return NO;
		
		NSArray * names = layout.allKeys;
		if ( 0 == names.count )
			return NO;

		NSNumber * type = (NSNumber *)[layout objectForKey:self.primaryKey];
		if ( nil == type || ATTR_TYPE_NUMBER != type.intValue )
			return NO;

		NSDictionary * relation = (NSDictionary *)[__userProperties objectForKey:className];
		if ( nil == relation )
			return NO;

		[super DB]
			.TABLE( self.tableName )
			.FIELD( self.primaryKey, @"INTEGER", 12 ).PRIMARY_KEY().AUTO_INREMENT();

		for ( NSString * name in names )
		{
			type = (NSNumber *)[layout objectForKey:name];
			if ( type )
			{
				if ( ATTR_TYPE_NUMBER == type.intValue )
				{
					[super DB].FIELD( name, @"INTEGER" );
				}	
				else if ( ATTR_TYPE_TEXT == type.intValue )
				{
					[super DB].FIELD( name, @"TEXT" );
				}
			}

			if ( relation )
			{
				NSObject * defaultValue = [relation objectForKey:name];	
				if ( defaultValue && NO == [defaultValue isKindOfClass:[NonValue class]] )
				{
					[super DB].DEFAULT( defaultValue );
				}
			}
		}

		[super DB].CREATE_IF_NOT_EXISTS();
		
		[super DB]
			.TABLE( self.tableName )
			.INDEX_ON( self.primaryKey, nil );

		[__tableCache setObject:__INT(1) forKey:self.tableName];
	}

	return YES;
}

+ (BOOL)prepareLayoutOnce
{	
	if ( nil == __layoutCache )
	{
		__layoutCache = [[NSMutableDictionary alloc] init];
	}

	NSString * className = [self description];
	NSMutableDictionary * layout = (NSMutableDictionary *)[__layoutCache objectForKey:className];
	if ( nil == layout )
	{
		[self mapRelation];
		
		NSUInteger			propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( self, &propertyCount );
		
		if ( NULL == properties || 0 == propertyCount )
			return NO;
		
		NSMutableDictionary * relation = [__userProperties objectForKey:className];
		if ( nil == relation )
			return NO;

		layout = [NSMutableDictionary dictionary];

		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char * name = property_getName(properties[i]);
			NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];

			if ( nil == [relation objectForKey:propertyName] )
				continue;
			
			const char * attr = property_getAttributes(properties[i]);
			NSUInteger propertyType = [self attributeType:attr];
			
			[layout setObject:__INT(propertyType) forKey:propertyName];
		}

		[__layoutCache setObject:layout forKey:className];
	}
	
	return YES;
}

+ (void)prepare
{
	if ( [[self description] isEqualToString:[[BeeBaseActiveRecord class] description]] )
		return;
	
	if ( [[self description] isEqualToString:[[BeeActiveRecord class] description]] )
		return;

	[self prepareLayoutOnce];
	[self prepareTableOnce];
}

- (void)initSelf
{	
	[[self class] prepare];

	NSString * className = [[self class] description];
	NSDictionary * relation = (NSDictionary *)[__userProperties objectForKey:className];

	NSString * primaryKey = [self class].primaryKey;
	NSArray * properties = [self class].properties;
	for ( NSString * name in properties )
	{
		if ( [name isEqualToString:primaryKey] )
			continue;

		if ( relation )
		{
			NSObject * defaultValue = [relation objectForKey:name];	
			if ( defaultValue && NO == [defaultValue isKindOfClass:[NonValue class]] )
			{
				[self setValue:defaultValue forKey:name];
			}
		}
	}		
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithDict:(NSDictionary *)dict
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
		[self bindDict:dict];
	}
	return self;	
}

- (void)bindDict:(NSDictionary *)dict
{
	if ( nil == dict )
		return;

	[super bindDict:dict];

	NSNumber * value = [dict objectForKey:[self class].primaryKey];
	if ( value || [value isKindOfClass:[NSNumber class]] )
	{
		self.ID = value;
	}
}

- (void)dealloc
{
	[super dealloc];
}

- (BOOL)insert
{
	NSString * key = [self class].primaryKey;
	if ( nil == key )
		return NO;

	NSArray * properties = [self class].properties;
	if ( nil == properties || 0 == properties.count )
		return NO;

	[super DB].FROM( [self class].tableName );

	for ( NSString * property in properties )
	{
		if ( [property isEqualToString:key] )
			continue;

		NSObject * propertyValue = [self valueForKey:property];
		if ( propertyValue )
		{
			[super DB].SET( property, propertyValue );
		}
	}

	[super DB].INSERT();

	if ( [super DB].succeed )
	{		
		self.ID = __INT( [super DB].insertID );
		
		[self setValue:self.ID forKey:[self class].primaryKey];
		return YES;
	}
	
	return NO;
}

- (BOOL)update
{
	if ( nil == self.ID || self.ID.intValue < 0 )
		return NO;
	
	NSString * key = [self class].primaryKey;
	if ( nil == key )
		return NO;

	NSObject * value = [self valueForKey:key];	
	if ( nil == value )
		return NO;

	NSArray * properties = [self class].properties;
	if ( nil == properties || 0 == properties.count )
		return NO;

	[super DB]
		.FROM( [self class].tableName )
		.WHERE( key, value );
	
	for ( NSString * property in properties )
	{
		if ( [property isEqualToString:key] )
			continue;
		
		NSObject * propertyValue = [self valueForKey:property];
		if ( propertyValue )
		{
			[super DB].SET( property, propertyValue );
		}		
	}
	
	[super DB].UPDATE();

	return [super DB].succeed;
}

- (BOOL)delete
{
	if ( nil == self.ID || self.ID.intValue < 0 )
		return NO;

	NSString * key = [self class].primaryKey;
	if ( nil == key )
		return NO;

	NSObject * value = [self valueForKey:key];	
	if ( nil == value )
		return NO;

	NSArray * properties = [self class].properties;
	if ( nil == properties || 0 == properties.count )
		return NO;

	[super DB]
		.FROM( [self class].tableName )
		.WHERE( key, value )
		.DELETE();
	
	if ( [super DB].succeed )
	{
		for ( NSString * property in properties )
		{
			if ( [property isEqualToString:key] )
				continue;
			
			[self setValue:nil forKey:property];
		}		

		self.ID = __INT( -1 );
		
		[self setValue:self.ID forKey:[self class].primaryKey];
		return YES;
	}
	
	return NO;
}

- (BeeActiveRecordBoolBlock)INSERT
{
	BeeActiveRecordBoolBlock block = ^ BOOL ( void )
	{
		return [self insert];
	};
	
	return [[block copy] autorelease];
}

- (BeeActiveRecordBoolBlock)UPDATE
{
	BeeActiveRecordBoolBlock block = ^ BOOL ( void )
	{
		return [self update];
	};
	
	return [[block copy] autorelease];
}

- (BeeActiveRecordBoolBlock)DELETE
{
	BeeActiveRecordBoolBlock block = ^ BOOL ( void )
	{
		return [self delete];
	};
	
	return [[block copy] autorelease];
}

@end

#pragma mark -

@implementation BeeDatabase(BeeActiveRecord)

@dynamic CLASS;
@dynamic GET_RECORDS;

- (BeeDatabaseBlockN)CLASS
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		[self classType:(Class)first];
		return self;
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

- (void)classType:(Class)clazz
{	
	if ( nil == clazz || NO == [clazz isSubclassOfClass:[BeeActiveRecord class]] )
		return;

	[_userInfo addObject:[clazz description]];

	[super DB].FROM( [BeeActiveRecord tableNameFor:clazz] );
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

	if ( 0 == _userInfo.count )
		return [NSArray array];

	NSString * className = _userInfo.lastObject;
	if ( nil == className || 0 == className.length )
		return [NSArray array];
	
	Class classType = NSClassFromString( className );
	if ( nil == classType || NO == [classType isSubclassOfClass:[BeeActiveRecord class]] )
		return [NSArray array];

	NSArray * array = [[super DB] get:table limit:limit offset:offset];
	if ( nil == array || 0 == array.count )
	{
		return [NSArray array];
	}

	NSMutableArray * activeRecords = [[NSMutableArray alloc] init];
	
	for ( NSDictionary * dict in array )
	{
		BeeActiveRecord * record = [[[classType alloc] initWithDict:dict] autorelease];
		[activeRecords addObject:record];
	}
	
	[_resultArray removeAllObjects];
	[_resultArray addObjectsFromArray:activeRecords];
	
	[activeRecords release];

	return _resultArray;
}

@end

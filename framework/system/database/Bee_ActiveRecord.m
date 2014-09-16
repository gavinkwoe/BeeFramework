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

#import "Bee_ActiveRecord.h"
#import "Bee_ActiveObject.h"
#import "Bee_ActiveBuilder.h"
#import "NSObject+BeeDatabase.h"
#import "NSObject+BeeActiveRecord.h"
#import "BeeDatabase+BeeActiveRecord.h"
#import "NSObject+BeeJSON.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	__PRECREATE_TABLES__
#define __PRECREATE_TABLES__	(__OFF__)

#undef	__JSON_SERIALIZATION__
#define	__JSON_SERIALIZATION__	(__OFF__)

#pragma mark -

@interface BeeActiveRecord()
{
	NSNumber *				_id;

	BOOL					_changed;
	BOOL					_deleting;
	BOOL					_deleted;

#if __JSON_SERIALIZATION__
	NSMutableDictionary *	_JSON;
#endif	// #if __JSON_SERIALIZATION__
}

- (void)initSelf;
- (void)setObservers;
- (void)resetProperties;
- (void)setPropertiesFrom:(NSDictionary *)dict;

@end

#pragma mark -

@implementation BeeActiveRecord

DEF_NUMBER( INVALID_ID,	-1 )

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

+ (BOOL)autoLoad
{
#if defined(__PRECREATE_TABLES__) && __PRECREATE_TABLES__
	
	INFO( @"Loading tables ..." );
	
	[[BeeLogger sharedInstance] indent];
//	[[BeeLogger sharedInstance] disable];

	NSArray * availableClasses = [BeeRuntime allSubClassesOf:[BeeActiveRecord class]];
	
	for ( Class classType in availableClasses )
	{
		if ( [[classType description] hasPrefix:@"NSKVONotifying"] )
			continue;

		[BeeActiveBuilder buildTableFor:classType untilRootClass:[BeeActiveRecord class]];

//		[[BeeLogger sharedInstance] enable];
		INFO( @"%@ loaded", [classType description] );
//		[[BeeLogger sharedInstance] disable];
	}

	[[BeeLogger sharedInstance] unindent];
//	[[BeeLogger sharedInstance] enable];
	
#endif	// #if defined(__PRECREATE_TABLES__) && __PRECREATE_TABLES__
	
	return YES;
}

+ (void)mapRelation
{
	[self mapRelationForClass:[BeeActiveRecord class]];
}

+ (BeeDatabase *)DB
{
	[BeeActiveBuilder buildTableFor:self untilRootClass:[BeeActiveRecord class]];
	
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

#if __JSON_SERIALIZATION__

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

		if ( object == self )	// sync property to JSON
		{
	//		NSObject * value = [self valueForKey:name];
			if ( value && NO == [value isKindOfClass:[BeeNonValue class]] )
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
				else if ( BeeTypeEncoding.NSARRAY == type.intValue )
				{
					NSObject *	defaultValue = [NSMutableArray array];
					NSArray *	array = nil;
					
					if ( [value isKindOfClass:[NSArray class]] )
					{
						array = (NSArray *)value;
					}
					else if ( [value isKindOfClass:[NSString class]] )
					{
						NSObject * obj = [(NSString *)value objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:nil];
						if ( [obj isKindOfClass:[NSArray class]] )
						{
							array = (NSArray *)obj;
						}
					}

					if ( array && array.count )
					{
						NSString * className = [property objectForKey:@"className"];
						if ( className )
						{
							Class class = NSClassFromString( className );
							if ( class )
							{
								NSMutableArray * results = [NSMutableArray array];
								
								if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
								{
									for ( NSObject * elem in array )
									{
										if ( NO == [elem isKindOfClass:[BeeActiveRecord class]] )
											continue;
										
										NSDictionary * dict = [(BeeActiveRecord *)elem JSON];
										if ( dict )
										{
											[results addObject:dict];
										}
									}
								}
								else
								{
									for ( NSObject * elem in array )
									{
										NSDictionary * dict = [elem objectToDictionary];
										if ( dict )
										{
											[results addObject:dict];
										}
									}
								}

								value = results;
							}
							else
							{
								value = defaultValue;
							}
						}
						else
						{
							value = [array asNSMutableArray];
						}
					}
					else
					{
						value = defaultValue;
					}
				}
				else if ( BeeTypeEncoding.NSDICTIONARY == type.intValue )
				{
					value = [value asNSMutableDictionary];	// convert to NSMutableDictionary
				}
				else if ( BeeTypeEncoding.OBJECT == type.intValue )
				{
					value = [value objectToDictionary];		// convert NSObject to NSDictionary
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
				else if ( BeeTypeEncoding.NSARRAY == type.intValue )
				{
					NSMutableArray *	defaultValue = [NSMutableArray array];
					NSArray *			array = nil;
					
					if ( [value isKindOfClass:[NSArray class]] )
					{
						array = (NSArray *)value;
					}
					else if ( [value isKindOfClass:[NSString class]] )
					{
						NSObject * obj = [(NSString *)value objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:nil];
						if ( [obj isKindOfClass:[NSArray class]] )
						{
							array = (NSArray *)obj;
						}
					}

					if ( array && array.count )
					{
						NSString * className = [property objectForKey:@"className"];
						if ( className )
						{
							Class class = NSClassFromString( className );
							if ( class )
							{
								NSMutableArray * results = [NSMutableArray array];

								if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
								{
									for ( NSObject * elem in array )
									{
										BeeActiveRecord * record = [class recordWithObject:elem];
										if ( record )
										{
											[results addObject:record];
										}
									}
								}
								else
								{
									for ( NSObject * elem in array )
									{
										if ( [elem isKindOfClass:[NSDictionary class]] )
										{
											NSObject * newObj = [class objectFromDictionary:elem];
											if ( newObj )
											{
												[results addObject:newObj];
											}
										}
										else if ( [elem isKindOfClass:[NSString class]] )
										{
											NSObject * newObj = [class objectFromString:elem];
											if ( newObj )
											{
												[results addObject:newObj];
											}
										}
									}
								}
								
								value = results;
							}
							else
							{
								value = defaultValue;
							}
						}
						else
						{
							value = [array asNSMutableArray];
						}
					}
					else
					{
						value = defaultValue;
					}
				}
				else if ( BeeTypeEncoding.NSDICTIONARY == type.intValue )
				{
					value = [value asNSMutableDictionary];
				}
				else if ( BeeTypeEncoding.OBJECT == type.intValue )
				{
					NSString * className = [property objectForKey:@"className"];
					if ( className )
					{
						Class class = NSClassFromString( className );
						if ( class )
						{
							if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
							{
								value = [class recordWithObject:value];			// convert value to BeeActiveRecord
							}
							else
							{
								if ( [value isKindOfClass:[NSDictionary class]] )
								{
									value = [class objectFromDictionary:value];	// convert dictionary to NSObject
								}
								else if ( [value isKindOfClass:[NSString class]] )
								{
									value = [class objectFromString:value];		// convert string to NSObject
								}
							}
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

#endif	// #if __JSON_SERIALIZATION__

- (void)initSelf
{
	[BeeActiveBuilder buildTableFor:[self class] untilRootClass:[BeeActiveRecord class]];

#if __JSON_SERIALIZATION__
	if ( [[self class] usingJSON] )
	{
		_JSON = [[NSMutableDictionary alloc] init];
	}
#endif	// #if __JSON_SERIALIZATION__

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
		[self setValue:self.INVALID_ID forKey:primaryKey];
	}

#if __JSON_SERIALIZATION__
	
	NSString * JSONKey = self.activeJSONKey;
	if ( _JSON )
	{
		[_JSON removeAllObjects];

		NSDictionary * property = [propertySet objectForKey:JSONKey];
		if ( property )
		{
			NSString * path = [property objectForKey:@"path"];
			if ( path )
			{
				[_JSON setObject:self.INVALID_ID atPath:path];
			}
		}
	}

#endif	// #if __JSON_SERIALIZATION__

	if ( propertySet && propertySet.count )
	{
		for ( NSString * key in propertySet.allKeys )
		{
			NSDictionary * property = [propertySet objectForKey:key];
			
			NSString * name = [property objectForKey:@"name"];
//			NSString * path = [property objectForKey:@"path"];
			NSNumber * type = [property objectForKey:@"type"];
			
		#if __JSON_SERIALIZATION__
			NSObject * json = nil;
		#endif	// #if __JSON_SERIALIZATION__
			
			NSObject * value = [property objectForKey:@"value"];
			
			if ( value && NO == [value isKindOfClass:[BeeNonValue class]] )
			{
				if ( BeeTypeEncoding.NSNUMBER == type.intValue )
				{
					value = [value asNSNumber];
					
				#if __JSON_SERIALIZATION__
					json = value;
				#endif	// #if __JSON_SERIALIZATION__
				}
				else if ( BeeTypeEncoding.NSSTRING == type.intValue )
				{
					value = [value asNSString];
					
				#if __JSON_SERIALIZATION__
					json = value;
				#endif	// #if __JSON_SERIALIZATION__
				}
				else if ( BeeTypeEncoding.NSDATE == type.intValue )
				{
					value = [value asNSString];
					
				#if __JSON_SERIALIZATION__
					json = value;
				#endif	// #if __JSON_SERIALIZATION__
				}
				else if ( BeeTypeEncoding.NSARRAY == type.intValue )
				{
					NSMutableArray *	defaultValue = [NSMutableArray array];
					NSArray *			array = nil;
					
					if ( [value isKindOfClass:[NSArray class]] )
					{
						array = (NSArray *)value;
					}
					else if ( [value isKindOfClass:[NSString class]] )
					{
						NSObject * obj = [(NSString *)value objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:nil];
						if ( [obj isKindOfClass:[NSArray class]] )
						{
							array = (NSArray *)obj;
						}
					}

					if ( array && array.count )
					{
						value = [array asNSMutableArray];
						
					#if __JSON_SERIALIZATION__
						json = [array objectToString];
					#endif	// #if __JSON_SERIALIZATION__
					}
					else
					{
						value = defaultValue;
						
					#if __JSON_SERIALIZATION__
						json = [defaultValue JSONString];
					#endif	// #if __JSON_SERIALIZATION__
					}
				}
				else if ( BeeTypeEncoding.NSDICTIONARY == type.intValue )
				{
					value = [value asNSMutableDictionary];
					
				#if __JSON_SERIALIZATION__
					json = [(NSDictionary *)value JSONString];
				#endif	// #if __JSON_SERIALIZATION__
				}
				else if ( BeeTypeEncoding.NSDATE == type.intValue )
				{
					value = [value asNSString];
					
				#if __JSON_SERIALIZATION__
					json = value;
				#endif	// #if __JSON_SERIALIZATION__
				}
				else if ( BeeTypeEncoding.OBJECT == type.intValue )
				{
					BeeActiveRecord * arValue = nil;
					
					// 尝试创建默认的AR对象
					NSString * className = [property objectForKey:@"className"];
					if ( className )
					{
						Class class = NSClassFromString( className );
						if ( class )
						{
							if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
							{
								NSNumber * primaryKey = [value asNSNumber];
								if ( primaryKey && primaryKey.unsignedIntValue )
								{
									arValue = [class recordWithKey:[value asNSNumber]];
									
									value = arValue;
									
								#if __JSON_SERIALIZATION__
									json = [arValue JSON];
								#endif	// #if __JSON_SERIALIZATION__
								}
								else
								{
									value = nil;
									
								#if __JSON_SERIALIZATION__
									json = nil;
								#endif	// #if __JSON_SERIALIZATION__
								}

							}
							else
							{
								value = nil;
								
							#if __JSON_SERIALIZATION__
								json = nil;
							#endif	// #if __JSON_SERIALIZATION__
							}
						}
						else
						{
							value = nil;
							
						#if __JSON_SERIALIZATION__
							json = nil;
						#endif	// #if __JSON_SERIALIZATION__
						}
					}
				}

				[self setValue:value forKey:name];
				
			#if __JSON_SERIALIZATION__
				if ( json )
				{
					[_JSON setObject:json atPath:path];
				}
//				else
//				{
//					[_JSON setObject:nil atPath:path];
//				}
			#endif	// #if __JSON_SERIALIZATION__
			}
			else
			{
				NSObject * value = nil;
				
				if ( BeeTypeEncoding.OBJECT == type.intValue )
				{
					NSString * className = [property objectForKey:@"className"];
					if ( className )
					{
						Class class = NSClassFromString( className );
						if ( class )
						{
							if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
							{
								value = [class record];
							}
							else
							{
								value = [[[class alloc] init] autorelease];
							}
						}
					}
				}

				if ( value )
				{
					[self setValue:value forKey:name];
				}
			}
		}
	}
}

- (void)setObservers
{
#if __JSON_SERIALIZATION__
	
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
	
#endif	// #if __JSON_SERIALIZATION__
}

- (void)removeObservers
{
#if __JSON_SERIALIZATION__
	
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
	
#endif	// #if __JSON_SERIALIZATION__
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
//		[self load];
		[self performLoad];
	}
	
	[BeeDatabase scopeLeave];

	return self;
}

- (id)initWithKey:(id)key
{
	[BeeDatabase scopeEnter];
	
	self = [super init];
	if ( self )
	{
		[self initSelf];
		[self setPrimaryID:self.INVALID_ID];
		
		NSString * primaryKey = self.primaryKey;
		if ( primaryKey )
		{
			BeeDatabase * db = [self class].DB;
			if ( db )
			{
				db.WHERE( self.primaryKey, key ).GET();
				if ( db.succeed )
				{
					NSDictionary * dict = [db.resultArray safeObjectAtIndex:0];
					if ( dict && [dict isKindOfClass:[NSDictionary class]] )
					{
						NSMutableDictionary * newDict = [NSMutableDictionary dictionary];
						
						for ( NSString * key in dict.allKeys )
						{
							if ( [key isEqualToString:primaryKey] )
							{
								[newDict setObject:[dict objectForKey:key] forKey:key];
							}
							else
							{
								NSString * propertyName = [BeeActiveRecord identifierForFieldName:key];
								[newDict setObject:[dict objectForKey:key] forKey:propertyName];
							}
						}
						
						[self setDictionary:newDict];
						[self setPrimaryID:key];
					}
				}
			}
		}

		_changed = NO;
		_deleted = NO;
		
		[self setObservers];
//		[self load];
		[self performLoad];
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
		[self setPrimaryID:self.INVALID_ID];

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
						NSDictionary * dict = [db.resultArray safeObjectAtIndex:0];
						if ( dict && [dict isKindOfClass:[NSDictionary class]] )
						{
							NSMutableDictionary * newDict = [NSMutableDictionary dictionary];
							
							for ( NSString * key in dict.allKeys )
							{
								if ( [key isEqualToString:primaryKey] )
								{
									[newDict setObject:[dict objectForKey:key] forKey:key];
								}
								else
								{
									NSString * propertyName = [BeeActiveRecord identifierForFieldName:key];
									[newDict setObject:[dict objectForKey:key] forKey:propertyName];
								}
							}

							[self setDictionary:newDict];
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
			ERROR( @"Unknown object type" );
		}

		_changed = NO;
		_deleted = NO;

		[self setObservers];
//		[self load];
		[self performLoad];
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
//		[self load];
		[self performLoad];
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
//		[self load];
		[self performLoad];
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
//		[self load];
		[self performLoad];
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
	if ( nil == otherObject || [otherObject isKindOfClass:[NSNull class]] )
		return nil;
	
	if ( [otherObject isKindOfClass:[NSNumber class]] )
	{
		NSNumber * key = (NSNumber *)otherObject;
		if ( key.intValue < 0 )
			return nil;
	}
	else if ( [otherObject isKindOfClass:[NSString class]] )
	{
		NSString * string = (NSString *)otherObject;
		if ( 0 == string.length )
			return nil;
	}
	else if ( [otherObject isKindOfClass:[NSDictionary class]] )
	{
		NSDictionary * dict = (NSDictionary *)otherObject;
		if ( 0 == dict.count )
			return nil;
	}
	else if ( [otherObject isKindOfClass:[NSData class]] )
	{
		NSData * data = (NSData *)otherObject;
		if ( 0 == data.length )
			return nil;
	}
	else if ( [otherObject isKindOfClass:[NSArray class]] )
	{
		NSMutableArray * results = [NSMutableArray array];
		
		for ( NSObject * obj in (NSArray *)otherObject )
		{
			BeeActiveRecord * record = [[self class] record:obj];
			if ( record )
			{
				[results addObject:record];
			}
		}
		
		return results;
	}
	
	return [[[[self class] alloc] initWithObject:otherObject] autorelease];
}

+ (id)recordWithKey:(NSNumber *)key
{
	if ( nil == key || NO == [key isKindOfClass:[NSNumber class]] )
		return nil;

	return [[self class] record:key];
}

+ (id)recordsWithArray:(NSArray *)array
{
	if ( nil == array || NO == [array isKindOfClass:[NSArray class]] )
		return nil;
	
	return [[self class] record:array];
}

+ (id)recordWithObject:(NSObject *)otherObject
{
	if ( nil == otherObject )
		return nil;

	return [[self class] record:otherObject];
}

+ (id)recordWithDictionary:(NSDictionary *)dict
{
	if ( nil == dict || NO == [dict isKindOfClass:[NSDictionary class]] )
		return nil;
	
	return [[self class] record:dict];
}

+ (id)recordWithJSONData:(NSData *)data
{
	if ( nil == data || 0 == data.length )
		return nil;
	
	return [[[[self class] alloc] initWithJSONData:data] autorelease];
}

+ (id)recordWithJSONString:(NSString *)string
{
	if ( nil == string || 0 == string.length )
		return nil;
	
	return [[[[self class] alloc] initWithJSONString:string] autorelease];
}

+ (id)recordFromNumber:(NSNumber *)key
{
	return [self recordWithKey:key];
}

+ (id)recordFromObject:(NSObject *)otherObject
{
	return [self recordWithObject:otherObject];
}

+ (id)recordFromDictionary:(NSDictionary *)dict
{
	return [self recordWithDictionary:dict];
}

+ (id)recordsFromArray:(NSArray *)array
{
	return [self recordsWithArray:array];
}

+ (id)recordFromJSONData:(NSData *)data
{
	return [self recordWithJSONData:data];
}

+ (id)recordFromJSONString:(NSString *)string
{
	return [self recordWithJSONString:string];
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

//	[self unload];
	[self performUnload];
	
	[self removeObservers];
	
#if __JSON_SERIALIZATION__
	[_JSON release];
#endif	// #if __JSON_SERIALIZATION__
	
	[super dealloc];
}

- (id)valueForUndefinedKey:(NSString *)key
{
	return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	ERROR( @"undefined key '%@'", key );
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

			if ( nil == value )
			{
				value = [dict objectAtPath:name];
			}
		}

		if ( nil == value )
		{
			value = [property objectForKey:@"value"];

			if ( [value isKindOfClass:[BeeNonValue class]] || [value isKindOfClass:[NSNull class]] )
			{
				value = nil;
			}
		}

		if ( value && NO == [value isKindOfClass:[BeeNonValue class]] )
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
			else if ( BeeTypeEncoding.NSARRAY == type.intValue )
			{
				NSMutableArray *	defaultValue = [NSMutableArray array];
				NSArray *			array = nil;
				
				if ( [value isKindOfClass:[NSArray class]] )
				{
					array = (NSArray *)value;
				}
				else if ( [value isKindOfClass:[NSString class]] )
				{
					NSObject * obj = [(NSString *)value objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:nil];
					if ( [obj isKindOfClass:[NSArray class]] )
					{
						array = (NSArray *)obj;
					}
				}

				if ( array && array.count )
				{
					NSString * className = [property objectForKey:@"className"];
					if ( className )
					{
						Class class = NSClassFromString( className );
						if ( class )
						{
							NSMutableArray * results = [NSMutableArray array];

							if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
							{
								for ( NSObject * elem in array )
								{
									BeeActiveRecord * record = [class recordWithObject:elem];
									if ( record )
									{
										[results addObject:record];
									}
								}
							}
							else
							{
								for ( NSObject * elem in array )
								{
									if ( [elem isKindOfClass:[NSDictionary class]] )
									{
										NSObject * newObj = [class objectFromDictionary:elem];	// convert dictionary to NSObject
										if ( newObj )
										{
											[results addObject:newObj];
										}
									}
									else if ( [elem isKindOfClass:[NSString class]] )
									{
										NSObject * newObj = [class objectFromString:elem];		// convert dictionary to NSObject
										if ( newObj )
										{
											[results addObject:newObj];
										}
									}
								}
							}

							value = results;
						}
						else
						{
							value = defaultValue;
						}
					}
					else
					{
						value = [array asNSMutableArray];
					}
				}
				else
				{
					value = defaultValue;
				}
			}
			else if ( BeeTypeEncoding.NSDICTIONARY == type.intValue )
			{
				if ( [value isKindOfClass:[NSString class]] )
				{
					value = [(NSString *)value objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:nil];
					if ( NO == [value isKindOfClass:[NSDictionary class]] )
					{
						value = [NSMutableDictionary dictionary];
					}
				}
				else
				{
					value = [value asNSMutableDictionary];	
				}
			}
			else if ( BeeTypeEncoding.OBJECT == type.intValue )
			{
			// set inner AR objects

				NSString * className = [property objectForKey:@"className"];
				if ( className )
				{
					Class class = NSClassFromString( className );
					if ( class )
					{
						if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
						{
							value = [class recordWithObject:value];
						}
						else
						{
							if ( [value isKindOfClass:[NSDictionary class]] )
							{
								value = [class objectFromDictionary:value];	// convert dictionary to NSObject
							}
							else if ( [value isKindOfClass:[NSString class]] )
							{
								value = [class objectFromString:value];		// convert string to NSObject
							}
							else
							{
								value = nil;
							}
						}
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
		}
		else
		{
			// TODO: impossible
		}
		
		if ( name && value )
		{
			[self setValue:value forKey:name];
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
	
#if __JSON_SERIALIZATION__
	[_JSON setDictionary:dict];
#endif	// #if __JSON_SERIALIZATION__
}

- (NSDictionary *)JSON
{
#if __JSON_SERIALIZATION__
	return _JSON;
#else	// #if __JSON_SERIALIZATION__
	return [self objectToDictionaryUntilRootClass:[BeeActiveRecord class]];
#endif	// #if __JSON_SERIALIZATION__
}

- (void)setJSON:(NSMutableDictionary *)JSON
{
	[self setDictionary:JSON];
}

- (NSData *)JSONData
{
#if __JSON_SERIALIZATION__
	return [_JSON JSONData];
#else	// #if __JSON_SERIALIZATION__
	return [self objectToDataUntilRootClass:[BeeActiveRecord class]];
#endif	// #if __JSON_SERIALIZATION__
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
#if __JSON_SERIALIZATION__
	NSString * json = [_JSON JSONString];
#else	// #if __JSON_SERIALIZATION__
	NSString * json = [self objectToStringUntilRootClass:[BeeActiveRecord class]];
#endif	// #if __JSON_SERIALIZATION__

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
	NSString * key = self.activePrimaryKey;
	if ( key )
	{
		return [self valueForKey:key];
	}

	return nil;
}

- (void)setPrimaryID:(NSNumber *)pid
{
	if ( nil == pid )
	{
		pid = self.INVALID_ID;
	}
	
	NSString * key = self.activePrimaryKey;
	if ( key )
	{
		[self setValue:pid forKey:key];
	}
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

	[BeeDatabase scopeEnter];
	
	super.DB
	.FROM( self.tableName )
	.WHERE( primaryKey, [self valueForKey:primaryKey] )
	.LIMIT( 1 )
	.GET();
	
	BOOL succeed = super.DB.succeed;
	if ( succeed )
	{
		NSDictionary * dict = [super.DB.resultArray safeObjectAtIndex:0];
		if ( dict && [dict isKindOfClass:[NSDictionary class]] )
		{
			NSMutableDictionary * newDict = [NSMutableDictionary dictionary];
			
			for ( NSString * key in dict.allKeys )
			{
				if ( [key isEqualToString:primaryKey] )
				{
					[newDict setObject:[dict objectForKey:key] forKey:key];
				}
				else
				{
					NSString * propertyName = [BeeActiveRecord identifierForFieldName:key];
					[newDict setObject:[dict objectForKey:key] forKey:propertyName];
				}
			}

			[self resetProperties];
			[self setPropertiesFrom:newDict];

		#if __JSON_SERIALIZATION__

			NSString * json = [newDict objectForKey:self.activeJSONKey];
			if ( json && json.length )
			{
				NSObject * object = [json objectFromJSONString];
				if ( object && [object isKindOfClass:[NSDictionary class]] )
				{
					[_JSON removeAllObjects];
					[_JSON setDictionary:(NSDictionary *)object];
				}
			}

		#endif	// #if __JSON_SERIALIZATION__
		}
	}

	[BeeDatabase scopeLeave];

	return succeed;
}

- (BOOL)exists
{
	NSString * primaryKey = self.activePrimaryKey;
	if ( nil == primaryKey )
		return NO;
	
	NSNumber * primaryID = [self valueForKey:primaryKey];
	if ( nil == primaryID || primaryID.intValue < 0 )
		return NO;

	[BeeDatabase scopeEnter];
	
	super.DB
	.FROM( self.tableName )
	.WHERE( primaryKey, [self valueForKey:primaryKey] )
	.LIMIT( 1 )
	.COUNT();

	BOOL succeed = (super.DB.succeed && super.DB.resultCount > 0) ? YES : NO;

	[BeeDatabase scopeLeave];
	
	return succeed;
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

	[BeeDatabase scopeEnter];

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
			else if ( BeeTypeEncoding.NSARRAY == type.intValue )
			{
				NSString *	defaultValue = @"[]";
				NSArray *	array = nil;
				
				if ( [value isKindOfClass:[NSArray class]] )
				{
					array = (NSArray *)value;
				}
				else if ( [value isKindOfClass:[NSString class]] )
				{
					NSObject * obj = [(NSString *)value objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:nil];
					if ( [obj isKindOfClass:[NSArray class]] )
					{
						array = (NSArray *)obj;
					}
				}

				if ( array && array.count )
				{
					NSString * className = [property objectForKey:@"className"];
					if ( className )
					{
						Class class = NSClassFromString( className );
						if ( class )
						{
							NSMutableArray * results = [NSMutableArray array];

							if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
							{
								for ( NSObject * elem in array )
								{
									if ( NO == [elem isKindOfClass:[BeeActiveRecord class]] )
										continue;
									
									BeeActiveRecord * record = (BeeActiveRecord *)elem;
									[record exists] ? [record update] : [record insert];
									
									if ( record.inserted )
									{
										[results addObject:record.primaryID];
									}
								}
							}
							else
							{
								for ( NSObject * elem in array )
								{
									NSDictionary * dict = [elem objectToDictionary];
									if ( dict )
									{
										[results addObject:dict];
									}
								}
							}

							value = [results JSONString];
						}
						else
						{
							value = defaultValue;
						}
					}
					else
					{
						value = defaultValue;
					}
				}
				else
				{
					value = defaultValue;
				}
			}
			else if ( BeeTypeEncoding.NSDICTIONARY == type.intValue )
			{
				value = [(NSDictionary *)value JSONString];
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
					value = [value objectToString];
				}
			}
			else
			{
//				value = [value asNSNumber];
			}
			
			if ( name && value )
			{
				if ( [name isEqualToString:primaryKey] )
				{
					super.DB.SET( name, value );
				}
				else
				{
					super.DB.SET( [[self class] fieldNameForIdentifier:name], value );
				}
			}
		}
	}

#if __JSON_SERIALIZATION__
	
	if ( [[self class] usingJSON] )
	{
		super.DB.SET( JSONKey, self.JSONString );
	}

#endif	// #if __JSON_SERIALIZATION__
	
	super.DB.INSERT();

	BOOL succeed = super.DB.succeed;
	if ( succeed )
	{
		_changed = NO;

		if ( primaryKey )
		{
			[self setValue:[NSNumber numberWithInteger:super.DB.insertID] forKey:primaryKey];
		}
	}

	[BeeDatabase scopeLeave];

	return succeed;
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

	[BeeDatabase scopeEnter];

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
			else if ( BeeTypeEncoding.NSARRAY == type.intValue )
			{
				NSString *	defaultValue = @"[]";
				NSArray *	array = nil;
				
				if ( [value isKindOfClass:[NSArray class]] )
				{
					array = (NSArray *)value;
				}
				else if ( [value isKindOfClass:[NSString class]] )
				{
					NSObject * obj = [(NSString *)value objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:nil];
					if ( [obj isKindOfClass:[NSArray class]] )
					{
						array = (NSArray *)obj;
					}
				}

				if ( array && array.count )
				{
					NSString * className = [property objectForKey:@"className"];
					if ( className )
					{
						Class class = NSClassFromString( className );
						if ( class )
						{
							NSMutableArray * results = [NSMutableArray array];
							
							if ( [class isSubclassOfClass:[BeeActiveRecord class]] )
							{
								for ( NSObject * elem in array )
								{
									if ( NO == [elem isKindOfClass:[BeeActiveRecord class]] )
										continue;
									
									BeeActiveRecord * record = (BeeActiveRecord *)elem;
									[record exists] ? [record update] : [record insert];
									
									if ( record.inserted )
									{
										[results addObject:record.primaryID];
									}
								}
							}
							else
							{
								for ( NSObject * elem in array )
								{
									NSDictionary * dict = [elem objectToDictionary];
									if ( dict )
									{
										[results addObject:dict];
									}
								}
							}

							value = [results JSONString];
						}
						else
						{
							value = defaultValue;
						}
					}
					else
					{
						value = defaultValue;
					}
				}
				else
				{
					value = defaultValue;
				}
			}
			else if ( BeeTypeEncoding.NSDICTIONARY == type.intValue )
			{
				value = [(NSDictionary *)value JSONString];
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
						value = [value objectToString];
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

			if ( name && value )
			{
				if ( [name isEqualToString:primaryKey] )
				{
					super.DB.SET( name, value );
				}
				else
				{
					super.DB.SET( [[self class] fieldNameForIdentifier:name], value );
				}
			}
		}
	}

#if __JSON_SERIALIZATION__
	
	if ( [[self class] usingJSON] )
	{
		super.DB.SET( JSONKey, self.JSONString );
	}
	
#endif	// #if __JSON_SERIALIZATION__
	
	super.DB.UPDATE();
	
	BOOL succeed = super.DB.succeed;
	if ( succeed )
	{
		_changed = NO;
	}
	
	[BeeDatabase scopeLeave];

	return succeed;
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

	[BeeDatabase scopeEnter];
	
	super.DB
	.FROM( self.tableName )
	.WHERE( primaryKey, primaryID )
	.DELETE();

	BOOL succeed = super.DB.succeed;
	if ( succeed )
	{
		NSString *		JSONKey = self.activeJSONKey;
		NSDictionary *	propertySet = self.activePropertySet;

		[self setValue:self.INVALID_ID forKey:primaryKey];
		
		for ( NSString * key in propertySet.allKeys )
		{
			NSDictionary * property = [propertySet objectForKey:key];

			NSString * name = [property objectForKey:@"name"];
			if ( [name isEqualToString:JSONKey] )
				continue;

			NSObject * value = [property objectForKey:@"value"];
			
			if ( value && NO == [value isKindOfClass:[BeeNonValue class]] )
			{
				[self setValue:value forKey:name];
			}
			else
			{
				[self setValue:nil forKey:name];
			}
		}

	#if __JSON_SERIALIZATION__
		[_JSON removeAllObjects];
	#endif	// #if __JSON_SERIALIZATION__

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
	}

	[BeeDatabase scopeLeave];

	return succeed;
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
			self.changed = YES;	// force to update
			
			ret = [self update];
		}
		return ret;
	};

	return [[block copy] autorelease];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

@interface __TestLocation : BeeActiveRecord
@property (nonatomic, retain) NSNumber *		lid;
@property (nonatomic, retain) NSNumber *		lat;
@property (nonatomic, retain) NSNumber *		lon;
@end

@interface __TestRecord : BeeActiveRecord
@property (nonatomic, retain) NSNumber *		uid;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		gender;
@property (nonatomic, retain) NSDate *			birth;
@end

@interface __TestRecord2 : __TestRecord
@property (nonatomic, retain) NSString *		city;
@property (nonatomic, retain) __TestLocation *	location;
@end

@implementation __TestLocation

+ (void)mapRelation
{
	[super mapRelation];
	[super useJSON];
	[super useAutoIncrement];
}

@end

@implementation __TestRecord

@synthesize uid;
@synthesize name;
@synthesize gender;
@synthesize birth;

+ (void)mapRelation
{
	[super mapRelation];
	[super useJSON];
	[super useAutoIncrement];
}

@end

@implementation __TestRecord2

+ (void)mapRelation
{
	[super mapRelation];
	[super useJSON];
	[super useAutoIncrement];
}

@end

TEST_CASE( BeeActiveRecord )
{
	TIMES( 3 )
	{
		HERE( "open close DB", {
			[BeeDatabase closeSharedDatabase];
			EXPECTED( nil == [BeeDatabase sharedDatabase] );
			
			[BeeDatabase openSharedDatabase:@"ar2"];
			EXPECTED( [BeeDatabase sharedDatabase] );
		});
	}
	
	TIMES( 3 )
	{
		HERE( "clear", {
			__TestRecord2.DB.EMPTY();
			EXPECTED( __TestRecord2.DB.succeed );
			EXPECTED( __TestRecord2.DB.total == 0 );
		});
		
		__TestRecord2 * me = nil;
		
		HERE( "create record", {
			me = [__TestRecord2 record];
			
			EXPECTED( me );
			EXPECTED( me.deleted == NO );
			EXPECTED( me.changed == NO );
			EXPECTED( me.inserted == NO );
			EXPECTED( me.primaryKey && [me.primaryKey isEqualToString:@"uid"] );
			EXPECTED( me.primaryID );
			EXPECTED( me.JSON );
			EXPECTED( me.JSONData );
			EXPECTED( me.JSONString );
		});
		
		HERE( "set values by property", {
			me.name = @"gavin";
			me.gender = @"male";
			me.birth = [NSDate date];
			
			me.city = @"beijing";
			me.location.lat = __INT(888);
			me.location.lon = __INT(999);
		});

		HERE( "get values by properties", {
			EXPECTED( [me.name isEqualToString:@"gavin"] );
			EXPECTED( [me.city isEqualToString:@"beijing"] );
			EXPECTED( [me.gender isEqualToString:@"male"] );
			EXPECTED( [me.location.lat isEqualToNumber:__INT(888)] );
			EXPECTED( [me.location.lon isEqualToNumber:__INT(999)] );

			EXPECTED( me.JSONData );
			EXPECTED( me.JSONString );
		});

		HERE( "get values by JSON", {
			EXPECTED( [[me.JSON objectForKey:@"name"] isEqualToString:@"gavin"] );
			EXPECTED( [[me.JSON objectForKey:@"city"] isEqualToString:@"beijing"] );
			EXPECTED( [[me.JSON objectForKey:@"gender"] isEqualToString:@"male"] );
			EXPECTED( [[me.location.JSON objectForKey:@"lat"] isEqualToNumber:__INT(888)] );
			EXPECTED( [[me.location.JSON objectForKey:@"lon"] isEqualToNumber:__INT(999)] );
			
			EXPECTED( me.JSONData );
			EXPECTED( me.JSONString );
		});
		
		HERE( "insert", {
			me.SAVE();
			
			EXPECTED( me.inserted );
			EXPECTED( __TestRecord2.DB.succeed );
			EXPECTED( __TestRecord2.DB.total == 1 );
		});

		HERE( "update", {
			me.city = @"shenyang";
			
			EXPECTED( [[me.JSON objectForKey:@"city"] isEqualToString:@"shenyang"] );
			
			me.UPDATE();
			
			EXPECTED( __TestRecord2.DB.succeed );
			EXPECTED( __TestRecord2.DB.total == 1 );
		});
		
		HERE( "delete", {
			me.DELETE();
			me = nil;
			
			EXPECTED( __TestRecord2.DB.succeed );
			EXPECTED( __TestRecord2.DB.total == 0 );
		});
	}

	TIMES( 3 )
	{
		
		HERE( "clear", {
			__TestRecord2.DB.EMPTY();
			
			EXPECTED( __TestRecord2.DB.succeed );
			EXPECTED( __TestRecord2.DB.total == 0 );
		});
		
		__TestRecord2 * me = nil;
		
		HERE( "create", {
			me = [__TestRecord2 record];
			
			EXPECTED( me );
			EXPECTED( me.deleted == NO );
			EXPECTED( me.changed == NO );
			EXPECTED( me.inserted == NO );
			
			me.name = @"gavin";
			me.gender = @"male";
			me.birth = [NSDate date];
			me.city = @"beijing";
			me.location.lat = __INT(888);
			me.location.lon = __INT(999);
			
			TIMES( 3 )
			{
				me.SAVE();
				
				EXPECTED( __TestRecord2.DB.succeed );
				EXPECTED( __TestRecord2.DB.total == 1 );
			}
		});
		
		__TestRecord2 * copy1 = nil;
		
		HERE( "copy by record", {
			copy1 = [__TestRecord2 record:me];
			
			EXPECTED( copy1 );
			EXPECTED( copy1.deleted == NO );
			EXPECTED( copy1.changed == NO );
			EXPECTED( copy1.inserted == YES );
			
			EXPECTED( [copy1.name isEqualToString:me.name] );
			EXPECTED( [copy1.city isEqualToString:me.city] );
			EXPECTED( [copy1.gender isEqualToString:me.gender] );
			EXPECTED( [copy1.location.lat isEqualToNumber:me.location.lat] );
			EXPECTED( [copy1.location.lon isEqualToNumber:me.location.lon] );
			
			copy1.SAVE();
			
			EXPECTED( __TestRecord2.DB.succeed );
			EXPECTED( __TestRecord2.DB.total == 1 );
		});
		
		__TestRecord2 * copy2 = nil;
		
		HERE( "copy by JSON", {
			copy2 = [__TestRecord2 record:copy1.JSON];
			
			EXPECTED( copy2 );
			EXPECTED( copy2.deleted == NO );
			EXPECTED( copy2.changed == NO );
			EXPECTED( copy2.inserted == YES );
			
			EXPECTED( [copy2.name isEqualToString:me.name] );
			EXPECTED( [copy2.city isEqualToString:me.city] );
			EXPECTED( [copy2.gender isEqualToString:me.gender] );
			EXPECTED( [copy2.location.lat isEqualToNumber:me.location.lat] );
			EXPECTED( [copy2.location.lon isEqualToNumber:me.location.lon] );
			
			copy2.SAVE();
			
			EXPECTED( __TestRecord2.DB.succeed );
			EXPECTED( __TestRecord2.DB.total == 1 );
		});
		
		__TestRecord2 * copy3 = nil;
		
		HERE( "create by JSON String", {
			copy3 = [__TestRecord2 record:copy2.JSONString];
			
			EXPECTED( copy3 );
			EXPECTED( copy3.deleted == NO );
			EXPECTED( copy3.changed == NO );
			EXPECTED( copy3.inserted == YES );
			
			EXPECTED( [copy3.name isEqualToString:me.name] );
			EXPECTED( [copy3.city isEqualToString:me.city] );
			EXPECTED( [copy3.gender isEqualToString:me.gender] );
			EXPECTED( [copy3.location.lat isEqualToNumber:me.location.lat] );
			EXPECTED( [copy3.location.lon isEqualToNumber:me.location.lon] );
			
			copy3.SAVE();
			
			EXPECTED( __TestRecord2.DB.succeed );
			EXPECTED( __TestRecord2.DB.total == 1 );
		});
		
		__TestRecord2 * copy4 = nil;
		
		HERE( "create by JSON Data", {
			copy4 = [__TestRecord2 record:copy2.JSONData];
			
			EXPECTED( copy4 );
			EXPECTED( copy4.deleted == NO );
			EXPECTED( copy4.changed == NO );
			EXPECTED( copy4.inserted == YES );
			
			EXPECTED( [copy4.name isEqualToString:me.name] );
			EXPECTED( [copy4.city isEqualToString:me.city] );
			EXPECTED( [copy4.gender isEqualToString:me.gender] );
			EXPECTED( [copy4.location.lat isEqualToNumber:me.location.lat] );
			EXPECTED( [copy4.location.lon isEqualToNumber:me.location.lon] );
			
			copy4.SAVE();
			
			EXPECTED( __TestRecord2.DB.succeed );
			EXPECTED( __TestRecord2.DB.total == 1 );
		});
		
		__TestRecord2 * copy5 = nil;

		HERE( "create by String", {
			copy5 = [__TestRecord2 record:@"{ \
					 'name' : 'gavin', \
					 'city' : 'beijing', \
					 'gender' : 'male', \
					 'location' : { 'lat' : 888, 'lid' : 100, 'lon' : 999 } \
					 }"];
			
			EXPECTED( copy5 );
			EXPECTED( copy5.deleted == NO );
			EXPECTED( copy5.changed == NO );
			EXPECTED( copy5.inserted == NO );
			
			EXPECTED( [copy5.name isEqualToString:@"gavin"] );
			EXPECTED( [copy5.city isEqualToString:@"beijing"] );
			EXPECTED( [copy5.gender isEqualToString:@"male"] );
			EXPECTED( [copy5.location.lat isEqualToNumber:__INT(888)] );
			EXPECTED( [copy5.location.lon isEqualToNumber:__INT(999)] );
			
			copy5.SAVE();
			
			EXPECTED( __TestRecord2.DB.succeed );
			EXPECTED( __TestRecord2.DB.total == 2 );
		});
		
		HERE( "Query records", {
			__TestRecord2.DB.GET_RECORDS();	// Results are BeeActiveRecord
			
			EXPECTED( __TestRecord2.DB.succeed );
			EXPECTED( __TestRecord2.DB.resultArray.count == 2 );
			EXPECTED( __TestRecord2.DB.resultCount == 2 );
		});
		
		HERE( "Delete records", {
			me.DELETE();
			copy1.DELETE();
			copy2.DELETE();
			copy3.DELETE();
			copy4.DELETE();
			copy5.DELETE();
		});

		HERE( "Count records", {
			__TestRecord2.DB.COUNT();
			
			NSAssert( __TestRecord2.DB.succeed, @"" );
			NSAssert( __TestRecord2.DB.resultCount == 0, @"" );
		});
	}
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

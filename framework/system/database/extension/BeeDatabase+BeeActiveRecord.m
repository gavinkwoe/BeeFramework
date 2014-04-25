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

#import "Bee_ActiveObject.h"
#import "NSObject+BeeDatabase.h"
#import "BeeDatabase+BeeActiveRecord.h"
#import "NSDictionary+BeeActiveRecord.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface BeeActiveRecord(BeeActiveRecord)
+ (void)setAssociateConditions;
+ (void)setHasConditions;
@end

#pragma mark -

@implementation BeeActiveRecord(BeeActiveRecord)

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
					value = [[value asNSDate] description];
				}
				else
				{
//					value = [value asNSNumber];
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

- (BeeDatabaseObjectBlockN)SAVE
{
	BeeDatabaseObjectBlockN block = ^ id ( id first, ... )
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
		else if ( [first isKindOfClass:[BeeActiveRecord class]] )
		{
			BeeActiveRecord * record = (BeeActiveRecord *)first;
			record.changed = YES;
			record.SAVE();
			return record;
		}

		return nil;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseObjectBlockN)SAVE_DATA
{
	BeeDatabaseObjectBlockN block = ^ id ( id first, ... )
	{
		return [self saveData:(NSData *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseObjectBlockN)SAVE_STRING
{
	BeeDatabaseObjectBlockN block = ^ id ( id first, ... )
	{
		return [self saveString:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseObjectBlockN)SAVE_ARRAY
{
	BeeDatabaseObjectBlockN block = ^ id ( id first, ... )
	{
		return [self saveArray:(NSArray *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseObjectBlockN)SAVE_DICTIONARY
{
	BeeDatabaseObjectBlockN block = ^ id ( id first, ... )
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
		return nil;
	
	if ( [obj isKindOfClass:[NSArray class]] )
	{
		return [self saveArray:(NSArray *)obj];
	}
	else if ( [obj isKindOfClass:[NSDictionary class]] )
	{
		return [self saveDictionary:(NSDictionary *)obj];
	}
	
	return nil;
}

- (id)saveString:(NSString *)string
{
	if ( string && [string rangeOfString:@"'"].length > 0 )
	{
		string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"\""];	
	}
		
    NSError * error = nil;
	NSObject * obj = [(NSString *)string objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&error];

	if ( nil == obj )
	{
		ERROR( @"%@", error );
		return nil;
	}
	
	if ( [obj isKindOfClass:[NSArray class]] )
	{
		return [self saveArray:(NSArray *)obj];
	}
	else if ( [obj isKindOfClass:[NSDictionary class]] )
	{
		return [self saveDictionary:(NSDictionary *)obj];
	}
	
	return nil;
}

- (id)saveArray:(NSArray *)array
{
	NSMutableArray * results = [NSMutableArray array];
	
	self.BATCH_BEGIN();
	
	for ( NSObject * obj in array )
	{
		if ( [obj isKindOfClass:[NSDictionary class]] )
		{
			id result = [self saveDictionary:(NSDictionary *)obj];
			if ( result )
			{
				[results addObject:result];
			}
		}
		else if ( [obj isKindOfClass:[BeeActiveRecord class]] )
		{
			BeeActiveRecord * record = (BeeActiveRecord *)obj;
			if ( record )
			{
				record.changed = YES;
				record.SAVE();

				[results addObject:record];
			}
		}
	}

	self.BATCH_END();
	
	return results;
}

- (id)saveDictionary:(NSDictionary *)dict
{
	Class classType = self.classType;
	if ( NO == [classType isSubclassOfClass:[BeeActiveRecord class]] )
		return nil;
	
	BeeActiveRecord * record = [dict objectToActiveRecord:classType];
	if ( record )
	{
		record.changed = YES;
		record.SAVE();

		return record;
	}

	return nil;
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
		return [array safeObjectAtIndex:0];
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
	
	NSDictionary * dict = [array safeObjectAtIndex:0];
	if ( dict && [dict isKindOfClass:[NSDictionary class]] )
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
	
	if ( table )
	{
		self.FROM( table );
	}
	
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

	NSMutableArray * activeRecords = [[[NSMutableArray alloc] init] autorelease];
	
	for ( NSDictionary * dict in array )
	{
		BeeActiveRecord * object = [[[classType alloc] initWithDictionary:dict] autorelease];
		[activeRecords addObject:object];
	}
	
	[self __internalSetResult:activeRecords];

	return activeRecords;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

@interface __TestUser : BeeActiveRecord
@property (nonatomic, retain) NSNumber *		uid;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		gender;
@property (nonatomic, retain) NSDate *			birth;
@end

@implementation __TestUser

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

TEST_CASE( BeeDatabase_BeeActiveRecord )
{
	TIMES( 3 )
	{
		HERE( "open and close DB", {
			[BeeDatabase closeSharedDatabase];
			EXPECTED( nil == [BeeDatabase sharedDatabase] );
			
			[BeeDatabase openSharedDatabase:@"ar"];
			EXPECTED( [BeeDatabase sharedDatabase] );
		});
	}
	
	TIMES( 3 )
	{
		HERE( "empty DB", {
			__TestUser.DB.EMPTY();
			EXPECTED( __TestUser.DB.succeed );
			EXPECTED( __TestUser.DB.total == 0 );
		});
		
		HERE( "insert and get", {
			__TestUser.DB.SET( @"name", @"gavin" ).SET( @"gender", @"male" ).SET( @"birth", [NSDate date] ).INSERT();
			EXPECTED( __TestUser.DB.succeed );
			EXPECTED( __TestUser.DB.total == 1 );
			
			__TestUser.DB.WHERE( @"name", @"gavin" ).GET();
			EXPECTED( __TestUser.DB.succeed );
			EXPECTED( __TestUser.DB.resultCount == 1 );
			
			NSDictionary * user = [__TestUser.DB.resultArray objectAtIndex:0];
			EXPECTED( user );
			EXPECTED( [[user objectForKey:@"name"] isEqualToString:@"gavin"] );
			EXPECTED( [[user objectForKey:@"gender"] isEqualToString:@"male"] );
			EXPECTED( [user objectForKey:@"birth"] );
		});
		
		HERE( "insert and get again", {
			__TestUser.DB.SET( @"name", @"amanda" ).SET( @"gender", @"female" ).SET( @"birth", [NSDate date] ).INSERT();
			EXPECTED( __TestUser.DB.succeed );
			EXPECTED( __TestUser.DB.total == 2 );
			
			__TestUser.DB.WHERE( @"name", @"amanda" ).GET();
			EXPECTED( __TestUser.DB.succeed );
			EXPECTED( __TestUser.DB.resultCount == 1 );
			
			NSDictionary * user2 = [__TestUser.DB.resultArray objectAtIndex:0];
			EXPECTED( user2 );
			EXPECTED( [[user2 objectForKey:@"name"] isEqualToString:@"amanda"] );
			EXPECTED( [[user2 objectForKey:@"gender"] isEqualToString:@"female"] );
			EXPECTED( [user2 objectForKey:@"birth"] );
		});
		
		HERE( "update", {
			__TestUser.DB.SET( @"birth", [NSDate date] ).WHERE( @"name", @"gavin" ).UPDATE();
			EXPECTED( __TestUser.DB.succeed );
			EXPECTED( __TestUser.DB.total == 2 );
		});
		
		HERE( "delete", {
			__TestUser.DB.WHERE( @"name", @"gavin" ).DELETE();
			EXPECTED( __TestUser.DB.succeed );
			EXPECTED( __TestUser.DB.total == 1 );
			
			__TestUser.DB.WHERE( @"name", @"amanda" ).DELETE();
			EXPECTED( __TestUser.DB.succeed );
			EXPECTED( __TestUser.DB.total == 0 );
		});
		
		HERE( "count", {
			__TestUser.DB.COUNT();
			EXPECTED( __TestUser.DB.succeed );
			EXPECTED( __TestUser.DB.resultCount == 0 );
		});
	}
	
	[BeeDatabase closeSharedDatabase];
	EXPECTED( nil == [BeeDatabase sharedDatabase] );
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

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
//  Bee_Database.h
//

#import "Bee_Precompile.h"
#import "Bee_Database.h"
#import "Bee_Log.h"
#import "Bee_Sandbox.h"
#import "Bee_ActiveRecord.h"
#import "Bee_ActiveBase.h"

#import "NSArray+BeeExtension.h"
#import "NSString+BeeExtension.h"
#import "NSNumber+BeeExtension.h"
#import "NSDictionary+BeeExtension.h"
#import "NSObject+BeeDatabase.h"

#import "FMDatabase.h"

#pragma mark -

@interface BeeDatabase(Private)

+ (NSString *)fieldNameForIdentifier:(NSString *)identifier;
+ (BOOL)isFullPath:(NSString *)path;

- (void)initSelf;
- (NSString *)internalCreateAliasFromTable:(NSString *)name;
- (void)internalSelect:(NSString *)select alias:(NSString *)alias type:(NSString *)type;
- (void)internalWhere:(NSString *)key value:(NSObject *)value type:(NSString *)type;
- (void)internalLike:(NSString *)field match:(NSObject *)match type:(NSString *)type side:(NSString *)side not:(BOOL)not;
- (void)internalHaving:(NSString *)key value:(NSObject *)value type:(NSString *)type;

- (NSString *)internalCompileSelect:(NSString *)override;
- (NSString *)internalCompileCreate:(NSString *)table;
- (NSString *)internalCompileIndex:(NSString *)table;

// create

- (BeeDatabase *)table:(NSString *)name;
- (BeeDatabase *)field:(NSString *)name type:(NSString *)type size:(NSUInteger)size;
- (BeeDatabase *)unsignedType;
- (BeeDatabase *)notNull;
- (BeeDatabase *)primaryKey;
- (BeeDatabase *)autoIncrement;
- (BeeDatabase *)defaultZero;
- (BeeDatabase *)defaultNull;
- (BeeDatabase *)defaultValue:(id)value;
- (BeeDatabase *)unique;
- (BOOL)createTableIfNotExists;
- (BOOL)createTableIfNotExists:(NSString *)table;
- (BOOL)indexTableOn:(NSArray *)fields;
- (BOOL)indexTable:(NSString *)table on:(NSArray *)fields;
- (BOOL)existsTable:(NSString *)table;

// select

- (BeeDatabase *)select:(NSString *)select;
- (BeeDatabase *)selectMax:(NSString *)select;
- (BeeDatabase *)selectMax:(NSString *)select alias:(NSString *)alias;
- (BeeDatabase *)selectMin:(NSString *)select;
- (BeeDatabase *)selectMin:(NSString *)select alias:(NSString *)alias;
- (BeeDatabase *)selectAvg:(NSString *)select;
- (BeeDatabase *)selectAvg:(NSString *)select alias:(NSString *)alias;
- (BeeDatabase *)selectSum:(NSString *)select;
- (BeeDatabase *)selectSum:(NSString *)select alias:(NSString *)alias;

- (BeeDatabase *)distinct:(BOOL)flag;
- (BeeDatabase *)from:(NSString *)from;

- (BeeDatabase *)where:(NSString *)key value:(id)value;
- (BeeDatabase *)orWhere:(NSString *)key value:(id)value;

- (BeeDatabase *)whereIn:(NSString *)key values:(NSArray *)values;
- (BeeDatabase *)orWhereIn:(NSString *)key values:(NSArray *)values;
- (BeeDatabase *)whereNotIn:(NSString *)key values:(NSArray *)values;
- (BeeDatabase *)orWhereNotIn:(NSString *)key values:(NSArray *)values;

- (BeeDatabase *)like:(NSString *)field match:(id)value;
- (BeeDatabase *)notLike:(NSString *)field match:(id)value;
- (BeeDatabase *)orLike:(NSString *)field match:(id)value;
- (BeeDatabase *)orNotLike:(NSString *)field match:(id)value;

- (BeeDatabase *)groupBy:(NSString *)by;

- (BeeDatabase *)having:(NSString *)key value:(id)value;
- (BeeDatabase *)orHaving:(NSString *)key value:(id)value;

- (BeeDatabase *)orderAscendBy:(NSString *)by;
- (BeeDatabase *)orderDescendBy:(NSString *)by;
- (BeeDatabase *)orderRandomBy:(NSString *)by;
- (BeeDatabase *)orderBy:(NSString *)by direction:(NSString *)direction;

- (BeeDatabase *)limit:(NSUInteger)limit;
- (BeeDatabase *)offset:(NSUInteger)offset;

- (BeeDatabase *)classInfo:(id)obj;

// write

- (BeeDatabase *)set:(NSString *)key;
- (BeeDatabase *)set:(NSString *)key value:(id)value;

- (NSArray *)get;
- (NSArray *)get:(NSString *)table;
- (NSArray *)get:(NSString *)table limit:(NSUInteger)limit;
- (NSArray *)get:(NSString *)table limit:(NSUInteger)limit offset:(NSUInteger)offset;

- (NSUInteger)count;
- (NSUInteger)count:(NSString *)table;

- (NSInteger)insert;
- (NSInteger)insert:(NSString *)table;

- (BOOL)update;
- (BOOL)update:(NSString *)table;

- (BOOL)empty;
- (BOOL)empty:(NSString *)table;

- (BOOL)truncate;
- (BOOL)truncate:(NSString *)table;

- (BOOL)delete;
- (BOOL)delete:(NSString *)table;

// active record

- (void)classType:(Class)clazz;
- (void)associate:(NSObject *)obj;
- (void)has:(NSObject *)obj;

@end

#pragma mark -

@implementation BeeDatabase

@dynamic autoOptimize;
@dynamic ready;
@dynamic total;
@synthesize shadow = _shadow;
@synthesize database = _database;
@synthesize filePath = _filePath;
@synthesize identifier = _identifier;

@dynamic TABLE;
@dynamic FIELD;
@dynamic FIELD_WITH_SIZE;
@dynamic UNSIGNED;
@dynamic NOT_NULL;
@dynamic PRIMARY_KEY;
@dynamic AUTO_INREMENT;
@dynamic DEFAULT_ZERO;
@dynamic DEFAULT_NULL;
@dynamic DEFAULT;
@dynamic UNIQUE;
@dynamic CREATE_IF_NOT_EXISTS;
@dynamic INDEX_ON;

@dynamic SELECT;
@dynamic SELECT_MAX;
@dynamic SELECT_MAX_ALIAS;
@dynamic SELECT_MIN;
@dynamic SELECT_MIN_ALIAS;
@dynamic SELECT_AVG;
@dynamic SELECT_AVG_ALIAS;
@dynamic SELECT_SUM;
@dynamic SELECT_SUM_ALIAS;

@dynamic DISTINCT;
@dynamic FROM;

@dynamic WHERE;
@dynamic OR_WHERE;

@dynamic WHERE_IN;
@dynamic OR_WHERE_IN;
@dynamic WHERE_NOT_IN;
@dynamic OR_WHERE_NOT_IN;

@dynamic LIKE;
@dynamic NOT_LIKE;
@dynamic OR_LIKE;
@dynamic OR_NOT_LIKE;

@dynamic GROUP_BY;

@dynamic HAVING;
@dynamic OR_HAVING;

@dynamic ORDER_ASC_BY;
@dynamic ORDER_DESC_BY;
@dynamic ORDER_RAND_BY;
@dynamic ORDER_BY;

@dynamic LIMIT;
@dynamic OFFSET;

@dynamic SET;
@dynamic SET_NULL;

@dynamic GET;
@dynamic COUNT;

@dynamic INSERT;
@dynamic UPDATE;
@dynamic EMPTY;
@dynamic TRUNCATE;
@dynamic DELETE;

@dynamic BATCH_BEGIN;
@dynamic BATCH_END;

@dynamic CLASS_TYPE;
@dynamic ASSOCIATE;
@dynamic HAS;

@dynamic resultArray;
@dynamic resultCount;
@dynamic insertID;
@dynamic succeed;

@synthesize lastQuery = _lastQuery;
@synthesize lastUpdate = _lastUpdate;

static NSMutableArray *	__shadowDBs = nil;
static BeeDatabase *	__sharedDB = nil;
static NSUInteger		__identSeed = 1;

- (NSArray *)resultArray
{
	[self __internalResetSelect];
	[self __internalResetWrite];
	[self __internalResetCreate];
    
    //	[self __internalResetResult];
    
	return [[[NSMutableArray alloc] initWithArray:_resultArray] autorelease];
}

- (NSUInteger)resultCount
{
	[self __internalResetSelect];
	[self __internalResetWrite];
	[self __internalResetCreate];
	
	return _resultCount;
}

- (NSInteger)insertID
{
	[self __internalResetSelect];
	[self __internalResetWrite];
	[self __internalResetCreate];

	return _lastInsertID;
}

- (BOOL)succeed
{
	[self __internalResetSelect];
	[self __internalResetWrite];
	[self __internalResetCreate];

	return _lastSucceed;
}

- (NSUInteger)total
{
	NSUInteger count = [self count];
	
	[self __internalResetSelect];
	[self __internalResetWrite];
	[self __internalResetCreate];

	return count;
}

- (void)initSelf
{
	_select = [[NSMutableArray alloc] init];
	_distinct = NO;
	_from = [[NSMutableArray alloc] init];
	_where = [[NSMutableArray alloc] init];
	_like = [[NSMutableArray alloc] init];
	_groupby = [[NSMutableArray alloc] init];
	_having = [[NSMutableArray alloc] init];
	_keys = [[NSMutableArray alloc] init];
	_limit = 0;
	_offset = 0;
	_orderby = [[NSMutableArray alloc] init];
	_set = [[NSMutableDictionary alloc] init];
	_classType = [[NSMutableArray alloc] init];
	_associate = [[NSMutableArray nonRetainingArray] retain];
    _has = [[NSMutableArray nonRetainingArray] retain];
	
	_table = [[NSMutableArray alloc] init];
	_field = [[NSMutableArray alloc] init];
	_index = [[NSMutableArray alloc] init];
	
	_resultArray = [[NSMutableArray alloc] init];
	_resultCount = 0;
	
	_identifier = __identSeed++;
	
	_lastQuery = [NSDate timeIntervalSinceReferenceDate];
	_lastUpdate = [NSDate timeIntervalSinceReferenceDate];
}

+ (BOOL)openSharedDatabase:(NSString *)path
{
	if ( __sharedDB.ready && [__sharedDB.filePath isEqualToString:path] )
		return YES;

	[self closeSharedDatabase];

	__sharedDB = [[[self class] alloc] initWithPath:path];
	if ( __sharedDB )
	{
		if ( NO == __sharedDB.ready )
		{
			[__sharedDB release];
			__sharedDB = nil;
		}
	}

	return (__sharedDB && __sharedDB.ready) ? YES : NO;
}

+ (BOOL)existsSharedDatabase:(NSString *)path
{
	return [BeeDatabase exists:path];
}

+ (void)closeSharedDatabase
{
	if ( __shadowDBs )
	{
		for ( BeeDatabase * db in __shadowDBs )
		{
			[db close];
		}
		
		[__shadowDBs removeAllObjects];
		[__shadowDBs release];
		__shadowDBs = nil;
	}

	[__sharedDB close];
	[__sharedDB release];
	__sharedDB = nil;
	
	[self resetPrepareFlags];
}

+ (void)setSharedDatabase:(BeeDatabase *)db
{
	if ( db != __sharedDB )
	{
		[db retain];

		if ( __shadowDBs )
		{
			for ( BeeDatabase * db in __shadowDBs )
			{
				[db close];
			}
			
			[__shadowDBs removeAllObjects];
			[__shadowDBs release];
			__shadowDBs = nil;
		}
		
		[__sharedDB close];
		[__sharedDB release];
		__sharedDB = db;
	}

	[self resetPrepareFlags];
}

+ (BeeDatabase *)sharedDatabase
{
	if ( __shadowDBs.count )
	{
		return (BeeDatabase *)__shadowDBs.lastObject;
	}

	return __sharedDB;
}

+ (void)scopeEnter
{
	if ( __sharedDB )
	{
		BeeDatabase * db = [[BeeDatabase alloc] initWithDatabase:__sharedDB.database];
		if ( db )
		{
			db.shadow = YES;
			
			if ( nil == __shadowDBs )
			{
				__shadowDBs = [[NSMutableArray alloc] init];
			}
			
			[__shadowDBs addObject:db];
			
			[db release];
		}
	}
}

+ (void)scopeLeave
{
	if ( __shadowDBs && __shadowDBs.count )
	{
		[__shadowDBs removeObject:__shadowDBs.lastObject];		
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

- (id)initWithDatabase:(FMDatabase *)db
{
	self = [super init];
	if ( self )
	{
		[self initSelf];

		CC( @"[DB] open shadow '%p'", db );

		self.database = db;
		self.filePath = db.databasePath;
	}
	return self;
}

- (id)initWithPath:(NSString *)path
{
	self = [super init];
	if ( self )
	{
		[self initSelf];
		[self open:path];
	}
	return self;
}

- (BOOL)ready
{
	if ( nil == _database )
		return NO;
	
	return _database.open;
}

+ (BOOL)isFullPath:(NSString *)path
{
    if ( [[path componentsSeparatedByString:@"/"] count] > 1 )
	{
        return YES;
    }

    return NO;
}

+ (NSString *)storePath:(NSString *)path
{
    if ( [BeeDatabase isFullPath:path] )
	{
        return path;
    }

    NSString * fullPath = [NSString stringWithFormat:@"%@/BeeDatabase/", [BeeSandbox docPath]];
	NSString * fullName = [fullPath stringByAppendingString:path];
    return fullName;
}

+ (BOOL)exists:(NSString *)path;
{
	NSFileManager * manager = [NSFileManager defaultManager];
	NSString * fullName = [BeeDatabase storePath:path];
	BOOL isDirectory = NO;
	BOOL returnValue = [manager fileExistsAtPath:fullName isDirectory:&isDirectory];
	if ( NO == returnValue || YES == isDirectory )
		return NO;
	
	return YES;
}

- (BOOL)open:(NSString *)path
{
	if ( _filePath && [_filePath isEqualToString:path] )
		return YES;
    
	[self close];
	
	CC( @"[DB] open at '%@'", path );
	
	NSFileManager * manager = [NSFileManager defaultManager];
	
	if ( NO == [BeeDatabase isFullPath:path] )
	{
        NSString * fullPath = [NSString stringWithFormat:@"%@/BeeDatabase/", [BeeSandbox docPath]];
        if ( NO == [manager fileExistsAtPath:fullPath isDirectory:NULL] )
        {
            BOOL ret = [manager createDirectoryAtPath:fullPath
                          withIntermediateDirectories:YES
                                           attributes:nil
                                                error:nil];
            if ( NO == ret )
                return NO;
        }
    }

	_database = [[FMDatabase alloc] initWithPath:[BeeDatabase storePath:path]];
    if ( nil == _database )
		return NO;
	
	BOOL ret = [_database open];
	if ( NO == ret )
	{
		[_database release];
		_database = nil;
		return NO;
	}
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	_database.traceExecution = YES;
	_database.logsErrors = YES;
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
    
	self.filePath = path;
	return YES;
}

- (void)close
{
	if ( _database )
	{
		if ( NO == _shadow )
		{
			CC( @"[DB] close '%p'", _database );
			
			[_database close];
		}
		else
		{
			CC( @"[DB] close shadow '%p'", _database );
		}
		
		[_database release];
		_database = nil;
	}
	
	_lastQuery = [NSDate timeIntervalSinceReferenceDate];
	_lastUpdate = [NSDate timeIntervalSinceReferenceDate];
}

- (void)clearState
{
	[self __internalResetCreate];
	[self __internalResetWrite];
	[self __internalResetSelect];
}

- (void)dealloc
{
	[self close];
	
	[_database release];
	_database = nil;

	[_filePath release];
    
	[_select removeAllObjects];
	[_select release];
    
	[_from removeAllObjects];
	[_from release];
	
	[_where removeAllObjects];
	[_where release];
	
	[_like removeAllObjects];
	[_like release];
	
	[_groupby removeAllObjects];
	[_groupby release];
	
	[_having removeAllObjects];
	[_having release];
	
	[_keys removeAllObjects];
	[_keys release];
    
	[_orderby removeAllObjects];
	[_orderby release];
	
	[_set removeAllObjects];
	[_set release];
	
	[_field removeAllObjects];
	[_field release];
	
	[_table removeAllObjects];
	[_table release];
	
	[_index removeAllObjects];
	[_index release];
	
	[_resultArray removeAllObjects];
	[_resultArray release];
	
	[_classType removeAllObjects];
	[_classType release];
	
	[_associate removeAllObjects];
	[_associate release];
	
	[_has removeAllObjects];
	[_has release];
    
	[super dealloc];
}

- (void)__internalResetCreate
{
	[_field removeAllObjects];
	[_table removeAllObjects];
	[_index removeAllObjects];
	
	if ( NO == _batch )
	{
		[_classType removeAllObjects];
		[_associate removeAllObjects];
		[_has removeAllObjects];
	}
}

- (BeeDatabase *)table:(NSString *)name
{
	if ( nil == _database )
		return self;
	
	if ( nil == name )
		return self;
    
	for ( NSString * table in _table )
	{
		if ( NSOrderedSame == [table compare:name options:NSCaseInsensitiveSearch] )
			return self;
	}
    
	[_table addObject:name];
	return self;
}

- (BeeDatabase *)field:(NSString *)name type:(NSString *)type size:(NSUInteger)size
{
	if ( nil == _database )
		return self;
    
	name = [[self class] fieldNameForIdentifier:name];
	
	for ( NSMutableDictionary * dict in _field )
	{
		NSString * name2 = [dict objectForKey:@"name"];
		if ( NSOrderedSame == [name2 compare:name options:NSCaseInsensitiveSearch] )
		{
			if ( type )
			{
				[dict setObject:type forKey:@"type"];
			}
			if ( size )
			{
				[dict setObject:__INT(size) forKey:@"size"];
			}
			return self;
		}
	}
	
	[_field addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
					   name ? name : @"",		@"name",
					   type ? type : @"int",	@"type",
					   __INT(size),				@"size",
					   nil]];
    
	return self;
}

- (BeeDatabase *)unsignedType
{
	if ( nil == _database )
		return self;
    
	NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
	if ( nil == dict )
		return self;
	
	[dict setObject:__INT(1) forKey:@"unsigned"];
	return self;
}

- (BeeDatabase *)notNull
{
	if ( nil == _database )
		return self;
    
	NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
	if ( nil == dict )
		return self;
	
	[dict setObject:__INT(1) forKey:@"notNull"];
	return self;
}

- (BeeDatabase *)primaryKey
{
	if ( nil == _database )
		return self;
    
	NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
	if ( nil == dict )
		return self;
	
	[dict setObject:__INT(1) forKey:@"primaryKey"];
	return self;
}

- (BeeDatabase *)autoIncrement
{
	if ( nil == _database )
		return self;
	
	NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
	if ( nil == dict )
		return self;
	
	[dict setObject:__INT(1) forKey:@"autoIncrement"];
	return self;
}

- (BeeDatabase *)defaultZero
{
	return [self defaultValue:__INT(0)];
}

- (BeeDatabase *)defaultNull
{
	return [self defaultValue:[NSNull null]];
}

- (BeeDatabase *)defaultValue:(id)value
{
	if ( nil == _database )
		return self;
    
	NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
	if ( nil == dict )
        return self;
    
	[dict setObject:value forKey:@"default"];
	return self;
}

- (BeeDatabase *)unique
{
	if ( nil == _database )
		return self;
	
	NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
	if ( nil == dict )
		return self;
	
	[dict setObject:__INT(1) forKey:@"unique"];
	return self;
}

- (BOOL)createTableIfNotExists
{
	return [self createTableIfNotExists:nil];
}

- (BOOL)createTableIfNotExists:(NSString *)table
{
	[self __internalResetResult];
	
	if ( nil == _database )
		return NO;
    
	if ( 0 == _table.count )
		return NO;
    
	if ( nil == table )
	{
		table = (NSString *)_table.lastObject;
	}
	
	if ( nil == table || 0 == table.length )
		return NO;
	
	if ( 0 == _field.count )
		return NO;
    
	NSString * sql = [self internalCompileCreate:table];
	[self __internalResetCreate];
	
	BOOL ret = [_database executeUpdate:sql];
	if ( ret )
	{
		_lastUpdate = [NSDate timeIntervalSinceReferenceDate];
		_lastSucceed = YES;
	}
	
	return ret;
}

- (NSString *)internalCompileCreate:(NSString *)table
{
	NSMutableString * sql = [NSMutableString string];
    
	[sql appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ( ", table];
    
	for ( NSInteger i = 0; i < _field.count; ++i )
	{
		NSDictionary * dict = [_field objectAtIndex:i];
		
		NSString * name = (NSString *)[dict objectForKey:@"name"];
		NSString * type = (NSString *)[dict objectForKey:@"type"];
		NSNumber * size = (NSNumber *)[dict objectForKey:@"size"];
		NSNumber * PK = (NSNumber *)[dict objectForKey:@"primaryKey"];
		NSNumber * AI = (NSNumber *)[dict objectForKey:@"autoIncrement"];
		NSNumber * UN = (NSNumber *)[dict objectForKey:@"unique"];
		NSNumber * NN = (NSNumber *)[dict objectForKey:@"notNull"];
        
		NSObject * defaultValue = [dict objectForKey:@"default"];
        
		if ( 0 == i )
		{
			[sql appendFormat:@"%@", name];
		}
		else
		{
			[sql appendFormat:@", %@", name];
		}
        
		if ( type )
		{
			[sql appendFormat:@" %@", type];
		}
		
		if ( size && size.intValue )
		{
			[sql appendFormat:@"(%@)", size];
		}
		
		if ( PK && PK.intValue )
		{
			[sql appendString:@" PRIMARY KEY"];
		}
		
		if ( AI && AI.intValue )
		{
			[sql appendString:@" AUTOINCREMENT"];
		}
        
		if ( UN && UN.intValue )
		{
			[sql appendString:@" UNIQUE"];
		}
        
		if ( NN && NN.intValue )
		{
			[sql appendString:@" NOT NULL"];
		}
		
		if ( defaultValue )
		{
			if ( [defaultValue isKindOfClass:[NSNull class]] )
			{
				[sql appendString:@" DEFAULT NULL"];
			}
			else
			{
				[sql appendFormat:@" DEFAULT '%@'", defaultValue];
			}
		}
	}
	
	[sql appendString:@" )"];
    
	return sql;
}

- (BOOL)indexTableOn:(NSArray *)fields
{
	[self __internalResetResult];
    
	if ( nil == _database )
		return NO;
    
	if ( nil == fields || 0 == fields.count )
		return NO;
    
	if ( 0 == _table.count )
		return NO;
	
	NSString * table = (NSString *)_table.lastObject;
	if ( nil == table || 0 == table.length )
		return NO;
	
	for ( NSString * field in fields )
	{
		field = [[self class] fieldNameForIdentifier:field];
		[_index addObject:field];
	}
    
	if ( 0 == _index.count )
		return NO;
	
	NSString * sql = [self internalCompileIndex:table];
	[self __internalResetCreate];
	
	BOOL ret = [_database executeUpdate:sql];
	if ( ret )
	{
		_lastUpdate = [NSDate timeIntervalSinceReferenceDate];
		_lastSucceed = YES;
	}
	
	return ret;
}

- (BOOL)indexTable:(NSString *)table on:(NSArray *)fields
{
	[self __internalResetResult];
	
	if ( nil == _database )
		return NO;
    
	if ( nil == fields || 0 == fields.count )
		return NO;
    
	if ( 0 == _table.count )
		return NO;
    
	if ( nil == table )
	{
		table = (NSString *)_table.lastObject;
	}
	if ( nil == table || 0 == table.length )
		return NO;
	
	for ( NSString * field in fields )
	{
		field = [[self class] fieldNameForIdentifier:field];
		[_index addObject:field];
	}
    
	if ( 0 == _index.count )
		return NO;
	
	NSString * sql = [self internalCompileIndex:table];
	[self __internalResetCreate];
	
	BOOL ret = [_database executeUpdate:sql];
	if ( ret )
	{
		_lastUpdate = [NSDate timeIntervalSinceReferenceDate];
		_lastSucceed = YES;
	}
	
	return ret;
}

- (NSString *)internalCompileIndex:(NSString *)table
{
	NSMutableString * sql = [NSMutableString string];
    
	[sql appendFormat:@"CREATE INDEX IF NOT EXISTS index_%@ ON %@ ( ", table, table];
	
	for ( NSInteger i = 0; i < _index.count; ++i )
	{
		NSString * field = [_index objectAtIndex:i];
		
		if ( 0 == i )
		{
			[sql appendFormat:@"%@", field];
		}
		else
		{
			[sql appendFormat:@", %@", field];
		}
	}
	
	[sql appendString:@" )"];
	
	return sql;
}

- (BOOL)existsTable:(NSString *)table
{
	FMResultSet * result = [_database executeQuery:@"SELECT COUNT(*) as 'numrows' FROM sqlite_master WHERE type ='table' AND name = ?", table];
	if ( nil == result )
		return NO;

	_lastQuery = [NSDate timeIntervalSinceReferenceDate];
	
	BOOL succed = [result next];
	if ( NO == succed )
		return NO;
	
	NSDictionary * dict = [result resultDictionary];
	if ( nil == dict )
		return NO;
	
	NSNumber * numrows = [dict objectForKey:@"numrows"];
	if ( nil == numrows )
		return NO;
	
	return numrows.intValue ? YES : NO;
}

- (void)__internalResetSelect
{
	[_select removeAllObjects];
	[_from removeAllObjects];
	[_where removeAllObjects];
	[_like removeAllObjects];
	[_groupby removeAllObjects];
	[_having removeAllObjects];
	[_orderby removeAllObjects];
	
	if ( NO == _batch )
	{
		[_classType removeAllObjects];
		[_associate removeAllObjects];
		[_has removeAllObjects];
	}
	
	_distinct = NO;
	_limit = 0;
	_offset = 0;
}

- (void)__internalResetWrite
{
	[_set removeAllObjects];
	[_from removeAllObjects];
	[_where removeAllObjects];
	[_like removeAllObjects];
	[_orderby removeAllObjects];
	[_keys removeAllObjects];
	
	if ( NO == _batch )
	{
		[_classType removeAllObjects];
		[_associate removeAllObjects];
		[_has removeAllObjects];
	}
	
	_limit = 0;
}

- (BeeDatabase *)select:(NSString *)select
{
	if ( nil == _database )
		return self;
    
	if ( nil == select )
		return self;
	
	NSArray * components = [select componentsSeparatedByString:@","];
	for ( NSString * component in components )
	{
		component = [component trim];
		if ( component && component.length )
		{
			[_select addObject:component];
		}
	}
	
	return self;
}

- (BeeDatabase *)selectMax:(NSString *)select
{
	return [self selectMax:select alias:nil];
}

- (BeeDatabase *)selectMax:(NSString *)select alias:(NSString *)alias
{
	if ( nil == _database )
		return self;
    
	[self internalSelect:select alias:alias type:@"MAX"];
	return self;
}

- (BeeDatabase *)selectMin:(NSString *)select
{
	return [self selectMin:select alias:nil];
}

- (BeeDatabase *)selectMin:(NSString *)select alias:(NSString *)alias
{
	if ( nil == _database )
		return self;
    
	[self internalSelect:select alias:alias type:@"MIN"];
	return self;
}

- (BeeDatabase *)selectAvg:(NSString *)select
{
	return [self selectAvg:select alias:nil];
}

- (BeeDatabase *)selectAvg:(NSString *)select alias:(NSString *)alias
{
	if ( nil == _database )
		return self;
    
	[self internalSelect:select alias:alias type:@"AVG"];
	return self;
}

- (BeeDatabase *)selectSum:(NSString *)select
{
	return [self selectSum:select alias:nil];
}

- (BeeDatabase *)selectSum:(NSString *)select alias:(NSString *)alias
{
	if ( nil == _database )
		return self;
    
	[self internalSelect:select alias:alias type:@"SUM"];
	return self;
}

- (void)internalSelect:(NSString *)select alias:(NSString *)alias type:(NSString *)type
{
	if ( nil == select )
		return;
	
	if ( nil == alias || 0 == alias.length )
	{
		alias = [self internalCreateAliasFromTable:alias];
	}
    
	NSString * sql = [NSString stringWithFormat:@"%@(%@) AS %@", type, [select trim], alias];
    
	[_select addObject:sql];
}

- (NSString *)internalCreateAliasFromTable:(NSString *)name
{
	NSRange range = [name rangeOfString:@"."];
	if ( range.length )
	{
		NSArray * array = [name componentsSeparatedByString:@"."];
		if ( array && array.count )
		{
			return array.lastObject;
		}
	}
    
	return name;
}

- (BeeDatabase *)distinct:(BOOL)flag
{
	if ( nil == _database )
		return self;
    
	_distinct = flag;
	return self;
}

- (BeeDatabase *)from:(NSString *)from
{
	if ( nil == _database )
		return self;
    
	if ( nil == from )
		return self;
    
	for ( NSString * table in _from )
	{
		if ( NSOrderedSame == [table compare:from options:NSCaseInsensitiveSearch] )
			return self;
	}
    
	[_from addObject:from.trim];
	return self;
}

- (void)internalWhere:(NSString *)key value:(NSObject *)value type:(NSString *)type
{
	NSString * prefix = (0 == _where.count) ? @"" : type;
	NSString * sql = nil;
	
	key = [[self class] fieldNameForIdentifier:key];
    
	if ( nil == value )
	{
		sql = [NSString stringWithFormat:@"%@ %@ IS NULL", prefix, key];
	}
	else
	{
		if ( [value isKindOfClass:[NSNumber class]] )
		{
			sql = [NSString stringWithFormat:@"%@ %@ = %@", prefix, key, value];
		}
		else
		{
			sql = [NSString stringWithFormat:@"%@ %@ = '%@'", prefix, key, value];
		}
	}
    
	[_where addObject:sql];
}

- (BeeDatabase *)where:(NSString *)key value:(id)value
{
	if ( nil == _database )
		return self;
    
	[self internalWhere:key value:value type:@"AND"];
	return self;
}

- (BeeDatabase *)orWhere:(NSString *)key value:(id)value
{
	if ( nil == _database )
		return self;
    
	[self internalWhere:key value:value type:@"OR"];
	return self;
}

- (BeeDatabase *)whereIn:(NSString *)key values:(NSArray *)values
{
	if ( nil == _database )
		return self;
    
	[self internalWhereIn:key values:values not:NO type:@"AND"];
	return self;
}

- (BeeDatabase *)orWhereIn:(NSString *)key values:(NSArray *)values
{
	if ( nil == _database )
		return self;
    
	[self internalWhereIn:key values:values not:NO type:@"OR"];
	return self;
}

- (BeeDatabase *)whereNotIn:(NSString *)key values:(NSArray *)values
{
	if ( nil == _database )
		return self;
    
	[self internalWhereIn:key values:values not:YES type:@"AND"];
	return self;
}

- (BeeDatabase *)orWhereNotIn:(NSString *)key values:(NSArray *)values
{
	if ( nil == _database )
		return self;
    
	[self internalWhereIn:key values:values not:YES type:@"OR"];
	return self;
}

- (void)internalWhereIn:(NSString *)key values:(NSArray *)values not:(BOOL)not type:(NSString *)type
{
	if ( nil == key || nil == values || 0 == values.count )
		return;
    
	key = [[self class] fieldNameForIdentifier:key];
	
	NSMutableString * sql = [NSMutableString string];
	
	if ( _where.count )
	{
		[sql appendFormat:@"%@ ", type];
	}
    
	[sql appendString:key];
	
	if ( not )
	{
		[sql appendString:@" NOT"];
	}
    
	[sql appendString:@" IN ("];
	
	for ( NSInteger i = 0; i < values.count; ++i )
	{
		NSObject * value = [values objectAtIndex:i];
		
		if ( i > 0 )
		{
			[sql appendFormat:@", "];
		}
        
		if ( [value isKindOfClass:[NSNumber class]] )
		{
			[sql appendFormat:@"%@", value];
		}
		else
		{
			[sql appendFormat:@"'%@'", value];
		}
	}
	
	[sql appendString:@")"];
    
	[_where addObject:sql];
}

- (BeeDatabase *)like:(NSString *)field match:(id)value
{
	if ( nil == _database )
		return self;
    
	[self internalLike:field match:value type:@"AND" side:@"both" not:NO];
	return self;
}

- (BeeDatabase *)notLike:(NSString *)field match:(id)value
{
	if ( nil == _database )
		return self;
    
	[self internalLike:field match:value type:@"AND" side:@"both" not:YES];
	return self;
}

- (BeeDatabase *)orLike:(NSString *)field match:(id)value
{
	if ( nil == _database )
		return self;
    
	[self internalLike:field match:value type:@"OR" side:@"both" not:NO];
	return self;
}

- (BeeDatabase *)orNotLike:(NSString *)field match:(id)value
{
	if ( nil == _database )
		return self;
    
	[self internalLike:field match:value type:@"OR" side:@"both" not:YES];
	return self;
}

- (void)internalLike:(NSString *)field match:(NSObject *)match type:(NSString *)type side:(NSString *)side not:(BOOL)not
{
	if ( nil == field || nil == match )
		return;
    
	field = [[self class] fieldNameForIdentifier:field];
	
	NSString * value = nil;
	
	if ( [side isEqualToString:@"before"] )
	{
		value = [NSString stringWithFormat:@"%%%@", match];
	}
	else if ( [side isEqualToString:@"after"] )
	{
		value = [NSString stringWithFormat:@"%@%%", match];
	}
	else
	{
		value = [NSString stringWithFormat:@"%%%@%%", match];
	}
    
	NSMutableString * sql = [NSMutableString string];
	
	if ( _like.count )
	{
		[sql appendString:type];
	}
    
	[sql appendFormat:@" %@", field];
	
	if ( not )
	{
		[sql appendString:@" NOT"];
	}
	
	[sql appendFormat:@" LIKE '%@'", value];
    
	[_like addObject:sql];
}

- (BeeDatabase *)groupBy:(NSString *)by
{
	if ( nil == _database )
		return self;
    
	by = [[self class] fieldNameForIdentifier:by];
	
	[_groupby addObject:by];
    
	return self;
}

- (BeeDatabase *)having:(NSString *)key value:(id)value
{
	if ( nil == _database )
		return self;
    
	[self internalHaving:key value:value type:@"AND"];
	return self;
}

- (BeeDatabase *)orHaving:(NSString *)key value:(id)value
{
	if ( nil == _database )
		return self;
    
	[self internalHaving:key value:value type:@"OR"];
	return self;
}

- (void)internalHaving:(NSString *)key value:(NSObject *)value type:(NSString *)type
{
	if ( nil == key || nil == value )
		return;
	
	key = [[self class] fieldNameForIdentifier:key];
	
	NSString * sql = nil;
	
	if ( _having.count )
	{
		sql = [NSString stringWithFormat:@"%@ %@ = '%@'", type, key, value];
	}
	else
	{
		sql = [NSString stringWithFormat:@"%@ = '%@'", key, value];
	}
    
	[_having addObject:sql];
}

- (BeeDatabase *)orderAscendBy:(NSString *)by
{
	return [self orderBy:by direction:@"ASC"];
}

- (BeeDatabase *)orderDescendBy:(NSString *)by
{
	return [self orderBy:by direction:@"DESC"];
}

- (BeeDatabase *)orderRandomBy:(NSString *)by
{
	return [self orderBy:by direction:@"RAND()"];
}

- (BeeDatabase *)orderBy:(NSString *)by direction:(NSString *)direction
{
	if ( nil == _database )
		return self;
    
	if ( nil == by )
		return self;
    
	by = [[self class] fieldNameForIdentifier:by];
	
	NSString * sql = [NSString stringWithFormat:@"%@ %@", by, direction];
	[_orderby addObject:sql];
	
	return self;
}

- (BeeDatabase *)limit:(NSUInteger)limit
{
	if ( nil == _database )
		return self;
    
	_limit = limit;
	return self;
}

- (BeeDatabase *)offset:(NSUInteger)offset
{
	if ( nil == _database )
		return self;
    
	_offset = offset;
	return self;
}

- (BeeDatabase *)classInfo:(id)obj
{
	if ( nil == obj )
		return self;
	
	[_classType addObject:obj];
	return self;
}

- (BeeDatabase *)set:(NSString *)key
{
	return [self set:key value:nil];
}

- (BeeDatabase *)set:(NSString *)key value:(id)value
{
	if ( nil == _database )
		return self;
    
	if ( nil == key )
		return self;
	
	key = [[self class] fieldNameForIdentifier:key];
	value = (value ? value : [NSNull null]);
	
	[_set setObject:value forKey:key];
	return self;
}

- (void)__internalResetResult
{
	[_resultArray removeAllObjects];
	
	_resultCount = 0;
	_lastInsertID = -1;
	_lastSucceed = NO;
}

- (NSArray *)get
{
	return [self get:nil limit:0 offset:0];
}

- (NSArray *)get:(NSString *)table
{
	return [self get:table limit:0 offset:0];
}

- (NSArray *)get:(NSString *)table limit:(NSUInteger)limit
{
	return [self get:table limit:limit offset:0];
}

- (NSArray *)get:(NSString *)table limit:(NSUInteger)limit offset:(NSUInteger)offset
{
	[self __internalResetResult];
    
	if ( nil == _database )
		return nil;
    
	if ( table )
	{
		[self from:table];
	}
    
	if ( limit )
	{
		[self limit:limit];
	}
	
	if ( offset )
	{
		[self offset:offset];
	}
	
	NSString * sql = [self internalCompileSelect:nil];
	[self __internalResetSelect];
    
	FMResultSet * result = [_database executeQuery:sql];
	if ( result )
	{
		while ( [result next] )
		{
			[_resultArray addObject:[result resultDictionary]];
		}

		_resultCount = _resultArray.count;
		
		_lastQuery = [NSDate timeIntervalSinceReferenceDate];
		_lastSucceed = YES;
	}
    
	return _resultArray;
}

- (NSString *)internalCompileSelect:(NSString *)override
{
	NSMutableString * sql = [NSMutableString string];
	
	if ( override )
	{
		[sql appendString:override];
	}
	else
	{
		if ( _distinct )
		{
			[sql appendString:@"SELECT DISTINCT "];
		}
		else
		{
			[sql appendString:@"SELECT "];
		}
        
		if ( _select.count )
		{
			for ( NSInteger i = 0; i < _select.count; ++i )
			{
				NSString * select = [_select objectAtIndex:i];
				
				if ( 0 == i )
				{
					[sql appendString:select];
				}
				else
				{
					[sql appendFormat:@", %@", select];
				}
			}
		}
		else
		{
			[sql appendString:@"*"];
		}
	}
    
	if ( _from.count )
	{
		[sql appendString:@" FROM "];
		
		for ( NSInteger i = 0; i < _from.count; ++i )
		{
			NSString * from = [_from objectAtIndex:i];
            
			if ( 0 == i )
			{
				[sql appendString:from];
			}
			else
			{
				[sql appendFormat:@", %@", from];
			}
		}
	}
    
	if ( _where.count || _like.count )
	{
		[sql appendString:@" WHERE"];
	}
    
	if ( _where.count )
	{
		for ( NSString * where in _where )
		{
			[sql appendFormat:@" %@ ", where];
		}
	}
	
	if ( _like.count )
	{
		if ( _where.count )
		{
			[sql appendString:@" AND "];
		}
        
		for ( NSString * like in _like )
		{
			[sql appendFormat:@" %@ ", like];
		}
	}
    
	if ( _groupby.count )
	{
		[sql appendString:@" GROUP BY "];
		
		for ( NSInteger i = 0; i < _groupby.count; ++i )
		{
			NSString * by = [_groupby objectAtIndex:i];
			
			if ( 0 == i )
			{
				[sql appendString:by];
			}
			else
			{
				[sql appendFormat:@", %@", by];
			}
		}
	}
    
	if ( _having.count )
	{
		[sql appendString:@" HAVING "];
		
		for ( NSString * have in _having )
		{
			[sql appendFormat:@" %@ ", have];
		}
	}
    
	if ( _orderby.count )
	{
		[sql appendString:@" ORDER BY "];
        
		for ( NSInteger i = 0; i < _orderby.count; ++i )
		{
			NSString * by = [_orderby objectAtIndex:i];
			
			if ( 0 == i )
			{
				[sql appendString:by];
			}
			else
			{
				[sql appendFormat:@", %@", by];
			}
		}
	}
    
	if ( _limit )
	{
		if ( _offset )
		{
			[sql appendFormat:@" LIMIT %u, %u", _offset, _limit];
		}
		else
		{
			[sql appendFormat:@" LIMIT %u", _limit];
		}
	}
    
	return sql;
}

- (NSUInteger)count
{
	return [self count:nil];
}

- (NSUInteger)count:(NSString *)table
{
	[self __internalResetResult];
    
	if ( nil == _database )
		return 0;
    
	if ( table )
	{
		[self from:table];
	}
	
	NSString * sql = [self internalCompileSelect:@"SELECT COUNT(*) AS numrows"];
	[self __internalResetSelect];
	
	FMResultSet * result = [_database executeQuery:sql];
	if ( result )
	{
		BOOL ret = [result next];
		if ( NO == ret )
			return 0;
		
		_resultCount = (NSUInteger)[result unsignedLongLongIntForColumn:@"numrows"];
		
		_lastQuery = [NSDate timeIntervalSinceReferenceDate];
		_lastSucceed = YES;
	}
    
	return _resultCount;
}

- (NSInteger)insert
{
	return [self insert:nil];
}

- (NSInteger)insert:(NSString *)table
{
	[self __internalResetResult];
    
	if ( nil == _database )
		return -1;
    
	if ( 0 == _set.count )
		return -1;
    
	if ( nil == table )
	{
		if ( 0 == _from.count )
			return -1;
		
		table = [_from objectAtIndex:0];
	}
    
	NSMutableString *	sql = [NSMutableString string];
	NSArray *			allKeys = _set.allKeys;
	NSMutableArray *	allValues = [NSMutableArray array];
    
	NSString *			field = nil;
	NSObject *			value = nil;
    
	[sql appendFormat:@"INSERT INTO %@ (", table];
    
	for ( NSInteger i = 0; i < allKeys.count; ++i )
	{
		NSString * key = [allKeys objectAtIndex:i];
        
		field = [[self class] fieldNameForIdentifier:key];
		value = [_set objectForKey:key];
        
		if ( 0 == i )
		{
			[sql appendString:field];
		}
		else
		{
			[sql appendFormat:@", %@", field];
		}
        
		[allValues addObject:value];
	}
	
	[sql appendString:@") VALUES ("];
    
	for ( NSInteger i = 0; i < allValues.count; ++i )
	{
		if ( 0 == i )
		{
			[sql appendString:@"?"];
		}
		else
		{
			[sql appendString:@", ?"];
		}
	}
    
	[sql appendString:@")"];
    
	[self __internalResetWrite];
    
	BOOL ret = [_database executeUpdate:sql withArgumentsInArray:allValues];
	if ( ret )
	{
		_lastInsertID = (NSInteger)_database.lastInsertRowId;

		_lastUpdate = [NSDate timeIntervalSinceReferenceDate];
		_lastSucceed = YES;
	}
    
	return _lastInsertID;
}

- (BOOL)update
{
	return [self update:nil];
}

- (BOOL)update:(NSString *)table
{
	[self __internalResetResult];
    
	if ( nil == _database )
		return NO;
	
	if ( 0 == _set.count )
		return NO;
	
	if ( nil == table )
	{
		if ( 0 == _from.count )
			return NO;
		
		table = [_from objectAtIndex:0];
	}
    
	NSMutableString *	sql = [NSMutableString string];
	NSArray *			allKeys = _set.allKeys;
	NSMutableArray *	allValues = [NSMutableArray array];
    
	NSString *			field = nil;
	NSObject *			value = nil;
    
	[sql appendFormat:@"UPDATE %@ SET ", table];
    
	for ( NSInteger i = 0; i < allKeys.count; ++i )
	{
		NSString * key = [allKeys objectAtIndex:i];
        
		field = [[self class] fieldNameForIdentifier:key];
		value = [_set objectForKey:key];
        
		if ( value )
		{
			[allValues addObject:value];
			
			if ( 0 == i )
			{
				[sql appendFormat:@"%@ = ?", field];
			}
			else
			{
				[sql appendFormat:@", %@ = ?", field];
			}
		}
	}
    
	if ( _where.count )
	{
		[sql appendString:@" WHERE"];
		
		for ( NSString * where in _where )
		{
			[sql appendFormat:@" %@", where];
		}
	}
	
	if ( _orderby.count )
	{
		[sql appendString:@" ORDER BY "];
		
		for ( NSInteger i = 0; i < _orderby.count; ++i )
		{
			NSString * by = [_orderby objectAtIndex:i];
			
			if ( 0 == i )
			{
				[sql appendString:by];
			}
			else
			{
				[sql appendFormat:@", %@", by];
			}
		}
	}
    
	if ( _limit )
	{
		[sql appendFormat:@" LIMIT %u", _limit];
	}
	
	[self __internalResetWrite];
    
	BOOL ret = [_database executeUpdate:sql withArgumentsInArray:allValues];
	if ( ret )
	{
		_lastUpdate = [NSDate timeIntervalSinceReferenceDate];
		_lastSucceed = YES;
		
		// TODO: ...
	}
	return ret;
}

- (BOOL)empty
{
	return [self empty:nil];
}

- (BOOL)empty:(NSString *)table
{
	[self __internalResetResult];
	
	if ( nil == _database )
		return NO;
    
	if ( nil == table )
	{
		if ( 0 == _from.count )
			return NO;
		
		table = [_from objectAtIndex:0];
	}
	
	NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", table];
    
	[self __internalResetWrite];
	
	BOOL ret = [_database executeUpdate:sql];
	if ( ret )
	{
		_lastUpdate = [NSDate timeIntervalSinceReferenceDate];
		_lastSucceed = YES;
		
		// TODO: ...
	}
	return ret;
}

- (BOOL)truncate
{
	return [self truncate:nil];
}

- (BOOL)truncate:(NSString *)table
{
	[self __internalResetResult];
	
	if ( nil == _database )
		return NO;
    
	if ( nil == table )
	{
		if ( 0 == _from.count )
			return NO;
		
		table = [_from objectAtIndex:0];
	}
	
	NSString * sql = [NSString stringWithFormat:@"TRUNCATE %@", table];
    
	[self __internalResetWrite];
	
	BOOL ret = [_database executeUpdate:sql];
	if ( ret )
	{
		_lastUpdate = [NSDate timeIntervalSinceReferenceDate];
		_lastSucceed = YES;
		
		// TODO: ...
	}
	return ret;
}

- (BOOL)delete
{
	return [self delete:nil];
}

- (BOOL)delete:(NSString *)table
{
	[self __internalResetResult];
	
	if ( nil == _database )
		return NO;
    
	if ( nil == table )
	{
		if ( 0 == _from.count )
			return NO;
		
		table = [_from objectAtIndex:0];
	}
	
	if ( 0 == _where.count && 0 == _like.count )
		return NO;
	
	NSMutableString * sql = [NSMutableString string];
	
	[sql appendFormat:@"DELETE FROM %@", table];
    
	if ( _where.count || _like.count )
	{
		[sql appendString:@" WHERE "];
		
		if ( _where.count )
		{
			for ( NSString * where in _where )
			{
				[sql appendFormat:@" %@ ", where];
			}
		}
        
		if ( _like.count )
		{
			if ( _where.count )
			{
				[sql appendString:@" AND "];
			}
			
			for ( NSString * like in _like )
			{
				[sql appendFormat:@" %@ ", like];
			}
		}
	}
	
	if ( _limit )
	{
		[sql appendFormat:@" LIMIT %u", _limit];
	}
	
	[self __internalResetWrite];
	
	BOOL ret = [_database executeUpdate:sql];
	if ( ret )
	{
		_lastUpdate = [NSDate timeIntervalSinceReferenceDate];
		_lastSucceed = YES;
		
		// TODO: ...
	}
	return ret;
}

+ (NSString *)fieldNameForIdentifier:(NSString *)identifier
{
	NSString * name = identifier;
	name = [name stringByReplacingOccurrencesOfString:@"." withString:@"_"];
	name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	return name;
}

+ (NSString *)tableNameForClass:(Class)clazz
{
	if ( [clazz respondsToSelector:@selector(mapTableName)] )
	{
		return [clazz performSelector:@selector(mapTableName)];
	}

	return [NSString stringWithFormat:@"table_%@", [clazz description]];
}

- (Class)classType
{
	NSString * className = _classType.lastObject;
	if ( nil == className || 0 == className.length )
		return NULL;
	
	Class classType = NSClassFromString( className );
	if ( nil == classType || NO == [classType conformsToProtocol:@protocol(BeeActiveProtocol)] )
		return NULL;
    
	return classType;
}

- (NSArray *)associateObjects
{
	return _associate;
}

- (NSArray *)associateObjectsFor:(Class)clazz
{
	NSMutableArray * array = [NSMutableArray array];
	
	for ( NSObject * obj in _associate )
	{
		if ( [obj isKindOfClass:clazz] )
		{
			[array addObject:obj];
		}
	}
    
	return array;
}

- (NSArray *)hasObjects
{
	return _has;
}

- (NSArray *)hasObjectsFor:(Class)clazz
{
	NSMutableArray * array = [NSMutableArray array];
    
	for ( NSObject * obj in _has )
	{
		if ( [obj isKindOfClass:clazz] )
		{
			[array addObject:obj];
		}
	}
    
	return array;
}

- (void)classType:(Class)clazz
{
	if ( nil == clazz )
		return;
	
	[_classType addObject:[clazz description]];
    
	[self from:[BeeDatabase tableNameForClass:clazz]];
}

- (void)associate:(NSObject *)obj
{
	if ( nil == obj )
		return;
    
	[_associate addObject:obj];
}

- (void)has:(NSObject *)obj
{
	if ( nil == obj )
		return;
    
	[_has addObject:obj];
}

- (BeeDatabaseBlockN)TABLE
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self table:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)FIELD
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
        
		NSString *	field = (NSString *)first;
		NSString *	type = va_arg( args, NSString * );
        va_end( args );
		return [self field:field type:type size:0];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)FIELD_WITH_SIZE
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString *	field = (NSString *)first;
		NSString *	type = va_arg( args, NSString * );
		NSUInteger	size = va_arg( args, NSUInteger );
		
        va_end( args );
        
		return [self field:field type:type size:size];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)UNSIGNED
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		return [self unsignedType];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)NOT_NULL
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		return [self notNull];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)PRIMARY_KEY
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		return [self primaryKey];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)AUTO_INREMENT
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		return [self autoIncrement];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)DEFAULT_ZERO
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		return [self defaultZero];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)DEFAULT_NULL
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		return [self defaultNull];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)DEFAULT
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self defaultValue:first];
	};
    
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)UNIQUE
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		return [self unique];
	};
    
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)CREATE_IF_NOT_EXISTS
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		return [self createTableIfNotExists] ? self : nil;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)INDEX_ON
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id field, ... )
	{
		va_list args;
		va_start( args, field );
		
		NSMutableArray * array = [NSMutableArray array];
		
		for ( ;; field = nil )
		{
			NSObject * name = field ? field : va_arg( args, NSObject * );
			if ( nil == name || NO == [name isKindOfClass:[NSString class]] )
				break;
			
			[array addObject:(NSString *)name];
		}
		va_end(args);
		return [self indexTableOn:array] ? self : nil;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SELECT
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self select:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SELECT_MAX
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self selectMax:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SELECT_MAX_ALIAS
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * field = (NSString *)first;
		NSString * alias = (NSString *)va_arg( args, NSString * );
		va_end( args );
		return [self selectMax:field alias:alias];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SELECT_MIN
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self selectMin:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SELECT_MIN_ALIAS
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * field = (NSString *)first;
		NSString * alias = (NSString *)va_arg( args, NSString * );
		va_end(args);
		return [self selectMin:field alias:alias];
	};
    
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SELECT_AVG
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self selectAvg:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SELECT_AVG_ALIAS
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * field = (NSString *)first;
		NSString * alias = (NSString *)va_arg( args, NSString * );
		va_end( args );
		return [self selectAvg:field alias:alias];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SELECT_SUM
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self selectSum:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SELECT_SUM_ALIAS
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * field = (NSString *)first;
		NSString * alias = (NSString *)va_arg( args, NSString * );
		va_end( args );
		return [self selectSum:field alias:alias];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)DISTINCT
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		return [self distinct:YES];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)FROM
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self from:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)WHERE
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * key = (NSString *)first;
		NSObject * value = (NSObject *)va_arg( args, NSObject * );
		va_end( args );
		return [self where:key value:value];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)OR_WHERE
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * key = (NSString *)first;
		NSObject * value = (NSObject *)va_arg( args, NSObject * );
		va_end( args );
		return [self orWhere:key value:value];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)WHERE_IN
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id field, ... )
	{
		va_list args;
		va_start( args, field );
		
		NSString * key = (NSString *)field;
		
		NSMutableArray * array = [NSMutableArray array];
		for ( ;; )
		{
			NSObject * value = va_arg( args, NSObject * );
			if ( nil == value )
				break;
			
			[array addObject:(NSString *)value];
		}
        va_end( args );
		return [self whereIn:key values:array];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)OR_WHERE_IN
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id field, ... )
	{
		va_list args;
		va_start( args, field );
		
		NSString * key = (NSString *)field;
		
		NSMutableArray * array = [NSMutableArray array];
		for ( ;; )
		{
			NSObject * value = va_arg( args, NSObject * );
			if ( nil == value )
				break;
			
			[array addObject:(NSString *)value];
		}
        va_end( args );
		return [self orWhereIn:key values:array];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)WHERE_NOT_IN
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id field, ... )
	{
		va_list args;
		va_start( args, field );
		
		NSString * key = (NSString *)field;
		
		NSMutableArray * array = [NSMutableArray array];
		for ( ;; )
		{
			NSObject * value = va_arg( args, NSObject * );
			if ( nil == value )
				break;
			
			[array addObject:(NSString *)value];
		}
		va_end( args );
		return [self whereNotIn:key values:array];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)OR_WHERE_NOT_IN
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id field, ... )
	{
		va_list args;
		va_start( args, field );
		
		NSString * key = (NSString *)field;
		
		NSMutableArray * array = [NSMutableArray array];
		for ( ;; )
		{
			NSObject * value = va_arg( args, NSObject * );
			if ( nil == value )
				break;
			
			[array addObject:(NSString *)value];
		}
        va_end( args );
		return [self orWhereNotIn:key values:array];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)LIKE
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * key = (NSString *)first;
		NSObject * value = (NSObject *)va_arg( args, NSObject * );
		va_end( args );
		return [self like:key match:value];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)NOT_LIKE
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * key = (NSString *)first;
		NSObject * value = (NSObject *)va_arg( args, NSObject * );
		
		return [self notLike:key match:value];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)OR_LIKE
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * key = (NSString *)first;
		NSObject * value = (NSObject *)va_arg( args, NSObject * );
		va_end( args );
		return [self orLike:key match:value];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)OR_NOT_LIKE
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * key = (NSString *)first;
		NSObject * value = (NSObject *)va_arg( args, NSObject * );
		va_end( args );
		return [self orNotLike:key match:value];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)GROUP_BY
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self groupBy:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)HAVING
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * key = (NSString *)first;
		NSObject * value = (NSObject *)va_arg( args, NSObject * );
		va_end( args );
		return [self having:key value:value];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)OR_HAVING
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * key = (NSString *)first;
		NSObject * value = (NSObject *)va_arg( args, NSObject * );
		va_end( args );
		return [self orHaving:key value:value];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)ORDER_ASC_BY
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self orderAscendBy:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)ORDER_DESC_BY
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self orderDescendBy:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)ORDER_RAND_BY
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self orderRandomBy:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)ORDER_BY
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * by = (NSString *)first;
		NSString * direction = (NSString *)va_arg( args, NSString * );
		va_end( args );
		return [self orderBy:by direction:direction];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockU)LIMIT
{
	BeeDatabaseBlockU block = ^ BeeDatabase * ( NSUInteger value )
	{
		return [self limit:value];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockU)OFFSET
{
	BeeDatabaseBlockU block = ^ BeeDatabase * ( NSUInteger value )
	{
		return [self offset:value];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SET_NULL
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		return [self set:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)SET
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * key = (NSString *)first;
		NSObject * value = (NSObject *)va_arg( args, NSObject * );
		va_end( args );
		return [self set:key value:value];
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)GET
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		[self get];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)COUNT
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		[self count];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)INSERT
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		[self insert];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)UPDATE
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		[self update];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)EMPTY
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		[self empty];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)TRUNCATE
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		[self truncate];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)DELETE
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		[self delete];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)CLASS_TYPE
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		[self classType:(Class)first];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)ASSOCIATE
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		[self associate:first];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)BELONG_TO
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		[self associate:first];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlockN)HAS
{
	BeeDatabaseBlockN block = ^ BeeDatabase * ( id first, ... )
	{
		[self has:first];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)BATCH_BEGIN
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		_batch = YES;
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeDatabaseBlock)BATCH_END
{
	BeeDatabaseBlock block = ^ BeeDatabase * ( void )
	{
		_batch = NO;
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

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
#import "Bee_Singleton.h"
#import "NSObject+BeeProperty.h"
#import "NSObject+BeeNotification.h"

#import "FMDatabase.h"

#pragma mark -

@class BeeDatabase;

typedef BeeDatabase *	(^BeeDatabaseBlockI)( NSInteger val );
typedef BeeDatabase *	(^BeeDatabaseBlockU)( NSUInteger val );
typedef BeeDatabase *	(^BeeDatabaseBlockN)( id key, ... );
typedef BeeDatabase *	(^BeeDatabaseBlockB)( BOOL flag );
typedef BeeDatabase *	(^BeeDatabaseBlock)( void );
typedef NSArray *		(^BeeDatabaseArrayBlock)( void );
typedef id				(^BeeDatabaseObjectBlock)( void );
typedef id				(^BeeDatabaseObjectBlockN)( id key, ... );
typedef BOOL			(^BeeDatabaseBoolBlock)( void );

#pragma mark -

@interface BeeDatabase : NSObject
{
	BOOL					_autoOptimize;	// TO BE DONE
	BOOL					_batch;
	NSUInteger				_identifier;
	NSString *				_filePath;
	
	BOOL					_shadow;
	FMDatabase *			_database;

	NSMutableArray *		_select;
	BOOL					_distinct;
	NSMutableArray *		_from;
	NSMutableArray *		_where;
	NSMutableArray *		_like;
	NSMutableArray *		_groupby;
	NSMutableArray *		_having;
	NSMutableArray *		_keys;
	NSUInteger				_limit;
	NSUInteger				_offset;
	NSMutableArray *		_orderby;
	NSMutableDictionary *	_set;

	NSMutableArray *		_resultArray;
	NSUInteger				_resultCount;
	NSInteger				_lastInsertID;
	BOOL					_lastSucceed;

	NSMutableArray *		_table;
	NSMutableArray *		_field;
	NSMutableArray *		_index;
	
	NSMutableArray *		_classType;
	NSMutableArray *		_associate;
	NSMutableArray *		_has;
	
	NSTimeInterval			_lastQuery;
	NSTimeInterval			_lastUpdate;
}

@property (nonatomic, assign) BOOL					autoOptimize;	// TO BE DONE
@property (nonatomic, retain) NSString *			filePath;

@property (nonatomic, assign) BOOL					shadow;
@property (nonatomic, retain) FMDatabase *			database;

@property (nonatomic, readonly) NSUInteger			total;
@property (nonatomic, readonly) BOOL				ready;
@property (nonatomic, readonly) NSUInteger			identifier;

@property (nonatomic, readonly) BeeDatabaseBlockN	TABLE;
@property (nonatomic, readonly) BeeDatabaseBlockN	FIELD;
@property (nonatomic, readonly) BeeDatabaseBlockN	FIELD_WITH_SIZE;
@property (nonatomic, readonly) BeeDatabaseBlock	UNSIGNED;
@property (nonatomic, readonly) BeeDatabaseBlock	NOT_NULL;
@property (nonatomic, readonly) BeeDatabaseBlock	PRIMARY_KEY;
@property (nonatomic, readonly) BeeDatabaseBlock	AUTO_INREMENT;
@property (nonatomic, readonly) BeeDatabaseBlock	DEFAULT_ZERO;
@property (nonatomic, readonly) BeeDatabaseBlock	DEFAULT_NULL;
@property (nonatomic, readonly) BeeDatabaseBlockN	DEFAULT;
@property (nonatomic, readonly) BeeDatabaseBlock	UNIQUE;
@property (nonatomic, readonly) BeeDatabaseBlock	CREATE_IF_NOT_EXISTS;

@property (nonatomic, readonly) BeeDatabaseBlockN	INDEX_ON;

@property (nonatomic, readonly) BeeDatabaseBlockN	SELECT;
@property (nonatomic, readonly) BeeDatabaseBlockN	SELECT_MAX;
@property (nonatomic, readonly) BeeDatabaseBlockN	SELECT_MAX_ALIAS;
@property (nonatomic, readonly) BeeDatabaseBlockN	SELECT_MIN;
@property (nonatomic, readonly) BeeDatabaseBlockN	SELECT_MIN_ALIAS;
@property (nonatomic, readonly) BeeDatabaseBlockN	SELECT_AVG;
@property (nonatomic, readonly) BeeDatabaseBlockN	SELECT_AVG_ALIAS;
@property (nonatomic, readonly) BeeDatabaseBlockN	SELECT_SUM;
@property (nonatomic, readonly) BeeDatabaseBlockN	SELECT_SUM_ALIAS;

@property (nonatomic, readonly) BeeDatabaseBlock	DISTINCT;
@property (nonatomic, readonly) BeeDatabaseBlockN	FROM;

@property (nonatomic, readonly) BeeDatabaseBlockN	WHERE;
@property (nonatomic, readonly) BeeDatabaseBlockN	OR_WHERE;

@property (nonatomic, readonly) BeeDatabaseBlockN	WHERE_IN;
@property (nonatomic, readonly) BeeDatabaseBlockN	OR_WHERE_IN;
@property (nonatomic, readonly) BeeDatabaseBlockN	WHERE_NOT_IN;
@property (nonatomic, readonly) BeeDatabaseBlockN	OR_WHERE_NOT_IN;

@property (nonatomic, readonly) BeeDatabaseBlockN	LIKE;
@property (nonatomic, readonly) BeeDatabaseBlockN	NOT_LIKE;
@property (nonatomic, readonly) BeeDatabaseBlockN	OR_LIKE;
@property (nonatomic, readonly) BeeDatabaseBlockN	OR_NOT_LIKE;

@property (nonatomic, readonly) BeeDatabaseBlockN	GROUP_BY;

@property (nonatomic, readonly) BeeDatabaseBlockN	HAVING;
@property (nonatomic, readonly) BeeDatabaseBlockN	OR_HAVING;

@property (nonatomic, readonly) BeeDatabaseBlockN	ORDER_ASC_BY;
@property (nonatomic, readonly) BeeDatabaseBlockN	ORDER_DESC_BY;
@property (nonatomic, readonly) BeeDatabaseBlockN	ORDER_RAND_BY;
@property (nonatomic, readonly) BeeDatabaseBlockN	ORDER_BY;

@property (nonatomic, readonly) BeeDatabaseBlockU	LIMIT;
@property (nonatomic, readonly) BeeDatabaseBlockU	OFFSET;

@property (nonatomic, readonly) BeeDatabaseBlockN	SET;
@property (nonatomic, readonly) BeeDatabaseBlockN	SET_NULL;

@property (nonatomic, readonly) BeeDatabaseBlock	GET;
@property (nonatomic, readonly) BeeDatabaseBlock	COUNT;

@property (nonatomic, readonly) BeeDatabaseBlock	INSERT;
@property (nonatomic, readonly) BeeDatabaseBlock	UPDATE;
@property (nonatomic, readonly) BeeDatabaseBlock	EMPTY;
@property (nonatomic, readonly) BeeDatabaseBlock	TRUNCATE;
@property (nonatomic, readonly) BeeDatabaseBlock	DELETE;

@property (nonatomic, readonly) BeeDatabaseBlock	BATCH_BEGIN;
@property (nonatomic, readonly) BeeDatabaseBlock	BATCH_END;

@property (nonatomic, readonly) BeeDatabaseBlockN	CLASS_TYPE;	// for activeRecord
@property (nonatomic, readonly) BeeDatabaseBlockN	ASSOCIATE;	// for activeRecord
@property (nonatomic, readonly) BeeDatabaseBlockN	BELONG_TO;	// for activeRecord
@property (nonatomic, readonly) BeeDatabaseBlockN	HAS;		// for activeRecord

@property (nonatomic, readonly) NSArray *			resultArray;
@property (nonatomic, readonly) NSUInteger			resultCount;
@property (nonatomic, readonly) NSInteger			insertID;
@property (nonatomic, readonly) BOOL				succeed;

@property (nonatomic, readonly) NSTimeInterval		lastQuery;
@property (nonatomic, readonly) NSTimeInterval		lastUpdate;

+ (BOOL)openSharedDatabase:(NSString *)path;
+ (BOOL)existsSharedDatabase:(NSString *)path;
+ (void)closeSharedDatabase;

+ (void)setSharedDatabase:(BeeDatabase *)db;
+ (BeeDatabase *)sharedDatabase;

+ (void)scopeEnter;
+ (void)scopeLeave;

- (id)initWithPath:(NSString *)path;
- (id)initWithDatabase:(FMDatabase *)db;

+ (BOOL)exists:(NSString *)path;
- (BOOL)open:(NSString *)path;
- (void)close;
- (void)clearState;

+ (NSString *)fieldNameForIdentifier:(NSString *)identifier;
+ (NSString *)tableNameForClass:(Class)clazz;

- (Class)classType;

- (NSArray *)associateObjects;
- (NSArray *)associateObjectsFor:(Class)clazz;

- (NSArray *)hasObjects;
- (NSArray *)hasObjectsFor:(Class)clazz;

// internal user only
- (void)__internalResetCreate;
- (void)__internalResetSelect;
- (void)__internalResetWrite;
- (void)__internalResetResult;

@end

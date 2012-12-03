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

//	obj1.to( obj2 )
//		.to( obj3 )
//		.to( obj4 );

#pragma mark -

@class BeeDatabase;

@interface NSObject(BeeDatabase)
@property (nonatomic, readonly) BeeDatabase * DB;
+ (BeeDatabase *)DB;
@end

#pragma mark -

typedef BeeDatabase *	(^BeeDatabaseBlockI)( NSInteger val );
typedef BeeDatabase *	(^BeeDatabaseBlockU)( NSUInteger val );
typedef BeeDatabase *	(^BeeDatabaseBlockN)( id key, ... );
typedef BeeDatabase *	(^BeeDatabaseBlock)( void );
typedef NSArray *		(^BeeDatabaseArrayBlock)( void );

#pragma mark -

@interface BeeDatabase : NSObject
{
	BOOL					_autoOptimize;	// TO BE DONE
	NSString *				_filePath;
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
	
	NSMutableArray *		_userInfo;
}

@property (nonatomic, assign) BOOL					autoOptimize;	// TO BE DONE
@property (nonatomic, retain) NSString *			filePath;
@property (nonatomic, readonly) BOOL				ready;

@property (nonatomic, readonly) BeeDatabaseBlockN	TABLE;
@property (nonatomic, readonly) BeeDatabaseBlockN	FIELD;
@property (nonatomic, readonly) BeeDatabaseBlock	UNSIGNED;
@property (nonatomic, readonly) BeeDatabaseBlock	NOT_NULL;
@property (nonatomic, readonly) BeeDatabaseBlock	PRIMARY_KEY;
@property (nonatomic, readonly) BeeDatabaseBlock	AUTO_INREMENT;
@property (nonatomic, readonly) BeeDatabaseBlock	DEFAULT_ZERO;
@property (nonatomic, readonly) BeeDatabaseBlock	DEFAULT_NULL;
@property (nonatomic, readonly) BeeDatabaseBlockN	DEFAULT;
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

@property (nonatomic, readonly) NSArray *			resultArray;
@property (nonatomic, readonly) NSUInteger			resultCount;
@property (nonatomic, readonly) NSInteger			insertID;
@property (nonatomic, readonly) BOOL				succeed;

+ (BOOL)openSharedDatabase:(NSString *)path;
+ (BOOL)existsSharedDatabase:(NSString *)path;
+ (void)closeSharedDatabase;

+ (void)setSharedDatabase:(BeeDatabase *)db;
+ (BeeDatabase *)sharedDatabase;

- (id)initWithPath:(NSString *)path;

+ (BOOL)exists:(NSString *)path;
- (BOOL)open:(NSString *)path;
- (void)close;
- (void)clearState;

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

- (BeeDatabase *)userInfo:(id)obj;

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
- (NSInteger)insert:(NSString *)table set:(NSDictionary *)set;
- (NSInteger)insertSet:(NSDictionary *)set;

- (BOOL)update;
- (BOOL)update:(NSString *)table;
- (BOOL)update:(NSString *)table set:(NSDictionary *)set;
- (BOOL)updateSet:(NSDictionary *)set;

- (BOOL)empty;
- (BOOL)empty:(NSString *)table;

- (BOOL)truncate;
- (BOOL)truncate:(NSString *)table;

- (BOOL)delete;
- (BOOL)delete:(NSString *)table;

// internal user only

- (void)__internalResetCreate;
- (void)__internalResetSelect;
- (void)__internalResetWrite;
- (void)__internalResetResult;

@end

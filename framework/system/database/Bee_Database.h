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
#import "Bee_Package.h"
#import "Bee_Foundation.h"
#import "Bee_SystemConfig.h"
#import "Bee_SystemPackage.h"

#pragma mark -

AS_PACKAGE( BeePackage_System, BeeDatabase, db );

#pragma mark -

@class FMDatabase;
@class BeeDatabase;

typedef BeeDatabase *	(^BeeDatabaseBlockI)( NSInteger val );
typedef BeeDatabase *	(^BeeDatabaseBlockU)( NSUInteger val );
typedef BeeDatabase *	(^BeeDatabaseBlockN)( id key, ... );
typedef BeeDatabase *	(^BeeDatabaseBlockB)( BOOL flag );
typedef BeeDatabase *	(^BeeDatabaseBlock)( void );
typedef NSArray *		(^BeeDatabaseArrayBlock)( void );
typedef NSArray *		(^BeeDatabaseArrayBlockU)( NSUInteger val );
typedef NSArray *		(^BeeDatabaseArrayBlockUN)( NSUInteger val, ... );
typedef id				(^BeeDatabaseObjectBlock)( void );
typedef id				(^BeeDatabaseObjectBlockN)( id key, ... );
typedef BOOL			(^BeeDatabaseBoolBlock)( void );
typedef NSInteger		(^BeeDatabaseIntBlock)( void );
typedef NSUInteger		(^BeeDatabaseUintBlock)( void );

#pragma mark -

@interface BeeDatabase : NSObject

AS_NOTIFICATION( SHARED_DB_OPEN )
AS_NOTIFICATION( SHARED_DB_CLOSE )

@property (nonatomic, assign) BOOL						autoOptimize;	// TO BE DONE
@property (nonatomic, retain) NSString *				filePath;

@property (nonatomic, assign) BOOL						shadow;
@property (atomic, retain) FMDatabase *					database;

@property (nonatomic, readonly) NSUInteger				total;
@property (nonatomic, readonly) BOOL					ready;
@property (nonatomic, readonly) NSInteger				identifier;

@property (nonatomic, readonly) BeeDatabaseBlockN		TABLE;
@property (nonatomic, readonly) BeeDatabaseBlockN		FIELD;
@property (nonatomic, readonly) BeeDatabaseBlockN		FIELD_WITH_SIZE;
@property (nonatomic, readonly) BeeDatabaseBlock		UNSIGNED;
@property (nonatomic, readonly) BeeDatabaseBlock		NOT_NULL;
@property (nonatomic, readonly) BeeDatabaseBlock		PRIMARY_KEY;
@property (nonatomic, readonly) BeeDatabaseBlock		AUTO_INREMENT;
@property (nonatomic, readonly) BeeDatabaseBlock		DEFAULT_ZERO;
@property (nonatomic, readonly) BeeDatabaseBlock		DEFAULT_NULL;
@property (nonatomic, readonly) BeeDatabaseBlockN		DEFAULT;
@property (nonatomic, readonly) BeeDatabaseBlock		UNIQUE;
@property (nonatomic, readonly) BeeDatabaseBlock		CREATE_IF_NOT_EXISTS;

@property (nonatomic, readonly) BeeDatabaseBlockN		INDEX_ON;

@property (nonatomic, readonly) BeeDatabaseBlockN		SELECT;
@property (nonatomic, readonly) BeeDatabaseBlockN		SELECT_MAX;
@property (nonatomic, readonly) BeeDatabaseBlockN		SELECT_MAX_ALIAS;
@property (nonatomic, readonly) BeeDatabaseBlockN		SELECT_MIN;
@property (nonatomic, readonly) BeeDatabaseBlockN		SELECT_MIN_ALIAS;
@property (nonatomic, readonly) BeeDatabaseBlockN		SELECT_AVG;
@property (nonatomic, readonly) BeeDatabaseBlockN		SELECT_AVG_ALIAS;
@property (nonatomic, readonly) BeeDatabaseBlockN		SELECT_SUM;
@property (nonatomic, readonly) BeeDatabaseBlockN		SELECT_SUM_ALIAS;

@property (nonatomic, readonly) BeeDatabaseBlock		DISTINCT;
@property (nonatomic, readonly) BeeDatabaseBlockN		FROM;

@property (nonatomic, readonly) BeeDatabaseBlockN		WHERE;
@property (nonatomic, readonly) BeeDatabaseBlockN		OR_WHERE;

@property (nonatomic, readonly) BeeDatabaseBlockN		WHERE_OPERATOR;
@property (nonatomic, readonly) BeeDatabaseBlockN		OR_WHERE_OPERATOR;

@property (nonatomic, readonly) BeeDatabaseBlockN		WHERE_IN;
@property (nonatomic, readonly) BeeDatabaseBlockN		OR_WHERE_IN;
@property (nonatomic, readonly) BeeDatabaseBlockN		WHERE_NOT_IN;
@property (nonatomic, readonly) BeeDatabaseBlockN		OR_WHERE_NOT_IN;

@property (nonatomic, readonly) BeeDatabaseBlockN		LIKE;
@property (nonatomic, readonly) BeeDatabaseBlockN		NOT_LIKE;
@property (nonatomic, readonly) BeeDatabaseBlockN		OR_LIKE;
@property (nonatomic, readonly) BeeDatabaseBlockN		OR_NOT_LIKE;

@property (nonatomic, readonly) BeeDatabaseBlockN		GROUP_BY;

@property (nonatomic, readonly) BeeDatabaseBlockN		HAVING;
@property (nonatomic, readonly) BeeDatabaseBlockN		OR_HAVING;

@property (nonatomic, readonly) BeeDatabaseBlockN		ORDER_ASC_BY;
@property (nonatomic, readonly) BeeDatabaseBlockN		ORDER_DESC_BY;
@property (nonatomic, readonly) BeeDatabaseBlockN		ORDER_RAND_BY;
@property (nonatomic, readonly) BeeDatabaseBlockN		ORDER_BY;

@property (nonatomic, readonly) BeeDatabaseBlockU		LIMIT;
@property (nonatomic, readonly) BeeDatabaseBlockU		OFFSET;

@property (nonatomic, readonly) BeeDatabaseBlockN		SET;
@property (nonatomic, readonly) BeeDatabaseBlockN		SET_NULL;

@property (nonatomic, readonly) BeeDatabaseArrayBlock	GET;
@property (nonatomic, readonly) BeeDatabaseUintBlock	COUNT;

@property (nonatomic, readonly) BeeDatabaseIntBlock		INSERT;
@property (nonatomic, readonly) BeeDatabaseBoolBlock	UPDATE;
@property (nonatomic, readonly) BeeDatabaseBoolBlock	EMPTY;
@property (nonatomic, readonly) BeeDatabaseBoolBlock	TRUNCATE;
@property (nonatomic, readonly) BeeDatabaseBoolBlock	DELETE;

@property (nonatomic, readonly) BeeDatabaseBlock		BATCH_BEGIN;
@property (nonatomic, readonly) BeeDatabaseBlock		BATCH_END;

@property (nonatomic, readonly) BeeDatabaseBlockN		CLASS_TYPE;	// for activeRecord
@property (nonatomic, readonly) BeeDatabaseBlockN		ASSOCIATE;	// for activeRecord
@property (nonatomic, readonly) BeeDatabaseBlockN		BELONG_TO;	// for activeRecord
@property (nonatomic, readonly) BeeDatabaseBlockN		HAS;		// for activeRecord

@property (nonatomic, readonly) BeeDatabaseBlock		LOCK;		// for multi-thread
@property (nonatomic, readonly) BeeDatabaseBlock		UNLOCK;		// for multi-thread

@property (nonatomic, readonly) NSArray *				resultArray;
@property (nonatomic, readonly) NSUInteger				resultCount;
@property (nonatomic, readonly) NSInteger				insertID;
@property (nonatomic, readonly) BOOL					succeed;

@property (nonatomic, readonly) NSTimeInterval			lastQuery;
@property (nonatomic, readonly) NSTimeInterval			lastUpdate;

+ (BOOL)openSharedDatabase:(NSString *)path;
+ (BOOL)existsSharedDatabase:(NSString *)path;
+ (void)closeSharedDatabase;

+ (void)setSharedDatabase:(BeeDatabase *)db;
+ (BeeDatabase *)sharedDatabase;
+ (BeeDatabase *)sharedInstance;	// same as sharedDatabase

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
- (void)__internalSetResult:(NSArray *)array;

@end

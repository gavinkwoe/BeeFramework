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
#import "Bee_Database.h"
#include <objc/runtime.h>

#pragma mark -

@class BeeBaseActiveRecord;
@class BeeActiveRecord;

#pragma mark -

@interface BeeBaseActiveRecord : NSObject

- (id)initWithDict:(NSDictionary *)dict;
- (void)bindDict:(NSDictionary *)dict;

- (void)load;	// for subclass
- (void)unload;	// for subclass

- (BOOL)insert;
- (BOOL)update;
- (BOOL)delete;

@end

#pragma mark -

typedef BOOL (^BeeActiveRecordBoolBlock)( void );

#pragma mark -

@interface BeeActiveRecord : BeeBaseActiveRecord
{
	NSNumber * _ID;
}

@property (nonatomic, retain) NSNumber *					ID;	// default primary key

@property (nonatomic, readonly) BeeActiveRecordBoolBlock	INSERT;
@property (nonatomic, readonly) BeeActiveRecordBoolBlock	UPDATE;
@property (nonatomic, readonly) BeeActiveRecordBoolBlock	DELETE;

+ (void)mapRelation;	// for subclass
+ (void)mapPropertyAsKey:(NSString *)name;
+ (void)mapProperty:(NSString *)name;
+ (void)mapProperty:(NSString *)name defaultValue:(id)value;

+ (NSString *)tableNameFor:(Class)clazz;

@end

#pragma mark -

@interface BeeDatabase(BeeActiveRecord)

@property (nonatomic, readonly) BeeDatabaseBlockN		CLASS;
@property (nonatomic, readonly) BeeDatabaseArrayBlock	GET_RECORDS;

- (void)classType:(Class)clazz;

- (NSArray *)getRecords;
- (NSArray *)getRecords:(NSString *)table;
- (NSArray *)getRecords:(NSString *)table limit:(NSUInteger)limit;
- (NSArray *)getRecords:(NSString *)table limit:(NSUInteger)limit offset:(NSUInteger)offset;

@end


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
#import "Bee_Foundation.h"
#import "Bee_Database.h"
#import "Bee_ActiveProtocol.h"
#import "Bee_ActiveRecord.h"

#pragma mark -

@interface BeeDatabase(BeeActiveRecord)

@property (nonatomic, readonly) BeeDatabaseObjectBlockN		SAVE;
@property (nonatomic, readonly) BeeDatabaseObjectBlockN		SAVE_DATA;
@property (nonatomic, readonly) BeeDatabaseObjectBlockN		SAVE_STRING;
@property (nonatomic, readonly) BeeDatabaseObjectBlockN		SAVE_ARRAY;
@property (nonatomic, readonly) BeeDatabaseObjectBlockN		SAVE_DICTIONARY;

@property (nonatomic, readonly) BeeDatabaseArrayBlock		GET_RECORDS;
@property (nonatomic, readonly) BeeDatabaseObjectBlock		FIRST_RECORD;
@property (nonatomic, readonly) BeeDatabaseObjectBlockN		FIRST_RECORD_BY_ID;
@property (nonatomic, readonly) BeeDatabaseObjectBlock		LAST_RECORD;
@property (nonatomic, readonly) BeeDatabaseObjectBlockN		LAST_RECORD_BY_ID;

- (id)saveData:(NSData *)data;
- (id)saveString:(NSString *)string;
- (id)saveArray:(NSArray *)array;
- (id)saveDictionary:(NSDictionary *)dict;

- (id)firstRecord;
- (id)firstRecord:(NSString *)table;
- (id)firstRecordByID:(id)key;
- (id)firstRecord:(NSString *)table byID:(id)key;

- (id)lastRecord;
- (id)lastRecord:(NSString *)table;
- (id)lastRecordByID:(id)key;
- (id)lastRecord:(NSString *)table byID:(id)key;

- (NSArray *)getRecords;
- (NSArray *)getRecords:(NSString *)table;
- (NSArray *)getRecords:(NSString *)table limit:(NSUInteger)limit;
- (NSArray *)getRecords:(NSString *)table limit:(NSUInteger)limit offset:(NSUInteger)offset;

@end

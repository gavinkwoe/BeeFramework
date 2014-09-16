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

#pragma mark -

@protocol BeeActiveProtocol<NSObject>

@property (nonatomic, readonly) BeeDatabaseBoolBlock	EXISTS;		// COUNT WHERE '<your primary key>' = id
@property (nonatomic, readonly) BeeDatabaseBoolBlock	LOAD;		// GET
@property (nonatomic, readonly) BeeDatabaseBoolBlock	SAVE;		// INSERT if failed to UPDATE
@property (nonatomic, readonly) BeeDatabaseBoolBlock	INSERT;
@property (nonatomic, readonly) BeeDatabaseBoolBlock	UPDATE;
@property (nonatomic, readonly) BeeDatabaseBoolBlock	DELETE;

@property (nonatomic, readonly) NSString *				primaryKey;
@property (nonatomic, retain) NSNumber *				primaryID;

@property (nonatomic, readonly) BOOL					inserted;
@property (nonatomic, readonly) BOOL					deleted;
@property (nonatomic, assign) BOOL						changed;

@property (nonatomic, retain) NSMutableDictionary *		JSON;
@property (nonatomic, retain) NSData *					JSONData;
@property (nonatomic, retain) NSString *				JSONString;

- (id)initWithKey:(id)key;
- (id)initWithObject:(NSObject *)object;
- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithJSONData:(NSData *)data;
- (id)initWithJSONString:(NSString *)string;

- (void)setDictionary:(NSDictionary *)dict;

@end

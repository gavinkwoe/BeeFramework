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
#import "Bee_ActiveProtocol.h"

#pragma mark -

@interface BeeNonValue : NSObject
+ (BeeNonValue *)value;
@end

#pragma mark -

@interface BeeActiveObject : NSObject
- (BOOL)validate;
@end

#pragma mark -

@interface NSObject(BeeActiveObject)

+ (BOOL)isRelationMapped;
+ (void)mapRelation;						// for subclass
+ (void)mapRelationForClass:(Class)clazz;	// for subclass

+ (void)mapPropertyAsKey:(NSString *)name;
+ (void)mapPropertyAsKey:(NSString *)name defaultValue:(id)value;
+ (void)mapPropertyAsKey:(NSString *)name atPath:(NSString *)path;
+ (void)mapPropertyAsKey:(NSString *)name atPath:(NSString *)path defaultValue:(id)value;

+ (void)mapProperty:(NSString *)name;
+ (void)mapProperty:(NSString *)name defaultValue:(id)value;
+ (void)mapProperty:(NSString *)name atPath:(NSString *)path;
+ (void)mapProperty:(NSString *)name atPath:(NSString *)path defaultValue:(id)value;
+ (void)mapProperty:(NSString *)name forClass:(NSString *)className;
+ (void)mapProperty:(NSString *)name forClass:(NSString *)className defaultValue:(id)value;
+ (void)mapProperty:(NSString *)name forClass:(NSString *)className atPath:(NSString *)path;
+ (void)mapProperty:(NSString *)name forClass:(NSString *)className atPath:(NSString *)path defaultValue:(id)value;
+ (void)mapProperty:(NSString *)name associateTo:(NSString *)clazz;
+ (void)mapProperty:(NSString *)name associateTo:(NSString *)clazz defaultValue:(id)value;

+ (void)mapPropertyAsArray:(NSString *)name forClass:(NSString *)className;
+ (void)mapPropertyAsArray:(NSString *)name forClass:(NSString *)className defaultValue:(id)value;

+ (void)mapPropertyAsArray:(NSString *)name;
+ (void)mapPropertyAsArray:(NSString *)name defaultValue:(id)value;

+ (void)mapPropertyAsDictionary:(NSString *)name;
+ (void)mapPropertyAsDictionary:(NSString *)name defaultValue:(id)value;

#pragma mark -

+ (NSString *)mapTableName;					// for subclass

#pragma mark -

+ (void)useAutoIncrement;
+ (void)useAutoIncrementFor:(Class)clazz;
+ (BOOL)usingAutoIncrement;
+ (BOOL)usingAutoIncrementFor:(Class)clazz;

+ (void)useAutoIncrementFor:(Class)clazz andProperty:(NSString *)name;
+ (BOOL)usingAutoIncrementFor:(Class)clazz andProperty:(NSString *)name;

+ (void)useAutoIncrementForProperty:(NSString *)name;
+ (BOOL)usingAutoIncrementForProperty:(NSString *)name;

+ (void)useUniqueFor:(Class)clazz andProperty:(NSString *)name;
+ (BOOL)usingUniqueFor:(Class)clazz andProperty:(NSString *)name;

+ (void)useUniqueForProperty:(NSString *)name;
+ (BOOL)usingUniqueForProperty:(NSString *)name;

+ (void)useJSON;
+ (void)useJSONFor:(Class)clazz;
+ (BOOL)usingJSON;
+ (BOOL)usingJSONFor:(Class)clazz;

#pragma mark -

- (NSString *)activePrimaryKey;
- (NSString *)activeJSONKey;

+ (NSString *)activePrimaryKey;
+ (NSString *)activePrimaryKeyFor:(Class)clazz;

+ (NSString *)activeJSONKey;
+ (NSString *)activeJSONKeyFor:(Class)clazz;

- (NSMutableDictionary *)activePropertySet;
+ (NSMutableDictionary *)activePropertySet;
+ (NSMutableDictionary *)activePropertySetFor:(Class)clazz;

#pragma mark -

+ (NSString *)fieldNameForIdentifier:(NSString *)string;
+ (NSString *)identifierForFieldName:(NSString *)string;

@end

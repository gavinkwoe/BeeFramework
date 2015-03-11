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

#import "Bee.h"

#pragma mark -

@class SchemaObject;
@class SchemaProperty;
@class SchemaRequest;
@class SchemaResponse;
@class SchemaEnum;
@class SchemaController;
@class SchemaProtocol;
@class SchemaGenerator;

#pragma mark -

@interface SchemaObject : NSObject

@property (nonatomic, assign) NSInteger				order;
@property (nonatomic, assign) SchemaProtocol *		protocol;

+ (id)parseKey:(NSString *)key value:(id)value protocol:(SchemaProtocol *)protocol;

- (NSString *)JSON;
- (NSString *)MD;

- (NSString *)DOT;
- (NSString *)DOT2;

- (NSString *)h;
- (NSString *)mm;

- (NSString *)randColor;

@end

#pragma mark -

@interface SchemaProperty : SchemaObject

AS_INT( TYPE_UNKNOWN )
AS_INT( TYPE_ENUM )
AS_INT( TYPE_NUMBER )
AS_INT( TYPE_STRING )
AS_INT( TYPE_ARRAY )
AS_INT( TYPE_DICTIONARY )
AS_INT( TYPE_OBJECT )

@property (nonatomic, assign) BOOL					required;
@property (nonatomic, assign) NSUInteger			type;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSString *			value;

@property (nonatomic, assign) NSUInteger			elemType;
@property (nonatomic, retain) NSString *			elemClass;
@property (nonatomic, assign) NSUInteger			elemCount;
@property (nonatomic, retain) SchemaProperty *		elemProperty;

@property (nonatomic, retain) NSMutableArray *		subProperties;

@end

#pragma mark -

@interface SchemaPropertyUnknown : SchemaProperty
@end

#pragma mark -

@interface SchemaPropertyEnum : SchemaProperty
@end

#pragma mark -

@interface SchemaPropertyNumber : SchemaProperty
@end

#pragma mark -

@interface SchemaPropertyString : SchemaProperty
@end

#pragma mark -

@interface SchemaPropertyArray : SchemaProperty
@end

#pragma mark -

@interface SchemaPropertyDictionary : SchemaProperty
@end

#pragma mark -

@interface SchemaPropertyObject : SchemaProperty
@end

#pragma mark -

@interface SchemaPropertyEmbedObject : SchemaPropertyObject
@end

#pragma mark -

@interface SchemaModel : SchemaObject

@property (nonatomic, retain) NSString *			superClassName;
@property (nonatomic, retain) NSString *			className;
@property (nonatomic, retain) NSMutableArray *		properties;
@property (nonatomic, assign) BOOL					isActiveRecord;
@property (nonatomic, assign) BOOL					isArray;
@property (nonatomic, assign) BOOL					isDictionary;
@property (nonatomic, assign) BOOL					isContainer;

- (BOOL)appendKeyValues:(NSDictionary *)keyValues;

@end

#pragma mark -

@interface SchemaRequest : SchemaModel
@end

#pragma mark -

@interface SchemaResponse : SchemaModel
@end

#pragma mark -

@interface SchemaFileList : SchemaModel
@end

#pragma mark -

@interface SchemaController : SchemaObject

@property (nonatomic, retain) NSString *			desc;
@property (nonatomic, retain) NSString *			method;
@property (nonatomic, retain) NSString *			url;
@property (nonatomic, retain) NSString *			relativeUrl;
@property (nonatomic, retain) SchemaRequest *		request;
@property (nonatomic, retain) SchemaResponse *		response;
@property (nonatomic, retain) SchemaFileList *      fileList;
@property (nonatomic, retain) NSDictionary  *       fileParam;

@end

#pragma mark -

@interface SchemaEnum : SchemaObject

@property (nonatomic, assign) BOOL					isString;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSDictionary *		values;

@end

#pragma mark -

@interface SchemaProtocol : SchemaObject

@property (nonatomic, retain) NSString *			author;
@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) NSString *			source;
@property (nonatomic, retain) NSString *			prefix;
@property (nonatomic, retain) NSNumber *			shortName;

@property (nonatomic, retain) NSDictionary *		server;

@property (nonatomic, retain) NSMutableArray *		enums;
@property (nonatomic, retain) NSMutableArray *		models;
@property (nonatomic, retain) NSMutableArray *		controllers;

@property (nonatomic, retain) NSString *			fileName;

- (BOOL)parseString:(NSString *)str error:(NSError **)perror;

- (SchemaEnum *)enumByName:(NSString *)name;
- (SchemaModel *)modelByName:(NSString *)name;

@end

#pragma mark -

@interface SchemaGenerator : NSObject

@property (nonatomic, retain) NSString *			inputPath;
@property (nonatomic, retain) NSString *			inputFile;
@property (nonatomic, retain) NSString *			outputPath;
@property (nonatomic, assign) NSUInteger			errorLine;
@property (nonatomic, retain) NSString *			errorDesc;
@property (nonatomic, retain) NSMutableArray *		results;

- (BOOL)generate;

@end

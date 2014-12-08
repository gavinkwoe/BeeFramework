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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"

#import "Bee_UILayoutConfig.h"
#import "Bee_UILayoutBuilder.h"

#import "Bee_UICollection.h"
#import "Bee_UIMetrics.h"
#import "Bee_UICapability.h"

#pragma mark -

@class BeeUIMetrics;
@class BeeUILayout;
@class BeeUIStyle;
@class BeeUILayoutBuilder;

#pragma mark -

typedef BeeUILayout *	(^BeeUILayoutBlock)( void );
typedef BeeUILayout *	(^BeeUILayoutBlockN)( id first, ... );
typedef BeeUILayout *	(^BeeUILayoutBlockS)( NSString * tag );
typedef BeeUILayout *	(^BeeUILayoutBlockB)( BOOL flag );
typedef BeeUILayout *	(^BeeUILayoutBlockCS)( Class clazz, NSString * tag );

#pragma mark -

@interface NSObject(LayoutParser)

+ (void)parseLayout:(BeeUILayout *)layout forView:(id)view;
- (void)parseLayout:(BeeUILayout *)layout;

@end

#pragma mark -

@interface BeeUILayout : NSObject

@property (nonatomic, assign) NSUInteger				version;
@property (nonatomic, assign) BOOL						visible;
@property (nonatomic, assign) BOOL						constructable;
@property (nonatomic, assign) BOOL						containable;
@property (nonatomic, assign) BeeUILayout *				root;
@property (nonatomic, assign) BeeUILayout *				parent;
@property (nonatomic, retain) NSString *				name;
@property (nonatomic, retain) NSString *				value;
@property (nonatomic, retain) NSMutableString *			attributes;

@property (nonatomic, retain) BeeUIStyle *				styleRoot;
@property (nonatomic, retain) NSMutableArray *			styleClasses;
@property (nonatomic, retain) BeeUIStyle *				styleInline;
@property (nonatomic, retain) BeeUIStyle *				styleMerged;

@property (nonatomic, assign) Class						classType;
@property (nonatomic, retain) NSString *				elemName;
@property (nonatomic, retain) NSString *				className;
@property (nonatomic, retain) NSMutableArray *			childs;

@property (nonatomic, assign) BOOL						enabled;
@property (nonatomic, assign) BOOL						isRoot;
@property (nonatomic, assign) BOOL						isWrapper;
@property (nonatomic, readonly) NSString *				DOMPath;
@property (nonatomic, readonly) NSUInteger				DOMDepth;

@property (nonatomic, readonly) BeeUILayoutBlockN		ADD;
@property (nonatomic, readonly) BeeUILayoutBlockN		REMOVE;
@property (nonatomic, readonly) BeeUILayoutBlock		REMOVE_ALL;

@property (nonatomic, readonly) BeeUILayoutBlockS		CONTAINER_BEGIN;
@property (nonatomic, readonly) BeeUILayoutBlock		CONTAINER_END;
@property (nonatomic, readonly) BeeUILayoutBlockS		VIEW;
@property (nonatomic, readonly) BeeUILayoutBlock		DUMP;

+ (NSString *)generateName;

+ (BeeUILayout *)layout;
+ (BeeUILayout *)layout:(NSUInteger)version;

- (UIView *)createView;
- (UIView *)createTree;

- (void)buildFor:(UIView *)canvas;
- (void)layoutFor:(UIView *)canvas inBound:(CGRect)bound;
- (CGRect)estimateFor:(UIView *)canvas inBound:(CGRect)bound;

- (void)mergeRootStyle:(BeeUIStyle *)style;
- (void)mergeStyle;

- (void)dump;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

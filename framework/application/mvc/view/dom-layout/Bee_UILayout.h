//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#import "Bee_UICollection.h"
#import "Bee_UIMetrics.h"

#pragma mark -

@class BeeUIMetrics;
@class BeeUILayout;
@class BeeUIStyle;

#pragma mark -

#undef	SUPPORT_SIZE_ESTIMATING
#define SUPPORT_SIZE_ESTIMATING( __flag ) \
		+ (BOOL)supportForUISizeEstimating { return __flag; }

#pragma mark -

@interface NSObject(BeeUISizeEstimating)
+ (BOOL)supportForUISizeEstimating;
+ (CGSize)estimateUISizeByBound:(CGSize)bound forData:(id)data;
+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data;
+ (CGSize)estimateUISizeByHeight:(CGFloat)height forData:(id)data;
- (CGSize)estimateUISizeByBound:(CGSize)bound;
- (CGSize)estimateUISizeByWidth:(CGFloat)width;
- (CGSize)estimateUISizeByHeight:(CGFloat)height;
@end

#pragma mark -

typedef BeeUILayout *	(^BeeUILayoutBlock)( void );
typedef BeeUILayout *	(^BeeUILayoutBlockN)( id first, ... );
typedef BeeUILayout *	(^BeeUILayoutBlockS)( NSString * tag );
typedef BeeUILayout *	(^BeeUILayoutBlockB)( BOOL flag );
typedef BeeUILayout *	(^BeeUILayoutBlockCS)( Class clazz, NSString * tag );

#pragma mark -

@interface BeeUILayout : NSObject

@property (nonatomic, retain) NSString *				uniqueID;
@property (nonatomic, assign) BOOL						visible;
@property (nonatomic, assign) BOOL						containable;
@property (nonatomic, assign) BeeUILayout *				root;
@property (nonatomic, assign) BeeUILayout *				parent;
@property (nonatomic, retain) NSString *				name;
@property (nonatomic, readonly) NSString *				prettyName;
@property (nonatomic, retain) NSString *				value;
@property (nonatomic, retain) NSString *				styleID;
@property (nonatomic, retain) NSMutableArray *			styleClasses;
@property (nonatomic, retain) BeeUIStyle *				styleInline;
@property (nonatomic, retain) BeeUIStyle *				style;
@property (nonatomic, assign) Class						classType;
@property (nonatomic, retain) NSString *				className;
@property (nonatomic, retain) NSMutableArray *			childs;
@property (nonatomic, retain) NSMutableDictionary *		childFrames;
@property (nonatomic, assign) UIView *					canvas;
@property (nonatomic, readonly) UIView *				view;

@property (nonatomic, assign) BOOL						isRoot;
@property (nonatomic, retain) NSMutableDictionary *		rootStyles;

@property (nonatomic, readonly) BeeUILayoutBlockN		ADD;
@property (nonatomic, readonly) BeeUILayoutBlockN		REMOVE;
@property (nonatomic, readonly) BeeUILayoutBlock		REMOVE_ALL;

@property (nonatomic, readonly) BeeUILayoutBlock		EMPTY;
@property (nonatomic, readonly) BeeUILayoutBlock		REBUILD;
@property (nonatomic, readonly) BeeUILayoutBlock		RELAYOUT;

@property (nonatomic, readonly) BeeUILayoutBlock		BEGIN_LAYOUT;
@property (nonatomic, readonly) BeeUILayoutBlock		END_LAYOUT;
@property (nonatomic, readonly) BeeUILayoutBlockS		BEGIN_CONTAINER;
@property (nonatomic, readonly) BeeUILayoutBlock		END_CONTAINER;
@property (nonatomic, readonly) BeeUILayoutBlockCS		VIEW;
@property (nonatomic, readonly) BeeUILayoutBlock		DUMP;

+ (NSString *)generateName;

- (UIView *)buildView;
- (UIView *)buildViewAndSubviews;

- (void)buildSubviewsForCanvas;
- (void)buildSubviewsFor:(UIView *)canvas;

- (void)reorderSubviewsFor:(UIView *)canvas;

- (CGPoint)estimateOriginForCanvas;
- (CGPoint)estimateOriginBy:(CGRect)parentFrame;

- (CGSize)estimateSizeForCanvas;
- (CGSize)estimateSizeBy:(CGRect)parentFrame;

- (CGRect)estimateFrameForCanvas;
- (CGRect)estimateFrameBy:(CGRect)parentFrame;

- (CGRect)relayoutForCanvas;
- (CGRect)relayoutForBound:(CGRect)frame;

- (BeeUILayout *)topLayout;
- (void)pushLayout:(BeeUILayout *)layout;
- (void)popLayout;

- (BOOL)hasStyleClass:(NSString * )className;
- (void)addStyleClass:(NSString * )className;
- (void)removeStyleClass:(NSString * )className;
- (void)toggleStyleClass:(NSString * )className;

- (void)mergeStyle;
- (void)applyStyle;

- (void)dump;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

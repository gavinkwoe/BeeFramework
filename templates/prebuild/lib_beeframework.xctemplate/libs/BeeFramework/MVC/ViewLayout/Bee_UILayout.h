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
//  Bee_UILayout.h
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Singleton.h"
#import "Bee_UICollection.h"
#import "Bee_UIStyle.h"
#import "NSObject+BeeProperty.h"

#pragma mark -

@class BeeUIValue;
@class BeeUILayout;

typedef BeeUILayout *	(^BeeUILayoutBlock)( void );
typedef BeeUILayout *	(^BeeUILayoutBlockN)( id first, ... );
typedef BeeUILayout *	(^BeeUILayoutBlockS)( NSString * tag );
typedef BeeUILayout *	(^BeeUILayoutBlockB)( BOOL flag );
typedef BeeUILayout *	(^BeeUILayoutBlockCS)( Class clazz, NSString * tag );

#pragma mark -

@interface BeeUIValue : NSObject
{
	NSInteger	_type;
	CGFloat		_value;
}

AS_INT( PIXEL )
AS_INT( PERCENT )
AS_INT( FILL_PARENT )
AS_INT( WRAP_CONTENT )

@property (nonatomic, assign) NSInteger	type;
@property (nonatomic, assign) CGFloat	value;

+ (BeeUIValue *)pixel:(CGFloat)value;
+ (BeeUIValue *)percent:(CGFloat)value;
+ (BeeUIValue *)fillParent;
+ (BeeUIValue *)wrapContent;
+ (BeeUIValue *)fromString:(NSString *)str;

@end

#pragma mark -

@interface BeeUILayout : NSObject
{
	NSMutableArray *		_stack;
	BeeUILayout *			_root;
	BeeUILayout *			_parent;
	NSString *				_name;
	NSString *				_value;
	BeeUIStyle *			_style;
	NSString *				_styleID;
	UIView *				_canvas;
	Class					_classType;
	NSMutableDictionary *	_properties;
	NSMutableArray *		_childs;
	BOOL					_autoresizingWidth;
	BOOL					_autoresizingHeight;
	BOOL					_containable;
	BOOL					_visible;
	BOOL					_always;
}

AS_STRING( POSITION_ABSOLUTE )
AS_STRING( POSITION_RELATIVE )		// default

AS_STRING( ALIGN_CENTER )
AS_STRING( ALIGN_LEFT )
AS_STRING( ALIGN_TOP )
AS_STRING( ALIGN_BOTTOM )
AS_STRING( ALIGN_RIGHT )

AS_STRING( ORIENTATION_HORIZONAL )
AS_STRING( ORIENTATION_VERTICAL )	// default

@property (nonatomic, assign) BOOL						always;
@property (nonatomic, assign) BOOL						visible;
@property (nonatomic, assign) BOOL						containable;
@property (nonatomic, assign) BeeUILayout *				root;
@property (nonatomic, assign) BeeUILayout *				parent;
@property (nonatomic, retain) NSString *				name;
@property (nonatomic, retain) NSString *				value;
@property (nonatomic, retain) NSString *				styleID;
@property (nonatomic, retain) BeeUIStyle *				style;
@property (nonatomic, assign) Class						classType;
@property (nonatomic, retain) NSMutableDictionary *		properties;
@property (nonatomic, retain) NSMutableArray *			childs;
@property (nonatomic, assign) UIView *					canvas;

@property (nonatomic, assign) BOOL						autoresizingWidth;
@property (nonatomic, assign) BOOL						autoresizingHeight;

@property (nonatomic, readonly) BeeUILayoutBlockN		X;
@property (nonatomic, readonly) BeeUILayoutBlockN		Y;
@property (nonatomic, readonly) BeeUILayoutBlockN		W;
@property (nonatomic, readonly) BeeUILayoutBlockN		H;
@property (nonatomic, readonly) BeeUILayoutBlockN		POSITION;
@property (nonatomic, readonly) BeeUILayoutBlockN		ALIGN;
@property (nonatomic, readonly) BeeUILayoutBlockN		V_ALIGN;
@property (nonatomic, readonly) BeeUILayoutBlockN		ORIENTATION;
@property (nonatomic, readonly) BeeUILayoutBlockB		AUTORESIZE_WIDTH;
@property (nonatomic, readonly) BeeUILayoutBlockB		AUTORESIZE_HEIGHT;
@property (nonatomic, readonly) BeeUILayoutBlockB		VISIBLE;

@property (nonatomic, readonly) BeeUILayoutBlockB		ALWAYS;
@property (nonatomic, readonly) BeeUILayoutBlock		FULLFILL;

@property (nonatomic, readonly) BeeUIValue *			x;
@property (nonatomic, readonly) BeeUIValue *			y;
@property (nonatomic, readonly) BeeUIValue *			w;
@property (nonatomic, readonly) BeeUIValue *			h;
@property (nonatomic, readonly) NSString *				position;
@property (nonatomic, readonly) NSString *				align;
@property (nonatomic, readonly) NSString *				v_align;
@property (nonatomic, readonly) NSString *				orientation;

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
@property (nonatomic, readonly) BeeUILayoutBlock		SPACE;

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
- (CGRect)estimateFrameBy:(CGRect)parentFrame changeViewFrame:(BOOL)flag;

- (CGRect)relayoutForCanvas;
- (CGRect)relayoutForBound:(CGRect)frame;

- (BeeUILayout *)topLayout;
- (void)pushLayout:(BeeUILayout *)layout;
- (void)popLayout;

- (void)dump;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

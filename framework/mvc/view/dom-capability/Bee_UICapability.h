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
#import "Bee_UISignal.h"

#pragma mark -

#undef	IS_CONTAINABLE
#define IS_CONTAINABLE( __flag ) \
		+ (BOOL)isContainable { return __flag; } \
		- (BOOL)isContainable { return __flag; }

#undef	SUPPORT_AUTOMATIC_LAYOUT
#define SUPPORT_AUTOMATIC_LAYOUT( __flag ) \
		+ (BOOL)supportForUIAutomaticLayout { return __flag; } \
		- (BOOL)supportForUIAutomaticLayout { return __flag; }

#undef	SUPPORT_SIZE_ESTIMATING
#define SUPPORT_SIZE_ESTIMATING( __flag ) \
		+ (BOOL)supportForUISizeEstimating { return __flag; } \
		- (BOOL)supportForUISizeEstimating { return __flag; }

#undef	SUPPORT_STYLING
#define SUPPORT_STYLING( __flag ) \
		+ (BOOL)supportForUIStyling { return __flag; } \
		- (BOOL)supportForUIStyling { return __flag; }

#undef	SUPPORT_RESOURCE_LOADING
#define SUPPORT_RESOURCE_LOADING( __flag ) \
		+ (BOOL)supportForUIResourceLoading { return __flag; } \
		- (BOOL)supportForUIResourceLoading { return __flag; } \
		+ (NSString *)UIResourceName { return [self description]; } \
		- (NSString *)UIResourceName { return [[self class] UIResourceName]; } \
		+ (NSString *)UIResourcePath { return [[NSString stringWithUTF8String:__FILE__] stringByDeletingLastPathComponent]; } \
		- (NSString *)UIResourcePath { return [[self class] UIResourcePath]; }

#undef	SUPPORT_PROPERTY_MAPPING
#define SUPPORT_PROPERTY_MAPPING( __flag ) \
		+ (BOOL)supportForUIPropertyMapping { return __flag; } \
		- (BOOL)supportForUIPropertyMapping { return __flag; } \

#pragma mark -

#undef	AS_OUTLET
#define	AS_OUTLET( __class, __tag ) \
		@property (nonatomic, assign) __class *	__tag;

#undef	DEF_OUTLET
#define	DEF_OUTLET( __class, __tag ) \
		@synthesize __tag = _##__tag;

#pragma mark -

@interface NSObject(BeeUICapability)

// containable?

+ (BOOL)isContainable;
- (BOOL)isContainable;

// automatic layout?

+ (BOOL)supportForUIAutomaticLayout;
- (BOOL)supportForUIAutomaticLayout;

// size estimating?

+ (BOOL)supportForUISizeEstimating;
- (BOOL)supportForUISizeEstimating;

+ (CGSize)estimateUISizeByBound:(CGSize)bound forData:(id)data;
+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data;
+ (CGSize)estimateUISizeByHeight:(CGFloat)height forData:(id)data;
- (CGSize)estimateUISizeByBound:(CGSize)bound;
- (CGSize)estimateUISizeByWidth:(CGFloat)width;
- (CGSize)estimateUISizeByHeight:(CGFloat)height;

// styling?

+ (BOOL)supportForUIStyling;
- (BOOL)supportForUIStyling;

- (void)applyUIStyling:(NSDictionary *)properties;

// resource loading?

+ (BOOL)supportForUIResourceLoading;
- (BOOL)supportForUIResourceLoading;

+ (NSString *)UIResourceName;
- (NSString *)UIResourceName;
+ (NSString *)UIResourcePath;
- (NSString *)UIResourcePath;

// property mapping?

+ (BOOL)supportForUIPropertyMapping;
- (BOOL)supportForUIPropertyMapping;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

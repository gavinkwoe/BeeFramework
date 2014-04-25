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
#import "Bee_Singleton.h"
#import "Bee_SystemInfo.h"

typedef enum Restrictor {
    RestrictorOnly,
    RestrictorNot,
    RestrictorNone
} Restrictor;

#pragma mark -

@class CSSProperty;

@class CSSSelector;

@class CSSMediaList;
@class CSSMediaQuery;
@class CSSMediaQueryExp;

@class CSSRule;
@class CSSRuleData;
@class CSSRuleList;
@class CSSMediaRule;
@class CSSStyleRule;
@class CSSImportRule;
@class CSSFontFaceRule;

@class CSSStyleSheet;
@class CSSStyleDeclaration;

#pragma mark - CSSProperty

@interface CSSProperty : NSObject

@property (nonatomic, assign) NSUInteger            id;
@property (nonatomic, retain) NSString *            name;
@property (nonatomic, retain) NSString *            value;
@property (nonatomic, assign) BOOL                  important;

@end

#pragma mark - CSSStyleDeclaration

@interface CSSStyleDeclaration : NSObject
@property (nonatomic, retain) NSArray *             properties;
@end

#pragma mark - CSSMedia

@interface CSSMediaList : NSObject
@property (nonatomic, retain) NSMutableArray *      queries;
- (BOOL)isCompatibled;
- (void)appendMediaQuery:(CSSMediaQuery *)query;
@end

@interface CSSMediaQuery : NSObject
@property (nonatomic, retain) NSString *            mediaType;
@property (nonatomic, retain) NSString *            restrictor;
@property (nonatomic, retain) NSArray *             expressions;
- (BOOL)isCompatibled;
+ (BOOL)isCompatibled:(NSString *)mediaType;
@end

@interface CSSMediaQueryExp : NSObject
@property (nonatomic, retain) NSString *            values;
@property (nonatomic, retain) NSString *            feature;
@end

@interface CSSMediaQueryExp(expression)
- (NSString *)device;
@end

#pragma mark - CSSRule

@interface CSSRule : NSObject
@end

@interface CSSRuleList : NSObject
@property (nonatomic, retain) NSMutableArray *      rules;
- (void)appendRule:(CSSRule *)rule;
@end

@interface CSSStyleRule : CSSRule
@property (nonatomic, retain) NSArray *             selectorList;
@property (nonatomic, retain) CSSStyleDeclaration * style;
@end

@interface CSSMediaRule : CSSRule
@property (nonatomic, retain) CSSMediaList *        media;
@property (nonatomic, retain) CSSRuleList *         ruleList;
@property (nonatomic, assign) CSSStyleSheet *       styleSheet;
@end

@interface CSSImportRule : CSSRule
@property (nonatomic, retain) NSString *            url;
@property (nonatomic, retain) CSSMediaList *        media;
@property (nonatomic, assign) CSSStyleSheet *       styleSheet;
@end

@interface CSSFontFaceRule : CSSRule
@property (nonatomic, retain) CSSStyleDeclaration * style;
@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

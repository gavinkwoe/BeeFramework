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

typedef enum CSSSelectorMatch {
    MatchNone = 0,
    MatchId,
    MatchClass,
    MatchExact,
    MatchSet,
    MatchList,
    MatchHyphen,
    MatchPseudoClass,
    MatchPseudoElement,
    MatchContain, // css3: E[foo*="bar"]
    MatchBegin, // css3: E[foo^="bar"]
    MatchEnd, // css3: E[foo$="bar"]
    MatchPagePseudoClass
} CSSSelectorMatch;

typedef enum CSSSelectorRelation {
    Descendant = 0, //
    Child,
    DirectAdjacent,
    IndirectAdjacent,
    SubSelector,
    ShadowDescendant
} CSSSelectorRelation;

enum PseudoType {
    PseudoUnknown = 0,
    PseudoEmpty,
    PseudoOther,
    PseudoFirstChild,
    PseudoFirstOfType,
    PseudoLastChild,
    PseudoLastOfType,
    PseudoOnlyChild,
    PseudoOnlyOfType,
    PseudoFirstLine,
    PseudoFirstLetter,
    PseudoNthChild,
    PseudoNthOfType,
    PseudoNthLastChild,
    PseudoNthLastOfType,
    PseudoLink,
    PseudoVisited,
    PseudoAny,
    PseudoAnyLink,
    PseudoAutofill,
    PseudoHover,
    PseudoDrag,
    PseudoFocus,
    PseudoActive,
    PseudoChecked,
    PseudoEnabled,
    PseudoFullPageMedia,
    PseudoDefault,
    PseudoDisabled,
    PseudoInputPlaceholder,
    PseudoOptional,
    PseudoRequired,
    PseudoReadOnly,
    PseudoReadWrite,
    PseudoValid,
    PseudoInvalid,
    PseudoIndeterminate,
    PseudoTarget,
    PseudoBefore,
    PseudoAfter,
    PseudoLang,
    PseudoNot,
    PseudoCustom,
} PseudoType;

@interface RareData : NSObject
@property (nonatomic, retain) NSString * value;
@property (nonatomic, assign) int a;
@property (nonatomic, assign) int b;
@property (nonatomic, retain) NSString * attribute;
@property (nonatomic, retain) NSString * argument;
@property (nonatomic, retain) NSArray * selectorList;
@end

@interface CSSSelector : NSObject

@property (nonatomic, assign) NSUInteger pseudoType;
@property (nonatomic, assign) NSUInteger match;
@property (nonatomic, assign) NSUInteger relation;
@property (nonatomic, assign) NSUInteger specificity;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) RareData * data;
@property (nonatomic, retain) CSSSelector * tagHistory;

- (BOOL)parseNth;
- (BOOL)matchNth:(NSInteger)count;

- (BOOL)hasTag;
- (BOOL)isSimple;
- (BOOL)hasAttribute;
- (bool)isUnknownPseudoElement;

- (CSSSelector *)lastTagHistory;

- (void)setArgument:(NSString *)argument;
- (void)setAttribute:(NSString *)attribute;
- (void)setSelectorList:(NSArray *)list;

- (void)adoptSelectorList:(NSArray *)selectors;
- (void)appendTagHistory:(CSSSelector *)selector relation:(int)relation;
- (void)insertTagHistory:(CSSSelector *)selector relationBefore:(int)before relationAfter:(int)after;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

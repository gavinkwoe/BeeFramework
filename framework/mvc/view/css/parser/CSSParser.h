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

#import "CSSOM.h"
#import "CSSSelector.h"
#import "CSSTokenizer.h"
#import "CSSStyleSheet.h"

#pragma mark -

@interface CSSParser : NSObject

AS_SINGLETON( CSSParser );

@property (nonatomic, assign) CSSStyleSheet *  styleSheet;
@property (nonatomic, retain) NSMutableArray * reusableSelectorVector;

#pragma mark - fontface

- (CSSFontFaceRule *)createFontFaceRule;

#pragma mark - import

- (CSSImportRule *)createImportRuleWithURL:(NSString *)url media:(CSSMediaList *)media;

#pragma mark - media

- (CSSMediaRule *)createMediaRuleWithMediaList:(CSSMediaList *)media ruleList:(CSSRuleList *)ruleList;

- (NSMutableArray *)createFloatingMediaQueryExpList;
- (NSArray *)sinkFloatingMediaQueryExpList:(NSArray *)explist;

- (CSSMediaQueryExp *)createFloatingMediaQueryExp;
- (CSSMediaQueryExp *)sinkFloatingMediaQueryExp:(CSSMediaQueryExp *)exp;

- (CSSMediaQuery *)createFloatingMediaQuery;
- (CSSMediaQuery *)sinkFloatingMediaQuery:(CSSMediaQuery *)query;

- (CSSMediaList *)createMediaList;

#pragma mark - rule

- (void)markRuleBodyStart;
- (void)markRuleBodyEnd;
- (void)addRule:(CSSRule *)rule;
- (CSSRuleList *)createRuleList;
- (CSSStyleRule *)createStyleRule:(NSArray *)selectorList;

#pragma mark - selector

- (void)markSelectorListStart;
- (void)markSelectorListEnd;

- (NSMutableArray *)createFloatingSelectorVector;
- (NSMutableArray *)sinkFloatingSelectorVector:(NSMutableArray *)selectorVector;

- (CSSSelector *)createFloatingSelector;
- (CSSSelector *)sinkFloatingSelector:(CSSSelector *)selector;

- (CSSSelector *)updateSpecifier:(CSSSelector *)specifier withNewSpecifier:(CSSSelector *)newSpecifier;

- (void)updateSpecifier:(CSSSelector *)selector elementName:(NSString *)name;


#pragma mark - property and value

- (void)markPropertyStart;
- (void)markPropertyEnd;

- (void)addPropertyWithName:(NSString *)name value:(id)value important:(BOOL)important;

- (void)rollbackLastProperties:(int)num;

#pragma mark - lex callback

- (int)csslex:(void *)yylvalp;

#pragma mark - parse

- (void)parseFile:(NSString *)filePath style:(CSSStyleSheet *)styleSheel;
- (void)parseString:(NSString *)string style:(CSSStyleSheet *)styleSheel;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

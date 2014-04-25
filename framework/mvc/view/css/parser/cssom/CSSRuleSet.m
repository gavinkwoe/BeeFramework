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

#import "CSSOM.h"
#import "CSSSelector.h"
#import "CSSRuleSet.h"
#import "CSSStyleSheet.h"

static int kRuleCount = 0;

@implementation CSSRuleData

- (NSUInteger)specificity
{
    return self.selector.specificity;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", self.selector, self.rule];
}

@end

@interface CSSRuleSet()
- (void)addRule:(CSSStyleRule *)rule selector:(CSSSelector *)selector;
- (void)addToRuleSet:(NSMutableDictionary *)map key:(NSString *)key rule:(CSSStyleRule *)rule selector:(CSSSelector *)selector;
@end

@implementation CSSRuleSet

- (id)init
{
    self = [super init];

    if ( self )
    {
        self.idRules        = [NSMutableDictionary dictionary];
        self.tagRules       = [NSMutableDictionary dictionary];
        self.classRules     = [NSMutableDictionary dictionary];
        self.pseudoRules    = [NSMutableDictionary dictionary];
        self.universalRules = [NSMutableArray array];
    }
    
    return self;
}

- (void)dealloc
{
    [self clear];
    
    self.idRules        = nil;
    self.tagRules       = nil;
    self.classRules     = nil;
    self.pseudoRules    = nil;
    self.universalRules = nil;

    [super dealloc];
}

- (void)clear
{
    [self.idRules removeAllObjects];
    [self.tagRules removeAllObjects];
    [self.classRules removeAllObjects];
    [self.pseudoRules removeAllObjects];
    [self.universalRules removeAllObjects];
}

- (NSMutableArray *)getUniversalRules
{
    return self.universalRules;
}

- (NSMutableArray *)getIDRules:(NSString *)key
{
    return self.idRules[key];
}

- (NSMutableArray *)getTagRules:(NSString *)key
{
    return self.tagRules[key];
}

- (NSMutableArray *)getClassRules:(NSString *)key
{
    return self.classRules[key];
}

- (NSMutableArray *)getPseudoRules:(NSString *)key
{
    return self.pseudoRules[key];
}

- (void)addRulesFromSheet:(CSSStyleSheet *)sheet
{
    if ( !sheet )
        return;
    // TODO:有样式，但样式里不包括当前的media类型，return;
    
    for ( int i=0; i<sheet.rules.count; i++)
    {
        CSSRule * rule = sheet.rules[i];

        if ( [rule isKindOfClass:[CSSStyleRule class]] )
        {
            [self addStyleRule:(CSSStyleRule *)rule];
        }
        else if ( [rule isKindOfClass:[CSSMediaRule class]] )
        {
            CSSMediaRule * mediaRule = (CSSMediaRule *)rule;
            
            if ( mediaRule.media.isCompatibled )
            {
                for ( CSSStyleRule * rule in mediaRule.ruleList.rules )
                {
                    [self addStyleRule:rule];
                }
            }
        }
        else if ( [rule isKindOfClass:[CSSImportRule class]] )
        {
            CSSImportRule * importRule = (CSSImportRule *)rule;
            CSSStyleSheet * importStyle = [[[CSSStyleSheet alloc] init] autorelease];
            [importStyle parseFile:importRule.url];
            [self addRulesFromSheet:importStyle];
        }
        else if ( [rule isKindOfClass:[CSSFontFaceRule class]] )
        {
            // TODO: @fontface
        }
    }
}

- (void)addStyleRule:(CSSStyleRule *)rule
{
    for ( CSSSelector * sel in rule.selectorList )
    {
        [self addRule:rule selector:sel];
    }
}

- (void)addRule:(CSSStyleRule *)rule selector:(CSSSelector *)sel
{
    if ( sel.match == MatchId )
    {
        [self addToRuleSet:self.idRules key:sel.value rule:rule selector:sel];
        return;
    }
    
    if ( sel.match == MatchClass )
    {
        [self addToRuleSet:self.classRules key:sel.value rule:rule selector:sel];
        return;
    }
    
    if ( [sel isUnknownPseudoElement] )
    {
        [self addToRuleSet:self.pseudoRules key:sel.value rule:rule selector:sel];
        return;
    }
    
    if ( ![sel.tag isEqualToString:@"*"] )
    {
        [self addToRuleSet:self.tagRules key:sel.tag rule:rule selector:sel];
        return;
    }
    
    CSSRuleData * data = [[[CSSRuleData alloc] init] autorelease];
    data.rule = rule;
    data.selector = sel;
    data.position = kRuleCount++;
    [self.universalRules addObject:data];
}

- (void)addToRuleSet:(NSMutableDictionary *)map key:(NSString *)key rule:(CSSStyleRule *)rule selector:(CSSSelector *)selector
{
    if (!key || !map || !rule)
        return;

    NSMutableArray * rules = [map objectForKey:key];
    
    if (!rules)
    {
        rules = [NSMutableArray array];
        [map setValue:rules forKey:key];
    }
    
    CSSRuleData * data = [[[CSSRuleData alloc] init] autorelease];
    data.rule = rule;
    data.selector = selector;
    data.position = kRuleCount++;
    [rules addObject:data];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)


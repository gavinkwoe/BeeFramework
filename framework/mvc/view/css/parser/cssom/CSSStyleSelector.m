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
#import "CSSStyleSheet.h"
#import "CSSStyleSelector.h"

@interface SelectorChecker : NSObject

- (SelectorMatch)checkSelector:(CSSSelector*)selector
                       element:(id<CSSElementProtocol>)elment
                         attrs:(NSSet *)attrs;
@end

@implementation SelectorChecker

- (BOOL)selectorTagMatches:(id<CSSElementProtocol>)element selector:(CSSSelector *)selector
{
    if ( ![selector hasTag] )
        return true;
    
    NSString * localName = selector.tag;
    
    if ( [localName isEqualToString:[element localName]] )
        return true;
    if ( [localName isEqualToString:@"*"] )
        return true;
    
    return false;
}

- (BOOL)checkOneSelector:(CSSSelector *)selector element:(id<CSSElementProtocol>)element attrs:(NSSet *)attrs
{
    if ( nil == element )
        return false;
    
    if ( ![self selectorTagMatches:element selector:selector] )
        return false;
    
    if ( [selector hasAttribute] )
    {
        if ( selector.match == MatchClass )
            return element.classes && [element.classes containsObject:selector.value];
        
        if ( selector.match == MatchId )
            return [element hash] && [[element hash] isEqualToString:selector.value];
        
        // TODO: attribute check
    }
    
    // TODO: PseudoClass check
    if ( selector.match == MatchPseudoClass || selector.match == MatchNone )
    {
        // any ":pseudo" is true.
        // TODO: should check if element has PseudoClass
        BOOL matched = false;
        
        switch ( selector.pseudoType )
        {
            case PseudoFirstChild:
                matched = [element isFirstChild];
                break;
            case PseudoLastChild:
                matched = [element isLastChild];
                break;
            case PseudoNthChild:
                matched = [element isNthChild:[selector.data.argument integerValue]];
                break;
//            case PseudoNthOfType:
            case PseudoCustom:
            case PseudoUnknown:
                matched = true;
                break;
            default:
                matched = false;
                break;
        }
        
        return matched;
    }
    
    // TODO: PseudoElement check
    
    return false;
}

// Recursive check of selectors and combinators
// It can return 3 different values:
// * SelectorMatches         - the selector matches the element e
// * SelectorFailsLocally    - the selector fails for the element e
// * SelectorFailsCompletely - the selector fails for e and any sibling or ancestor of e
- (SelectorMatch)checkSelector:(CSSSelector*)selector element:(id<CSSElementProtocol>)element attrs:(NSSet *)attrs
{
    if ( !element || !element.isElementNode )
        return SelectorFailsCompletely;
    
    // first selector has to match
    BOOL checked = [self checkOneSelector:selector element:element attrs:attrs];
    if ( !checked )
        return SelectorFailsLocally;
    
    // The rest of the selectors has to match
    NSUInteger relation = selector.relation;
    
    // Prepare next sel
    selector = [selector tagHistory];
    if ( !selector )
        return SelectorMatches;

    // get the elment shadow pointer
    id<CSSElementProtocol> shadow = element;
    
    switch (relation) {
        case Descendant: // selector1 selector2, 1 is 2's ancestor
            while (true)
            {
                SelectorMatch match = [self checkSelector:selector element:shadow attrs:attrs];
                if ( match != SelectorFailsLocally )
                    return match;
                shadow = [shadow parent];
            }
            break;
        case Child: // selector1 > selector2, 1 is 2's parent
        {
            shadow = [shadow parent];
            return [self checkSelector:selector element:shadow attrs:attrs];
        }
        case DirectAdjacent: // selector1 + selector2, 1 is 2's closest brother
        {
            shadow = [shadow siblingAtIndex:-1];
            return [self checkSelector:selector element:shadow attrs:attrs];
        }
        case IndirectAdjacent: // selector1 ~ selector2, 1 is 2's older brother
        {
            NSArray * siblings = [shadow previousSiblings];
            
            for ( id<CSSElementProtocol> brother in siblings )
            {
                if ( SelectorMatches == [self checkSelector:selector element:brother attrs:attrs] )
                    return SelectorMatches;
            }
            return SelectorFailsCompletely;
        }
        case SubSelector:       // selector:pseudo
        case ShadowDescendant:  // selector::pseudo
        {
            // TODO: check more ~ check more ~
            return [self checkSelector:selector element:shadow attrs:attrs];
        }
    }
    
    return SelectorFailsCompletely;
}

@end

@interface CSSStyleSelector()
@property (nonatomic, retain) SelectorChecker *         checker;
@property (nonatomic, assign) id<CSSElementProtocol>    element;
@end

@implementation CSSStyleSelector

DEF_SINGLETON( CSSStyleSelector );

- (id)init
{
    self = [super init];
    if (self) {
        self.matchedRules = [NSMutableArray array];
        self.checker = [[[SelectorChecker alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    self.matchedRules = nil;
    self.checker = nil;
    
    [super dealloc];
}

- (NSDictionary *)styleForElement:(id<CSSElementProtocol>)element inStyleSheet:(CSSStyleSheet *)sheet
{
    if ( nil == element )
        return nil;
    
    return [self styleForElement:element inRuleSet:sheet.ruleSet];
}

- (NSDictionary *)styleForElement:(id<CSSElementProtocol>)element inRuleSet:(CSSRuleSet *)ruleSet
{
    self.element = element;
    [self matchRules:ruleSet];
    
    return [self buildProperties];
}

- (NSDictionary *)buildProperties
{
    if ( 0 == self.matchedRules.count )
        return nil;
    
    NSMutableDictionary * properties = [NSMutableDictionary dictionary];
    
    for ( CSSRuleData * data in self.matchedRules )
    {
        NSArray * array = data.rule.style.properties;
        
        CSSSelector * selector = data.selector.lastTagHistory;
        
        NSUInteger pseudoType = selector.pseudoType;
//        NSUInteger match = selector.match;
        switch ( pseudoType )
        {
            case PseudoCustom: // selector:pseudo => selector-pseudo
            {
                NSString * pseudo = selector.value;
                
                for ( CSSProperty * p in array )
                {
                    // make a pseudo key
                    NSString * key = [NSString stringWithFormat:@"%@-%@", p.name, pseudo];
                    [properties setObject:p.value forKey:key];
                }
                
                break;
            }
            case PseudoUnknown: // class group: .class.class.class...
            default:
            {
                for ( CSSProperty * p in array )
                {
                    [properties setObject:p.value forKey:p.name];
                }
                break;
            }
        }
    }
    
    NSDictionary * result = [NSDictionary dictionaryWithDictionary:properties];

    [self clearMatchedRules];
    
    return result;
}

- (void)addMatchedRule:(CSSRuleData *)rule
{
    [self.matchedRules addObject:rule];
}

- (void)sortMatchedRules
{
    [self.matchedRules sortUsingComparator:^NSComparisonResult(CSSRuleData * obj1, CSSRuleData * obj2) {
        unsigned specificity1 = obj1.specificity;
        unsigned specificity2 = obj2.specificity;
        return (specificity1 == specificity2) ? obj1.position > obj2.position : specificity1 > specificity2;
    }];
}

- (void)clearMatchedRules
{
    [self.matchedRules removeAllObjects];
}

- (void)matchRules:(CSSRuleSet *)ruleSet
{
    // #id
    if ( [self.element hash] )
    {
        [self matchRulesForList:[ruleSet getIDRules:[self.element hash]]];
    }
    // .class
    for ( NSString * className in self.element.classes )
    {
        [self matchRulesForList:[ruleSet getClassRules:className]];
    }
    // :pseudo
    for ( NSString * pseudo in self.element.pseudos )
    {
        [self matchRulesForList:[ruleSet getPseudoRules:pseudo]];
    }
    // element
    if ( [self.element localName] )
    {
        [self matchRulesForList:[ruleSet getTagRules:[self.element localName]]];
    }
    // * or ...
    [self matchRulesForList:[ruleSet getUniversalRules]];
    
    if ( nil == _matchedRules )
        return;
    
    // Sort the set of matched rules.
    if ( _matchedRules.count > 1 )
        [self sortMatchedRules];
}

- (void)matchRulesForList:(NSArray *)rules
{
    if ( !rules || !rules.count )
        return;

    for ( CSSRuleData * rule in rules )
    {
        if ( [self checkRuleData:rule] )
        {
            [self addMatchedRule:rule];
        }
    }
}

- (BOOL)checkRuleData:(CSSRuleData *)ruleData
{
    SelectorMatch match = [self.checker checkSelector:ruleData.selector element:self.element attrs:nil];
    
    if (match != SelectorMatches)
        return false;
    
    return true;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

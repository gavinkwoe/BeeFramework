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

#import "CSSSelector.h"

const static int kBaseIDLevel           = 100;
const static int kBaseTagLevel          = 1;
const static int kBaseAttrLevel         = 0;
const static int kBaseClassLevel        = 10;
const static int kBasePseudoLevel       = 0;

@interface RareData()
- (BOOL)parseNth;
- (BOOL)matchNth:(NSInteger)count;
@end

@implementation RareData

- (BOOL)parseNth
{
    return NO;
}

- (BOOL)matchNth:(NSInteger)count
{
    return NO;
}

- (void)dealloc
{
    self.value = nil;
    self.argument = nil;
    self.attribute = nil;
    self.selectorList = nil;
    
    [super dealloc];
}

@end

@interface CSSSelector()
@property (nonatomic, assign) BOOL matchNth;
@property (nonatomic, assign) BOOL isParsedNth;
@end

@implementation CSSSelector

- (void)dealloc
{
    self.tag = nil;
    self.data = nil;
    self.value = nil;
    self.tagHistory = nil;
    
    [super dealloc];
}

- (void)adoptSelectorList:(NSArray *)selectors
{
    [self setSelectorList:[NSArray arrayWithArray:selectors]];
}

- (void)insertTagHistory:(CSSSelector *)selector relationBefore:(int)before relationAfter:(int)after
{
    if ( self.tagHistory )
        [selector setTagHistory:self.tagHistory];
    [self setRelation:before];
    [selector setRelation:after];
    self.tagHistory = selector;
}

- (void)appendTagHistory:(CSSSelector *)selector relation:(int)relation
{
    CSSSelector * end = self;
    while ([end tagHistory])
        end = end.tagHistory;
    [end setRelation:relation];
    [end setTagHistory:selector];
}

- (NSString *)description
{
    return [self selectorText];
}

- (BOOL)hasTag
{
    return _tag != nil;
}

- (BOOL)hasAttribute
{
    return _match == MatchId || _match == MatchClass || (_data && _data.attribute != nil);
}

- (bool)isUnknownPseudoElement
{
    return self.match == MatchPseudoElement && self.pseudoType == PseudoUnknown;
}

- (BOOL)isSimple
{
    if ( self.match == MatchPseudoElement || self.tagHistory || self.data.selectorList )
        return NO;
    
    int numConditions = 0;

    if ([self.tag isEqualToString:@"*"])
        numConditions++;
    
    if (self.match == MatchId || self.match == MatchClass || self.match == MatchPseudoClass)
        numConditions++;
    
    if (self.data && self.data.attribute != nil)
        numConditions++;
    
    // numConditions is 0 for a universal selector.
    // numConditions is 1 for other simple selectors.
    return numConditions <= 1;
}

- (BOOL)parseNth
{
    if ( nil == self.data )
        return NO;
    if ( self.isParsedNth )
        return YES;
    
    return [self.data parseNth];
}

- (BOOL)matchNth:(NSInteger)count
{
    if ( nil == self.data )
        return NO;
    
    return [self.data matchNth:count];
}

- (CSSSelector *)lastTagHistory
{
    CSSSelector * end = self;
    
    while ( end.tagHistory )
        end = end.tagHistory;
    
    return end;
}

- (void)setSelectorList:(NSArray *)list
{
    if ( nil == self.data )
    {
        self.data = [[[RareData alloc] init] autorelease];
    }
    
    self.data.selectorList = list;
}

- (void)setArgument:(NSString *)argument
{
    if ( nil == self.data )
    {
        self.data = [[[RareData alloc] init] autorelease];
    }
    self.data.argument = argument;
}

- (void)setAttribute:(NSString *)attribute
{
    if ( nil == self.data )
    {
        self.data = [[[RareData alloc] init] autorelease];
    }
    self.data.attribute = attribute;
}

- (NSUInteger)pseudoType
{
    if ( _pseudoType == PseudoUnknown )
        [self extractPseudoType];
    
    return _pseudoType;
}

- (unsigned)parsePseudoType:(NSString *)value
{
    if ( nil == value )
        return PseudoUnknown;
    
    static NSMutableDictionary * __pseudoMap = nil;
    
    if ( nil == __pseudoMap )
    {
        __pseudoMap = [[NSMutableDictionary alloc] init];
        // custom
        __pseudoMap[@"selected"] = @(PseudoCustom);
        __pseudoMap[@"normal"] = @(PseudoCustom);
        __pseudoMap[@"highlighted"] = @(PseudoCustom);
        __pseudoMap[@"disabled"] = @(PseudoCustom);
        // css3 standard
//        __pseudoMap[@"not("] = @(PseudoNot);
//        __pseudoMap[@"any("] = @(PseudoAny);
//        __pseudoMap[@"lang("] = @(PseudoLang);
        __pseudoMap[@"first-child"] = @(PseudoFirstChild);
        __pseudoMap[@"last-child"] = @(PseudoLastChild);
        __pseudoMap[@"nth-child("] = @(PseudoNthChild);
//        __pseudoMap[@"nth-of-type("] = @(PseudoNthOfType);
//        __pseudoMap[@"nth-last-child("] = @(PseudoNthLastChild);
//        __pseudoMap[@"nth-last-of-type("] = @(PseudoNthLastOfType);
        
    }
    
    NSNumber * type = __pseudoMap[value];
    
    return nil == type ? PseudoOther : type.unsignedIntValue;
}

- (void)extractPseudoType
{
    if (_match != MatchPseudoClass && _match != MatchPseudoElement && _match != MatchPagePseudoClass)
        return;
    _pseudoType = [self parsePseudoType:self.value];
}

- (NSString *)value
{
    return nil == _value ? _data.value : _value;
}

- (NSUInteger)specificity
{
    if ( _specificity == 0 )
       _specificity = [self calcSpecificity];
    return _specificity;
}

- (NSUInteger)calcSpecificity
{
    NSInteger specificity = 0;
    
    if ( _tag )
    {
        if ( _match == MatchNone || ![_tag isEqualToString:@"*"])
        {
            specificity += kBaseTagLevel;
        }
    }
    
    CSSSelector * cs = self;
    
    while (true)
    {
        if (cs.match == MatchId)
        {
            specificity += kBaseIDLevel;
        }
        else if (cs.match == MatchClass)
        {
            specificity += kBaseClassLevel;
        }
        else if (cs.match == MatchPseudoClass || cs.match == MatchPagePseudoClass)
        {
            specificity += kBasePseudoLevel;
        }
        else if (cs.match == MatchPseudoElement)
        {
            specificity += kBasePseudoLevel;
        }
        else if (cs.data.attribute)
        {
            specificity += kBaseAttrLevel;
        }
        
        if (cs.relation != SubSelector || !cs.tagHistory)
            break;
        
        cs = cs.tagHistory;
    }
    
    CSSSelector * tagHistory = cs.tagHistory;
    
    if (tagHistory)
    {
        specificity += tagHistory.specificity;
    }
    
    return specificity;
}

- (NSString *)selectorText
{
    NSMutableString * str = [NSMutableString string];
    
    NSString * localName = _tag;
    
    if ( localName )
    {
        if ( _match == MatchNone || ![localName isEqualToString:@"*"])
        {
            [str appendString:localName];
        }
    }
    
    CSSSelector * cs = self;
    
    while (true)
    {
        if (cs.match == MatchId) {
            [str appendString:@"#"];
            [str appendString:cs.value];
        } else if (cs.match == MatchClass)
        {
            [str appendString:@"."];
            [str appendString:cs.value];
        }
        else if (cs.match == MatchPseudoClass || cs.match == MatchPagePseudoClass)
        {
            [str appendString:@":"];
            [str appendString:cs.value];
            
            switch (cs.pseudoType)
            {
                case PseudoNot:
                    [str appendString:[cs.data.selectorList[0] description]];
                    [str appendString:@")"];
                    break;
                case PseudoLang:
                case PseudoNthChild:
                case PseudoNthLastChild:
                case PseudoNthOfType:
                case PseudoNthLastOfType:
                    [str appendString:cs.data.argument];
                    [str appendString:@")"];
                    break;
                case PseudoAny:
                {
                    int i = 0;
                    for ( CSSSelector * subSelector in cs.data.selectorList )
                    {
                        if (i != 0)
                            [str appendString:@","];
                        [str appendString:[subSelector selectorText]];
                        i++;
                    }
                    [str appendString:@")"];
                    break;
                }
                default:
                    break;
            }
        } else if (cs.match == MatchPseudoElement)
        {
            [str appendString:@"::"];
            [str appendString:cs.value];
        }
        else if (cs.data.attribute)
        {
            [str appendString:@"["];
            [str appendString:cs.data.attribute];
            
            switch (cs.match)
            {
                case MatchExact:
                    [str appendString:@"="];
                    break;
                case MatchSet:
                    // set has no operator or value, just the attrName
                    [str appendString:@"]"];
                    break;
                case MatchList:
                    [str appendString:@"~="];
                    break;
                case MatchHyphen:
                    [str appendString:@"|="];
                    break;
                case MatchBegin:
                    [str appendString:@"^="];
                    break;
                case MatchEnd:
                    [str appendString:@"$="];
                    break;
                case MatchContain:
                    [str appendString:@"*="];
                    break;
                default:
                    break;
            }
            
            if (cs.match != MatchSet)
            {
                [str appendString:cs.value];
                [str appendString:@"]"];
            }
        }
        if (cs.relation != SubSelector || !cs.tagHistory)
            break;
        cs = cs.tagHistory;
    }
    
    CSSSelector* tagHistory = cs.tagHistory;
    
    if (tagHistory)
    {
        NSString * tagHistoryText = [tagHistory selectorText];
        
        if (cs.relation == DirectAdjacent)
            [str insertString:[NSString stringWithFormat:@"%@ + ", tagHistoryText] atIndex:0];
        else if (cs.relation == IndirectAdjacent)
            [str insertString:[NSString stringWithFormat:@"%@ ~ ", tagHistoryText] atIndex:0];
        else if (cs.relation == Child)
            [str insertString:[NSString stringWithFormat:@"%@ > ", tagHistoryText] atIndex:0];
        else // Descendant
            [str insertString:[NSString stringWithFormat:@"%@ ", tagHistoryText] atIndex:0];
    }
    
    return str;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

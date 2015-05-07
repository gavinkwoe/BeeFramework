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

extern int cssToken;

#import "CSSParser.h"
#import "CSSTokenizer.h"

@interface CSSParser()

//@property (nonatomic, retain) NSMutableArray * floatingFunctions;
//@property (nonatomic, retain) NSMutableArray * floatingValueLists;

@property (nonatomic, retain) NSMutableArray * reusableMediaQueryExpList;

@property (nonatomic, retain) NSMutableArray * parsedProperties;

@property (nonatomic, retain) NSMutableArray * reusableProperties;

@property (nonatomic, assign) int numParsedProperties;

@property (nonatomic, assign) int count;

@end

@implementation CSSParser

DEF_SINGLETON( CSSParser );

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.parsedProperties          = [NSMutableArray array];
        self.reusableSelectorVector    = [NSMutableArray array];
        self.reusableMediaQueryExpList = [NSMutableArray array];
//        self.floatingFunctions         = [NSMutableArray array];
//        self.floatingValueLists        = [NSMutableArray array];
    }
    
    return self;
}

- (void)dealloc
{
    self.parsedProperties          = nil;
    self.reusableSelectorVector    = nil;
    self.reusableMediaQueryExpList = nil;
//    self.floatingFunctions         = nil;
//    self.floatingValueLists        = nil;

    [super dealloc];
}

#pragma mark - fontface

- (CSSFontFaceRule *)createFontFaceRule
{
    CSSStyleDeclaration * delc = [[[CSSStyleDeclaration alloc] init] autorelease];
    delc.properties = [NSArray arrayWithArray:self.parsedProperties];
    
    CSSFontFaceRule * rule = [[[CSSFontFaceRule alloc] init] autorelease];
    rule.style = delc;

    [self.parsedProperties removeAllObjects];
    
    return rule;
}

#pragma mark - import

- (CSSImportRule *)createImportRuleWithURL:(NSString *)url media:(CSSMediaList *)media
{
    CSSImportRule * rule = [[[CSSImportRule alloc] init] autorelease];
    rule.url = [url substringWithRange:NSMakeRange( 4, url.length - 5 )];
    rule.media = media;
    rule.styleSheet = self.styleSheet;

    return rule;
}

#pragma mark - media

- (CSSMediaRule *)createMediaRuleWithMediaList:(CSSMediaList *)media ruleList:(CSSRuleList *)ruleList
{
    if ( nil == self.styleSheet || nil == media || nil == ruleList )
        return nil;
    
    CSSMediaRule * mediaRule = [[[CSSMediaRule alloc] init] autorelease];
    mediaRule.media = media;
    mediaRule.ruleList = ruleList;
    mediaRule.styleSheet = self.styleSheet;

    return mediaRule;
}

- (NSMutableArray *)createFloatingMediaQueryExpList
{
    return self.reusableMediaQueryExpList;
}

- (NSArray *)sinkFloatingMediaQueryExpList:(NSMutableArray *)explist
{
    NSArray * array = [[explist copy] autorelease];
    [self.reusableMediaQueryExpList removeAllObjects];
    return array;
}

- (CSSMediaQueryExp *)createFloatingMediaQueryExp
{
    return [[[CSSMediaQueryExp alloc] init] autorelease];
}

- (CSSMediaQueryExp *)sinkFloatingMediaQueryExp:(CSSMediaQueryExp *)exp
{
    return exp;
}

- (CSSMediaQuery *)createFloatingMediaQuery
{
    return [[[CSSMediaQuery alloc] init] autorelease];
}

- (CSSMediaQuery *)sinkFloatingMediaQuery:(CSSMediaQuery *)query
{
    return query;
}

- (CSSMediaList *)createMediaList
{
    return [[[CSSMediaList alloc] init] autorelease];;
}

#pragma mark - rule

- (void)markRuleBodyStart
{
//    INFO( @"rulebody start" );
}

- (void)markRuleBodyEnd
{
//    INFO( @"rulebody end" );
}

- (void)addRule:(CSSRule *)rule
{
    [self.styleSheet addRule:rule];
}

- (CSSRuleList *)createRuleList
{
    return [[[CSSRuleList alloc] init] autorelease];;
}

- (CSSStyleRule *)createStyleRule:(NSArray *)selectorList
{
    CSSStyleRule * rule = nil;
    
    [self markRuleBodyEnd];
    
    if ( selectorList )
    {
        CSSStyleDeclaration * style = [[[CSSStyleDeclaration alloc] init] autorelease];
        style.properties = [[self.parsedProperties copy] autorelease];
        
        rule = [[[CSSStyleRule alloc] init] autorelease];
        rule.style = style;
        rule.selectorList = [[selectorList copy] autorelease];
    }
    
    [self.reusableSelectorVector removeAllObjects];
    [self.parsedProperties removeAllObjects];
    
    return rule;
}

#pragma mark - selector

- (void)markSelectorListStart
{
//    INFO( @"++++ SelectorListStart ++++" );
}

- (void)markSelectorListEnd
{
//    INFO( @"++++ SelectorListEnd ++++" )
}

- (CSSSelector *)createFloatingSelector
{
    return [[[CSSSelector alloc] init] autorelease];
}

- (CSSSelector *)sinkFloatingSelector:(CSSSelector *)selector
{
    return selector;
}

- (NSMutableArray *)createFloatingSelectorVector
{
    return [NSMutableArray array];
}

- (NSMutableArray *)sinkFloatingSelectorVector:(NSMutableArray *)selectorVector
{
    return selectorVector;
}

- (void)updateSpecifier:(CSSSelector *)selector elementName:(NSString *)name
{
    selector.tag = name;
}

- (CSSSelector *)updateSpecifier:(CSSSelector *)specifier withNewSpecifier:(CSSSelector *)newSpecifier
{
    if ( [newSpecifier isUnknownPseudoElement] )
    {
        [newSpecifier appendTagHistory:specifier relation:ShadowDescendant];
        return newSpecifier;
    }
    
    if ([specifier isUnknownPseudoElement])
    {
        
        [specifier insertTagHistory:newSpecifier relationBefore:SubSelector relationAfter:ShadowDescendant];
        return specifier;
    }

    [specifier appendTagHistory:newSpecifier relation:SubSelector];
    
    return specifier;
}

#pragma mark - property and value

- (void)markPropertyStart
{
//    INFO( @"===== Declaration Start =====" );
}

- (void)markPropertyEnd
{
}

- (void)addPropertyWithName:(NSString *)name value:(id)value important:(BOOL)important
{
    if ( name && value )
    {
        CSSProperty * prop = [[[CSSProperty alloc] init] autorelease];
        prop.name = name;
        prop.value = value;
        prop.important = important;
        
        self.numParsedProperties++;
        [self.parsedProperties addObject:prop];
    }
}

- (void)rollbackLastProperties:(int)num
{
    if ( num < 0 || self.numParsedProperties < num )
        return;
    
    for (int i = 0; i < num; ++i)
    {
        [self.parsedProperties removeObjectAtIndex:--self.numParsedProperties];
    }
}

#pragma mark - parse

- (void)parseFile:(NSString *)filePath style:(CSSStyleSheet *)styleSheet
{
    self.styleSheet = styleSheet;
    [self parseFile:filePath];
}

- (void)parseString:(NSString *)string style:(CSSStyleSheet *)styleSheet
{
    self.styleSheet = styleSheet;
    [self parseString:string];
}

- (void)parseFile:(NSString *)fileName
{
	if ( nil == fileName )
		return;
	
	NSString * extension = [fileName pathExtension];
	NSString * fullName = [fileName substringToIndex:(fileName.length - extension.length - 1)];
	NSString * resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
	
    [self parseString:[NSString stringWithContentsOfFile:resPath encoding:NSUTF8StringEncoding error:NULL]];
}

- (void)parseString:(NSString *)string
{
    _count = 0;
    
    @autoreleasepool {
    
        if ( string && string.length )
        {
            yy_create_input([string UTF8String]);
            yyparse( self );
            yy_delete_input();
        }
    }
}

#pragma mark - flex & bison

- (int)csslex:(void *)yylvalp
{
    _count++;
    
    YYSTYPE * yylval = yylvalp;
    
    int length = 0;
    
    char * text = [self text:&length];

    switch (cssToken)
    {
        case WHITESPACE:
        case SGML_CD:
        case INCLUDES:
        case DASHMATCH:
        case IMPORT_SYM:
        case MEDIA_SYM:
        case FONT_FACE_SYM:
        case CHARSET_SYM:
        case IMPORTANT_SYM:
            break;
        
        case FLOATTOKEN:
        case INTEGER:
        {
            yylval->nsnumber = [NSNumber numberWithDouble:atof(text)];
            break;
        }
            
        case CSSLENGTH:
        case PERCENTAGE:
        case URII:
        case STRING:
        case IDENT:
        case NTH:
        case HEX:
        case IDSEL:
        case DIMEN:
        case UNICODERANGE:
        case CSSFUNCTION:
        case ANYFUNCTION:
        case NOTFUNCTION:
            
        default:
        {
            yylval->nsstring = [[[NSString alloc] initWithBytes:text length:length encoding:NSUTF8StringEncoding] autorelease];
            break;
        }
    }
    
    return cssToken;
}

bool isHTMLSpace(char character)
{
    return character <= ' ' && (character == ' ' || character == '\n' || character == '\t' || character == '\r' || character == '\f');
}

- (char *)text:(int *)length
{
    char * start = yytext;
    int l = yyleng;
    switch (cssToken) {
        case STRING:
            l--;
            /* nobreak */
        case HEX:
        case IDSEL:
            // strip '#'
            start++;
            l--;
            break;
        case URII:
            // "url("{w}{string}{w}")"
            // "url("{w}{url}{w}")"
            // strip "url(" and ")"
//            start += 4;
//            l -= 5;
//            l--;
            // strip {w}
            while (l && isHTMLSpace(*start)) {
                ++start;
                --l;
            }
            while (l && isHTMLSpace(start[l - 1]))
                --l;
            if (l && (*start == '"' || *start == '\'')) {
                ASSERT(l >= 2 && start[l - 1] == *start);
                ++start;
                l -= 2;
            }
            break;
        default:
            break;
    }
    
    *length = l;
    return start;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

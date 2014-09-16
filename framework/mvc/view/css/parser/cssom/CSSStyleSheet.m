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
#import "CSSParser.h"
#import "CSSRuleSet.h"
#import "CSSStyleSheet.h"

#pragma mark -

@interface CSSElement : NSObject<CSSElementProtocol>
@property (nonatomic, retain) NSString *	hash;
@property (nonatomic, retain) NSString *	localName;
@property (nonatomic, retain) NSArray *		classes;
@property (nonatomic, retain) NSArray *		pseudos;
@property (nonatomic, retain) NSArray *		attributes;
@end

#pragma mark -

@implementation CSSElement

@synthesize hash;
@synthesize localName;
@synthesize classes;
@synthesize pseudos;
@synthesize attributes;

- (void)dealloc
{
    self.classes = nil;
    self.pseudos = nil;
    self.attributes = nil;
    
    [super dealloc];
}

- (BOOL)isElementNode
{
	return YES;
}

- (BOOL)isFirstChild
{
	return YES;
}

- (BOOL)isLastChild
{
	return YES;
}

- (BOOL)isNthChild:(NSUInteger)index
{
	return index == [self index];
}

- (NSUInteger)index
{
	return 0;
}

- (NSArray *)childs
{
	return nil;
}

- (NSArray *)siblings
{
	return nil;
}

- (NSArray *)previousSiblings
{
	return nil;
}

- (NSArray *)followingSiblings
{
	return nil;
}

- (id<CSSElementProtocol>)parent
{
	return nil;
}

- (id<CSSElementProtocol>)siblingAtIndex:(NSInteger)index
{
	return nil;
}

@end

#pragma mark -

@interface CSSStyleSheet()
@property (nonatomic, assign) CSSParser * parser;
@end

#pragma mark -

@implementation CSSStyleSheet

+ (CSSStyleSheet *)styleSheet
{
    return [[[CSSStyleSheet alloc] init] autorelease];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.ruleSet = [[[CSSRuleSet alloc] init] autorelease];
        self.parser = [CSSParser sharedInstance];
        self.rules = [NSMutableArray array];
    }
    
    return self;
}

- (void)dealloc
{
    self.ruleSet = nil;
    self.rules = nil;
    
    [super dealloc];
}

- (void)addRule:(CSSStyleRule *)rule
{
    [self.rules addObject:rule];
}

- (void)parseFile:(NSString*)filePath;
{
    [self.parser parseFile:filePath style:self];
}

- (void)parseString:(NSString *)string
{
    [self.parser parseString:string style:self];
}

- (void)ensureRuleSet
{
    [self.ruleSet addRulesFromSheet:self];
}

- (void)mergeStyleSheet:(CSSStyleSheet *)sheet
{
    [self.ruleSet addRulesFromSheet:sheet];
}

- (NSDictionary *)styleForString:(NSString *)string
{
	CSSElement * elem = [[[CSSElement alloc] init] autorelease];
	elem.classes = [NSArray arrayWithObject:string];
	return [[CSSStyleSelector sharedInstance] styleForElement:elem inStyleSheet:self];
}

- (NSDictionary *)styleForElement:(id<CSSElementProtocol>)element
{
    return [[CSSStyleSelector sharedInstance] styleForElement:element inStyleSheet:self];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

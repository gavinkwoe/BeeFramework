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
#import "CSSStyleSheet.h"

#pragma mark - CSSProperty

@implementation CSSProperty

- (void)dealloc
{
    self.name = nil;
    self.value = nil;
    
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ = %@", self.name, self.value];
}

@end

#pragma mark - CSSStyleDeclaration

@implementation CSSStyleDeclaration

- (void)dealloc
{
    self.properties = nil;
    
    [super dealloc];
}

- (NSString *)description
{
    return [self.properties description];
}

@end

#pragma mark - Media

@implementation CSSMediaList

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.queries = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [self.queries removeAllObjects];
    self.queries = nil;
    
    [super dealloc];
}

- (NSString *)description
{
    return [self.queries description];
}

- (void)appendMediaQuery:(CSSMediaQuery *)query
{
    [self.queries addObject:query];
}

- (BOOL)isCompatibled
{
    for ( CSSMediaQuery * query in self.queries )
    {
        if ( NO == [query isCompatibled] )
            return NO;
    }
    
    return YES;
}

@end

@implementation CSSMediaQuery

- (void)dealloc
{
    self.mediaType = nil;
    self.restrictor = nil;
    self.expressions = nil;
    
    [super dealloc];
}

- (NSString *)description
{
    NSMutableString * string = [NSMutableString string];
    
    if ( self.restrictor )
    {
        [string appendFormat:@"%@", self.restrictor];
    }
    
    if ( self.mediaType )
    {
        [string appendFormat:@" %@", self.mediaType];
    }
    
    if ( self.expressions && self.expressions.count )
    {
        for ( int i=0; i < self.expressions.count; i++ )
        {
            if ( i > 0 || self.mediaType )
            {
                [string appendString:@" and"];
            }
            
            CSSMediaQueryExp * exp = self.expressions[i];
            
            [string appendFormat:@" %@", [exp description]];
        }
    }
    
    return  string;
}

+ (BOOL)isCompatibled:(NSString *)mediaType
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    if ( nil == mediaType )
		return YES;
    
	if ( [mediaType matchAnyOf:@[@"iphone"]] )
	{
		if ( NO == [BeeSystemInfo isPhone] )
		{
			return NO;
		}
	}
	else if ( [mediaType matchAnyOf:@[@"iphone4"]] )
	{
		if ( NO == [BeeSystemInfo isPhone35] && NO == [BeeSystemInfo isPhoneRetina35] )
		{
			return NO;
		}
	}
	else if ( [mediaType matchAnyOf:@[@"iphone5"]] )
	{
		if ( NO == [BeeSystemInfo isPhoneRetina4] )
		{
			return NO;
		}
	}
	else if ( [mediaType matchAnyOf:@[@"ipad"]] )
	{
		if ( NO == [BeeSystemInfo isPad] && NO == [BeeSystemInfo isPadRetina] )
		{
			return NO;
		}
	}

	if ( [mediaType matchAnyOf:@[@"7", @"iOS7"]] )
	{
		return IOS7_OR_LATER;
	}
	else if ( [mediaType matchAnyOf:@[@"6", @"iOS6"]] )
	{
		return IOS6_OR_LATER;
	}
	else if ( [mediaType matchAnyOf:@[@"5", @"iOS5"]] )
	{
		return IOS5_OR_LATER;
	}
	else if ( [mediaType matchAnyOf:@[@"4", @"iOS4"]] )
	{
		return IOS4_OR_LATER;
	}
	
	return YES;
#else
    return NO;
#endif// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}


- (BOOL)isCompatibled
{
    for ( CSSMediaQueryExp * exp in self.expressions )
    {
        if ( [[self class] isCompatibled:[exp device]] )
        {
            return YES;
        }
    }
    
    return NO;
}

@end

@implementation CSSMediaQueryExp

- (void)dealloc
{
    self.values = nil;
    self.feature = nil;
    
    [super dealloc];
}

- (NSString *)description
{
    NSMutableString * string = [NSMutableString string];
    
    [string appendString:@"("];
    if ( self.feature )
        [string appendString:self.feature];
    if ( self.values )
        [string appendFormat:@": %@", self.values];
    [string appendString:@")"];
    
    return string;
}

@end

@implementation CSSMediaQueryExp(expression)

- (NSString *)device
{
    if ( [self.feature isEqualToString:@"device"] )
    {
        return self.values;
    }
    
    return nil;
}

@end

#pragma mark - CSSRule

@implementation CSSRule
@end

@implementation CSSRuleList

- (void)dealloc
{
    [self.rules removeAllObjects];
    self.rules = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.rules = [NSMutableArray array];
    }
    return self;
}

- (void)appendRule:(CSSRule *)rule
{
    [self.rules addObject:rule];
}

- (NSString *)description
{
    NSString * desc = self.rules.description;
    return desc;
}

@end

@implementation CSSStyleRule

- (void)dealloc
{
    self.style = nil;
    self.selectorList = nil;
    
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@%@", self.selectorList, self.style];
}

@end

@implementation CSSMediaRule

- (void)dealloc
{
    self.media = nil;
    self.ruleList = nil;
    self.styleSheet = nil;
    
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"@media %@ %@", self.media, self.ruleList];
}

@end

@implementation CSSImportRule

- (void)dealloc
{
    self.url = nil;
    self.media = nil;
    self.styleSheet = nil;
    
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"@import url(%@)", self.url];
}

@end

@implementation CSSFontFaceRule

- (void)dealloc
{
    self.style = nil;
    
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"@font-face {\n%@\n}", self.style.properties];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

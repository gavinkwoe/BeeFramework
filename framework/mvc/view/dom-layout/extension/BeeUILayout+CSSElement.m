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

#import "BeeUILayout+CSSElement.h"
#import "CSSStyleSelector.h"

@implementation BeeUILayout (CSSElement)

- (NSString *)hash
{
    return self.name;
}

- (NSString *)localName
{
    return self.elemName;
}

- (NSUInteger)index
{
    return [self.parent.childs indexOfObject:self] + 1;
}

- (NSArray *)classes
{
    return self.styleClasses;
}

- (NSArray *)pseudos
{
    return nil;
}

//- (NSArray *)attributes
//{
//    return nil;
//}

- (BOOL)isElementNode
{
    return YES;
}

- (BOOL)isFirstChild
{
    return [self index] == 1;
}

- (BOOL)isLastChild
{
    return [self index] == self.parent.childs.count;
}

- (BOOL)isNthChild:(NSUInteger)index
{
    return [self index] == index;
}

- (NSArray *)siblings
{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.parent.childs];
    [array removeObject:self];
    return array;
}

- (NSArray *)previousSiblings
{
    NSInteger loc = 0;
    NSInteger len = [self.parent.childs indexOfObject:self];

    if ( len >= self.parent.childs.count )
        return nil;
    
    return [self.parent.childs subarrayWithRange:NSMakeRange(loc, len)];
}

- (NSArray *)followingSiblings
{
    NSInteger loc = [self.parent.childs indexOfObject:self] + 1;
    NSInteger len = self.parent.childs.count - loc;
    
    if ( loc >= self.parent.childs.count || len < 0 )
        return nil;
    
    return [self.parent.childs subarrayWithRange:NSMakeRange(loc, len)];
}

- (id<CSSElementProtocol>)siblingAtIndex:(NSInteger)index
{
    NSInteger currentIndex = [self.parent.childs indexOfObject:self];
    NSInteger siblingIndex = currentIndex + index;
    
    if ( siblingIndex < 0 || siblingIndex >= self.parent.childs.count )
        return nil;
    
    return self.parent.childs[siblingIndex];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

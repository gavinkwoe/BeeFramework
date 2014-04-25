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

#import "Bee_Precompile.h"

#pragma mark -

typedef NSMutableArray *	(^NSArrayAppendBlock)( id obj );
typedef NSMutableArray *	(^NSMutableArrayAppendBlock)( id obj );
typedef NSComparisonResult	(^NSMutableArrayCompareBlock)( id left, id right );

#pragma mark -

@interface NSArray(BeeExtension)

@property (nonatomic, readonly) NSArrayAppendBlock			APPEND;
@property (nonatomic, readonly) NSMutableArray *			mutableArray;

- (NSArray *)head:(NSUInteger)count;
- (NSArray *)tail:(NSUInteger)count;

- (id)safeObjectAtIndex:(NSInteger)index;
- (NSArray *)safeSubarrayWithRange:(NSRange)range;

- (NSString *)join:(NSString *)delimiter;

@end

#pragma mark -

@interface NSMutableArray(BeeExtension)

@property (nonatomic, readonly) NSMutableArrayAppendBlock	APPEND;

+ (NSMutableArray *)nonRetainingArray;			// copy from Three20

- (void)addUniqueObject:(id)object compare:(NSMutableArrayCompareBlock)compare;
- (void)addUniqueObjects:(const id [])objects count:(NSUInteger)count compare:(NSMutableArrayCompareBlock)compare;
- (void)addUniqueObjectsFromArray:(NSArray *)array compare:(NSMutableArrayCompareBlock)compare;

- (void)unique;
- (void)unique:(NSMutableArrayCompareBlock)compare;

- (void)sort;
- (void)sort:(NSMutableArrayCompareBlock)compare;

- (NSMutableArray *)pushHead:(NSObject *)obj;
- (NSMutableArray *)pushHeadN:(NSArray *)all;
- (NSMutableArray *)popTail;
- (NSMutableArray *)popTailN:(NSUInteger)n;

- (NSMutableArray *)pushTail:(NSObject *)obj;
- (NSMutableArray *)pushTailN:(NSArray *)all;
- (NSMutableArray *)popHead;
- (NSMutableArray *)popHeadN:(NSUInteger)n;

- (NSMutableArray *)keepHead:(NSUInteger)n;
- (NSMutableArray *)keepTail:(NSUInteger)n;

- (void)insertObjectNoRetain:(id)anObject atIndex:(NSUInteger)index;
- (void)addObjectNoRetain:(NSObject *)obj;
- (void)removeObjectNoRelease:(NSObject *)obj;
- (void)removeAllObjectsNoRelease;

- (void)removeObject:(NSObject *)obj usingComparator:(NSMutableArrayCompareBlock)cmptr;

@end

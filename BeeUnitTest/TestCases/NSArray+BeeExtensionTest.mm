//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  NSArray+BeeExtensionTest.h
//

#import "Bee.h"
#import "Bee_UnitTest.h"

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( nonmutable_array )
{
	TIMES( 3 )
	{
		NSArray * arr = [NSArray array];
		EXPECTED( arr );
		EXPECTED( 0 == arr.count );
		
		NSString * temp = [arr safeObjectAtIndex:100];
		EXPECTED( nil == temp );
		
		arr = arr.APPEND( @"1" );
		EXPECTED( 1 == arr.count );
		
		arr = arr.APPEND( @"2" ).APPEND( @"3" );
		EXPECTED( 3 == arr.count );

		NSArray * head2 = [arr head:2];
		EXPECTED( head2 );
		EXPECTED( 2 == head2.count );
		EXPECTED( [[head2 objectAtIndex:0] isEqualToString:@"1"] );
		EXPECTED( [[head2 objectAtIndex:1] isEqualToString:@"2"] );

		NSArray * tail2 = [arr tail:2];
		EXPECTED( tail2 );
		EXPECTED( 2 == tail2.count );
		EXPECTED( [[tail2 objectAtIndex:0] isEqualToString:@"2"] );
		EXPECTED( [[tail2 objectAtIndex:1] isEqualToString:@"3"] );
	}
}
TEST_CASE_END

TEST_CASE( mutable_array )
{
//	+ (NSMutableArray *)nonRetainingArray;	// copy from Three20
//	
//	- (NSMutableArray *)pushHead:(NSObject *)obj;
//	- (NSMutableArray *)pushHeadN:(NSArray *)all;
//	- (NSMutableArray *)popTail;
//	- (NSMutableArray *)popTailN:(NSUInteger)n;
//	
//	- (NSMutableArray *)pushTail:(NSObject *)obj;
//	- (NSMutableArray *)pushTailN:(NSArray *)all;
//	- (NSMutableArray *)popHead;
//	- (NSMutableArray *)popHeadN:(NSUInteger)n;
//	
//	- (NSMutableArray *)keepHead:(NSUInteger)n;
//	- (NSMutableArray *)keepTail:(NSUInteger)n;
//	
//	- (void)insertObjectNoRetain:(id)anObject atIndex:(NSUInteger)index;
//	- (void)addObjectNoRetain:(NSObject *)obj;
//	- (void)removeObjectNoRelease:(NSObject *)obj;
//	- (void)removeAllObjectsNoRelease;
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

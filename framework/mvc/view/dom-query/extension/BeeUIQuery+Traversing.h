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

#import "Bee_UIQuery.h"

#pragma mark -

@interface BeeUIQuery(Traversing)

@property (nonatomic, readonly) UIView *				first;
@property (nonatomic, readonly) UIView *				last;
@property (nonatomic, readonly) UIView *				next;
@property (nonatomic, readonly) UIView *				prev;

@property (nonatomic, readonly) UIView *				parent;
@property (nonatomic, readonly) NSArray *				parents;
@property (nonatomic, readonly) NSArray *				children;

@property (nonatomic, readonly) NSArray *				siblings;
@property (nonatomic, readonly) NSArray *				closest;

@property (nonatomic, readonly) BeeUIQueryObjectBlockCS	ADD;
@property (nonatomic, readonly) BeeUIQueryObjectBlockCS	ADD_BACK;

@property (nonatomic, readonly) BeeUIQueryObjectBlock	CHILDREN;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	CLOSEST;

@property (nonatomic, readonly) BeeUIQueryObjectBlock	END;

@property (nonatomic, readonly) BeeUIQueryObjectBlockC	IS;
@property (nonatomic, readonly) BeeUIQueryObjectBlockC	NOT;
@property (nonatomic, readonly) BeeUIQueryObjectBlockN	EQ;
@property (nonatomic, readonly) BeeUIQueryObjectBlockN	HAS;

@property (nonatomic, readonly) BeeUIQueryObjectBlock	FIRST;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	LAST;

@property (nonatomic, readonly) BeeUIQueryObjectBlock	NEXT;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	NEXT_ALL;
@property (nonatomic, readonly) BeeUIQueryObjectBlockN	NEXT_UNTIL;

@property (nonatomic, readonly) BeeUIQueryObjectBlock	PREV;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	PREV_ALL;
@property (nonatomic, readonly) BeeUIQueryObjectBlockN	PREV_UNTIL;

@property (nonatomic, readonly) BeeUIQueryObjectBlockS	FIND;
@property (nonatomic, readonly) BeeUIQueryObjectBlockS	FILTER;

@property (nonatomic, readonly) BeeUIQueryObjectBlock	PARENT;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	PARENTS;
@property (nonatomic, readonly) BeeUIQueryObjectBlockN	PARENTS_UNTIL;

@property (nonatomic, readonly) BeeUIQueryObjectBlock	SIBLINGS;
@property (nonatomic, readonly) BeeUIQueryObjectBlockUU	SLICE;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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
//  Bee_UIQuery.h
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UICollection.h"
#import "NSObject+BeeProperty.h"

#pragma mark -

@class BeeUIQuery;

typedef	BeeUIQuery *			(^BeeUIQueryObjectBlock)( void );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockN)( id first, ... );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockB)( BOOL flag );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockF)( CGFloat value );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockU)( NSUInteger value );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockS)( NSString * value );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockUU)( NSUInteger start, NSUInteger length );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockFF)( CGFloat value1, CGFloat value2 );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockCS)( Class clazz, NSString * tag );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockX)( void (^block)( UIView * view ) );

typedef	id						(^BeeUIQueryValueBlock)( void );
typedef	id						(^BeeUIQueryValueBlockS)( NSString * value );

typedef BeeUIQueryObjectBlockN	(^BeeUIQueryContextBlock)( id context );
extern BeeUIQueryObjectBlockN	__getQueryBlock( id context );

#pragma mark -

#undef	$
#define $ __getQueryBlock( self )

#pragma mark -

@interface BeeUIQuery : BeeUICollection

@property (nonatomic, readonly) BeeUIQueryObjectBlock	HIDE;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	SHOW;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	TOGGLE;

//@property (nonatomic, readonly) BeeUIQueryObjectBlock	UNWRAP;
//@property (nonatomic, readonly) BeeUIQueryObjectBlockCS	WRAP;

@property (nonatomic, readonly) BeeUIQueryObjectBlockCS	BEFORE;
@property (nonatomic, readonly) BeeUIQueryObjectBlockCS	AFTER;
@property (nonatomic, readonly) BeeUIQueryObjectBlockCS	APPEND;
@property (nonatomic, readonly) BeeUIQueryObjectBlockCS	PREPEND;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	REMOVE;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	EMPTY;
@property (nonatomic, readonly) BeeUIQueryObjectBlockS	REPLACE_ALL;
@property (nonatomic, readonly) BeeUIQueryObjectBlockCS	REPLACE_WITH;

//@property (nonatomic, readonly) BeeUIQueryValueBlock	TEXT;
//@property (nonatomic, readonly) BeeUIQueryValueBlockS	VAL;

@property (nonatomic, readonly) BeeUIQueryObjectBlockX	EACH;
@property (nonatomic, readonly) BeeUIQueryObjectBlockS	FIND;
@property (nonatomic, readonly) BeeUIQueryObjectBlockS	FILTER;

@property (nonatomic, readonly) BeeUIQueryObjectBlock	FIRST;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	LAST;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	NEXT;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	PREV;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	CHILDREN;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	PARENT;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	PARENTS;
@property (nonatomic, readonly) BeeUIQueryObjectBlock	SIBLINGS;

//@property (nonatomic, readonly) BeeUIQueryObjectBlockN	EQ;
//@property (nonatomic, readonly) BeeUIQueryObjectBlockN	NOT;
//@property (nonatomic, readonly) BeeUIQueryObjectBlockUU	SLICE;

//@property (nonatomic, readonly) BeeUIQueryObjectBlockN	NEXT_ALL;
//@property (nonatomic, readonly) BeeUIQueryObjectBlockN	NEXT_UNTIL;
//@property (nonatomic, readonly) BeeUIQueryObjectBlockN	PARENTS_UNTIL;
//@property (nonatomic, readonly) BeeUIQueryObjectBlockN	PREV_ALL;
//@property (nonatomic, readonly) BeeUIQueryObjectBlockN	PREV_UNTIL;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

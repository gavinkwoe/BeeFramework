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

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"
#import "Bee_UICollection.h"
#import "Bee_UIAnimation.h"

#pragma mark -

@class BeeUIQuery;

typedef	BeeUIQuery *			(^BeeUIQueryObjectBlock)( void );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockN)( id first, ... );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockB)( BOOL flag );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockF)( CGFloat value );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockR)( CGRect frame );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockU)( NSUInteger value );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockS)( NSString * value );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockSF)( NSString * value, CGFloat value2 );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockSS)( NSString * value1, NSString * value2 );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockUU)( NSUInteger start, NSUInteger length );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockFF)( CGFloat value1, CGFloat value2 );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockC)( Class clazz );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockRF)( CGRect value1, CGFloat value2 );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockCS)( Class clazz, NSString * tag );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockX)( void (^block)( void ) );
typedef	BeeUIQuery *			(^BeeUIQueryObjectBlockXV)( void (^block)( UIView * view ) );

typedef	BeeUIAnimation *		(^BeeUIQueryAnimationBlock)( void );
typedef	BeeUIAnimation *		(^BeeUIQueryAnimationBlockF)( CGFloat value );
typedef	BeeUIAnimation *		(^BeeUIQueryAnimationBlockR)( CGRect value );
typedef	BeeUIAnimation *		(^BeeUIQueryAnimationBlockRF)( CGRect value1, CGFloat value2 );
typedef	BeeUIAnimation *		(^BeeUIQueryAnimationBlockFF)( CGFloat value1, CGFloat value2 );
typedef	BeeUIAnimation *		(^BeeUIQueryAnimationBlockSF)( NSString * value, CGFloat value2 );

typedef	BOOL					(^BeeUIQueryBoolBlockS)( NSString * value );
typedef	NSString *				(^BeeUIQueryStringBlock)( void );
typedef	BeeUIQueryObjectBlockN	(^BeeUIQueryContextBlock)( id context );

#pragma mark -

#if defined(__cplusplus)
extern "C"
#else	// #if defined(__cplusplus)
extern
#endif	// #if defined(__cplusplus)

BeeUIQueryObjectBlockN	__getQueryBlock( id context );

#pragma mark -

#undef	$
#define $ __getQueryBlock( self )

#undef	FUNCTION
#define	FUNCTION ^

#pragma mark -

@interface BeeUIQuery : BeeUICollection
+ (NSMutableArray *)findViewsIn:(UIView *)rootView byExpression:(NSString *)tag;
@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

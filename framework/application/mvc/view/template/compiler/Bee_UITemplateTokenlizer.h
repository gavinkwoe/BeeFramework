//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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
#import "Bee_UITemplateContext.h"

#pragma mark -

@class BeeUITemplateTokenlizer;

typedef BeeUITemplateTokenlizer *	(^BeeUITemplateTokenlizerBlock)( void );
typedef BeeUITemplateTokenlizer *	(^BeeUITemplateTokenlizerBlockN)( id first, ... );

/*
	 <!-- -->
	 A
	 <!--# if $condition -->
		<!-- -->
		B
		<!--# for $data in $datas -->
			<!-- -->
			C
			<!-- -->
		<!--# end for -->
		D
		<!--# for $data in $datas -->
			<!-- -->
			E
			<!-- -->
		<!--# end for -->
		F
	 <!--# end if -->
	 G
	 <!-- -->
	 H

	root
		TEXT( A )
		EXPR( if $condition )
			TEXT( B )
			EXPR( for $data in $datas )
				TEXT( C )
			EXPR( end for )
			TEXT( D )
			EXPR( for $data in $datas )
				TEXT( E )
			EXPR( end for )
			TEXT( F )
		EXPR( end if )
		TEXT( G )
		TEXT( H )
*/

#pragma mark -

@interface BeeUITemplateTokenlizer : NSObject

@property (nonatomic, retain) NSString *	delimiter1;
@property (nonatomic, retain) NSString *	delimiter2;

@property (nonatomic, retain) NSString *	source;
@property (nonatomic, assign) NSUInteger	offset;

@property (nonatomic, assign) NSUInteger	tokenType;
@property (nonatomic, assign) NSRange		tokenRange;
@property (nonatomic, assign) NSRange		tokenInnerRange;
@property (nonatomic, readonly) NSString *	tokenString;
@property (nonatomic, readonly) NSString *	tokenInnerString;

@property (nonatomic, assign) NSUInteger	errorCode;
@property (nonatomic, retain) NSString *	errorDesc;

AS_INT( TOKEN_EOF )
AS_INT( TOKEN_TEXT )
AS_INT( TOKEN_IF )
AS_INT( TOKEN_FOR )
AS_INT( TOKEN_END )
AS_INT( TOKEN_EXPR )

AS_INT( ERROR_OK )
AS_INT( ERROR_FORMAT )

- (void)reset;
- (BOOL)nextToken;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

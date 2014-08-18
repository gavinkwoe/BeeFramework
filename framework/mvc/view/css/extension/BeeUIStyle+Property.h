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
#import "Bee_UIStyle.h"

#ifdef	OVERFLOW
#undef	OVERFLOW
#endif	// #ifdef OVERFLOW

#pragma mark -

@interface BeeUIStyle(Property)

AS_STRING( COMPOSITION_ABSOLUTE )
AS_STRING( COMPOSITION_RELATIVE )
AS_STRING( COMPOSITION_LINEAR )		// default

AS_STRING( POSITION_ABSOLUTE )
AS_STRING( POSITION_RELATIVE )		// default

AS_STRING( ALIGN_CENTER )
AS_STRING( ALIGN_LEFT )
AS_STRING( ALIGN_TOP )
AS_STRING( ALIGN_BOTTOM )
AS_STRING( ALIGN_RIGHT )

AS_STRING( ORIENTATION_HORIZONAL )
AS_STRING( ORIENTATION_VERTICAL )	// default

AS_STRING( DISPLAY_NONE )
AS_STRING( DISPLAY_BLOCK )

AS_STRING( OVERFLOW_VISIBLE )
AS_STRING( OVERFLOW_HIDDEN )
AS_STRING( OVERFLOW_SCROLL )
AS_STRING( OVERFLOW_AUTO )
AS_STRING( OVERFLOW_INHERIT )

@property (nonatomic, readonly) BeeUIStyleBlockN		X;
@property (nonatomic, readonly) BeeUIStyleBlockN		Y;
@property (nonatomic, readonly) BeeUIStyleBlockN		W;
@property (nonatomic, readonly) BeeUIStyleBlockN		H;
@property (nonatomic, readonly) BeeUIStyleBlockN		TOP;
@property (nonatomic, readonly) BeeUIStyleBlockN		LEFT;
@property (nonatomic, readonly) BeeUIStyleBlockN		RIGHT;
@property (nonatomic, readonly) BeeUIStyleBlockN		BOTTOM;
@property (nonatomic, readonly) BeeUIStyleBlockN		POSITION;
@property (nonatomic, readonly) BeeUIStyleBlockN		COMPOSITION;
@property (nonatomic, readonly) BeeUIStyleBlockN		MARGIN;
@property (nonatomic, readonly) BeeUIStyleBlockN		MARGIN_TOP;
@property (nonatomic, readonly) BeeUIStyleBlockN		MARGIN_BOTTOM;
@property (nonatomic, readonly) BeeUIStyleBlockN		MARGIN_LEFT;
@property (nonatomic, readonly) BeeUIStyleBlockN		MARGIN_RIGHT;
@property (nonatomic, readonly) BeeUIStyleBlockN		MIN_WIDTH;
@property (nonatomic, readonly) BeeUIStyleBlockN		MAX_WIDTH;
@property (nonatomic, readonly) BeeUIStyleBlockN		MIN_HEIGHT;
@property (nonatomic, readonly) BeeUIStyleBlockN		MAX_HEIGHT;
@property (nonatomic, readonly) BeeUIStyleBlockN		PADDING;
@property (nonatomic, readonly) BeeUIStyleBlockN		PADDING_TOP;
@property (nonatomic, readonly) BeeUIStyleBlockN		PADDING_BOTTOM;
@property (nonatomic, readonly) BeeUIStyleBlockN		PADDING_LEFT;
@property (nonatomic, readonly) BeeUIStyleBlockN		PADDING_RIGHT;
@property (nonatomic, readonly) BeeUIStyleBlockN		ALIGN;
@property (nonatomic, readonly) BeeUIStyleBlockN		V_ALIGN;
@property (nonatomic, readonly) BeeUIStyleBlockN		FLOATING;
@property (nonatomic, readonly) BeeUIStyleBlockN		V_FLOATING;
@property (nonatomic, readonly) BeeUIStyleBlockN		ORIENTATION;
@property (nonatomic, readonly) BeeUIStyleBlockN		TEXT;
@property (nonatomic, readonly) BeeUIStyleBlockN		PACKAGE;
@property (nonatomic, readonly) BeeUIStyleBlockN		DISPLAY;
@property (nonatomic, readonly) BeeUIStyleBlockN		OVERFLOW;

@property (nonatomic, readonly) BeeUIMetrics *			x;
@property (nonatomic, readonly) BeeUIMetrics *			y;
@property (nonatomic, readonly) BeeUIMetrics *			w;
@property (nonatomic, readonly) BeeUIMetrics *			h;
@property (nonatomic, readonly) BeeUIMetrics *			top;
@property (nonatomic, readonly) BeeUIMetrics *			left;
@property (nonatomic, readonly) BeeUIMetrics *			right;
@property (nonatomic, readonly) BeeUIMetrics *			bottom;
@property (nonatomic, readonly) NSString *				position;
@property (nonatomic, readonly) NSString *				composition;
@property (nonatomic, readonly) BeeUIMetrics *			margin_top;
@property (nonatomic, readonly) BeeUIMetrics *			margin_bottom;
@property (nonatomic, readonly) BeeUIMetrics *			margin_left;
@property (nonatomic, readonly) BeeUIMetrics *			margin_right;
@property (nonatomic, readonly) BeeUIMetrics *			min_width;
@property (nonatomic, readonly) BeeUIMetrics *			max_width;
@property (nonatomic, readonly) BeeUIMetrics *			min_height;
@property (nonatomic, readonly) BeeUIMetrics *			max_height;
@property (nonatomic, readonly) BeeUIMetrics *			padding_top;
@property (nonatomic, readonly) BeeUIMetrics *			padding_bottom;
@property (nonatomic, readonly) BeeUIMetrics *			padding_left;
@property (nonatomic, readonly) BeeUIMetrics *			padding_right;
@property (nonatomic, readonly) NSString *				align;
@property (nonatomic, readonly) NSString *				v_align;
@property (nonatomic, readonly) NSString *				floating;
@property (nonatomic, readonly) NSString *				v_floating;
@property (nonatomic, readonly) NSString *				orientation;
@property (nonatomic, readonly) NSString *				text;
@property (nonatomic, readonly) NSString *				package;
@property (nonatomic, readonly) NSString *				display;
@property (nonatomic, readonly) NSString *				overflow;

- (BOOL)isRelativePosition;
- (BOOL)isAbsolutePosition;

- (BOOL)isFlexiableW;
- (BOOL)isFlexiableH;

- (BOOL)needAdjustX;
- (BOOL)needAdjustY;
- (BOOL)needAdjustW;
- (BOOL)needAdjustH;

- (BOOL)isAligning;
- (BOOL)isAlignCenter;
- (BOOL)isAlignLeft;
- (BOOL)isAlignRight;

- (BOOL)isVAligning;
- (BOOL)isVAlignCenter;
- (BOOL)isVAlignTop;
- (BOOL)isVAlignBottom;

- (BOOL)isFloating;
- (BOOL)isFloatCenter;
- (BOOL)isFloatLeft;
- (BOOL)isFloatRight;

- (BOOL)isVFloating;
- (BOOL)isVFloatCenter;
- (BOOL)isVFloatTop;
- (BOOL)isVFloatBottom;

- (BOOL)isHorizontal;
- (BOOL)isVertical;

- (BOOL)isHidden;

- (BOOL)hasMinW;
- (BOOL)hasMaxW;
- (BOOL)hasMinH;
- (BOOL)hasMaxH;

- (CGFloat)estimateXBy:(CGRect)parentFrame;
- (CGFloat)estimateYBy:(CGRect)parentFrame;
- (CGPoint)estimateOriginBy:(CGRect)parentFrame;

- (CGFloat)estimateLeftBy:(CGRect)parentFrame;
- (CGFloat)estimateTopBy:(CGRect)parentFrame;
- (CGFloat)estimateRightBy:(CGRect)parentFrame;
- (CGFloat)estimateBottomBy:(CGRect)parentFrame;

- (CGFloat)estimateWBy:(CGRect)parentFrame;
- (CGFloat)estimateHBy:(CGRect)parentFrame;
- (CGFloat)estimateMinWBy:(CGRect)parentFrame;
- (CGFloat)estimateMaxWBy:(CGRect)parentFrame;
- (CGFloat)estimateMinHBy:(CGRect)parentFrame;
- (CGFloat)estimateMaxHBy:(CGRect)parentFrame;
- (CGSize)estimateSizeBy:(CGRect)parentFrame;

- (UIEdgeInsets)estimateMarginBy:(CGRect)parentFrame;
- (UIEdgeInsets)estimatePaddingBy:(CGRect)parentFrame;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

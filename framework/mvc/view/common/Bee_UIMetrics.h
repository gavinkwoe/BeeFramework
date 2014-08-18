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

#pragma mark -

@class BeeUIMetrics;

@compatibility_alias BeeUIValue BeeUIMetrics;

BEE_EXTERN const CGSize	CGSizeAuto;
BEE_EXTERN const CGRect	CGRectAuto;

#pragma mark -

@interface BeeUIMetrics : NSObject

AS_INT( PIXEL )
AS_INT( PERCENT )
AS_INT( FILL_PARENT )
AS_INT( WRAP_CONTENT )

@property (nonatomic, assign) NSInteger	type;
@property (nonatomic, assign) CGFloat	value;

+ (BeeUIMetrics *)pixel:(CGFloat)value;
+ (BeeUIMetrics *)percent:(CGFloat)value;
+ (BeeUIMetrics *)fillParent;
+ (BeeUIMetrics *)wrapContent;

+ (BeeUIMetrics *)fromString:(NSString *)str;

- (CGFloat)valueBy:(CGFloat)val;

@end

#pragma mark -

extern CGSize	AspectFitSizeByWidth( CGSize size, CGFloat width );
extern CGSize	AspectFitSizeByHeight( CGSize size, CGFloat height );

extern CGSize	AspectFillSizeByWidth( CGSize size, CGFloat width );
extern CGSize	AspectFillSizeByHeight( CGSize size, CGFloat height );

extern CGSize	AspectFitSize( CGSize size, CGSize bound );
extern CGRect	AspectFitRect( CGRect rect, CGRect bound );

extern CGSize	AspectFillSize( CGSize size, CGSize bound );
extern CGRect	AspectFillRect( CGRect rect, CGRect bound );

extern CGRect	CGRectFromString( NSString * str );

extern CGPoint	CGPointZeroNan( CGPoint point );
extern CGSize	CGSizeZeroNan( CGSize size );
extern CGRect	CGRectZeroNan( CGRect rect );
extern CGRect	CGRectNormalize( CGRect rect );

extern CGRect	CGRectAlignX( CGRect rect1, CGRect rect2 );				// rect1向rect2的X轴中心点对齐
extern CGRect	CGRectAlignY( CGRect rect1, CGRect rect2 );				// rect1向rect2的Y轴中心点对齐
extern CGRect	CGRectAlignCenter( CGRect rect1, CGRect rect2 );		// rect1向rect2的中心点对齐

extern CGRect	CGRectAlignTop( CGRect rect1, CGRect rect2 );			// 右边缘对齐
extern CGRect	CGRectAlignBottom( CGRect rect1, CGRect rect2 );		// 下边缘对齐
extern CGRect	CGRectAlignLeft( CGRect rect1, CGRect rect2 );			// 左边缘对齐
extern CGRect	CGRectAlignRight( CGRect rect1, CGRect rect2 );			// 上边缘对齐

extern CGRect	CGRectAlignLeftTop( CGRect rect1, CGRect rect2 );		// 右边缘对齐
extern CGRect	CGRectAlignLeftBottom( CGRect rect1, CGRect rect2 );	// 下边缘对齐
extern CGRect	CGRectAlignRightTop( CGRect rect1, CGRect rect2 );		// 右边缘对齐
extern CGRect	CGRectAlignRightBottom( CGRect rect1, CGRect rect2 );	// 下边缘对齐

extern CGRect	CGRectCloseToTop( CGRect rect1, CGRect rect2 );			// 与上边缘靠近
extern CGRect	CGRectCloseToBottom( CGRect rect1, CGRect rect2 );		// 与下边缘靠近
extern CGRect	CGRectCloseToLeft( CGRect rect1, CGRect rect2 );		// 与左边缘靠近
extern CGRect	CGRectCloseToRight( CGRect rect1, CGRect rect2 );		// 与右边缘靠近

extern CGRect	CGRectReduceWidth( CGRect rect, CGFloat pixels );		// 变宽
extern CGRect	CGRectReduceHeight( CGRect rect, CGFloat pixels );		// 变高

extern CGRect	CGRectMoveCenter( CGRect rect1, CGPoint offset );		// 移动中心点
extern CGRect	CGRectMakeBound( CGFloat w, CGFloat h );

extern CGRect	CGSizeMakeBound( CGSize size );
extern CGRect	CGRectToBound( CGRect frame );

extern CGSize	CGRectGetDistance( CGRect rect1, CGRect rect2 );		// 获取rect1与rect2的`dx`和`dy`

#pragma mark -

extern CGSize               CGSizeFromStringEx( NSString * text );
extern UIEdgeInsets			UIEdgeInsetsFromStringEx( NSString * text );
extern UIViewContentMode	UIViewContentModeFromString( NSString * text );
extern UITextAlignment		UITextAlignmentFromString( NSString * text );
extern UILineBreakMode		UILineBreakModeFromString( NSString * text );
extern UIBaselineAdjustment	UIBaselineAdjustmentFromString( NSString * text );

extern UIControlContentVerticalAlignment	UIControlContentVerticalAlignmentFromString( NSString * text );
extern UIControlContentHorizontalAlignment	UIControlContentHorizontalAlignmentFromString( NSString * text );

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

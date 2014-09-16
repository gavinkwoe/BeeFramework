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

#import "Bee_UIMetrics.h"
#import "Bee_Precompile.h"

#pragma mark -

const CGSize CGSizeAuto = { 0.0f, 0.0f };
const CGRect CGRectAuto = { { 0.0f, 0.0f }, { 0.0f, 0.0f } };

#pragma mark -

#undef	LAYOUT_MAX_WIDTH
#define LAYOUT_MAX_WIDTH	(99999.0f)

#undef	LAYOUT_MAX_HEIGHT
#define LAYOUT_MAX_HEIGHT	(99999.0f)

#undef  FLOORF
#define FLOORF(v) (v)
//#define FLOORF(v) floorf(v)

#pragma mark -

@interface BeeUIMetrics()
{
	NSInteger	_type;
	CGFloat		_value;
}
@end

#pragma mark -

@implementation BeeUIMetrics

DEF_INT( PIXEL,			0 )
DEF_INT( PERCENT,		1 )
DEF_INT( FILL_PARENT,	2 )
DEF_INT( WRAP_CONTENT,	3 )

@synthesize type = _type;
@synthesize value = _value;

- (NSString *)description
{
	if ( self.PIXEL == self.type )
	{
		return [NSString stringWithFormat:@"%.1fpx", _value];
	}
	else if ( self.PERCENT == self.type )
	{
		return [NSString stringWithFormat:@"%.1f%%", _value];
	}
	else if ( self.FILL_PARENT == self.type )
	{
		return @"fill_parent";
	}
	else if ( self.WRAP_CONTENT == self.type )
	{
		return @"wrap_content";
	}
	
	return @"";
}

+ (BeeUIMetrics *)pixel:(CGFloat)val
{
	BeeUIMetrics * value = [[[BeeUIMetrics alloc] init] autorelease];
	value.type = self.PIXEL;
	value.value = val;
	return value;
}

+ (BeeUIMetrics *)percent:(CGFloat)val
{
	BeeUIMetrics * value = [[[BeeUIMetrics alloc] init] autorelease];
	value.type = self.PERCENT;
	value.value = val;
	return value;
}

+ (BeeUIMetrics *)fillParent
{
	BeeUIMetrics * value = [[[BeeUIMetrics alloc] init] autorelease];
	value.type = self.FILL_PARENT;
	return value;
}

+ (BeeUIMetrics *)wrapContent
{
	BeeUIMetrics * value = [[[BeeUIMetrics alloc] init] autorelease];
	value.type = self.WRAP_CONTENT;
	return value;
}

+ (BeeUIMetrics *)fromString:(NSString *)str
{
	if ( 0 == str.length )
		return nil;
	
	BeeUIMetrics * value = [[[BeeUIMetrics alloc] init] autorelease];
	if ( value )
	{
		if ( [str hasSuffix:@"px"] )
		{
			value.type = self.PIXEL;
		}
		else if ( [str hasSuffix:@"%"] )
		{
			value.type = self.PERCENT;
		}
		else if ( NSOrderedSame == [str compare:@"fill" options:NSCaseInsensitiveSearch] ||
				 NSOrderedSame == [str compare:@"fill_parent" options:NSCaseInsensitiveSearch] )
		{
			value.type = self.FILL_PARENT;
		}
		else if ( NSOrderedSame == [str compare:@"auto" options:NSCaseInsensitiveSearch] ||
				 NSOrderedSame == [str compare:@"wrap_content" options:NSCaseInsensitiveSearch] )
		{
			value.type = self.WRAP_CONTENT;
		}
		else
		{
			value.type = self.PIXEL;
		}
		
		value.value = [str floatValue];
	}
	return value;
}

- (CGFloat)valueBy:(CGFloat)val
{
	if ( BeeUIMetrics.PIXEL == _type )
	{
		return _value;
	}
	else if ( BeeUIMetrics.PERCENT == _type )
	{
		return FLOORF( val * _value / 100.0f );
	}
	
	return val;
}

@end

#pragma mark -

CGSize AspectFitSizeByWidth( CGSize size, CGFloat width )
{
	float scale = size.width / width;
	return CGSizeMake( size.width / scale, size.height / scale );
}

CGSize AspectFitSizeByHeight( CGSize size, CGFloat height )
{
	float scale = size.height / height;
	return CGSizeMake( size.width / scale, size.height / scale );
}

CGSize AspectFillSizeByWidth( CGSize size, CGFloat width )
{
	float scale = width / size.width;
	
	size.width *= scale;
	size.height *= scale;
	size.width = FLOORF( size.width );
	size.height = FLOORF( size.height );
	
	return size;
}

CGSize AspectFillSizeByHeight( CGSize size, CGFloat height )
{
	float scale = height / size.height;
	
	size.width *= scale;
	size.height *= scale;
	size.width = FLOORF( size.width );
	size.height = FLOORF( size.height );
	
	return size;
}

CGSize AspectFitSize( CGSize size, CGSize bound )
{
	if ( size.width == 0 || size.height == 0 )
		return CGSizeZero;
	
	CGSize newSize = size;
	CGFloat newScale = 1.0f;
	
	float scaleX = bound.width / newSize.width;
	float scaleY = bound.height / newSize.height;
	
	newScale = fminf( scaleX, scaleY );
	
	newSize.width *= newScale;
	newSize.height *= newScale;
	
	newSize.width = FLOORF( newSize.width );
	newSize.height = FLOORF( newSize.height );
	
	return newSize;
}

CGRect AspectFitRect( CGRect rect, CGRect bound )
{
	CGSize newSize = AspectFitSize( rect.size, bound.size );
	newSize.width = FLOORF( newSize.width );
	newSize.height = FLOORF( newSize.height );
	
	CGRect newRect;
	newRect.origin.x = (bound.size.width - newSize.width) / 2;
	newRect.origin.y = (bound.size.height - newSize.height) / 2;
	newRect.size.width = newSize.width;
	newRect.size.height = newSize.height;
	
	return newRect;
}

CGSize AspectFillSize( CGSize size, CGSize bound )
{
	CGSize newSize = size;
	CGFloat newScale = 1.0f;
	
	float scaleX = bound.width / newSize.width;
	float scaleY = bound.height / newSize.height;
	
	newScale = fmaxf( scaleX, scaleY );
	
	newSize.width *= newScale;
	newSize.height *= newScale;
	newSize.width = FLOORF( newSize.width );
	newSize.height = FLOORF( newSize.height );
	
	return newSize;
}

CGRect AspectFillRect( CGRect rect, CGRect bound )
{
	CGSize newSize = AspectFillSize( rect.size, bound.size );
	newSize.width = FLOORF( newSize.width );
	newSize.height = FLOORF( newSize.height );
	
	CGRect newRect;
	newRect.origin.x = (bound.size.width - newSize.width) / 2;
	newRect.origin.y = (bound.size.height - newSize.height) / 2;
	newRect.size.width = newSize.width;
	newRect.size.height = newSize.height;
	
	return newRect;
}

CGRect CGRectFromString( NSString * str )
{
	CGRect rect = CGRectZero;
	
	NSArray * array = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ( array && array.count == 4 )
	{
		NSString *	x = [array objectAtIndex:0];
		NSString *	y = [array objectAtIndex:1];
		NSString *	w = [array objectAtIndex:2];
		NSString *	h = [array objectAtIndex:3];
		
		rect.origin.x = x.floatValue;
		rect.origin.y = y.floatValue;
		rect.size.width = w.floatValue;
		rect.size.height = h.floatValue;
	}
	
	return rect;
}

CGPoint CGPointZeroNan( CGPoint point )
{
	point.x = isnan( point.x ) ? 0.0f : point.x;
	point.y = isnan( point.y ) ? 0.0f : point.y;
	return point;
}

CGSize CGSizeZeroNan( CGSize size )
{
	size.width = isnan( size.width ) ? 0.0f : size.width;
	size.height = isnan( size.height ) ? 0.0f : size.height;
	return size;
}

CGRect CGRectZeroNan( CGRect rect )
{
	rect.origin = CGPointZeroNan( rect.origin );
	rect.size = CGSizeZeroNan( rect.size );
	return rect;
}

CGRect CGRectNormalize( CGRect rect )
{
	CGRect newRect;
	newRect.origin.x = ceilf(rect.origin.x);
	newRect.origin.y = ceilf(rect.origin.y);
	newRect.size.width = ceilf(rect.size.width);
	newRect.size.height = ceilf(rect.size.height);
	return newRect;
}

CGRect CGRectMakeBound( CGFloat w, CGFloat h )
{
	CGRect rect;
	rect.origin = CGPointZero;
	rect.size.width = w;
	rect.size.height = h;
	return rect;
}

CGRect CGRectAlignX( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = CGRectGetMidX( rect2 ) - rect1.size.width / 2.0f;
	return rect1;
}

CGRect CGRectAlignY( CGRect rect1, CGRect rect2 )
{
	rect1.origin.y = CGRectGetMidY( rect2 ) - rect1.size.height / 2.0f;
	return rect1;
}

CGRect CGRectAlignCenter( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = CGRectGetMidX( rect2 ) - rect1.size.width / 2.0f;
	rect1.origin.y = CGRectGetMidY( rect2 ) - rect1.size.height / 2.0f;
	return rect1;
}

CGRect CGRectAlignTop( CGRect rect1, CGRect rect2 )
{
	rect1.origin.y = rect2.origin.y;
	return rect1;
}

CGRect CGRectAlignBottom( CGRect rect1, CGRect rect2 )
{
	rect1.origin.y = CGRectGetMaxY( rect2 ) - rect1.size.height;
	return rect1;
}

CGRect CGRectAlignLeft( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = rect2.origin.x;
	return rect1;
}

CGRect CGRectAlignRight( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = CGRectGetMaxX( rect2 ) - rect1.size.width;
	return rect1;
}

CGRect CGRectAlignLeftTop( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = rect2.origin.x;
	rect1.origin.y = rect2.origin.y;
	return rect1;
}

CGRect CGRectAlignLeftBottom( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = rect2.origin.x;
	rect1.origin.y = CGRectGetMaxY( rect2 ) - rect1.size.height;
	return rect1;
}

CGRect CGRectAlignRightTop( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = CGRectGetMaxX( rect2 ) - rect1.size.width;
	rect1.origin.y = rect2.origin.y;
	return rect1;
}

CGRect CGRectAlignRightBottom( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = CGRectGetMaxX( rect2 ) - rect1.size.width;
	rect1.origin.y = CGRectGetMaxY( rect2 ) - rect1.size.height;
	return rect1;
}

CGRect CGRectCloseToTop( CGRect rect1, CGRect rect2 )
{
	rect1.origin.y = CGRectGetMaxY( rect2 );
	return rect1;
}

CGRect CGRectCloseToBottom( CGRect rect1, CGRect rect2 )
{
	rect1.origin.y = rect2.origin.y - rect1.size.height;
	return rect1;
}

CGRect CGRectCloseToLeft( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = CGRectGetMaxX( rect2 );
	return rect1;
}

CGRect CGRectCloseToRight( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = rect2.origin.x - rect1.size.width;
	return rect1;
}

CGRect CGRectReduceWidth( CGRect rect, CGFloat pixels )
{
	CGRect temp = rect;
	temp.size.width = (temp.size.width > pixels) ? (temp.size.width - pixels) : 0.0f;
	return temp;
}

CGRect CGRectReduceHeight( CGRect rect, CGFloat pixels )
{
	CGRect temp = rect;
	temp.size.height = (temp.size.height > pixels) ? (temp.size.height - pixels) : 0.0f;
	return temp;
}

CGRect CGRectMoveCenter( CGRect rect1, CGPoint offset )
{
	rect1.origin.x = offset.x - rect1.size.width / 2.0f;
	rect1.origin.y = offset.y - rect1.size.height / 2.0f;
	return rect1;
}

CGRect CGSizeMakeBound( CGSize size )
{
	CGRect rect;
	rect.origin = CGPointZero;
	rect.size = size;
	return rect;
}

CGRect CGRectToBound( CGRect frame )
{
	CGRect rect;
	rect.origin = CGPointZero;
	rect.size = frame.size;
	return rect;
}

CGSize CGRectGetDistance( CGRect rect1, CGRect rect2 )
{
    CGSize size;
    size.width = rect2.origin.x - rect1.origin.x;
    size.height = rect2.origin.y - rect1.origin.y;
    return size;
}

#pragma mark -

CGSize CGSizeFromStringEx( NSString * text )
{
    NSArray * segments = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ( segments.count == 2 )
	{
		CGFloat w = [[segments objectAtIndex:0] floatValue];
		CGFloat h = [[segments objectAtIndex:1] floatValue];
		
		return CGSizeMake( w, h );
	}
	else if ( segments.count == 1 )
	{
		CGFloat w = [[segments objectAtIndex:0] floatValue];
		CGFloat h = w;
		
		return CGSizeMake( w, h );
	}
	else
	{
		return CGSizeMake( 0, 0 );
	}
}

UIEdgeInsets UIEdgeInsetsFromStringEx( NSString * text )
{
	UIEdgeInsets insets = UIEdgeInsetsZero;
	
	text = text.trim.unwrap;
	if ( [text hasPrefix:@"{"] )
	{
		insets = UIEdgeInsetsFromString( text );
	}
	else
	{
		NSArray * array = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ( 1 == array.count )
		{
			CGFloat value = [[array objectAtIndex:0] floatValue];
			insets = UIEdgeInsetsMake( value, value, value, value );
		}
		else if ( 2 == array.count )
		{
			CGFloat value1 = [[array objectAtIndex:0] floatValue];
			CGFloat value2 = [[array objectAtIndex:1] floatValue];
			
			insets = UIEdgeInsetsMake( value1, value2, value1, value2 );
		}
		else if ( 4 == array.count )
		{
			CGFloat t = [[array objectAtIndex:0] floatValue];
			CGFloat r = [[array objectAtIndex:1] floatValue];
			CGFloat b = [[array objectAtIndex:2] floatValue];
			CGFloat l = [[array objectAtIndex:3] floatValue];
			
			insets = UIEdgeInsetsMake( t, l, b, r );
		}
	}
	
	return insets;
}

UIViewContentMode UIViewContentModeFromString( NSString * contentMode )
{
	if ( nil == contentMode )
		return UIViewContentModeCenter;
	
	BOOL flag;
	
	flag = [contentMode matchAnyOf:@[@"scale"]];
	if ( flag )
	{
		return UIViewContentModeScaleToFill;
	}
	
	flag = [contentMode matchAnyOf:@[@"fit"]];
	if ( flag )
	{
		return UIViewContentModeScaleAspectFit;
	}
	
	flag = [contentMode matchAnyOf:@[@"fill"]];
	if ( flag )
	{
		return UIViewContentModeScaleAspectFill;
	}
	
	flag = [contentMode matchAnyOf:@[@"c", @"center"]];
	if ( flag )
	{
		return UIViewContentModeCenter;
	}
	
	flag = [contentMode matchAnyOf:@[@"t", @"top"]];
	if ( flag )
	{
		return UIViewContentModeTop;
	}
	
	flag = [contentMode matchAnyOf:@[@"b", @"bottom"]];
	if ( flag )
	{
		return UIViewContentModeBottom;
	}
	
	flag = [contentMode matchAnyOf:@[@"l", @"left"]];
	if ( flag )
	{
		return UIViewContentModeLeft;
	}
	
	flag = [contentMode matchAnyOf:@[@"r", @"right"]];
	if ( flag )
	{
		return UIViewContentModeRight;
	}
	
	flag = [contentMode matchAnyOf:@[@"tl", @"top-left", @"lt", @"left-top"]];
	if ( flag )
	{
		return UIViewContentModeTopLeft;
	}
	
	flag = [contentMode matchAnyOf:@[@"tr", @"top-right", @"rt", @"right-top"]];
	if ( flag )
	{
		return UIViewContentModeTopRight;
	}
	
	flag = [contentMode matchAnyOf:@[@"bl", @"bottom-left", @"lb", @"left-bottom"]];
	if ( flag )
	{
		return UIViewContentModeBottomLeft;
	}
	
	flag = [contentMode matchAnyOf:@[@"br", @"bottom-right", @"rb", @"right-bottom"]];
	if ( flag )
	{
		return UIViewContentModeBottomRight;
	}
	
	return UIViewContentModeCenter;
}

UITextAlignment UITextAlignmentFromString( NSString * text )
{
	if ( text && text.length )
	{
		if ( [text matchAnyOf:@[@"l", @"left"]] )
		{
			return UITextAlignmentLeft;
		}
		else if ( [text matchAnyOf:@[@"r", @"right"]] )
		{
			return UITextAlignmentRight;
		}
		else if ( [text matchAnyOf:@[@"c", @"center"]] )
		{
			return UITextAlignmentCenter;
		}
	}

	return UITextAlignmentLeft;
}

UILineBreakMode UILineBreakModeFromString( NSString * text )
{
	if ( text && text.length )
	{
		if ( [text matchAnyOf:@[@"word-wrap"]] )
		{
			return UILineBreakModeWordWrap;
		}
		else if ( [text matchAnyOf:@[@"char-wrap"]] )
		{
			return UILineBreakModeCharacterWrap;
		}
		else if ( [text matchAnyOf:@[@"clip"]] )
		{
			return UILineBreakModeClip;
		}
		else if ( [text matchAnyOf:@[@"head-trunc", @"head-trunk", @"head"]] )
		{
			return UILineBreakModeHeadTruncation;
		}
		else if ( [text matchAnyOf:@[@"tail-trunc", @"tail-trunk", @"tail", @"..."]] )
		{
			return UILineBreakModeTailTruncation;
		}
		else if ( [text matchAnyOf:@[@"mid-trunc", @"mid-trunk", @"mid"]] )
		{
			return UILineBreakModeMiddleTruncation;
		}
	}
	
	return UILineBreakModeClip;
}

UIBaselineAdjustment UIBaselineAdjustmentFromString( NSString * text )
{
	if ( text && text.length )
	{
		if ( [text matchAnyOf:@[@"c", @"center"]] )
		{
			return UIBaselineAdjustmentAlignCenters;
		}
		else if ( [text matchAnyOf:@[@"t", @"top"]] )
		{
			return UIBaselineAdjustmentAlignBaselines;
		}
		else if ( [text matchAnyOf:@[@"b", @"bottom"]] )
		{
			return UIBaselineAdjustmentNone;
		}
	}

	return UIBaselineAdjustmentAlignCenters;
}

UIControlContentHorizontalAlignment UIControlContentHorizontalAlignmentFromString( NSString * text )
{
    if ( text && text.length )
	{
		if ( [text matchAnyOf:@[@"c", @"center"]] )
		{
			return UIControlContentHorizontalAlignmentCenter;
		}
		else if ( [text matchAnyOf:@[@"l", @"left"]] )
		{
			return UIControlContentHorizontalAlignmentLeft;
		}
		else if ( [text matchAnyOf:@[@"r", @"right"]] )
		{
			return UIControlContentHorizontalAlignmentRight;
		}
		else if ( [text matchAnyOf:@[@"fill"]] )
		{
			return UIControlContentHorizontalAlignmentFill;
		}
	}
	
	return UIControlContentHorizontalAlignmentCenter;
}

UIControlContentVerticalAlignment UIControlContentVerticalAlignmentFromString( NSString * text )
{
    if ( text && text.length )
	{
		if ( [text matchAnyOf:@[@"c", @"center"]] )
		{
			return UIControlContentVerticalAlignmentCenter;
		}
		else if ( [text matchAnyOf:@[@"t", @"top"]] )
		{
			return UIControlContentVerticalAlignmentTop;
		}
		else if ( [text matchAnyOf:@[@"b", @"bottom"]] )
		{
			return UIControlContentVerticalAlignmentBottom;
		}
		else if ( [text matchAnyOf:@[@"fill"]] )
		{
			return UIControlContentVerticalAlignmentFill;
		}
	}
	
	return UIControlContentVerticalAlignmentCenter;
}

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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
//  UIView+BeeExtension.m
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Bee_UIRect.h"

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

CGSize AspectFitSize( CGSize size, CGSize bound )
{
	CGSize newSize = size;
	CGFloat newScale = 1.0f;
	
	float scaleX = bound.width / newSize.width;
	float scaleY = bound.height / newSize.height;	

	newScale = fminf( scaleX, scaleY );
	
	newSize.width *= newScale;
	newSize.height *= newScale;
	
	newSize.width = floorf( newSize.width );
	newSize.height = floorf( newSize.height );
	
	return newSize;
}

CGRect AspectFitRect( CGRect rect, CGRect bound )
{
	CGSize newSize = AspectFitSize( rect.size, bound.size );
	newSize.width = floorf( newSize.width );
	newSize.height = floorf( newSize.height );
	
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
	newSize.width = floorf( newSize.width );
	newSize.height = floorf( newSize.height );
	
	return newSize;
}

CGRect AspectFillRect( CGRect rect, CGRect bound )
{
	CGSize newSize = AspectFillSize( rect.size, bound.size );
	newSize.width = floorf( newSize.width );
	newSize.height = floorf( newSize.height );
	
	CGRect newRect;	
	newRect.origin.x = (bound.size.width - newSize.width) / 2;
	newRect.origin.y = (bound.size.height - newSize.height) / 2;
	newRect.size.width = newSize.width;
	newRect.size.height = newSize.height;
	
	return newRect;
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

CGRect CGRectMakeBound( CGFloat w, CGFloat h )
{
	CGRect rect;
	rect.origin = CGPointZero;
	rect.size.width = w;
	rect.size.height = h;
	return rect;
}

CGRect CGSizeMakeBound( CGSize size )
{
	CGRect rect;
	rect.origin = CGPointZero;
	rect.size = size;
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

CGRect	CGRectCloseToRight( CGRect rect1, CGRect rect2 )
{
	rect1.origin.x = rect2.origin.x - rect1.size.width;
	return rect1;
}

CGRect CGRectMoveCenter( CGRect rect1, CGPoint offset )
{
	rect1.origin.x = offset.x - rect1.size.width / 2.0f;
	rect1.origin.y = offset.y - rect1.size.height / 2.0f;
	return rect1;
}

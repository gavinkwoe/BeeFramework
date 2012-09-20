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
//  Bee_UIRect.h
//

#pragma mark -

CGSize	AspectFitSizeByWidth( CGSize size, CGFloat width );
CGSize	AspectFitSizeByHeight( CGSize size, CGFloat height );

CGSize	AspectFitSize( CGSize size, CGSize bound );
CGRect	AspectFitRect( CGRect rect, CGRect bound );

CGSize	AspectFillSize( CGSize size, CGSize bound );
CGRect	AspectFillRect( CGRect rect, CGRect bound );

CGPoint	CGPointZeroNan( CGPoint point );
CGSize	CGSizeZeroNan( CGSize size );
CGRect	CGRectZeroNan( CGRect rect );

CGRect	CGRectAlignX( CGRect rect1, CGRect rect2 );				// rect1向rect2的X轴中心点对齐
CGRect	CGRectAlignY( CGRect rect1, CGRect rect2 );				// rect1向rect2的Y轴中心点对齐
CGRect	CGRectAlignCenter( CGRect rect1, CGRect rect2 );		// rect1向rect2的中心点对齐

CGRect	CGRectAlignTop( CGRect rect1, CGRect rect2 );			// 右边缘对齐
CGRect	CGRectAlignBottom( CGRect rect1, CGRect rect2 );		// 下边缘对齐
CGRect	CGRectAlignLeft( CGRect rect1, CGRect rect2 );			// 左边缘对齐
CGRect	CGRectAlignRight( CGRect rect1, CGRect rect2 );			// 上边缘对齐

CGRect	CGRectAlignLeftTop( CGRect rect1, CGRect rect2 );		// 右边缘对齐
CGRect	CGRectAlignLeftBottom( CGRect rect1, CGRect rect2 );	// 下边缘对齐
CGRect	CGRectAlignRightTop( CGRect rect1, CGRect rect2 );		// 右边缘对齐
CGRect	CGRectAlignRightBottom( CGRect rect1, CGRect rect2 );	// 下边缘对齐

CGRect	CGRectCloseToTop( CGRect rect1, CGRect rect2 );			// 与上边缘靠近
CGRect	CGRectCloseToBottom( CGRect rect1, CGRect rect2 );		// 与下边缘靠近
CGRect	CGRectCloseToLeft( CGRect rect1, CGRect rect2 );		// 与左边缘靠近
CGRect	CGRectCloseToRight( CGRect rect1, CGRect rect2 );		// 与右边缘靠近

CGRect	CGRectMoveCenter( CGRect rect1, CGPoint offset );		// 移动中心点
CGRect	CGRectMakeBound( CGFloat w, CGFloat h );

CGRect	CGSizeMakeBound( CGSize size );

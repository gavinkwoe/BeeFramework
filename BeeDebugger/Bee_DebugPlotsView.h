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
//  Bee_DebugPlotsView.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#pragma mark -

@interface BeeDebugPlotsView : UIView
{
	BOOL		_fill;
	BOOL		_border;
	CGFloat		_lineScale;
	UIColor *	_lineColor;
	CGFloat		_lineWidth;
	CGFloat		_lowerBound;
	CGFloat		_upperBound;
	NSUInteger	_capacity;
	NSArray *	_plots;
}

@property (nonatomic, assign) BOOL			fill;
@property (nonatomic, assign) BOOL			border;
@property (nonatomic, assign) CGFloat		lineScale;
@property (nonatomic, retain) UIColor *		lineColor;
@property (nonatomic, assign) CGFloat		lineWidth;
@property (nonatomic, assign) CGFloat		lowerBound;
@property (nonatomic, assign) CGFloat		upperBound;
@property (nonatomic, assign) NSUInteger	capacity;
@property (nonatomic, retain) NSArray *		plots;

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

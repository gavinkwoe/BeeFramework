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
//  Bee_DebugHeatmapModel.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#pragma mark -

@interface BeeDebugHeatmapModel : BeeModel
{
	NSUInteger				_rowCount;
	NSUInteger				_colCount;
	NSUInteger				_peakValueTap;
	NSUInteger				_peakValueDrag;
	NSUInteger *			_heatmapTap;
	NSUInteger *			_heatmapDrag;
}

@property (nonatomic, readonly) NSUInteger			rowCount;
@property (nonatomic, readonly) NSUInteger			colCount;
@property (nonatomic, readonly) NSUInteger			peakValueTap;
@property (nonatomic, readonly) NSUInteger			peakValueDrag;
@property (nonatomic, readonly) NSUInteger *		heatmapTap;
@property (nonatomic, readonly) NSUInteger *		heatmapDrag;

AS_SINGLETON( BeeDebugHeatmapModel )

- (void)recordTapAtLocation:(CGPoint)location;
- (void)recordDragAtLocation:(CGPoint)location;

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

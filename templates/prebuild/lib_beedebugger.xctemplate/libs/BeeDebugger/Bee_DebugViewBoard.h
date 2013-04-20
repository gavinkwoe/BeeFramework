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
//  Bee_DebugViewBoard.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugPlotsView.h"
#import "Bee_DebugSampleView.h"
#import "Bee_DebugDetailView.h"
#import "Bee_UITableBoard.h"

#pragma mark -

@interface BeeDebugViewDetailView : BeeDebugTextView
- (void)setBoard:(BeeUIBoard *)board;
@end

#pragma mark -

@interface BeeDebugViewCell : BeeUIGridCell
{
	BeeUILabel *		_timeLabel;
	BeeUILabel *		_nameLabel;
	BeeUILabel *		_countLabel;
	BeeUILabel *		_statusLabel;
	BeeDebugPlotsView *	_plotView;
}
@end

#pragma mark -

@interface BeeDebugViewBoard : BeeUITableBoard
AS_SINGLETON( BeeDebugViewBoard )
@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

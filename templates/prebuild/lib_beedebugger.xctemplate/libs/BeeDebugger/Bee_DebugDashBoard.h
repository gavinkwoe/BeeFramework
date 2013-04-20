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
//  Bee_DebugDashBoard.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugPlotsView.h"

#pragma mark -

@interface BeeDebugMemoryView : UIView
{
	BeeUILabel *			_titleView;
	BeeUILabel *			_statusView;
	BeeDebugPlotsView *		_plotView1;
	BeeDebugPlotsView *		_plotView2;
	BeeUIButton *			_manualAlloc;
	BeeUIButton *			_manualFree;
	BeeUIButton *			_manualAllocAll;
	BeeUIButton *			_manualFreeAll;
	BeeUIButton *			_autoWarning;
}

- (void)update;

@end

#pragma mark -

@interface BeeDebugMessageView : UIView
{
	BeeUILabel *			_titleView;
	BeeUILabel *			_statusView;
	BeeDebugPlotsView *		_plotView1;	// sending
	BeeDebugPlotsView *		_plotView2;	// succeed
	BeeDebugPlotsView *		_plotView3;	// failed
	BeeUIButton *			_cancelAll;
	BeeUIButton *			_freezeAll;
}

- (void)update;

@end

#pragma mark -

@interface BeeDebugNetworkView : UIView
{
	BeeUILabel *			_titleView;
	BeeUILabel *			_statusView;
	BeeDebugPlotsView *		_plotView1;	// send bytes
	BeeDebugPlotsView *		_plotView2;	// recv bytes
	BeeUIButton *			_delayPlus;
	BeeUIButton *			_delaySub;
	BeeUIButton *			_bandWidth;
	BeeUIButton *			_switchOnline;
}

- (void)update;

@end

#pragma mark -

@interface BeeDebugDashBoard : BeeUIBoard
{
	BeeDebugMemoryView *	_memoryView;
	BeeDebugMessageView *	_messageView;
	BeeDebugNetworkView *	_networkView;
}

AS_SINGLETON( BeeDebugDashBoard )

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

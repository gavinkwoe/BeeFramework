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
//  Bee_DebugMessageModel.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#pragma mark -

#undef	MAX_MESSAGE_HISTORY
#define MAX_MESSAGE_HISTORY	(50)

#pragma mark -

@interface BeeDebugMessageModel : BeeModel
{
	NSUInteger				_sendingCount;
	NSUInteger				_succeedCount;
	NSUInteger				_failedCount;
	NSUInteger				_upperBound;

	NSMutableArray *		_sendingPlots;
	NSMutableArray *		_succeedPlots;
	NSMutableArray *		_failedPlots;
	
	NSMutableArray *		_history;
}

@property (nonatomic, readonly) NSUInteger			sendingCount;
@property (nonatomic, readonly) NSUInteger			succeedCount;
@property (nonatomic, readonly) NSUInteger			failedCount;
@property (nonatomic, readonly) NSUInteger			upperBound;

@property (nonatomic, readonly) NSMutableArray *	sendingPlots;
@property (nonatomic, readonly) NSMutableArray *	succeedPlots;
@property (nonatomic, readonly) NSMutableArray *	failedPlots;

@property (nonatomic, readonly) NSMutableArray *	history;

AS_SINGLETON( BeeDebugMessageModel )

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

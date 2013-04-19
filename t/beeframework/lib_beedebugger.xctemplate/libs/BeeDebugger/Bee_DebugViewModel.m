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
//  Bee_DebugMemoryBoard.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugViewModel.h"
#import "Bee_DebugUtility.h"
#import "Bee_UIBoard.h"

#pragma mark -

@implementation BeeDebugViewModel

@synthesize lowerBound = _lowerBound;
@synthesize upperBound = _upperBound;
@synthesize chartDatas = _chartDatas;

DEF_SINGLETON( BeeDebugViewModel )

- (void)load
{
	[super load];
	
	_chartDatas = [[NSMutableDictionary alloc] init];

	_lastTimestamp = [NSDate timeIntervalSinceReferenceDate];
	_lowerBound = 0;
	_upperBound = 1;

	[self observeTick];
}

- (void)unload
{
	[self unobserveTick];
	
	[_chartDatas removeAllObjects];
	[_chartDatas release];
	
	[super unload];
}

- (NSArray *)plotsForBoard:(BeeUIBoard *)board
{
	NSString * key = [NSString stringWithFormat:@"%p", board];
	return (NSArray *)[_chartDatas objectForKey:key];
}

- (void)handleTick:(NSTimeInterval)elapsed
{
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
//	_lowerBound = _upperBound;
	_upperBound = 1;

	NSArray * array = [BeeUIBoard allBoards];
	
	for ( BeeUIBoard * board in array )
	{
		NSString * key = [NSString stringWithFormat:@"%p", board];
		NSMutableArray * plots = (NSMutableArray *)[_chartDatas objectForKey:key];
		if ( nil == plots )
		{
			plots = [[NSMutableArray alloc] init];
			[_chartDatas setObject:plots forKey:key];
			[plots release];
		}
		
		NSUInteger signalCount = 0;
		for ( BeeUISignal * signal in board.signals )
		{
			if ( signal.initTimeStamp >= _lastTimestamp )
			{
				signalCount += 1;
			}
		}

		[plots addObject:__INT(signalCount)];
		[plots keepTail:MAX_SIGNAL_HISTORY];
	}
	
	_lowerBound = 0;
	_upperBound = 1;
	
	for ( NSString * key in _chartDatas.allKeys )
	{
		NSArray * array = [_chartDatas objectForKey:key];
		for ( NSNumber * n in array )
		{
			if ( n.intValue > _upperBound )
			{
				_upperBound = n.intValue;
				if ( _upperBound < _lowerBound )
				{
					_lowerBound = _upperBound;
				}
			}
			else if ( n.intValue < _lowerBound )
			{
				_lowerBound = n.intValue;
			}
		}
	}

	_lastTimestamp = [NSDate timeIntervalSinceReferenceDate];
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
}

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

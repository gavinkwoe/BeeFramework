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

#import "ServiceDebugger_MessageModel.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@interface ServiceDebugger_MessageModel()
{
	NSUInteger				_sendingCount;
	NSUInteger				_succeedCount;
	NSUInteger				_failedCount;
	NSUInteger				_totalCount;
	NSUInteger				_upperBound;
	
	NSMutableArray *		_sendingPlots;
	NSMutableArray *		_succeedPlots;
	NSMutableArray *		_failedPlots;
	
	NSMutableArray *		_history;
}
@end

#pragma mark -

@implementation ServiceDebugger_MessageModel

@synthesize sendingCount = _sendingCount;
@synthesize succeedCount = _succeedCount;
@synthesize failedCount = _failedCount;
@synthesize totalCount = _totalCount;
@synthesize upperBound = _upperBound;
@synthesize sendingPlots = _sendingPlots;
@synthesize succeedPlots = _succeedPlots;
@synthesize failedPlots = _failedPlots;
@synthesize history = _history;

DEF_SINGLETON( ServiceDebugger_MessageModel )

- (void)load
{
//	[super load];

	_sendingCount = 0;
	_succeedCount = 0;
	_failedCount = 0;
	
	_upperBound = 4;

	_sendingPlots = [[NSMutableArray alloc] init];
	[_sendingPlots addObject:[NSNumber numberWithInt:0]];
	
	_succeedPlots = [[NSMutableArray alloc] init];
	[_succeedPlots addObject:[NSNumber numberWithInt:0]];
	
	_failedPlots = [[NSMutableArray alloc] init];
	[_failedPlots addObject:[NSNumber numberWithInt:0]];

	_history = [[NSMutableArray alloc] init];

	[BeeMessageQueue sharedInstance].whenCreate = ^( BeeMessage * msg )
	{
		[_history pushHead:msg];
		[_history keepHead:MAX_MESSAGE_HISTORY];
		
		_totalCount += 1;
	};
	
	[BeeMessageQueue sharedInstance].whenUpdate = ^( BeeMessage * msg )
	{
		_sendingCount = [BeeMessageQueue sharedInstance].sendingMessages.count;
		
		if ( msg.succeed )
		{
			_succeedCount += 1;
		}
		else if ( msg.failed )
		{
			_failedCount += 1;
		}
		
		_upperBound = MAX( MAX( MAX( _sendingCount, _succeedCount ), _failedCount ), _upperBound );
	};

	[self observeTick];
}

- (void)unload
{
	[self unobserveTick];

	[_sendingPlots removeAllObjects];
	[_sendingPlots release];
	
	[_succeedPlots removeAllObjects];
	[_succeedPlots release];
	
	[_failedPlots removeAllObjects];
	[_failedPlots release];
	
	[_history removeAllObjects];
	[_history release];
	
//	[super unload];
}

ON_TICK( tick )
{
	[_sendingPlots pushTail:[NSNumber numberWithInt:_sendingCount]];
	[_sendingPlots keepTail:MAX_MESSAGE_HISTORY];

	[_succeedPlots pushTail:[NSNumber numberWithInt:_succeedCount]];
	[_succeedPlots keepTail:MAX_MESSAGE_HISTORY];

	[_failedPlots pushTail:[NSNumber numberWithInt:_failedCount]];
	[_failedPlots keepTail:MAX_MESSAGE_HISTORY];
	
	_succeedCount = 0;
	_failedCount = 0;
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

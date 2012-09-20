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
//  Bee_DebugNetworkModel.m
//

#if __BEE_DEBUGGER__

#import "Bee_DebugNetworkModel.h"

#pragma mark -

@implementation BeeDebugNetworkModel

@synthesize totalCount = _totalCount;
@synthesize sendingCount = _sendingCount;
@synthesize succeedCount = _succeedCount;
@synthesize failedCount = _failedCount;
@synthesize upperBound = _upperBound;
@synthesize sendingPlots = _sendingPlots;
@synthesize succeedPlots = _succeedPlots;
@synthesize failedPlots = _failedPlots;

@synthesize uploadBytes = _uploadBytes;
@synthesize downloadBytes = _downloadBytes;

@synthesize history = _history;
@synthesize bandWidth = _bandWidth;

DEF_SINGLETON( BeeDebugNetworkModel )

- (void)load
{
	[super load];

	_history = [[NSMutableArray alloc] init];

	_sendingCount = 0;
	_succeedCount = 0;
	_failedCount = 0;

	_uploadBytes = 0;
	_downloadBytes = 0;

	_sendingPlots = [[NSMutableArray alloc] init];
	_succeedPlots = [[NSMutableArray alloc] init];
	_failedPlots = [[NSMutableArray alloc] init];

	_upperBound = 0;

	[BeeRequestQueue sharedInstance].whenCreate = ^( BeeRequest * req )
	{
		[_history insertObject:req atIndex:0];
		[_history keepHead:MAX_REQUEST_HISTORY];

		_totalCount += 1;
		_sendingCount = [BeeRequestQueue sharedInstance].requests.count;
		
		_upperBound = MAX( MAX( MAX( _sendingCount, _succeedCount ), _failedCount ), _upperBound );
		_upperBound = _upperBound;
	};
	
	[BeeRequestQueue sharedInstance].whenUpdate = ^( BeeRequest * req )
	{
		_sendingCount = [BeeRequestQueue sharedInstance].requests.count;
		
		if ( req.sending )
		{
			_uploadBytes += [req uploadBytes];
		}
		else if ( req.succeed )
		{
			if ( 200 == req.responseStatusCode )
			{
				_succeedCount += 1;
			}
			else
			{
				_failedCount += 1;
			}

			_downloadBytes += [req downloadBytes];
		}
		else if ( req.failed )
		{
			_failedCount += 1;

			_downloadBytes += [req downloadBytes];
		}
		
		_upperBound = MAX( MAX( MAX( _sendingCount, _succeedCount ), _failedCount ), _upperBound );
		_upperBound = _upperBound;
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
	
	[super unload];
}

- (void)handleTick:(NSTimeInterval)elapsed
{
	[_sendingPlots pushTail:[NSNumber numberWithInt:_sendingCount]];
	[_sendingPlots keepTail:MAX_REQUEST_HISTORY];
	
	[_succeedPlots pushTail:[NSNumber numberWithInt:_succeedCount]];
	[_succeedPlots keepTail:MAX_REQUEST_HISTORY];
	
	[_failedPlots pushTail:[NSNumber numberWithInt:_failedCount]];
	[_failedPlots keepTail:MAX_REQUEST_HISTORY];

	_succeedCount = 0;
	_failedCount = 0;
}

- (void)changeBandWidth:(NSUInteger)bw
{
	if ( bw == _bandWidth )
		return;
	
	_bandWidth = bw;

	if ( BANDWIDTH_CURRENT == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:NO];
		[ASIHTTPRequest setMaxBandwidthPerSecond:0];
	}
	else if ( BANDWIDTH_GPRS == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:YES];
		[ASIHTTPRequest setMaxBandwidthPerSecond:10 * 1024];
	}
	else if ( BANDWIDTH_EDGE == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:YES];
		[ASIHTTPRequest setMaxBandwidthPerSecond:30 * 1024];
	}
	else if ( BANDWIDTH_3G == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:YES];
		[ASIHTTPRequest setMaxBandwidthPerSecond:200 * 1024];
	}
}

@end

#endif	// #if __BEE_DEBUGGER__

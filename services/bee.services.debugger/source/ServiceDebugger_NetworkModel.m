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

#import "ServiceDebugger_NetworkModel.h"
#import "ServiceDebugger_Unit.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@interface ServiceDebugger_NetworkModel()
{
	NSUInteger			_totalCount;
	
	NSUInteger			_sendLowerBound;
	NSUInteger			_sendUpperBound;
	
	NSUInteger			_recvLowerBound;
	NSUInteger			_recvUpperBound;
	
	NSUInteger			_lastUploadBytes;
	NSUInteger			_lastDownloadBytes;
	
	NSUInteger			_uploadBytes;
	NSUInteger			_downloadBytes;
	
	NSMutableArray *	_sendPlots;
	NSMutableArray *	_recvPlots;
	
	NSMutableArray *	_history;
	NSUInteger			_bandWidth;
}
@end

#pragma mark -

@implementation ServiceDebugger_NetworkModel

@synthesize totalCount = _totalCount;
@dynamic concurrent;
@dynamic connections;

@synthesize sendLowerBound = _sendLowerBound;
@synthesize sendUpperBound = _sendUpperBound;
@synthesize recvLowerBound = _recvLowerBound;
@synthesize recvUpperBound = _recvUpperBound;

@synthesize sendPlots = _sendPlots;
@synthesize recvPlots = _recvPlots;

@synthesize uploadBytes = _uploadBytes;
@synthesize downloadBytes = _downloadBytes;

@synthesize history = _history;
@synthesize bandWidth = _bandWidth;

DEF_SINGLETON( ServiceDebugger_NetworkModel )

DEF_INT( BANDWIDTH_CURRENT,	0 )
DEF_INT( BANDWIDTH_GPRS,	1 )
DEF_INT( BANDWIDTH_EDGE,	2 )
DEF_INT( BANDWIDTH_3G,		3 )

- (void)load
{
//	[super load];

	_history = [[NSMutableArray alloc] init];

	_uploadBytes = 0;
	_downloadBytes = 0;

	_sendPlots = [[NSMutableArray alloc] init];
	[_sendPlots pushTail:[NSNumber numberWithInt:0]];

	_recvPlots = [[NSMutableArray alloc] init];
	[_recvPlots pushTail:[NSNumber numberWithInt:0]];

	_sendLowerBound = 0;
	_sendUpperBound = 1 * M;

	_recvLowerBound = 0;
	_recvUpperBound = 1 * M;

	[BeeRequestQueue sharedInstance].whenCreate = ^( BeeRequest * req )
	{
		[_history insertObject:req atIndex:0];
		[_history keepHead:MAX_REQUEST_HISTORY];

		_totalCount = [BeeRequestQueue sharedInstance].requests.count;
	};

	[BeeRequestQueue sharedInstance].whenUpdate = ^( BeeRequest * req )
	{
		if ( req.sending )
		{
			_uploadBytes += [req uploadBytes];
		}
		else if ( req.succeed || req.failed || req.cancelled )
		{
			_downloadBytes += [req downloadBytes];
		}
	};

	[self observeTick];
}

- (void)unload
{
	[self unobserveTick];

	[_sendPlots removeAllObjects];
	[_sendPlots release];
	
	[_recvPlots removeAllObjects];
	[_recvPlots release];
	
	[_history removeAllObjects];
	[_history release];
	
//	[super unload];
}

- (NSUInteger)concurrent
{
	return [BeeRequestQueue sharedInstance].requests.count;
}

- (NSUInteger)connections
{
	NSUInteger conn = 0;
	
	for ( BeeSocket * sock in [BeeSocket sockets] )
	{
		if ( sock.connecting || sock.connected )
		{
			conn += 1;
		}
	}
	
	return conn;
}

ON_TICK( tick )
{
	[_sendPlots pushTail:__INT(_uploadBytes - _lastUploadBytes)];
	[_sendPlots keepTail:MAX_REQUEST_HISTORY];

	for ( NSNumber * n in _sendPlots )
	{
		if ( n.intValue > _sendUpperBound )
		{
			_sendUpperBound = MAX( n.intValue, _recvUpperBound );
			
//			if ( _sendUpperBound < _sendLowerBound )
//			{
//				_sendLowerBound = _sendUpperBound;
//			}
		}
		else if ( n.intValue < _sendLowerBound )
		{
			_sendLowerBound = MIN( n.intValue, _recvLowerBound );
		}
	}

	[_recvPlots pushTail:__INT(_downloadBytes - _lastDownloadBytes)];
	[_recvPlots keepTail:MAX_REQUEST_HISTORY];

	for ( NSNumber * n in _recvPlots )
	{
		if ( n.intValue > _recvUpperBound )
		{
			_recvUpperBound = MAX( n.intValue, _sendUpperBound );
			
//			if ( _recvUpperBound < _recvLowerBound )
//			{
//				_recvLowerBound = _recvUpperBound;
//			}
		}
		else if ( n.intValue < _recvLowerBound )
		{
			_recvLowerBound = MIN( n.intValue, _sendLowerBound );
		}
	}
	
	_lastUploadBytes = _uploadBytes;
	_lastDownloadBytes = _downloadBytes;
}

- (void)changeBandWidth:(NSUInteger)bw
{
	if ( bw == _bandWidth )
		return;
	
	_bandWidth = bw;

	if ( self.BANDWIDTH_CURRENT == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:NO];
		[ASIHTTPRequest setMaxBandwidthPerSecond:0];
	}
	else if ( self.BANDWIDTH_GPRS == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:YES];
		[ASIHTTPRequest setMaxBandwidthPerSecond:10 * 1024];
	}
	else if ( self.BANDWIDTH_EDGE == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:YES];
		[ASIHTTPRequest setMaxBandwidthPerSecond:30 * 1024];
	}
	else if ( self.BANDWIDTH_3G == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:YES];
		[ASIHTTPRequest setMaxBandwidthPerSecond:300 * 1024];
	}
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

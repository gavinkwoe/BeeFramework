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
//  Bee_DebugNetworkModel.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#pragma mark -

#undef	MAX_REQUEST_HISTORY
#define MAX_REQUEST_HISTORY	(50)

#define BANDWIDTH_CURRENT	(0)
#define BANDWIDTH_GPRS		(1)
#define BANDWIDTH_EDGE		(2)
#define BANDWIDTH_3G		(3)

#pragma mark -

@interface BeeDebugNetworkModel : BeeModel
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

@property (nonatomic, readonly) NSUInteger			totalCount;

@property (nonatomic, readonly) NSUInteger			sendLowerBound;
@property (nonatomic, readonly) NSUInteger			sendUpperBound;
@property (nonatomic, readonly) NSUInteger			recvLowerBound;
@property (nonatomic, readonly) NSUInteger			recvUpperBound;

@property (nonatomic, readonly) NSUInteger			uploadBytes;
@property (nonatomic, readonly) NSUInteger			downloadBytes;

@property (nonatomic, readonly) NSMutableArray *	sendPlots;
@property (nonatomic, readonly) NSMutableArray *	recvPlots;

@property (nonatomic, readonly) NSMutableArray *	history;
@property (nonatomic, readonly) NSUInteger			bandWidth;

AS_SINGLETON( BeeDebugNetworkModel )

- (void)changeBandWidth:(NSUInteger)bw;

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

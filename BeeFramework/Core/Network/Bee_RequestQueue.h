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
//  Bee_Network.h
//

#import "Bee_Precompile.h"
#import "Bee_Singleton.h"
#import "Bee_Request.h"

#pragma mark -

@interface BeeRequestQueue : NSObject<ASIHTTPRequestDelegate>
{
	BOOL					_merge;
	BOOL					_online;

	BOOL					_blackListEnable;
	NSTimeInterval			_blackListTimeout;
	NSMutableDictionary *	_blackList;

	NSUInteger				_bytesUpload;
	NSUInteger				_bytesDownload;
	
	NSTimeInterval			_delay;
	NSMutableArray *		_requests;

	BeeRequestBlock			_whenCreate;
	BeeRequestBlock			_whenUpdate;
}

@property (nonatomic, assign) BOOL						merge;
@property (nonatomic, assign) BOOL						online;				// 开网/断网

@property (nonatomic, assign) BOOL						blackListEnable;	// 是否使用黑名单
@property (nonatomic, assign) NSTimeInterval			blackListTimeout;	// 黑名单超时
@property (nonatomic, retain) NSMutableDictionary *		blackList;

@property (nonatomic, assign) NSUInteger				bytesUpload;
@property (nonatomic, assign) NSUInteger				bytesDownload;

@property (nonatomic, assign) NSTimeInterval			delay;
@property (nonatomic, retain) NSMutableArray *			requests;

@property (nonatomic, copy) BeeRequestBlock				whenCreate;
@property (nonatomic, copy) BeeRequestBlock				whenUpdate;

+ (BeeRequestQueue *)sharedInstance;

+ (BOOL)isReachableViaWIFI;
+ (BOOL)isReachableViaWLAN;
+ (BOOL)isNetworkInUse;
+ (NSUInteger)bandwidthUsedPerSecond;

+ (BeeRequest *)GET:(NSString *)url;
+ (BeeRequest *)POST:(NSString *)url;
+ (BeeRequest *)PUT:(NSString *)url;

+ (BOOL)requesting:(NSString *)url;
+ (BOOL)requesting:(NSString *)url byResponder:(id)responder;

+ (NSArray *)requests:(NSString *)url;
+ (NSArray *)requests:(NSString *)url byResponder:(id)responder;

+ (void)cancelRequest:(BeeRequest *)request;
+ (void)cancelRequestByResponder:(id)responder;
+ (void)cancelAllRequests;

+ (void)blockURL:(NSString *)url;
+ (void)unblockURL:(NSString *)url;

@end


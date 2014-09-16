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

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"

#pragma mark -

@class ASIFormDataRequest;
@class BeeHTTPRequest;

#pragma mark -

@interface NSObject(BeeHTTPRequest)
- (BOOL)isRequestResponder;
- (BOOL)prehandleRequest:(BeeHTTPRequest *)request;
- (void)handleRequest:(BeeHTTPRequest *)request;
- (void)posthandleRequest:(BeeHTTPRequest *)request;
@end

#pragma mark -

#undef	BEFORE_REQUEST
#define BEFORE_REQUEST( __req ) \
		- (void)prehandleRequest:(BeeHTTPRequest *)__req

#undef	AFTER_REQUEST
#define AFTER_REQUEST( __req ) \
		- (void)posthandleRequest:(BeeHTTPRequest *)__req

#undef	ON_REQUEST
#define ON_REQUEST( __req ) \
		- (void)handleRequest:(BeeHTTPRequest *)__req

#undef	ON_HTTP_REQUEST
#define ON_HTTP_REQUEST( __req ) \
		- (void)handleRequest:(BeeHTTPRequest *)__req

@compatibility_alias BeeRequest BeeHTTPRequest;

typedef void				(^BeeHTTPRequestBlock)( void );
typedef BeeHTTPRequest *	(^BeeHTTPRequestBlockV)( void );
typedef BeeHTTPRequest *	(^BeeHTTPRequestBlockB)( BOOL flag );
typedef BeeHTTPRequest *	(^BeeHTTPRequestBlockT)( NSTimeInterval interval );
typedef BeeHTTPRequest *	(^BeeHTTPRequestBlockN)( id key, ... );
typedef BeeHTTPRequest *	(^BeeHTTPRequestBlockS)( NSString * string );
typedef BeeHTTPRequest *	(^BeeHTTPRequestBlockSN)( NSString * string, ... );
typedef BOOL				(^BeeHTTPBoolBlockS)( NSString * url );
typedef BOOL				(^BeeHTTPBoolBlockV)( void );

#pragma mark -

@interface BeeHTTPRequest : ASIFormDataRequest

AS_INT( STATE_CREATED );
AS_INT( STATE_SENDING );
AS_INT( STATE_RECVING );
AS_INT( STATE_FAILED );
AS_INT( STATE_SUCCEED );
AS_INT( STATE_CANCELLED );
AS_INT( STATE_REDIRECTED );

@property (nonatomic, readonly) BeeHTTPRequestBlockN	HEADER;				// directly set header
@property (nonatomic, readonly) BeeHTTPRequestBlockN	BODY;				// directly set body
@property (nonatomic, readonly) BeeHTTPRequestBlockN	PARAM;				// add key value
@property (nonatomic, readonly) BeeHTTPRequestBlockN    PARAMS;				// add keys values
@property (nonatomic, readonly) BeeHTTPRequestBlockN	FILE;				// add file data
@property (nonatomic, readonly) BeeHTTPRequestBlockN	FILE_ALIAS;
@property (nonatomic, readonly) BeeHTTPRequestBlockN	FILE_MP4;			// add jpeg file
@property (nonatomic, readonly) BeeHTTPRequestBlockN	FILE_MP4_ALIAS;		// add jpeg file
@property (nonatomic, readonly) BeeHTTPRequestBlockN	FILE_PNG;			// add png file
@property (nonatomic, readonly) BeeHTTPRequestBlockN	FILE_PNG_ALIAS;		// add png file
@property (nonatomic, readonly) BeeHTTPRequestBlockN	FILE_JPG;			// add jpeg file
@property (nonatomic, readonly) BeeHTTPRequestBlockN	FILE_JPG_ALIAS;		// add jpeg file
@property (nonatomic, readonly) BeeHTTPRequestBlockT	TIMEOUT;			// add file data
@property (nonatomic, readonly) BeeHTTPRequestBlockS	SAVE_AS;			// save the response data into a file
@property (nonatomic, readonly) BeeHTTPRequestBlockB	SHOULD_COMPRESS;	// save the response data into a file
@property (nonatomic, readonly) BeeHTTPRequestBlockB	SHOULD_DECOMPRESS;	// save the response data into a file

@property (nonatomic, assign) NSUInteger				state;
@property (nonatomic, retain) NSMutableArray *			responders;
//@property (nonatomic, assign) id						responder;

@property (nonatomic, assign) NSInteger					errorCode;
@property (nonatomic, retain) NSMutableDictionary *		userInfo;
@property (nonatomic, retain) NSObject *				userObject;

@property (nonatomic, copy) BeeHTTPRequestBlock			whenUpdate;
@property (nonatomic, copy) BeeHTTPRequestBlock			whenSending;
@property (nonatomic, copy) BeeHTTPRequestBlock			whenSendProgressed;
@property (nonatomic, copy) BeeHTTPRequestBlock			whenRecving;
@property (nonatomic, copy) BeeHTTPRequestBlock			whenRecvProgressed;
@property (nonatomic, copy) BeeHTTPRequestBlock			whenFailed;
@property (nonatomic, copy) BeeHTTPRequestBlock			whenSucceed;
@property (nonatomic, copy) BeeHTTPRequestBlock			whenCancelled;
@property (nonatomic, copy) BeeHTTPRequestBlock			whenRedirected;

@property (nonatomic, assign) NSTimeInterval			initTimeStamp;
@property (nonatomic, assign) NSTimeInterval			sendTimeStamp;
@property (nonatomic, assign) NSTimeInterval			recvTimeStamp;
@property (nonatomic, assign) NSTimeInterval			doneTimeStamp;

@property (nonatomic, readonly) NSTimeInterval			timeCostPending;	// 排队等待耗时
@property (nonatomic, readonly) NSTimeInterval			timeCostOverDNS;	// 网络连接耗时（DNS）
@property (nonatomic, readonly) NSTimeInterval			timeCostRecving;	// 网络收包耗时
@property (nonatomic, readonly) NSTimeInterval			timeCostOverAir;	// 网络整体耗时

#if __BEE_DEVELOPMENT__
@property (nonatomic, readonly) NSMutableArray *		callstack;
#endif	// #if __BEE_DEVELOPMENT__

@property (nonatomic, readonly) BOOL					created;
@property (nonatomic, readonly) BOOL					sending;
@property (nonatomic, readonly) BOOL					recving;
@property (nonatomic, readonly) BOOL					failed;
@property (nonatomic, readonly) BOOL					succeed;
@property (nonatomic, readonly) BOOL					cancelled;
@property (nonatomic, readonly) BOOL					redirected;
@property (nonatomic, readonly) BOOL					sendProgressed;
@property (nonatomic, readonly) BOOL					recvProgressed;

@property (nonatomic, readonly) CGFloat					uploadPercent;
@property (nonatomic, readonly) NSUInteger				uploadBytes;
@property (nonatomic, readonly) NSUInteger				uploadTotalBytes;

@property (nonatomic, readonly) CGFloat					downloadPercent;
@property (nonatomic, readonly) NSUInteger				downloadBytes;
@property (nonatomic, readonly) NSUInteger				downloadTotalBytes;

- (BOOL)is:(NSString *)url;
- (void)changeState:(NSUInteger)state;

- (BOOL)hasResponder:(id)responder;
- (void)addResponder:(id)responder;
- (void)removeResponder:(id)responder;
- (void)removeAllResponders;

- (void)callResponders;
- (void)forwardResponder:(NSObject *)obj;

- (void)updateSendProgress;
- (void)updateRecvProgress;

@end

#pragma mark -

@interface BeeEmptyRequest : BeeHTTPRequest
@end

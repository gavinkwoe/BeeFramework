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

#undef	BEFORE_SOCKET
#define BEFORE_SOCKET( __sock ) \
		- (void)prehandleSocket:(BeeSocket *)__sock

#undef	AFTER_SOCKET
#define AFTER_SOCKET( __sock ) \
		- (void)posthandleSocket:(BeeSocket *)__sock

#undef	ON_SOCKET
#define ON_SOCKET( __sock ) \
		- (void)handleSocket:(BeeSocket *)__sock

#pragma mark -

@class BeeSocket;

@interface NSObject(BeeSocket)
- (BOOL)isSocketResponder;
- (BOOL)prehandleSocket:(BeeSocket *)socket;
- (void)posthandleSocket:(BeeSocket *)socket;
- (void)handleSocket:(BeeSocket *)socket;
@end

#pragma mark -

typedef void (^BeeSocketBlock)( void );

#pragma mark -

@interface BeeSocket : NSObject

AS_INT( ROLE_CLIENT );
AS_INT( ROLE_SERVER );
AS_INT( ROLE_DAEMON );

AS_INT( STATE_CREATED );
AS_INT( STATE_CONNECTING );
AS_INT( STATE_CONNECTED );
AS_INT( STATE_READY );
AS_INT( STATE_DISCONNECTING );
AS_INT( STATE_DISCONNECTED );

AS_INT( ERROR_OK );
AS_INT( ERROR_IO );
AS_INT( ERROR_RESOLVE_HOST );
AS_INT( ERROR_CONNECTION_TIMEOUT );
AS_INT( ERROR_CONNECTION_RESET );
AS_INT( ERROR_UNKNOWN );

@property (nonatomic, assign) NSUInteger				role;
@property (nonatomic, readonly) BOOL					isClient;
@property (nonatomic, readonly) BOOL					isServer;
@property (nonatomic, readonly) BOOL					isDaemon;

@property (nonatomic, assign) NSUInteger				state;
@property (nonatomic, readonly) BOOL					created;
@property (nonatomic, readonly) BOOL					connecting;
@property (nonatomic, readonly) BOOL					connected;
@property (nonatomic, readonly) BOOL					accepting;
@property (nonatomic, readonly) BOOL					accepted;
@property (nonatomic, readonly) BOOL					disconnecting;
@property (nonatomic, readonly) BOOL					disconnected;
@property (nonatomic, readonly) BOOL					stopping;
@property (nonatomic, readonly) BOOL					stopped;
@property (nonatomic, readonly) BOOL					listenning;
@property (nonatomic, readonly) BOOL					acceptable;
@property (nonatomic, readonly) BOOL					writable;
@property (nonatomic, readonly) BOOL					readable;
@property (nonatomic, readonly) BOOL					heartBeat;

@property (nonatomic, retain) NSMutableArray *			responders;
//@property (nonatomic, assign) id						responder;

@property (nonatomic, assign) NSInteger					errorCode;
@property (nonatomic, retain) NSMutableDictionary *		userInfo;
@property (nonatomic, retain) NSObject *				userObject;

@property (nonatomic, copy) BeeSocketBlock				whenUpdate;
@property (nonatomic, copy) BeeSocketBlock				whenConnecting;
@property (nonatomic, copy) BeeSocketBlock				whenConnected;
@property (nonatomic, copy) BeeSocketBlock				whenAccepting;
@property (nonatomic, copy) BeeSocketBlock				whenAccepted;
@property (nonatomic, copy) BeeSocketBlock				whenDisconnecting;
@property (nonatomic, copy) BeeSocketBlock				whenDisconnected;
@property (nonatomic, copy) BeeSocketBlock				whenStopping;
@property (nonatomic, copy) BeeSocketBlock				whenStopped;
@property (nonatomic, copy) BeeSocketBlock				whenListenning;
@property (nonatomic, copy) BeeSocketBlock				whenAcceptable;
@property (nonatomic, copy) BeeSocketBlock				whenWritable;
@property (nonatomic, copy) BeeSocketBlock				whenReadable;
@property (nonatomic, copy) BeeSocketBlock				whenHeartBeat;

@property (nonatomic, retain) NSString *				host;
@property (nonatomic, assign) NSUInteger				port;

@property (nonatomic, readonly) NSMutableData *			readBuffer;
@property (nonatomic, readonly) NSMutableData *			sendBuffer;

@property (nonatomic, readonly) NSUInteger				readableSize;
@property (nonatomic, readonly) NSData *				readableData;
@property (nonatomic, readonly) NSString *				readableString;

@property (nonatomic, assign) BOOL						autoConsume;
@property (nonatomic, assign) BOOL						autoReconnect;
@property (nonatomic, assign) BOOL						autoHeartbeat;

@property (nonatomic, readonly) NSUInteger				readBytes;
@property (nonatomic, readonly) NSUInteger				sentBytes;

+ (BeeSocket *)socket;
+ (BeeSocket *)socket:(int)sock;
+ (BeeSocket *)socket:(int)sock responder:(id)responder;

+ (NSArray *)sockets;

- (BOOL)hasResponder:(id)responder;
- (void)addResponder:(id)responder;
- (void)removeResponder:(id)responder;
- (void)removeAllResponders;

// client

- (BOOL)connect:(NSString *)addr;
- (BOOL)connect:(NSString *)addr port:(NSUInteger)port;
- (void)disconnect;

- (BOOL)send:(id)data;
- (BOOL)send:(id)data encoding:(NSStringEncoding)encoding;
- (BOOL)send:(void *)bytes length:(NSUInteger)length;
- (BOOL)sendEOL;
- (BOOL)sendEOF;

- (NSData *)read;
- (NSData *)read:(NSUInteger)length;
- (NSData *)read:(NSUInteger)length remove:(BOOL)remove;
- (NSData *)read:(NSUInteger)length offset:(NSUInteger)offset;
- (NSData *)read:(NSUInteger)length offset:(NSUInteger)offset remove:(BOOL)remove;

// server

- (BOOL)listen:(NSUInteger)port;
- (void)stop;

- (void)refuse;
- (void)refuseAll;

- (BeeSocket *)accept;

@end

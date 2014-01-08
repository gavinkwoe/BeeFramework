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
#import "Bee_Reachability.h"
#import "Bee_Socket.h"
#import "Reachability.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	MAX_SEGMENT_SIZE
#define MAX_SEGMENT_SIZE		(63 * 1024)	// BSD socket limitation, 65535 bytes

#undef	MAX_RETRY_TIMES
#define MAX_RETRY_TIMES			(3)

#undef	MAX_CONN_TIMEOUT
#define	MAX_CONN_TIMEOUT		(15.0f)

#undef	MAX_BACKLOG
#define MAX_BACKLOG				(1024)

#undef	HEARTBEAT_INTERVAL
#define	HEARTBEAT_INTERVAL		(30.0f)

#pragma mark -

@implementation NSObject(BeeSocket)

- (BOOL)isSocketResponder
{
	if ( [self respondsToSelector:@selector(handleSocket:)] )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)prehandleSocket:(BeeSocket *)socket
{
	return YES;
}

- (void)posthandleSocket:(BeeSocket *)socket
{
	
}

- (void)handleSocket:(BeeSocket *)socket
{
	
}

@end

#pragma mark -

@interface BeeSocket()
{
	BOOL					_autoConsume;
	BOOL					_autoReconnect;
	BOOL					_autoHeartbeat;
	BOOL					_ready;

	NSUInteger				_role;
	NSUInteger				_state;
	NSMutableArray *		_responders;
//	id						_responder;
	
	NSInteger				_errorCode;
	NSMutableDictionary *	_userInfo;
	NSObject *				_userObject;

	NSString *				_host;
	NSUInteger				_port;
	
	BOOL					_heartBeat;
	BOOL					_acceptable;
	BOOL					_writable;
	BOOL					_readable;
	
	BeeSocketBlock			_whenUpdate;
	BeeSocketBlock			_whenConnecting;
	BeeSocketBlock			_whenConnected;
	BeeSocketBlock			_whenAccepting;
	BeeSocketBlock			_whenAccepted;
	BeeSocketBlock			_whenDisconnecting;
	BeeSocketBlock			_whenDisconnected;
	BeeSocketBlock			_whenStopping;
	BeeSocketBlock			_whenStopped;
	BeeSocketBlock			_whenListenning;
	BeeSocketBlock			_whenAcceptable;
	BeeSocketBlock			_whenWritable;
	BeeSocketBlock			_whenReadable;
	BeeSocketBlock			_whenHeartBeat;

	char					_rawBuffer[MAX_SEGMENT_SIZE];
	NSMutableData *			_readBuffer;
	NSMutableData *			_sendBuffer;

	NSUInteger				_readBytes;
	NSUInteger				_sentBytes;
	
	int						_sock;
	CFSocketRef				_sockRef;
	CFRunLoopSourceRef		_runLoop;

	NSMutableArray *		_connections;
	NSTimer *				_connTimer;
	NSTimer *				_beatTimer;
}

@property (nonatomic, readonly) int				sock;
@property (nonatomic, readonly) CFSocketRef		sockRef;
@property (nonatomic, readonly) BOOL			ready;

- (BOOL)internalOpen:(int)sock;
- (BOOL)internalListen;
- (BOOL)internalConnect;
- (BOOL)internalAccept:(int)sock;
- (void)internalDisconnect;
- (void)internalClose;
- (void)internalError:(NSUInteger)error;

- (NSUInteger)internalSend;
- (NSUInteger)internalRead;

- (void)handleEventConnected;
- (void)handleEventChunkData:(NSData *)data;
- (void)handleEventAcceptable:(int)socket;
- (void)handleEventReadable;
- (void)handleEventWritable;
- (void)handleEventError:(NSInteger)error;

- (void)changeState:(NSUInteger)state;
- (void)changeState:(NSUInteger)state silent:(BOOL)silent;

- (void)updateSendProgress;
- (void)updateReadProgress;
- (void)updateHeartBeat;
- (void)updateAcceptable;

- (void)startConnectTimer;
- (void)stopConnectTimer;
- (void)didConnectTimeout;

- (void)startHeartbeatTimer;
- (void)stopHeartbeatTimer;
- (void)didHeartbeatTimeout;

@end

#pragma mark -

@implementation BeeSocket

DEF_INT( ROLE_CLIENT,			0 );
DEF_INT( ROLE_SERVER,			1 );
DEF_INT( ROLE_DAEMON,			2 );

DEF_INT( STATE_CREATED,			0 );
DEF_INT( STATE_CONNECTING,		1 );
DEF_INT( STATE_CONNECTED,		2 );
DEF_INT( STATE_READY,			3 );
DEF_INT( STATE_DISCONNECTING,	4 );
DEF_INT( STATE_DISCONNECTED,	5 );

DEF_INT( ERROR_OK,					0 );
DEF_INT( ERROR_IO,					1 );
DEF_INT( ERROR_RESOLVE_HOST,		2 );
DEF_INT( ERROR_CONNECTION_TIMEOUT,	3 );
DEF_INT( ERROR_CONNECTION_RESET,	4 );
DEF_INT( ERROR_UNKNOWN,				5 );

@synthesize role = _role;
@dynamic isClient;
@dynamic isServer;
@dynamic isDaemon;

@synthesize state = _state;
@dynamic created;
@dynamic connecting;
@dynamic connected;
@dynamic accepting;
@dynamic accepted;
@dynamic disconnecting;
@dynamic disconnected;
@dynamic listenning;
@dynamic stopping;
@dynamic stopped;
@synthesize writable = _writable;
@synthesize readable = _readable;
@synthesize acceptable = _acceptable;
@synthesize heartBeat = _heartBeat;

@synthesize host = _host;
@synthesize port = _port;

@synthesize sock = _sock;
@synthesize sockRef = _sockRef;
@synthesize ready = _ready;

@synthesize errorCode = _errorCode;
//@synthesize responder = _responder;
@synthesize responders = _responders;

@synthesize userInfo = _userInfo;
@synthesize userObject = _userObject;

@synthesize whenUpdate = _whenUpdate;
@synthesize whenConnecting = _whenConnecting;
@synthesize whenConnected = _whenConnected;
@synthesize whenAccepting = _whenAccepting;
@synthesize whenAccepted = _whenAccepted;
@synthesize whenDisconnecting = _whenDisconnecting;
@synthesize whenDisconnected = _whenDisconnected;
@synthesize whenStopping = _whenStopping;
@synthesize whenStopped = _whenStopped;
@synthesize whenListenning = _whenListenning;
@synthesize whenAcceptable = _whenAcceptable;
@synthesize whenWritable = _whenWritable;
@synthesize whenReadable = _whenReadable;
@synthesize whenHeartBeat = _whenHeartBeat;

@synthesize readBuffer = _readBuffer;
@synthesize sendBuffer = _sendBuffer;

@dynamic readableSize;
@dynamic readableData;
@dynamic readableString;

@synthesize autoConsume = _autoConsume;
@synthesize autoReconnect = _autoReconnect;
@synthesize autoHeartbeat = _autoHeartbeat;

@synthesize readBytes = _readBytes;
@synthesize sentBytes = _sentBytes;

static NSMutableArray *	__sockets = nil;

static void socketCallback( CFSocketRef socketRef, CFSocketCallBackType type, CFDataRef address, const void * data, void * info )
{
	BeeSocket * socketObj = (BeeSocket *)info;
	if ( nil == socketObj )
		return;

//	INFO( @"socket %d callback, type = %d", socketObj.sock, type );
	if ( NO == socketObj.ready || socketRef != socketObj.sockRef )
		return;

	switch ( type )
	{
	case kCFSocketConnectCallBack:
		{
			SInt32 * err_code = (SInt32 *)data;
			
			// If a connection attempt is made in the background by calling CFSocketConnectToAddress or -
			// CFSocketCreateConnectedToSocketSignature with a negative timeout value, this callback type -
			// is made when the connect finishes.
			// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			//
			// In this case the data argument is either NULL or a pointer to an SInt32 error code, if the -
			// connect failed. This callback will never be sent more than once for a given socket.

			if ( NULL == err_code )
			{
				[socketObj handleEventConnected];
			}
			else
			{
				[socketObj handleEventError:*err_code];
			}
		}
		break;

	case kCFSocketAcceptCallBack:
		{
			// New connections will be automatically accepted and the callback is called
			// with the data argument being a pointer to a CFSocketNativeHandle of the child socket.
			// This callback is usable only with listening sockets.

			int socket = data ? *((int *)data) : -1;
			if ( socket >= 0 )
			{
				[socketObj handleEventAcceptable:socket];
			}
			else
			{
				[socketObj handleEventError:0];
			}
		}
		break;
			
	case kCFSocketReadCallBack:
		{
			// The callback is called when data is available to be read or a new connection is waiting to be accepted.
			//                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			//                                 (for client side)                        (for server side)
			// The data is not automatically read; the callback must read the data itself.
			//                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			//                                              (use 'recv' to read)
			
			[socketObj handleEventReadable];
		}
		break;

	case kCFSocketWriteCallBack:
		{
			// The callback is called when the socket is writable.
			//                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^
			//                        ( if previous large data 'send' operation was fail )
			// This callback type may be useful when large amounts of data are being sent rapidly -
			// over the socket and you want a notification when there is space in the kernel buffers for more data.
		
			[socketObj handleEventWritable];
		}
		break;
			
	case kCFSocketDataCallBack:
		{
			// Incoming data will be read in chunks in the background and the callback is called -
			// with the data argument being a CFData object containing the read data.
			//          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			
			void *		data = (void *)CFDataGetBytePtr( address );
			NSUInteger	size = (NSUInteger)CFDataGetLength( address );

			if ( data && size )
			{
				NSData * segment = [NSData dataWithBytesNoCopy:data length:size];
				if ( segment && segment.length )
				{
					[socketObj handleEventChunkData:segment];
				}
			}
		}
		break;

	case kCFSocketNoCallBack:
	default:
		{
			// never go here
		}
		break;
	}
}

+ (BeeSocket *)socket
{
	return [[[BeeSocket alloc] init] autorelease];
}

+ (BeeSocket *)socket:(int)sock
{
	return [self socket:sock responder:nil];
}

+ (BeeSocket *)socket:(int)sock responder:(id)responder
{
	BeeSocket * conn = [[BeeSocket alloc] init];
	if ( nil == conn )
	{
		return nil;
	}
	
	if ( responder )
	{
		[conn addResponder:responder];
	}
	
	BOOL succeed = [conn internalAccept:sock];
	if ( NO == succeed )
	{
		[conn internalDisconnect];
		[conn internalClose];
		[conn release];
		return nil;
	}

	return [conn autorelease];
}

+ (NSArray *)sockets
{
	return [NSArray arrayWithArray:__sockets];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		static BOOL __inited = NO;

		if ( NO == __inited )
		{
			struct sigaction state = { 0 };
			
			// ignore the signal SIGPIPE
			int ret = sigaction( SIGPIPE, NULL, &state );
			if ( ret >= 0 )
			{
				state.sa_handler = SIG_IGN;

				ret = sigaction( SIGPIPE, &state, NULL );
				ASSERT( ret >= 0 );
			}

			__inited = YES;
		}
		
		if ( nil == __sockets )
		{
			__sockets = [[NSMutableArray nonRetainingArray] retain];
		}
		
		[__sockets addObject:self];

		_autoConsume = YES;
		_autoReconnect = NO;
		_autoHeartbeat = NO;
		_ready = NO;
		
		_role = BeeSocket.ROLE_CLIENT;
		_state = BeeSocket.STATE_CREATED;
		_errorCode = 0;
		
		_responders = [[NSMutableArray nonRetainingArray] retain];
		_userInfo = [[NSMutableDictionary alloc] init];
		_userObject = nil;

		_writable = NO;
		_readable = NO;

		_readBuffer = [[NSMutableData alloc] init];
		_sendBuffer = [[NSMutableData alloc] init];
		_connections = [[NSMutableArray alloc] init];

		memset( _rawBuffer, 0, MAX_SEGMENT_SIZE );
		
		_readBytes = 0;
		_sentBytes = 0;

		_sock		= (int)-1;
		_sockRef	= NULL;
		_runLoop	= NULL;

		_connTimer	= nil;
		_beatTimer	= nil;
	}
	return self;
}

- (void)dealloc
{
	[__sockets removeObject:self];

	self.whenUpdate = nil;
	self.whenConnecting = nil;
	self.whenConnected = nil;
	self.whenAccepting = nil;
	self.whenAccepted = nil;
	self.whenDisconnecting = nil;
	self.whenDisconnected = nil;
	self.whenStopping = nil;
	self.whenStopped = nil;
	self.whenListenning = nil;
	self.whenAcceptable = nil;
	self.whenWritable = nil;
	self.whenReadable = nil;
	self.whenHeartBeat = nil;

//	self.host = nil;
//	self.port = 0;

	[self internalDisconnect];
	[self internalClose];

	[_connections removeAllObjects];
	[_connections release];
	_connections = nil;
	
	[_responders removeAllObjects];
	[_responders release];
	_responders = nil;

	[_userInfo removeAllObjects];
	[_userInfo release];
	_userInfo = nil;

	[_userObject release];
	_userObject = nil;

	[_readBuffer release];
	_readBuffer = nil;

	[_sendBuffer release];
	_sendBuffer = nil;

	[_host release];
	_host = nil;

	[super dealloc];
}

- (void)callResponders
{
    NSArray * responds = [self.responders copy];
	
	for ( NSObject * responder in responds)
	{
		[self forwardResponder:responder];
	}
	
    [responds release];
}

- (void)forwardResponder:(NSObject *)obj
{
	BOOL allowed = YES;
	
	if ( [obj respondsToSelector:@selector(prehandleRequest:)] )
	{
		allowed = [obj prehandleSocket:self];
	}
	
	if ( allowed )
	{
//		[obj retain];

		if ( [obj isSocketResponder] )
		{
			[obj handleSocket:self];
		}

		[obj posthandleSocket:self];

//		[obj release];
	}
}

#pragma mark -

- (BOOL)isClient
{
	return BeeSocket.ROLE_CLIENT == _role ? YES : NO;
}

- (BOOL)isServer
{
	return BeeSocket.ROLE_SERVER == _role ? YES : NO;
}

- (BOOL)isDaemon
{
	return BeeSocket.ROLE_DAEMON == _role ? YES : NO;
}

#pragma mark -

- (BOOL)created
{
	return BeeSocket.STATE_CREATED == _state ? YES : NO;
}

- (BOOL)connecting
{
	if ( BeeSocket.ROLE_CLIENT != _role || BeeSocket.ROLE_SERVER != _role )
	{
		return NO;
	}
	
	return BeeSocket.STATE_CONNECTING == _state ? YES : NO;
}

- (BOOL)connected
{
	if ( BeeSocket.ROLE_CLIENT != _role || BeeSocket.ROLE_SERVER != _role )
	{
		return NO;
	}

	return BeeSocket.STATE_CONNECTED == _state ? YES : NO;
}

- (BOOL)accepting
{
	if ( BeeSocket.ROLE_SERVER != _role )
	{
		return NO;
	}
	
	return BeeSocket.STATE_CONNECTING == _state ? YES : NO;
}

- (BOOL)accepted
{
	if ( BeeSocket.ROLE_SERVER != _role )
	{
		return NO;
	}
	
	return BeeSocket.STATE_CONNECTED == _state ? YES : NO;
}

- (BOOL)disconnecting
{
	if ( BeeSocket.ROLE_CLIENT != _role && BeeSocket.ROLE_SERVER != _role )
	{
		return NO;
	}

	return BeeSocket.STATE_DISCONNECTING == _state ? YES : NO;
}

- (BOOL)disconnected
{
	if ( BeeSocket.ROLE_CLIENT != _role && BeeSocket.ROLE_SERVER != _role )
	{
		return NO;
	}

	return BeeSocket.STATE_DISCONNECTED == _state ? YES : NO;
}

#pragma mark -

- (BOOL)listenning
{
	if ( BeeSocket.ROLE_DAEMON != _role )
	{
		return NO;
	}
	
	return BeeSocket.STATE_CONNECTING == _state ? YES : NO;
}

- (BOOL)acceptable
{
	if ( BeeSocket.ROLE_DAEMON != _role )
	{
		return NO;
	}
	
	return _acceptable ? YES : NO;
}

- (BOOL)stopping
{
	if ( BeeSocket.ROLE_DAEMON != _role )
	{
		return NO;
	}

	return BeeSocket.STATE_DISCONNECTING == _state ? YES : NO;
}

- (BOOL)stopped
{
	if ( BeeSocket.ROLE_DAEMON != _role )
	{
		return NO;
	}

	return BeeSocket.STATE_DISCONNECTED == _state ? YES : NO;
}

#pragma mark -

- (BOOL)hasResponder:(id)responder
{
	return [_responders containsObject:responder];
}

- (void)addResponder:(id)responder
{
	[_responders addObject:responder];
}

- (void)removeResponder:(id)responder
{
	[_responders removeObject:responder];
}

- (void)removeAllResponders
{
	[_responders removeAllObjects];
}

#pragma mark -

- (void)changeState:(NSUInteger)state
{
	return [self changeState:state silent:NO];
}

- (void)changeState:(NSUInteger)state silent:(BOOL)silent
{
	if ( state != _state && state != self.STATE_CREATED )
	{
		INFO( @"socket %d, status %d -> %d", _sock, _state, state );
		
		_state = state;
		
		// TODO: calc time here
		
		if ( NO == silent )
		{
			[self callResponders];
			
			if ( self.connecting )
			{
				if ( self.whenConnecting )
				{
					self.whenConnecting();
				}
			}
			else if ( self.connected )
			{
				if ( self.whenConnected )
				{
					self.whenConnected();
				}
			}
			else if ( self.accepting )
			{
				if ( self.whenAccepting )
				{
					self.whenAccepting();
				}
			}
			else if ( self.accepted )
			{
				if ( self.whenAccepted )
				{
					self.whenAccepted();
				}
			}
			else if ( self.disconnecting )
			{
				if ( self.whenDisconnecting )
				{
					self.whenDisconnecting();
				}
			}
			else if ( self.disconnected )
			{
				if ( self.whenDisconnected )
				{
					self.whenDisconnected();
				}
			}
			else if ( self.stopping )
			{
				if ( self.whenStopping )
				{
					self.whenStopping();
				}
			}
			else if ( self.stopped )
			{
				if ( self.whenStopped )
				{
					self.whenStopped();
				}
			}
			else if ( self.listenning )
			{
				if ( self.whenListenning )
				{
					self.whenListenning();
				}
			}
			
			if ( self.whenUpdate )
			{
				self.whenUpdate();
			}
		}
	}
}

- (void)updateSendProgress
{
	if ( _sock )
	{
		_writable = YES;
		
		[self callResponders];
		
		if ( self.whenWritable )
		{
			self.whenWritable();
		}
		
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
		
		_writable = NO;
	}
}

- (void)updateReadProgress
{
	if ( _sock )
	{
		_readable = YES;
		
		[self callResponders];
		
		if ( self.whenReadable )
		{
			self.whenReadable();
		}
		
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
		
		_readable = NO;
	}
}

- (void)updateHeartBeat
{
	if ( _sock )
	{
		_heartBeat = YES;
		
		[self callResponders];
		
		if ( self.whenHeartBeat )
		{
			self.whenHeartBeat();
		}
		
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
		
		_heartBeat = NO;
	}
}

- (void)updateAcceptable
{
	if ( _sock )
	{
		_acceptable = YES;
		
		[self callResponders];
		
		if ( self.whenAcceptable )
		{
			self.whenAcceptable();
		}
		
		if ( self.whenUpdate )
		{
			self.whenUpdate();
		}
		
		_acceptable = NO;
	}
}

#pragma mark -

- (BOOL)internalOpen:(int)sock
{	
	if ( _sock >= 0 )
	{
		WARN( @"socket %d, already opened", _sock );
		return NO;
	}

	if ( sock >= 0 )
	{
		if ( _sock >= 0 )
		{
			WARN( @"socket %d, already opened", _sock );
			return NO;
		}
		
		// Set to non-blocking mode
		
		int nonBlock = fcntl( sock, F_GETFL, NULL );
		nonBlock |= O_NONBLOCK;
		//	nonBlock |= O_SYNC;
#ifdef TCP_NOPUSH
		nonBlock |= TCP_NOPUSH;
#endif	// #ifdef TCP_NOPUSH
		
		int ret = fcntl( sock, F_SETFL, nonBlock );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"socket %d, failed to set non-blocking mode", sock );
			return NO;
		}
		
		// No SIG PIPE
		
		int noSignal = 1;
		ret = setsockopt( sock, SOL_SOCKET, SO_NOSIGPIPE, &noSignal, sizeof(noSignal) );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"socket %d, failed to set option, SO_NOSIGPIPE", sock );
			return NO;
		}
		
		// Don't delay send to coalesce packets
		
#ifdef TCP_NODELAY
		
		int noDelay = 1;
		ret = setsockopt( sock, IPPROTO_TCP, TCP_NODELAY, (const void *)&noDelay, sizeof(noDelay) );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"socket %d, failed to set option, TCP_NODELAY", sock );
			return NO;
		}
		
#endif	// #ifdef TCP_NODELAY
		
#ifdef TCP_NOPUSH
		
		int noPush = 1;
		ret = setsockopt( sock_fd, IPPROTO_TCP, TCP_NOPUSH, (const void *)&noPush, sizeof(noPush) );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"socket %d, failed to set option, TCP_NOPUSH", sock );
			return NO;
		}
		
#endif	// #ifdef TCP_NOPUSH		
	}
	else
	{
		sock = socket( PF_INET, SOCK_STREAM, 0 );
		if ( sock < 0 )
		{
			ERROR( @"failed to create socket" );
			return NO;
		}
		
		// Allow to reuse same address between different process(s)
		
		int reuseAddr = 1;
		int ret = setsockopt( sock, SOL_SOCKET, SO_REUSEADDR, (const void *)&reuseAddr, sizeof(reuseAddr) );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"failed to set option, SO_REUSEADDR" );
			return NO;
		}
		
		// Discards all sending data when 'close'
		
		struct linger linger = { 0 };
		linger.l_onoff = 1; // 1
		linger.l_linger = 1;
		ret = setsockopt( sock, SOL_SOCKET, SO_LINGER, (const void *)&linger, sizeof(linger) );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"failed to set option, SO_LINGER" );
			return NO;
		}

		// Max send/receive segment size
		int sendBufSize = MAX_SEGMENT_SIZE;
		int recvBufSize = MAX_SEGMENT_SIZE;

		ret = setsockopt( sock, SOL_SOCKET, SO_SNDBUF, (const void *)&sendBufSize, sizeof(sendBufSize) );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"failed to set option, SO_LINGER" );
			return NO;
		}

		ret = setsockopt( sock, SOL_SOCKET, SO_RCVBUF, (const void *)&recvBufSize, sizeof(recvBufSize) );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"failed to set option, SO_LINGER" );
			return NO;
		}

		// Accept any outgoing connections
		
		struct sockaddr_in addr = { 0 };
		bzero( &addr, sizeof(addr) );
		addr.sin_family = AF_INET;
		addr.sin_addr.s_addr = htonl( INADDR_ANY );
		
		if ( BeeSocket.ROLE_DAEMON == self.role )
		{
			addr.sin_port = htons( self.port );
		}
		else if ( BeeSocket.ROLE_CLIENT == self.role )
		{
			addr.sin_port = htonl( INADDR_ANY );
		}
		else if ( BeeSocket.ROLE_SERVER == self.role )
		{
			addr.sin_port = htonl( INADDR_ANY );
		}
		
		ret = bind( sock, (const struct sockaddr *)&addr, sizeof(struct sockaddr_in) );
		if ( ret < 0 )
		{
	//		ASSERT( EADDRINUSE != errno );

			close( sock );
			
			ERROR( @"failed to bind address" );
			return NO;
		}
		
		// Set to non-blocking mode
		
		int nonBlock = fcntl( sock, F_GETFL, NULL );
		nonBlock |= O_NONBLOCK;
	//	nonBlock |= O_SYNC;
	#ifdef TCP_NOPUSH
		nonBlock |= TCP_NOPUSH;
	#endif	// #ifdef TCP_NOPUSH

		ret = fcntl( sock, F_SETFL, nonBlock );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"failed to set non-blocking mode" );
			return NO;
		}

		// No SIG PIPE

		int noSignal = 1;
		ret = setsockopt( sock, SOL_SOCKET, SO_NOSIGPIPE, &noSignal, sizeof(noSignal) );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"failed to set option, SO_NOSIGPIPE" );
			return NO;
		}

		// Allow to reuse same port between different process(s)
		
	#ifdef SO_REUSEPORT
		
		int reusePort = 1;
		ret = setsockopt( sock, SOL_SOCKET, SO_REUSEPORT, (const void *)&reusePort, sizeof(reusePort) );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"failed to set option, SO_REUSEPORT" );
			return NO;
		}
		
	#endif	// #ifdef SO_REUSEPORT
		
		// Don't delay send to coalesce packets
		
	#ifdef TCP_NODELAY
		
		int noDelay = 1;
		ret = setsockopt( sock, IPPROTO_TCP, TCP_NODELAY, (const void *)&noDelay, sizeof(noDelay) );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"failed to set option, TCP_NODELAY" );
			return NO;
		}
		
	#endif	// #ifdef TCP_NODELAY
		
	#ifdef TCP_NOPUSH
		
		int noPush = 1;
		ret = setsockopt( sock_fd, IPPROTO_TCP, TCP_NOPUSH, (const void *)&noPush, sizeof(noPush) );
		if ( ret < 0 )
		{
			close( sock );
			
			ERROR( @"failed to set option, TCP_NOPUSH" );
			return NO;
		}
		
	#endif	// #ifdef TCP_NOPUSH
	}

	_sock = sock;
	_ready = NO;
	
	[_readBuffer setData:[NSData data]];
	[_sendBuffer setData:[NSData data]];
	
	INFO( @"socket %d, open", _sock );
	return YES;
}

- (BOOL)internalListen
{
	[self internalDisconnect];
	[self internalClose];
	
	BOOL succeed = [self internalOpen:(-1)];
	if ( NO == succeed )
	{
		return NO;
	}

	int status = listen( _sock, MAX_BACKLOG );
	if ( status < 0 )
	{
		ERROR( @"socket %d, failed to create runloop", _sock );
		[self internalDisconnect];
		[self internalClose];
		return NO;
	}

	// add socket to main runloop
	
	CFSocketContext context = { 0, self, NULL, NULL, NULL };
	CFOptionFlags	flags = kCFSocketAcceptCallBack;

	_sockRef = CFSocketCreateWithNative( NULL, _sock, flags, socketCallback, &context );
	if ( NULL == _sockRef )
	{
		ERROR( @"socket %d, failed to create CFSocket", _sock );
		[self internalDisconnect];
		return NO;
	}
	
	CFSocketEnableCallBacks( _sockRef, flags );

	_runLoop = CFSocketCreateRunLoopSource( NULL, _sockRef, 0 );
	if ( NULL == _runLoop )
	{
		ERROR( @"socket %d, failed to create runloop", _sock );
		[self internalDisconnect];
		return NO;
	}

	CFRunLoopAddSource( CFRunLoopGetCurrent(), _runLoop, kCFRunLoopDefaultMode );

	_ready = YES;

	INFO( @"socket %d, listenning on %d", _sock, self.port );
	return YES;
}

- (BOOL)internalConnect
{
	[self internalDisconnect];
	[self internalClose];

	BOOL succeed = [self internalOpen:(-1)];
	if ( NO == succeed )
	{
		return NO;
	}

// add socket to main runloop
	
	CFSocketContext context = { 0, self, NULL, NULL, NULL };
	CFOptionFlags	flags = kCFSocketConnectCallBack|kCFSocketReadCallBack|kCFSocketWriteCallBack;
	
	_sockRef = CFSocketCreateWithNative( NULL, _sock, flags, socketCallback, &context );
	if ( NULL == _sockRef )
	{
		ERROR( @"socket %d, failed to create CFSocket", _sock );
		[self internalDisconnect];
		[self internalClose];
		return NO;
	}

	CFSocketEnableCallBacks( _sockRef, flags );

	_runLoop = CFSocketCreateRunLoopSource( NULL, _sockRef, 0 );
	if ( NULL == _runLoop )
	{
		ERROR( @"socket %d, failed to create runloop", _sock );
		[self internalDisconnect];
		[self internalClose];
		return NO;
	}

	CFRunLoopAddSource( CFRunLoopGetCurrent(), _runLoop, kCFRunLoopDefaultMode );
	
	// NOTE: connect to server
	struct sockaddr_in sockAddr = { 0 };
	sockAddr.sin_family = AF_INET;
	sockAddr.sin_addr.s_addr = inet_addr( self.host.UTF8String );
	sockAddr.sin_port = htons( self.port );

	CFDataRef destAddr = CFDataCreate( NULL, (const UInt8 *)&sockAddr, sizeof(struct sockaddr_in) );
	if ( NULL == destAddr )
	{
		ERROR( @"socket %d, failed to create address", _sock );
		[self internalDisconnect];
		[self internalClose];
		return NO;
	}

	CFSocketError error = CFSocketConnectToAddress( _sockRef, destAddr, -1.0 );
	CFRelease( destAddr );

	if ( kCFSocketSuccess != error )
	{
		int last_error = errno;
		ERROR( @"socket %d, failed to connect, error = %d", _sock, last_error );
		
		if ( kCFSocketError == error )
		{
			if ( EINPROGRESS != last_error ) // would block or error
			{
				[self internalDisconnect];
				[self internalClose];
				return NO;
			}
		}
		else
		{
			[self internalDisconnect];
			[self internalClose];
			return NO;
		}
	}

	[self startConnectTimer];

	_ready = YES;

	INFO( @"socket %d, connecting to %@:%d", _sock, self.host, self.port );
	return YES;
}

- (BOOL)internalAccept:(int)sock
{
	[self internalDisconnect];
	[self internalClose];
	
	BOOL succeed = [self internalOpen:sock];
	if ( NO == succeed )
	{
		return NO;
	}

	// add socket to main runloop
	
	CFSocketContext context = { 0, self, NULL, NULL, NULL };
	CFOptionFlags	flags = kCFSocketConnectCallBack|kCFSocketReadCallBack|kCFSocketWriteCallBack;
	
	_sockRef = CFSocketCreateWithNative( NULL, _sock, flags, socketCallback, &context );
	if ( NULL == _sockRef )
	{
		ERROR( @"socket %d, failed to create CFSocket", _sock );
		[self internalDisconnect];
		[self internalClose];
		return NO;
	}
	
	CFSocketEnableCallBacks( _sockRef, flags );
	
	_runLoop = CFSocketCreateRunLoopSource( NULL, _sockRef, 0 );
	if ( NULL == _runLoop )
	{
		ERROR( @"socket %d, failed to create runloop", _sock );
		[self internalDisconnect];
		[self internalClose];
		return NO;
	}
	
	CFRunLoopAddSource( CFRunLoopGetCurrent(), _runLoop, kCFRunLoopDefaultMode );

	self.role	= BeeSocket.ROLE_SERVER;
	self.host	= nil;	// TODO:
	self.port	= 0;	// TODO:

	_ready = YES;
	
	[self startConnectTimer];

	INFO( @"socket %d, accepting from %@:%d", _sock, self.host, self.port );
	return YES;
}

- (NSUInteger)internalSend
{
	if ( _sock < 0 )
	{
		WARN( @"please open first" );
		return 0;
	}
	
	if ( self.STATE_READY != _state )
	{
		WARN( @"socket %d, please connect first", _sock );
		return 0;
	}

	char *	buff = (char *)[_sendBuffer bytes];
	int		size = (int)[_sendBuffer length];

	if ( NULL == buff || 0 == size )
	{
//		WARN( @"socket %d, send buffer is empty", _sock );
		return 0;
	}

	// If the RST arrives first, then call internalSend again...
	// The SIGPIPE signal is sent to out process, the app will be terminated.
	// So our process must catch the signal to avoid being involuntarily terminated.

	int	sentSize = 0;
	int	tryTimes = 0;

	for ( ;; )
	{
		if ( sentSize >= size )
			break;

		int segmentSize = size - sentSize;
		if ( segmentSize > MAX_SEGMENT_SIZE )
		{
			segmentSize = MAX_SEGMENT_SIZE;
		}

		ssize_t ret = send( _sock, (const void *)(buff + sentSize), (size_t)segmentSize, 0 );
		if ( ret < 0 )
		{
			if ( EINTR == errno )
			{
				tryTimes += 1;
				
				if ( tryTimes <= MAX_RETRY_TIMES )
				{
					// try again immediatelly
					continue;
				}
				else
				{
					[self internalError:self.ERROR_IO];
					break;
				}
			}
			else if ( ECONNRESET == errno || EPIPE == errno /*if we catch the error signal*/ )
			{
				// *** If the RST arrives first, the result is an ECONNRESET ("Connection reset by peer") ***
				// connection reset, means socket closed by peer(server side)

				[self internalError:self.ERROR_CONNECTION_RESET];
				break;
			}
			else if ( EAGAIN == errno || EWOULDBLOCK == errno )
			{
				// wait for writable			
				break;
			}
			else
			{
				[self internalError:self.ERROR_IO];
				break;
			}
		}
		else if ( 0 == ret )
		{
			// connection reset, means socket closed by peer(server side)

			[self internalError:self.ERROR_CONNECTION_RESET];
			break;
		}
		else
		{
			INFO( @"socket %d, sent %d byte(s)", _sock, ret );
			sentSize += ret;
		}

		tryTimes = 0;
	}

	if ( sentSize > 0 )
	{
		_sentBytes += sentSize;
		[_sendBuffer replaceBytesInRange:NSMakeRange(0, sentSize) withBytes:NULL length:0];
	}

	return sentSize;
}

- (NSUInteger)internalRead
{
	if ( _sock < 0 )
	{
		WARN( @"please open first" );
		return 0;
	}
	
	if ( self.STATE_READY != _state )
	{
		WARN( @"socket %d, please connect first", _sock );
		return 0;
	}

	// <Getting the Number of Bytes Available>
	// The FIONREAD ioctl gets the number of bytes in the serial port (or file descriptor) input buffer.
	// Example:
	//		#include <unistd.h>
	//		#include <termios.h>
	//		int fd;
	//		int bytes;
	//		ioctl(fd, FIONREAD, &bytes);

	int	tryTimes = 0;
	int	readSize = 0;
	int	totalSize = 0;

	int ret = ioctl( _sock, FIONREAD, &totalSize );
	if ( ret < 0 )
	{
		[self internalError:self.ERROR_IO];
		return 0;
	}
	
	if ( 0 == totalSize ) // if ConnReset
	{
		[self internalError:BeeSocket.ERROR_CONNECTION_RESET];
		return 0;
	}

	for ( ;; )
	{
		if ( readSize >= totalSize )
			break;
		
		ssize_t size = recv( _sock, _rawBuffer, MAX_SEGMENT_SIZE, 0 );
		if ( size < 0 )
		{
			if ( EAGAIN == errno || EINTR == errno )
			{
				tryTimes += 1;
				
				if ( tryTimes <= MAX_RETRY_TIMES )
				{
					// try again immediatelly
					continue;
				}
				else
				{
					[self internalError:self.ERROR_IO];
					break;
				}
			}
			else if ( EWOULDBLOCK == errno )
			{
				[self internalError:self.ERROR_IO];
				break;
			}
			else if ( ECONNRESET == errno || EPIPE == errno /*if we catch the error signal*/ )
			{
				// connection reset, means socket closed by peer(server side)
				
				[self internalError:self.ERROR_CONNECTION_RESET];
				break;
			}
			else
			{
				[self internalError:self.ERROR_IO];
				break;
			}
		}
		else if ( 0 == size )
		{
			// connection reset, means socket closed by peer(server side)

			[self internalError:self.ERROR_CONNECTION_RESET];
			break;
		}
		else
		{
			INFO( @"socket %d, read %d byte(s)", _sock, size );			
			readSize += size;

			[_readBuffer appendBytes:_rawBuffer length:size];
		}
		
		tryTimes = 0;	// reset try times
	}
	
	if ( readSize > 0 )
	{
		_readBytes += readSize;
	}

	return readSize;
}

- (void)internalDisconnect
{
	[self stopConnectTimer];
	[self stopHeartbeatTimer];

	if ( _sock )
	{
		shutdown( _sock, SHUT_RDWR );
	}
	
	if ( NULL != _sockRef )
	{
		CFOptionFlags flags = kCFSocketConnectCallBack|kCFSocketReadCallBack|kCFSocketWriteCallBack|kCFSocketAcceptCallBack;
		CFSocketDisableCallBacks( _sockRef, flags );
		
		shutdown( _sock, SHUT_RDWR );
		
		CFSocketInvalidate( _sockRef );
		CFRelease( _sockRef );
		
		_sockRef = NULL;
	}
	
	if ( NULL != _runLoop )
	{
		CFRunLoopRemoveSource( CFRunLoopGetCurrent(), _runLoop, kCFRunLoopDefaultMode );
		CFRelease( _runLoop );
		_runLoop = NULL;
	}
	
	_ready = NO;
}

- (void)internalClose
{
	[self stopConnectTimer];
	[self stopHeartbeatTimer];
	
	if ( _sock >= 0 )
	{
		INFO( @"socket %d, close", _sock );
		
		shutdown( _sock, SHUT_RDWR );
		close( _sock );
		
		for ( NSNumber * sockFd in _connections )
		{
			shutdown( sockFd.intValue, SHUT_RDWR );
			close( sockFd.intValue );			
		}
		
		[_connections removeAllObjects];

		_sock = (int)-1;
		_ready = NO;
		
		[_readBuffer setData:[NSData data]];
		[_sendBuffer setData:[NSData data]];
		
		memset( _rawBuffer, 0, MAX_SEGMENT_SIZE );
	}	
}

- (void)internalError:(NSUInteger)error
{
//	BREAK_POINT();

	ERROR( @"socket %d, internal error %d", _sock, error );

	_errorCode = error;

	[self stopConnectTimer];
	[self stopHeartbeatTimer];
	
	[self changeState:self.STATE_DISCONNECTING];
	[self internalDisconnect];
	[self changeState:self.STATE_DISCONNECTED];

	[self internalClose];
}

#pragma mark -

- (void)didConnectTimeout
{
	_connTimer = nil;
	_errorCode = self.ERROR_CONNECTION_TIMEOUT;
	
	[self changeState:self.STATE_DISCONNECTING];
	[self internalDisconnect];
	[self changeState:self.STATE_DISCONNECTED];
	
	[self internalClose];
}

- (void)startConnectTimer
{
	[_connTimer invalidate];
	_connTimer = [NSTimer scheduledTimerWithTimeInterval:MAX_CONN_TIMEOUT
												  target:self
												selector:@selector(didConnectTimeout)
												userInfo:nil
												 repeats:NO];
}

- (void)stopConnectTimer
{
	[_connTimer invalidate];
	_connTimer = nil;
}

- (void)didHeartbeatTimeout
{
	[self updateHeartBeat];
}

- (void)startHeartbeatTimer
{
	[_beatTimer invalidate];
	_beatTimer = nil;

	if ( _autoHeartbeat )
	{
		_beatTimer = [NSTimer scheduledTimerWithTimeInterval:HEARTBEAT_INTERVAL
													  target:self
													selector:@selector(didHeartbeatTimeout)
													userInfo:nil
													 repeats:YES];
	}
}

- (void)stopHeartbeatTimer
{
	if ( _beatTimer )
	{
		[_beatTimer invalidate];
		_beatTimer = nil;
	}
}

#pragma mark -

- (BOOL)listen:(NSUInteger)port
{
	if ( 0 == port )
	{
		WARN( @"socket %d, invalid port", _sock );
		return NO;		
	}
	
	self.role = BeeSocket.ROLE_DAEMON;
	self.host = nil;
	self.port = port;
	
	BOOL succeed = [self internalListen];
	if ( succeed )
	{
		[self changeState:self.STATE_CONNECTING];
		[self changeState:self.STATE_CONNECTED];
		[self changeState:self.STATE_READY silent:YES];
	}
	else
	{
		[self internalDisconnect];
		[self internalClose];
	}
	
	return succeed;
}

- (void)stop
{
	[self disconnect];
}

- (BOOL)connect:(NSString *)addr
{
	return [self connect:addr port:0];
}

- (BOOL)connect:(NSString *)addr port:(NSUInteger)port
{
	if ( nil == addr || 0 == addr.length )
	{
		WARN( @"socket %d, invalid host address", _sock );
		return NO;
	}
	
	NSString *	hostString = addr;
	NSString *	portString = port ? [NSString stringWithFormat:@"%u", port] : nil;

	if ( NSNotFound != [addr rangeOfString:@":"].location )
	{
		NSArray * components = [addr componentsSeparatedByString:@":"];
		if ( components.count >= 2 )
		{
			hostString = [components objectAtIndex:0];
			portString = [components objectAtIndex:1];
		}
	}
	
	if ( NO == [hostString isIPAddress] )
	{
		struct hostent * haddr_ptr = gethostbyname( hostString.UTF8String );
		if ( NULL == haddr_ptr || AF_INET != haddr_ptr->h_addrtype )
		{
			ERROR( @"socket %d, failed to resolve host %@", _sock, hostString );
			return NO;
		}
		
		struct in_addr * inaddr_ptr = (struct in_addr *)haddr_ptr->h_addr;
		if ( NULL == inaddr_ptr )
		{
			ERROR( @"socket %d, failed to resolve host %@", _sock, hostString );
			return NO;
		}
		
		const char * inetHost = (const char *)inet_ntoa( *inaddr_ptr );
		if ( NULL == inetHost )
		{
			ERROR( @"socket %d, failed to resolve host %@", _sock, hostString );
			return NO;
		}
		
		hostString = [NSString stringWithUTF8String:inetHost];
	}
	
	if ( nil == hostString || nil == portString )
	{
		ERROR( @"socket %d, invalid host or port", _sock );
		return NO;
	}

	self.role = BeeSocket.ROLE_CLIENT;
	self.host = hostString;
	self.port = portString.integerValue;

	BOOL succeed = [self internalConnect];
	if ( succeed )
	{
		[self changeState:self.STATE_CONNECTING];
	}
	else
	{
		[self internalDisconnect];
		[self internalClose];
		
		self.host = nil;
		self.port = 0;
	}

	return succeed;
}

- (void)disconnect
{
	if ( _sock )
	{
		if ( self.STATE_CONNECTING == _state || self.STATE_CONNECTED == _state || self.STATE_READY == _state )
		{
			[self changeState:self.STATE_DISCONNECTING];
			[self internalDisconnect];
			[self changeState:self.STATE_DISCONNECTED];

			[self internalClose];
		}
	}
}

- (BOOL)send:(id)data
{
	return [self send:data encoding:NSUTF8StringEncoding];
}

- (BOOL)send:(id)data encoding:(NSStringEncoding)encoding
{
	if ( nil == data )
		return NO;
	
	NSData * raw = [data asNSData];
	if ( raw && raw.length )
	{
		return [self send:(void *)raw.bytes length:raw.length];
	}
	else
	{
		ERROR( @"socket %d, invalid data type", _sock );
		return NO;
	}
}

- (BOOL)send:(void *)bytes length:(NSUInteger)length
{
	[_sendBuffer appendBytes:bytes length:length];

	if ( self.STATE_CONNECTING == _state )
	{
		return YES;
	}
	else if ( self.STATE_CONNECTED == _state || self.STATE_READY == _state )
	{
		NSUInteger sentSize = [self internalSend];
		if ( sentSize > 0 )
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)sendEOL
{
	return [self send:@"\n" length:1];
}

- (BOOL)sendEOF
{
	return [self send:@"\0" length:1];
}

- (BeeSocket *)accept
{
	if ( 0 == _connections.count )
	{
		return nil;
	}
	
	int sock = [(NSNumber *)[_connections objectAtIndex:0] intValue];
	if ( sock < 0 )
	{
		return nil;
	}
	
	BeeSocket *	conn = [BeeSocket socket:sock];
	if ( conn )
	{
		[_connections removeObjectAtIndex:0];
	}
	return conn;
}

- (void)refuse
{
	if ( 0 == _connections.count )
	{
		return;
	}
	
	NSNumber * sockFd = [_connections objectAtIndex:0];
	if ( nil == sockFd )
	{
		return;
	}

	shutdown( sockFd.intValue, SHUT_RDWR );
	close( sockFd.intValue );
	
	[_connections removeObjectAtIndex:0];
}

- (void)refuseAll
{
	NSArray * array = [NSArray arrayWithArray:_connections];
	
	for ( NSNumber * sockFd in array )
	{
		shutdown( sockFd.intValue, SHUT_RDWR );
		close( sockFd.intValue );
	}
	
	[_connections removeAllObjects];
}

- (NSUInteger)readableSize
{
	if ( nil == _readBuffer )
	{
		ERROR( @"socket %d, empty data", _sock );
		return 0;
	}
	
	return _readBuffer.length;
}

- (NSData *)readableData
{
	return _readBuffer;
}

- (NSString *)readableString
{
	return [_readBuffer asNSString];
}

- (NSData *)read
{
	return [self read:_readBuffer.length offset:0 remove:YES];
}

- (NSData *)read:(NSUInteger)length
{
	return [self read:length offset:0 remove:YES];
}

- (NSData *)read:(NSUInteger)length remove:(BOOL)remove
{
	return [self read:length offset:0 remove:remove];
}

- (NSData *)read:(NSUInteger)length offset:(NSUInteger)offset
{
	return [self read:length offset:offset remove:YES];
}

- (NSData *)read:(NSUInteger)length offset:(NSUInteger)offset remove:(BOOL)remove
{
	if ( nil == _readBuffer )
	{
		WARN( @"socket %d, wrong context", _sock );
		return 0;
	}

	if ( offset + length >= _readBuffer.length )
	{
		WARN( @"socket %d, out of range", _sock );
		return nil;
	}

	char *		buffer = (char *)_readBuffer.bytes + offset;
	NSData *	result = [NSData dataWithBytes:buffer length:length];

	if ( result && result.length )
	{
		[_readBuffer replaceBytesInRange:NSMakeRange(offset, length) withBytes:NULL length:0];
		return result;
	}

	return nil;
}

#pragma mark -

- (void)handleEventConnected
{
	if ( self.STATE_CREATED == _state )
	{
		[self changeState:self.STATE_CONNECTING];
	}
	
	INFO( @"socket %d, connected", _sock );
	
	[self stopConnectTimer];
	[self startHeartbeatTimer];
	
	[self changeState:self.STATE_CONNECTED];
	[self changeState:self.STATE_READY silent:YES];
}

- (void)handleEventChunkData:(NSData *)data
{
	INFO( @"socket %d, chunk data", _sock );
	
	[_readBuffer appendData:data];
	
	if ( _readBuffer.length > 0 )
	{
		[self updateReadProgress];

		if ( self.autoConsume )
		{
			[_readBuffer setData:[NSData data]];
		}
	}
}

- (void)handleEventAcceptable:(int)socket
{
	INFO( @"socket %d, acceptable", _sock );
	
	[_connections addObject:[NSNumber numberWithInt:socket]];
	[self updateAcceptable];
}

- (void)handleEventReadable
{
	INFO( @"socket %d, readable", _sock );
	
	[self internalRead];
	
	if ( _readBuffer.length > 0 )
	{
		[self updateReadProgress];
		
		if ( self.autoConsume )
		{
			[_readBuffer setData:[NSData data]];
		}
	}
}

- (void)handleEventWritable
{
	INFO( @"socket %d, writable", _sock );
	
	[self internalSend];
	[self updateSendProgress];
}

- (void)handleEventError:(NSInteger)error
{
	ERROR( @"socket %d, error code = %d", _sock, error );
	
	[self internalError:BeeSocket.ERROR_UNKNOWN];
}

@end

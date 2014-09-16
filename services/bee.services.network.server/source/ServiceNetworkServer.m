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
//	thanks to http://stackoverflow.com/users/243676/escouten and http://stackoverflow.com/posts/4976808/revisions
//	http://stackoverflow.com/questions/938521/iphone-bonjour-nsnetservice-ip-address-and-port
//

#import "ServiceNetworkServer.h"

#pragma mark -

#undef	DEFAULT_PORT
#define DEFAULT_PORT		(3001)

#undef	DEFAULT_TIMEOUT
#define	DEFAULT_TIMEOUT		(10 * 1000.0f)

#pragma mark -

@interface ServiceNetworkServer()
- (void)startServer;
- (void)stopServer;
@end

#pragma mark -

@implementation ServiceNetworkServer
{
	BOOL					_publishing;
	BOOL					_publishded;

	BeeHTTPServer2 *		_server;
	NSNetService *			_publisher;
	NSDictionary *			_lastError;

	BeeServiceBlock			_whenStart;
	BeeServiceBlock			_whenStop;
	BeeServiceBlock			_whenPublished;
	BeeServiceBlock			_whenError;
}

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( NO )

@synthesize publishing = _publishing;
@synthesize published = _publishded;

@synthesize server = _server;
@synthesize publisher = _publisher;
@synthesize lastError = _lastError;

@dynamic RESTART;
@dynamic START;
@dynamic STOP;

@synthesize whenStart = _whenStart;
@synthesize whenStop = _whenStop;
@synthesize whenPublished = _whenPublished;
@synthesize whenError = _whenError;

- (void)load
{
	self.domain = @"local.";
	self.name = [NSString stringWithFormat:@"Bee%@", BEE_VERSION];
	self.type = @"_bee._tcp.";
	self.port = DEFAULT_PORT;
}

- (void)unload
{
	self.lastError = nil;
	
	self.whenStart = nil;
	self.whenStop = nil;
	self.whenPublished = nil;
	self.whenError = nil;
	
	self.publisher = nil;
	self.server = nil;
}

- (void)powerOn
{
}

- (void)powerOff
{
}

- (void)serviceWillActive
{
}

- (void)serviceDidActived
{
}

- (void)serviceWillDeactive
{
}

- (void)serviceDidDeactived
{
}

#pragma mark -

- (void)startServer
{
	if ( _publishing || _publishded )
		return;

	[BeeHTTPServerConfig2 sharedInstance].port = self.port;

	if ( nil == self.server )
	{
		self.server = [[BeeHTTPServer2 alloc] init];
	}
	
	BOOL succeed = [self.server start];
	if ( NO == succeed )
		return;

	if ( nil == self.publisher )
	{
		self.publisher = [[NSNetService alloc] initWithDomain:@"local." type:self.type name:self.name port:self.port];
		if ( self.publisher )
		{
			[self.publisher scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
		}
	}
	
	[self.publisher setDelegate:self];
	[self.publisher publish];
	
	if ( self.whenStart )
	{
		self.whenStart();
	}

	_publishing = YES;
}

- (void)stopServer
{
	if ( self.publisher )
	{
		[self.publisher stop];
		
		self.publisher.delegate = nil;
		self.publisher = nil;
	}

	if ( self.server )
	{
		[self.server stop];
		self.server = nil;
	}

	_publishing = NO;
	_publishded = NO;
	
	if ( self.whenStop )
	{
		self.whenStop();
	}
}

#pragma mark -

- (BeeServiceBlock)START
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self startServer];
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)STOP
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self stopServer];
	};

	return [[block copy] autorelease];
}

#pragma mark -

/* Sent to the NSNetService instance's delegate prior to advertising the service on the network. If for some reason the service cannot be published, the delegate will not receive this message, and an error will be delivered to the delegate via the delegate's -netService:didNotPublish: method.
 */
- (void)netServiceWillPublish:(NSNetService *)sender
{
	
}

/* Sent to the NSNetService instance's delegate when the publication of the instance is complete and successful.
 */
- (void)netServiceDidPublish:(NSNetService *)sender
{
	INFO( @"bonjour '%@' was published", self.type );
	
	if ( self.whenPublished )
	{
		self.whenPublished();
	}
}

/* Sent to the NSNetService instance's delegate when an error in publishing the instance occurs. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants). It is possible for an error to occur after a successful publication.
 */
- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
	INFO( @"bonjour '%@' failed to publish", self.type );
	
	self.lastError = errorDict;
	
	if ( self.whenError )
	{
		self.whenError();
	}
}

/* Sent to the NSNetService instance's delegate when the instance's previously running publication or resolution request has stopped.
 */
- (void)netServiceDidStop:(NSNetService *)sender
{
	INFO( @"bonjour '%@' was stopped", self.type );
}

/* Sent to the NSNetService instance's delegate when the instance is being monitored and the instance's TXT record has been updated. The new record is contained in the data parameter.
 */
- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data
{
	
}

/* Sent to a published NSNetService instance's delegate when a new connection is
 * received. Before you can communicate with the connecting client, you must -open
 * and schedule the streams. To reject a connection, just -open both streams and
 * then immediately -close them.
 
 * To enable TLS on the stream, set the various TLS settings using
 * kCFStreamPropertySSLSettings before calling -open. You must also specify
 * kCFBooleanTrue for kCFStreamSSLIsServer in the settings dictionary along with
 * a valid SecIdentityRef as the first entry of kCFStreamSSLCertificates.
 */
- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
	
}

#pragma mark -

- (id)objectForKeyedSubscript:(id)key
{
	return [[BeeHTTPServerRouter2 sharedInstance] objectForKeyedSubscript:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[[BeeHTTPServerRouter2 sharedInstance] setObject:obj forKeyedSubscript:key];
}

@end

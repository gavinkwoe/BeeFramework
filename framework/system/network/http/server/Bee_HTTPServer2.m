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

#import "Bee_HTTPServer2.h"
#import "Bee_HTTPServerConfig2.h"
#import "Bee_HTTPServerRouter2.h"
#import "Bee_HTTPUtility2.h"
#import "Bee_HTTPConnectionPool2.h"

#pragma mark -

DEF_PACKAGE( BeePackage_HTTP, BeeHTTPServer2, server );

#pragma mark -

#undef	DEFAULT_PORT
#define	DEFAULT_PORT	(3000)

#pragma mark -

@interface BeeHTTPServer2()
{
	BOOL _running;
}
@end

#pragma mark -

@implementation BeeHTTPServer2

DEF_SINGLETON( BeeHTTPServer2 )

@synthesize running = _running;
@synthesize listener = _listener;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.listener = nil;
	}
	return self;
}

- (void)dealloc
{
	[self stop];

	self.listener = nil;

	[super dealloc];
}

- (BOOL)start
{
	if ( _running )
	{
		ERROR( @"HTTP server already running" );
		return NO;
	}

	NSUInteger port = [BeeHTTPServerConfig2 sharedInstance].port;
	NSString * path = [BeeHTTPServerConfig2 sharedInstance].documentPath;
	
	BOOL isDirectory = NO;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
	if ( NO == exists )
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:path
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}

	BeeSocket * sock = [BeeSocket socket];
	if ( sock )
	{
		[sock addResponder:self];
		
		BOOL succeed = [sock listen:port];
		if ( succeed )
		{
			self.listener = sock;
			
			_running = YES;
			return YES;
		}
	}
	
	ERROR( @"HTTP server cannot listen on port %d", port );
	return NO;
}

- (BOOL)stop
{
	if ( NO == _running )
	{
		ERROR( @"HTTP server not running" );
		return NO;
	}

	if ( self.listener )
	{
		[self.listener removeAllResponders];
		[self.listener stop];
		self.listener = nil;
	}
	
	_running = NO;
	return YES;
}

ON_SOCKET( sock )
{
	if ( sock.listenning )
	{
		INFO( @"HTTP server, starting" );
	}
	else if ( sock.acceptable )
	{
		INFO( @"HTTP server, new connection" );

		BeeHTTPConnection2 * connection = [BeeHTTPConnectionPool2 acceptConnectionFrom:sock];
		if ( nil == connection )
		{
			ERROR( @"HTTP server cannot accept new connections" );
		}
	}
	else if ( sock.stopping )
	{
		INFO( @"HTTP server, stopping" );
	}
	else if ( sock.stopped )
	{
		INFO( @"HTTP server, stopped" );
	}
}

@end

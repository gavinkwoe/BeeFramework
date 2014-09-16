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

#import "Bee_HTTPConnection2.h"
#import "Bee_HTTPWorkflow2.h"
#import "Bee_HTTPConnectionPool2.h"

#pragma mark -

@implementation BeeHTTPConnection2

@synthesize socket = _socket;
@synthesize request = _request;
@synthesize response = _response;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.socket = nil;
		self.request = nil;
		self.response = nil;
		
		[self performLoad];
	}
	return self;
}

- (void)dealloc
{
	[self performUnload];
	
	self.socket = nil;
	self.request = nil;
	self.response = nil;

	[super dealloc];
}

#pragma mark -

ON_SOCKET( sock )
{
	if ( sock != self.socket )
	{
		ERROR( @"Invalid socket file handle" );
		
		[sock disconnect];
		return;
	}

	if ( sock.accepting )
	{
		[[BeeHTTPConnectionPool2 sharedInstance] addConnection:self];
	}
	else if ( sock.accepted )
	{
	}
	else if ( sock.readable )
	{
		if ( nil == self.request )
		{
			self.request = [BeeHTTPRequest2 request:sock.readableData];
			if ( self.request )
			{
				self.response = [self.request response];

				[BeeHTTPWorkflow2 process:self];

				[self.socket send:[self.response packIncludeBody:YES]];
				[self.socket disconnect];
			}
		}
	}
	else if ( sock.writable )
	{
	}
	else if ( sock.disconnecting )
	{
	}
	else if ( sock.disconnected )
	{
		[[BeeHTTPConnectionPool2 sharedInstance] removeConnection:self];
	}
}

#pragma mark -

- (BOOL)acceptFrom:(BeeSocket *)listener
{
	if ( nil == listener )
	{
		return NO;
	}

	self.socket = [listener accept];
	if ( nil == self.socket )
	{
		return NO;
	}

	self.socket.autoConsume = NO;
	self.socket.autoHeartbeat = NO;
	self.socket.autoReconnect = NO;
	[self.socket addResponder:self];
	
	return YES;
}

@end

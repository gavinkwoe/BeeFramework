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

#import "ServiceNetworkBrowser.h"

#pragma mark -

#undef	DEFAULT_TIMEOUT
#define	DEFAULT_TIMEOUT		(10 * 1000.0f)

#pragma mark -

typedef union {
	struct sockaddr sa;
	struct sockaddr_in ipv4;
	struct sockaddr_in6 ipv6;
} ip_socket_address;

#pragma mark -

@implementation NSNetService(NetAddress)

@dynamic resolved;
@dynamic resolvedHost;

- (BOOL)resolved
{
	return self.addresses ? YES : NO;
}

- (NSString *)resolvedHost
{
	char buffer[INET6_ADDRSTRLEN];

	for ( NSData * data in self.addresses )
	{
		ip_socket_address * sockaddr = (ip_socket_address *)[data bytes];
		if ( nil == sockaddr )
			continue;
	
		if ( sockaddr->sa.sa_family != AF_INET && sockaddr->sa.sa_family != AF_INET6 )
			continue;

		memset( buffer, 0, INET6_ADDRSTRLEN );

		const char *	ipaddr = NULL;
		int				port = 0;

		if ( sockaddr->sa.sa_family == AF_INET )
		{
			ipaddr	= inet_ntop( sockaddr->sa.sa_family, (void *)&(sockaddr->ipv4.sin_addr), buffer, INET6_ADDRSTRLEN );
			port	= ntohs( sockaddr->ipv4.sin_port );
		}
		else
		{
			ipaddr	= inet_ntop( sockaddr->sa.sa_family, (void *)&(sockaddr->ipv6.sin6_addr), buffer, INET6_ADDRSTRLEN );
			port	= ntohs( sockaddr->ipv6.sin6_port );
		}
			
		if ( ipaddr && port )
		{
			return [NSString stringWithFormat:@"%s:%d", ipaddr, port];
		}
	}
	
	return nil;
}

@end

#pragma mark -

@interface ServiceNetworkBrowser()
- (void)startSearch;
- (void)stopSearch;
- (void)clearResults;
@end

#pragma mark -

@implementation ServiceNetworkBrowser
{
	BOOL					_autoClear;
	BOOL					_searching;
	BOOL					_more;

	NSNetServiceBrowser *	_browser;
	
	NSMutableArray *		_foundDomains;
	NSMutableArray *		_foundServices;
	NSDictionary *			_lastError;

	BeeServiceBlock			_whenStart;
	BeeServiceBlock			_whenStop;
	BeeServiceBlock			_whenUpdate;
	BeeServiceBlock			_whenError;
}

DEF_SINGLETON( ServiceNetworkBrowser )

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( NO )

@synthesize browser = _browser;

@synthesize foundDomains = _foundDomains;
@synthesize foundServices = _foundServices;
@synthesize lastError = _lastError;

@synthesize autoClear = _autoClear;
@synthesize searching = _searching;
@synthesize more = _more;

@dynamic START;
@dynamic STOP;
@dynamic CLEAR;

@synthesize whenStart = _whenStart;
@synthesize whenStop = _whenStop;
@synthesize whenUpdate = _whenUpdate;
@synthesize whenError = _whenError;

- (void)load
{
	self.foundDomains = [NSMutableArray array];
	self.foundServices = [NSMutableArray array];
}

- (void)unload
{
	[self.foundDomains removeAllObjects];
	self.foundDomains = nil;

	[self.foundServices removeAllObjects];
	self.foundServices = nil;

	if ( self.browser )
	{
		[self.browser setDelegate:nil];
		[self.browser stop];
		self.browser = nil;
	}

	self.lastError = nil;
	
	self.whenStart = nil;
	self.whenStop = nil;
	self.whenUpdate = nil;
	self.whenError = nil;
}

- (void)powerOn
{
	if ( nil == self.browser )
	{
		self.browser = [[NSNetServiceBrowser alloc] init];
		
		if ( IOS7_OR_LATER )
		{
			self.browser.includesPeerToPeer = YES;
		}
	}
}

- (void)powerOff
{
	if ( self.browser )
	{
		[self.browser stop];
		self.browser.delegate = nil;
		self.browser = nil;
	}
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

- (void)startSearch
{
	if ( _searching )
		return;
	
	if ( self.browser )
	{
		[self.browser setDelegate:self];
		[self.browser searchForServicesOfType:self.type inDomain:self.domain];
	}
	
	if ( _autoClear )
	{
		[self clearResults];
	}

	if ( self.whenStart )
	{
		self.whenStart();
	}
	
	_more = NO;
	_searching = YES;
}

- (void)stopSearch
{
	if ( NO == _searching )
		return;

	if ( self.browser )
	{
		[self.browser stop];
		[self.browser setDelegate:nil];
	}
	
	if ( self.whenStop )
	{
		self.whenStop();
	}
	
	_searching = NO;
}

- (void)clearResults
{
	[self.foundDomains removeAllObjects];
	[self.foundServices removeAllObjects];
}

#pragma mark -

- (BeeServiceBlock)START
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self startSearch];
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)STOP
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self stopSearch];
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)CLEAR
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self clearResults];
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

/* Sent to the NSNetServiceBrowser instance's delegate before the instance begins a search. The delegate will not receive this message if the instance is unable to begin a search. Instead, the delegate will receive the -netServiceBrowser:didNotSearch: message.
 */
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
	INFO( @"bonjour start search" );
}

/* Sent to the NSNetServiceBrowser instance's delegate when the instance's previous running search request has stopped.
 */
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
	INFO( @"bonjour stop search" );
}

/* Sent to the NSNetServiceBrowser instance's delegate when an error in searching for domains or services has occurred. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants). It is possible for an error to occur after a search has been started successfully.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict
{
	INFO( @"bonjour not found" );
	
	self.lastError = errorDict;
	
	if ( self.whenUpdate )
	{
		self.whenUpdate();
	}
}

/* Sent to the NSNetServiceBrowser instance's delegate for each domain discovered. If there are more domains, moreComing will be YES. If for some reason handling discovered domains requires significant processing, accumulating domains until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing
{
	INFO( @"bonjour '%@' found", domainString );
	
	_more = moreComing;
	
	[self.foundDomains addObject:domainString];
	
	if ( self.whenUpdate )
	{
		self.whenUpdate();
	}
}

/* Sent to the NSNetServiceBrowser instance's delegate for each service discovered. If there are more services, moreComing will be YES. If for some reason handling discovered services requires significant processing, accumulating services until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
	INFO( @"bonjour '%@' found", aNetService.type );
	
	_more = moreComing;
	
	[self.foundServices addObject:aNetService];
		
	if ( self.whenUpdate )
	{
		self.whenUpdate();
	}

	[aNetService setDelegate:self];
	[aNetService resolveWithTimeout:(10.0f * 1000.0f)];
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered domain is no longer available.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing
{
	INFO( @"bonjour '%@' remove", domainString );
	
	[self.foundDomains removeObject:domainString];
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered service is no longer published.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
	INFO( @"bonjour '%@' remove", aNetService.type );
	
	[aNetService setDelegate:nil];
	[aNetService stop];

	[self.foundServices removeObject:aNetService];
}

#pragma mark -

/* Sent to the NSNetService instance's delegate prior to resolving a service on the network. If for some reason the resolution cannot occur, the delegate will not receive this message, and an error will be delivered to the delegate via the delegate's -netService:didNotResolve: method.
 */
- (void)netServiceWillResolve:(NSNetService *)sender
{
}

/* Sent to the NSNetService instance's delegate when one or more addresses have been resolved for an NSNetService instance. Some NSNetService methods will return different results before and after a successful resolution. An NSNetService instance may get resolved more than once; truly robust clients may wish to resolve again after an error, or to resolve more than once.
 */
- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	INFO( @"bonjour '%@' found", sender.type );

	if ( self.whenUpdate )
	{
		self.whenUpdate();
	}
}

/* Sent to the NSNetService instance's delegate when an error in resolving the instance occurs. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants).
 */
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
}

@end

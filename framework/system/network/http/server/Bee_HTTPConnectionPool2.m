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

#import "Bee_HTTPConnectionPool2.h"
#import "Bee_HTTPConnection2.h"
#import "Bee_HTTPWorkflow2.h"

#pragma mark -

@interface BeeHTTPConnectionPool2()
{
	NSMutableArray * _connections;
}
@end

#pragma mark -

@implementation BeeHTTPConnectionPool2

DEF_SINGLETON( BeeHTTPConnectionPool2 )

- (id)init
{
	self = [super init];
	if ( self )
	{
		_connections = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_connections removeAllObjects];
	[_connections release];
	
	[super dealloc];
}

#pragma mark -

- (void)addConnection:(BeeHTTPConnection2 *)conn
{
	[_connections addObject:conn];
}

- (void)removeConnection:(BeeHTTPConnection2 *)conn
{
	[_connections removeObject:conn];
	
	[conn autorelease];
}

- (void)removeAllConnections
{
	[_connections removeAllObjects];
}

#pragma mark -

+ (BeeHTTPConnection2 *)acceptConnectionFrom:(BeeSocket *)listener
{
	ASSERT( listener );
	
	BeeHTTPConnection2 * conn = [[[BeeHTTPConnection2 alloc] init] autorelease];
	if ( conn )
	{
		BOOL succeed = [conn acceptFrom:listener];
		if ( succeed )
		{
			return conn;
		}
	}

	[listener refuse];
	return nil;
}

@end

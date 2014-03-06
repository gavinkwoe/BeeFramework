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

#import "ProcessingResponse.h"
#import "Bee_HTTPWorklet2.h"
#import "Bee_HTTPWorkflow2.h"
#import "Bee_HTTPServerConfig2.h"
#import "Bee_HTTPServerRouter2.h"
#import "Bee_MIME2.h"
#import "Bee_Reachability.h"

#pragma mark -

@implementation ProcessingResponse

- (void)load
{
	self.prio = 400;
}

- (BOOL)processWithWorkflow:(BeeHTTPWorkflow2 *)workflow
{
	BeeHTTPConnection2 *	conn = workflow.connection;
	BeeHTTPServerRouter2 *	router = [BeeHTTPServerRouter2 sharedInstance];
//	BeeHTTPServerConfig2 *	config = [BeeHTTPServerConfig2 sharedInstance];

	conn.response.Server = @"bhttpd";
	conn.response.Date = [[NSDate date] description];

	if ( BeeHTTPStatus_OK != conn.response.status )
	{
		BOOL found = [router routes:[@(conn.response.status) asNSString]];
		if ( NO == found )
		{
			NSString * template = @"<html><body><pre>500 internal error.</pre></body></html>";

			conn.response.status = BeeHTTPStatus_INTERNAL_SERVER_ERROR;
			[conn.response.bodyData appendData:[template asNSData]];
		}
	}
	
	if ( conn.response.bodyData && conn.response.bodyData.length )
	{
		conn.response.ContentLength = [NSString stringWithFormat:@"%lu", (unsigned long)(conn.response.bodyData.length)];
	}

	if ( BeeHTTPMethod_GET == conn.request.method )
	{
		// TODO:
	}
	else if ( BeeHTTPMethod_POST == conn.request.method )
	{
		// TODO:
	}
	else if ( BeeHTTPMethod_HEAD == conn.request.method )
	{
		// TODO:
	}
	else if ( BeeHTTPMethod_PUT == conn.request.method )
	{
		// TODO:
	}
	else if ( BeeHTTPMethod_DELETE == conn.request.method )
	{
		// TODO:
	}

	return YES;
}

@end

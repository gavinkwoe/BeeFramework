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

#import "ProcessingRoutes.h"
#import "Bee_HTTPWorklet2.h"
#import "Bee_HTTPWorkflow2.h"
#import "Bee_HTTPServerConfig2.h"
#import "Bee_HTTPServerRouter2.h"
#import "Bee_MIME2.h"
#import "Bee_Reachability.h"

#pragma mark -

@implementation ProcessingRoutes

- (void)load
{
	self.prio = 300;
}

- (BOOL)processWithWorkflow:(BeeHTTPWorkflow2 *)workflow
{
	BeeHTTPConnection2 *	conn = workflow.connection;
	BeeHTTPServerRouter2 *	router = [BeeHTTPServerRouter2 sharedInstance];
	BeeHTTPServerConfig2 *	config = [BeeHTTPServerConfig2 sharedInstance];

	BOOL		found = NO;
	NSString *	resource = conn.request.resource;
	NSString *	rootPath = config.documentPath;
	
	if ( resource && resource.length )
	{
		found = [router routes:resource];
	}
	else
	{
		found = [router routes:@"/"];
	}

	if ( NO == found )
	{
		NSString *	filePath = [[NSString stringWithFormat:@"%@/%@", rootPath, resource] normalize];
		NSData *	fileData = nil;
		
		BOOL isDirectory = NO;
		BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
		if ( exists && NO == isDirectory )
		{
			fileData = [NSData dataWithContentsOfFile:filePath];
		}
		
		if ( fileData && fileData.length )
		{
			conn.response.ContentType = [BeeMIME2 fromFileExtension:[filePath pathExtension]];
			[conn.response.bodyData appendData:fileData];
			
			found = YES;
		}
	}
	
	if ( NO == found )
	{
		conn.response.status = BeeHTTPStatus_NOT_FOUND;
	}

	return YES;
}

@end

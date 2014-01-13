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

#import "SchemaGenerator.h"
#import "SchemaServer.h"

#pragma mark -

@implementation SchemaServer

@synthesize inputPath = _inputPath;
@synthesize inputFile = _inputFile;
@synthesize port = _port;
@synthesize protocol = _protocol;
@synthesize errorLine = _errorLine;
@synthesize errorDesc = _errorDesc;

- (id)init
{
	self = [super init];
	if ( self )
	{
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (BOOL)start
{
	NSString * filePath = [(NSString *)[NSString stringWithFormat:@"%@/%@", self.inputPath, self.inputFile] normalize];
	NSString * content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
	
	if ( nil == content )
	{
		self.errorLine = 0;
		self.errorDesc = [NSString stringWithFormat:@"Cannot open file '%@'", filePath];
		return NO;
	}
	
	SchemaProtocol * protocol = [[[SchemaProtocol alloc] init] autorelease];
	if ( nil == protocol )
	{
		self.errorLine = 0;
		self.errorDesc = @"Out of memory";
		return NO;
	}
	
	NSError * error = nil;
	BOOL succeed = [protocol parseString:content error:&error];
	if ( NO == succeed )
	{
		NSDictionary * params = error.userInfo;
		NSString * desc = [params stringAtPath:@"NSLocalizedDescription"];
		NSString * line = [params stringAtPath:@"JKLineNumberKey"];
		
		self.errorLine = line.integerValue;
		self.errorDesc = desc;
		return NO;
	}

	bee.http.server.urls[@"/"] = ^
	{
		line( @"<html>" );
		line( @"<body>" );
		
		line( @"%@ by %@<br/>", self.protocol.title, self.protocol.author );
		line( @"<br/>" );
		
		for ( SchemaController * controller in self.protocol.controllers )
		{
			NSString * url;
			url = [NSString stringWithFormat:@"127.0.0.1:%lu/%@", bee.http.server.config.port, controller.relativeUrl];
			url = [url stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
			
			line( @"<a href='http://%@'>%@</a><br/>", url, controller.relativeUrl );
		}

		line( @"</body>" );
		line( @"</html>" );
	};
	
	for ( SchemaController * controller in protocol.controllers )
	{
		NSString * path = controller.relativeUrl;
		if ( path && path.length )
		{
			bee.http.server.urls[path] = ^
			{
				echo( [controller.response JSON] );
			};
		}
	}

	self.protocol = protocol;

	bee.http.server.config.port = self.port;
//	bee.http.server.config.documentPath = nil;
//	bee.http.server.config.temporaryPath = nil;
	
	[bee.http.server start];

	if ( NO == bee.http.server.running )
	{
		self.errorLine = 0;
		self.errorDesc = @"Failed to start HTTP server";
		return NO;
	}
	else
	{
		INFO( @"port: %d", bee.http.server.config.port );
		INFO( @"root: %@", bee.http.server.config.documentPath );
	}

	return YES;
}

@end

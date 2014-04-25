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

#import "Bee_HTTPServerConfig2.h"

#pragma mark -

DEF_PACKAGE( BeeHTTPServer2, BeeHTTPServerConfig2, config );

#pragma mark -

#undef	DEFAULT_PORT
#define	DEFAULT_PORT	(3000)

#pragma mark -

@interface BeeHTTPServer2()
{
	NSUInteger	_port;
	NSString *	_documentPath;
}
@end

#pragma mark -

@implementation BeeHTTPServerConfig2

DEF_SINGLETON( BeeHTTPServerConfig2 )

@synthesize port = _port;
@synthesize documentPath = _documentPath;
@synthesize temporaryPath = _temporaryPath;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.port = DEFAULT_PORT;

	#if (TARGET_OS_MAC)

		char	buff[256] = { 0 };
//		char *	result = getcwd( buff, 256 - 1 );

		self.documentPath = [NSString stringWithUTF8String:buff];
		self.temporaryPath = [NSString stringWithUTF8String:buff];
		
	#elif (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
		
		self.documentPath = [BeeSandbox docPath];
		self.temporaryPath = [BeeSandbox tmpPath];
		
	#endif	// #elif (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	}
	return self;
}

- (void)dealloc
{
	self.documentPath = nil;
	self.temporaryPath = nil;

	[super dealloc];
}

- (void)loadConfig
{
	[self loadConfig:@"config.json"];
}

- (void)loadConfig:(NSString *)path
{
	// TODO:
}

@end

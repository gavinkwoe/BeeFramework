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

#import "ServiceNetwork.h"

#pragma mark -

#undef	DEFAULT_PORT
#define DEFAULT_PORT		(3001)

#pragma mark -

@implementation ServiceNetwork
{
	NSString *				_domain;
	NSString *				_name;
	NSString *				_type;
	NSInteger				_port;
}

DEF_SINGLETON( ServiceNetwork )

@synthesize domain = _domain;
@synthesize name = _name;
@synthesize type = _type;
@synthesize port = _port;

- (void)load
{
	self.domain = @"local.";
	self.name = [NSString stringWithFormat:@"Bee%@", BEE_VERSION];
	self.type = @"_bee._tcp.";
	self.port = DEFAULT_PORT;
}

- (void)unload
{
	self.domain = nil;
	self.name = nil;
	self.type = nil;
	self.port = 0;
}

@end

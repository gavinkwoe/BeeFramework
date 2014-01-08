//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceAlipay_Config.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceAlipay_Config

DEF_SINGLETON( ServiceAlipay_Config )

@synthesize parnter		= _parnter;
@synthesize seller		= _seller;
@synthesize privateKey	= _privateKey;
@synthesize publicKey	= _publicKey;
@synthesize notifyURL	= _notifyURL;

- (void)load
{
	NSDictionary * config = [[NSString fromResource:@"alipay.json"] objectFromJSONString];
	if ( config )
	{
		self.parnter	= [config objectForKey:@"partner"];
		self.seller		= [config objectForKey:@"seller"];
		self.privateKey	= [config objectForKey:@"private_key"];
		self.publicKey	= [config objectForKey:@"public_key"];
		self.notifyURL	= [config objectForKey:@"notify_url"];
	}
}

- (void)unload
{
	self.parnter = nil;
	self.seller = nil;
	self.privateKey = nil;
	self.publicKey = nil;
}

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

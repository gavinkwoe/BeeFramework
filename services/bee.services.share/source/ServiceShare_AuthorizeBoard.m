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

#import "ServiceShare_AuthorizeBoard.h"
#import "ServiceShare.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceShare_AuthorizeBoard

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

DEF_OUTLET( BeeUIWebView,	web );
DEF_OUTLET( BeeUIButton,	close );

@synthesize whenClose = _whenClose;

#pragma mark -

- (void)load
{
}

- (void)unload
{
	self.whenClose = nil;
}

#pragma makr -

ON_CREATE_VIEWS( signal )
{
	SIGNAL_FORWARD( signal );
	
	self.web.scalesPageToFit = YES;
	self.close.image = [[ServiceShare sharedInstance].bundle image:@"share-close.png"];
}

ON_DELETE_VIEWS( signal )
{
	SIGNAL_FORWARD( signal );
}

ON_LAYOUT_VIEWS( signal )
{
	SIGNAL_FORWARD( signal );
}

ON_WILL_APPEAR( signal )
{
	SIGNAL_FORWARD( signal );
	
	self.web.url = self.authorizeURL;
}

ON_DID_APPEAR( signal )
{
	SIGNAL_FORWARD( signal );
}

ON_WILL_DISAPPEAR( signal )
{
	SIGNAL_FORWARD( signal );
}

ON_DID_DISAPPEAR( signal )
{
	SIGNAL_FORWARD( signal );
}

#pragma mark -

ON_SIGNAL3( BeeUIWebView, WILL_START, signal )
{
	SIGNAL_FORWARD( signal );
}

ON_SIGNAL3( BeeUIWebView, DID_START, signal )
{
	SIGNAL_FORWARD( signal );
}

ON_SIGNAL3( BeeUIWebView, DID_FINISH, signal )
{
	SIGNAL_FORWARD( signal );
}

ON_SIGNAL3( BeeUIWebView, DID_FAILED, signal )
{
	SIGNAL_FORWARD( signal );
}

ON_SIGNAL3( BeeUIWebView, DID_LOAD_CANCELLED, signal )
{
	SIGNAL_FORWARD( signal );
	
	//	ServiceShare_SinaWeibo * service = [ServiceShare_SinaWeibo sharedInstance];
	//	[service notifyAuthCancelled];
}

#pragma mark -

ON_SIGNAL3( ServiceShare_AuthorizeBoard, close, signal )
{
	SIGNAL_FORWARD( signal );

	[self.web stopLoading];

	if ( self.whenClose )
	{
		self.whenClose();
	}
}



@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

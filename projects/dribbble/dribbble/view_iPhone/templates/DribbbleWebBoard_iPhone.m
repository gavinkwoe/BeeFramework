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

#import "DribbbleWebBoard_iPhone.h"

#pragma mark -

@implementation DribbbleWebBoard_iPhone

@synthesize url = _url;

SUPPORT_RESOURCE_LOADING(YES)
SUPPORT_AUTOMATIC_LAYOUT(YES)

DEF_OUTLET( BeeUIWebView,				web )
DEF_OUTLET( DribbbleWebBoardTab_iPhone,	tabbar )

- (void)load
{
}

- (void)unload
{
	self.url = nil;
}

#pragma mark -


#pragma mark -

ON_CREATE_VIEWS( signal )
{
//	self.allowedSwipeToBack = YES;
	
	self.view.backgroundColor = SHORT_RGB( 0x444 );
	
	self.navigationBarShown = YES;
	self.navigationBarTitle = @"Dribbble"; // self.shot.title;
	self.navigationBarLeft  = [UIImage imageNamed:@"navigation-back.png"];
	
	self.tabbar.canGoBack = NO;
	self.tabbar.canGoForward = NO;
	self.tabbar.loading = NO;
}

ON_DELETE_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
}

ON_DID_APPEAR( signal )
{
	self.web.url = self.url;
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
	[self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark -

ON_SIGNAL2( BeeUIWebView, signal )
{
	self.tabbar.canGoBack = self.web.canGoBack;
	self.tabbar.canGoForward = self.web.canGoForward;
	
	if ( [signal is:BeeUIWebView.DID_LOAD_FINISH] || [signal is:BeeUIWebView.DID_LOAD_FAILED] || [signal is:BeeUIWebView.DID_LOAD_CANCELLED] )
	{
		self.navigationBarRight = nil;

		self.tabbar.loading = NO;
	}
	else
	{
		BeeUIActivityIndicatorView * activity = [BeeUIActivityIndicatorView spawn];
		[activity startAnimating];
		[activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
		self.navigationBarRight = activity;
		
		self.tabbar.loading = YES;
	}
	
	NSString * title = [self.web stringByEvaluatingJavaScriptFromString:@"document.title"];
	if ( title && title.length )
	{
		self.titleString = title;
	}
}

#pragma mark -

ON_SIGNAL3( DribbbleWebBoardTab_iPhone, go_backward, signal )
{
	if ( self.web.canGoBack )
	{
		[self.web goBack];
	}
}

ON_SIGNAL3( DribbbleWebBoardTab_iPhone, go_forward, signal )
{
	if ( self.web.canGoForward )
	{
		[self.web goForward];
	}
}

ON_SIGNAL3( DribbbleWebBoardTab_iPhone, refresh, signal )
{
	[self.web stopLoading];
	[self.web reload];
}

@end

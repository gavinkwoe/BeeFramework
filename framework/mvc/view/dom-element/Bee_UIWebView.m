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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_UIWebView.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

@interface BeeUIWebView()
{
	NSString *	_loadingURL;
	NSError *	_lastError;
	BOOL		_inited;
}

- (void)initSelf;

@end

#pragma mark -

@implementation BeeUIWebView

DEF_SIGNAL( WILL_START )	// 准备加载
DEF_SIGNAL( DID_START )		// 开始加载
DEF_SIGNAL( DID_LOAD_FINISH )	// 加载成功
DEF_SIGNAL( DID_LOAD_FAILED )	// 加载失败
DEF_SIGNAL( DID_LOAD_CANCELLED )	// 加载取消

@synthesize loadingURL = _loadingURL;
@synthesize lastError = _lastError;

@synthesize navigationType = _navigationType;
@dynamic isLinkClicked;
@dynamic isFormSubmitted;
@dynamic isFormResubmitted;
@dynamic isBackForward;
@dynamic isReload;

@synthesize html;
@synthesize file;
@synthesize resource;
@synthesize url;

- (void)initSelf
{
	if ( NO == _inited )
	{
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.scalesPageToFit = YES;
		self.allowsInlineMediaPlayback = YES;
		self.mediaPlaybackAllowsAirPlay = YES;
		self.mediaPlaybackRequiresUserAction = YES;
		
		for ( UIView * subView in self.subviews )
		{
			for ( UIView * subView2 in subView.subviews )
			{
				if ( [subView2 isKindOfClass:[UIImageView class]] )
				{
					subView2.hidden = YES;
				}
			}
		}
		
		_inited = YES;
		
//		[self load];
		[self performLoad];
	}
}

- (id)init
{
    if( (self = [super initWithFrame:CGRectZero]) )
    {
		[self initSelf];
    }
    return self;	
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
		[self initSelf];
    }
    return self;
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	self.loadingURL = nil;
	self.lastError = nil;

    [super dealloc];
}

#pragma mark -

- (void)setHtml:(NSString *)string
{
	[self loadHTMLString:string baseURL:nil];
}

- (void)setFile:(NSString *)path
{
	NSData * data = [NSData dataWithContentsOfFile:path];
	if ( data )
	{
		[self loadData:data MIMEType:@"text/html" textEncodingName:@"UTF8" baseURL:nil];
	}
}

- (void)setResource:(NSString *)path
{
	NSString * extension = [path pathExtension];
	NSString * fullName = [path substringToIndex:(path.length - extension.length - 1)];

	NSString * path2 = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
	NSData * data = [NSData dataWithContentsOfFile:path2];
	if ( data )
	{
		[self loadData:data MIMEType:@"text/html" textEncodingName:@"UTF8" baseURL:nil];
	}
}

- (void)setUrl:(NSString *)path
{
	if ( nil == path )
		return;
	
	if ( NO == [path hasPrefix:@"http://"] && NO == [path hasPrefix:@"https://"] )
	{
		path = [NSString stringWithFormat:@"http://%@", path];
	}
	
	NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];

	for ( NSHTTPCookie * cookie in cookies )
	{
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
	}
	
	[self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
}

#pragma mark -

- (BOOL)isLinkClicked
{
	return UIWebViewNavigationTypeLinkClicked == _navigationType ? YES : NO;
}

- (BOOL)isFormSubmitted
{
	return UIWebViewNavigationTypeFormSubmitted == _navigationType ? YES : NO;
}

- (BOOL)isFormResubmitted
{
	return UIWebViewNavigationTypeFormResubmitted == _navigationType ? YES : NO;
}

- (BOOL)isBackForward
{
	return UIWebViewNavigationTypeBackForward == _navigationType ? YES : NO;
}

- (BOOL)isReload
{
	return UIWebViewNavigationTypeReload == _navigationType ? YES : NO;
}

#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	self.loadingURL		= request.URL.absoluteString;
	self.navigationType	= navigationType;
	
	if ( nil == self.loadingURL || 0 == self.loadingURL.length )
	{
		ERROR( @"Invalid url" );
		return NO;
	}

//	INFO( @"Loading url '%@'", self.loadingURL );
	
	BeeUISignal * signal = [self sendUISignal:BeeUIWebView.WILL_START];
	if ( nil == signal.returnValue )
		return YES;

	return [signal boolValue];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self sendUISignal:BeeUIWebView.DID_START];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self sendUISignal:BeeUIWebView.DID_LOAD_FINISH];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	self.lastError = error;

	if ( [[error domain] isEqualToString:NSURLErrorDomain] )
	{
		if ( NSURLErrorCancelled == [error code] )
		{
			[self sendUISignal:BeeUIWebView.DID_LOAD_CANCELLED withObject:nil];
			return;
		}
	}

	if ( [error.domain isEqual:@"WebKitErrorDomain"] && error.code == 102 )
	{
		// 据说这个错误可以忽略掉
	}
	else
	{
		ERROR( @"%@", error );

		if ( error.code != 204 )
		{
			[self sendUISignal:BeeUIWebView.DID_LOAD_FAILED withObject:error];
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

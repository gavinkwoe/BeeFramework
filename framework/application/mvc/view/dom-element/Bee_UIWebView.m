//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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
	BOOL	_inited;
}

- (void)initSelf;

@end

#pragma mark -

@implementation BeeUIWebView

DEF_SIGNAL( USER_ACTION_CLICK )		// 链接点击
DEF_SIGNAL( USER_ACTION_SUBMIT )	// 表单提交
DEF_SIGNAL( USER_ACTION_RESUBMIT )	// 表单重新提交
DEF_SIGNAL( USER_ACTION_BACK )		// 回退
DEF_SIGNAL( USER_ACTION_RELOAD )	// 刷新
DEF_SIGNAL( USER_ACTION_OTHER )		// 其他操作

DEF_SIGNAL( WILL_START )			// 准备加载
DEF_SIGNAL( DID_START )				// 开始加载
DEF_SIGNAL( DID_LOAD_FINISH )		// 加载成功
DEF_SIGNAL( DID_LOAD_FAILED )		// 加载失败
DEF_SIGNAL( DID_LOAD_CANCELLED )	// 加载取消

@synthesize html;
@synthesize file;
@synthesize resource;
@synthesize url;

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

- (void)initSelf
{
	if ( NO == _inited )
	{
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		
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
		
		[self load];
	}
}

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
	
	NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];

	for ( NSHTTPCookie * cookie in cookies )
	{
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
	}
	
	[self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
}

- (void)dealloc
{
	[self unload];

    [super dealloc];
}

#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{	
	NSObject * result = nil;
	NSString * absoluteURL = request.URL.absoluteString;
	
	INFO( @"BeeUIWebView, shouldStartLoadWithRequest, url = %@", absoluteURL );
	
	[self sendUISignal:BeeUIWebView.WILL_START withObject:absoluteURL];

	if ( UIWebViewNavigationTypeLinkClicked == navigationType )
	{
		result = [self sendUISignal:BeeUIWebView.USER_ACTION_CLICK withObject:absoluteURL].returnValue;
	}
	else if ( UIWebViewNavigationTypeFormSubmitted == navigationType )
	{
		result = [self sendUISignal:BeeUIWebView.USER_ACTION_SUBMIT withObject:absoluteURL].returnValue;
	}
	else if ( UIWebViewNavigationTypeBackForward == navigationType )
	{
		result = [self sendUISignal:BeeUIWebView.USER_ACTION_BACK withObject:absoluteURL].returnValue;
	}
	else if ( UIWebViewNavigationTypeReload == navigationType )
	{
		result = [self sendUISignal:BeeUIWebView.USER_ACTION_RELOAD withObject:absoluteURL].returnValue;
	}
	else if ( UIWebViewNavigationTypeFormResubmitted == navigationType )
	{
		result = [self sendUISignal:BeeUIWebView.USER_ACTION_RESUBMIT withObject:absoluteURL].returnValue;
	}
	else if ( UIWebViewNavigationTypeOther == navigationType )
	{
		result = [self sendUISignal:BeeUIWebView.USER_ACTION_OTHER withObject:absoluteURL].returnValue;
	}

	if ( result == BeeUISignal.NO_VALUE )
	{
		return NO;
	}
	else // if ( result == BeeUISignal.YES_VALUE )
	{
		return YES;
	}
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self sendUISignal:BeeUIWebView.DID_START withObject:webView.request.URL.absoluteString];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self sendUISignal:BeeUIWebView.DID_LOAD_FINISH withObject:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
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

		[self sendUISignal:BeeUIWebView.DID_LOAD_FAILED withObject:error];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

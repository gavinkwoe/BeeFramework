//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  WebViewBoard.m
//

#import "WebViewBoard.h"

static const CGFloat kToolbarHeight = 44.f;

@implementation WebViewBoard {
    UIToolbar *toolbar_;
}

- (void)refreshUI
{
    UIBarButtonItem *backButton = [toolbar_.items objectAtIndex:0];
    backButton.enabled = self.webView.canGoBack;
    
    UIBarButtonItem *forwardButton = [toolbar_.items objectAtIndex:2];
    forwardButton.enabled = self.webView.canGoForward;
}

- (void)handleUISignal:(BeeUISignal *)signal
{
    [super handleUISignal:signal];
    if ([signal is: BeeUIBoard.CREATE_VIEWS]) {
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", nil)
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self.webView action:@selector(goBack)];
        
        UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                                        target:self.webView
                                                                                        action:@selector(goForward)];
        
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                        target:self.webView
                                                                                        action:@selector(reload)];
        
        UIBarButtonItem *openInSafariButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                            target:self
                                                                                            action:@selector(openInSafari:)];
        
        
        CGRect toolbarFrame = self.view.bounds;
        toolbarFrame.origin.y = CGRectGetHeight(self.view.bounds) - kToolbarHeight;
        toolbarFrame.size.height = kToolbarHeight;
        
        toolbar_ = [[UIToolbar alloc] initWithFrame:toolbarFrame];
        toolbar_.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [toolbar_ setItems:@[backButton,
         flexible, forwardButton,
         flexible, refreshButton,
         flexible, openInSafariButton] animated:NO];
        
        [backButton release];
        [forwardButton release];
        [refreshButton release];
        [openInSafariButton release];
        [flexible release];
        
        CGRect webFrame = self.webView.frame;
        webFrame.size.height -= kToolbarHeight;
        self.webView.frame = webFrame;
        [self.view addSubview:toolbar_];
        [self.view bringSubviewToFront:toolbar_];
        
        [self refreshUI];
    } else if ([signal is:BeeUIBoard.LAYOUT_VIEWS]) {
        CGRect toolbarF = self.view.bounds;
        toolbarF.origin.y = CGRectGetHeight(toolbarF) - kToolbarHeight;
        toolbarF.size.height = kToolbarHeight;
        [toolbar_ setFrame: toolbarF];
    } else if ([signal is:BeeUIBoard.DELETE_VIEWS]) {
        [toolbar_ release]; toolbar_ = nil;
    } else if ([signal is:BeeUIBoard.WILL_APPEAR]) {

    } else if ([signal is:BeeUIBoard.WILL_DISAPPEAR]) {

    } else if ([signal is: BeeUIBoard.LOAD_DATAS]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://3g.qq.com"]]];
    } else if ([signal is: BeeUIWebView.DID_LOAD_FINISH]) {
        [self refreshUI];
    }
}

- (void)openInSafari:(id)sender
{
    NSURL *url = [self.webView request].URL;
    [[UIApplication sharedApplication] openURL:url];    
}


@end

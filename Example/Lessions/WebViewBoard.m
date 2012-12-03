//
//  WebViewBoard.m
//  WhatsBug
//
//  Created by cui on 12-11-26.
//  Copyright (c) 2012年 tencent. All rights reserved.
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

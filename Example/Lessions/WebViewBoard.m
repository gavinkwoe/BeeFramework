//
//  WebViewBoard.m
//  WhatsBug
//
//  Created by cui on 12-11-26.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "WebViewBoard.h"

@implementation WebViewBoard {
    UIBarButtonItem *backButton_;
    UIBarButtonItem *forwardButton_;
    UIBarButtonItem *refreshButton_;
    UIBarButtonItem *openInSafariButton_;
    
    BOOL toolBarWasHidden_;
}

- (void)refreshUI
{
    backButton_.enabled = self.webView.canGoBack;
    forwardButton_.enabled = self.webView.canGoForward;
}

- (void)handleUISignal:(BeeUISignal *)signal
{
    [super handleUISignal:signal];
    if ([signal is: BeeUIBoard.CREATE_VIEWS]) {
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        backButton_ = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", nil)
                                                      style:UIBarButtonItemStyleBordered
                                                     target:self.webView action:@selector(goBack)];

        forwardButton_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                       target:self.webView
                                                                       action:@selector(goForward)];

        refreshButton_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                       target:self.webView
                                                                       action:@selector(reload)];
        
        openInSafariButton_ = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                           target:self
                                                                           action:@selector(openInSafari:)];
        
        self.toolbarItems = @[backButton_,
        flexible, forwardButton_,
        flexible, refreshButton_,
        flexible, openInSafariButton_];
        
        [flexible release];
        
        [self refreshUI];
    } else if ([signal is:BeeUIBoard.DELETE_VIEWS]) {
        [self.webView removeObserver:self forKeyPath:nil];
        
        [backButton_ release]; backButton_ = nil;
        [forwardButton_ release]; forwardButton_ = nil;
        [refreshButton_ release]; refreshButton_ = nil;
        [openInSafariButton_ release]; openInSafariButton_ = nil;
    } else if ([signal is:BeeUIBoard.WILL_APPEAR]) {
        toolBarWasHidden_ = self.navigationController.isToolbarHidden;
        [self.navigationController setToolbarHidden:NO];
    } else if ([signal is:BeeUIBoard.WILL_APPEAR]) {
        [self.navigationController setToolbarHidden:toolBarWasHidden_];
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

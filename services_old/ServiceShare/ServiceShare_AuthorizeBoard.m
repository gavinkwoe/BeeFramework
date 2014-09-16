//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  ServiceShare_AuthorizeBoard.m
//  ShareService
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "ServiceShare_AuthorizeBoard.h"
#import "ServiceShare.h"

#define kPadding 10.0f

#pragma mark -

@implementation ServiceShare_AuthorizeBoard

#pragma mark - Signal


ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        self.view.backgroundColor = [UIColor clearColor];
        
        _background = [BeeUICell spawn];
        _background.backgroundColor = [UIColor grayColor];
        _background.layer.masksToBounds = NO;
        _background.layer.cornerRadius = kPadding;
        [self.view addSubview:_background];
        
        _webView = [UIWebView spawn];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        _webView.layer.masksToBounds = YES;
        _webView.layer.cornerRadius = kPadding;
        [_background addSubview:_webView];
        
        _close = [BeeUIButton spawn];
        _close.image = [[ServiceShare sharedInstance].bundle image:@"share-close.png"];
        [_close addTarget:self action:@selector(close)
         forControlEvents:UIControlEventTouchUpInside];
        _close.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_background addSubview:_close];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        CGRect frame = self.viewBound;
        
        frame.origin.x += kPadding;
        frame.origin.y += kPadding;
        frame.size.width -= kPadding * 2;
        frame.size.height -= kPadding * 2;
        _background.frame = frame;
        
        frame.size.width -= kPadding * 2;
        frame.size.height -= kPadding * 2;
        _webView.frame = frame;
        
        _close.frame = CGRectMake( frame.size.width - 40, -40, 100, 100 );

    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        NSString * urlString = self.authorizeURL;
        
        if ( urlString && urlString.length )
        {
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        }
        else
        {
            // 授权失败，无回调地址
            [self postNotification:ServiceShareApi.AUTHORIZE_FAILURE];
        }
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

- (void)close
{
    [self postNotification:ServiceShareApi.AUTHORIZE_CANCEL];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self presentLoadingTips:@"正在加载"].useMask = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [self dismissTips];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self dismissTips];
    
    if ( -1009 == error.code && [[error domain] isEqualToString:@"NSURLErrorDomain"]) // network error
    {
        [self postNotification:ServiceShareApi.AUTHORIZE_FAILURE];   
    }
}

@end

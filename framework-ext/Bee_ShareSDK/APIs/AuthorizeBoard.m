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
//  AuthorizeBoard.m
//  BeeSNS
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "AuthorizeBoard.h"

#define kTransitionDuration 0.35f
#define kPadding 5.0f

#pragma mark -

@implementation AuthorizeBoard

#pragma mark - Signal

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.view.autoresizesSubviews = YES;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view.contentMode = UIViewContentModeRedraw;
		
        self.view.backgroundColor = [UIColor grayColor];
        self.view.layer.cornerRadius = kPadding;
        
		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT title:@"关闭"];
        
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.layer.masksToBounds = YES;
        _webView.layer.cornerRadius = kPadding;
        [self.view addSubview:_webView];
        
        UIImage * closeImage = [UIImage imageNamed:@"share-close.png"];
        _close = [UIButton buttonWithType:UIButtonTypeCustom];
        [_close setImage:closeImage forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(cancel)
         forControlEvents:UIControlEventTouchUpInside];
        _close.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:_close];
    }
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{   
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        if ( self.authorizeUrl )
        {
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.authorizeUrl]]];
        }
        else
        {
            [self presentFailureTips:@"页面打开失败"];
        }
	}
}

#pragma mark -

- (void)showIn:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.x += kPadding;
    frame.origin.y += kPadding;
    frame.size.width -= kPadding * 2;
    frame.size.height -= kPadding * 2;
    self.view.frame = frame;
    
    frame.size.width -= kPadding * 2;
    frame.size.height -= kPadding * 2;
    _webView.frame = frame;
    
    _close.frame = CGRectMake( frame.size.width - 15 + kPadding, -9, 29, 29 );
    
    self.view.transform = CGAffineTransformScale( CGAffineTransformIdentity, 0.6, 0.6 );
    
    [view addSubview:self.view];
    
    [UIView animateWithDuration:kTransitionDuration/2 animations:^{
        self.view.transform = \
        CGAffineTransformScale( CGAffineTransformIdentity, 1.1, 1.1 );
    } completion: ^(BOOL finished){
        [UIView animateWithDuration:kTransitionDuration animations:^{
            self.view.transform = \
            CGAffineTransformScale( CGAffineTransformIdentity, 0.9, 0.9 );
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kTransitionDuration/2 animations:^{
                self.view.transform = \
                CGAffineTransformIdentity;
            }];
        }];
    }];
}

- (void)hide
{
    [_webView stopLoading];
    
    [UIView animateWithDuration:kTransitionDuration animations:^{
        self.view.transform = \
        CGAffineTransformScale( CGAffineTransformIdentity, 0.3, 0.3 );
        self.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if ( finished )
        {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)cancel
{
    [self hide];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self presentLoadingTips:@"正在加载"];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [self dismissTips];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self dismissTips];
}

@end

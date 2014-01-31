//
//  WebViewBoard_iPhone.m
//  ActionInChina
//
//  Created by QFish on 4/16/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"

#pragma mark -

@implementation WebViewBoard_iPhone
{
	BOOL _showLoading;
    UIToolbar * _toolbar;
    
    UIBarButtonItem * _back;
    UIBarButtonItem * _stop;
    UIBarButtonItem * _forward;
    UIBarButtonItem * _refresh;
    UIBarButtonItem * _flexible;
	UIBarButtonItem * _fixed;
}

@synthesize showLoading = _showLoading;
@synthesize useHTMLTitle = _useHTMLTitle;

@synthesize toolbar = _toolbar;
@synthesize defaultTitle = _defaultTitle;

@synthesize backBoard = _backBoard;

- (void)load
{
	[super load];
	
	self.showLoading = YES;
	self.isToolbarHiden = NO;
}

- (void)unload
{
	self.htmlString = nil;
	self.urlString = nil;
	self.defaultTitle = nil;
	
	[super unload];
}

#pragma mark [B] UISignal

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.view.backgroundColor = HEX_RGB( 0xdfdfdf );

        [self showNavigationBarAnimated:NO];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back.png"]];
        
		if ( self.defaultTitle && self.defaultTitle.length )
		{
			self.titleString = self.defaultTitle;
		}
		else
		{
			self.titleString = @"浏览器";
		}
        
        _webView = [[BeeUIWebView alloc] init];
        _webView.scalesPageToFit = YES;
        [self.view addSubview:_webView];
        
        if ( !_isToolbarHiden )
        {
            _toolbar = [[UIToolbar alloc] init];
            _toolbar.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
			_toolbar.backgroundColor = [UIColor clearColor];
            _toolbar.tintColor = [UIColor grayColor];
			_toolbar.translucent = YES;
			
            [self.view addSubview:_toolbar];
        }
        
        [self setupToolbar];
		[self updateUI];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        [self.webView stopLoading];
        
        SAFE_RELEASE( _back );
        SAFE_RELEASE( _stop );
        SAFE_RELEASE( _forward );
        SAFE_RELEASE( _refresh );
        SAFE_RELEASE( _urlString );
		
		SAFE_RELEASE( _flexible );
		SAFE_RELEASE( _fixed );
		
        SAFE_RELEASE_SUBVIEW( _webView );
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		if ( _isToolbarHiden )
		{
			_webView.frame = self.view.bounds;
		}
		else
		{
			int toolbarHeight = 44.0f;

			CGRect frame = self.view.frame;
			frame.size.height -= toolbarHeight;
            if ( IOS7_OR_EARLIER )
            {
                frame.origin.y = 0;
            }
			_webView.frame = frame;
			
			frame.origin.y += frame.size.height;
			frame.size.height = toolbarHeight;
			_toolbar.frame = frame;
		}
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
	}
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
		bee.ext.appBoard.menuShown = NO;

		if ( self.firstEnter )
		{
			[self refresh];
		}
	}
}

ON_LEFT_BUTTON_TOUCHED( signal )
{
	if ( self.backBoard )
	{
		[self.stack popToBoard:self.backBoard animated:YES];
	}
	else
	{
		[self.stack popBoardAnimated:YES];
	}
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark -

- (void)refresh
{
    if ( self.urlString )
    {
//        if ( [self.urlString isUrl]  )
//        {
             self.webView.url = self.urlString;
//        }
//        else
//        {
//            [self.stack performSelector:@selector(popBoardAnimated:) withObject:@YES afterDelay:2.0];
//        }
    }
    else if ( self.htmlString )
    {
        self.webView.html = self.htmlString;
    }
}

- (void)updateUI
{
	if ( self.useHTMLTitle )
	{
		NSString * title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
		if ( title && title.length )
		{
			self.titleString = title;
		}
	}
	
	_back.enabled = self.webView.canGoBack;
	_forward.enabled = self.webView.canGoForward;
		
	if ( _webView.loading )
	{
        [_toolbar setItems:@[ _flexible, _back, _flexible, _forward, _flexible, _flexible, _flexible, _stop, _flexible ] animated:NO];
    }
    else
    {
        [_toolbar setItems:@[ _flexible, _back, _flexible, _forward, _flexible, _flexible, _flexible, _refresh , _flexible] animated:NO];
    }
}

#pragma mark -

- (void)setupToolbar
{
    _flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	
    _back = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser-baritem-back.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self.webView
                                    action:@selector(goBack)];
    
    _forward = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser-baritem-forward.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self.webView
                                    action:@selector(goForward)];
    
    _refresh = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser-baritem-refresh.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self.webView
                                    action:@selector(reload)];

    _stop = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser-baritem-stop.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self.webView
                                    action:@selector(stopLoading)];
    
}

#pragma mark - UIWebViewDelegate

ON_SIGNAL2( BeeUIWebView, signal )
{
	[self updateUI];
    
    if ( [signal is:BeeUIWebView.DID_START] )
    {
		if ( _showLoading )
		{
			BeeUIActivityIndicatorView * activity = [BeeUIActivityIndicatorView spawn];
			[activity startAnimating];
			[activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
			[self showBarButton:BeeUINavigationBar.RIGHT custom:activity];
//			[self presentLoadingTips:__TEXT(@"tips_loading")].useMask = NO;
		}
    }
    else if ( [signal is:BeeUIWebView.DID_LOAD_FINISH] )
    {
		if ( _showLoading )
		{
			[self dismissTips];
			[self hideBarButton:BeeUINavigationBar.RIGHT];
//			[self presentSuccessTips:@"加载成功"];
		}
    }
    else if ( [signal is:BeeUIWebView.DID_LOAD_CANCELLED] )
    {
		if ( _showLoading )
		{
			[self dismissTips];
			[self hideBarButton:BeeUINavigationBar.RIGHT];
//			[self presentSuccessTips:@"取消加载"];
		}
    }
    else if( [signal is:BeeUIWebView.DID_LOAD_FAILED] )
    {
		if ( _showLoading )
		{
			[self dismissTips];
			[self hideBarButton:BeeUINavigationBar.RIGHT];
			
			[self presentSuccessTips:__TEXT(@"error_network")];
		}
    }
}

@end

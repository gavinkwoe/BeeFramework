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
//  AuthorizeBoard.h
//  BeeSNS
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "Bee.h"
#import "BeeShareApi.h"

#pragma mark -

@interface AuthorizeBoard : BeeUIBoard<UIWebViewDelegate>
{
    UIButton * _close;
}

@property (nonatomic, retain) NSString  * authorizeUrl;
@property (nonatomic, retain) UIWebView * webView;

- (void)hide;
- (void)showIn:(UIView *)view;

@end

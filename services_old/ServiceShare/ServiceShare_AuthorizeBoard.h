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
//  ServiceShare_AuthorizeBoard.h
//  ShareService
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface ServiceShare_AuthorizeBoard : BeeUIBoard<UIWebViewDelegate>
{
    BeeUIButton *  _close;
    BeeUICell *    _background;
}

@property (nonatomic, retain) NSString * authorizeURL;
@property (nonatomic, retain) UIWebView * webView;

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal;

@end

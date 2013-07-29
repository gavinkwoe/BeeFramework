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
//  RenrenApi.h
//  BeeSNS
//
//  Created by QFish on 4/26/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "BeeShareApi.h"
#import "RenrenModel.h"
#import "RenrenAuthorizeBoard.h"

#define kRenrenAppKey                   @"6044c7868ff54f7a86dfe49d061ceb36"
#define kRenrenAppSecret                @"f749413a5cf7416d9b765b44ff607c6b"
#define kRenrenAppRedirectURI           @"http://graph.renren.com/oauth/login_success.html"

//授权及api相关
#define kAuthBaseURL            @"http://graph.renren.com/oauth/authorize"
#define kDialogBaseURL          @"http://widget.renren.com/dialog/"
#define kRestserverBaseURL      @"http://api.renren.com/restserver.do"
#define kRRSessionKeyURL        @"http://graph.renren.com/renren_api/session_key"
#define kRRSuccessURL           @"http://widget.renren.com/callback.html"
#define kSDKversion             @"3.0"
#define kPasswordFlowBaseURL    @"https://graph.renren.com/oauth/token"

//支付相关
#define kPaySuccessURL      @"rrpay://success"
#define kPayFailURL         @"rrpay://error"
#define kRepairSuccessURL   @"rrpay://repairsuccess"
#define kRepairFailURL      @"rrpay://repairerror"
#define kDirectPayURL       @"http://mpay.renren.com/pay/main/ui/entry/deposit/payment.do"
#define kIPhonePaySDK       @"1"
#define kSubmitOrderURL     @"https://graph.renren.com/spay/iphone/test/submitOrder"
#define kFixOrderURL        @"https://graph.renren.com/spay/iphone/test/fixOrder"
#define kTestSubmitOrderURL     @"https://graph.renren.com/spay/iphone/test/submitOrder"
#define kTestFixOrderURL        @"https://graph.renren.com/spay/iphone/test/fixOrder"
#define kCheckAppStatusURL  @"https://graph.renren.com/spay/appStatus"
#define kIsTestOrder        @"true"
#define kIsNotTestOrder     @"false"
#define kPaySuccessCode     @"102"

//dialog相关
#define kWidgetURL @"http://widget.renren.com/callback.html"
#define kWidgetDialogURL @"//widget.renren.com/dialog"
#define kWidgetDialogUA @"18da8a1a68e2ee89805959b6c8441864"
#pragma mark -

@interface Renren : BeeShareApi

@property (nonatomic, retain) RenrenAuth * auth;

AS_SINGLETON( Renren )
AS_MESSAGE( users_getLoggedInUser )

@end

//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "Bee.h"
#import "ServiceShare.h"
#import "ServiceShare_Weixin_Config.h"
#import "ServiceShare_Weixin_Post.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "WXApi.h"

#pragma mark -

@interface ServiceShare_Weixin : ServiceShare<WXApiDelegate>

AS_SINGLETON( ServiceShare_Weixin )

AS_NUMBER( ERROR_NOT_INSTALL )
AS_NUMBER( ERROR_NOT_SUPPORT )

@property (nonatomic, readonly) ServiceShare_Weixin_Config *	config;
@property (nonatomic, readonly) ServiceShare_Weixin_Post *		post;

@property (nonatomic, readonly) BOOL							installed;
@property (nonatomic, retain) NSNumber *						errorCode;
@property (nonatomic, retain) NSString *						errorDesc;

@property (nonatomic, readonly) BeeServiceBlock					SHARE_TO_FRIEND;
@property (nonatomic, readonly) BeeServiceBlock					SHARE_TO_TIMELINE;

@property (nonatomic, readonly) BeeServiceBlock					OPEN_WEIXIN;
@property (nonatomic, readonly) BeeServiceBlock					OPEN_STORE;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

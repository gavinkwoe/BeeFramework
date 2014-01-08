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
#import "ServiceShare_TencentWeibo_Config.h"
#import "ServiceShare_TencentWeibo_Post.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface ServiceShare_TencentWeibo : ServiceShare

AS_SINGLETON( ServiceShare_TencentWeibo )

@property (nonatomic, readonly) ServiceShare_TencentWeibo_Config *	config;
@property (nonatomic, readonly) ServiceShare_TencentWeibo_Post *	post;

@property (nonatomic, retain) NSString *						openid;
@property (nonatomic, retain) NSString *						openkey;
@property (nonatomic, retain) NSString *						accessToken;
@property (nonatomic, retain) NSString *						refreshToken;
@property (nonatomic, retain) NSNumber *						expiresIn;

@property (nonatomic, readonly) BOOL							isAuthorized;
@property (nonatomic, readonly) BOOL							isExpired;

@property (nonatomic, retain) NSString *						errorMsg;
@property (nonatomic, retain) NSString *						errorSeqId;
@property (nonatomic, retain) NSString *						errorCode;

@property (nonatomic, readonly) BeeServiceBlock					AUTHORIZE;
@property (nonatomic, readonly) BeeServiceBlock					SHARE;
@property (nonatomic, readonly) BeeServiceBlock					CANCEL;
@property (nonatomic, readonly) BeeServiceBlock					CLEAR;

- (void)notifyAuthBegin;
- (void)notifyAuthSucceed;
- (void)notifyAuthFailed;
- (void)notifyAuthCancelled;

- (void)notifyShareBegin;
- (void)notifyShareSucceed;
- (void)notifyShareFailed;
- (void)notifyShareCancelled;

- (void)saveCache;
- (void)loadCache;
- (void)deleteCache;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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
#import "ServiceAlipay_Config.h"
#import "ServiceAlipay_Order.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface ServiceAlipay : BeeService

@property (nonatomic, readonly) ServiceAlipay_Order *	order;
@property (nonatomic, readonly) ServiceAlipay_Config *	config;

@property (nonatomic, assign) NSUInteger				errorCode;
@property (nonatomic, retain) NSString *				errorDesc;

@property (nonatomic, copy) BeeServiceBlock				whenWaiting;
@property (nonatomic, copy) BeeServiceBlock				whenSucceed;
@property (nonatomic, copy) BeeServiceBlock				whenFailed;

@property (nonatomic, readonly) BeeServiceBlock			PAY;

AS_INT( ERROR_SUCCEED )
AS_INT( ERROR_SYS_ERROR )
AS_INT( ERROR_BAD_FORMAT )
AS_INT( ERROR_BAD_ACCOUNT )
AS_INT( ERROR_UNBINDED )
AS_INT( ERROR_CANNOT_BIND )
AS_INT( ERROR_CANNOT_PAY )
AS_INT( ERROR_EXPIRED )
AS_INT( ERROR_MAINTENANCE )
AS_INT( ERROR_USER_CANCEL )

AS_INT( ERROR_INVALID_DATA )
AS_INT( ERROR_INSTALL_ALIPAY )
AS_INT( ERROR_SIGNATURE )

AS_NOTIFICATION( WAITING )
AS_NOTIFICATION( SUCCEED )
AS_NOTIFICATION( FAILED )

- (BOOL)pay;

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

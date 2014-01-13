//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"
#import "Bee_UISignal.h"
#import "Bee_UICapability.h"

#pragma mark -

@interface BeeUIWebView : UIWebView<UIWebViewDelegate>

AS_SIGNAL( WILL_START )		// 准备加载
AS_SIGNAL( DID_START )		// 开始加载
AS_SIGNAL( DID_LOAD_FINISH )		// 加载成功
AS_SIGNAL( DID_LOAD_FAILED )		// 加载失败
AS_SIGNAL( DID_LOAD_CANCELLED )	// 加载取消

@property (nonatomic, retain) NSString *				loadingURL;
@property (nonatomic, retain) NSError *					lastError;

@property (nonatomic, assign) UIWebViewNavigationType	navigationType;
@property (nonatomic, readonly) BOOL					isLinkClicked;
@property (nonatomic, readonly) BOOL					isFormSubmitted;
@property (nonatomic, readonly) BOOL					isFormResubmitted;
@property (nonatomic, readonly) BOOL					isBackForward;
@property (nonatomic, readonly) BOOL					isReload;

@property (nonatomic, assign) NSString *	html;
@property (nonatomic, assign) NSString *	file;
@property (nonatomic, assign) NSString *	resource;
@property (nonatomic, assign) NSString *	url;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

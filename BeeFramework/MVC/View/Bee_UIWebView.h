//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  Bee_UIWebView.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bee_UISignal.h"

#pragma mark -

@interface BeeUIWebView : UIWebView<UIWebViewDelegate>

AS_SIGNAL( USER_ACTION_CLICK )		// 链接点击
AS_SIGNAL( USER_ACTION_SUBMIT )		// 表单提交
AS_SIGNAL( USER_ACTION_RESUBMIT )	// 表单重新提交
AS_SIGNAL( USER_ACTION_BACK )		// 回退
AS_SIGNAL( USER_ACTION_RELOAD )		// 刷新
AS_SIGNAL( USER_ACTION_OTHER )		// 其他操作

AS_SIGNAL( DID_START )				// 开始加载
AS_SIGNAL( DID_LOAD_FINISH )		// 加载成功
AS_SIGNAL( DID_LOAD_FAILED )		// 加载失败
AS_SIGNAL( DID_LOAD_CANCELLED )		// 加载取消

@property (nonatomic, assign) NSString * html;
@property (nonatomic, assign) NSString * file;
@property (nonatomic, assign) NSString * resource;
@property (nonatomic, assign) NSString * url;

+ (BeeUIWebView *)spawn;

@end

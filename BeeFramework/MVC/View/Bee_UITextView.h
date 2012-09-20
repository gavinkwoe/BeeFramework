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
//  Bee_UITextView.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bee_UISignal.h"

#pragma mark -

@class BeeUITextViewAgent;

@interface BeeUITextView : UITextView
{
	BeeUITextViewAgent *	_agent;
    NSString *				_placeholder;
    UIColor *				_placeHolderColor;
    UILabel *				_placeHolderLabel;
}

AS_SIGNAL( WILL_ACTIVE )		// 将要获取焦点
AS_SIGNAL( DID_ACTIVED )		// 已经获取焦点
AS_SIGNAL( WILL_DEACTIVE )		// 已经丢失焦点
AS_SIGNAL( DID_DEACTIVED )		// 已经丢失焦点
AS_SIGNAL( TEXT_CHANGED )		// 文字变了
AS_SIGNAL( SELECTION_CHANGED )	// 光标位置

@property (nonatomic, retain) NSString *	placeholder;
@property (nonatomic, retain) UILabel *		placeHolderLabel;
@property (nonatomic, retain) UIColor *		placeHolderColor;

+ (BeeUITextView *)spawn;

- (void)updatePlaceHolder;
- (void)setActive:(BOOL)flag;
@end

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
//  Bee_UIActionSheet.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bee_UISignal.h"

#pragma mark -

@interface BeeUIActionSheet : UIActionSheet<UIActionSheetDelegate>
{
	UIViewController *		_parentController;
	NSMutableArray *		_actions;
	NSObject *				_userData;
}

AS_SIGNAL( WILL_PRESENT )	// 将要显示
AS_SIGNAL( DID_PRESENT )	// 已经显示
AS_SIGNAL( WILL_DISMISS )	// 将要隐藏
AS_SIGNAL( DID_DISMISS )	// 已经隐藏

@property (nonatomic, assign) UIViewController *	parentController;
@property (nonatomic, retain) NSObject *			userData;

+ (BeeUIActionSheet *)spawn;

- (void)presentForController:(UIViewController *)controller;

- (void)addCancelTitle:(NSString *)title;
- (void)addCancelTitle:(NSString *)title signal:(NSString *)signal object:(NSObject *)object;
- (void)addButtonTitle:(NSString *)title signal:(NSString *)signal object:(NSObject *)object;
- (void)addDestructiveTitle:(NSString *)title signal:(NSString *)signal object:(NSObject *)object;

@end

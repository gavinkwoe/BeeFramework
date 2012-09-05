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
//  Bee_UIButton.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bee_UISignal.h"

#pragma mark -

//typedef void (^BeeButtonBlock)( UIView * view );

@class BeeUIButton;

@interface BeeUIButtonState : NSObject
{
	BeeUIButton *	_button;
	UIControlState	_state;
}

@property (nonatomic, assign) BeeUIButton *		button;
@property (nonatomic, assign) UIControlState	state;
@property (nonatomic, assign) NSString *		title;
@property (nonatomic, assign) UIColor *			titleColor;
@property (nonatomic, assign) UIColor *			titleShadowColor;
@property (nonatomic, assign) UIImage *			image;
@property (nonatomic, assign) UIImage *			backgroundImage;

@end

#pragma mark -

@interface BeeUIButton : UIButton
{
	NSMutableArray *	_actions;
	UILabel *			_label;
	
//	BeeButtonBlock		_touchDown;
//	BeeButtonBlock		_touchDownRepeat;
//	BeeButtonBlock		_touchUpInside;
//	BeeButtonBlock		_touchUpOutside;
//	BeeButtonBlock		_touchUpCancel;
	
	BeeUIButtonState *	_stateNormal;
	BeeUIButtonState *	_stateHighlighted;
	BeeUIButtonState *	_stateDisabled;
	BeeUIButtonState *	_stateSelected;
}

AS_SIGNAL( TOUCH_DOWN )			// 按下
AS_SIGNAL( TOUCH_DOWN_REPEAT )	// 长按
AS_SIGNAL( TOUCH_UP_INSIDE )	// 抬起（击中）
AS_SIGNAL( TOUCH_UP_OUTSIDE )	// 抬起（未击中）
AS_SIGNAL( TOUCH_UP_CANCEL )	// 撤销

@property (nonatomic, retain) NSString *			title;
@property (nonatomic, retain) UIColor *				titleColor;

@property (nonatomic, readonly) BeeUIButtonState *	stateNormal;
@property (nonatomic, readonly) BeeUIButtonState *	stateHighlighted;
@property (nonatomic, readonly) BeeUIButtonState *	stateDisabled;
@property (nonatomic, readonly) BeeUIButtonState *	stateSelected;

+ (BeeUIButton *)spawn;

- (void)addSignal:(NSString *)signal forControlEvents:(UIControlEvents)controlEvents;
- (void)addSignal:(NSString *)signal forControlEvents:(UIControlEvents)controlEvents object:(NSObject *)object;

@end

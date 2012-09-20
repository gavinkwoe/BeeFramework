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
//  Bee_UIKeyboard.h
//

#import "NSObject+BeeNotification.h"
#import "Bee_UISignal.h"
#import "Bee_Singleton.h"
#import "NSObject+BeeNotification.h"

#pragma mark -

@interface BeeUIKeyboard : NSObject
{
	BOOL		_shown;
	CGFloat		_height;

	CGRect		_accessorFrame;
	UIView *	_accessor;
}

AS_SINGLETON( BeeUIKeyboard )

AS_NOTIFICATION( SHOWN )			// 键盘弹出
AS_NOTIFICATION( HIDDEN )			// 键盘收起
AS_NOTIFICATION( HEIGHT_CHANGED )	// 输入法切换

@property (nonatomic, readonly) BOOL	shown;
@property (nonatomic, readonly) CGFloat	height;

- (void)showAccessor:(UIView *)view animated:(BOOL)animated;
- (void)hideAccessor:(UIView *)view animated:(BOOL)animated;
- (void)updateAccessorAnimated:(BOOL)animated;

@end

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
//  Bee_UIPullLoader.h
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"

#pragma mark -

@class BeeUIActivityIndicatorView;

@interface BeeUIPullLoader : UIView
{
	NSInteger						_state;
	UIImageView *					_arrow;
	BeeUIActivityIndicatorView *	_indicator;
}

AS_INT( STATE_NORMAL )
AS_INT( STATE_PULLING )
AS_INT( STATE_LOADING )

AS_SIGNAL( STATE_CHANGED )	// 状态改变

@property (nonatomic, readonly) NSInteger	state;
@property (nonatomic, assign) BOOL			normal;
@property (nonatomic, assign) BOOL			pulling;
@property (nonatomic, assign) BOOL			loading;

@property (nonatomic, readonly) UIImageView *					arrow;
@property (nonatomic, readonly) BeeUIActivityIndicatorView *	indicator;

+ (BeeUIPullLoader *)spawn;
+ (BeeUIPullLoader *)spawn:(NSString *)tagString;

- (void)changeState:(NSInteger)state;
- (void)changeState:(NSInteger)state animated:(BOOL)animated;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

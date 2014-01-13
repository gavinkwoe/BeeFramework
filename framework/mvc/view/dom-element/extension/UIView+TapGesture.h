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
#import "Bee_UISignal.h"

#pragma mark -

@interface UIView(TapGesture)

@property (nonatomic, assign) BOOL							tappable;	// same as tapEnabled
@property (nonatomic, assign) BOOL							tapEnabled;
@property (nonatomic, retain) NSString *					tapSignal;
@property (nonatomic, retain) NSObject *					tapObject;
@property (nonatomic, readonly) UITapGestureRecognizer *	tapGesture;

AS_SIGNAL( TAPPED );	// 单击

- (void)makeTappable;
- (void)makeTappable:(NSString *)signal;
- (void)makeTappable:(NSString *)signal withObject:(NSObject *)obj;
- (void)makeUntappable;

@end

#pragma mark -

#undef	ON_TAPPED
#define ON_TAPPED( signal )		ON_SIGNAL3( UIView, TAPPED, signal )

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

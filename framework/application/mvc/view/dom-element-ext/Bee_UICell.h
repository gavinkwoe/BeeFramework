//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#pragma mark -

@class BeeUICell;

typedef BeeUICell *	(^BeeUICellBlock)( void );
typedef BeeUICell *	(^BeeUICellBlockN)( id first, ... );

#pragma mark -

#undef	SUPPORT_AUTOMATIC_LAYOUT
#define SUPPORT_AUTOMATIC_LAYOUT( __flag ) \
		+ (BOOL)supportForUIAutomaticLayout { return __flag; }

#pragma mark -

@protocol BeeUICellLayoutProtocol<NSObject>
@optional
+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data;
- (void)layoutInBound:(CGSize)bound forCell:(BeeUICell *)cell;
@end

#pragma mark -

@interface BeeUICell : UIView<BeeUICellLayoutProtocol>

AS_INT( STATE_NORMAL )
AS_INT( STATE_DISABLED )
AS_INT( STATE_SELECTED )
AS_INT( STATE_HIGHLIGHTED )

@property (nonatomic, retain) id				data;
@property (nonatomic, assign) NSUInteger		state;

@property (nonatomic, assign) BOOL				disabled;
@property (nonatomic, assign) BOOL				selected;
@property (nonatomic, assign) BOOL				highlighted;

@property (nonatomic, readonly) BeeUICellBlock	RELAYOUT;

+ (BOOL)supportForUIAutomaticLayout;

- (void)dataWillChange;
- (void)dataDidChanged;

- (void)layoutWillBegin;
- (void)layoutDidFinish;

- (void)stateWillChange;
- (void)stateDidChanged;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

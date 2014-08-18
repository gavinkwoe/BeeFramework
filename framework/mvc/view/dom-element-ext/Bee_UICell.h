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

@class BeeUICell;

typedef BeeUICell *	(^BeeUICellBlock)( void );
typedef BeeUICell *	(^BeeUICellBlockN)( id first, ... );

#pragma mark -

@interface BeeUICell : UIView

AS_INT( STATE_NORMAL )
AS_INT( STATE_DISABLED )
AS_INT( STATE_SELECTED )
AS_INT( STATE_HIGHLIGHTED )

//AS_SIGNAL( DATA_WILL_CHANGE )
//AS_SIGNAL( DATA_DID_CHANGED )
//
//AS_SIGNAL( LAYOUT_WILL_BEGIN )
//AS_SIGNAL( LAYOUT_DID_FINISH )
//
//AS_SIGNAL( STATE_WILL_CHANGE )
//AS_SIGNAL( STATE_DID_CHANGED )

@property (nonatomic, retain) id				data;
@property (nonatomic, assign) NSUInteger		state;

@property (nonatomic, assign) BOOL				disabled;
@property (nonatomic, assign) BOOL				selected;
@property (nonatomic, assign) BOOL				highlighted;

@property (nonatomic, assign) BOOL				layouted;
@property (nonatomic, assign) BOOL				layoutOnce;
@property (nonatomic, readonly) BeeUICellBlock	RELAYOUT;

+ (id)cell;

- (BOOL)frameWillChange:(CGRect)newRect;
- (void)frameWillChange;
- (void)frameDidChanged;

- (BOOL)dataWillChange:(id)newData;
- (void)dataWillChange;
- (void)dataDidChanged;

- (void)layoutWillBegin;
- (void)layoutDidFinish;

- (void)stateWillChange;
- (void)stateDidChanged;

- (void)viewWillAppear;
- (void)viewDidAppear;

- (void)viewWillDisappear;
- (void)viewDidDisappear;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

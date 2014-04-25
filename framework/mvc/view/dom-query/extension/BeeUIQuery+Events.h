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

#import "Bee_UIQuery.h"

#pragma mark -

@interface BeeUIQuery(Events)

@property (nonatomic, readonly) BOOL						selected;
@property (nonatomic, readonly) BOOL						focusing;

@property (nonatomic, readonly) BeeUIQueryObjectBlock		FOCUS;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		BLUR;

@property (nonatomic, readonly) BeeUIQueryObjectBlock		SELECT;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		UNSELECT;

@property (nonatomic, readonly) BeeUIQueryObjectBlock		ENABLE;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		DISABLE;

@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		ERROR;		// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		RESIZE;		// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		SCROLL;		// TODO

@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		LOAD;		// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		READY;		// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		UNLOAD;		// TODO

@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		CLICK;			// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		DOUBLE_CLICK;	// TODO

@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		TOUCH_DOWN;			// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		TOUCH_DOWN_REPEAT;	// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		TOUCH_UP_INSIDE;	// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		TOUCH_UP_OUTSIDE;	// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		TOUCH_UP_CANCEL;	// TODO

@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		PAN;				// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		SWIPE_UP;			// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		SWIPE_DOWN;			// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		SWIPE_LEFT;			// TODO
@property (nonatomic, readonly) BeeUIQueryObjectBlockXV		SWIPE_RIGHT;		// TODO

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

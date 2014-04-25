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

@interface BeeUIQuery(Effects)

@property (nonatomic, readonly) BOOL						hidden;
@property (nonatomic, readonly) BOOL						visible;
@property (nonatomic, readonly) BOOL						animating;

@property (nonatomic, readonly) BeeUIQueryObjectBlock		HIDE;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		SHOW;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		TOGGLE;

@property (nonatomic, readonly) BeeUIQueryObjectBlock		AND;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		THEN;

@property (nonatomic, readonly) BeeUIQueryObjectBlockX		ANIMATE;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		COMMIT;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		CANCEL;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		STOP;	// equals to CANCEL

@property (nonatomic, readonly) BeeUIQueryObjectBlock		HIDE_ON_STOP;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		SHOW_ON_STOP;

@property (nonatomic, readonly) BeeUIQueryObjectBlockU		CURVE;
@property (nonatomic, readonly) BeeUIQueryObjectBlockF		DELAY;
@property (nonatomic, readonly) BeeUIQueryObjectBlockF		DURATION;

@property (nonatomic, readonly) BeeUIQueryObjectBlockX		ON_BEGIN;
@property (nonatomic, readonly) BeeUIQueryObjectBlockX		ON_COMPLETE;
@property (nonatomic, readonly) BeeUIQueryObjectBlockX		ON_CANCEL;
@property (nonatomic, readonly) BeeUIQueryObjectBlockX		ON_STOP;	// equals to ON_CANCEL

@property (nonatomic, readonly) BeeUIQueryObjectBlock		FADE_IN;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		FADE_OUT;
@property (nonatomic, readonly) BeeUIQueryObjectBlockF		FADE_TO;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		FADE_TOGGLE;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		BOUNCE;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		DISSOLVE;
@property (nonatomic, readonly) BeeUIQueryObjectBlockR		ZOOM_IN;
@property (nonatomic, readonly) BeeUIQueryObjectBlock		ZOOM_OUT;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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
#if (__ON__ == __BEE_DEVELOPMENT__)

#import "UINavigationBar+UIWireframe.h"
#import "NSObject+UIWireframe.h"
#import "UIView+UIWireframe.h"
#import "UIColor+BeeExtension.h"

#pragma mark -

@implementation UINavigationBar(UIWireframe)

- (void)renderWireframe:(CGRect)rect
{
	[self renderBackground:rect];
	[self renderBorder:rect];
}

<_UINavigationBarBackground: 0x9e58000; frame = (0 -20; 320 64); opaque = NO; autoresize = W; userInteractionEnabled = NO; layer = <CALayer: 0x9ee82e0>>,
<UINavigationItemView: 0xfb91690; frame = (125.5 8; 69.5 27); opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0xfb94f10>>,
<_UINavigationBarBackIndicatorView: 0xa065f70; frame = (8 12; 12.5 20.5); alpha = 0; opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0xa04f080>>
)

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

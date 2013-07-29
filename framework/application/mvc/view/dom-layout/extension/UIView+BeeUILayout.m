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

#import "UIView+BeeUILayout.h"

#pragma mark -

#undef	KEY_LAYOUT
#define KEY_LAYOUT	"UIView.layout"

#pragma mark -

@implementation UIView(BeeUILayout)

@dynamic layout;
@dynamic canvasSize;

@dynamic BEGIN_LAYOUT;
@dynamic RELAYOUT;

- (BeeUILayout *)layout
{
	BeeUILayout * layout = objc_getAssociatedObject( self, KEY_LAYOUT );
	if ( nil == layout )
	{
		layout = [[[BeeUILayout alloc] init] autorelease];
		objc_setAssociatedObject( self, KEY_LAYOUT, layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
	
	layout.canvas = self;
	return layout;
}

- (void)setLayout:(BeeUILayout *)newLayout
{
	BeeUILayout * layout = objc_getAssociatedObject( self, KEY_LAYOUT );
	if ( layout != newLayout )
	{
		newLayout.canvas = self;
		objc_setAssociatedObject( self, KEY_LAYOUT, newLayout, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	}
}

- (CGSize)canvasSize
{
	BeeUILayout * layout = [self layout];
	if ( layout )
	{
		return [layout estimateFrameBy:self.bounds].size;
	}
	
	return CGSizeZero;
}

- (BeeUILayoutBlock)BEGIN_LAYOUT
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		[[BeeLogger sharedInstance] indent];

		BeeUILayout * layout = [self layout];
		[layout.childs removeAllObjects];
		return layout;
	};
	
	return [[block copy] autorelease];
}

- (BeeUILayoutBlock)RELAYOUT
{
	BeeUILayoutBlock block = ^ BeeUILayout * ( void )
	{
		BeeUILayout * layout = [self layout];
		if ( layout )
		{
			layout.RELAYOUT();
		}
		else
		{
			[self layoutSubviews];
		}
		return layout;
	};

	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

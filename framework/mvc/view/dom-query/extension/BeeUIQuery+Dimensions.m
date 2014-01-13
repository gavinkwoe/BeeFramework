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

#import "BeeUIQuery+Dimensions.h"
#import "UIView+Metrics.h"

#pragma mark -

@implementation BeeUIQuery(Dimensions)

@dynamic width;
@dynamic height;
@dynamic frame;

@dynamic WIDTH;
@dynamic HEIGHT;
@dynamic FRAME;

- (CGFloat)width
{
	UIView * view = self.view;
	if ( nil == view )
		return 0.0f;

	return view.width;
}

- (CGFloat)height
{
	UIView * view = self.view;
	if ( nil == view )
		return 0.0f;

	return view.height;
}

- (CGRect)frame
{
	UIView * view = self.view;
	if ( nil == view )
		return CGRectZero;
	
	return view.frame;
}

- (BeeUIQueryObjectBlockF)WIDTH
{
	BeeUIQueryObjectBlockF block = ^ BeeUIQuery * ( CGFloat value )
	{
		for ( UIView * v in self.views )
		{
			v.width = value;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockF)HEIGHT
{
	BeeUIQueryObjectBlockF block = ^ BeeUIQuery * ( CGFloat value )
	{
		for ( UIView * v in self.views )
		{
			v.height = value;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockR)FRAME
{
	BeeUIQueryObjectBlockR block = ^ BeeUIQuery * ( CGRect frame )
	{
		for ( UIView * v in self.views )
		{
			v.frame = frame;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

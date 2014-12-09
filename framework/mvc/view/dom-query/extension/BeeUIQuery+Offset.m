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

#import "BeeUIQuery+Offset.h"
#import "UIView+Metrics.h"
#import "UIView+BeeUILayout.h"

#pragma mark -

@implementation BeeUIQuery(Offset)

@dynamic left;
@dynamic top;
@dynamic bottom;
@dynamic right;

@dynamic offset;
@dynamic position;

@dynamic LEFT;
@dynamic TOP;
@dynamic BOTTOM;
@dynamic RIGHT;

@dynamic OFFSET;
@dynamic POSITION;

@dynamic RELAYOUT;

- (CGFloat)left
{
	UIView * view = self.view;
	if ( nil == view )
		return 0.0f;
	
	return view.left;
}

- (CGFloat)top
{
	UIView * view = self.view;
	if ( nil == view )
		return 0.0f;
	
	return view.top;
}

- (CGFloat)bottom
{
	UIView * view = self.view;
	if ( nil == view )
		return 0.0f;
	
	return view.bottom;
}

- (CGFloat)right
{
	UIView * view = self.view;
	if ( nil == view )
		return 0.0f;
	
	return view.right;
}

- (CGPoint)offset
{
	UIView * view = self.view;
	if ( nil == view )
		return CGPointZero;
	
	return view.offset;
}

- (CGPoint)position
{
	UIView * view = self.view;
	if ( nil == view )
		return CGPointZero;

	return view.position;
}

- (BeeUIQueryObjectBlockF)LEFT
{
	BeeUIQueryObjectBlockF block = ^ BeeUIQuery * ( CGFloat value )
	{
		for ( UIView * v in self.views )
		{
			v.left = value;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockF)TOP
{
	BeeUIQueryObjectBlockF block = ^ BeeUIQuery * ( CGFloat value )
	{
		for ( UIView * v in self.views )
		{
			v.top = value;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockF)BOTTOM
{
	BeeUIQueryObjectBlockF block = ^ BeeUIQuery * ( CGFloat value )
	{
		for ( UIView * v in self.views )
		{
			v.bottom = value;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockF)RIGHT
{
	BeeUIQueryObjectBlockF block = ^ BeeUIQuery * ( CGFloat value )
	{
		for ( UIView * v in self.views )
		{
			v.right = value;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockFF)OFFSET
{
	BeeUIQueryObjectBlockFF block = ^ BeeUIQuery * ( CGFloat value1, CGFloat value2 )
	{
		for ( UIView * v in self.views )
		{
			v.offset = CGPointMake( value1, value2 );
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockFF)POSITION
{
	BeeUIQueryObjectBlockFF block = ^ BeeUIQuery * ( CGFloat value1, CGFloat value2 )
	{
		for ( UIView * v in self.views )
		{
			v.position = CGPointMake( value1, value2 );
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)RELAYOUT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			v.superview.RELAYOUT();
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

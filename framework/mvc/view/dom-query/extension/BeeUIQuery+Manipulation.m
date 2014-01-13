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

#import "BeeUIQuery+Manipulation.h"
#import "UIView+Tag.h"
#import "UIView+Manipulation.h"

#pragma mark -

@implementation BeeUIQuery(Manipulation)

@dynamic UNWRAP;
@dynamic WRAP;

@dynamic BEFORE;
@dynamic AFTER;
@dynamic APPEND;
@dynamic PREPEND;
@dynamic REMOVE;
@dynamic EMPTY;
@dynamic REPLACE_ALL;
@dynamic REPLACE_WITH;

- (BeeUIQueryObjectBlock)UNWRAP
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		// TODO:
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockCS)WRAP
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		// TODO:
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockCS)BEFORE
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		if ( nil == clazz )
		{
			clazz = [UIView class];
		}
		
		if ( clazz != [UIView class] && NO == [clazz isSubclassOfClass:[UIView class]] )
			return self;
		
		for ( UIView * v in self.views )
		{
			if ( nil == v.superview )
				continue;
			
			UIView * view = [[[clazz alloc] initWithFrame:CGRectZero] autorelease];
			if ( view )
			{
				view.tagString = tag;
				
				[v.superview insertSubview:view belowSubview:v];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockCS)AFTER
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		if ( nil == clazz )
		{
			clazz = [UIView class];
		}
		
		if ( clazz != [UIView class] && NO == [clazz isSubclassOfClass:[UIView class]] )
			return self;
		
		for ( UIView * v in self.views )
		{
			if ( nil == v.superview )
				continue;
			
			UIView * view = [[[clazz alloc] initWithFrame:CGRectZero] autorelease];
			if ( view )
			{
				view.tagString = tag;
				
				[v.superview insertSubview:view aboveSubview:v];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockCS)APPEND
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		if ( nil == clazz )
		{
			clazz = [UIView class];
		}
		
		if ( clazz != [UIView class] && NO == [clazz isSubclassOfClass:[UIView class]] )
			return self;
		
		for ( UIView * v in self.views )
		{
			UIView * view = [[[clazz alloc] initWithFrame:CGRectZero] autorelease];
			if ( view )
			{
				view.tagString = tag;
				
				[v addSubview:view];
				[v bringSubviewToFront:view];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockCS)PREPEND
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		if ( nil == clazz )
		{
			clazz = [UIView class];
		}
		
		if ( clazz != [UIView class] && NO == [clazz isSubclassOfClass:[UIView class]] )
			return self;
		
		for ( UIView * v in self.views )
		{
			UIView * view = [[[clazz alloc] initWithFrame:CGRectZero] autorelease];
			if ( view )
			{
				view.tagString = tag;
				
				[v addSubview:view];
				[v sendSubviewToBack:view];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)REMOVE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			[v removeFromSuperview];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)EMPTY
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			[v removeAllSubviews];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockS)REPLACE_ALL
{
	BeeUIQueryObjectBlockS block = ^ BeeUIQuery * ( NSString * tag )
	{
		// TODO:
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockCS)REPLACE_WITH
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		if ( nil == clazz )
		{
			clazz = [UIView class];
		}
		
		for ( UIView * v in self.views )
		{
			UIView * parentView = v.superview;
			if ( parentView )
			{
				UIView * newView = [[[clazz alloc] init] autorelease];
				if ( newView )
				{
					newView.tagString = tag;
					
					[parentView insertSubview:newView aboveSubview:v];
					[v removeFromSuperview];
				}
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

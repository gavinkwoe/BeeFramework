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

#import "BeeUIQuery+Traversing.h"
#import "UIView+Tag.h"
#import "UIView+Traversing.h"

#pragma mark -

@interface BeeUIQuery(TraversingPrivate)
- (void)walkThroughSuperviews:(UIView *)view toArray:(NSMutableArray *)array;
@end

#pragma mark -

@implementation BeeUIQuery(Traversing)

@dynamic first;
@dynamic last;
@dynamic next;
@dynamic prev;

@dynamic parent;
@dynamic parents;
@dynamic children;

@dynamic siblings;
@dynamic closest;

@dynamic ADD;
@dynamic ADD_BACK;

@dynamic CHILDREN;
@dynamic CLOSEST;

@dynamic END;

@dynamic IS;
@dynamic NOT;
@dynamic EQ;
@dynamic HAS;

@dynamic FIRST;
@dynamic LAST;

@dynamic NEXT;
@dynamic NEXT_ALL;
@dynamic NEXT_UNTIL;

@dynamic PREV;
@dynamic PREV_ALL;
@dynamic PREV_UNTIL;

@dynamic FIND;
@dynamic FILTER;

@dynamic PARENT;
@dynamic PARENTS;
@dynamic PARENTS_UNTIL;

@dynamic SIBLINGS;
@dynamic SLICE;

- (UIView *)first
{
	NSArray * views = self.views;
	if ( nil == views || 0 == views.count )
		return nil;
	
	return [views objectAtIndex:0];
}

- (UIView *)last
{
	NSArray * views = self.views;
	if ( nil == views || 0 == views.count )
		return nil;
	
	return [views lastObject];
}

- (UIView *)next
{
	// TODO:
	return nil;
}

- (UIView *)prev
{
	// TODO:
	return nil;
}

- (NSArray *)children
{
	NSArray * views = self.views;
	if ( nil == views || 0 == views.count )
		return [NSArray array];

	NSMutableArray * childViews = [NSMutableArray array];

	for ( UIView * view in views )
	{
		if ( view.subviews.count )
		{
			[childViews addObjectsFromArray:view.subviews];
		}
	}

	return childViews;
}

- (UIView *)parent
{
	UIView * view = self.view;
	if ( nil == view )
		return nil;
	
	return view.superview;
}

- (NSArray *)parents
{
	NSArray * views = self.views;
	if ( nil == views || 0 == views.count )
		return nil;
	
	NSMutableArray * parentViews = [NSMutableArray array];
	
	for ( UIView * view in views )
	{
		if ( view.superview )
		{
			[parentViews addObject:view.superview];
		}
	}
	
	return parentViews;
}

- (NSArray *)siblings
{
	// TODO:
	return nil;
}

- (NSArray *)closest
{
	// TODO:
	return nil;
}

- (void)walkThroughSuperviews:(UIView *)view toArray:(NSMutableArray *)array
{
	if ( nil == view.superview )
		return;
	
	[array addObject:view.superview];
	
	[self walkThroughSuperviews:view.superview toArray:array];
}

- (BeeUIQueryObjectBlockCS)ADD
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		for ( UIView * view in self.views )
		{
			UIView * subview = [[[clazz alloc] initWithFrame:CGRectZero] autorelease];
			if ( subview )
			{
				subview.tagString = tag;

				[view addSubview:subview];
			}
		}
		
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockCS)ADD_BACK
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		// TODO:
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)CHILDREN
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];
		
		for ( UIView * v in self.views )
		{
			[array addObjectsFromArray:v.subviews];
		}
		
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)CLOSEST
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		// TODO:
		NSAssert( 0, @"" );
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)END
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		// TODO:
		NSAssert( 0, @"" );

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockC)IS
{
	BeeUIQueryObjectBlockC block = ^ BeeUIQuery * ( Class clazz )
	{
		// TODO:
		NSAssert( 0, @"" );
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockC)NOT
{
	BeeUIQueryObjectBlockC block = ^ BeeUIQuery * ( Class clazz )
	{
		// TODO:
		NSAssert( 0, @"" );
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockN)EQ
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		// TODO:
		NSAssert( 0, @"" );
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockN)HAS
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		// TODO:
		NSAssert( 0, @"" );

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)FIRST
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.object = [self.views objectAtIndex:0];
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)LAST
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.object = [self.views lastObject];
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)NEXT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];
		
		for ( UIView * v in self.views )
		{
			UIView * sibling = [v nextSibling];
			if ( sibling )
			{
				[array addObject:sibling];
			}
		}
		
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)NEXT_ALL
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		// TODO:
		NSAssert( 0, @"" );

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockN)NEXT_UNTIL
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		// TODO:
		NSAssert( 0, @"" );
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)PREV
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];
		
		for ( UIView * v in self.views )
		{
			UIView * sibling = [v prevSibling];
			if ( sibling )
			{
				[array addObject:sibling];
			}
		}
		
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)PREV_ALL
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		// TODO:
		NSAssert( 0, @"" );
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockN)PREV_UNTIL
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		// TODO:
		NSAssert( 0, @"" );
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockS)FIND
{
	BeeUIQueryObjectBlockS block = ^ BeeUIQuery * ( NSString * tag )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];
		
		for ( UIView * v in self.views )
		{
			NSArray * results = [BeeUIQuery findViewsIn:v byExpression:tag];
			if ( results && results.count )
			{
				[array addObjectsFromArray:results];
			}
		}
		
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockS)FILTER
{
	BeeUIQueryObjectBlockS block = ^ BeeUIQuery * ( NSString * tag )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];
		
		for ( UIView * v in self.views )
		{
			if ( [tag isEqualToString:@"*"] )
			{
				[array addObject:v];
			}
			else if ( [tag hasPrefix:@"#"] )
			{
				if ( [v.tagString isEqualToString:[tag substringFromIndex:1]] )
				{
					[array addObject:v];
				}
			}
			else if ( [tag hasPrefix:@"."] )
			{
				Class clazz = NSClassFromString( [tag substringFromIndex:1] );
				if ( nil == clazz )
				{
					clazz = [UIView class];
				}
				
				if ( clazz && [v isKindOfClass:clazz] )
				{
					[array addObject:v];
				}
			}
			else
			{
				if ( [v.tagString isEqualToString:tag] )
				{
					[array addObject:v];
				}
			}
		}
		
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)PARENT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];
		
		for ( UIView * v in self.views )
		{
			if ( v.superview )
			{
				[array addObject:v.superview];
			}
		}
		
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)PARENTS
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];
		
		for ( UIView * v in self.views )
		{
			[self walkThroughSuperviews:v toArray:array];
		}
		
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockN)PARENTS_UNTIL
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		// TODO:
		NSAssert( 0, @"" );
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)SIBLINGS
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];
		
		for ( UIView * v in self.views )
		{
			if ( v.superview )
			{
				[array addObjectsFromArray:v.superview.subviews];
				[array removeObject:v];
			}
		}

		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockUU)SLICE
{
	BeeUIQueryObjectBlockUU block = ^ BeeUIQuery * ( NSUInteger value1, NSUInteger value2 )
	{
		// TODO:
		NSAssert( 0, @"" );

		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

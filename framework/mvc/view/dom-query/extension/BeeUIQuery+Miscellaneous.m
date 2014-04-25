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

#import "BeeUIQuery+Miscellaneous.h"

#pragma mark -

@implementation BeeUIQuery(Miscellaneous)

@dynamic array;
@dynamic size;

@dynamic GET;
@dynamic EACH;

- (NSArray *)array
{
	if ( self.object && [self.object isKindOfClass:[NSArray class]] )
	{
		return (NSArray *)self.object;
	}
	
	return nil;
}

- (NSUInteger)size
{
	NSArray * arr = self.array;
	if ( arr )
		return arr.count;
	
	return 0;
}

- (BeeUIQueryObjectBlockXV)EACH
{
	BeeUIQueryObjectBlockXV block = ^ BeeUIQuery * ( void (^block)(UIView *) )
	{
		for ( UIView * v in self.views )
		{
			block( v );
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockU)GET
{
	BeeUIQueryObjectBlockU block = ^ BeeUIQuery * ( NSUInteger index )
	{
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.object = [self.array safeObjectAtIndex:index];
		return q;
	};

	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

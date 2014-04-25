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

#import "UIView+Traversing.h"

#pragma mark -

@implementation UIView(Traversing)

@dynamic inheritanceLevel;

- (UIView *)rootView
{
	for ( UIView * view = self;; )
	{
		if ( nil == view.superview )
		{
			return view;
		}

		view = view.superview;
	}
	
	return nil;
}

- (NSUInteger)inheritanceLevel
{
	NSUInteger level = 0;
	
	for ( UIView * view = self.superview; nil != view; view = view.superview )
	{
		level += 1;
	}
	
	return level;
}

- (UIView *)subview:(NSString *)name
{
	if ( nil == name || 0 == [name length] )
		return nil;
	
	NSObject * view = [self valueForKey:name];
	
	if ( [view isKindOfClass:[UIView class]] )
	{
		return (UIView *)view;
	}
	else
	{
		return nil;
	}
}

- (UIView *)viewAtPath:(NSString *)path
{
	if ( nil == path || 0 == path.length )
		return nil;
	
	NSString *	keyPath = [path stringByReplacingOccurrencesOfString:@"/" withString:@"."];
	NSRange		range = NSMakeRange( 0, 1 );
	
	if ( [[keyPath substringWithRange:range] isEqualToString:@"."] )
	{
		keyPath = [keyPath substringFromIndex:1];
	}
	
	NSObject * result = [self valueForKeyPath:keyPath];
	if ( result == [NSNull null] || NO == [result isKindOfClass:[UIView class]] )
		return nil;
	
	return (UIView *)result;
}

- (UIView *)prevSibling
{
	if ( nil == self.superview )
		return nil;
	
	if ( self.superview.subviews.count <= 1 )
		return nil;
	
	NSUInteger count = self.superview.subviews.count;
	NSUInteger index = [self.superview.subviews indexOfObject:self];
	if ( 0 == index )
	{
		index = count - 1;
	}
	else
	{
		index = index - 1;
	}

	return [self.superview.subviews objectAtIndex:index];
}

- (UIView *)nextSibling
{
	if ( nil == self.superview )
		return nil;

	if ( self.superview.subviews.count <= 1 )
		return nil;

	NSUInteger count = self.superview.subviews.count;
	NSUInteger index = [self.superview.subviews indexOfObject:self];

	return [self.superview.subviews objectAtIndex:(index + 1) % count];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

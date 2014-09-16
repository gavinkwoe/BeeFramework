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

#import "Bee_UICollection.h"

#pragma mark -

@interface BeeUICollection()
{
	BOOL	_retained;
	id		_object;
}
@end

#pragma mark -

@implementation BeeUICollection

@synthesize retained = _retained;
@dynamic object;
@dynamic retainedObject;
@dynamic count;
@dynamic view;
@dynamic views;
@dynamic viewController;
@dynamic viewControllers;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_retained = NO;
		_object = nil;
	}
	return self;
}

- (void)dealloc
{
	if ( _retained )
	{
		[_object release];
	}
	
	[super dealloc];
}

- (id)object
{
	return _object;
}

- (void)setObject:(id)obj
{
	if ( obj == _object )
		return;

	if ( _retained )
	{
		[_object release];
	}

	_object = obj;
	_retained = NO;
}

- (id)retainedObject
{
	return _object;
}

- (void)setRetainedObject:(id)obj
{
	if ( obj == _object )
		return;
	
	if ( _retained )
	{
		[_object release];
	}

	_object = [obj retain];
	_retained = YES;
}

- (NSUInteger)count
{
	if ( nil == self.object )
		return 0;
	
	if ( [self.object isKindOfClass:[NSArray class]] )
	{
		return ((NSArray *)self.object).count;
	}
	
	return 1;
}

- (void)copyFrom:(BeeUICollection *)other
{
	if ( other.retained )
	{
		_object = [other.object retain];
	}
	else
	{
		_object = other.object;
	}
}

- (UIView *)view
{	
	if ( nil == self.object )
		return nil;

	if ( [self.object isKindOfClass:[UIView class]] )
	{
		return (UIView *)self.object;
	}
	else if ( [self.object isKindOfClass:[UIViewController class]] )
	{
		return ((UIViewController *)self.object).view;
	}
	else if ( [self.object isKindOfClass:[NSArray class]] )
	{
		for ( NSObject * obj in (NSArray *)self.object )
		{
			if ( [obj isKindOfClass:[UIView class]] )
			{
				return (UIView *)obj;
			}
			else if ( [obj isKindOfClass:[UIViewController class]] )
			{
				return ((UIViewController *)obj).view;
			}
		}
	}

	return nil;
}

- (NSArray *)views
{
	NSMutableArray * array = [NSMutableArray array];
	
	if ( [self.object isKindOfClass:[UIView class]] )
	{
		[array addObject:self.object];
	}
	else if ( [self.object isKindOfClass:[UIViewController class]] )
	{
		[array addObject:((UIViewController *)self.object).view];
	}
	else if ( [self.object isKindOfClass:[NSArray class]] )
	{
		for ( NSObject * obj in (NSArray *)self.object )
		{
			if ( [obj isKindOfClass:[UIView class]] )
			{
				[array addObject:obj];
			}
			else if ( [obj isKindOfClass:[UIViewController class]] )
			{
				[array addObject:((UIViewController *)obj).view];
			}
		}
	}
	
	return array;
}

- (UIViewController *)viewController
{
	if ( nil == self.object )
		return nil;
	
	if ( [self.object isKindOfClass:[UIViewController class]] )
	{
		return (UIViewController *)self.object;
	}
	else if ( [self.object isKindOfClass:[NSArray class]] )
	{
		for ( NSObject * obj in (NSArray *)self.object )
		{
			if ( [obj isKindOfClass:[UIViewController class]] )
			{
				return (UIViewController *)obj;
			}
		}
	}

	return nil;
}

- (NSArray *)viewControllers
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	
	if ( [self.object isKindOfClass:[UIViewController class]] )
	{
		[array addObject:((UIViewController *)self.object).view];
	}
	else if ( [self.object isKindOfClass:[NSArray class]] )
	{
		for ( NSObject * obj in (NSArray *)self.object )
		{
			if ( [obj isKindOfClass:[UIViewController class]] )
			{
				[array addObject:((UIViewController *)self.object).view];
			}
		}
	}
	
	return array;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

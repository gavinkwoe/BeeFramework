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

#import "BeeUIQuery+Value.h"
#import "Bee_UIDataBinding.h"

#pragma mark -

@implementation BeeUIQuery(Value)

@dynamic val;
@dynamic VAL;

@dynamic data;
@dynamic DATA;
@dynamic BIND_DATA;
@dynamic REMOVE_DATA;

@dynamic text;
@dynamic texts;
@dynamic TEXT;

@dynamic image;
@dynamic images;
@dynamic IMAGE;

- (id)val
{
	UIView * view = self.view;
	if ( nil == view )
		return nil;
	
	return [view bindedData];
}

- (BeeUIQueryObjectBlockN)VAL
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		for ( UIView * v in self.views )
		{
			[v bindData:first];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (id)data
{
	UIView * view = self.view;
	if ( nil == view )
		return nil;
	
	return [view bindedData];
}

- (BeeUIQueryObjectBlockN)DATA
{
	return [self BIND_DATA];
}

- (BeeUIQueryObjectBlockN)BIND_DATA
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		for ( UIView * v in self.views )
		{
			[v bindData:first];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)REMOVE_DATA
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			[v unbindData];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

+ (NSString *)textFromView:(UIView *)view
{
	NSObject * result = nil;
	
	if ( [view respondsToSelector:@selector(text)] )
	{
		result = [view performSelector:@selector(text)];
	}
	else if ( [view respondsToSelector:@selector(title)] )
	{
		result = [view performSelector:@selector(title)];
	}
//	else if ( [view respondsToSelector:@selector(currentText)] )
//	{
//		result = [view performSelector:@selector(currentText)];
//	}
//	else if ( [view respondsToSelector:@selector(currentTitle)] )
//	{
//		result = [view performSelector:@selector(currentTitle)];
//	}
	
	if ( result && [result isKindOfClass:[NSString class]] )
	{
		return (NSString *)result;
	}
	
	return nil;
}

- (NSString *)text
{
	UIView * view = self.view;
	if ( nil == view )
		return nil;
	
	return [BeeUIQuery textFromView:view];
}

- (NSArray *)texts
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	
	for ( UIView * view in self.views )
	{
		NSString * text = [BeeUIQuery textFromView:view];
		if ( text )
		{
			[array addObject:text];
		}
	}
	
	return array;
}

- (BeeUIQueryObjectBlockN)TEXT
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first )
		{
			for ( UIView * v in self.views )
			{
				[v bindData:first];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

+ (UIImage *)imageFromView:(UIView *)view
{
	NSObject * result = nil;

	if ( [view respondsToSelector:@selector(image)] )
	{
		result = [view performSelector:@selector(image)];
	}
	else if ( [view respondsToSelector:@selector(currentImage)] )
	{
		result = [view performSelector:@selector(currentImage)];
	}

	if ( result && [result isKindOfClass:[UIImage class]] )
		return (UIImage *)result;
	
	return nil;
}

- (UIImage *)image
{
	UIView * view = self.view;
	if ( nil == view )
		return nil;
	
	return [BeeUIQuery imageFromView:view];
}

- (NSArray *)images
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];

	for ( UIView * view in self.views )
	{
		UIImage * image = [BeeUIQuery imageFromView:view];
		if ( image )
		{
			[array addObject:image];
		}
	}
	
	return array;
}

- (BeeUIQueryObjectBlockN)IMAGE
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first )
		{
			for ( UIView * v in self.views )
			{
				[v bindData:first];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

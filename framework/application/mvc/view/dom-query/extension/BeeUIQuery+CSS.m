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

#import "BeeUIQuery+CSS.h"
#import "Bee_UIStyle.h"
#import "Bee_UILayout.h"
#import "UIView+BeeUILayout.h"
#import "UIView+BeeUIStyle.h"

#pragma mark -

@implementation BeeUIQuery(CSS)

@dynamic css;

@dynamic CSS;
@dynamic ATTR;

@dynamic ADD_CLASS;
@dynamic HAS_CLASS;
@dynamic REMOVE_CLASS;
@dynamic TOGGLE_CLASS;

- (NSString *)css
{
	UIView * view = self.view;
	if ( nil == view )
		return nil;

	if ( nil == view.layout )
		return nil;

	return view.layout.style.css;
}

- (BeeUIQueryObjectBlockN)CSS
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		NSDictionary * properties = nil;

		if ( first )
		{
			if ( [first isKindOfClass:[NSString class]] )
			{
				properties = [NSMutableDictionary dictionary];
				
				NSArray * segments = [(NSString *)first componentsSeparatedByString:@";"];
				for ( NSString * seg in segments )
				{
					NSArray * keyValue = [seg componentsSeparatedByString:@":"];
					if ( keyValue.count == 2 )
					{
						NSString * key = [keyValue objectAtIndex:0];
						NSString * val = [keyValue objectAtIndex:1];
						
						key = key.trim.unwrap;
						val = val.trim.unwrap;
						
						[(NSMutableDictionary *)properties setObject:val forKey:key];
					}
				}
			}
			else if ( [first isKindOfClass:[NSDictionary class]] )
			{
				properties = (NSDictionary *)first;
			}
		}

		if ( properties && properties.count )
		{            
//			BeeUIStyle * style = [[[BeeUIStyle alloc] init] autorelease];
//			style.CSS( properties );
//			
//			for ( UIView * v in self.views )
//			{
//				[v applyUIStyleProperties:style];
//			}

			for ( UIView * v in self.views )
			{
				[v applyUIStyleProperties:properties];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockSS)ATTR
{
	BeeUIQueryObjectBlockSS block = ^ BeeUIQuery * ( NSString * value1, NSString * value2 )
	{
		if ( value1 && value2 )
		{
			for ( UIView * v in self.views )
			{
				if ( v.layout )
				{
					[v.layout.styleInline.properties setObject:value2 atPath:value1];
					
					[self applyStylesForView:v];
				}
			}
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryBoolBlockS)HAS_CLASS
{
	BeeUIQueryBoolBlockS block = ^ BOOL ( NSString * value )
	{
		if ( nil == value )
			return NO;
		
		NSArray * subviews = self.views;
		if ( nil == subviews || 0 == subviews.count )
			return NO;
		
		BOOL flag = YES;
		
		for ( UIView * v in subviews )
		{
			BOOL found = [v.layout hasStyleClass:value];
			if ( NO == found )
			{
				flag = NO;
				break;
			}
		}
		
		return flag;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockN)ADD_CLASS
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first && [first isKindOfClass:[NSString class]] )
		{
			for ( UIView * v in self.views )
			{
				NSArray * classes = [(NSString *)first componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				for ( NSString * className in classes )
				{
					[v.layout addStyleClass:className];
				}
				
				[self applyStylesForView:v];
			}
		}
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockN)REMOVE_CLASS
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first && [first isKindOfClass:[NSString class]] )
		{
			for ( UIView * v in self.views )
			{
				NSArray * classes = [(NSString *)first componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				for ( NSString * className in classes )
				{
					[v.layout removeStyleClass:className];
				}

				[self applyStylesForView:v];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockN)TOGGLE_CLASS
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first && [first isKindOfClass:[NSString class]] )
		{
			for ( UIView * v in self.views )
			{
				NSArray * classes = [(NSString *)first componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				for ( NSString * className in classes )
				{
					[v.layout toggleStyleClass:className];
				}

				[self applyStylesForView:v];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (void)applyStylesForView:(UIView *)view
{
	if ( nil == view.layout )
		return;

	[view.layout mergeStyle];
	[view.layout applyStyle];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

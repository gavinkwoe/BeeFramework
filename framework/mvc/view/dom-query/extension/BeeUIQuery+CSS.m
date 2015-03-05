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

#import "BeeUIQuery+CSS.h"

#import "Bee_UIStyle.h"
#import "Bee_UIStyleParser.h"
#import "BeeUIStyle+Builder.h"
#import "BeeUIStyle+Property.h"

#import "Bee_UILayout.h"
#import "UIView+BeeUILayout.h"
#import "UIView+BeeUIStyle.h"
#import "UIView+Tag.h"

#pragma mark -

@implementation BeeUIQuery(CSS)

@dynamic css;

@dynamic CSS;
@dynamic ATTR;

@dynamic ADD_CLASS;
@dynamic HAS_CLASS;
@dynamic SET_CLASS;
@dynamic REMOVE_CLASS;
@dynamic TOGGLE_CLASS;

- (NSString *)css
{
	UIView * view = self.view;
	if ( nil == view )
		return nil;

	if ( nil == view.layout )
		return nil;

	if ( nil == view.UIStyle )
	{
		[view mergeStyle];
	}

	return view.UIStyle.css;
}

- (BeeUIQueryObjectBlockN)CSS
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		NSDictionary * properties = [BeeUIStyleParser parseProperties:first];

		if ( properties && properties.count )
		{            
			for ( UIView * v in self.views )
			{
				[v addStyleProperties:properties];
				[v mergeStyle];
				[v applyStyle];
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
			NSDictionary * properties = [NSDictionary dictionaryWithObject:value2 forKey:value1];
			
			for ( UIView * v in self.views )
			{
				[v addStyleProperties:properties];
				[v mergeStyle];
				[v applyStyle];
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
		
		for ( UIView * v in subviews )
		{
			BOOL flag = [v hasStyleClass:value];
			if ( flag )
			{
				return YES;
			}
		}
		
		return NO;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockN)SET_CLASS
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first && [first isKindOfClass:[NSString class]] )
		{
			NSArray * classes = [(NSString *)first componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			if ( classes.count )
			{
				for ( UIView * v in self.views )
				{
					[v removeAllStyleClasses];
					
					for ( NSString * className in classes )
					{
						[v addStyleClass:className];
					}
					
					[v mergeStyle];
					[v applyStyle];
				}
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockN)ADD_CLASS
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first && [first isKindOfClass:[NSString class]] )
		{
			NSArray * classes = [(NSString *)first componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			if ( classes.count )
			{
				for ( UIView * v in self.views )
				{
					for ( NSString * className in classes )
					{
						[v addStyleClass:className];
					}
					
					[v mergeStyle];
					[v applyStyle];					
				}
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
			NSArray * classes = [(NSString *)first componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			if ( classes.count )
			{
				for ( UIView * v in self.views )
				{
					for ( NSString * className in classes )
					{
						[v removeStyleClass:className];
					}
					
					[v mergeStyle];
					[v applyStyle];
				}
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
			NSArray * classes = [(NSString *)first componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			if ( classes.count )
			{
				for ( UIView * v in self.views )
				{
					for ( NSString * className in classes )
					{
						[v toggleStyleClass:className];
					}
					
					[v mergeStyle];
					[v applyStyle];					
				}
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

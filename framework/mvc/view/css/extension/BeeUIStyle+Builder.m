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

#import "BeeUIStyle+Builder.h"
#import "BeeUIStyle+Property.h"
#import "Bee_UIStyleParser.h"
#import "CSSStyleSheet.h"

#pragma mark -

@implementation BeeUIStyle(Builder)

@dynamic css;
@dynamic CSS;

- (BeeUIStyle *)childStyleWithName:(NSString *)name
{
	if ( nil == name || 0 == name.length )
	{
		return nil;
	}
	
	if ( [self.name isEqualToString:name] )
	{
		return self;
	}
	
	return [self.childs objectForKey:name];
}

- (BeeUIStyle *)childStyleWithOneOfNames:(NSArray *)names
{
	for ( NSString * name in names )
	{
		BeeUIStyle * style = [self childStyleWithName:name];
		if ( style )
		{
			return style;
		}
	}
	
	return nil;
}

- (BeeUIStyle *)childStyleWithString:(id)element
{
    NSDictionary * properties = [self.styleSheet styleForString:element];
    
    if ( properties )
    {
        BeeUIStyle * style = [BeeUIStyle style];
        [style.properties addEntriesFromDictionary:properties];
        return style;
    }
    
    return nil;
}

- (BeeUIStyle *)childStyleWithClasses:(id)element
{
	NSMutableDictionary * mergedProperties = [NSMutableDictionary dictionary];
	
	for ( NSString * clazz in element )
	{
		NSDictionary * properties = [self.styleSheet styleForString:clazz];
		if ( properties )
		{
			[mergedProperties addEntriesFromDictionary:properties];
		}
	}
	
	if ( mergedProperties.count )
	{
		BeeUIStyle * style = [BeeUIStyle style];
        [style.properties addEntriesFromDictionary:mergedProperties];
        return style;
	}
	
	return nil;
}

- (BeeUIStyle *)childStyleWithElement:(id)element
{
    NSDictionary * properties = [self.styleSheet styleForElement:element];
    
    if ( properties && properties.count )
    {
        BeeUIStyle * style = [BeeUIStyle style];
        [style.properties addEntriesFromDictionary:properties];
        return style;
    }
    
    return nil;
}

#pragma mark -

- (void)addChild:(BeeUIStyle *)style
{
	if ( self.isRoot )
	{
		style.root = self;
	}
	else
	{
		self.root = self.root;
	}
	
	style.parent = self;
	
	[self.childs setObject:style forKey:style.name];
}

- (void)removeChilds
{
	[self.childs removeAllObjects];
}

#pragma mark -

- (void)clearCSS
{
	[self.properties removeAllObjects];
}

- (void)buildCSS:(id)css
{
	[self clearCSS];
	[self appendCSS:css];
}

- (void)buildCSSTree:(id)cssArray
{
	[self removeChilds];
	[self appendCSSTree:cssArray];
}

- (void)appendCSS:(id)css
{
	NSMutableDictionary * dict = nil;
	
	if ( css )
	{
		if ( [css isKindOfClass:[NSString class]] )
		{
			dict = [BeeUIStyleParser parseProperties:css];
		}
		else if ( [css isKindOfClass:[NSDictionary class]] )
		{
			dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)css];
		}
	}
	
	if ( nil == dict || 0 == dict.count )
		return;
	
	NSString * left = [dict stringOfAny:@[@"x", @"left"] removeAll:YES];
	if ( left )
	{
		self.LEFT( left );
	}

	NSString * top = [dict stringOfAny:@[@"y", @"top"] removeAll:YES];
	if ( top )
	{
		self.TOP( top );
	}

	NSString * right = [dict stringOfAny:@[@"right"] removeAll:YES];
	if ( right )
	{
		self.RIGHT( right );
	}

	NSString * bottom = [dict stringOfAny:@[@"bottom"] removeAll:YES];
	if ( bottom )
	{
		self.BOTTOM( bottom );
	}

	NSString * w = [dict stringOfAny:@[@"w", @"width"] removeAll:YES];
	if ( w )
	{
		self.W( w );
	}
	
	NSString * h = [dict stringOfAny:@[@"h", @"height"] removeAll:YES];
	if ( h )
	{
		self.H( h );
	}
	
	NSString * max_w = [dict stringOfAny:@[@"max-w", @"max-width"] removeAll:YES];
	if ( max_w )
	{
		self.MAX_WIDTH( max_w );
	}
	
	NSString * max_h = [dict stringOfAny:@[@"max-h", @"max-height"] removeAll:YES];
	if ( max_h )
	{
		self.MAX_HEIGHT( max_h );
	}
	
	NSString * min_w = [dict stringOfAny:@[@"min-w", @"min-width"] removeAll:YES];
	if ( min_w )
	{
		self.MIN_WIDTH( min_w );
	}
	
	NSString * min_h = [dict stringOfAny:@[@"min-h", @"min-height"] removeAll:YES];
	if ( min_h )
	{
		self.MIN_HEIGHT( max_h );
	}
	
	NSString * pos = [dict stringOfAny:@[@"position"] removeAll:YES];
	if ( pos )
	{
		self.POSITION( pos );
	}
	
	NSString * align = [dict stringOfAny:@[@"align"] removeAll:YES];
	if ( align )
	{
		self.ALIGN( align );
	}
	
	NSString * v_align = [dict stringOfAny:@[@"valign", @"v-align", @"vertical-align"] removeAll:YES];
	if ( v_align )
	{
		self.V_ALIGN( v_align );
	}
	
	NSString * floating = [dict stringOfAny:@[@"float"] removeAll:YES];
	if ( floating )
	{
		self.FLOATING( floating );
	}
	
	NSString * v_floating = [dict stringOfAny:@[@"vfloat", @"v-float", @"vertical-float"] removeAll:YES];
	if ( v_floating )
	{
		self.V_FLOATING( v_floating );
	}
	
	NSString * orientation = [dict stringOfAny:@[@"orient", @"orientation"] removeAll:YES];
	if ( orientation )
	{
		if ( [orientation matchAnyOf:@[@"h", @"hori", @"horizonal"]] )
		{
			self.ORIENTATION( BeeUIStyle.ORIENTATION_HORIZONAL );
		}
		else if ( [orientation matchAnyOf:@[@"v", @"vert", @"vertical"]] )
		{
			self.ORIENTATION( BeeUIStyle.ORIENTATION_VERTICAL );
		}
		else
		{
			self.ORIENTATION( BeeUIStyle.ORIENTATION_VERTICAL );
		}
	}
	
	NSString * margin = [dict stringOfAny:@[@"margin"] removeAll:YES];
	if ( margin )
	{
		NSArray * components = [margin.trim componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ( components.count == 1 )
		{
			self.MARGIN( ((NSString *)[components objectAtIndex:0]).trim );
		}
		else if ( components.count == 2 )
		{
			self.MARGIN_TOP( ((NSString *)[components objectAtIndex:0]).trim );
			self.MARGIN_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
			self.MARGIN_BOTTOM( ((NSString *)[components objectAtIndex:0]).trim );
			self.MARGIN_LEFT( ((NSString *)[components objectAtIndex:1]).trim );
		}
		else if ( components.count == 4 )
		{
			self.MARGIN_TOP( ((NSString *)[components objectAtIndex:0]).trim );
			self.MARGIN_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
			self.MARGIN_BOTTOM( ((NSString *)[components objectAtIndex:2]).trim );
			self.MARGIN_LEFT( ((NSString *)[components objectAtIndex:3]).trim );
		}
	}
	else
	{
		NSString * margin_left = [dict stringOfAny:@[@"margin-left"] removeAll:YES];
		if ( margin_left )
		{
			self.MARGIN_LEFT( margin_left.trim );
		}
		
		NSString * margin_right = [dict stringOfAny:@[@"margin-right"] removeAll:YES];
		if ( margin_right )
		{
			self.MARGIN_RIGHT( margin_right.trim );
		}
		
		NSString * margin_top = [dict stringOfAny:@[@"margin-top"] removeAll:YES];
		if ( margin_top )
		{
			self.MARGIN_TOP( margin_top.trim );
		}
		
		NSString * margin_bottom = [dict stringOfAny:@[@"margin-bottom"] removeAll:YES];
		if ( margin_bottom )
		{
			self.MARGIN_BOTTOM( margin_bottom.trim );
		}
	}
	
	NSString * padding = [dict stringOfAny:@[@"padding"] removeAll:YES];
	if ( padding )
	{
		NSArray * components = [padding.trim componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ( components.count == 1 )
		{
			self.PADDING( ((NSString *)[components objectAtIndex:0]).trim );
		}
		else if ( components.count == 2 )
		{
			self.PADDING_TOP( ((NSString *)[components objectAtIndex:0]).trim );
			self.PADDING_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
			self.PADDING_BOTTOM( ((NSString *)[components objectAtIndex:0]).trim );
			self.PADDING_LEFT( ((NSString *)[components objectAtIndex:1]).trim );
		}
		else if ( components.count == 4 )
		{
			self.PADDING_TOP( ((NSString *)[components objectAtIndex:0]).trim );
			self.PADDING_RIGHT( ((NSString *)[components objectAtIndex:1]).trim );
			self.PADDING_BOTTOM( ((NSString *)[components objectAtIndex:2]).trim );
			self.PADDING_LEFT( ((NSString *)[components objectAtIndex:3]).trim );
		}
	}
	else
	{
		NSString * padding_left = [dict stringOfAny:@[@"padding-left"] removeAll:YES];
		if ( padding_left )
		{
			self.PADDING_LEFT( padding_left.trim );
		}
		
		NSString * padding_right = [dict stringOfAny:@[@"padding-right"] removeAll:YES];
		if ( padding_right )
		{
			self.PADDING_RIGHT( padding_right.trim );
		}
		
		NSString * padding_top = [dict stringOfAny:@[@"padding-top"] removeAll:YES];
		if ( padding_top )
		{
			self.PADDING_TOP( padding_top.trim );
		}
		
		NSString * padding_bottom = [dict stringOfAny:@[@"padding-bottom"] removeAll:YES];
		if ( padding_bottom )
		{
			self.PADDING_BOTTOM( padding_bottom.trim );
		}
	}
	
	[self.properties addEntriesFromDictionary:dict];
}

- (void)appendCSSTree:(id)cssArray
{
	NSDictionary * dict = nil;
	
	if ( nil == cssArray )
		return;
	
	if ( cssArray )
	{
		if ( [cssArray isKindOfClass:[NSString class]] )
		{
			dict = [BeeUIStyleParser parse:cssArray];
		}
		else if ( [cssArray isKindOfClass:[NSDictionary class]] )
		{
			dict = (NSDictionary *)cssArray;
		}
	}
	
	if ( nil == dict || 0 == dict.count )
		return;
	
	for ( NSString * key in dict.allKeys )
	{
		BeeUIStyle * style = [BeeUIStyle style];
		if ( style )
		{
			style.name = key;
			style.CSS( [dict objectForKey:key] );
			style.PACKAGE( self.package );
			
			[self addChild:style];
		}
	}
	
	CSSStyleSheet * sheet = [BeeUIStyleParser parseStyleSheet:cssArray];
	if ( sheet )
	{
		[self.styleSheet mergeStyleSheet:sheet];
	}
}

#pragma mark -

- (id)objectForKey:(id)aKey
{
	return [self.properties objectForKey:aKey];
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
	NSDictionary * css = [NSDictionary dictionaryWithObject:anObject forKey:aKey];
	[self appendCSS:css];
}

- (id)objectForKeyedSubscript:(id)key
{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setObject:obj forKey:key];
}

#pragma mark -

- (NSString *)css
{
	NSMutableString * cssText = [NSMutableString string];
	
	[cssText appendFormat:@"%@ { ", self.name];
	
	for ( NSString * key in self.properties.allKeys )
	{
		NSString * value = [self.properties objectForKey:key];
		[cssText appendFormat:@"%@ : %@; ", key, value];
	}
	
	[cssText appendString:@"}"];
	
	return cssText;
}

- (BeeUIStyleBlockN)CSS
{
	BeeUIStyleBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		[self appendCSS:first];
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

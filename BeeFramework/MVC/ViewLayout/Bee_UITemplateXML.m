//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  Bee_UITemplateXML.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Log.h"
#import "Bee_UITemplateXML.h"
#import "UIView+BeeExtension.h"
#import "NSArray+BeeExtension.h"
#import "NSString+BeeExtension.h"

#import "Bee_UIStyle.h"
#import "Bee_UITemplate.h"

#import "JSONKit.h"
#import "TouchXML.h"

#pragma mark -

@interface BeeUITemplateXML()

AS_INT( ELEM_TYPE_UNKNOWN )
AS_INT( ELEM_TYPE_TEMPLATE )
AS_INT( ELEM_TYPE_LAYOUT )
AS_INT( ELEM_TYPE_CONTAINER )
AS_INT( ELEM_TYPE_SUBVIEW )
AS_INT( ELEM_TYPE_SPACE )
AS_INT( ELEM_TYPE_STYLE )

@end

#pragma mark -

@implementation BeeUITemplateXML

DEF_INT( ELEM_TYPE_UNKNOWN,		0 )
DEF_INT( ELEM_TYPE_TEMPLATE,	1 )
DEF_INT( ELEM_TYPE_LAYOUT,		2 )
DEF_INT( ELEM_TYPE_CONTAINER,	3 )
DEF_INT( ELEM_TYPE_SUBVIEW,		4 )
DEF_INT( ELEM_TYPE_SPACE,		5 )
DEF_INT( ELEM_TYPE_STYLE,		6 )

- (NSInteger)guessElementType:(CXMLElement *)elem
{
	if ( NSOrderedSame == [elem.name compare:@"ui" options:NSCaseInsensitiveSearch] )
	{
		return self.ELEM_TYPE_TEMPLATE;
	}
	else if ( NSOrderedSame == [elem.name compare:@"view" options:NSCaseInsensitiveSearch] )
	{
		return self.ELEM_TYPE_SUBVIEW;
	}
	else if ( NSOrderedSame == [elem.name compare:@"container" options:NSCaseInsensitiveSearch] )
	{
		return self.ELEM_TYPE_CONTAINER;
	}
	else if ( NSOrderedSame == [elem.name compare:@"layout" options:NSCaseInsensitiveSearch] )
	{
		return self.ELEM_TYPE_LAYOUT;
	}
	else if ( NSOrderedSame == [elem.name compare:@"space" options:NSCaseInsensitiveSearch] )
	{
		return self.ELEM_TYPE_SPACE;
	}
	else if ( NSOrderedSame == [elem.name compare:@"style" options:NSCaseInsensitiveSearch] )
	{
		return self.ELEM_TYPE_STYLE;
	}

	return self.ELEM_TYPE_UNKNOWN;
}

- (void)parseAttributes:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSString * x = [[elem attributeForName:@"x"] stringValue];
	if ( x )
	{
		layout.X( x );
	}
	
	NSString * y = [[elem attributeForName:@"y"] stringValue];
	if ( y )
	{
		layout.Y( y );
	}
	
	NSString * w = [[elem attributeForName:@"w"] stringValue];
	if ( nil == w )
	{
		w = [[elem attributeForName:@"width"] stringValue];
	}
	
	if ( w )
	{
		layout.W( w );
	}
	
	NSString * h = [[elem attributeForName:@"h"] stringValue];
	if ( nil == h )
	{
		h = [[elem attributeForName:@"height"] stringValue];
	}
	
	if ( h )
	{
		layout.H( h );
	}
	
	NSString * pos = [[elem attributeForName:@"position"] stringValue];
	if ( pos )
	{
		layout.POSITION( pos );
	}
	
	NSString * align = [[elem attributeForName:@"align"] stringValue];
	if ( align )
	{
		layout.ALIGN( align );
	}
	
	NSString * v_align = [[elem attributeForName:@"v_align"] stringValue];
	if ( v_align )
	{
		layout.V_ALIGN( v_align );
	}
	
	NSString * orientation = [[elem attributeForName:@"orientation"] stringValue];
	if ( orientation )
	{
		layout.ORIENTATION( orientation );
	}
	
	NSString * autoresizeWidth = [[elem attributeForName:@"autoresize_width"] stringValue];
	if ( autoresizeWidth )
	{
		layout.AUTORESIZE_WIDTH( autoresizeWidth.boolValue );
	}
	
	NSString * autoresizeHeight = [[elem attributeForName:@"autoresize_height"] stringValue];
	if ( autoresizeHeight )
	{
		layout.AUTORESIZE_HEIGHT( autoresizeHeight.boolValue );
	}
	
	NSString * frame = [[elem attributeForName:@"frame"] stringValue];
	if ( frame )
	{
		NSArray * components = [frame componentsSeparatedByString:@","];
		if ( components.count >= 2 )
		{
			layout.X( ((NSString *)[components objectAtIndex:0]).trim );
			layout.Y( ((NSString *)[components objectAtIndex:1]).trim );
		}
		if ( components.count >= 4 )
		{
			layout.W( ((NSString *)[components objectAtIndex:2]).trim );
			layout.H( ((NSString *)[components objectAtIndex:3]).trim );
		}
	}

	
	NSString * styleID = [[elem attributeForName:@"style"] stringValue];
	if ( nil == styleID )
	{
		styleID = [[elem attributeForName:@"style_id"] stringValue];
	}
	
	layout.styleID = styleID;
}

- (void)parseLayout:(CXMLElement *)elem forLayout:(BeeUILayout *)parentLayout
{
	BeeUILayout * layout = nil;
	
	if ( nil == parentLayout )
	{
		layout = [[[BeeUILayout alloc] init] autorelease];

		NSString * elemID = [[elem attributeForName:@"id"] stringValue];
		if ( elemID )
		{
			layout.name = elemID;
		}
	}
	else
	{
		layout = parentLayout;
	}

	if ( layout )
	{
		layout = layout.BEGIN_LAYOUT();
		if ( layout )
		{
			[self parseAttributes:elem forLayout:layout];
			
			for ( CXMLElement * child in elem.children )
			{
				if ( NO == [child isKindOfClass:[CXMLElement class]] )
					continue;
				
				[self parseElement:child forLayout:layout];
			}
			
			layout.END_LAYOUT();	
		}

		self.rootLayout = layout;
	}
}

- (void)parseContainer:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSString * elemID = [[elem attributeForName:@"id"] stringValue];

	layout = layout.BEGIN_CONTAINER( elemID );
	if ( layout )
	{
		[self parseAttributes:elem forLayout:layout];
		
		for ( CXMLElement * child in elem.children )
		{
			if ( NO == [child isKindOfClass:[CXMLElement class]] )
				continue;
			
			[self parseElement:child forLayout:layout];
		}

		layout.END_CONTAINER();
	}
}

- (void)parseSubview:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSString * elemID = [[elem attributeForName:@"id"] stringValue];
	NSString * classType = [[elem attributeForName:@"class"] stringValue];

	layout = layout.VIEW( NSClassFromString(classType), elemID );
	if ( layout )
	{
		[self parseAttributes:elem forLayout:layout];
		
		for ( CXMLElement * child in elem.children )
		{
			if ( NO == [child isKindOfClass:[CXMLElement class]] )
				continue;

			[self parseElement:child forLayout:layout];
		}
	}
}

- (void)parseSpace:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	layout = layout.SPACE();
	if ( layout )
	{
		[self parseAttributes:elem forLayout:layout];

		for ( CXMLElement * child in elem.children )
		{
			if ( NO == [child isKindOfClass:[CXMLElement class]] )
				continue;

			[self parseElement:child forLayout:layout];
		}
	}
}

- (void)parseTemplate:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSString * elemID = [[elem attributeForName:@"id"] stringValue];
	if ( elemID )
	{
		self.name = elemID;
	}

	for ( CXMLElement * child in elem.children )
	{
		if ( NO == [child isKindOfClass:[CXMLElement class]] )
			continue;
		
		[self parseElement:child forLayout:layout];
	}
}

- (void)parseStyle:(CXMLElement *)elem
{
	BeeUIStyle * style = [[[BeeUIStyle alloc] init] autorelease];
	if ( style )
	{
		NSString * elemID = [[elem attributeForName:@"id"] stringValue];
		if ( elemID )
		{
			style.name = elemID;
		}

		NSString * text = [elem stringValue].trim;
		if ( [text hasPrefix:@"{"] )
		{
			NSDictionary * props = [text objectFromJSONString];
			if ( props && props.count )
			{
				[style.properties addEntriesFromDictionary:props];
			}
		}
		else
		{
			NSArray * segments = [text componentsSeparatedByString:@";"];
			for ( NSString * seg in segments )
			{
				NSArray * keyValue = [seg componentsSeparatedByString:@":"];
				if ( keyValue.count == 2 )
				{
					NSString * key = [keyValue objectAtIndex:0];
					NSString * val = [keyValue objectAtIndex:1];
					
					key = key.trim.unwrap;
					val = val.trim.unwrap;

					[style.properties setObject:val forKey:key];
				}
			}
		}
		
		[self.rootStyles setObject:style forKey:style.name];
	}
}

- (void)parseElement:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSInteger elemType = [self guessElementType:elem];

	if ( self.ELEM_TYPE_TEMPLATE == elemType )
	{
		[self parseTemplate:elem forLayout:layout];
	}
	else if ( self.ELEM_TYPE_LAYOUT == elemType )
	{
		[self parseLayout:elem forLayout:layout];
	}
	else if ( self.ELEM_TYPE_CONTAINER == elemType )
	{
		[self parseContainer:elem forLayout:layout];
	}
	else if ( self.ELEM_TYPE_SUBVIEW == elemType )
	{
		[self parseSubview:elem forLayout:layout];
	}
	else if ( self.ELEM_TYPE_SPACE == elemType )
	{
		[self parseSpace:elem forLayout:layout];
	}
	else if ( self.ELEM_TYPE_STYLE == elemType )
	{
		[self parseStyle:elem];
	}
}

- (void)matchStylesForLayout:(BeeUILayout *)layout
{
	if ( layout.styleID )
	{
		BeeUIStyle * style = [self.rootStyles objectForKey:layout.styleID];
		if ( style )
		{
			layout.style = style;
		}
	}

	for ( BeeUILayout * subLayout in layout.childs )
	{
		[self matchStylesForLayout:subLayout];
	}
}

- (BOOL)parse:(NSData *)data
{
	if ( nil == data )
		return NO;

	[self.rootStyles removeAllObjects];
	
	NSError * error = nil;
	CXMLDocument * doc = [[[CXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding options:0 error:&error] autorelease];
	if ( nil == doc )
	{
		CC( @"Failed to open XML document" );
		return NO;
	}

	CXMLElement * root = doc.rootElement;
	if ( nil == root )
	{
		CC( @"Root node not found" );
		return NO;
	}

	[self parseElement:root forLayout:nil];
	[self matchStylesForLayout:self.rootLayout];

	return YES;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

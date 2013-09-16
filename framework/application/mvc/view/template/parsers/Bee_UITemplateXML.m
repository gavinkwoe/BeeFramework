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

#import "Bee_UITemplateXML.h"

#import "Bee_UILayout.h"
#import "Bee_UIStyle.h"

#pragma mark -

@implementation BeeUITemplateXML

static NSMutableDictionary * __mapping = nil;

+ (NSMutableDictionary *)classMapping
{
	if ( nil == __mapping )
	{
		__mapping = [[NSMutableDictionary alloc] init];
		__mapping.APPEND( @"view",		@"UIView" );
		__mapping.APPEND( @"image",		@"BeeUIImageView" );
		__mapping.APPEND( @"label",		@"BeeUILabel" );
		__mapping.APPEND( @"input",		@"BeeUITextField" );
		__mapping.APPEND( @"button",	@"BeeUIButton" );
		__mapping.APPEND( @"scroll",	@"BeeUIScrollView" );
		__mapping.APPEND( @"indicator",	@"BeeUIActivityIndicatorView" );
		__mapping.APPEND( @"textArea",	@"BeeUITextView" );
		__mapping.APPEND( @"switch",	@"BeeUISwitch" );
		__mapping.APPEND( @"slider",	@"BeeUISlider" );
		__mapping.APPEND( @"check",		@"BeeUICheck" );
		__mapping.APPEND( @"zoom",		@"BeeUIZoomView" );
	}
	
	return __mapping;
}

- (NSDictionary *)viewClassMapping
{
	return [BeeUITemplateXML classMapping];
}

+ (void)map:(NSString *)tag toClass:(Class)clazz
{
	if ( nil == tag || nil == clazz )
		return;
	
	NSMutableDictionary * mapping = [BeeUITemplateXML classMapping];
	if ( mapping )
	{
		[mapping setObject:[clazz description] forKey:tag];
	}
}

+ (void)unmap:(NSString *)tag
{
	if ( nil == tag )
		return;

	NSMutableDictionary * mapping = [BeeUITemplateXML classMapping];
	if ( mapping )
	{
		[mapping removeObjectForKey:tag];
	}
}

- (void)parseAttributes:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSString * styleClass = [[elem attributeForName:@"class"] stringValue];
    if ( styleClass && styleClass.length )
    {
		NSArray * styleClasses = [styleClass componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		for ( NSString * className in styleClasses )
		{
			className = className.trim;
			if ( className && className.length )
			{
				[layout.styleClasses addObject:className];
			}
		}
    }
	
    NSString * style = [[elem attributeForName:@"style"] stringValue];
    if ( style )
    {
        layout.styleInline.CSS( style );
    }
    
    for ( CXMLNode * attr in elem.attributes )
    {
        layout.styleInline.PROPERTY( attr.name, attr.stringValue );
    }
}

- (void)parseContent:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSMutableString * string = nil;;
	
	for ( CXMLElement * child in elem.children )
	{
		if ( child.kind == CXMLTextKind )
		{
			if ( nil == string )
			{
				string = [NSMutableString string];
			}
			
			NSString *	text = [child stringValue];
			NSArray *	segments = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

			if ( segments.count > 1 )
			{
				for ( NSString * segment in segments )
				{
					segment = segment.trim;
					if ( segment && segment.length )
					{
						[string appendString:[segment stringByAppendingString:@"\n"]];
					}
				}
			}
			else
			{
				[string appendString:text.trim];
			}
		}
	}

	if ( string && string.length )
	{
		layout.styleInline.PROPERTY( @"text", string );
	}
}

- (void)parseAbsoluteLayout:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSString * elemID = [[elem attributeForName:@"id"] stringValue];
	//	NSString * classType = [[elem attributeForName:@"type"] stringValue];
	
	layout = layout.BEGIN_CONTAINER( elemID );
	if ( layout )
	{
		layout.styleInline.COMPOSITION( BeeUIStyle.COMPOSITION_ABSOLUTE );
		
		[self parseAttributes:elem forLayout:layout];
		
		for ( CXMLElement * child in elem.children )
		{
			if ( child.kind != CXMLElementKind )
				continue;
			
			[self parseElement:child forLayout:layout];
		}
		
		layout.END_CONTAINER();
	}
}

- (void)parseRelativeLayout:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSString * elemID = [[elem attributeForName:@"id"] stringValue];
	//	NSString * classType = [[elem attributeForName:@"type"] stringValue];
	
	layout = layout.BEGIN_CONTAINER( elemID );
	if ( layout )
	{
		layout.styleInline.COMPOSITION( BeeUIStyle.COMPOSITION_RELATIVE );
		
		[self parseAttributes:elem forLayout:layout];
		
		for ( CXMLElement * child in elem.children )
		{
			if ( child.kind != CXMLElementKind )
				continue;
			
			[self parseElement:child forLayout:layout];
		}
		
		layout.END_CONTAINER();
	}
}

- (void)parseLinearLayout:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSString * elemID = [[elem attributeForName:@"id"] stringValue];
    //	NSString * classType = [[elem attributeForName:@"type"] stringValue];
	
	layout = layout.BEGIN_CONTAINER( elemID );
	if ( layout )
	{
		layout.styleInline.COMPOSITION( BeeUIStyle.COMPOSITION_LINEAR );
        
		[self parseAttributes:elem forLayout:layout];
		
		for ( CXMLElement * child in elem.children )
		{
			if ( child.kind != CXMLElementKind )
				continue;
			
			[self parseElement:child forLayout:layout];
		}
        
		layout.END_CONTAINER();
	}
}

- (void)parseView:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSString * elemID = [[elem attributeForName:@"id"] stringValue];
	NSString * classType = [[elem attributeForName:@"type"] stringValue];

    if ( nil == classType && 0 == classType.length )
    {
        classType = elem.name;
		classType = [[self viewClassMapping] objectForKey:classType];
		
		if ( nil == classType )
		{
			ERROR( @"unknown elem type, '%@'", elem.name );

			classType = @"UIView";
		}
    }

    layout = layout.VIEW( NSClassFromString(classType), elemID );
	
    if ( layout )
    {
        [self parseAttributes:elem forLayout:layout];
		[self parseContent:elem forLayout:layout];		
	}
}

- (void)parseUI:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	if ( nil == self.rootLayout )
	{
		self.rootLayout = [[[BeeUILayout alloc] init] autorelease];
		self.rootLayout.isRoot = YES;
		self.rootLayout.containable = YES;
		self.rootLayout.visible = YES;
		
		NSString * name = [[elem attributeForName:@"namespace"] stringValue];
		if ( name && name.length )
		{
			self.rootLayout.name = name;
		}
		else
		{
			self.rootLayout.name = nil;
		}
		
		[self parseAttributes:elem forLayout:self.rootLayout];
		
		for ( CXMLElement * child in elem.children )
		{
			if ( child.kind != CXMLElementKind )
				continue;
			
			[self parseElement:child forLayout:self.rootLayout];
		}
	}
}

- (void)parseStyle:(CXMLElement *)elem
{
	NSString * type = [[elem attributeForName:@"type"] stringValue];
	
	if ( nil == type || NSOrderedSame == [type compare:@"text/css" options:NSCaseInsensitiveSearch] )
	{
		NSString * text = [elem stringValue].trim;
		
		NSArray * segments = [text componentsSeparatedByString:@"}"];
		for ( NSString * seg in segments )
		{
			NSArray * keyValue = [seg componentsSeparatedByString:@"{"];
			if ( keyValue.count == 2 )
			{
				NSString * key = [keyValue objectAtIndex:0];
				NSString * val = [keyValue objectAtIndex:1];
				
				key = key.trim.unwrap;
				val = val.trim.unwrap;
				
				if ( key.length && val.length )
				{
					BeeUIStyle * style = [[[BeeUIStyle alloc] init] autorelease];
					if ( style )
					{
						style.name = key;
						style.CSS( val );
					}
					
					[self.rootLayout.rootStyles setObject:style forKey:key];
				}
			}
		}
	}
	else if ( NSOrderedSame == [type compare:@"text/json" options:NSCaseInsensitiveSearch] )
	{
		// TODO:
	}
}

- (void)parseElement:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	if ( [[self viewClassMapping].allKeys containsObject:elem.name] )
	{
		[self parseView:elem forLayout:layout];
	}
	else if ( [elem.name matchAnyOf:@[@"linear", @"layout"]] )
	{
		[self parseLinearLayout:elem forLayout:layout];
	}
	else if ( [elem.name matchAnyOf:@[@"absolute"]] )
	{
		[self parseAbsoluteLayout:elem forLayout:layout];
	}
	else if ( [elem.name matchAnyOf:@[@"relative"]] )
	{
		[self parseRelativeLayout:elem forLayout:layout];
	}
	else if ( [elem.name matchAnyOf:@[@"style"]] )
	{
		[self parseStyle:elem];
	}
    else if ( [elem.name matchAnyOf:@[@"ui"]] )
    {
        [self parseUI:elem forLayout:layout];
    }
}

- (void)matchStylesForLayout:(BeeUILayout *)layout
{
	[layout mergeStyle];
	
	for ( BeeUILayout * subLayout in layout.childs )
	{
		[self matchStylesForLayout:subLayout];
	}
}

//- (void)matchPositionForLayout:(BeeUILayout *)layout
//{
//	NSString * position = nil;
//
//	if ( layout.containable && layout.style.composition )
//	{
//		if ( [layout.style.composition isEqualToString:BeeUIStyle.COMPOSITION_ABSOLUTE] )
//		{
//			position = BeeUIStyle.POSITION_ABSOLUTE;
//		}
//		else
//		{
//			position = BeeUIStyle.POSITION_RELATIVE;
//		}
//	}
//
//	for ( BeeUILayout * subLayout in layout.childs )
//	{
//		if ( position )
//		{
//			subLayout.style.POSITION( position );
//		}
//
//		[self matchPositionForLayout:subLayout];
//	}
//}

- (BOOL)parseText:(NSString *)text
{
	return [self parseData:[text asNSData]];
}

- (BOOL)parseData:(NSData *)data
{
	if ( nil == data )
		return NO;
	
	self.rootLayout = nil;
	
	NSError * error = nil;
	CXMLDocument * doc = [[[CXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding options:0 error:&error] autorelease];
	if ( nil == doc )
	{
		ERROR( @"Failed to open XML document" );
		return NO;
	}
	
	CXMLElement * root = doc.rootElement;
	if ( nil == root )
	{
		ERROR( @"Root node not found" );
		return NO;
	}
	
	[self parseElement:root forLayout:nil];
	
	[self matchStylesForLayout:self.rootLayout];
//	[self matchPositionForLayout:self.rootLayout];
	
	return YES;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

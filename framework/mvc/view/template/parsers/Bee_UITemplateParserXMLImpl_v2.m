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

#import "Bee_UITemplateParserXMLImpl_v2.h"
#import "Bee_UITemplateMediaQuery.h"

#import "Bee_UILayout.h"
#import "Bee_UILayoutContainer.h"

#import "Bee_UIStyle.h"
#import "Bee_UIStyleParser.h"
#import "BeeUIStyle+Builder.h"
#import "BeeUIStyle+Property.h"

#pragma mark -

@interface BeeUITemplateParserXMLImpl_v2()
{
	BeeUILayout *	_rootLayout;
	BeeUIStyle *	_rootStyle;
}

- (void)parseElement:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseElementTemplate:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseElementLayout:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseElementStyle:(CXMLElement *)elem;
- (void)parseElementView:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;

- (void)parseAttr:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseText:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseChilds:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;

- (void)renderLayout:(BeeUILayout *)layout;

@end

#pragma mark -

@implementation BeeUITemplateParserXMLImpl_v2

- (void)parseAttr:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
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
        [layout.styleInline setObject:attr.stringValue forKey:attr.name];
    }
}

- (void)parseText:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
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
			
			NSString *	text = [child stringValue].trim;
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
		layout.styleInline.TEXT( string );
	}
}

- (void)parseChilds:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	for ( CXMLElement * child in elem.children )
	{
		if ( child.kind == CXMLElementKind )
		{
			[self parseElement:child forLayout:layout];
		}
	}
}

- (void)parseElementTemplate:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	ASSERT( nil != layout );
	
	NSString * name = [[elem attributeForName:@"namespace"] stringValue];
	if ( nil == name )
	{
		name = [[elem attributeForName:@"name"] stringValue];
	}

	if ( name && name.length )
	{
		layout.name = name;
	}

	layout.version = 2;
	layout.classType = nil;
	layout.className = nil;

	[self parseAttr:elem forLayout:layout];
	[self parseChilds:elem forLayout:layout];
}

- (void)parseElementLayout:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	if ( nil == layout )
		return;
	
	NSString * elemID = [[elem attributeForName:@"id"] stringValue];
	NSString * elemName = [elem name];
//	NSString * classType = [[elem attributeForName:@"type"] stringValue];

	layout = layout.CONTAINER_BEGIN( elemID );
	if ( layout )
	{
		layout.version = 2;
		layout.classType = [BeeUILayoutContainer class];
		layout.className = [layout.classType description];

		if ( [elemName isEqualToString:@"row"] )
		{
			layout.styleInline.ORIENTATION( BeeUIStyle.ORIENTATION_HORIZONAL );
		}
		else if ( [elemName isEqualToString:@"column"] )
		{
			layout.styleInline.ORIENTATION( BeeUIStyle.ORIENTATION_VERTICAL );
		}
		
		[self parseAttr:elem forLayout:layout];
		[self parseChilds:elem forLayout:layout];
		
		layout.CONTAINER_END();
	}
}

- (void)parseElementView:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	if ( nil == layout )
		return;
	
	NSString *	elemID = [[elem attributeForName:@"id"] stringValue];
	NSString *	elemName = [elem name];
	NSString *	classType = [[elem attributeForName:@"type"] stringValue];

	if ( nil == classType && 0 == classType.length )
	{
		classType = elem.name;
		classType = [self.classMapping objectForKey:classType];
		
		if ( nil == classType )
		{
			ERROR( @"unknown elem type, '%@'", elem.name );
			classType = @"UIView";
		}
	}

	Class viewClass = NSClassFromString( classType );
	if ( nil == viewClass )
	{
		ERROR( @"unknown elem type, '%@'", elem.name );
		return;
	}
	
	layout = layout.VIEW( elemID );
	if ( layout )
	{
		layout.version = 2;
		layout.classType = viewClass;
		layout.className = [layout.classType description];
		layout.elemName = elemName;

		[self parseAttr:elem forLayout:layout];
		[self parseText:elem forLayout:layout];

		[self parseChilds:elem forLayout:layout];
	}
}

- (void)parseElementStyle:(CXMLElement *)elem
{
	NSString * type = [[elem attributeForName:@"type"] stringValue];
	
	if ( nil == type || NSOrderedSame == [type compare:@"text/css" options:NSCaseInsensitiveSearch] )
	{
		NSString * media = [[elem attributeForName:@"media"] stringValue];
		if ( NO == [BeeUITemplateMediaQuery test:media] )
			return;

		NSString * text = nil;
		NSString * href = [[elem attributeForName:@"href"] stringValue];
		
		if ( href && href.length )
		{
			if ( [href hasPrefix:@"http://"] || [href hasPrefix:@"https://"] )
			{
				// TODO: further version
				
				ERROR( @"not support for remote style, eg. <style href='http://...'>" );
			}
			else
			{
				NSString *	extension = [href pathExtension];
				NSString *	fullName = [href substringToIndex:(href.length - extension.length - 1)];
				NSString *	fullPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
				NSString *	content = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:NULL];
				
				if ( content && content.length )
				{
					text = content.trim;
				}
			}
		}
		else
		{
			text = [elem stringValue].trim;
		}

		[_rootStyle appendCSSTree:text];
	}
	else if ( NSOrderedSame == [type compare:@"text/json" options:NSCaseInsensitiveSearch] )
	{
		// TODO:
	}
}

- (void)parseElement:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	if ( [elem.name matchAnyOf:@[@"template"]] )
    {
        [self parseElementTemplate:elem forLayout:layout];
    }
	else if ( [elem.name matchAnyOf:@[@"row", @"column"]] )
	{
		[self parseElementLayout:elem forLayout:layout];
	}
	else if ( [elem.name matchAnyOf:@[@"style"]] )
	{
		[self parseElementStyle:elem];
	}
	else
	{
		[self parseElementView:elem forLayout:layout];
	}
}

- (void)renderLayout:(BeeUILayout *)layout
{
	if ( _rootStyle )
	{
		[layout mergeRootStyle:_rootStyle];
	}

	for ( BeeUILayout * subLayout in layout.childs )
	{
		[self renderLayout:subLayout];
	}
}

- (BeeUITemplate *)parse
{
	BeeUITemplate * template = [[[BeeUITemplate alloc] init] autorelease];

	if ( template )
	{
		_rootLayout = [BeeUILayout layout];
		_rootLayout.version = 1;
		_rootLayout.isRoot = YES;
		_rootLayout.containable = YES;
		_rootLayout.name = nil;
		
		_rootStyle = [BeeUIStyle style];
		_rootStyle.isRoot = YES;
		_rootStyle.name = nil;

		[self parseElement:self.document.rootElement forLayout:_rootLayout];
		[self renderLayout:_rootLayout];
		
		_rootLayout.styleInline = [_rootStyle childStyleWithName:self.document.rootElement.name];
		[_rootLayout mergeStyle];
		
		template.rootLayout = _rootLayout;
		template.rootStyle = _rootStyle;
	}

	return template;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

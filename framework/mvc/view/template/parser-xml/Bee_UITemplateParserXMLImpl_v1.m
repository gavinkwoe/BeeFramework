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

#import "Bee_UITemplateParserXMLImpl_v1.h"
#import "Bee_UITemplateMediaQuery.h"
#import "Bee_UILayoutContainer.h"

#import "Bee_UILayout.h"

#import "Bee_UIStyle.h"
#import "Bee_UIStyleParser.h"
#import "BeeUIStyle+Builder.h"
#import "BeeUIStyle+Property.h"

#pragma mark -

@interface BeeUITemplateParserXMLImpl_v1()

- (void)parseXMLContent:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseXMLAttributes:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;

- (void)parseXMLElement:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseXMLElementView:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseXMLElementLayout:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseXMLElementStyle:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseXMLElementHead:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseXMLElementBody:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)parseXMLChildren:(NSArray *)children forLayout:(BeeUILayout *)layout;

- (void)parseXMLTemplate:(CXMLElement *)elem forLayout:(BeeUILayout *)layout;
- (void)mergeXMLStyle:(BeeUIStyle *)style forLayout:(BeeUILayout *)layout;

@end

#pragma mark -

@implementation BeeUITemplateParserXMLImpl_v1

- (void)load
{
}

- (void)unload
{
}

#pragma mark -

- (void)parseXMLChildren:(NSArray *)children forLayout:(BeeUILayout *)layout
{
	for ( CXMLElement * child in children )
	{
		if ( child.kind != CXMLElementKind )
			continue;
		
		[self parseXMLElement:child forLayout:layout];
	}
}

- (void)parseXMLElementHead:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	if ( nil == layout )
		return;

	NSString * elemID = [[elem attributeForName:@"id"] stringValue];
	NSString * elemName = [elem name];

	layout = layout.CONTAINER_BEGIN( elemID ? elemID : elemName );
	if ( layout )
	{
		layout.version = 1;
		
		[self parseXMLAttributes:elem forLayout:layout];
		[self parseXMLChildren:elem.children forLayout:layout];

		layout.CONTAINER_END();
	}
}

- (void)parseXMLElementBody:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	if ( nil == layout )
		return;
	
	NSString * elemID = [[elem attributeForName:@"id"] stringValue];
	NSString * elemName = [elem name];

	layout = layout.CONTAINER_BEGIN( elemID ? elemID : elemName );
	if ( layout )
	{
		layout.version = 1;
		
		[self parseXMLAttributes:elem forLayout:layout];
		[self parseXMLChildren:elem.children forLayout:layout];
		
		layout.CONTAINER_END();
	}
}

- (void)parseXMLElementLayout:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	if ( nil == layout )
		return;
	
	NSString * elemID = [[elem attributeForName:@"id"] stringValue];
	NSString * elemName = [elem name];
	
	layout = layout.CONTAINER_BEGIN( elemID );
	if ( layout )
	{
		layout.version = 1;
		layout.classType = nil;
		layout.className = nil;

		if ( elemID && elemID.length )
		{
			layout.classType = [BeeUILayoutContainer class];
			layout.className = @"BeeUILayoutContainer";

			layout.isWrapper = YES;
			layout.containable = YES;
			layout.constructable = YES;
		}

		if ( [elemName matchAnyOf:@[@"col"]] )
		{
			layout.styleInline.COMPOSITION( BeeUIStyle.COMPOSITION_LINEAR );
			layout.styleInline.ORIENTATION( BeeUIStyle.ORIENTATION_VERTICAL );
		}
		else if ( [elemName matchAnyOf:@[@"row"]] )
		{
			layout.styleInline.COMPOSITION( BeeUIStyle.COMPOSITION_LINEAR );
			layout.styleInline.ORIENTATION( BeeUIStyle.ORIENTATION_HORIZONAL );
		}
		else if ( [elemName matchAnyOf:@[@"linear"]] )
		{
			layout.styleInline.COMPOSITION( BeeUIStyle.COMPOSITION_LINEAR );
			layout.styleInline.ORIENTATION( BeeUIStyle.ORIENTATION_VERTICAL );
		}
		else if ( [elemName matchAnyOf:@[@"absolute"]] )
		{
			layout.styleInline.COMPOSITION( BeeUIStyle.COMPOSITION_ABSOLUTE );
			layout.styleInline.ORIENTATION( BeeUIStyle.ORIENTATION_VERTICAL );
		}
		else if ( [elemName matchAnyOf:@[@"relative"]] )
		{
			layout.styleInline.COMPOSITION( BeeUIStyle.COMPOSITION_RELATIVE );
			layout.styleInline.ORIENTATION( BeeUIStyle.ORIENTATION_VERTICAL );
		}
		else
		{
			layout.styleInline.COMPOSITION( BeeUIStyle.COMPOSITION_LINEAR );
			layout.styleInline.ORIENTATION( BeeUIStyle.ORIENTATION_VERTICAL );			
		}
		
		[self parseXMLAttributes:elem forLayout:layout];
		[self parseXMLChildren:elem.children forLayout:layout];
		
		layout.CONTAINER_END();
	}
}

- (void)parseXMLElementView:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	if ( nil == layout )
		return;
	
	NSString *	elemID = [[elem attributeForName:@"id"] stringValue];
	NSString *	elemName = [elem name];
	NSString *	classType = [[elem attributeForName:@"type"] stringValue];
	
	if ( nil == classType && 0 == classType.length )
	{
		classType = [self.classMapping objectForKey:elemName];
	}
	
	if ( nil == classType )
	{
		classType = elemName;
	}
	
	Class viewClass = NSClassFromString( classType );
	if ( nil == viewClass )
	{
		viewClass = [UIView class];
		
		//		ERROR( @"unknown elem type, '%@'", elem.name );
		//		return;
	}
	
	layout = layout.VIEW( elemID );
	if ( layout )
	{
		layout.version = 1;
		layout.elemName = elemName;
		layout.classType = viewClass;
		layout.className = [viewClass description];
		
		layout.constructable = YES;
		layout.containable = [viewClass isContainable];
		
		[self parseXMLAttributes:elem forLayout:layout];
		[self parseXMLContent:elem forLayout:layout];
		
		if ( layout.classType )
		{
			[layout.classType parseXMLElement:elem forLayout:layout];
		}
	}
}

- (void)parseXMLElementStyle:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSString * type = [[elem attributeForName:@"type"] stringValue];
	
	if ( nil == type || [type matchAnyOf:@[@"text/css"]] )
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
		
		[layout.styleRoot appendCSSTree:text];
	}
}

- (void)parseXMLElement:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	if ( [elem.name matchAnyOf:@[@"linear", @"col", @"row", @"absolute", @"relative"]] )
	{
		[self parseXMLElementLayout:elem forLayout:layout];
	}
	else if ( [elem.name matchAnyOf:@[@"style"]] )
	{
		[self parseXMLElementStyle:elem forLayout:layout];
	}
	else if ( [elem.name matchAnyOf:@[@"body"]] )
	{
		[self parseXMLElementBody:elem forLayout:layout];
	}
	else if ( [elem.name matchAnyOf:@[@"head"]] )
	{
		[self parseXMLElementHead:elem forLayout:layout];
	}
	else
	{
		[self parseXMLElementView:elem forLayout:layout];
	}
}

#pragma mark -

- (void)parseXMLTemplate:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	ASSERT( nil != layout );

	if ( NO == [elem.name matchAnyOf:@[@"ui", @"template", @"xml"]] )
	{
		WARN( @"invalid root name '%@'", elem.name );
	}
		
	NSString * name = [[elem attributeForName:@"namespace"] stringValue];
	if ( nil == name )
	{
		name = [[elem attributeForName:@"name"] stringValue];
	}
	
	if ( name && name.length )
	{
		layout.name = name;
	}

	[self parseXMLAttributes:elem forLayout:layout];
	[self parseXMLChildren:elem.children forLayout:layout];
}


#pragma mark -

- (void)parseXMLContent:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	NSMutableString * string = [NSMutableString string];
	
	for ( CXMLElement * child in elem.children )
	{
		[string appendString:[child XMLString]];
	}
	
	if ( string && string.length )
	{
		layout.styleInline.TEXT( string );
	}
}

- (void)parseXMLAttributes:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
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

- (void)mergeXMLStyle:(BeeUIStyle *)style forLayout:(BeeUILayout *)layout
{
	[layout mergeRootStyle:style];

	for ( BeeUILayout * subLayout in layout.childs )
	{
		[self mergeXMLStyle:style forLayout:subLayout];
	}
}

#pragma mark -

- (BeeUITemplate *)parse
{
	BeeUITemplate * template = [[[BeeUITemplate alloc] init] autorelease];
	if ( template )
	{
		BeeUIStyle * rootStyle = [BeeUIStyle style];
		rootStyle.name = nil;
		rootStyle.isRoot = YES;

		BeeUILayout * rootLayout = [BeeUILayout layout];
		rootLayout.name = nil;
		rootLayout.isRoot = YES;
		rootLayout.version = 1;
		rootLayout.containable = YES;
		rootLayout.styleRoot = rootStyle;

		[self parseXMLTemplate:self.document.rootElement forLayout:rootLayout];
		[self mergeXMLStyle:rootStyle forLayout:rootLayout];

		rootLayout.styleInline = [rootStyle childStyleWithName:rootLayout.name];
		if ( nil == rootLayout.styleInline )
		{
			rootLayout.styleInline = [rootStyle childStyleWithName:self.document.rootElement.name];
		}

		[rootLayout mergeStyle];

		template.rootLayout = rootLayout;
		template.rootStyle = rootStyle;
	}

	return template;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

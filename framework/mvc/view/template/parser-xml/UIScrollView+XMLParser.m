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

#import "UIScrollView+XMLParser.h"
#import "Bee_UITemplateParserXML.h"

#import "BeeUIStyle+Builder.h"
#import "BeeUIStyle+Property.h"

#pragma mark -

@implementation UIScrollView(XMLParser)

+ (void)parseScrollAttributes:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
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

+ (void)parseScrollItem:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	if ( nil == layout )
		return;
	
	NSString *	elemID = [[elem attributeForName:@"id"] stringValue];
	NSString *	elemName = [elem name];
	NSString *	classType = [[elem attributeForName:@"type"] stringValue];

	Class viewClass = NSClassFromString( classType );
	if ( nil == viewClass )
	{
		viewClass = NSClassFromString( elemName );
		if ( nil == viewClass )
		{
			ERROR( @"unknown elem type, '%@'", elem.name );
			return;
		}
	}

	layout = layout.VIEW( elemID );
	if ( layout )
	{
		layout.version = 1;
		layout.elemName = elemName;
		layout.classType = viewClass;
		layout.className = [viewClass description];

		layout.containable = NO;
		layout.constructable = NO;

		[self parseScrollAttributes:elem forLayout:layout];
	}
}

+ (void)parseXMLElement:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	for ( CXMLElement * child in elem.children )
	{
		if ( child.kind != CXMLElementKind )
			continue;

		[self parseScrollItem:child forLayout:layout];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

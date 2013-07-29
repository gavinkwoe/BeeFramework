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

#import "Bee_UITemplateHTML.h"

#import "Bee_UILayout.h"
#import "Bee_UIStyle.h"

#pragma mark -

@interface BeeUITemplateHTML()

AS_INT( ELEM_TYPE_UNKNOWN )
AS_INT( ELEM_TYPE_HTML )
AS_INT( ELEM_TYPE_HEADER )
AS_INT( ELEM_TYPE_BODY )
AS_INT( ELEM_TYPE_STYLE )
AS_INT( ELEM_TYPE_DIV )
AS_INT( ELEM_TYPE_VIEW )

@end

#pragma mark -

@implementation BeeUITemplateHTML

DEF_INT( ELEM_TYPE_UNKNOWN,	0 )
DEF_INT( ELEM_TYPE_HTML,	1 )
DEF_INT( ELEM_TYPE_HEADER,	2 )
DEF_INT( ELEM_TYPE_BODY,	3 )
DEF_INT( ELEM_TYPE_STYLE,	4 )
DEF_INT( ELEM_TYPE_DIV,		5 )
DEF_INT( ELEM_TYPE_VIEW,	6 )

- (NSDictionary *)viewClassMapping
{
	static NSMutableDictionary * __mapping = nil;
	
	if ( nil == __mapping )
	{
		__mapping = [[NSMutableDictionary alloc] init];
		__mapping.APPEND( @"view",		@"BeeUICell" );
		__mapping.APPEND( @"image",		@"BeeUIImageView" );
		__mapping.APPEND( @"label",		@"BeeUILabel" );
		__mapping.APPEND( @"input",		@"BeeUITextField" );
		__mapping.APPEND( @"button",	@"BeeUIButton" );
		__mapping.APPEND( @"scroll",	@"BeeUIScrollView" );
		__mapping.APPEND( @"indicator",	@"BeeUIActivityIndicatorView" );
		__mapping.APPEND( @"textArea",	@"BeeUIActivityIndicatorView" );
		__mapping.APPEND( @"indicator",	@"BeeUITextView" );
		__mapping.APPEND( @"switch",	@"BeeUISwitch" );
		__mapping.APPEND( @"switch",	@"BeeUISwitch" );
		__mapping.APPEND( @"slider",	@"BeeUISlider" );
		__mapping.APPEND( @"check",		@"BeeUICheck" );
	}

	return __mapping;
}

- (NSInteger)guessElementType:(CXMLElement *)elem
{
    if ( [[self viewClassMapping].allKeys containsObject:elem.name] )
	{
		return self.ELEM_TYPE_VIEW;
	}
	else if ( NSOrderedSame == [elem.name compare:@"div" options:NSCaseInsensitiveSearch] )
	{
		return self.ELEM_TYPE_DIV;
	}
    else if ( NSOrderedSame == [elem.name compare:@"html" options:NSCaseInsensitiveSearch] )
    {
        return self.ELEM_TYPE_HTML;
    }
    else if ( NSOrderedSame == [elem.name compare:@"header" options:NSCaseInsensitiveSearch] )
    {
        return self.ELEM_TYPE_HEADER;
    }
    else if ( NSOrderedSame == [elem.name compare:@"body" options:NSCaseInsensitiveSearch] )
    {
        return self.ELEM_TYPE_BODY;
    }
	else if ( NSOrderedSame == [elem.name compare:@"style" options:NSCaseInsensitiveSearch] )
	{
		return self.ELEM_TYPE_STYLE;
	}
	
	return self.ELEM_TYPE_UNKNOWN;
}

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
	
	return YES;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

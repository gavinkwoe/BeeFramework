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

#import "Bee_UITemplateParserXML.h"
#import "Bee_UITemplateParserXMLImpl.h"
#import "Bee_UIStyleParser.h"

#import "Bee_UILayout.h"
#import "Bee_UIStyle.h"

#pragma mark -

#undef	RESOURCE_NAME
#define	RESOURCE_NAME	@"xml-tag.json"

#pragma mark -

@implementation NSObject(XMLParser)

+ (void)parseXMLElement:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
}

- (void)parseXMLElement:(CXMLElement *)elem forLayout:(BeeUILayout *)layout
{
	[[self class] parseXMLElement:elem forLayout:layout];
}

@end

#pragma mark -

@interface BeeUITemplateParserXML()
{
	NSMutableDictionary * _classMapping;
}

- (void)loadResource:(NSString *)resName;

@end

#pragma mark -

@implementation BeeUITemplateParserXML

@synthesize classMapping = _classMapping;

DEF_SINGLETON( BeeUITemplateParserXML );

- (void)load
{
	_classMapping = [[NSMutableDictionary alloc] init];
	
	[self map:@"button"		toClass:NSClassFromString(@"BeeUIButton")];
	[self map:@"check"		toClass:NSClassFromString(@"BeeUICheck")];
	[self map:@"image"		toClass:NSClassFromString(@"BeeUIImageView")];
	[self map:@"zoom-image"	toClass:NSClassFromString(@"BeeUIZoomImageView")];
	[self map:@"zoom-image"	toClass:NSClassFromString(@"BeeUIZoomImageView")];
	[self map:@"label"		toClass:NSClassFromString(@"BeeUILabel")];
	[self map:@"input"		toClass:NSClassFromString(@"BeeUITextField")];
	[self map:@"textarea"	toClass:NSClassFromString(@"BeeUITextView")];
	[self map:@"slider"		toClass:NSClassFromString(@"BeeUISlider")];
	[self map:@"switch"		toClass:NSClassFromString(@"BeeUISwitch")];
	[self map:@"view"		toClass:NSClassFromString(@"UIView")];
	[self map:@"list"		toClass:NSClassFromString(@"BeeUIScrollView")];
	[self map:@"scroll"		toClass:NSClassFromString(@"BeeUIScrollView")];
	[self map:@"indicator"	toClass:NSClassFromString(@"BeeUIActivityIndicatorView")];
	[self map:@"zoom"		toClass:NSClassFromString(@"BeeUIZoomView")];
	[self map:@"pager"		toClass:NSClassFromString(@"BeeUIPageControl")];
	[self map:@"web"		toClass:NSClassFromString(@"BeeUIWebView")];
	[self map:@"progress"	toClass:NSClassFromString(@"BeeUIProgressView")];

	[self loadResource:RESOURCE_NAME];
}

- (void)unload
{
	[_classMapping removeAllObjects];
	[_classMapping release];
}

- (void)loadResource:(NSString *)resName
{
	NSString *	extension = [resName pathExtension];
	NSString *	fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
	
	NSString * resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
	if ( nil == resPath )
		return;
	
	NSError * error = nil;
	NSString * content = [NSString stringWithContentsOfFile:resPath encoding:NSUTF8StringEncoding error:&error];
	if ( nil == content )
		return;
	
	NSDictionary * dict = [content objectFromJSONString];
	if ( nil == dict || NO == [dict isKindOfClass:[NSDictionary class]] )
		return;
	
	for ( NSString * key in dict )
	{
		NSString * value = [dict objectForKey:key];
		if ( nil == value || NO == [value isKindOfClass:[NSString class]] )
			continue;
		
		Class classType = NSClassFromString( value );
		if ( nil == classType )
			continue;
		
		[self map:key toClass:classType];
	}
}

#pragma mark -

+ (void)map:(NSString *)tag toClass:(Class)clazz
{
	[[self sharedInstance] map:tag toClass:clazz];
}

- (void)map:(NSString *)tag toClass:(Class)clazz
{
	if ( nil == tag || nil == clazz )
		return;
	
	[_classMapping setObject:[clazz description] forKey:tag];
}

- (BeeUITemplate *)parse:(id)data
{
	if ( nil == data )
		return nil;
	
	if ( NO == [data isKindOfClass:[NSData class]] )
	{
		data = [data asNSData];
		if ( nil == data )
			return nil;
	}

	NSError * error = nil;
	CXMLDocument * document = [[[CXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding options:0 error:&error] autorelease];
	if ( nil == document || nil == document.rootElement )
	{
		ERROR( @"Failed to open XML document" );
		return nil;
	}

	NSUInteger version = 0;
	CXMLNode * versionNode = [document.rootElement attributeForName:@"version"];
	if ( versionNode )
	{
		version = [versionNode.stringValue.trim intValue];
	}

	BeeUITemplateParserXMLImpl * impl = [BeeUITemplateParserXMLImpl impl:version];
	if ( nil == impl )
	{
		ERROR( @"Version not support" );
		return nil;
	}
	
	impl.document = document;
	impl.packagePath = self.packagePath;
	impl.classMapping = self.classMapping;
	return [impl parse];
}

- (id)objectForKeyedSubscript:(id)key
{
	if ( nil == key )
		return nil;
	
	return [self.classMapping objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self.classMapping setObject:obj forKey:key];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

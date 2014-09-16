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

#import "Bee_Language.h"

#pragma mark -

@interface BeeLanguage()
{
	NSString *				_name;
	NSMutableDictionary *	_strings;
}

- (BOOL)parseData:(NSData *)data;
- (BOOL)parseText:(NSString *)text;

@end

#pragma mark -

@implementation BeeLanguage

@synthesize name = _name;
@synthesize strings = _strings;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.name = nil;
		self.strings = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)dealloc
{
	[_name release];
	
	[_strings removeAllObjects];
	[_strings release];

	[super dealloc];
}

- (void)addString:(NSString *)string forName:(NSString *)name
{
	if ( nil == string || nil == name )
		return;

	[_strings setObject:string forKey:name];
}

- (NSString *)stringWithName:(NSString *)name
{
	if ( nil == _strings )
	{
		return nil; // name;
	}

	NSString * result = [_strings objectForKey:name];
	if ( nil == result )
	{
		return nil; // name;
	}
	
	return result;
}

- (NSString *)stringWithCstr:(const char *)name
{
	if ( nil == _strings )
		return nil;
	
	return [_strings objectForKey:[NSString stringWithUTF8String:name]];
}

#pragma mark -

- (void)parseString:(CXMLElement *)elem
{
	NSString *	stringName = [[elem attributeForName:@"name"] stringValue];
	NSString *	stringContent = nil;
	
	for ( CXMLElement * child in elem.children )
	{
		if ( child.kind == CXMLTextKind )
		{
			stringContent = child.stringValue;
		}
	}
	
	if ( stringName && stringContent )
	{
		[_strings setObject:stringContent forKey:stringName];
	}
}

- (void)parseResource:(CXMLElement *)elem
{
	for ( CXMLElement * child in elem.children )
	{
		if ( child.kind == CXMLElementKind )
		{
			[self parseString:child];
		}
	}
}

- (void)parseElement:(CXMLElement *)elem
{
	if ( [elem.name matchAnyOf:@[@"resources"]] )
	{
		[self parseResource:elem];
	}
	else if ( [elem.name matchAnyOf:@[@"string"]] )
	{
		[self parseString:elem];
	}
}

#pragma mark -

- (BOOL)parseData:(NSData *)data
{
	if ( nil == data )
		return NO;
	
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
	
	[self parseElement:root];

	return YES;
}

- (BOOL)parseText:(NSString *)text
{
	return [self parseData:[text asNSData]];
}

+ (BeeLanguage *)language
{
	return [[[BeeLanguage alloc] init] autorelease];
}

+ (BeeLanguage *)language:(id)data
{
	BeeLanguage * lang = [[[BeeLanguage alloc] init] autorelease];
	if ( lang )
	{
		if ( [data isKindOfClass:[NSData class]] )
		{
			[lang parseData:(NSData *)data];
		}
		else if ( [data isKindOfClass:[NSString class]] )
		{
			[lang parseText:(NSString *)data];
		}
	}

	return lang;
}

@end

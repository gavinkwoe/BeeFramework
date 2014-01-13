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

#import "Bee_UITemplateParser.h"
#import "Bee_UITemplateParserAndroid.h"
#import "Bee_UITemplateParserXML.h"

#pragma mark -

@implementation BeeUITemplateParser

static NSMutableDictionary * __parserClasses = nil;

@synthesize packagePath = _packagePath;

+ (BOOL)autoLoad
{
//	[self registerParserClass:[BeeUITemplateParserXML class] forType:@"html"];
	[self registerParserClass:[BeeUITemplateParserXML class] forType:@"xml"];
	[self registerParserClass:[BeeUITemplateParserXML class] forType:@"ui"];
//	[self registerParserClass:[BeeUITemplateParserAndroid class] forType:@"android"];
	
	return YES;
}

+ (NSArray *)supportedExtensions
{
	if ( nil == __parserClasses )
	{
		return nil;
	}
	
	return __parserClasses.allKeys;
}

+ (BOOL)supportForType:(NSString *)type
{
	for ( NSString * key in __parserClasses.allKeys )
	{
		if ( NSOrderedSame == [key compare:type options:NSCaseInsensitiveSearch] )
			return YES;
	}

	return NO;
}

+ (BeeUITemplateParser *)parserForType:(NSString *)type
{	
	BeeUITemplateParser * templateParser = nil;
	
	for ( NSString * key in __parserClasses.allKeys )
	{
		if ( NSOrderedSame != [key compare:type options:NSCaseInsensitiveSearch] )
			continue;

		NSString * className = [__parserClasses objectForKey:key.lowercaseString];
		if ( className )
		{
			Class classType = NSClassFromString( className );
			if ( classType )
			{
				if ( [classType respondsToSelector:@selector(sharedInstance)] )
				{
					templateParser = [classType sharedInstance];
				}
				else
				{
					templateParser = [[[classType alloc] init] autorelease];	
				}
				break;
			}
		}
	}

	return templateParser;
}

+ (void)registerParserClass:(Class)clazz forType:(NSString *)type
{
	if ( nil == __parserClasses )
	{
		__parserClasses = [[NSMutableDictionary alloc] init];
	}
	
	NSString * className = [NSString stringWithUTF8String:class_getName(clazz)];
	if ( className )
	{
		[__parserClasses setObject:className forKey:type.lowercaseString];
	}
}

+ (void)unregisterParserClassForType:(NSString *)type
{
	[__parserClasses removeObjectForKey:type.lowercaseString];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
//		[self load];
		[self performLoad];
	}
	return self;
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	self.packagePath = nil;

	[super dealloc];
}

- (void)load
{
}

- (void)unload
{
}

- (BeeUITemplate *)parse:(id)data
{
	return nil;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

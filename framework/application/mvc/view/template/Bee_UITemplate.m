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

#import "Bee_UITemplate.h"

#import "Bee_UITemplateAndroid.h"
#import "Bee_UITemplateHTML.h"
#import "Bee_UITemplateXML.h"

#pragma mark -

@implementation NSObject(BeeUIResourceLoading)

+ (BOOL)supportForUIResourceLoading
{
	return NO;
}

- (NSString *)UIResourceName
{
	return [[self class] description];
}

@end

#pragma mark -

@interface BeeUITemplate()
{
	NSString *				_name;
	BeeUILayout *			_rootLayout;
}
@end

#pragma mark -

@implementation BeeUITemplate

@synthesize name = _name;
@synthesize rootLayout = _rootLayout;

static NSMutableDictionary * __templateClasses = nil;
static NSMutableDictionary * __templateCache = nil;

+ (BOOL)autoLoad
{
	INFO( @"Loading parsers ..." );
	
	[BeeUITemplate registerTemplateClass:[BeeUITemplateXML class] forType:@"xml"];
	[BeeUITemplate registerTemplateClass:[BeeUITemplateXML class] forType:@"ui"];
	[BeeUITemplate registerTemplateClass:[BeeUITemplateHTML class] forType:@"html"];
	[BeeUITemplate registerTemplateClass:[BeeUITemplateHTML class] forType:@"htm"];
	[BeeUITemplate registerTemplateClass:[BeeUITemplateAndroid class] forType:@"android"];
	
	return YES;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.name = nil;
		self.rootLayout = nil;
	}
	return self;
}

- (void)dealloc
{
	self.name = nil;
	self.rootLayout = nil;

	[super dealloc];
}

+ (BeeUITemplate *)templateForType:(NSString *)type
{	
	BeeUITemplate * template = nil;
	
	for ( NSString * key in __templateClasses.allKeys )
	{
		if ( NSOrderedSame != [key compare:type options:NSCaseInsensitiveSearch] )
			continue;

		NSString * className = [__templateClasses objectForKey:key.lowercaseString];
		if ( className )
		{
			Class classType = NSClassFromString( className );
			if ( classType )
			{
				template = [[[classType alloc] init] autorelease];
				break;
			}
		}
	}
	
	return template;
}

+ (void)registerTemplateClass:(Class)clazz forType:(NSString *)type
{
	INFO( @"Loading parser '.%@' ...", type );

	if ( nil == __templateClasses )
	{
		__templateClasses = [[NSMutableDictionary alloc] init];
	}
	
	NSString * className = [NSString stringWithUTF8String:class_getName(clazz)];
	if ( className )
	{
		[__templateClasses setObject:className forKey:type.lowercaseString];
	}
}

+ (void)unregisterTemplateClassForType:(NSString *)type
{
	[__templateClasses removeObjectForKey:type.lowercaseString];
}

+ (BeeUITemplate *)fromResource:(NSString *)resName
{	
	if ( nil == __templateCache )
	{
		__templateCache = [[NSMutableDictionary alloc] init];
	}

	BeeUITemplate *	template = [__templateCache objectForKey:resName];
	if ( nil == template )
	{
		NSString *	extension = [resName pathExtension];
		NSString *	fullName = [resName substringToIndex:(resName.length - extension.length - 1)];

		NSString *	resPath = nil;
		NSString *	resPath2 = nil;
		NSString *	resDefaultPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
		
		if ( NSNotFound == [fullName rangeOfString:@"@"].location )
		{
			if ( [BeeSystemInfo isPhoneRetina4] )
			{
				resPath = [[NSBundle mainBundle] pathForResource:[fullName stringByAppendingString:@"-568h@2x"] ofType:extension];
				resPath2 = [[NSBundle mainBundle] pathForResource:[fullName stringByAppendingString:@"-568h"] ofType:extension];
			}
			else if ( [BeeSystemInfo isPhoneRetina35] )
			{
				resPath = [[NSBundle mainBundle] pathForResource:[fullName stringByAppendingString:@"@2x"] ofType:extension];
				resPath2 = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
			}
			else if ( [BeeSystemInfo isPhone35] )
			{
				resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
			}
			else if ( [BeeSystemInfo isPadRetina] )
			{
				resPath = [[NSBundle mainBundle] pathForResource:[fullName stringByAppendingString:@"@2x"] ofType:extension];
				resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
			}
			else if ( [BeeSystemInfo isPad] )
			{
				resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
			}
			else
			{
				resPath = resDefaultPath;
			}
		}
		
		NSData * data = nil;

		data = [NSData dataWithContentsOfFile:resPath];
		if ( nil == data || 0 == data.length )
		{
			data = [NSData dataWithContentsOfFile:resPath2];
			if ( nil == data || 0 == data.length )
			{
				data = [NSData dataWithContentsOfFile:resDefaultPath];
			}
		}

		if ( nil == data || 0 == data.length )
		{
			ERROR( @"failed to load '%@'", resName );
			return nil;
		}

		template = [BeeUITemplate templateForType:extension];
		if ( nil == template )
		{
			ERROR( @"unknown resource type '%@'", resName );
			return nil;
		}
		
		[template parse:data];
		
		if ( nil == template.rootLayout )
		{
			ERROR( @"failed to load '%@'", resName );
			return nil;
		}
		
		INFO( @"template loaded '%@'", resName );
		[__templateCache setObject:template forKey:resName];
	}
	
	return template;
}

+ (BeeUITemplate *)fromFile:(NSString *)fileName
{
	INFO( @"template load, '%@'", fileName );

	if ( nil == __templateCache )
	{
		__templateCache = [[NSMutableDictionary alloc] init];
	}
	
	BeeUITemplate *	template = [__templateCache objectForKey:fileName];
	if ( nil == template )
	{
		NSData * data = [NSData dataWithContentsOfFile:fileName];
		if ( nil == data || 0 == data.length )
			return nil;

		template = [BeeUITemplate templateForType:[fileName pathExtension]];
		if ( template )
		{
			[template parse:data];

			[__templateCache setObject:template forKey:fileName];
		}
	}
	
	return template;
}

+ (void)clearCache
{
	[__templateCache removeAllObjects];
}

- (BOOL)parse:(id)data
{
	if ( [data isKindOfClass:[NSData class]] )
	{
		return [self parseData:(NSData *)data];
	}
	else if ( [data isKindOfClass:[NSString class]] )
	{
		return [self parseText:(NSString *)data];
	}
	
	return NO;
}

- (BOOL)parseData:(NSData *)data
{
	return NO;
}

- (BOOL)parseText:(NSString *)text
{
	return NO;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

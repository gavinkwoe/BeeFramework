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

#import "Bee_UITemplatePackage.h"

#pragma mark -

@interface BeeUITemplatePackage()
{
	NSString *		_packageName;
	NSString *		_packagePath;
	NSDictionary *	_packageContent;
}
@end

#pragma mark -

@implementation BeeUITemplatePackage

@synthesize packagePath = _packagePath;
@synthesize packageContent = _packageContent;

@dynamic name;
@dynamic description;
@dynamic version;
@dynamic homepage;
@dynamic author;
@dynamic templates;
@dynamic licenses;

- (id)init
{
	self = [super init];
	if ( self )
	{
		
	}
	return self;
}

- (void)dealloc
{
	self.packagePath = nil;
	self.packageContent = nil;

	[super dealloc];
}

+ (BeeUITemplatePackage *)fromDirectory:(NSString *)fileName
{
	BOOL isDirectory = NO;
	BOOL fileExists = NO;
	
	fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileName isDirectory:&isDirectory];
	if ( NO == fileExists )
	{
//		WARN( @"'%@' not exists", fileName );
		return nil;
	}

	if ( isDirectory )
	{
		fileName = [fileName stringByAppendingPathComponent:@"/package.json"];
	}

	return [self fromFile:fileName];
}

+ (BeeUITemplatePackage *)fromFile:(NSString *)fileName
{
	NSString * fileContent = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:NULL];
	if ( nil == fileContent )
	{
		WARN( @"Failed to load package '%@'", fileName );
		return nil;
	}

	NSDictionary * dict = [fileContent objectFromJSONString];
	if ( nil == dict || NO == [dict isKindOfClass:[NSDictionary class]] )
	{
		WARN( @"Failed to load package '%@'", fileName );
		return nil;
	}
	
	BeeUITemplatePackage * package = [[[BeeUITemplatePackage alloc] init] autorelease];
	if ( package )
	{
		package.packagePath = [fileName stringByDeletingLastPathComponent];
		package.packageContent = dict;
		
		INFO( @"Package '%@' loaded\n%@", fileName, package.packageContent );
	}
	return package;
}

- (NSString *)name
{
	return [self.packageContent objectForKey:@"name"];
}

- (NSString *)description
{
	return [self.packageContent objectForKey:@"description"];
}

- (NSString *)version
{
	return [self.packageContent objectForKey:@"version"];
}

- (NSString *)author
{
	return [self.packageContent objectForKey:@"author"];
}

- (NSString *)homepage
{
	return [self.packageContent objectForKey:@"homepage"];
}

- (NSArray *)templates
{
	return [self.packageContent objectForKey:@"templates"];
}

- (NSDictionary *)licenses
{
	return [self.packageContent objectForKey:@"licenses"];
}

- (NSString *)templateFilePath:(NSString *)fileName
{
	if ( nil == fileName )
		return nil;
	
	for ( NSString * templatePath in self.templates )
	{
		if ( [templatePath hasSuffix:fileName] )
			return templatePath;
	}

	return nil;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

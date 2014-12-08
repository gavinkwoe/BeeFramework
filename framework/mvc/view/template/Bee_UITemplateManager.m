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

#import "Bee_UITemplateManager.h"
#import "Bee_UITemplatePackage.h"
#import "Bee_UITemplateParser.h"
#import "Bee_Network.h"

#pragma mark -

DEF_PACKAGE( BeePackage_UI, BeeUITemplateManager, templateManager );

#pragma mark -

#undef	__PRELOAD_RESOURCES__
#define __PRELOAD_RESOURCES__	(__OFF__)

#pragma mark -

@interface BeeUITemplateManager()
{
	NSMutableArray *		_packages;
	NSMutableDictionary *	_templates;

	NSString *				_defaultTemplatePath;
	NSString *				_defaultResourcePath;
	NSString *				_defaultPassword;
	
	NSString *				_defaultPackage;
	NSString *				_currentPackage;
}

- (NSString *)tempFilePath:(NSString *)url;

- (void)preloadResources;
- (void)preloadPackages;
- (void)downloadPackage:(NSDictionary *)dict;

- (BOOL)unzipArchive:(NSString *)fullPath;
- (BOOL)unzipArchive:(NSString *)fullPath password:(NSString *)password;

- (BeeUITemplatePackage *)packageByName:(NSString *)name;

@end

#pragma mark -

@implementation BeeUITemplateManager

DEF_NOTIFICATION( SYNC_BEGIN )
DEF_NOTIFICATION( SYNC_PROGRESS )
DEF_NOTIFICATION( SYNC_FINISHED )
DEF_NOTIFICATION( SYNC_FAILED )
DEF_NOTIFICATION( SYNC_CANCELLED )

DEF_NOTIFICATION( PACKAGE_WILL_CHANGE )
DEF_NOTIFICATION( PACKAGE_DID_CHANGED )

DEF_SINGLETON( BeeUITemplateManager )

@synthesize defaultPackage = _defaultPackage;
@synthesize currentPackage = _currentPackage;

@synthesize defaultResourcePath = _defaultResourcePath;
@synthesize defaultTemplatePath = _defaultTemplatePath;
@synthesize defaultPassword = _defaultPassword;

@dynamic all;
@synthesize templates = _templates;
@synthesize packages = _packages;

@dynamic syncing;
@dynamic syncProgress;

+ (BOOL)autoLoad
{
#if __PRELOAD_RESOURCES__

	INFO( @"Loading templates ..." );
	
	[[BeeUITemplateManager sharedInstance] preloadResources];
	[[BeeUITemplateManager sharedInstance] preloadPackages];
	
	INFO( @"" );
	
#endif	//	#if __PRELOAD_RESOURCES__

	return YES;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.defaultPackage = @"default";
		self.currentPackage = self.defaultPackage;

		self.defaultTemplatePath = [NSString stringWithFormat:@"%@/Template/", [BeeSandbox libCachePath]];
		self.defaultResourcePath = [BeeSandbox appPath];
		self.defaultPassword = nil;

		self.packages = [NSMutableArray array];
		self.templates = [NSMutableDictionary dictionary];

		[BeeSandbox touch:self.defaultTemplatePath];
		[BeeSandbox touch:self.defaultResourcePath];
	}
	return self;
}

- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	[_packages removeAllObjects];
	[_packages release];

	[_templates removeAllObjects];
	[_templates release];

	[_defaultTemplatePath release];
	[_defaultResourcePath release];
	[_defaultPassword release];
	
	[_currentPackage release];
	[_defaultPackage release];

	[super dealloc];
}

- (NSArray *)all
{
	return _templates ? _templates.allValues : [NSArray array];
}

- (NSArray *)namesByAppendingMediaSuffix:(NSString *)name
{
	NSString *	extension = [name pathExtension];
	NSString *	fullName = [name substringToIndex:(name.length - extension.length - 1)];

	NSString *	resPath = nil;
	NSString *	resPath2 = nil;
	NSString *	resDefaultPath = name;

	if ( NSNotFound == [name rangeOfString:@"@"].location )
	{
		if ( [BeeSystemInfo isPhoneRetina4] )
		{
			resPath = [fullName stringByAppendingFormat:@"-568h@2x.%@", extension];
			resPath2 = [fullName stringByAppendingFormat:@"-568h.%@", extension];
		}
		else if ( [BeeSystemInfo isPhoneRetina35] || [BeeSystemInfo isPadRetina] )
		{
			resPath = [fullName stringByAppendingFormat:@"@2x.%@", extension];
		}
	}
	
	NSMutableArray * result = [NSMutableArray array];
	
	if ( resPath )
	{
		[result addObject:resPath];
	}

	if ( resPath2 )
	{
		[result addObject:resPath2];
	}

	if ( resDefaultPath )
	{
		[result addObject:resDefaultPath];
	}

	return result;
}

- (BeeUITemplatePackage *)packageByName:(NSString *)name
{
	for ( BeeUITemplatePackage * package in self.packages )
	{
		if ( [package.name isEqualToString:name] )
		{
			return package;
		}
	}
	
	BeeUITemplatePackage * package = nil;

	NSString * filePath = [self.defaultTemplatePath stringByAppendingPathComponent:name];
	NSString * filePath2 = [self.defaultResourcePath stringByAppendingPathComponent:name];
	
	NSString * zipFile = [self.defaultTemplatePath stringByAppendingPathComponent:[name stringByAppendingString:@".zip"]];
	NSString * zipFile2 = [self.defaultResourcePath stringByAppendingPathComponent:[name stringByAppendingString:@".zip"]];

	if ( nil == package )
	{
		package = [BeeUITemplatePackage fromDirectory:filePath];
		if ( nil == package )
		{
			BOOL succeed = [self unzipArchive:zipFile];
			if ( succeed )
			{
				package = [BeeUITemplatePackage fromDirectory:filePath];
			}
		}	
	}
	
	if ( nil == package )
	{
		package = [BeeUITemplatePackage fromDirectory:filePath2];
		if ( nil == package )
		{
			BOOL succeed = [self unzipArchive:zipFile2];
			if ( succeed )
			{
				package = [BeeUITemplatePackage fromDirectory:filePath];
			}
		}
	}
	
	if ( package )
	{
		[_packages addObject:package];
	}

	return package;
}

- (BeeUITemplate *)fromResource:(NSString *)fileName
{
	NSString *	mediaExtension = [fileName pathExtension];
	NSArray *	mediaNames = [self namesByAppendingMediaSuffix:fileName];
	NSData *	mediaContent = nil;
	
	NSString *	mediaFileName = nil;
	NSString *	mediaFullPath = nil;
	
	for ( NSString * mediaName in mediaNames )
	{
		mediaFileName = [mediaName substringToIndex:(mediaName.length - mediaExtension.length - 1)];
		mediaFullPath = [[NSBundle mainBundle] pathForResource:mediaFileName ofType:mediaExtension];

		if ( mediaFullPath )
		{
			mediaContent = [NSData dataWithContentsOfFile:mediaFullPath];
			if ( mediaContent && mediaContent.length )
			{
				break;
			}
		}
	}

	if ( nil == mediaContent || 0 == mediaContent.length )
	{
		return nil;
	}
	
	INFO( @"Template '%@' loaded", fileName );

	BeeUITemplateParser * parser = [BeeUITemplateParser parserForType:mediaExtension];
	if ( nil == parser )
	{
		ERROR( @"Unknown resource type '%@'", fileName );
		return nil;
	}

	parser.packagePath = nil;

	BeeUITemplate * template = [parser parse:mediaContent];
	if ( nil == template )
	{
		ERROR( @"Failed to parse '%@'", fileName );
		return nil;		
	}

	[_templates setObject:template forKey:fileName];

	template.package = self.currentPackage ? self.currentPackage : self.defaultPackage;
	return template;
}

- (BeeUITemplate *)fromFile:(NSString *)fileName
{
	NSString *	resName = [fileName lastPathComponent];
	NSString *	pathName = [fileName stringByDeletingLastPathComponent];

	NSString *	mediaExtension = [resName pathExtension];
	NSArray *	mediaNames = [self namesByAppendingMediaSuffix:resName];
	NSData *	mediaContent = nil;
	
	NSString *	mediaFileName = nil;
	NSString *	mediaFullPath = nil;
	
	for ( NSString * mediaName in mediaNames )
	{
		mediaFileName = [mediaName substringToIndex:(mediaName.length - mediaExtension.length - 1)];
		mediaFullPath = [NSString stringWithFormat:@"%@/%@.%@", pathName, mediaFileName, mediaExtension];

		if ( mediaFullPath )
		{
			mediaContent = [NSData dataWithContentsOfFile:mediaFullPath];
			if ( mediaContent && mediaContent.length )
			{
				break;
			}
		}
	}
	
	if ( nil == mediaContent || 0 == mediaContent.length )
	{
		return nil;
	}
	
	INFO( @"Template '%@' loaded", fileName );
	
	BeeUITemplateParser * parser = [BeeUITemplateParser parserForType:mediaExtension];
	if ( nil == parser )
	{
		ERROR( @"Unknown file type '%@'", fileName );
		return nil;
	}

	parser.packagePath = [fileName stringByDeletingLastPathComponent];

	BeeUITemplate * template = [parser parse:mediaContent];
	if ( nil == template )
	{
		ERROR( @"Failed to parse '%@'", fileName );
		return nil;
	}

	return template;
}

- (BeeUITemplate *)fromPackage:(NSString *)fileName
{
	NSString * packageName = nil;
	NSString * packageFile = nil;
	
	if ( [fileName hasPrefix:@"@"] && NSNotFound != [fileName rangeOfString:@"/"].location )
	{
		NSCharacterSet * charset = [NSCharacterSet characterSetWithCharactersInString:@"/"];
		NSUInteger offset = 0;
		
		packageName = [fileName substringFromIndex:1 untilCharset:charset endOffset:&offset];
		if ( packageName )
		{
			packageFile = [fileName substringFromIndex:offset];
		}
	}

	if ( nil == packageName )
	{
		packageName = self.currentPackage ? self.currentPackage : self.defaultPackage;
	}

	if ( nil == packageFile )
	{
		packageFile = fileName;
	}

	BeeUITemplatePackage * package = [self packageByName:packageName];
	if ( nil == package )
	{
		return nil;
	}

	NSString * templatePath = [package templateFilePath:packageFile];
	if ( nil == templatePath )
	{
		return nil;
	}

	NSString * filePath;
	filePath = [NSString stringWithFormat:@"%@/%@/%@", self.defaultTemplatePath, packageName, templatePath];
	filePath = [filePath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];

	return [self fromFile:filePath];
}

- (BeeUITemplate *)fromCache:(NSString *)fileName
{
	return [_templates objectForKey:fileName];
}

- (BeeUITemplate *)fromName:(NSString *)name
{
	NSArray * extentions = [BeeUITemplateParser supportedExtensions];

	for ( NSString * extentionName in extentions )
	{
		NSString * fileName = [NSString stringWithFormat:@"%@.%@", name, extentionName];

		BeeUITemplate * template = [self fromCache:fileName];
		if ( nil == template )
		{
			template = [self fromPackage:fileName];
			if ( nil == template )
			{
				NSString * fullPath = [self.defaultTemplatePath stringByAppendingPathComponent:fileName];
				template = [self fromFile:fullPath];
				if ( nil == template )
				{
					template = [self fromResource:fileName];
				}
			}
		}

		if ( template )
		{
			return template;
		}
	}

	return nil;
}

- (void)preloadResources
{
	if ( nil == self.defaultResourcePath )
		return;
	
	NSError * error = nil;
	NSArray * files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self.defaultResourcePath error:&error];

	[[BeeLogger sharedInstance] indent];
	
	for ( NSString * filePath in files )
	{
		NSString * fileName = [filePath lastPathComponent];
		NSString * extension = [filePath pathExtension];

		if ( [BeeUITemplateParser supportForType:extension] )
		{
			[self fromResource:fileName];
		}
	}
	
	[[BeeLogger sharedInstance] unindent];
}

- (void)preloadPackages
{
	NSMutableArray * allFiles = [NSMutableArray array];

	if ( self.defaultTemplatePath )
	{
		NSArray * files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self.defaultTemplatePath error:NULL];
		if ( files )
		{
			[allFiles addObjectsFromArray:files];
		}
	}
	
	if ( self.defaultResourcePath )
	{
		NSArray * files2 = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self.defaultResourcePath error:NULL];
		if ( files2 )
		{
			[allFiles addObjectsFromArray:files2];
		}
	}
	
	[[BeeLogger sharedInstance] indent];

	for ( NSString * filePath in allFiles )
	{
		BOOL isDirectory = NO;
		BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
		if ( fileExists && isDirectory )
		{
			BeeUITemplatePackage * package = [BeeUITemplatePackage fromDirectory:filePath];
			if ( package )
			{
				[_packages addObject:package];
			}
		}
	}
	
	[[BeeLogger sharedInstance] unindent];
}

- (void)clearCache
{
	[_templates removeAllObjects];
}

#pragma mark -

- (NSString *)tempFilePath:(NSString *)url
{
	return [self.defaultTemplatePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/~temp/%@.zip", [url MD5]]];
}

- (BOOL)unzipArchive:(NSString *)fullPath
{
	return [self unzipArchive:fullPath password:nil];
}

- (BOOL)unzipArchive:(NSString *)fullPath password:(NSString *)password
{
	BOOL			succeed = NO;
	ZipArchive *	archive = [[[ZipArchive alloc] init] autorelease];

	if ( nil == password )
	{
		password = self.defaultPassword;
	}

	succeed = [archive UnzipOpenFile:fullPath Password:password];
	if ( NO == succeed )
	{
		return NO;
	}

	succeed = [archive UnzipFileTo:self.defaultTemplatePath overWrite:YES];
	if ( NO == succeed )
	{
		return NO;
	}

	[archive UnzipCloseFile];
	return YES;
}

- (BOOL)syncing
{
	return self.REQUESTING();
}

- (CGFloat)syncProgress
{
	NSArray * array = self.requests;
	if ( nil == array || 0 == array.count )
	{
		return 0.0f;
	}
	
	BeeHTTPRequest * request = [array objectAtIndex:0];
	if ( request.sending )
	{
		return 0.0f;
	}
	else
	{
		return request.downloadPercent;
	}
}

- (void)sync:(NSString *)url
{
	[self sync:url password:nil];
}

- (void)sync:(NSString *)url password:(NSString *)password
{
	if ( nil == url || 0 == url.length )
		return;

	NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:url, @"url", password, @"password", nil];

	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self cancelRequests];
	[self performSelector:@selector(downloadPackage:) withObject:params afterDelay:0.3f];
}

- (void)stop
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self cancelRequests];
	[self postNotification:self.SYNC_CANCELLED];
}

- (void)downloadPackage:(NSDictionary *)dict
{
	[self cancelRequests];

	NSString * url = [dict objectForKey:@"url"];
	NSString * password = [dict objectForKey:@"password"];	
	NSString * path = [self tempFilePath:url];

	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
	if ( exists )
	{
		[self postNotification:self.SYNC_BEGIN];

		BOOL succeed = [self unzipArchive:path password:password];
		if ( succeed )
		{
			INFO( @"'%@' unziped to '%@'", path, self.defaultTemplatePath );
			
			[self postNotification:self.SYNC_FINISHED];
		}
		else
		{
			[self postNotification:self.SYNC_FAILED];
		}
	}
	else
	{
		self.HTTP_GET( url ).SAVE_AS( path ).userObject = password;
	}
}

#pragma mark -

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.sending )
	{
	}
	else if ( request.recving )
	{
		[self postNotification:self.SYNC_PROGRESS];
	}
	else if ( request.failed )
	{
		[self postNotification:self.SYNC_FAILED];
	}
	else if ( request.succeed )
	{
		NSString * fullPath = [self tempFilePath:request.url.absoluteString];
		NSString * password = (NSString *)request.userObject;

		if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
		{
			[self postNotification:self.SYNC_FAILED];
		}
		else
		{
			BOOL succeed = [self unzipArchive:fullPath password:password];
			if ( succeed )
			{

				[self postNotification:self.SYNC_FINISHED];
			}
			else
			{
				[self postNotification:self.SYNC_FAILED];
			}
		}
	}
	else if ( request.cancelled )
	{
		[self postNotification:self.SYNC_CANCELLED];
	}
}

- (BOOL)applyPackage:(NSString *)package
{
	if ( [package isEqualToString:self.currentPackage] )
	{
		return YES;
	}

	[self postNotification:BeeUITemplateManager.PACKAGE_WILL_CHANGE];
	
	self.currentPackage = package;
	
	[self postNotification:BeeUITemplateManager.PACKAGE_DID_CHANGED];

	return YES;
}

#pragma mark -

- (id)objectForKeyedSubscript:(id)key
{
	if ( nil == key )
		return nil;
	
	if ( nil == _templates )
		return nil;
	
	return [_templates objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	if ( nil == key || nil == obj )
		return;
	
	if ( nil == _templates )
		return;

	[_templates setObject:obj forKey:key];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

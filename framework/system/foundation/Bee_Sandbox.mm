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

#import "Bee_Sandbox.h"
#import "Bee_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( BeePackage_System, BeeSandbox, sandbox );

#pragma mark -

@interface BeeSandbox()
{
	NSString *	_appPath;
	NSString *	_docPath;
	NSString *	_libPrefPath;
	NSString *	_libCachePath;
	NSString *	_tmpPath;
}

- (BOOL)remove:(NSString *)path;
- (BOOL)touch:(NSString *)path;
- (BOOL)touchFile:(NSString *)path;

@end

#pragma mark -

@implementation BeeSandbox

DEF_SINGLETON( BeeSandbox )

@dynamic appPath;
@dynamic docPath;
@dynamic libPrefPath;
@dynamic libCachePath;
@dynamic tmpPath;

+ (NSString *)appPath
{
	return [[BeeSandbox sharedInstance] appPath];
}

- (NSString *)appPath
{
	if ( nil == _appPath )
	{
		NSString * exeName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
		NSString * appPath = [[NSHomeDirectory() stringByAppendingPathComponent:exeName] stringByAppendingPathExtension:@"app"];
		
		_appPath = [appPath retain];
	}

	return _appPath;
}

+ (NSString *)docPath
{
	return [[BeeSandbox sharedInstance] docPath];
}

- (NSString *)docPath
{
	if ( nil == _docPath )
	{
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		_docPath = [[paths objectAtIndex:0] retain];
	}
	
	return _docPath;
}

+ (NSString *)libPrefPath
{
	return [[BeeSandbox sharedInstance] libPrefPath];
}

- (NSString *)libPrefPath
{
	if ( nil == _libPrefPath )
	{
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
		
		[self touch:path];
			
		_libPrefPath = [path retain];
	}

	return _libPrefPath;
}

+ (NSString *)libCachePath
{
	return [[BeeSandbox sharedInstance] libCachePath];
}

- (NSString *)libCachePath
{
	if ( nil == _libCachePath )
	{
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];

		[self touch:path];
		
		_libCachePath = [path retain];
	}
	
	return _libCachePath;
}

+ (NSString *)tmpPath
{
	return [[BeeSandbox sharedInstance] tmpPath];
}

- (NSString *)tmpPath
{
	if ( nil == _tmpPath )
	{
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
		
		[self touch:path];

		_tmpPath = [path retain];
	}

	return _tmpPath;
}

+ (BOOL)remove:(NSString *)path
{
	return [[BeeSandbox sharedInstance] remove:path];
}

- (BOOL)remove:(NSString *)path
{
	return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

+ (BOOL)touch:(NSString *)path
{
	return [[BeeSandbox sharedInstance] touch:path];
}

- (BOOL)touch:(NSString *)path
{
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
	{
		return [[NSFileManager defaultManager] createDirectoryAtPath:path
										 withIntermediateDirectories:YES
														  attributes:nil
															   error:NULL];
	}
	
	return YES;
}

+ (BOOL)touchFile:(NSString *)file
{
	return [[BeeSandbox sharedInstance] touchFile:file];
}

- (BOOL)touchFile:(NSString *)file
{
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:file] )
	{
		return [[NSFileManager defaultManager] createFileAtPath:file
													   contents:[NSData data]
													 attributes:nil];
	}
	
	return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeSandbox )
{
	TIMES( 3 )
	{
		EXPECTED( nil != [BeeSandbox appPath] );
		EXPECTED( nil != [BeeSandbox docPath] );
		EXPECTED( nil != [BeeSandbox libPrefPath] );
		EXPECTED( nil != [BeeSandbox libCachePath] );
		EXPECTED( nil != [BeeSandbox tmpPath] );
	}
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

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

#import "NSBundle+BeeExtension.h"
#import "Bee_SystemInfo.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation NSBundle(BeeExntension)

@dynamic fullPath;
@dynamic pathName;

- (NSString *)fullPath
{
	return [self.resourcePath stringByDeletingLastPathComponent];
}

- (NSString *)pathName
{
	return [[self.resourcePath lastPathComponent] stringByDeletingPathExtension];
}

- (NSData *)data:(NSString *)resName
{
	NSString *	path = [NSString stringWithFormat:@"%@/%@", self.resourcePath, resName];
	NSData *	data = [NSData dataWithContentsOfFile:path];

	return data;
}

- (UIImage *)image:(NSString *)resName
{
	NSString *	extension = [resName pathExtension];
	NSString *	fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
	UIImage *	image = nil;
	
	if ( nil == image && [BeeSystemInfo isDevicePad] )
	{
		NSString *	path = [NSString stringWithFormat:@"%@/%@@2x.%@", self.resourcePath, fullName, extension];
		NSString *	path2 = [NSString stringWithFormat:@"%@/%@.%@", self.resourcePath, fullName, extension];
		
		image = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
		if ( nil == image )
		{
			image = [[[UIImage alloc] initWithContentsOfFile:path2] autorelease];
		}
	}

	if ( nil == image && [BeeSystemInfo isPhoneRetina4] )
	{
		NSString *	path = [NSString stringWithFormat:@"%@/%@-568h@2x.%@", self.resourcePath, fullName, extension];
		NSString *	path2 = [NSString stringWithFormat:@"%@/%@-568h.%@", self.resourcePath, fullName, extension];
		
		image = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
		if ( nil == image )
		{
			image = [[[UIImage alloc] initWithContentsOfFile:path2] autorelease];
		}
	}

	if ( nil == image )
	{
		NSString *	path = [NSString stringWithFormat:@"%@/%@@2x.%@", self.resourcePath, fullName, extension];
		NSString *	path2 = [NSString stringWithFormat:@"%@/%@.%@", self.resourcePath, fullName, extension];
		
		image = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
		if ( nil == image )
		{
			image = [[[UIImage alloc] initWithContentsOfFile:path2] autorelease];
		}
	}
	
	return image;
}

- (NSString *)string:(NSString *)resName
{
	NSString *	path = [NSString stringWithFormat:@"%@/%@", self.resourcePath, resName];
	NSString *	data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
	
	return data;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

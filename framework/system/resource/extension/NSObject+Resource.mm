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

#import "NSObject+Resource.h"
#import "NSObject+BeeJSON.h"

#pragma mark -

@implementation NSObject(Resource)

+ (NSString *)stringFromResource:(NSString *)resName
{
	if ( nil == resName )
		return nil;

	NSString * extension = [resName pathExtension];
	NSString * fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
	NSString * resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
	
	return [NSString stringWithContentsOfFile:resPath encoding:NSUTF8StringEncoding error:NULL];
}

- (NSString *)stringFromResource:(NSString *)resName
{
	return [NSObject stringFromResource:resName];
}

+ (NSData *)dataFromResource:(NSString *)resName
{
	if ( nil == resName )
		return nil;
	
	NSString * extension = [resName pathExtension];
	NSString * fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
	NSString * resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];

	return [NSData dataWithContentsOfFile:resPath];
}

- (NSData *)dataFromResource:(NSString *)resName
{
	return [NSObject dataFromResource:resName];
}

+ (id)objectFromResource:(NSString *)resName
{
	NSString * content = [self stringFromResource:resName];
	if ( nil == content )
		return nil;
	
	NSObject * decodedObject = [self objectFromString:content];
	if ( nil == decodedObject )
		return nil;
	
	return decodedObject;
}

@end

// TODO: 0.5

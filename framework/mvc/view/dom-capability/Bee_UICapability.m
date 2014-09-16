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

#import "Bee_UICapability.h"

#pragma mark -

@implementation NSObject(BeeUICapability)

+ (BOOL)isContainable
{
	return NO;
}

- (BOOL)isContainable
{
	return NO;
}

+ (BOOL)supportForUIAutomaticLayout
{
	return YES;
}

- (BOOL)supportForUIAutomaticLayout
{
	return YES;
}

+ (BOOL)supportForUISizeEstimating
{
	return NO;
}

- (BOOL)supportForUISizeEstimating
{
	return NO;
}

+ (CGSize)estimateUISizeByBound:(CGSize)bound forData:(id)data
{
	return CGSizeZero;
}

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
	return CGSizeMake( width, 0.0f );
}

+ (CGSize)estimateUISizeByHeight:(CGFloat)height forData:(id)data
{
	return CGSizeMake( 0.0f, height );
}

- (CGSize)estimateUISizeByBound:(CGSize)bound
{
	return CGSizeZero;
}

- (CGSize)estimateUISizeByWidth:(CGFloat)width
{
	return CGSizeMake( width, 0.0f );
}

- (CGSize)estimateUISizeByHeight:(CGFloat)height
{
	return CGSizeMake( 0.0f, height );
}

+ (BOOL)supportForUIStyling
{
	return NO;
}

- (BOOL)supportForUIStyling
{
	return NO;
}

- (void)applyUIStyling:(NSDictionary *)properties
{
//	WARN( @"unrecognized styles for '%@':\n%@", [[self class] description], properties );
}

+ (BOOL)supportForUIResourceLoading
{
	return NO;
}

- (BOOL)supportForUIResourceLoading
{
	return NO;
}

+ (NSString *)UIResourceName
{
	return [self description];
}

- (NSString *)UIResourceName
{
	return [[self class] description];
}

+ (NSString *)UIResourcePath
{
	return nil;
}

- (NSString *)UIResourcePath
{
	return nil;
}

+ (BOOL)supportForUIPropertyMapping
{
	return YES;
}

- (BOOL)supportForUIPropertyMapping
{
	return YES;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

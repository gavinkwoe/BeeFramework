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

#import "UILabel+BeeUILayout.h"

#pragma mark -

#undef	MIN_TEXT_LEN
#define	MIN_TEXT_LEN	(32)

#undef	MAX_SIZE_CACHE
#define MAX_SIZE_CACHE	(256)

#pragma mark -

@implementation UILabel(BeeUILayout)

static NSMutableDictionary * __UILabelSizeCache = nil;

+ (BOOL)supportForUISizeEstimating
{
	return YES;
}

#pragma mark -

- (NSString *)cacheKeyByBound:(CGSize)bound
{
	if ( nil == __UILabelSizeCache )
	{
		return nil;
	}
	
	if ( nil == self.text || 0 == self.text.length )
	{
		return nil;
	}
	
	return [NSString stringWithFormat:@"[%@]_[%.0f,%.0f]_[%@,%.0f,%d]",
			self.text, floorf(bound.width), floorf(bound.height),
			self.font.fontName, self.font.lineHeight, self.lineBreakMode];
}

- (CGSize)cachedSizeByBound:(CGSize)bound
{
	if ( self.text && self.text.length >= MIN_TEXT_LEN )
	{
		if ( nil == __UILabelSizeCache )
		{
			__UILabelSizeCache = [[NSMutableDictionary alloc] initWithCapacity:MAX_SIZE_CACHE];
		}

		NSString * key = [self cacheKeyByBound:bound];
		if ( key )
		{
			NSValue * value = [__UILabelSizeCache objectForKey:key];
			if ( value )
			{
				return [value CGSizeValue];
			}
		}
	}
	
	return CGSizeMake( -1, -1 );
}

- (void)cacheSize:(CGSize)size byBound:(CGSize)bound
{
	if ( self.text && self.text.length >= MIN_TEXT_LEN )
	{
		NSString * key = [self cacheKeyByBound:bound];
		if ( key )
		{
			NSValue * value = [NSValue valueWithCGSize:size];
			if ( value )
			{
				if ( nil == __UILabelSizeCache )
				{
					__UILabelSizeCache = [[NSMutableDictionary alloc] initWithCapacity:MAX_SIZE_CACHE];
				}

				[__UILabelSizeCache setObject:value forKey:key];
				
				PERF( @"__UILabelSizeCache.count = %d", __UILabelSizeCache.count )
			}
		}
	}
}

#pragma mark -

- (CGSize)estimateUISizeByBound:(CGSize)bound
{
	if ( nil == self.text || 0 == self.text.length )
	{
		return CGSizeZero;
	}

	CGSize size = [self cachedSizeByBound:bound];
	if ( size.width < 0.0f || size.height < 0.0f )
	{
		size = [self.text sizeWithFont:self.font constrainedToSize:bound lineBreakMode:self.lineBreakMode];
		
		[self cacheSize:size byBound:bound];
	}
	
	return size;
}

- (CGSize)estimateUISizeByWidth:(CGFloat)width
{
	if ( nil == self.text || 0 == self.text.length )
	{
		return CGSizeMake( width, 0.0f );
	}

	CGSize size = [self cachedSizeByBound:CGSizeMake(width, -1)];
	if ( size.width < 0.0f || size.height < 0.0f )
	{
		if ( self.numberOfLines )
		{
			size = [self.text sizeWithFont:self.font
							constrainedToSize:CGSizeMake(width, self.font.lineHeight * self.numberOfLines + 1)
								lineBreakMode:self.lineBreakMode];
		}
		else
		{
			size = [self.text sizeWithFont:self.font
							constrainedToSize:CGSizeMake(width, 999999.0f)
								lineBreakMode:self.lineBreakMode];
		}
		
		[self cacheSize:size byBound:CGSizeMake(width, -1)];
	}

	return size;
}

- (CGSize)estimateUISizeByHeight:(CGFloat)height
{
	if ( nil == self.text || 0 == self.text.length )
		return CGSizeMake( 0.0f, height );

	CGSize size = [self cachedSizeByBound:CGSizeMake(-1,height)];
	if ( size.width < 0.0f || size.height < 0.0f )
	{
		size = [self.text sizeWithFont:self.font
						constrainedToSize:CGSizeMake(999999.0f, height)
							lineBreakMode:self.lineBreakMode];

		[self cacheSize:size byBound:CGSizeMake(-1, height)];
	}
	
	return size;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

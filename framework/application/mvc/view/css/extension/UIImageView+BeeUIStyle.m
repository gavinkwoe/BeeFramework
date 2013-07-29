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

#import "UIImageView+BeeUIStyle.h"
#import "UIImage+Theme.h"
#import "UIView+BeeUIStyle.h"
#import "UIView+Tag.h"
//#import "UIEdgeInsets+BeeExtension.h"

#pragma mark -

@implementation UIImageView(BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

- (void)resetUIStyleProperties
{
	[super resetUIStyleProperties];
}

#pragma mark -

- (void)setImageProperties:(NSDictionary *)properties
{
	NSString * image = [properties stringOfAny:@[@"src", @"image", @"image-src"]];
	NSString * imageMode = [properties stringOfAny:@[@"mode", @"image-mode"]];
	NSString * imageInsets = [properties stringOfAny:@[@"insets", @"image-insets"]];
	NSString * imageStyles = [properties stringOfAny:@[@"style", @"styles", @"image-style", @"image-styles"]];

	BOOL hasStretchInsets = NO;
    UIEdgeInsets stretchInsets = UIEdgeInsetsZero;
	
	BOOL hasContentMode = NO;
	UIViewContentMode contentMode = UIViewContentModeCenter;
	
    NSString * imageName = nil;
	
	BOOL pattern = NO;
	BOOL stretch = NO;
	BOOL round = NO;
	BOOL gray = NO;
	
// image-src: url(url)

    if ( image && image.length )
    {
		image = image.trim;
		if ( image.length )
		{
			if ( [image hasPrefix:@"url("] && [image hasSuffix:@")"] )
			{
				NSRange range = NSMakeRange( 4, image.length - 5 );
				imageName = [image substringWithRange:range].trim;
			}
			else
			{
				imageName = image;
			}
		}
    }

// image-mode:
	
    if ( imageMode )
    {
		imageMode = imageMode.trim;
		if ( imageMode.length )
		{
			if ( [imageMode isEqualToString:@"stretch"] || [imageMode isEqualToString:@"stretched"] )
			{
				stretch = YES;

				hasContentMode = YES;
				contentMode = UIViewContentModeScaleToFill;
			}
			else if ( [imageMode isEqualToString:@"round"] || [imageMode isEqualToString:@"rounded"] )
			{
				round = YES;

				hasContentMode = YES;
				contentMode = UIViewContentModeScaleAspectFit;
			}
			else
			{
				hasContentMode = YES;
				contentMode = UIViewContentModeFromString( imageMode );				
			}
		}
    }

// image-insets: { 0, 0, 0, 0 }
	
    if ( imageInsets )
    {
		imageInsets = imageInsets.trim;
		if ( imageInsets.length )
		{
			hasStretchInsets = YES;
			stretchInsets = UIEdgeInsetsFromStringEx( imageInsets );
			if ( NO == UIEdgeInsetsEqualToEdgeInsets(stretchInsets, UIEdgeInsetsZero) )
			{
				stretch = YES;
				
				hasContentMode = YES;
				contentMode = UIViewContentModeScaleToFill;
			}
		}
    }

// image-style: { gray|pattern }

	if ( imageStyles )
	{
		imageStyles = imageStyles.trim;
		if ( imageStyles.length )
		{
			NSArray * segments = [imageStyles componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			for ( NSString * segment in segments )
			{
				segment = segment.trim;
				
				if ( [segment isEqualToString:@"gray"] || [segment isEqualToString:@"grayed"] )
				{
					gray = YES;
				}
				else if ( [segment isEqualToString:@"pattern"] || [segment isEqualToString:@"repeat"] )
				{
					pattern = YES;
				}
			}
		}
	}
	
// content mode
	
	if ( hasContentMode )
	{
		self.contentMode = contentMode;
	}

// set image
	
    if ( imageName && imageName.length )
    {
		if ( [self respondsToSelector:@selector(setGray:)] )
		{
			objc_msgSend( self, @selector(setGray:), gray );
		}

		if ( [self respondsToSelector:@selector(setRound:)] )
		{
			objc_msgSend( self, @selector(setRound:), round );
		}

		if ( [self respondsToSelector:@selector(setStrech:)] )
		{
			objc_msgSend( self, @selector(setStrech:), stretch );
		}
		
//		if ( hasStretchInsets )
//		{
//			if ( [self respondsToSelector:@selector(setStrechInsets:)] )
//			{
//				objc_msgSend( self, @selector(setStrechInsets:), stretchInsets );
//			}
//		}
		
		if ( [imageName hasPrefix:@"http://"] || [imageName hasPrefix:@"https://"] )
		{
			if ( [self respondsToSelector:@selector(setUrl:)] )
			{
				[self performSelector:@selector(setUrl:) withObject:imageName];
			}
		}
		else
		{
			if ( [self respondsToSelector:@selector(setResource:)] )
			{
				[self performSelector:@selector(setResource:) withObject:imageName];
			}
		}
    }
}

#pragma mark -

- (void)setImageLoadingProperties:(NSDictionary *)properties
{
	NSString * imageLoading = [properties stringOfAny:@[@"loading", @"image-loading"]];
	if ( imageLoading )
	{
		imageLoading = imageLoading.trim;
		if ( imageLoading.length )
		{
			if ( [self respondsToSelector:@selector(setIndicatorStyle:)] )
			{
				if ( NSOrderedSame == [imageLoading compare:@"white" options:NSCaseInsensitiveSearch] )
				{
					objc_msgSend( self, @selector(setIndicatorStyle:), UIActivityIndicatorViewStyleWhite );
				}
				else if ( NSOrderedSame == [imageLoading compare:@"gray" options:NSCaseInsensitiveSearch] )
				{
					objc_msgSend( self, @selector(setIndicatorStyle:), UIActivityIndicatorViewStyleGray );
				}
			}			
		}
	}
}

#pragma mark -

- (void)applyUIStyleProperties:(NSDictionary *)properties
{
    [super applyUIStyleProperties:properties];

	[self setImageProperties:properties];
	[self setImageLoadingProperties:properties];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

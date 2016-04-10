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

#import "UIImageView+BeeUIStyle.h"
#import "UIImage+BeeExtension.h"
#import "UIColor+BeeExtension.h"
#import "UIFont+BeeExtension.h"

#import "UIView+BeeUIStyle.h"
#import "UIView+Tag.h"

#import "Bee_UIStyleParser.h"

#pragma mark -

@implementation UIImageView(BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

- (void)applyImageContent:(NSMutableDictionary *)properties
{
	BOOL				stretched = NO;
	BOOL				rounded = NO;
	BOOL				pattern = NO;
	BOOL				grayed = NO;
    BOOL                croped = NO;

	UIEdgeInsets		contentInsets = UIEdgeInsetsZero;
	CGSize              cropSize = CGSizeZero;
	UIViewContentMode	contentMode = UIViewContentModeCenter;
	NSString *			relativePath = [properties objectForKey:@"package"];

// old styels
	
	NSString * imageMode = [properties parseStringWithKeys:@[@"mode", @"image-mode"]];
    if ( imageMode )
    {
		if ( [imageMode matchAnyOf:@[@"stretch", @"stretched"]] )
		{
			stretched = YES;
			contentMode = UIViewContentModeScaleToFill;
		}
		else if ( [imageMode matchAnyOf:@[@"round", @"rounded"]] )
		{
			rounded = YES;
			contentMode = UIViewContentModeScaleAspectFit;
		}
		else
		{
			contentMode = UIViewContentModeFromString( imageMode );				
		}
    }
//	else
//	{
//		if ( [self respondsToSelector:@selector(strech)] )
//		{
//			stretched = (BOOL)[self performSelector:@selector(strech)];
//		}
//
//		if ( [self respondsToSelector:@selector(round)] )
//		{
//			rounded = (BOOL)[self performSelector:@selector(round)];
//		}
//	}

	NSString * imageInsets = [properties parseStringWithKeys:@[@"image-insets"]];
	if ( imageInsets )
	{
		contentInsets = UIEdgeInsetsFromStringEx( imageInsets );
		
		stretched = YES;
		contentMode = UIViewContentModeScaleToFill;
	}

	NSArray * imageStyles = [properties parseComponentsWithKeys:@[@"image-style"]];
	if ( imageStyles && imageStyles.count )
	{
		for ( NSString * segment in imageStyles )
		{
			if ( [segment matchAnyOf:@[@"gray", @"grayed"]] )
			{
				grayed = YES;
			}
			else if ( [segment matchAnyOf:@[@"pattern", @"repeat"]] )
			{
				pattern = YES;
			}
		}
	}
//	else
//	{
//		if ( [self respondsToSelector:@selector(gray)] )
//		{
//			grayed = (BOOL)[self performSelector:@selector(gray)];
//		}
//		
//		if ( [self respondsToSelector:@selector(pattern)] )
//		{
//			pattern = (BOOL)[self performSelector:@selector(pattern)];
//		}
//	}

// new styels
	
	NSString * imageStretch = [properties parseStringWithKeys:@[@"stretch", @"stretched"]];
	if ( imageStretch )
	{
		stretched = YES;
		contentMode = UIViewContentModeScaleToFill;
		contentInsets = UIEdgeInsetsFromStringEx( imageStretch );
	}
//	else
//	{
//		if ( [self respondsToSelector:@selector(strech)] )
//		{
//			stretched = (BOOL)[self performSelector:@selector(strech)];
//		}
//	}
    
    NSString * imageCropped = [properties parseStringWithKeys:@[@"crop"]];
    if ( imageCropped )
    {
        croped = YES;
        cropSize = CGSizeFromStringEx(imageCropped);
    }

	NSString * imageRounded = [properties parseStringWithKeys:@[@"round", @"rounded"]];
	if ( imageRounded )
	{
		rounded = [imageRounded boolValue];
		
		if ( rounded )
		{
			contentMode = UIViewContentModeScaleAspectFit;
		}
	}
//	else
//	{
//		if ( [self respondsToSelector:@selector(round)] )
//		{
//			rounded = (BOOL)[self performSelector:@selector(round)];
//		}
//	}
	
	NSString * imageGrayed = [properties parseStringWithKeys:@[@"gray", @"grayed"]];
	if ( imageGrayed )
	{
		grayed = [imageGrayed boolValue];
	}
//	else
//	{
//		if ( [self respondsToSelector:@selector(gray)] )
//		{
//			grayed = (BOOL)[self performSelector:@selector(gray)];
//		}
//	}

	NSString * imageRepeat = [properties parseStringWithKeys:@[@"pattern", @"repeat"]];
	if ( imageRepeat )
	{
		pattern = [imageRepeat boolValue];
	}
//	else
//	{
//		if ( [self respondsToSelector:@selector(pattern)] )
//		{
//			pattern = (BOOL)[self performSelector:@selector(pattern)];
//		}
//	}

// apply effects
	
	if ( [self respondsToSelector:@selector(setStrech:)] )
	{
        [(BeeUIImageView *)self setStrech:stretched];
	}
	
	if ( [self respondsToSelector:@selector(setRound:)] )
	{
        [(BeeUIImageView *)self setRound:rounded];
	}
	
	if ( [self respondsToSelector:@selector(setGray:)] )
	{
        [(BeeUIImageView *)self setGray:grayed];
	}
	
	if ( [self respondsToSelector:@selector(setPattern:)] )
	{
        [(BeeUIImageView *)self setPattern:pattern];
	}

	if ( [self respondsToSelector:@selector(setStrechInsets:)] )
	{
        [(BeeUIImageView *)self setStrechInsets:contentInsets];
	}
    
    if ( [self respondsToSelector:@selector(setCrop:)] )
	{
        [(BeeUIImageView *)self setCrop:croped];
	}
    
    if ( [self respondsToSelector:@selector(setCropSize:)] )
    {
        [(BeeUIImageView *)self setCropSize:cropSize];
    }

	self.contentMode = contentMode;

	NSString * imageName = [properties parseURLWithKeys:@[@"src", @"image", @"image-src"]];
    if ( imageName )
    {
		if ( [imageName hasPrefix:@"http://"] || [imageName hasPrefix:@"https://"] )
		{
			if ( [self respondsToSelector:@selector(setUrl:)] )
			{
				[self performSelector:@selector(setUrl:) withObject:imageName];
			}
			else
			{
				// TODO: 
			}
		}
		else
		{
			UIImage * image = nil;
			
			if ( nil == image && relativePath )
			{
				NSString * absolutePath = [relativePath stringByAppendingPathComponent:imageName];
				if ( [[NSFileManager defaultManager] fileExistsAtPath:absolutePath] )
				{
					image = [[[UIImage alloc] initWithContentsOfFile:absolutePath] autorelease];
				}
			}
			
			if ( nil == image )
			{
				image = [UIImage imageNamed:imageName];
			}

			if ( image )
			{
				if ( stretched )
				{
					if ( NO == UIEdgeInsetsEqualToEdgeInsets(contentInsets, UIEdgeInsetsZero) )
					{
						self.image = [image stretched:contentInsets];
					}
					else
					{
						self.image = [image stretched];
					}
				}
				else
				{
					self.image = image;
				}
			}
		}
    }
	else
	{
		self.image = nil;
	}
}

- (void)applyImageIndicator:(NSMutableDictionary *)properties
{
	NSString * imageLoading = [properties parseStringWithKeys:@[@"loading", @"image-loading"]];
	if ( imageLoading )
	{
		if ( NSOrderedSame == [imageLoading compare:@"white" options:NSCaseInsensitiveSearch] )
		{
			if ( [self respondsToSelector:@selector(setIndicatorStyle:)] )
			{
				UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleWhite;
				
                [(BeeUIImageView *)self setIndicatorStyle:indicatorStyle];
			}
		}
		else if ( NSOrderedSame == [imageLoading compare:@"gray" options:NSCaseInsensitiveSearch] )
		{
			if ( [self respondsToSelector:@selector(setIndicatorStyle:)] )
			{
				UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleGray;
				
                [(BeeUIImageView *)self setIndicatorStyle:indicatorStyle];
			}
		}
		else
		{
			if ( [self respondsToSelector:@selector(setIndicatorColor:)] )
			{
				UIColor * color = [UIColor colorWithString:imageLoading];
				if ( color )
				{
                    [(BeeUIImageView *)self setIndicatorColor:color];
				}
			}
		}
	}
//	else
//	{
//		objc_msgSend( self, @selector(setIndicatorStyle:), UIActivityIndicatorViewStyleGray );
//	}
}

#pragma mark -

- (void)applyUIStyling:(NSDictionary *)properties
{
	NSMutableDictionary * propertiesCopy = [NSMutableDictionary dictionaryWithDictionary:properties];

	[self applyImageContent:propertiesCopy];
	[self applyImageIndicator:propertiesCopy];

	[super applyUIStyling:propertiesCopy];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "UIButton+BeeUIStyle.h"
#import "UIImage+Theme.h"
#import "UIColor+Theme.h"
#import "UIFont+Theme.h"
#import "UIView+Background.h"

#pragma mark -

@implementation UIButton(BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

- (void)resetUIStyleProperties
{
	[super resetUIStyleProperties];
}

- (UIImage *)imageNamed:(NSString *)imageName
{
    if ( imageName )
    {
		imageName = imageName.trim;
		
		if ( imageName.length )
		{
			if ( [imageName hasPrefix:@"url("] && [imageName hasSuffix:@")"] )
			{
				NSRange range = NSMakeRange( 4, imageName.length - 5 );
				imageName = [imageName substringWithRange:range].trim;
			}
		}
		
		if ( imageName && imageName.length )
		{
			return [UIImage imageFromString:imageName];
		}
    }

	return nil;
}

#pragma mark -

- (void)setButtonBackgroundProperties:(NSDictionary *)properties
{
// normal
	
	UIImage * imageNormal = [self imageNamed:[properties stringOfAny:@[@"background-image", @"button-background", @"button-background-normal"]]];
	if ( imageNormal )
	{
		[self setBackgroundImage:[imageNormal stretched] forState:UIControlStateNormal];
	}

// highlighted

	UIImage * imageHighlighted = [self imageNamed:[properties stringOfAny:@[@"background-image-highlighted", @"button-background-highlighted"]]];
	if ( imageHighlighted )
	{
		[self setBackgroundImage:[imageHighlighted stretched] forState:UIControlStateHighlighted];
	}

// disabled

	UIImage * imageDisabled = [self imageNamed:[properties stringOfAny:@[@"background-image-disabled", @"button-background-disabled"]]];
	if ( imageDisabled )
	{
		[self setBackgroundImage:[imageDisabled stretched] forState:UIControlStateDisabled];
	}

// selected
	
	UIImage * imageSelected = [self imageNamed:[properties stringOfAny:@[@"background-image-selected", @"button-background-selected"]]];
    if ( imageSelected )
    {
		[self setBackgroundImage:[imageSelected stretched] forState:UIControlStateSelected];
    }
}

#pragma mark -

- (void)setButtonImageProperties:(NSDictionary *)properties
{
// normal
	
	UIImage * imageNormal = [self imageNamed:[properties stringOfAny:@[@"image", @"button-image", @"button-image-normal"]]];
	if ( imageNormal )
	{
		[self setImage:[imageNormal stretched] forState:UIControlStateNormal];
	}
	
// highlighted
	
	UIImage * imageHighlighted = [self imageNamed:[properties stringOfAny:@[@"image-highlighted", @"button-image-highlighted"]]];
	if ( imageHighlighted )
	{
		[self setImage:[imageHighlighted stretched] forState:UIControlStateHighlighted];
	}
	
// disabled
	
	UIImage * imageDisabled = [self imageNamed:[properties stringOfAny:@[@"image-disabled", @"button-image-disabled"]]];
	if ( imageDisabled )
	{
		[self setImage:[imageDisabled stretched] forState:UIControlStateDisabled];
	}
	
// selected
	
	UIImage * imageSelected = [self imageNamed:[properties stringOfAny:@[@"image-selected", @"button-image-selected"]]];
    if ( imageSelected )
    {
		[self setImage:[imageSelected stretched] forState:UIControlStateSelected];
    }
}

#pragma mark -

- (void)setButtonTitleProperties:(NSDictionary *)properties
{
// normal
	
    NSString * title = [properties stringOfAny:@[@"text", @"button-title"]];
    if ( title && title.length )
    {
        [self setTitle:title forState:UIControlStateNormal];
    }
    
//    NSString * titleAlginment = [properties stringOfAny:@[@"text-align", @"button-title-align"]];
//    if ( titleAlginment && titleAlginment.length )
//    {
//        if ( [self isKindOfClass:[BeeUIButton class]] )
//        {
//            [(BeeUIButton *)self setTitleTextAlignment:UITextAlignmentFromString(titleAlginment)];
//        }
//    }
	
// highlighted
    
    NSString * titleHighlighted = [properties stringOfAny:@[@"text-highlighted", @"button-title-highlighted"]];
    if ( titleHighlighted )
    {
        [self setTitle:titleHighlighted forState:UIControlStateHighlighted];
    }
    
// disabled
	
    NSString * titleDisabled = [properties stringOfAny:@[@"text-disabled", @"button-title-disabled"]];
    if ( titleDisabled )
    {
        [self setTitle:titleDisabled forState:UIControlStateDisabled];
    }
    
// selected
    
    NSString * titleSelected = [properties stringOfAny:@[@"text-selected", @"button-title-selected"]];
    if ( titleSelected )
    {
        [self setTitle:titleSelected forState:UIControlStateSelected];
    }

// font

	NSString * font = [properties stringOfAny:@[@"font"]];
	if ( font )
	{
		font = font.trim;
		if ( font.length )
		{
			// 18,system,bold
			// 18,arial
			// 18
			// 18,bold
			// 18,italic
			
			UIFont * userFont = [UIFont fontFromString:font];
			if ( userFont )
			{
				[self performSelector:@selector(setTitleFont:) withObject:userFont];
			}
		}
	}
	else
	{
		NSString * fontFamily = [properties stringOfAny:@[@"font-name", @"font-family"]];
		NSString * fontStyle = [properties stringOfAny:@[@"font-style"]];
		NSString * fontWeight = [properties stringOfAny:@[@"font-weight"]];
		NSString * fontSize = [properties stringOfAny:@[@"font-size"]];
		
		if ( fontFamily || fontStyle || fontWeight || fontStyle )
		{
			UIFont *		userFont = nil;
			BeeUIMetrics *	userSize = [BeeUIMetrics fromString:fontSize];
			
			if ( fontFamily && fontFamily.length )
			{
				userFont = [UIFont fontWithName:fontFamily size:userSize.value];
			}
			else
			{
				if ( [fontWeight matchAnyOf:@[@"bold"]] )
				{
					userFont = [UIFont boldSystemFontOfSize:userSize.value];
				}
				else if ( [fontStyle matchAnyOf:@[@"italic"]] )
				{
					userFont = [UIFont italicSystemFontOfSize:userSize.value];
				}
				else
				{
					userFont = [UIFont systemFontOfSize:userSize.value];
				}
			}

			if ( userFont )
			{
				[self performSelector:@selector(setTitleFont:) withObject:userFont];
			}
		}
	}

// text alignment

    NSString * textAlignment = [properties stringOfAny:@[@"text-align"]];
	if ( textAlignment )
	{
		textAlignment = textAlignment.trim;
		if ( textAlignment.length )
		{
			self.titleLabel.textAlignment = UITextAlignmentFromString( textAlignment );
		}
	}
}

#pragma mark -

- (void)setButtonTitleColorProperties:(NSDictionary *)properties
{
// normal

    NSString * titleColor = [properties stringOfAny:@[@"color", @"button-title-color"]];
    if ( titleColor )
    {
		UIColor * color = [UIColor colorWithString:titleColor];
		if ( color )
		{
			[self setTitleColor:color forState:UIControlStateNormal];
		}
    }
	
// highlighted
    
    NSString * titleColorHighlighted = [properties stringOfAny:@[@"color-highlighted", @"button-title-color-highlighted"]];
    if ( titleColorHighlighted )
    {
		UIColor * color = [UIColor colorWithString:titleColorHighlighted];
		if ( color )
		{
			[self setTitleColor:color forState:UIControlStateHighlighted];
		}
    }
    
// disabled
	
    NSString * titleColorDisabled = [properties stringOfAny:@[@"color-disabled", @"button-title-color-disabled"]];
    if ( titleColorDisabled )
    {
		UIColor * color = [UIColor colorWithString:titleColorDisabled];
		if ( color )
		{
			[self setTitleColor:color forState:UIControlStateDisabled];
		}
    }
	
// selected
    
    NSString * titleColorSelected = [properties stringOfAny:@[@"color-selected", @"button-title-color-selected"]];
    if ( titleColorSelected )
    {
		UIColor * color = [UIColor colorWithString:titleColorSelected];
		if ( color )
		{
			[self setTitleColor:color forState:UIControlStateSelected];
		}
    }
}

#pragma mark -

- (void)setButtonInsetsProperties:(NSDictionary *)properties
{
	NSString * contentEdgeInsets = [properties stringOfAny:@[@"insets", @"button-insets"]];
    if ( contentEdgeInsets )
    {
		UIEdgeInsets insets = UIEdgeInsetsFromStringEx( contentEdgeInsets );
		if ( NO == UIEdgeInsetsEqualToEdgeInsets( insets, UIEdgeInsetsZero ) )
		{
			[self setContentEdgeInsets:insets];	
		}
    }

	NSString * titleEdgeInsets = [properties stringOfAny:@[@"text-insets", @"button-text-insets", @"button-title-insets"]];
    if ( titleEdgeInsets )
    {
		UIEdgeInsets insets = UIEdgeInsetsFromStringEx( titleEdgeInsets );
		if ( NO == UIEdgeInsetsEqualToEdgeInsets( insets, UIEdgeInsetsZero ) )
		{
			[self setTitleEdgeInsets:insets];
		}
    }

	NSString * imageEdgeInsets = [properties stringOfAny:@[@"image-insets", @"button-image-insets"]];
    if ( imageEdgeInsets )
    {
		UIEdgeInsets insets = UIEdgeInsetsFromStringEx( imageEdgeInsets );
		if ( NO == UIEdgeInsetsEqualToEdgeInsets( insets, UIEdgeInsetsZero ) )
		{
			[self setImageEdgeInsets:insets];
		}
    }
}


- (void)setBackgroundProperties:(NSDictionary *)properties
{
    NSString * background = [properties stringOfAny:@[@"background"]];
    NSString * backgroundColor = [properties stringOfAny:@[@"background-color"]];
    NSString * backgroundImage = [properties stringOfAny:@[@"background-image"]];
	NSString * backgroundMode = [properties stringOfAny:@[@"background-mode"]];
	NSString * backgroundInsets = [properties stringOfAny:@[@"background-insets"]];
	NSString * backgroundStyles = [properties stringOfAny:@[@"background-style", @"background-styles"]];
    
	BOOL hasStretchInsets = NO;
    UIEdgeInsets stretchInsets = UIEdgeInsetsZero;
	
	BOOL hasContentMode = NO;
	UIViewContentMode contentMode = UIViewContentModeCenter;
    
    NSString * imageName = nil;
	NSString * colorName = nil;
    
	BOOL pattern = NO;
	BOOL stretch = NO;
	BOOL round = NO;
	BOOL gray = NO;
	
    // background { #FFFFFF url(url)  }
	
    if ( background && background.length )
    {
		background = background.trim;
		if ( background.length )
		{
			NSArray * segments = [background componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			for ( NSString * segment in segments )
			{
				segment = segment.trim;
				
				if ( [segment hasPrefix:@"url("] && [segment hasSuffix:@")"] )
				{
					NSRange range = NSMakeRange( 4, segment.length - 5 );
					imageName = [segment substringWithRange:range].trim;
				}
				else if ( [segment hasPrefix:@"#"] )
				{
					colorName = segment;
				}
				else
				{
					// TODO:
				}
			}
		}
    }
    
    // background-color: { #FFFFF | #FFFFFF, 0.6 }
	
    if ( backgroundColor )
    {
		backgroundColor = backgroundColor.trim;
		if ( backgroundColor.length )
		{
			colorName = backgroundColor;
		}
    }
    
    // background-mode:
	
    if ( backgroundMode )
    {
		backgroundMode = backgroundMode.trim;
		if ( backgroundColor.length )
		{
			if ( [backgroundMode isEqualToString:@"stretch"] || [backgroundMode isEqualToString:@"stretched"] )
			{
				stretch = YES;
				
				hasContentMode = YES;
				contentMode = UIViewContentModeScaleToFill;
			}
			else if ( [backgroundMode isEqualToString:@"round"] || [backgroundMode isEqualToString:@"rounded"] )
			{
				round = YES;
				
				hasContentMode = YES;
				contentMode = UIViewContentModeScaleAspectFit;
			}
			else
			{
				hasContentMode = YES;
				contentMode = UIViewContentModeFromString( backgroundMode );
			}
		}
    }
    
    // background-insets: { 0, 0, 0, 0 }
    
    if ( backgroundInsets )
    {
		backgroundInsets = backgroundInsets.trim;
		if ( backgroundInsets.length )
		{
			hasStretchInsets = YES;
			stretchInsets = UIEdgeInsetsFromStringEx( backgroundInsets );
			if ( NO == UIEdgeInsetsEqualToEdgeInsets(stretchInsets, UIEdgeInsetsZero) )
			{
				hasContentMode = YES;
				contentMode = UIViewContentModeScaleToFill;
			}
		}
    }
    
    // background-image: { url(url) }
	
    if ( backgroundImage )
    {
		backgroundImage = backgroundImage.trim;
		if ( backgroundImage.length )
		{
			if ( [backgroundImage hasPrefix:@"url("] && [backgroundImage hasSuffix:@")"] )
			{
				NSRange range = NSMakeRange( 4, backgroundImage.length - 5 );
				imageName = [backgroundImage substringWithRange:range].trim;
			}
			else
			{
				imageName = backgroundImage;
			}
		}
    }
    
    // background-style: { gray|pattern }
	
	if ( backgroundStyles )
	{
		backgroundStyles = backgroundStyles.trim;
		if ( backgroundStyles.length )
		{
			NSArray * segments = [backgroundStyles componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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
    
    // set color
	
    if ( colorName && colorName.length )
    {
		if ( pattern )
		{
			UIImage * image = [UIImage imageFromString:imageName];
			if ( image )
			{
				self.backgroundColor = [UIColor colorWithPatternImage:image];
                return;
			}
		}
		else
		{
			self.backgroundColor = [UIColor colorWithString:colorName];
		}
    }
    
    // set image
	
    if ( imageName && imageName.length )
    {
		self.backgroundImageView.gray = gray;
		self.backgroundImageView.round = round;
		self.backgroundImageView.strech = stretch;
		
        UIImage * image = nil;
        
		if ( hasStretchInsets )
		{
			image = [UIImage imageFromString:imageName stretched:stretchInsets];
		}
        else
        {
            image = [UIImage imageFromString:imageName];
        }
        
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
}

#pragma mark -

- (void)applyUIStyleProperties:(NSDictionary *)properties
{
    [super applyUIStyleProperties:properties];

	[self setButtonBackgroundProperties:properties];
	[self setButtonImageProperties:properties];
	[self setButtonTitleProperties:properties];
	[self setButtonTitleColorProperties:properties];
	[self setButtonInsetsProperties:properties];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "Bee_UIStyleParser.h"
#import "Bee_UIMetrics.h"

#import "Bee_Language.h"
#import "Bee_LanguageSetting.h"

#import "UIImage+BeeExtension.h"
#import "UIColor+BeeExtension.h"
#import "UIFont+BeeExtension.h"
#import "UIView+Background.h"

#import "CSSStyleSheet.h"

#pragma mark -

@implementation BeeUIStyleParser

+ (CSSStyleSheet *)parseStyleSheet:(id)obj
{
    CSSStyleSheet * styleSheet = [CSSStyleSheet styleSheet];
    [styleSheet parseString:obj];
    return styleSheet;
}

+ (NSMutableDictionary *)parse:(id)obj
{
	if ( [obj isKindOfClass:[NSString class]] )
	{
		return [self parseText:obj];
	}
	else if ( [obj isKindOfClass:[NSData class]] )
	{
		return [self parseData:obj];
	}
	else if ( [obj isKindOfClass:[NSDictionary class]] )
	{
		return [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)obj];
	}
	
	return nil;
}

+ (NSMutableDictionary *)parseData:(NSData *)data
{
	NSString * string = [data asNSString];
	return [self parseText:string];
}

+ (NSMutableDictionary *)parseText:(NSString *)text
{
	NSMutableDictionary * result = [NSMutableDictionary dictionary];
	
	if ( text && text.length )
	{
		text = text.trim;

		NSArray * segments = [text componentsSeparatedByString:@"}"];
		for ( NSString * seg in segments )
		{
			NSArray * keyValue = [seg componentsSeparatedByString:@"{"];
			if ( keyValue.count != 2 )
				continue;
			
			NSString * key = [keyValue objectAtIndex:0];
			NSString * val = [keyValue objectAtIndex:1];
			
			key = key.trim.unwrap;
			val = val.trim.unwrap;
			
			if ( 0 == key.length || 0 == val.length )
				continue;

			NSMutableDictionary * properties = [self parseProperties:val];
			if ( nil == properties || 0 == properties.count )
				continue;

			NSArray * keys = [key componentsSeparatedByString:@","];
			for ( NSString * key2 in keys )
			{
				key2 = key2.trim.unwrap;
				if ( key2.length )
				{
					[result setObject:properties forKey:key2];
				}
			}
		}
	}

	return result;
}

+ (NSMutableDictionary *)parseProperties:(NSString *)text
{
	NSMutableDictionary * properties = [NSMutableDictionary dictionary];
	
	NSArray * segments = [text componentsSeparatedByString:@";"];
	for ( NSString * seg in segments )
	{
		NSCharacterSet *	set = [NSCharacterSet characterSetWithCharactersInString:@":"];
		NSUInteger			offset = 0;

		NSString *	key = [seg substringFromIndex:0 untilCharset:set endOffset:&offset];
		NSString *	val = [seg substringFromIndex:offset];

		if ( key.length && val.length )
		{
			key = key.trim.unwrap;
			val = val.trim.unwrap;

			if ( [val rangeOfString:@"!important"].length )
			{
				val = [val stringByReplacingOccurrencesOfString:@"!important" withString:@""];
				val = val.trim;
			}

			[properties setObject:val forKey:key];
		}
	}
	
	return properties;
}

@end

#pragma mark -

@implementation NSMutableDictionary(BeeUIStyleUtility)

- (UIFont *)parseFont
{
	return [self parseFontWithDefaultValue:[UIFont systemFontOfSize:12.0f]];
}

- (UIFont *)parseFontWithDefaultValue:(UIFont *)defaultValue
{
	UIFont *	fontValue = nil;
	NSString *	font = [self stringOfAny:@[@"font"] removeAll:YES];
	
	if ( font && font.length )
	{
		// 18,system,bold
		// 18,arial
		// 18
		// 18,bold
		// 18,italic
		
		fontValue = [UIFont fontFromString:font];
	}
	else
	{
		NSString * fontFamily = @"方正兰亭纤黑_GBK"; // [self stringOfAny:@[@"font-name", @"font-family"] removeAll:YES];
		NSString * fontStyle = [self stringOfAny:@[@"font-style"] removeAll:YES];
		NSString * fontWeight = [self stringOfAny:@[@"font-weight"] removeAll:YES];
		NSString * fontSize = [self stringOfAny:@[@"font-size"] removeAll:YES];
		
		if ( fontFamily || fontStyle || fontWeight || fontSize )
		{
			CGFloat heightPixels = 0.0f;
			
			BeeUIMetrics * metrics = [BeeUIMetrics fromString:fontSize];
			if ( metrics )
			{
				heightPixels = metrics.value;
			}
			else
			{
				heightPixels = 12.0f;
			}

			if ( fontFamily && fontFamily.length )
			{
				fontValue = [UIFont fontWithName:fontFamily size:heightPixels];
			}
			
			if ( nil == fontValue )
			{
				if ( [fontWeight matchAnyOf:@[@"bold"]] )
				{
					fontValue = [UIFont boldSystemFontOfSize:heightPixels];
				}
				else if ( [fontStyle matchAnyOf:@[@"italic"]] )
				{
					fontValue = [UIFont italicSystemFontOfSize:heightPixels];
				}
				else
				{
					fontValue = [UIFont systemFontOfSize:heightPixels];
				}
			}
		}
	}
	
	if ( nil == fontValue )
	{
		return defaultValue ? defaultValue : [UIFont systemFontOfSize:12.0f];
	}
	
	return fontValue;
}

- (NSInteger)parseIntegerWithKeys:(NSArray *)keys
{
	return [self parseIntegerWithKeys:keys defaultValue:0];
}

- (NSInteger)parseIntegerWithKeys:(NSArray *)keys defaultValue:(NSInteger)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{
		return [value integerValue];
	}
	
	return defaultValue;
}

- (NSInteger)parseLineNumberWithKeys:(NSArray *)keys
{
	return [self parseIntegerWithKeys:keys defaultValue:1];
}

- (NSInteger)parseLineNumberWithKeys:(NSArray *)keys defaultValue:(NSInteger)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{
		if ( [value matchAnyOf:@[@"auto"]] )
		{
			return 99999;
		}
		else
		{
			return [value integerValue];
		}
	}

	return defaultValue;
}

- (CGFloat)parseFloatWithKeys:(NSArray *)keys
{
	return [self parseFloatWithKeys:keys defaultValue:0.0f];
}

- (CGFloat)parseFloatWithKeys:(NSArray *)keys defaultValue:(CGFloat)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{
		return [value floatValue];
	}
	
	return defaultValue;
}

- (CGSize)parseSizeWithKeys:(NSArray *)keys
{
	return [self parseSizeWithKeys:keys defaultValue:CGSizeZero];
}

- (CGSize)parseSizeWithKeys:(NSArray *)keys defaultValue:(CGSize)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( nil == value )
	{
		return defaultValue;
	}

	NSArray * segments = [value componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ( segments.count == 2 )
	{
		CGFloat w = [[segments objectAtIndex:0] floatValue];
		CGFloat h = [[segments objectAtIndex:1] floatValue];
		
		return CGSizeMake( w, h );
	}
	else if ( segments.count == 1 )
	{
		CGFloat w = [[segments objectAtIndex:0] floatValue];
		CGFloat h = w;
		
		return CGSizeMake( w, h );
	}
	else
	{
		return CGSizeMake( 0, 0 );
	}

	return defaultValue;
}

- (NSString *)parseStringWithKeys:(NSArray *)keys
{
	return [self parseStringWithKeys:keys defaultValue:nil];
}

- (NSString *)parseStringWithKeys:(NSArray *)keys defaultValue:(NSString *)defaultValue
{
	NSString * value = [self stringOfAny:keys removeAll:YES];
	if ( nil == value )
	{
		return defaultValue;
	}
	
	value = value.unwrap.trim;
	if ( 0 == value.length )
	{
		return defaultValue;
	}
	
	return value;
}

- (NSString *)parseTextWithKeys:(NSArray *)keys
{
	return [self parseTextWithKeys:keys defaultValue:nil];
}

- (NSString *)parseTextWithKeys:(NSArray *)keys defaultValue:(NSString *)defaultValue
{
	NSString * text = [self parseStringWithKeys:keys];
	if ( nil == text || 0 == text.length )
	{
		return defaultValue;
	}

	if ( [text hasPrefix:@"@{"] && [text hasSuffix:@"}"] )
	{
		NSString * textID = [text substringWithRange:NSMakeRange(2, text.length - 3)];
		if ( textID && text.length )
		{
			text = __TEXT( textID.trim );
		}
	}

	return (text && text.length) ? text : defaultValue;
}

- (NSArray *)parseComponentsWithKeys:(NSArray *)keys
{
	return [self parseComponentsWithKeys:keys defaultValue:nil];
}

- (NSArray *)parseComponentsWithKeys:(NSArray *)keys defaultValue:(NSArray *)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( nil == value )
	{
		return defaultValue;
	}

	NSArray * segments = [value componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ( nil == segments || 0 == segments.count )
	{
		return defaultValue;
	}
	
	return segments;
}

- (NSString *)parseURLWithKeys:(NSArray *)keys
{
	return [self parseURLWithKeys:keys defaultValue:nil];
}

- (NSString *)parseURLWithKeys:(NSArray *)keys defaultValue:(NSString *)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( nil == value )
	{
		return defaultValue;
	}
	
	if ( [value hasPrefix:@"url("] && [value hasSuffix:@")"] )
	{
		NSRange range = NSMakeRange( 4, value.length - 5 );
		value = [value substringWithRange:range].trim;
	}

	return value;
}

- (UIImage *)parseImageWithKeys:(NSArray *)keys
{
	return [self parseImageWithKeys:keys defaultValue:nil];
}

- (UIImage *)parseImageWithKeys:(NSArray *)keys defaultValue:(UIImage *)defaultValue
{
	NSString * imageName = [self parseStringWithKeys:keys];
	if ( imageName )
	{
		UIImage * image = [UIImage imageFromString:imageName];
		if ( image )
		{
			return image;
		}
	}

	return defaultValue;
}

- (UIImage *)parseImageWithKeys:(NSArray *)keys relativePath:(NSString *)path
{
	return [self parseImageWithKeys:keys relativePath:path defaultValue:nil];
}

- (UIImage *)parseImageWithKeys:(NSArray *)keys relativePath:(NSString *)path defaultValue:(UIImage *)defaultValue
{
	NSString * imageName = [self parseStringWithKeys:keys];
	if ( imageName )
	{
		UIImage * image = [UIImage imageFromString:imageName atPath:path];
		if ( image )
		{
			return image;
		}
	}
	
	return defaultValue;	
}

- (UIColor *)parseColorWithKeys:(NSArray *)keys
{
	return [self parseColorWithKeys:keys defaultValue:nil];
}

- (UIColor *)parseColorWithKeys:(NSArray *)keys defaultValue:(UIColor *)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{	
		UIColor * color = [UIColor colorWithString:value];
		if ( color )
		{
			return color;
		}
	}

	return defaultValue;
}

- (BOOL)parseBoolWithKeys:(NSArray *)keys
{
	return [self parseBoolWithKeys:keys defaultValue:NO];
}

- (BOOL)parseBoolWithKeys:(NSArray *)keys defaultValue:(BOOL)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{
		if ( [value matchAnyOf:@[@"true", @"yes"]] )
		{
			return YES;
		}
		else if ( [value matchAnyOf:@[@"false", @"no"]] )
		{
			return NO;
		}
	}
	
	return defaultValue;
}

- (UIViewContentMode)parseContentModeWithKeys:(NSArray *)keys
{
	return [self parseContentModeWithKeys:keys defaultValue:UIViewContentModeCenter];
}

- (UIViewContentMode)parseContentModeWithKeys:(NSArray *)keys defaultValue:(UIViewContentMode)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{
		return UIViewContentModeFromString( value );
	}
	
	return defaultValue;
}

- (UITextAlignment)parseTextAlignmentWithKeys:(NSArray *)keys
{
	return [self parseTextAlignmentWithKeys:keys defaultValue:UITextAlignmentLeft];
}

- (UITextAlignment)parseTextAlignmentWithKeys:(NSArray *)keys defaultValue:(UITextAlignment)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{
		return UITextAlignmentFromString( value );
	}
	
	return defaultValue;
}

- (UIBaselineAdjustment)parseBaselineAdjustmentWithKeys:(NSArray *)keys
{
	return [self parseBaselineAdjustmentWithKeys:keys defaultValue:UIBaselineAdjustmentAlignCenters];
}

- (UIBaselineAdjustment)parseBaselineAdjustmentWithKeys:(NSArray *)keys defaultValue:(UIBaselineAdjustment)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{
		return UIBaselineAdjustmentFromString( value );
	}
	
	return defaultValue;
}

- (UIEdgeInsets)parseEdgeInsetsWithKeys:(NSArray *)keys
{
	return [self parseEdgeInsetsWithKeys:keys defaultValue:UIEdgeInsetsZero];
}

- (UIEdgeInsets)parseEdgeInsetsWithKeys:(NSArray *)keys defaultValue:(UIEdgeInsets)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{
		return UIEdgeInsetsFromStringEx( value );
	}
	
	return defaultValue;
}

- (UIControlContentHorizontalAlignment)parseHorizontalAlignmentWithKeys:(NSArray *)keys
{
	return [self parseHorizontalAlignmentWithKeys:keys defaultValue:UIControlContentHorizontalAlignmentCenter];
}

- (UIControlContentHorizontalAlignment)parseHorizontalAlignmentWithKeys:(NSArray *)keys defaultValue:(UIControlContentHorizontalAlignment)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{
		if ( [value matchAnyOf:@[@"l", @"left"]] )
        {
			return UIControlContentHorizontalAlignmentLeft;
        }
        else if ( [value matchAnyOf:@[@"r", @"right"]] )
        {
			return UIControlContentHorizontalAlignmentRight;
        }
        else if ( [value matchAnyOf:@[@"c", @"center"]] )
        {
            return UIControlContentHorizontalAlignmentCenter;
        }
	}

	return defaultValue;
}

- (UIControlContentVerticalAlignment)parseVerticalAlignmentWithKeys:(NSArray *)keys
{
	return [self parseVerticalAlignmentWithKeys:keys defaultValue:UIControlContentVerticalAlignmentCenter];
}

- (UIControlContentVerticalAlignment)parseVerticalAlignmentWithKeys:(NSArray *)keys defaultValue:(UIControlContentVerticalAlignment)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{
		if ( [value matchAnyOf:@[@"t", @"top"]] )
        {
			return UIControlContentVerticalAlignmentTop;
        }
        else if ( [value matchAnyOf:@[@"b", @"bottom"]] )
        {
			return UIControlContentVerticalAlignmentBottom;
        }
        else if ( [value matchAnyOf:@[@"c", @"center"]] )
        {
			return UIControlContentVerticalAlignmentCenter;
        }
	}
	
	return defaultValue;
}

- (UILineBreakMode)parseLineBreakModeWithKeys:(NSArray *)keys
{
	return [self parseLineBreakModeWithKeys:keys defaultValue:UILineBreakModeClip];
}

- (UILineBreakMode)parseLineBreakModeWithKeys:(NSArray *)keys defaultValue:(UILineBreakMode)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( value )
	{
		return UILineBreakModeFromString( value );
	}
	
	return defaultValue;
}

- (UIReturnKeyType)parseReturnKeyTypeWithKeys:(NSArray *)keys
{
	return [self parseReturnKeyTypeWithKeys:keys defaultValue:UIReturnKeyDefault];
}

- (UIReturnKeyType)parseReturnKeyTypeWithKeys:(NSArray *)keys defaultValue:(UIReturnKeyType)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( nil == value )
	{
		return defaultValue;
	}
		
	if ( [value matchAnyOf:@[@"done"]] )
	{
		return UIReturnKeyDone;
	}
	else if ( [value matchAnyOf:@[@"search"]] )
	{
		return UIReturnKeySearch;
	}
	else if ( [value matchAnyOf:@[@"join"]] )
	{
		return UIReturnKeyJoin;
	}
	else if ( [value matchAnyOf:@[@"send"]] )
	{
		return UIReturnKeySend;
	}
	else if ( [value matchAnyOf:@[@"next"]] )
	{
		return UIReturnKeyNext;
	}
	else if ( [value matchAnyOf:@[@"go"]] )
	{
		return UIReturnKeyGo;
	}

	return defaultValue;
}

- (UIKeyboardType)parseKeyboardTypeWithKeys:(NSArray *)keys
{
	return [self parseKeyboardTypeWithKeys:keys defaultValue:UIKeyboardTypeDefault];
}

- (UIKeyboardType)parseKeyboardTypeWithKeys:(NSArray *)keys defaultValue:(UIKeyboardType)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( nil == value )
	{
		return defaultValue;
	}

	if ( [value matchAnyOf:@[@"ascii", @"abc"]] )
	{
		return UIKeyboardTypeASCIICapable;
	}
	else if ( [value matchAnyOf:@[@"number", @"123"]] )
	{
		return UIKeyboardTypeNumbersAndPunctuation;
	}
	else if ( [value matchAnyOf:@[@"pin"]] )
	{
		return UIKeyboardTypeNumberPad;
	}
	else if ( [value matchAnyOf:@[@"phone"]] )
	{
		return UIKeyboardTypePhonePad;
	}
	else if ( [value matchAnyOf:@[@"contact"]] )
	{
		return UIKeyboardTypeNamePhonePad;
	}
	else if ( [value matchAnyOf:@[@"email"]] )
	{
		return UIKeyboardTypeEmailAddress;
	}

	return defaultValue;
}

- (UITextAutocapitalizationType)parseAutocapitalizationTypeWithKeys:(NSArray *)keys
{
	return [self parseAutocapitalizationTypeWithKeys:keys defaultValue:UITextAutocapitalizationTypeNone];
}

- (UITextAutocapitalizationType)parseAutocapitalizationTypeWithKeys:(NSArray *)keys defaultValue:(UITextAutocapitalizationType)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( nil == value )
	{
		return defaultValue;
	}

	if ( [value matchAnyOf:@[@"chars", @"characters"]] )
	{
		return UITextAutocapitalizationTypeAllCharacters;
	}
	else if ( [value matchAnyOf:@[@"words"]] )
	{
		return UITextAutocapitalizationTypeWords;
	}
	else if ( [value matchAnyOf:@[@"sents", @"sentences"]] )
	{
		return UITextAutocapitalizationTypeSentences;
	}
	
	return defaultValue;
}

- (UITextAutocorrectionType)parseAutocorrectionTypeWithKeys:(NSArray *)keys
{
	return [self parseAutocorrectionTypeWithKeys:keys defaultValue:UITextAutocorrectionTypeDefault];
}

- (UITextAutocorrectionType)parseAutocorrectionTypeWithKeys:(NSArray *)keys defaultValue:(UITextAutocorrectionType)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( nil == value )
	{
		return defaultValue;
	}
	
	if ( [value matchAnyOf:@[@"true", @"yes"]] )
	{
		return UITextAutocorrectionTypeYes;
	}
	else if ( [value matchAnyOf:@[@"false", @"no"]] )
	{
		return UITextAutocorrectionTypeNo;
	}
	
	return defaultValue;
}

- (UITextFieldViewMode)parseTextFieldViewModeWithKeys:(NSArray *)keys
{
	return [self parseTextFieldViewModeWithKeys:keys defaultValue:UITextFieldViewModeWhileEditing];
}

- (UITextFieldViewMode)parseTextFieldViewModeWithKeys:(NSArray *)keys defaultValue:(UITextFieldViewMode)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( nil == value )
	{
		return defaultValue;
	}

	if ( [value matchAnyOf:@[@"never"]] )
	{
		return UITextFieldViewModeNever;
	}
	else if ( [value matchAnyOf:@[@"not-editing", @"unless-editing"]] )
	{
		return UITextFieldViewModeUnlessEditing;
	}
	else if ( [value matchAnyOf:@[@"always"]] )
	{
		return UITextFieldViewModeAlways;
	}

	return defaultValue;
}

- (UITextBorderStyle)parseTextBorderStyleWithKeys:(NSArray *)keys
{
	return [self parseTextBorderStyleWithKeys:keys defaultValue:UITextBorderStyleNone];
}

- (UITextBorderStyle)parseTextBorderStyleWithKeys:(NSArray *)keys defaultValue:(UITextBorderStyle)defaultValue
{
	NSString * value = [self parseStringWithKeys:keys];
	if ( nil == value )
	{
		return defaultValue;
	}

	if ( [value matchAnyOf:@[@"line"]] )
	{
		return UITextBorderStyleLine;
	}
	else if ( [value matchAnyOf:@[@"bezel"]] )
	{
		return UITextBorderStyleBezel;
	}
	else if ( [value matchAnyOf:@[@"round", @"rounded", @"rounded-rect"]] )
	{
		return UITextBorderStyleRoundedRect;
	}

	return UITextBorderStyleNone;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

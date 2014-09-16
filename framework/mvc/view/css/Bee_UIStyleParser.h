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

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"

@class CSSStyleSheet;

#pragma mark -

@interface BeeUIStyleParser : NSObject

+ (NSMutableDictionary *)parse:(id)obj;
+ (NSMutableDictionary *)parseText:(NSString *)string;
+ (NSMutableDictionary *)parseData:(NSData *)data;
+ (NSMutableDictionary *)parseProperties:(NSString *)text;

+ (CSSStyleSheet *)parseStyleSheet:(id)obj;

@end

#pragma mark -

@interface NSMutableDictionary(BeeUIStyleUtility)

- (UIFont *)parseFont;
- (UIFont *)parseFontWithDefaultValue:(UIFont *)defaultValue;

- (NSInteger)parseIntegerWithKeys:(NSArray *)keys;
- (NSInteger)parseIntegerWithKeys:(NSArray *)keys defaultValue:(NSInteger)defaultValue;

- (NSInteger)parseLineNumberWithKeys:(NSArray *)keys;
- (NSInteger)parseLineNumberWithKeys:(NSArray *)keys defaultValue:(NSInteger)defaultValue;

- (CGFloat)parseFloatWithKeys:(NSArray *)keys;
- (CGFloat)parseFloatWithKeys:(NSArray *)keys defaultValue:(CGFloat)defaultValue;

- (CGSize)parseSizeWithKeys:(NSArray *)keys;
- (CGSize)parseSizeWithKeys:(NSArray *)keys defaultValue:(CGSize)defaultValue;

- (NSString *)parseStringWithKeys:(NSArray *)keys;
- (NSString *)parseStringWithKeys:(NSArray *)keys defaultValue:(NSString *)defaultValue;

- (NSString *)parseTextWithKeys:(NSArray *)keys;
- (NSString *)parseTextWithKeys:(NSArray *)keys defaultValue:(NSString *)defaultValue;

- (NSArray *)parseComponentsWithKeys:(NSArray *)keys;
- (NSArray *)parseComponentsWithKeys:(NSArray *)keys defaultValue:(NSArray *)defaultValue;

- (NSString *)parseURLWithKeys:(NSArray *)keys;
- (NSString *)parseURLWithKeys:(NSArray *)keys defaultValue:(NSString *)defaultValue;

- (UIImage *)parseImageWithKeys:(NSArray *)keys;
- (UIImage *)parseImageWithKeys:(NSArray *)keys defaultValue:(UIImage *)defaultValue;

- (UIImage *)parseImageWithKeys:(NSArray *)keys relativePath:(NSString *)path;
- (UIImage *)parseImageWithKeys:(NSArray *)keys relativePath:(NSString *)path defaultValue:(UIImage *)defaultValue;

- (UIColor *)parseColorWithKeys:(NSArray *)keys;
- (UIColor *)parseColorWithKeys:(NSArray *)keys defaultValue:(UIColor *)defaultValue;

- (BOOL)parseBoolWithKeys:(NSArray *)keys;
- (BOOL)parseBoolWithKeys:(NSArray *)keys defaultValue:(BOOL)defaultValue;

- (UIViewContentMode)parseContentModeWithKeys:(NSArray *)keys;
- (UIViewContentMode)parseContentModeWithKeys:(NSArray *)keys defaultValue:(UIViewContentMode)defaultValue;

- (UITextAlignment)parseTextAlignmentWithKeys:(NSArray *)keys;
- (UITextAlignment)parseTextAlignmentWithKeys:(NSArray *)keys defaultValue:(UITextAlignment)defaultValue;

- (UIBaselineAdjustment)parseBaselineAdjustmentWithKeys:(NSArray *)keys;
- (UIBaselineAdjustment)parseBaselineAdjustmentWithKeys:(NSArray *)keys defaultValue:(UIBaselineAdjustment)defaultValue;

- (UIEdgeInsets)parseEdgeInsetsWithKeys:(NSArray *)keys;
- (UIEdgeInsets)parseEdgeInsetsWithKeys:(NSArray *)keys defaultValue:(UIEdgeInsets)defaultValue;

- (UIControlContentHorizontalAlignment)parseHorizontalAlignmentWithKeys:(NSArray *)keys;
- (UIControlContentHorizontalAlignment)parseHorizontalAlignmentWithKeys:(NSArray *)keys defaultValue:(UIControlContentHorizontalAlignment)defaultValue;

- (UIControlContentVerticalAlignment)parseVerticalAlignmentWithKeys:(NSArray *)keys;
- (UIControlContentVerticalAlignment)parseVerticalAlignmentWithKeys:(NSArray *)keys defaultValue:(UIControlContentVerticalAlignment)defaultValue;

- (UILineBreakMode)parseLineBreakModeWithKeys:(NSArray *)keys;
- (UILineBreakMode)parseLineBreakModeWithKeys:(NSArray *)keys defaultValue:(UILineBreakMode)defaultValue;

- (UIReturnKeyType)parseReturnKeyTypeWithKeys:(NSArray *)keys;
- (UIReturnKeyType)parseReturnKeyTypeWithKeys:(NSArray *)keys defaultValue:(UIReturnKeyType)defaultValue;

- (UIKeyboardType)parseKeyboardTypeWithKeys:(NSArray *)keys;
- (UIKeyboardType)parseKeyboardTypeWithKeys:(NSArray *)keys defaultValue:(UIKeyboardType)defaultValue;

- (UITextAutocapitalizationType)parseAutocapitalizationTypeWithKeys:(NSArray *)keys;
- (UITextAutocapitalizationType)parseAutocapitalizationTypeWithKeys:(NSArray *)keys defaultValue:(UITextAutocapitalizationType)defaultValue;

- (UITextAutocorrectionType)parseAutocorrectionTypeWithKeys:(NSArray *)keys;
- (UITextAutocorrectionType)parseAutocorrectionTypeWithKeys:(NSArray *)keys defaultValue:(UITextAutocorrectionType)defaultValue;

- (UITextFieldViewMode)parseTextFieldViewModeWithKeys:(NSArray *)keys;
- (UITextFieldViewMode)parseTextFieldViewModeWithKeys:(NSArray *)keys defaultValue:(UITextFieldViewMode)defaultValue;

- (UITextBorderStyle)parseTextBorderStyleWithKeys:(NSArray *)keys;
- (UITextBorderStyle)parseTextBorderStyleWithKeys:(NSArray *)keys defaultValue:(UITextBorderStyle)defaultValue;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "UITextField+BeeUIStyle.h"
#import "UIImage+BeeExtension.h"
#import "UIColor+BeeExtension.h"
#import "UIFont+BeeExtension.h"

#import "Bee_UIStyleParser.h"

#pragma mark -

@implementation UITextField(BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

#pragma mark -

- (void)applyInputContent:(NSMutableDictionary *)properties
{
	self.font = [properties parseFontWithDefaultValue:[UIFont systemFontOfSize:12.0f]];
	self.textColor = [properties parseColorWithKeys:@[@"color", @"text-color"] defaultValue:[UIColor blackColor]];
	self.textAlignment = [properties parseTextAlignmentWithKeys:@[@"text-align"] defaultValue:UITextAlignmentLeft];
}

- (void)applyInputKeyboard:(NSMutableDictionary *)properties
{
	self.returnKeyType = [properties parseReturnKeyTypeWithKeys:@[@"return", @"input-return", @"return-key", @"input-return-key"] defaultValue:UIReturnKeyDefault];
	self.keyboardType = [properties parseKeyboardTypeWithKeys:@[@"keyboard", @"input-keyboard"] defaultValue:UIKeyboardTypeDefault];
}

- (void)applyInputValue:(NSMutableDictionary *)properties
{
	self.text = [properties parseTextWithKeys:@[@"text"] defaultValue:self.text];
	self.placeholder = [properties parseTextWithKeys:@[@"placeholder", @"input-placeholder"] defaultValue:self.placeholder];
	self.enabled = [properties parseBoolWithKeys:@[@"disabled"] defaultValue:NO] ? NO : YES;
	self.userInteractionEnabled = [properties parseBoolWithKeys:@[@"readonly"] defaultValue:NO] ? NO : YES;
    
	NSInteger maxLength = [properties parseIntegerWithKeys:@[@"maxlength", @"input-max-length"] defaultValue:0];

	if ( [self respondsToSelector:@selector(setMaxLength:)] )
	{
        [(BeeUITextField *)self setMaxLength:maxLength];
	}
}

#pragma mark -

- (void)applyInputCorrection:(NSMutableDictionary *)properties
{
	self.autocapitalizationType = [properties parseAutocapitalizationTypeWithKeys:@[@"capital", @"input-capitalization"] defaultValue:UITextAutocapitalizationTypeNone];
	self.autocorrectionType = [properties parseAutocorrectionTypeWithKeys:@[@"correction", @"input-correction"] defaultValue:UITextAutocorrectionTypeDefault];
	self.clearButtonMode = [properties parseTextFieldViewModeWithKeys:@[@"clear", @"input-clear"] defaultValue:UITextFieldViewModeWhileEditing];
}

- (void)applyInputAppearance:(NSMutableDictionary *)properties
{
	self.secureTextEntry = [properties parseBoolWithKeys:@[@"secure", @"input-secure"] defaultValue:NO];
	self.borderStyle = [properties parseTextBorderStyleWithKeys:@[@"border-style", @"input-border", @"input-border-style"] defaultValue:UITextBorderStyleNone];
}

#pragma mark -

- (void)applyUIStyling:(NSDictionary *)properties
{
	NSMutableDictionary * propertiesCopy = [NSMutableDictionary dictionaryWithDictionary:properties];

	[self applyInputContent:propertiesCopy];
	[self applyInputKeyboard:propertiesCopy];
	[self applyInputValue:propertiesCopy];
	[self applyInputCorrection:propertiesCopy];
	[self applyInputAppearance:propertiesCopy];

    [super applyUIStyling:propertiesCopy];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

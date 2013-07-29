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

#import "UITextField+BeeUIStyle.h"

#pragma mark -

@implementation UITextField(BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

- (void)resetUIStyleProperties
{
	[super resetUIStyleProperties];
}

#pragma mark -

- (void)setInputKeyboardProperties:(NSDictionary *)properties
{
	NSString * returnType = [properties stringOfAny:@[@"input-return-key", @"input-return-key-type"]];
    if ( returnType )
    {
		if ( [returnType matchAnyOf:@[@"done"]] )
        {
            [self setReturnKeyType:UIReturnKeyDone];
        }
        else if ( [returnType matchAnyOf:@[@"search"]] )
        {
            [self setReturnKeyType:UIReturnKeySearch];
        }
        else if ( [returnType matchAnyOf:@[@"join"]] )
        {
            [self setReturnKeyType:UIReturnKeyJoin];
        }
        else if ( [returnType matchAnyOf:@[@"send"]] )
        {
            [self setReturnKeyType:UIReturnKeySend];
        }
        else if ( [returnType matchAnyOf:@[@"next"]] )
        {
            [self setReturnKeyType:UIReturnKeyNext];
        }
        else if ( [returnType matchAnyOf:@[@"go"]] )
        {
            [self setReturnKeyType:UIReturnKeyGo];
        }
		else // if ( [returnType matchAnyOf:@[@"default"]] )
        {
            [self setReturnKeyType:UIReturnKeyDefault];
        }
    }
	
    NSString * keyboardType = [properties stringOfAny:@[@"input-keyboard", @"input-method", @"input-keyboard-type"]];
    if ( keyboardType )
    {
		if ( [keyboardType matchAnyOf:@[@"ascii", @"abc"]] )
        {
			[self setKeyboardType:UIKeyboardTypeASCIICapable];
		}
        else if ( [keyboardType matchAnyOf:@[@"number", @"123"]] )
        {
			[self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
		}
        else if ( [keyboardType matchAnyOf:@[@"pin"]] )
        {
			[self setKeyboardType:UIKeyboardTypeNumberPad];
		}
        else if ( [keyboardType matchAnyOf:@[@"phone"]] )
        {
			[self setKeyboardType:UIKeyboardTypePhonePad];
		}
        else if ( [keyboardType matchAnyOf:@[@"contact"]] )
        {
			[self setKeyboardType:UIKeyboardTypeNamePhonePad];
		}
        else if ( [keyboardType matchAnyOf:@[@"email"]] )
        {
			[self setKeyboardType:UIKeyboardTypeEmailAddress];
		}
		else // if ( [keyboardType matchAnyOf:@[@"default"]] )
		{
			[self setKeyboardType:UIKeyboardTypeDefault];
		}
	}
}

#pragma mark -

- (void)setInputValueProperties:(NSDictionary *)properties
{
    NSString * placeholder = [properties stringOfAny:@[@"text", @"input-default", @"input-placeholder"]];
    if ( placeholder && placeholder.length )
    {
        [self setPlaceholder:placeholder];
    }

	NSString * maxLength = [properties stringOfAny:@[@"maxlength", @"input-max-length"]];
	if ( maxLength && maxLength.integerValue > 0 )
	{
		if ( [self respondsToSelector:@selector(setMaxLength:)] )
		{
			objc_msgSend( self, @selector(setMaxLength:), maxLength.integerValue );
		}
	}

	NSString * textAlignment = [properties stringOfAny:@[@"align", @"text-align"]];
	if ( textAlignment )
	{
		textAlignment = textAlignment.trim;
		if ( textAlignment.length )
		{
			self.textAlignment = UITextAlignmentFromString( textAlignment );
		}
	}
	
	NSString * disabled = [properties stringOfAny:@[@"disabled"]];
    if ( disabled && disabled.length )
    {
		[self setEnabled:NO];
    }
	
    NSString * readonly = [properties stringOfAny:@[@"readonly"]];
    if ( readonly && readonly.length )
    {
		[self setEnabled:NO];
    }
}

#pragma mark -

- (void)setInputCorrectionProperties:(NSDictionary *)properties
{
	NSString * capType = [properties stringOfAny:@[@"input-capitalization"]];
    if ( capType )
    {
        if ( [capType matchAnyOf:@[@"chars", @"characters"]] )
        {
			[self setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
		}
        else if ( [capType matchAnyOf:@[@"words"]] )
        {
			[self setAutocapitalizationType:UITextAutocapitalizationTypeWords];
		}
        else if ( [capType matchAnyOf:@[@"sentences"]] )
        {
			[self setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
		}
        else if ( [capType matchAnyOf:@[@"none"]] )
        {
			[self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		}
	}

    NSString * corType = [properties stringOfAny:@[@"input-correction"]];
    if ( corType )
    {
        if ( [corType matchAnyOf:@[@"true", @"yes"]] )
        {
			[self setAutocorrectionType:UITextAutocorrectionTypeYes];
		}
        else if ( [corType matchAnyOf:@[@"false", @"no"]] )
        {
			[self setAutocorrectionType:UITextAutocorrectionTypeNo];
		}
        else if ( [corType matchAnyOf:@[@"default"]] )
        {
			[self setAutocorrectionType:UITextAutocorrectionTypeDefault];
		}
	}
	
	NSString * clearMode = [properties stringOfAny:@[@"input-clear"]];
    if ( clearMode )
    {
		if ( [clearMode matchAnyOf:@[@"never"]] )
		{
			self.clearButtonMode = UITextFieldViewModeNever;
		}
		else if ( [clearMode matchAnyOf:@[@"editing", @"while-editing"]] )
		{
			self.clearButtonMode = UITextFieldViewModeWhileEditing;
		}
		else if ( [clearMode matchAnyOf:@[@"not-editing", @"unless-editing"]] )
		{
			self.clearButtonMode = UITextFieldViewModeUnlessEditing;
		}
		else if ( [clearMode matchAnyOf:@[@"always"]] )
		{
			self.clearButtonMode = UITextFieldViewModeAlways;
		}
	}
}

#pragma mark -

- (void)setInputAppearanceProperties:(NSDictionary *)properties
{
    NSString * secure = [properties stringOfAny:@[@"input-secure"]];
    if ( secure )
    {
		if ( [secure matchAnyOf:@[@"true", @"yes"]] )
        {
			[self setSecureTextEntry:YES];
		}
		else
		{
			[self setSecureTextEntry:NO];
		}
	}

    NSString * borderStyle = [properties stringOfAny:@[@"input-border", @"input-border-style"]];
    if ( borderStyle )
    {
        if ( [borderStyle matchAnyOf:@[@"line"]] )
        {
            [self setBorderStyle:UITextBorderStyleLine];
        }
        else if ( [borderStyle matchAnyOf:@[@"bezel"]] )
        {
            [self setBorderStyle:UITextBorderStyleBezel];
        }
        else if ( [borderStyle matchAnyOf:@[@"round", @"rounded", @"rounded-rect"]] )
        {
            [self setBorderStyle:UITextBorderStyleRoundedRect];
        }
        else // if ( [borderStyle matchAnyOf:@[@"none"]] )
        {
            [self setBorderStyle:UITextBorderStyleNone];
        }
    }
}

#pragma mark -

- (void)applyUIStyleProperties:(NSDictionary *)properties
{
    [super applyUIStyleProperties:properties];

	[self setInputKeyboardProperties:properties];
	[self setInputValueProperties:properties];
	[self setInputCorrectionProperties:properties];
	[self setInputAppearanceProperties:properties];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

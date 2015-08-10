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

#import "UITextView+BeeUIStyle.h"
#import "UIImage+BeeExtension.h"
#import "UIColor+BeeExtension.h"
#import "UIFont+BeeExtension.h"

#import "Bee_UIStyleParser.h"

#pragma mark -

@implementation UITextView (BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

- (void)applyInputContent:(NSMutableDictionary *)properties
{
	self.font = [properties parseFontWithDefaultValue:self.font];
	self.textColor = [properties parseColorWithKeys:@[@"color", @"text-color"] defaultValue:[UIColor blackColor]];
	self.textAlignment = [properties parseTextAlignmentWithKeys:@[@"text-align"] defaultValue:UITextAlignmentLeft];
	self.contentMode = [properties parseContentModeWithKeys:@[@"text-valign", @"text-v-align", @"text-vertical-align"] defaultValue:UIViewContentModeCenter];
}

- (void)applyInputValue:(NSMutableDictionary *)properties
{
	self.text = [properties parseTextWithKeys:@[@"text"] defaultValue:self.text];
	self.userInteractionEnabled = [properties parseBoolWithKeys:@[@"disabled"] defaultValue:NO] ? NO : YES;
	self.editable = [properties parseBoolWithKeys:@[@"readonly"] defaultValue:YES] ? NO : YES;

	if ( [self respondsToSelector:@selector(setPlaceholder:)] )
	{
		NSString * defaultPlaceholder = [self performSelector:@selector(placeholder)];
		NSString * placeholder = [properties parseTextWithKeys:@[@"placeholder", @"input-placeholder"] defaultValue:defaultPlaceholder];
        [(BeeUITextView *)self setPlaceholder:placeholder];
	}

	NSInteger maxLength = [properties parseIntegerWithKeys:@[@"maxlength", @"input-max-length"] defaultValue:0];
	if ( [self respondsToSelector:@selector(setMaxLength:)] )
	{
        [(BeeUITextView *)self setMaxLength:maxLength];
	}
}

- (void)applyUIStyling:(NSDictionary *)properties
{
	NSMutableDictionary * propertiesCopy = [NSMutableDictionary dictionaryWithDictionary:properties];

	[self applyInputContent:propertiesCopy];
	[self applyInputValue:propertiesCopy];
	
    [super applyUIStyling:propertiesCopy];
}

@end

#endif	 // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

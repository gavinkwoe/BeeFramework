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

#import "UILabel+BeeUIStyle.h"
#import "UIImage+BeeExtension.h"
#import "UIColor+BeeExtension.h"
#import "UIFont+BeeExtension.h"

#import "Bee_UIStyleParser.h"

#pragma mark -

@implementation UILabel(BeeUIStyle)

+ (BOOL)supportForUIStyling
{
	return YES;
}

#pragma mark -

- (void)applyLabelContent:(NSMutableDictionary *)properties
{
	self.font = [properties parseFontWithDefaultValue:[UIFont systemFontOfSize:12.0f]];
	self.text = [properties parseTextWithKeys:@[@"text", @"content"] defaultValue:self.text];
	self.textColor = [properties parseColorWithKeys:@[@"color", @"text-color"] defaultValue:[UIColor blackColor]];
	self.textAlignment = [properties parseTextAlignmentWithKeys:@[@"text-align"] defaultValue:UITextAlignmentLeft];
	self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	self.contentMode = [properties parseContentModeWithKeys:@[@"text-valign", @"text-v-align", @"text-vertical-align"] defaultValue:UIViewContentModeCenter];
	self.lineBreakMode = [properties parseLineBreakModeWithKeys:@[@"line-break"] defaultValue:UILineBreakModeTailTruncation];
	self.numberOfLines = [properties parseIntegerWithKeys:@[@"line-num"] defaultValue:self.numberOfLines];
    self.adjustsFontSizeToFitWidth = [properties parseBoolWithKeys:@[@"fit-width"] defaultValue:NO];

	NSString * textShadow = [properties parseStringWithKeys:@[@"text-shadow"]];
	if ( textShadow )
	{
		NSArray * components = [textShadow componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ( components && components.count == 4 )
		{
			CGFloat offsetX = [((NSString *)[components objectAtIndex:0]).trim floatValue];
			CGFloat offsetY = [((NSString *)[components objectAtIndex:1]).trim floatValue];
//			CGFloat radius = [((NSString *)[components objectAtIndex:2]).trim floatValue];
			UIColor * color = [UIColor colorWithString:[components objectAtIndex:3]];
			
			self.shadowColor = color ? color : [UIColor blackColor];
			self.shadowOffset = CGSizeMake( offsetX, offsetY );
		}
	}

	NSString * wordWrap = [properties parseStringWithKeys:@[@"word-wrap"]];
	if ( wordWrap )
	{
		if ( [wordWrap matchAnyOf:@[@"normal"]] )
		{
			self.numberOfLines = 999999;
			self.lineBreakMode = UILineBreakModeClip;
		}
		else if ( [wordWrap matchAnyOf:@[@"break-word"]] )
		{
			self.numberOfLines = 999999;
			self.lineBreakMode = UILineBreakModeWordWrap;
		}
	}

	NSString * textOverflow = [properties parseStringWithKeys:@[@"text-overflow"]];
	if ( textOverflow )
	{
		if ( [textOverflow matchAnyOf:@[@"clip"]] )
		{
			self.lineBreakMode = UILineBreakModeClip;
		}
		else if ( [textOverflow matchAnyOf:@[@"ellipsis"]] )
		{
			self.lineBreakMode = UILineBreakModeTailTruncation;
		}
	}
}

- (void)applyUIStyling:(NSDictionary *)properties
{
	NSMutableDictionary * propertiesCopy = [NSMutableDictionary dictionaryWithDictionary:properties];
	[self applyLabelContent:propertiesCopy];
    [super applyUIStyling:propertiesCopy];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

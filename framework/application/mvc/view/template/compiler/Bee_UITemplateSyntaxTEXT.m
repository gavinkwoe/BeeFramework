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

#import "Bee_UITemplateSyntaxTEXT.h"

#pragma mark -

#define	DEFAULT_DELIMITER_1		@"{{"
#define	DEFAULT_DELIMITER_2		@"}}"

#pragma mark -

@implementation ASTNodeTEXT

- (NSString *)renderInContext:(BeeUITemplateContext *)context
{
	NSMutableString * renderedText = [NSMutableString string];
	
	NSUInteger	offset = 0;
	NSString *	delimiter1 = DEFAULT_DELIMITER_1;
	NSString *	delimiter2 = DEFAULT_DELIMITER_2;

	for ( ;; )
	{
		if ( offset >= self.source.length )
			break;

		NSRange remainRange = NSMakeRange( offset, self.source.length - offset );
		NSRange delimiterRange1 = [self.source rangeOfString:delimiter1 options:NSCaseInsensitiveSearch range:remainRange];
		NSRange delimiterRange2 = [self.source rangeOfString:delimiter2 options:NSCaseInsensitiveSearch range:remainRange];

		if ( delimiterRange1.length && delimiterRange2.length )
		{
			NSUInteger diffLength = delimiterRange1.location - offset;
			if ( diffLength > 0 )
			{
				NSRange		segmentRange = NSMakeRange( offset, diffLength );
				NSString *	segmentText = [self.source substringWithRange:segmentRange];
				
				if ( segmentText.length )
				{
					[renderedText appendString:segmentText];
				}
			}

			NSRange fullRange = NSMakeRange( delimiterRange1.location, delimiterRange2.location + delimiterRange2.length - delimiterRange1.location );
			NSRange innerRange = NSMakeRange( delimiterRange1.location + delimiterRange1.length, delimiterRange2.location - (delimiterRange1.location + delimiterRange1.length) );

			if ( innerRange.length )
			{
				NSString * innerString = [self.source substringWithRange:innerRange].trim;
				NSString * stringValue = [[context.values objectForKey:innerString] asNSString];
				
				if ( stringValue && stringValue.length )
				{
					[renderedText appendString:stringValue];
				}
			}

			offset = fullRange.location + fullRange.length;
		}
		else
		{
			NSString * segmentText = [self.source substringWithRange:remainRange];
			if ( segmentText && segmentText.length )
			{
				[renderedText appendString:segmentText];	
			}

			offset = remainRange.location + remainRange.length;
		}
	}

	return renderedText;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

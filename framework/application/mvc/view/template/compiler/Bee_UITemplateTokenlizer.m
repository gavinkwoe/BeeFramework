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

#import "Bee_UITemplateTokenlizer.h"

#pragma mark -

#define	DEFAULT_DELIMITER_1		@"<!--{{"
#define	DEFAULT_DELIMITER_2		@"}}-->"

#pragma mark -

@interface BeeUITemplateTokenlizer()
{
	NSString *				_delimiter1;
	NSString *				_delimiter2;

	NSString *				_source;
	NSUInteger				_offset;

	NSUInteger				_tokenType;
	NSRange					_tokenRange;
	NSRange					_tokenInnerRange;

	NSUInteger				_errorCode;
	NSString *				_errorDesc;
}
@end

#pragma mark -

@implementation BeeUITemplateTokenlizer

@synthesize delimiter1 = _delimiter1;
@synthesize delimiter2 = _delimiter2;

@synthesize source = _source;
@synthesize offset = _offset;

@synthesize tokenType = _tokenType;
@synthesize tokenRange = _tokenRange;
@synthesize tokenInnerRange = _tokenInnerRange;
@dynamic tokenString;
@dynamic tokenInnerString;

@synthesize errorCode = _errorCode;
@synthesize errorDesc = _errorDesc;

DEF_INT( TOKEN_EOF,		0 )
DEF_INT( TOKEN_TEXT,	1 )
DEF_INT( TOKEN_IF,		2 )
DEF_INT( TOKEN_FOR,		3 )
DEF_INT( TOKEN_END,		4 )
DEF_INT( TOKEN_EXPR,	5 )

DEF_INT( ERROR_OK,		0 )
DEF_INT( ERROR_FORMAT,	1 )

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self reset];
	}
	return self;
}

- (void)dealloc
{
	self.delimiter1 = nil;
	self.delimiter2 = nil;
	
	self.source = nil;
	self.errorDesc = nil;

	[super dealloc];
}

- (NSString *)tokenString
{
	if ( nil == self.source )
		return nil;

	return [self.source substringWithRange:self.tokenRange];
}

#pragma mark -

- (void)reset
{
	self.delimiter1 = DEFAULT_DELIMITER_1;
	self.delimiter2 = DEFAULT_DELIMITER_2;

	self.source = nil;
	self.offset = 0;

	self.tokenType = self.TOKEN_EOF;
	self.tokenRange = NSMakeRange( 0, 0 );
	self.tokenInnerRange = NSMakeRange( 0, 0 );

	self.errorCode = self.ERROR_OK;
	self.errorDesc = @"";
}

- (BOOL)nextToken
{
	if ( self.offset >= self.source.length )
	{
		self.tokenType = self.TOKEN_EOF;
		self.tokenRange = NSMakeRange( 0, 0 );
		self.tokenInnerRange = NSMakeRange( 0, 0 );
		return NO;
	}

	NSRange remainRange = NSMakeRange( self.offset, self.source.length - self.offset );
	NSRange delimiterRange1 = [self.source rangeOfString:self.delimiter1 options:NSCaseInsensitiveSearch range:remainRange];
	NSRange delimiterRange2 = [self.source rangeOfString:self.delimiter2 options:NSCaseInsensitiveSearch range:remainRange];

	if ( delimiterRange1.length && delimiterRange2.length )
	{
		NSUInteger diffLength = delimiterRange1.location - self.offset;
		if ( diffLength > 0 )
		{
			self.tokenType = self.TOKEN_TEXT;
			self.tokenRange = NSMakeRange( self.offset, diffLength );
			self.tokenInnerRange = self.tokenRange;
		}
		else
		{
			self.tokenRange = NSMakeRange( delimiterRange1.location, delimiterRange2.location + delimiterRange2.length - delimiterRange1.location );
			self.tokenInnerRange = NSMakeRange( delimiterRange1.location + delimiterRange1.length, delimiterRange2.location - (delimiterRange1.location + delimiterRange1.length) );
			
			NSString * innerString = [self.source substringWithRange:self.tokenInnerRange].trim;
			if ( [innerString hasPrefix:@"if"] )
			{
				self.tokenType = self.TOKEN_IF;
			}
			else if ( [innerString hasPrefix:@"for"] )
			{
				self.tokenType = self.TOKEN_FOR;
			}
			else if ( [innerString hasPrefix:@"for"] )
			{
				self.tokenType = self.TOKEN_FOR;
			}
			else if ( [innerString hasPrefix:@"end"] )
			{
				self.tokenType = self.TOKEN_FOR;
			}
			else
			{
				self.tokenType = self.TOKEN_EXPR;
			}	
		}
	}
	else
	{
		self.tokenType = self.TOKEN_TEXT;
		self.tokenRange = remainRange;
		self.tokenInnerRange = self.tokenRange;
	}

	self.offset = self.tokenRange.location + self.tokenRange.length;
	return YES;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

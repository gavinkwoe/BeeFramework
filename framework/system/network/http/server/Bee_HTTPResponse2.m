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

#import "Bee_HTTPResponse2.h"

#pragma mark -

@implementation BeeHTTPResponse2

@synthesize version = _version;
@synthesize status = _status;
@synthesize statusMessage = _statusMessage;

DEF_HTTP_HEADER( AcceptRanges,			@"Accept-Ranges" )			// Accept-Ranges: bytes
DEF_HTTP_HEADER( Age,					@"Age" )					// Age: 12
DEF_HTTP_HEADER( Allow,					@"Allow" )					// Allow: GET, HEAD
DEF_HTTP_HEADER( CacheControl,			@"Cache-Control" )			// Cache-Control: no-cache
DEF_HTTP_HEADER( Connection,			@"Connection" )				// Connection: close
DEF_HTTP_HEADER( ContentEncoding,		@"Content-Encoding" )		// Content-Encoding: gzip
DEF_HTTP_HEADER( ContentLanguage,		@"Content-Language" )		// Content-Language: en,zh
DEF_HTTP_HEADER( ContentLength,			@"Content-Length" )			// Content-Length: 348
DEF_HTTP_HEADER( ContentLocation,		@"Content-Location" )		// Content-Location: /index.htm
DEF_HTTP_HEADER( ContentMD5,			@"Content-MD5" )			// Content-MD5: Q2hlY2sgSW50ZWdyaXR5IQ==
DEF_HTTP_HEADER( ContentRange,			@"Content-Range" )			// Content-Range: bytes 21010-47021/47022
DEF_HTTP_HEADER( ContentType,			@"Content-Type" )			// Content-Type: text/html; charset=utf-8
DEF_HTTP_HEADER( Date,					@"Date" )					// Date: Tue, 15 Nov 2010 08:12:31 GMT
DEF_HTTP_HEADER( ETag,					@"ETag" )					// ETag: “737060cd8c284d8af7ad3082f209582d”
DEF_HTTP_HEADER( Expires,				@"Expires" )				// Expires: Thu, 01 Dec 2010 16:00:00 GMT
DEF_HTTP_HEADER( LastModified,			@"Last-Modified" )			// Last-Modified: Tue, 15 Nov 2010 12:45:26 GMT
DEF_HTTP_HEADER( Location,				@"Location" )				// Location: http://www.zcmhi.com/archives/94.html
DEF_HTTP_HEADER( Pragma,				@"Pragma" )					// Pragma: no-cache
DEF_HTTP_HEADER( ProxyAuthenticate,		@"Proxy-Authenticate" )		// Proxy-Authenticate: Basic
DEF_HTTP_HEADER( Refresh,				@"Refresh" )				// Refresh: 5; url=http://www.zcmhi.com/archives/94.html
DEF_HTTP_HEADER( RetryAfter,			@"Retry-After" )			// Retry-After: 120
DEF_HTTP_HEADER( Server,				@"Server" )					// Server: Apache/1.3.27 (Unix) (Red-Hat/Linux)
DEF_HTTP_HEADER( SetCookie,				@"Set-Cookie" )				// Set-Cookie: UserID=JohnDoe; Max-Age=3600; Version=1
DEF_HTTP_HEADER( Trailer,				@"Trailer" )				// Trailer: Max-Forwards
DEF_HTTP_HEADER( TransferEncoding,		@"Transfer-Encoding" )		// Transfer-Encoding:chunked
DEF_HTTP_HEADER( Vary,					@"Vary" )					// Vary: *
DEF_HTTP_HEADER( Via,					@"Via" )					// Via: 1.0 fred, 1.1 nowhere.com (Apache/1.1)
DEF_HTTP_HEADER( Warning,				@"Warning" )				// Warning: 199 Miscellaneous warning
DEF_HTTP_HEADER( WWWAuthenticate,		@"WWW-Authenticate" )		// WWW-Authenticate: Basic

+ (BeeHTTPResponse2 *)response
{
	return [[[BeeHTTPResponse2 alloc] init] autorelease];
}

+ (BeeHTTPResponse2 *)response:(NSData *)data
{
	BeeHTTPResponse2 * resp = [[[BeeHTTPResponse2 alloc] init] autorelease];
	if ( resp )
	{
		BOOL succeed = [resp unpack:data];
		if ( succeed )
		{
			return resp;
		}
	}

	return nil;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.status = BeeHTTPStatus_OK;
		self.Server = BEE_SERVER_NAME;
		self.Date = [[NSDate date] description];
		self.Connection = @"close";
		self.ContentType = @"text/html; charset=UTF-8";

//		self.Pragma = @"no-cache";
//		self.CacheControl = @"no-cache";
//		self.ContentEncoding = nil;	// gzip
//		self.ContentLanguage = @"en";
	}
	return self;
}

- (NSString *)packHead
{
	NSMutableString * headLine = [NSMutableString string];

	if ( BeeHTTPVersion_11 == self.version )
	{
		[headLine appendString:@"HTTP/1.1"];
	}
	else if ( BeeHTTPVersion_10 == self.version )
	{
		[headLine appendString:@"HTTP/1.0"];
	}
	else if ( BeeHTTPVersion_9 == self.version )
	{
		[headLine appendString:@"HTTP/0.9"];
	}
	else
	{
		return nil;
	}
	
	[headLine appendString:@" "];
	[headLine appendFormat:@"%d", self.status];
	[headLine appendString:@" "];
	[headLine appendString:[BeeHTTPProtocol2 statusMessage:self.status]];

	return headLine;
}

- (NSData *)packBody
{
	return self.bodyData;
}

- (BOOL)unpackHead:(NSString *)text
{
	if ( nil == text || 0 == text.length )
		return NO;

	NSCharacterSet *	eolCharset = [NSCharacterSet characterSetWithCharactersInString:@"\r\n"];
	NSCharacterSet *	whiteSpace = [NSCharacterSet whitespaceCharacterSet];
	NSUInteger			offset = 0;

	NSString * version = [text substringFromIndex:offset untilCharset:whiteSpace endOffset:&offset].trim;
	NSString * status = [text substringFromIndex:offset untilCharset:whiteSpace endOffset:&offset].trim;
	NSString * message = [text substringFromIndex:offset untilCharset:eolCharset].trim;

	if ( NSOrderedSame == [version compare:@"HTTP/1.1" options:NSCaseInsensitiveSearch] )
	{
		self.version = BeeHTTPVersion_11;
	}
	else if ( NSOrderedSame == [version compare:@"HTTP/1.0" options:NSCaseInsensitiveSearch] )
	{
		self.version = BeeHTTPVersion_10;
	}
	else if ( NSOrderedSame == [version compare:@"HTTP/0.9" options:NSCaseInsensitiveSearch] )
	{
		self.version = BeeHTTPVersion_9;
	}
	else
	{
		self.version = BeeHTTPVersion_UNKNOWN;
	}

	self.status = (BeeHTTPStatus)status.integerValue;
	self.statusMessage = message;

	return YES;
}

- (BOOL)unpackBody:(NSData *)text
{
	return YES;
}

@end

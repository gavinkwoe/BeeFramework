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

#import "Bee_HTTPRequest2.h"
#import "Bee_HTTPResponse2.h"

#pragma mark -

@interface BeeHTTPRequest2()
- (BOOL)checkIntegrity:(NSData *)data;
@end

#pragma mark -

@implementation BeeHTTPRequest2

@synthesize version = _version;
@synthesize method = _method;
@synthesize resource = _resource;

@synthesize params = _params;
@synthesize files = _files;

DEF_HTTP_HEADER( Accept,				@"Accept" )					// Accept: text/plain, text/html
DEF_HTTP_HEADER( AcceptCharset,			@"Accept-Charset" )			// Accept-Charset: iso-8859-5
DEF_HTTP_HEADER( AcceptEncoding,		@"Accept-Encoding" )		// Accept-Encoding: compress, gzip
DEF_HTTP_HEADER( AcceptLanguage,		@"Accept-Language" )		// Accept-Language: en,zh
DEF_HTTP_HEADER( AcceptRanges,			@"Accept-Ranges" )			// Accept-Ranges: bytes
DEF_HTTP_HEADER( Authorization,			@"Authorization" )			// Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
DEF_HTTP_HEADER( CacheControl,			@"Cache-Control" )			// Cache-Control: no-cache
DEF_HTTP_HEADER( Connection,			@"Connection" )				// Connection: close
DEF_HTTP_HEADER( Cookie,				@"Cookie" )					// Cookie: $Version=1; Skin=new;
DEF_HTTP_HEADER( ContentLength,			@"Content-Length" )			// Content-Length: 348
DEF_HTTP_HEADER( ContentType,			@"Content-Type" )			// Content-Type: application/x-www-form-urlencoded
DEF_HTTP_HEADER( Date,					@"Date" )					// Date: Tue, 15 Nov 2010 08:12:31 GMT
DEF_HTTP_HEADER( Expect,				@"Expect" )					// Expect: 100-continue
DEF_HTTP_HEADER( From,					@"From" )					// From: user@email.com
DEF_HTTP_HEADER( Host,					@"Host" )					// Host: www.zcmhi.com
DEF_HTTP_HEADER( IfMatch,				@"If-Match" )				// If-Match: “737060cd8c284d8af7ad3082f209582d”
DEF_HTTP_HEADER( IfModifiedSince,		@"If-Modified-Since" )		// If-Modified-Since: Sat, 29 Oct 2010 19:43:31 GMT
DEF_HTTP_HEADER( IfNoneMatch,			@"If-None-Match" )			// If-None-Match: “737060cd8c284d8af7ad3082f209582d”
DEF_HTTP_HEADER( IfRange,				@"If-Range" )				// If-Range: “737060cd8c284d8af7ad3082f209582d”
DEF_HTTP_HEADER( IfUnmodifiedSince,		@"If-Unmodified-Since" )	// If-Unmodified-Since: Sat, 29 Oct 2010 19:43:31 GMT
DEF_HTTP_HEADER( MaxForwards,			@"Max-Forwards" )			// Max-Forwards: 10
DEF_HTTP_HEADER( Pragma,				@"Pragma" )					// Pragma: no-cache
DEF_HTTP_HEADER( ProxyAuthorization,	@"Proxy-Authorization" )	// Proxy-Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
DEF_HTTP_HEADER( Range,					@"Range" )					// Range: bytes=500-999
DEF_HTTP_HEADER( Referer,				@"Referer" )				// Referer: http://www.zcmhi.com/archives/71.html
DEF_HTTP_HEADER( TE,					@"TE" )						// TE: trailers,deflate;q=0.5
DEF_HTTP_HEADER( Upgrade,				@"Upgrade" )				// Upgrade: HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11
DEF_HTTP_HEADER( UserAgent,				@"User-Agent" )				// User-Agent: Mozilla/5.0 (Linux; X11)
DEF_HTTP_HEADER( Via,					@"Via" )					// Via: 1.0 fred, 1.1 nowhere.com (Apache/1.1)
DEF_HTTP_HEADER( Warning,				@"Warning" )				// Warn: 199 Miscellaneous warning

+ (BeeHTTPRequest2 *)request
{
	return [[[BeeHTTPRequest2 alloc] init] autorelease];
}

+ (BeeHTTPRequest2 *)request:(NSData *)data
{
	BeeHTTPRequest2 * req = [[[BeeHTTPRequest2 alloc] init] autorelease];
	if ( req )
	{
		BOOL succeed = [req checkIntegrity:data];
		if ( succeed )
		{
			return req;
		}
	}
	
	return nil;
}

- (BeeHTTPResponse2 *)response
{
	BeeHTTPResponse2 * response = [BeeHTTPResponse2 response];
	if ( response )
	{
		response.version = self.version;
		response.eol = self.eol;
		response.eol2 = self.eol2;
		response.eolValid = self.eolValid;
	}
	return response;
}

- (void)load
{
	self.params = [NSMutableDictionary dictionary];
	self.files = [NSMutableDictionary dictionary];
}

- (void)unload
{
	self.params = nil;
	self.files = nil;
}

- (NSString *)packHead
{
	NSMutableString * headLine = [NSMutableString string];
	
	if ( BeeHTTPMethod_GET == self.method )
	{
		[headLine appendString:@"GET"];
	}
	else if ( BeeHTTPMethod_HEAD == self.method )
	{
		[headLine appendString:@"HEAD"];
	}
	else if ( BeeHTTPMethod_POST == self.method )
	{
		[headLine appendString:@"POST"];
	}
	else if ( BeeHTTPMethod_PUT == self.method )
	{
		[headLine appendString:@"PUT"];
	}
	else if ( BeeHTTPMethod_DELETE == self.method )
	{
		[headLine appendString:@"DELETE"];
	}
	else
	{
		return nil;
	}
	
	[headLine appendString:@" "];
	[headLine appendString:self.resource];
	[headLine appendString:@" "];

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

	NSArray * components = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ( nil == components || 3 != components.count )
		return NO;
	
	NSString * method = [components objectAtIndex:0];
	NSString * resource = [components objectAtIndex:1];
	NSString * version = [components objectAtIndex:2];

	if ( NSOrderedSame == [method compare:@"GET" options:NSCaseInsensitiveSearch] )
	{
		self.method = BeeHTTPMethod_GET;
	}
	else if ( NSOrderedSame == [method compare:@"HEAD" options:NSCaseInsensitiveSearch] )
	{
		self.method = BeeHTTPMethod_HEAD;
	}
	else if ( NSOrderedSame == [method compare:@"POST" options:NSCaseInsensitiveSearch] )
	{
		self.method = BeeHTTPMethod_POST;
	}
	else if ( NSOrderedSame == [method compare:@"PUT" options:NSCaseInsensitiveSearch] )
	{
		self.method = BeeHTTPMethod_PUT;
	}
	else if ( NSOrderedSame == [method compare:@"DELETE" options:NSCaseInsensitiveSearch] )
	{
		self.method = BeeHTTPMethod_DELETE;
	}
	else
	{
		self.method = BeeHTTPMethod_UNKNOWN;
	}
	
	self.resource = resource;
	
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

	return YES;
}

- (BOOL)unpackBody:(NSData *)data
{
	return YES;
}

- (BOOL)checkIntegrity:(NSData *)data
{
	if ( nil == data || 0 == data.length )
		return NO;
	
	if ( NO == self.headValid )
	{
		BOOL flag = [self unpack:data includeBody:YES];
		if ( NO == flag )
		{
			return NO;
		}
	}

	if ( NO == self.headValid )
	{
		return NO;
	}
	
	if ( BeeHTTPMethod_GET == self.method )
	{
		return YES;
	}
	else if ( BeeHTTPMethod_HEAD == self.method )
	{
		return YES;
	}
	else if ( BeeHTTPMethod_POST == self.method )
	{
		if ( self.ContentLength )
		{
			NSUInteger remainLength = data.length - self.headLength;

			if ( remainLength >= self.ContentLength.integerValue )
			{
				return YES;
			}
			else
			{
				return NO;
			}
		}
		else
		{
			return YES;
		}
	}
	else if ( BeeHTTPMethod_PUT == self.method )
	{
		return YES;
	}
	else if ( BeeHTTPMethod_DELETE == self.method )
	{
		return YES;
	}

	return YES;
}

@end

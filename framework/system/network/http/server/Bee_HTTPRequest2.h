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
//	Hypertext Transfer Protocol -- HTTP/1.1
//	http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
//

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"
#import "Bee_HTTPProtocol2.h"

#pragma mark -

@class BeeHTTPResponse2;

@interface BeeHTTPRequest2 : BeeHTTPProtocol2

@property (nonatomic, assign) BeeHTTPVersion		version;
@property (nonatomic, assign) BeeHTTPMethod			method;
@property (nonatomic, retain) NSString *			resource;

@property (nonatomic, retain) NSMutableDictionary *	params;
@property (nonatomic, retain) NSMutableDictionary *	files;

AS_HTTP_HEADER( Accept )				// Accept: text/plain, text/html
AS_HTTP_HEADER( AcceptCharset )			// Accept-Charset: iso-8859-5
AS_HTTP_HEADER( AcceptEncoding )		// Accept-Encoding: compress, gzip
AS_HTTP_HEADER( AcceptLanguage )		// Accept-Language: en,zh
AS_HTTP_HEADER( AcceptRanges )			// Accept-Ranges: bytes
AS_HTTP_HEADER( Authorization )			// Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
AS_HTTP_HEADER( CacheControl )			// Cache-Control: no-cache
AS_HTTP_HEADER( Connection )			// Connection: close
AS_HTTP_HEADER( Cookie )				// Cookie: $Version=1; Skin=new;
AS_HTTP_HEADER( ContentLength )			// Content-Length: 348
AS_HTTP_HEADER( ContentType )			// Content-Type: application/x-www-form-urlencoded
AS_HTTP_HEADER( Date )					// Date: Tue, 15 Nov 2010 08:12:31 GMT
AS_HTTP_HEADER( Expect )				// Expect: 100-continue
AS_HTTP_HEADER( From )					// From: user@email.com
AS_HTTP_HEADER( Host )					// Host: www.zcmhi.com
AS_HTTP_HEADER( IfMatch )				// If-Match: “737060cd8c284d8af7ad3082f209582d”
AS_HTTP_HEADER( IfModifiedSince )		// If-Modified-Since: Sat, 29 Oct 2010 19:43:31 GMT
AS_HTTP_HEADER( IfNoneMatch )			// If-None-Match: “737060cd8c284d8af7ad3082f209582d”
AS_HTTP_HEADER( IfRange )				// If-Range: “737060cd8c284d8af7ad3082f209582d”
AS_HTTP_HEADER( IfUnmodifiedSince )		// If-Unmodified-Since: Sat, 29 Oct 2010 19:43:31 GMT
AS_HTTP_HEADER( MaxForwards )			// Max-Forwards: 10
AS_HTTP_HEADER( Pragma )				// Pragma: no-cache
AS_HTTP_HEADER( ProxyAuthorization )	// Proxy-Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
AS_HTTP_HEADER( Range )					// Range: bytes=500-999
AS_HTTP_HEADER( Referer )				// Referer: http://www.zcmhi.com/archives/71.html
AS_HTTP_HEADER( TE )					// TE: trailers,deflate;q=0.5
AS_HTTP_HEADER( Upgrade )				// Upgrade: HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11
AS_HTTP_HEADER( UserAgent )				// User-Agent: Mozilla/5.0 (Linux; X11)
AS_HTTP_HEADER( Via )					// Via: 1.0 fred, 1.1 nowhere.com (Apache/1.1)
AS_HTTP_HEADER( Warning )				// Warn: 199 Miscellaneous warning

+ (BeeHTTPRequest2 *)request;
+ (BeeHTTPRequest2 *)request:(NSData *)data;

- (BeeHTTPResponse2 *)response;

@end

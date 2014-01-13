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

#undef	BEE_SERVER_NAME
#define	BEE_SERVER_NAME		@"bhttpd"

#pragma mark -

@interface BeeHTTPResponse2 : BeeHTTPProtocol2

@property (nonatomic, assign) BeeHTTPVersion		version;
@property (nonatomic, assign) BeeHTTPStatus			status;
@property (nonatomic, retain) NSString *			statusMessage;

AS_HTTP_HEADER( AcceptRanges )			// Accept-Ranges: bytes
AS_HTTP_HEADER( Age )					// Age: 12
AS_HTTP_HEADER( Allow )					// Allow: GET, HEAD
AS_HTTP_HEADER( Connection )			// Connection: close
AS_HTTP_HEADER( CacheControl )			// Cache-Control: no-cache
AS_HTTP_HEADER( ContentEncoding )		// Content-Encoding: gzip
AS_HTTP_HEADER( ContentLanguage )		// Content-Language: en,zh
AS_HTTP_HEADER( ContentLength )			// Content-Length: 348
AS_HTTP_HEADER( ContentLocation )		// Content-Location: /index.htm
AS_HTTP_HEADER( ContentMD5 )			// Content-MD5: Q2hlY2sgSW50ZWdyaXR5IQ==
AS_HTTP_HEADER( ContentRange )			// Content-Range: bytes 21010-47021/47022
AS_HTTP_HEADER( ContentType )			// Content-Type: text/html; charset=utf-8
AS_HTTP_HEADER( Date )					// Date: Tue, 15 Nov 2010 08:12:31 GMT
AS_HTTP_HEADER( ETag )					// ETag: “737060cd8c284d8af7ad3082f209582d”
AS_HTTP_HEADER( Expires )				// Expires: Thu, 01 Dec 2010 16:00:00 GMT
AS_HTTP_HEADER( LastModified )			// Last-Modified: Tue, 15 Nov 2010 12:45:26 GMT
AS_HTTP_HEADER( Location )				// Location: http://www.zcmhi.com/archives/94.html
AS_HTTP_HEADER( Pragma )				// Pragma: no-cache
AS_HTTP_HEADER( ProxyAuthenticate )		// Proxy-Authenticate: Basic
AS_HTTP_HEADER( Refresh )				// Refresh: 5; url=http://www.zcmhi.com/archives/94.html
AS_HTTP_HEADER( RetryAfter )			// Retry-After: 120
AS_HTTP_HEADER( Server )				// Server: Apache/1.3.27 (Unix) (Red-Hat/Linux)
AS_HTTP_HEADER( SetCookie )				// Set-Cookie: UserID=JohnDoe; Max-Age=3600; Version=1
AS_HTTP_HEADER( Trailer )				// Trailer: Max-Forwards
AS_HTTP_HEADER( TransferEncoding )		// Transfer-Encoding:chunked
AS_HTTP_HEADER( Vary )					// Vary: *
AS_HTTP_HEADER( Via )					// Via: 1.0 fred, 1.1 nowhere.com (Apache/1.1)
AS_HTTP_HEADER( Warning )				// Warning: 199 Miscellaneous warning
AS_HTTP_HEADER( WWWAuthenticate )		// WWW-Authenticate: Basic

+ (BeeHTTPResponse2 *)response;
+ (BeeHTTPResponse2 *)response:(NSData *)data;

@end

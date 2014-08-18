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

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"

#import "Bee_HTTPRequest.h"
#import "Bee_HTTPRequestQueue.h"

#pragma mark -

@interface NSObject(BeeHTTPRequestResponder)

@property (nonatomic, readonly) BeeHTTPBoolBlockV		REQUESTING;
@property (nonatomic, readonly) BeeHTTPBoolBlockS		REQUESTING_URL;
@property (nonatomic, readonly) BeeHTTPBoolBlockV		CANCEL_REQUESTS;

@property (nonatomic, readonly) BeeHTTPRequestBlockSN	GET;
@property (nonatomic, readonly) BeeHTTPRequestBlockSN	PUT;
@property (nonatomic, readonly) BeeHTTPRequestBlockSN	POST;
@property (nonatomic, readonly) BeeHTTPRequestBlockSN	DELETE;

@property (nonatomic, readonly) BeeHTTPRequestBlockSN	HTTP_GET;
@property (nonatomic, readonly) BeeHTTPRequestBlockSN	HTTP_PUT;
@property (nonatomic, readonly) BeeHTTPRequestBlockSN	HTTP_POST;
@property (nonatomic, readonly) BeeHTTPRequestBlockSN	HTTP_DELETE;

- (BeeHTTPRequest *)GET:(NSString *)url;
- (BeeHTTPRequest *)PUT:(NSString *)url;
- (BeeHTTPRequest *)POST:(NSString *)url;
- (BeeHTTPRequest *)DELETE:(NSString *)url;

- (BeeHTTPRequest *)HTTP_GET:(NSString *)url;
- (BeeHTTPRequest *)HTTP_PUT:(NSString *)url;
- (BeeHTTPRequest *)HTTP_POST:(NSString *)url;
- (BeeHTTPRequest *)HTTP_DELETE:(NSString *)url;

- (BOOL)requestingURL;
- (BOOL)requestingURL:(NSString *)url;
- (BeeHTTPRequest *)request;
- (NSArray *)requests;
- (NSArray *)requests:(NSString *)url;
- (void)cancelRequests;

@end

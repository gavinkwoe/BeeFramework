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

#import "NSObject+BeeHTTPRequest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(BeeHTTPRequestResponder)

@dynamic REQUESTING;
@dynamic REQUESTING_URL;
@dynamic CANCEL_REQUESTS;

@dynamic GET;
@dynamic PUT;
@dynamic POST;
@dynamic DELETE;

@dynamic HTTP_GET;
@dynamic HTTP_PUT;
@dynamic HTTP_POST;
@dynamic HTTP_DELETE;

#pragma mark -

- (BeeHTTPRequest *)GET:(NSString *)url
{
	return [self HTTP_GET:url];
}

- (BeeHTTPRequest *)PUT:(NSString *)url
{
	return [self HTTP_PUT:url];
}

- (BeeHTTPRequest *)POST:(NSString *)url
{
	return [self HTTP_POST:url];
}

- (BeeHTTPRequest *)DELETE:(NSString *)url
{
	return [self HTTP_DELETE:url];
}

- (BeeHTTPRequest *)HTTP_GET:(NSString *)url
{
	BeeHTTPRequest * req = [BeeHTTPRequestQueue GET:url];
	[req addResponder:self];
	return req;
}

- (BeeHTTPRequest *)HTTP_PUT:(NSString *)url
{
	BeeHTTPRequest * req = [BeeHTTPRequestQueue PUT:url];
	[req addResponder:self];
	return req;
}

- (BeeHTTPRequest *)HTTP_POST:(NSString *)url
{
	BeeHTTPRequest * req = [BeeHTTPRequestQueue POST:url];
	[req addResponder:self];
	return req;
}

- (BeeHTTPRequest *)HTTP_DELETE:(NSString *)url
{
	BeeHTTPRequest * req = [BeeHTTPRequestQueue DELETE:url];
	[req addResponder:self];
	return req;
}

#pragma mark -

- (BeeHTTPBoolBlockV)REQUESTING
{
	BeeHTTPBoolBlockV block = ^ BOOL ( void )
	{
		return [self requestingURL:nil];
	};

	return [[block copy] autorelease];
}

- (BeeHTTPBoolBlockS)REQUESTING_URL
{
	BeeHTTPBoolBlockS block = ^ BOOL ( NSString * url )
	{
		return [self requestingURL:url];
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPBoolBlockV)CANCEL_REQUESTS
{
	BeeHTTPBoolBlockV block = ^ BOOL ( void )
	{
		[self cancelRequests];
		return YES;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockSN)GET
{
	BeeHTTPRequestBlockSN block = ^ BeeHTTPRequest * ( NSString * url, ... )
	{
		va_list args;
		va_start( args, url );

		url = [[[NSString alloc] initWithFormat:url arguments:args] autorelease];
		
		va_end( args );

		BeeHTTPRequest * req = [BeeHTTPRequestQueue GET:url];
		[req addResponder:self];
		return req;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockSN)PUT
{
	BeeHTTPRequestBlockSN block = ^ BeeHTTPRequest * ( NSString * url, ... )
	{
		va_list args;
		va_start( args, url );
		
		url = [[[NSString alloc] initWithFormat:url arguments:args] autorelease];
		
		va_end( args );

		BeeHTTPRequest * req = [BeeHTTPRequestQueue PUT:url];
		[req addResponder:self];
		return req;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockSN)POST
{
	BeeHTTPRequestBlockSN block = ^ BeeHTTPRequest * ( NSString * url, ... )
	{
		va_list args;
		va_start( args, url );
		
		url = [[[NSString alloc] initWithFormat:url arguments:args] autorelease];
		
		va_end( args );

		BeeHTTPRequest * req = [BeeHTTPRequestQueue POST:url];
		[req addResponder:self];
		return req;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockSN)DELETE
{
	BeeHTTPRequestBlockSN block = ^ BeeHTTPRequest * ( NSString * url, ... )
	{
		va_list args;
		va_start( args, url );
		
		url = [[[NSString alloc] initWithFormat:url arguments:args] autorelease];
		
		va_end( args );

		BeeHTTPRequest * req = [BeeHTTPRequestQueue DELETE:url];
		[req addResponder:self];
		return req;
	};
	
	return [[block copy] autorelease];
}

- (BeeHTTPRequestBlockSN)HTTP_GET
{
	return [self GET];
}

- (BeeHTTPRequestBlockSN)HTTP_PUT
{
	return [self PUT];
}

- (BeeHTTPRequestBlockSN)HTTP_POST
{
	return [self POST];
}

- (BeeHTTPRequestBlockSN)HTTP_DELETE
{
	return [self DELETE];
}

- (BOOL)requestingURL
{
	if ( [self isRequestResponder] )
	{
		return [BeeHTTPRequestQueue requesting:nil byResponder:self];
	}
	else
	{
		return NO;
	}		
}

- (BOOL)requestingURL:(NSString *)url
{
	if ( [self isRequestResponder] )
	{
		return [BeeHTTPRequestQueue requesting:url byResponder:self];
	}
	else
	{
		return NO;
	}			
}

- (BeeHTTPRequest *)request
{
	NSArray * array = [BeeHTTPRequestQueue requests:nil byResponder:self];
	return [array safeObjectAtIndex:0];
}

- (NSArray *)requests
{
	return [BeeHTTPRequestQueue requests:nil byResponder:self];
}

- (NSArray *)requests:(NSString *)url
{
	return [BeeHTTPRequestQueue requests:url byResponder:self];
}

- (void)cancelRequests
{
	if ( [self isRequestResponder] )
	{
		[BeeHTTPRequestQueue cancelRequestByResponder:self];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSObject_BeeHTTPRequest )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

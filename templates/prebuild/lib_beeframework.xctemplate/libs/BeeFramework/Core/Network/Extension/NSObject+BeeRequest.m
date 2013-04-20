//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  NSObject+BeeRequest.m
//

#include <execinfo.h>

#import "Bee_Precompile.h"
#import "NSObject+BeeRequest.h"

#pragma mark -

@implementation NSObject(BeeRequestResponder)

@dynamic HTTP_GET;
@dynamic HTTP_PUT;
@dynamic HTTP_POST;

- (BeeRequest *)GET:(NSString *)url
{
	return [self HTTP_GET:url];
}

- (BeeRequest *)PUT:(NSString *)url
{
	return [self HTTP_PUT:url];
}

- (BeeRequest *)POST:(NSString *)url
{
	return [self HTTP_POST:url];
}

- (BeeRequest *)HTTP_GET:(NSString *)url
{
	BeeRequest * req = [BeeRequestQueue GET:url];
	[req addResponder:self];
	return req;
}

- (BeeRequest *)HTTP_PUT:(NSString *)url
{
	BeeRequest * req = [BeeRequestQueue PUT:url];
	[req addResponder:self];
	return req;
}

- (BeeRequest *)HTTP_POST:(NSString *)url
{
	BeeRequest * req = [BeeRequestQueue POST:url];
	[req addResponder:self];
	return req;
}

- (BOOL)isRequestResponder
{
	if ( [self respondsToSelector:@selector(handleRequest:)] )
	{
		return YES;
	}
	
	return NO;
}

- (BeeRequestBlockS)HTTP_GET
{
	BeeRequestBlockS block = ^ BeeRequest * ( NSString * url )
	{
		BeeRequest * req = [BeeRequestQueue GET:url];
		[req addResponder:self];
		return req;
	};

	return [[block copy] autorelease];
}

- (BeeRequestBlockS)HTTP_PUT
{
	BeeRequestBlockS block = ^ BeeRequest * ( NSString * url )
	{
		BeeRequest * req = [BeeRequestQueue PUT:url];
		[req addResponder:self];
		return req;
	};
	
	return [[block copy] autorelease];
}

- (BeeRequestBlockS)HTTP_POST
{
	BeeRequestBlockS block = ^ BeeRequest * ( NSString * url )
	{
		BeeRequest * req = [BeeRequestQueue POST:url];
		[req addResponder:self];
		return req;
	};

	return [[block copy] autorelease];
}

- (BOOL)requestingURL
{
	if ( [self isRequestResponder] )
	{
		return [BeeRequestQueue requesting:nil byResponder:self];
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
		return [BeeRequestQueue requesting:url byResponder:self];
	}
	else
	{
		return NO;
	}			
}

- (NSArray *)requests
{
	return [BeeRequestQueue requests:nil byResponder:self];
}

- (NSArray *)requests:(NSString *)url
{
	return [BeeRequestQueue requests:url byResponder:self];
}

- (void)cancelRequests
{
	if ( [self isRequestResponder] )
	{
		[BeeRequestQueue cancelRequestByResponder:self];
	}
}

- (void)handleRequest:(BeeRequest *)request
{
}

@end


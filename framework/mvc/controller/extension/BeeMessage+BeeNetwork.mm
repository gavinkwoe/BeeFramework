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

#import "BeeMessage+BeeNetwork.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface BeeMessage(BeeNetworkPrivate)
- (void)internalNotifyProgressUpdated;
@end

#pragma mark -

@implementation BeeMessage(BeeNetwork)

@dynamic uploadProgress;
@dynamic downloadProgress;
@dynamic requesting;
@dynamic request;
@dynamic response;
@dynamic responseString;

@dynamic HTTPUploadProgress;
@dynamic HTTPDownloadProgress;
@dynamic HTTPRequesting;
@dynamic HTTPRequest;
@dynamic HTTPRequests;
@dynamic HTTPResponse;
@dynamic HTTPResponseData;
@dynamic HTTPResponseString;

#pragma mark -

// backward compatible

- (BOOL)requesting
{
	return [self HTTPRequesting];
}

- (BeeHTTPRequest *)request
{
	return [self HTTPRequest];
}

- (NSData *)response
{
	return [self HTTPResponseData];
}

- (NSString *)responseString
{
	return [self HTTPResponseString];
}

- (float)uploadProgress
{
	return [self HTTPUploadProgress];
}

- (float)downloadProgress
{
	return [self HTTPDownloadProgress];
}

#pragma mark -

// new methods

- (float)HTTPUploadProgress
{
	NSArray * array = self.requests;
	
	if ( array && array.count )
	{
		float percent = 0.0f;
		
		for ( BeeHTTPRequest * req in array )
		{
			unsigned long long sent = [req totalBytesSent];
			unsigned long long total = [req postLength];
			
			INFO( @"%@(%@), sent = %d, total = %d", self.message, [req.url absoluteString], sent, total );
			
			if ( total )
			{
				percent += (sent * 1.0f) / (total * 1.0f);
			}
		}
		
		return (percent / array.count);
	}
	else
	{
		return 0.0f;
	}
}

- (float)HTTPDownloadProgress
{
	NSArray * array = self.requests;
	
	if ( array && array.count )
	{
		float percent = 0.0f;
		
		for ( BeeHTTPRequest * req in array )
		{
			unsigned long long recv = [req totalBytesRead];
			unsigned long long total = [req contentLength];
			
			INFO( @"%@(%@), recv = %d, total = %d", self.message, [req.url absoluteString], recv, total );
			
			if ( total )
			{
				percent += (recv * 1.0f) / (total * 1.0f);
			}
		}
		
		return (percent / array.count);
	}
	else
	{
		return 0.0f;
	}
}

- (BOOL)HTTPRequesting
{
	return self.requestingURL;
}

- (BeeHTTPRequest *)HTTPRequest
{
	for ( BeeHTTPRequest * req in self.requests )
	{
		if ( req.created || req.sending )
		{
			return req;
		}
	}
	
	return nil;
}

- (NSArray *)HTTPRequests
{
	return self.requests;
}

- (id)HTTPResponse
{
	return [self HTTPResponseData];
}

- (NSData *)HTTPResponseData
{
	NSArray * array = self.requests;
    
	for ( BeeHTTPRequest * req in array )
	{
		if ( req.succeed || req.failed )
		{
			return req.responseData;
		}
	}
	
	return nil;
}

- (NSString *)HTTPResponseString
{
	NSArray * array = self.requests;
    
	for ( BeeHTTPRequest * req in array )
	{
		if ( req.succeed || req.failed )
		{
			return req.responseString;
		}
	}
	
	return nil;
}

#pragma mark -

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.sendProgressed )
	{
		if ( self.toldProgress )
		{
			[self internalNotifyProgressUpdated];
		}
	}
	else if ( request.sending )
	{
		// TODO:
		request.timeOutSeconds = self.seconds;
		
		[self changeState:BeeMessage.STATE_SENDING];
	}
	else if ( request.recvProgressed )
	{
		if ( self.toldProgress )
		{
			[self internalNotifyProgressUpdated];
		}
	}
	else if ( request.recving )
	{
		if ( self.toldProgress )
		{
			[self changeState:BeeMessage.STATE_WAITING];
		}
	}
	else if ( request.succeed )
	{
		[self changeState:BeeMessage.STATE_SUCCEED];
	}
	else if ( request.failed )
	{
		if ( self.timeout )
		{
			self.errorDomain = BeeMessage.ERROR_DOMAIN_SERVER;
			self.errorCode = BeeMessage.ERROR_CODE_TIMEOUT;
			self.errorDesc = @"timeout";
		}
		else
		{
			self.errorDomain = BeeMessage.ERROR_DOMAIN_NETWORK;
			self.errorCode = request.errorCode;
			self.errorDesc = nil;
		}
        
		[self changeState:BeeMessage.STATE_FAILED];
	}
	else if ( request.cancelled )
	{
		[self changeState:BeeMessage.STATE_CANCELLED];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( BeeMessage_BeeNetwork )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

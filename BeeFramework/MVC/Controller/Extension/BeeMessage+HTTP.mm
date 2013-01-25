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
//  BeeMessage+HTTP.mm
//

#import "Bee_Precompile.h"
#import "Bee_Log.h"
#import "BeeMessage+HTTP.h"

#import <objc/runtime.h>

#pragma mark -

@interface BeeMessage(HTTPPrivate)
- (void)internalNotifyProgressUpdated;
@end

#pragma mark -

@implementation BeeMessage(HTTP)

@dynamic requesting;
@dynamic request;
@dynamic response;
@dynamic responseString;

- (BOOL)requesting
{
	return self.requestingURL;
}

- (BeeRequest *)request
{
	NSArray * array = self.requests;
	
	for ( BeeRequest * req in array )
	{
		if ( req.sending )
		{
			return req;
		}
	}

	return nil;
}

- (NSData *)response
{
	NSArray * array = self.requests;
	
	for ( BeeRequest * req in array )
	{
		if ( req.succeed )
		{
			return req.responseData;
		}
	}
	
	return nil;
}

- (NSString *)responseString
{
	NSData * data = [self response];
	if ( data )
	{
		return [[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding] autorelease];
	}
	
	return nil;
}

- (void)handleRequest:(BeeRequest *)request
{
	if ( request.sending )
	{
	}
	else if ( request.sendProgressed )
	{
		[self internalNotifyProgressUpdated];
	}
	else if ( request.recving )
	{
	}
	else if ( request.recvProgressed )
	{
		[self internalNotifyProgressUpdated];
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

- (float)uploadProgress
{
	NSArray * array = self.requests;
	
	if ( array && array.count )
	{
		float percent = 0.0f;
		
		for ( BeeRequest * req in array )
		{
			unsigned long long sent = [req totalBytesSent];
			unsigned long long total = [req postLength];
			
			CC( @"%@(%@), sent = %d, total = %d", self.message, [req.url absoluteString], sent, total );
			
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

- (float)downloadProgress
{
	NSArray * array = self.requests;
	
	if ( array && array.count )
	{
		float percent = 0.0f;
		
		for ( BeeRequest * req in array )
		{
			unsigned long long recv = [req totalBytesRead];
			unsigned long long total = [req contentLength];
			
			CC( @"%@(%@), recv = %d, total = %d", self.message, [req.url absoluteString], recv, total );
			
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

@end

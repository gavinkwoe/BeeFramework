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
//  BeeMessage+JSON.h
//

#import "Bee_Precompile.h"
#import "Bee_Network.h"
#import "BeeMessage+JSON.h"
#import "BeeMessage+HTTP.h"

#import "JSONKit.h"
#import <objc/runtime.h>

#pragma mark -

@implementation BeeMessage(JSON)

@dynamic JSON_GET;
@dynamic JSON_POST;
@dynamic responseJSON;
@dynamic responseJSONDictionary;
@dynamic responseJSONArray;

- (BeeMessageJSONRequestBlock)JSON_GET
{
	BeeMessageJSONRequestBlock block = ^ BeeRequest * ( NSString * url, id json )
	{
		BeeRequest * req = self.HTTP_GET( url );

		if ( req && json )
		{
			req.BODY( [json JSONData] );
		}

		return req;
	};

	return [[block copy] autorelease];
}

- (BeeMessageJSONRequestBlock)JSON_POST
{
	BeeMessageJSONRequestBlock block = ^ BeeRequest * ( NSString * url, id json )
	{
		BeeRequest * req = self.HTTP_POST( url );

		if ( req && json )
		{
			req.BODY( [json JSONData] );
		}

		return req;
	};
	
	return [[block copy] autorelease];
}

- (id)responseJSON
{
	NSData * data = self.response;
	if ( data )
	{
		return [data objectFromJSONData];
	}
	
	return nil;
}

- (NSDictionary *)responseJSONDictionary
{
	id obj = self.responseJSON;
	if ( obj && [obj isKindOfClass:[NSDictionary class]] )
	{
		return (NSDictionary *)obj;
	}
	
	return nil;
}

- (NSArray *)responseJSONArray
{
	id obj = self.responseJSON;
	if ( obj && [obj isKindOfClass:[NSArray class]] )
	{
		return (NSArray *)obj;
	}
	
	return nil;
}

@end

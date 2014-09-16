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

#import "BeeMessage+BeeJSON.h"
#import "BeeMessage+BeeNetwork.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	KEY_RESPONSE_JSON
#define KEY_RESPONSE_JSON	"BeeMessage.cachedResponseJSON"

#pragma mark -

@implementation BeeMessage(BeeJSON)

@dynamic JSON_GET;
@dynamic JSON_POST;
@dynamic responseJSON;
@dynamic responseJSONDictionary;
@dynamic responseJSONArray;

- (BeeMessageJSONRequestBlock)JSON_GET
{
	BeeMessageJSONRequestBlock block = ^ BeeHTTPRequest * ( NSString * url, id json )
	{
		BeeHTTPRequest * req = self.HTTP_GET( url );

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
	BeeMessageJSONRequestBlock block = ^ BeeHTTPRequest * ( NSString * url, id json )
	{
		BeeHTTPRequest * req = self.HTTP_POST( url );

		if ( req && json )
		{
			req.BODY( [json JSONData] );
		}

		return req;
	};
	
	return [[block copy] autorelease];
}

- (NSObject *)cachedResponseJSON
{
	return objc_getAssociatedObject( self, KEY_RESPONSE_JSON );
}

- (void)setCachedResponseJSON:(NSObject *)value
{
	if ( nil == value )
		return;

	objc_setAssociatedObject( self, KEY_RESPONSE_JSON, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (id)responseJSON
{
//	NSObject * cached = [self cachedResponseJSON];
//	if ( nil != cached )
//		return cached;

	NSString * string = self.responseString;
	if ( nil == string || 0 == string.length )
		return nil;

	NSError * error = nil;
	
//	NSObject * obj = [string objectFromJSONString];
	NSObject * obj = [string objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&error];
	if ( nil == obj )
	{
		ERROR( @"%@\n\n%@", [error description], string );
		return nil;
	}
	
//	[self setCachedResponseJSON:obj];
	return obj;
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

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( BeeMessage_BeeJSON )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

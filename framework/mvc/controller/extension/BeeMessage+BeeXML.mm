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

#import "BeeMessage+BeeXML.h"
#import "BeeMessage+BeeNetwork.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation BeeMessage(BeeXML)

@dynamic XML_GET;
@dynamic XML_POST;
@dynamic responseXML;
@dynamic responseXMLDictionary;
@dynamic responseXMLString;

- (BeeMessageXMLRequestBlock)XML_GET
{
	BeeMessageXMLRequestBlock block = ^ BeeHTTPRequest * ( NSString * url, id xml )
	{
		// TODO: convert xml into string
		return nil;
	};
	
	return [[block copy] autorelease];
}

- (BeeMessageXMLRequestBlock)XML_POST
{
	BeeMessageXMLRequestBlock block = ^ BeeHTTPRequest * ( NSString * url, id xml )
	{
		// TODO: convert xml into string
		return nil;
	};
	
	return [[block copy] autorelease];
}

- (id)responseXML
{
	NSData * data = self.response;
	if ( data )
	{
		// TODO: parse XML
		return nil;
	}
	
	return nil;
}

- (NSDictionary *)responseXMLDictionary
{
	return nil;
}

- (NSString *)responseXMLString
{
	return nil;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( BeeMessage_BeeXML )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

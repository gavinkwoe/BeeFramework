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
//  BeeMessage+XML.h
//

#import "Bee_Precompile.h"
#import "Bee_Network.h"
#import "BeeMessage+XML.h"
#import "BeeMessage+HTTP.h"

#import <objc/runtime.h>

#pragma mark -

@implementation BeeMessage(XML)

- (BeeMessageXMLRequestBlock)XML_GET
{
	BeeMessageXMLRequestBlock block = ^ BeeRequest * ( NSString * url, id xml )
	{
		// TODO: convert xml into string
		return nil;
	};
	
	return [[block copy] autorelease];
}

- (BeeMessageXMLRequestBlock)XML_POST
{
	BeeMessageXMLRequestBlock block = ^ BeeRequest * ( NSString * url, id xml )
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

@end

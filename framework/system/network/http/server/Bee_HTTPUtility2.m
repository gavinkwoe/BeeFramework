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

#import "Bee_HTTPUtility2.h"
#import "Bee_HTTPWorkflow2.h"

#pragma mark -

BEE_EXTERN void echo( NSString * text, ... )
{
	BeeHTTPWorkflow2 * workflow = [BeeHTTPWorkflow2 processingWorkflow];
	if ( workflow )
	{
		va_list args;
		va_start( args, text );
		
		NSString * content = [[NSString alloc] initWithFormat:(NSString *)text arguments:args];
		
		if ( content )
		{
			[workflow.connection.response.bodyData appendData:[content asNSData]];

			[content release];
		}
		
		va_end( args );
	}
}

BEE_EXTERN void line( NSString * text, ... )
{
	BeeHTTPWorkflow2 * workflow = [BeeHTTPWorkflow2 processingWorkflow];
	if ( workflow )
	{
		va_list args;
		va_start( args, text );
		
		NSString * content = [[NSString alloc] initWithFormat:(NSString *)text arguments:args];
		
		if ( content )
		{
			[workflow.connection.response.bodyData appendData:[content asNSData]];
			[workflow.connection.response.bodyData appendData:[@"\n" asNSData]];

			[content release];
		}

		va_end( args );
	}
}

BEE_EXTERN void file( NSString * filePath )
{
	if ( nil == filePath )
		return;
	
	BeeHTTPWorkflow2 * workflow = [BeeHTTPWorkflow2 processingWorkflow];
	if ( workflow )
	{
		NSData * fileData = [[NSData alloc] initWithContentsOfFile:filePath];
		if ( fileData )
		{
			[workflow.connection.response.bodyData appendData:fileData];
			
			[fileData release];
		}
	}
}

BEE_EXTERN void header( NSString * key, NSString * value )
{
	if ( nil == key )
		return;
	
	BeeHTTPWorkflow2 * workflow = [BeeHTTPWorkflow2 processingWorkflow];
	if ( workflow )
	{
		if ( value )
		{
			[workflow.connection.response addHeader:key value:value];
		}
		else
		{
			[workflow.connection.response removeHeader:key];
		}
	}
}

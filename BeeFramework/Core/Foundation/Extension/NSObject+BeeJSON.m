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
//  NSObject+BeeJSON.m
//

#import "Bee_Precompile.h"
#import "Bee_Runtime.h"
#import "NSObject+BeeJSON.h"
#import "NSObject+BeeTypeConversion.h"
#import "JSONKit.h"
#include <objc/runtime.h>

#pragma mark -

@implementation NSObject(BeeJSON)

- (NSData *)JSONData
{
	return [[self JSONDictionary] JSONData];
}

- (NSString *)JSONString
{
	return [[self JSONDictionary] JSONString];
}

- (NSDictionary *)JSONDictionary
{
	NSMutableDictionary * result = [NSMutableDictionary dictionary];
	
	NSUInteger			propertyCount = 0;
	objc_property_t *	properties = class_copyPropertyList( [self class], &propertyCount );
	
	for ( NSUInteger i = 0; i < propertyCount; i++ )
	{
		const char *	name = property_getName(properties[i]);
		const char *	attr = property_getAttributes(properties[i]);

		NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
		NSUInteger		propertyType = [BeeTypeEncoding typeOf:attr];

		NSObject * obj = [self valueForKey:propertyName];
		if ( obj )
		{
			if ( BeeTypeEncoding.NSNUMBER == propertyType )
			{
				[result setObject:obj forKey:propertyName];
			}
			else if ( BeeTypeEncoding.NSSTRING == propertyType )
			{
				[result setObject:obj forKey:propertyName];
			}
			else if ( BeeTypeEncoding.NSARRAY == propertyType )
			{
				[result setObject:obj forKey:propertyName];
			}
			else if ( BeeTypeEncoding.NSDICTIONARY == propertyType )
			{
				[result setObject:obj forKey:propertyName];
			}
			else if ( BeeTypeEncoding.NSDATE == propertyType )
			{
				[result setObject:obj forKey:propertyName];
			}
			else
			{
				obj = [obj JSONDictionary];
				if ( obj )
				{
					[result setObject:obj forKey:propertyName];
				}
				else
				{
					[result setObject:[NSDictionary dictionary] forKey:propertyName];
				}
			}
		}
		else
		{
			[result setObject:[NSNull null] forKey:propertyName];
		}
	}

	free( properties );
	
	return result;
}

@end

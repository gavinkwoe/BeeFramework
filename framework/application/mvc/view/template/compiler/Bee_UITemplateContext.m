//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_UITemplateContext.h"

#pragma mark -

@implementation BeeUITemplateContext

@synthesize precompile = _precompile;
@synthesize values = _values;

@dynamic PRECOMPILE;
@dynamic SET;
@dynamic REMOVE;
@dynamic CLEAR;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_precompile = [[NSMutableDictionary alloc] init];
		_values = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_precompile removeAllObjects];
	[_precompile release];

	[_values removeAllObjects];
	[_values release];

	[super dealloc];
}


#pragma mark -

- (BeeUITemplateContextBlockN)PRECOMPILE
{
	BeeUITemplateContextBlockN block = ^ BeeUITemplateContext * ( id first, ... )
	{
		if ( nil == first || NO == [first isKindOfClass:[NSString class]] )
			return self;
		
		va_list args;
		va_start( args, first );
		
		NSString * key = (NSString *)first;
		NSObject * val = (NSObject *)va_arg( args, NSObject * );
		
		va_end( args );
		
		if ( val )
		{
			[_precompile setObject:val forKey:key];
		}
		else
		{
			[_precompile removeObjectForKey:key];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUITemplateContextBlockN)SET
{
	BeeUITemplateContextBlockN block = ^ BeeUITemplateContext * ( id first, ... )
	{
		if ( nil == first || NO == [first isKindOfClass:[NSString class]] )
			return self;

		va_list args;
		va_start( args, first );
		
		NSString * key = (NSString *)first;
		NSObject * val = (NSObject *)va_arg( args, NSObject * );
		
		va_end( args );
		
		if ( val )
		{
			[_values setObject:val forKey:key];
		}
		else
		{
			[_values removeObjectForKey:key];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUITemplateContextBlockN)REMOVE
{
	BeeUITemplateContextBlockN block = ^ BeeUITemplateContext * ( id first, ... )
	{
		if ( nil == first || NO == [first isKindOfClass:[NSString class]] )
			return self;
		
		[_values removeObjectForKey:(NSString *)first];
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUITemplateContextBlock)CLEAR
{
	BeeUITemplateContextBlock block = ^ BeeUITemplateContext * ( void )
	{
		[_values removeAllObjects];
		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

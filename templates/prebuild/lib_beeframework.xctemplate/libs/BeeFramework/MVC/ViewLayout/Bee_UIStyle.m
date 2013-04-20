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
//  Bee_UIQuery.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UIStyle.h"
#import "Bee_UIQuery.h"
#import "UIView+BeeExtension.h"
#import "NSArray+BeeExtension.h"

#import "JSONKit.h"
#import <objc/runtime.h>

#pragma mark -

@implementation BeeUIStyle

@synthesize name = _name;
@synthesize properties = _properties;

@dynamic PROPERTY;
@dynamic APPLY_FOR;
@dynamic APPLY;

+ (NSString *)generateName
{
	static NSUInteger __seed = 0;
	return [NSString stringWithFormat:@"style_%u", __seed++];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.name = [BeeUIStyle generateName];
		self.properties = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)dealloc
{
	self.name = nil;
	self.properties = nil;
	
	[super dealloc];
}

- (BeeUIStyleObjectBlock)APPLY
{
    BeeUIStyleObjectBlock block = ^ BeeUIStyle * ( void )
	{
        if ( self.object )
        {
            [self applyFor:self.object];
        }
        
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleObjectBlockN)APPLY_FOR
{
    BeeUIStyleObjectBlockN block = ^ BeeUIStyle * ( id first, ... )
    {
        [self applyFor:first];
        
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIStyleObjectBlockN)PROPERTY
{
	BeeUIStyleObjectBlockN block = ^ BeeUIStyle * ( id first, ... )
	{
		NSMutableDictionary * dict = nil;
		
		if ( [first isKindOfClass:[NSString class]] )
		{
			NSString * json = [(NSString *)first stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
			if ( json && json.length )
			{
				dict = [json objectFromJSONString];
				if ( nil == dict || NO == [dict isKindOfClass:[NSDictionary class]] )
				{
					va_list args;
					va_start( args, first );

					NSString * key = (NSString *)first;
					NSString * val = va_arg( args, NSString * );

					va_end( args );

					dict = [NSMutableDictionary dictionaryWithObject:val forKey:key];
				}
			}
		}
		else if ( [first isKindOfClass:[NSDictionary class]] )
		{
			dict = (NSMutableDictionary *)first;
		}

		if ( dict )
		{
			[self.properties addEntriesFromDictionary: dict];
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

- (void)applyFor:(id)object
{
	if ( 0 == self.properties.count )
		return;
	
    if ( [object isKindOfClass:[UIView class]] )
	{
        [object performSelector:@selector(applyStyleProperties:) withObject:self.properties];
	}
	else if ( [object isKindOfClass:[UIViewController class]] )
	{
        UIView * view = ((UIViewController *)object).view;
        [view performSelector:@selector(applyStyleProperties:) withObject:self.properties];
	}
	else if ( [object isKindOfClass:[NSArray array]] )
	{
		for ( NSObject * obj in (NSArray *)object )
		{
			if ( [obj isKindOfClass:[UIView class]] )
			{
                [obj performSelector:@selector(applyStyleProperties:) withObject:self.properties];
			}
			else if ( [obj isKindOfClass:[UIViewController class]] )
			{
                UIView * view = ((UIViewController *)obj).view;
                [view performSelector:@selector(applyStyleProperties:) withObject:self.properties];
			}
		}
	}
    else if ( [object isKindOfClass:[BeeUIQuery class]] )
    {
        for ( NSObject * obj in ((BeeUIQuery *)object).views )
		{
            [obj performSelector:@selector(applyStyleProperties:) withObject:self.properties];
		}
    }
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

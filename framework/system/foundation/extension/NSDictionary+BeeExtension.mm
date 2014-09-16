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

#import "NSDictionary+BeeExtension.h"
#import "NSObject+BeeTypeConversion.h"
#import "NSObject+BeeJSON.h"
#import "Bee_UnitTest.h"
#import "Bee_Runtime.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSDictionary(BeeExtension)

@dynamic APPEND;

- (NSDictionaryAppendBlock)APPEND
{
	NSDictionaryAppendBlock block = ^ NSDictionary * ( NSString * key, id value )
	{
		if ( key && value )
		{
			NSString * className = [[self class] description];

			if ( [self isKindOfClass:[NSMutableDictionary class]] || [className isEqualToString:@"NSMutableDictionary"] || [className isEqualToString:@"__NSDictionaryM"] )
			{
				[(NSMutableDictionary *)self setObject:value atPath:key];
				return self;
			}
			else
			{
				NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self];
				[dict setObject:value atPath:key];
				return dict;
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (NSObject *)objectOfAny:(NSArray *)array
{
	for ( NSString * key in array )
	{
		NSObject * obj = [self objectForKey:key];
		if ( obj )
			return obj;
	}
	
	return nil;
}

- (NSString *)stringOfAny:(NSArray *)array
{
	NSObject * obj = [self objectOfAny:array];
	if ( nil == obj )
		return nil;
	
	return [obj asNSString];
}

- (id)objectAtPath:(NSString *)path
{
	return [self objectAtPath:path separator:nil];
}

- (id)objectAtPath:(NSString *)path separator:(NSString *)separator
{
	if ( nil == separator )
	{
		path = [path stringByReplacingOccurrencesOfString:@"." withString:@"/"];
		separator = @"/";
	}
	
#if 1
	
	NSArray * array = [path componentsSeparatedByString:separator];
	if ( 0 == [array count] )
	{
		return nil;
	}

	NSObject * result = nil;
	NSDictionary * dict = self;
	
	for ( NSString * subPath in array )
	{
		if ( 0 == [subPath length] )
			continue;
		
		result = [dict objectForKey:subPath];
		if ( nil == result )
			return nil;

		if ( [array lastObject] == subPath )
		{
			return result;
		}
		else if ( NO == [result isKindOfClass:[NSDictionary class]] )
		{
			return nil;
		}

		dict = (NSDictionary *)result;
	}
	
	return (result == [NSNull null]) ? nil : result;

#else
	
	// thanks @lancy, changed: use native keyPath
	
	NSString *	keyPath = [path stringByReplacingOccurrencesOfString:separator withString:@"."];
	NSRange		range = NSMakeRange( 0, 1 );

	if ( [[keyPath substringWithRange:range] isEqualToString:@"."] )
	{
		keyPath = [keyPath substringFromIndex:1];
	}

	NSObject * result = [self valueForKeyPath:keyPath];
	return (result == [NSNull null]) ? nil : result;
	
#endif
}

- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other
{
	NSObject * obj = [self objectAtPath:path];
	return obj ? obj : other;
}

- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other separator:(NSString *)separator
{
	NSObject * obj = [self objectAtPath:path separator:separator];
	return obj ? obj : other;
}

- (id)objectAtPath:(NSString *)path withClass:(Class)clazz
{
	return [self objectAtPath:path withClass:clazz otherwise:nil];
}

- (id)objectAtPath:(NSString *)path withClass:(Class)clazz otherwise:(NSObject *)other
{
	NSObject * obj = [self objectAtPath:path];
	if ( obj && [obj isKindOfClass:[NSDictionary class]] )
	{
		return [clazz objectFromDictionary:obj];
	}
	
	return nil;
}

- (BOOL)boolAtPath:(NSString *)path
{
	return [self boolAtPath:path otherwise:NO];
}

- (BOOL)boolAtPath:(NSString *)path otherwise:(BOOL)other
{
	NSObject * obj = [self objectAtPath:path];
	if ( [obj isKindOfClass:[NSNull class]] )
	{
		return NO;
	}
	else if ( [obj isKindOfClass:[NSNumber class]] )
	{
		return [(NSNumber *)obj intValue] ? YES : NO;
	}
	else if ( [obj isKindOfClass:[NSString class]] )
	{
		if ( [(NSString *)obj hasPrefix:@"y"] ||
			[(NSString *)obj hasPrefix:@"Y"] ||
			[(NSString *)obj hasPrefix:@"T"] ||
			[(NSString *)obj hasPrefix:@"t"] ||
			[(NSString *)obj isEqualToString:@"1"] )
		{
			// YES/Yes/yes/TRUE/Ture/true/1
			return YES;
		}
		else
		{
			return NO;
		}
	}

	return other;
}

- (NSNumber *)numberAtPath:(NSString *)path
{
	NSObject * obj = [self objectAtPath:path];
	if ( [obj isKindOfClass:[NSNull class]] )
	{
		return nil;
	}
	else if ( [obj isKindOfClass:[NSNumber class]] )
	{
		return (NSNumber *)obj;
	}
	else if ( [obj isKindOfClass:[NSString class]] )
	{
		return [NSNumber numberWithDouble:[(NSString *)obj doubleValue]];
	}

	return nil;
}

- (NSNumber *)numberAtPath:(NSString *)path otherwise:(NSNumber *)other
{
	NSNumber * obj = [self numberAtPath:path];
	return obj ? obj : other;
}

- (NSString *)stringAtPath:(NSString *)path
{
	NSObject * obj = [self objectAtPath:path];
	if ( [obj isKindOfClass:[NSNull class]] )
	{
		return nil;
	}
	else if ( [obj isKindOfClass:[NSNumber class]] )
	{
		return [NSString stringWithFormat:@"%d", [(NSNumber *)obj intValue]];
	}
	else if ( [obj isKindOfClass:[NSString class]] )
	{
		return (NSString *)obj;
	}
	
	return nil;
}

- (NSString *)stringAtPath:(NSString *)path otherwise:(NSString *)other
{
	NSString * obj = [self stringAtPath:path];
	return obj ? obj : other;
}

- (NSArray *)arrayAtPath:(NSString *)path
{
	NSObject * obj = [self objectAtPath:path];
	return [obj isKindOfClass:[NSArray class]] ? (NSArray *)obj : nil;
}

- (NSArray *)arrayAtPath:(NSString *)path otherwise:(NSArray *)other
{
	NSArray * obj = [self arrayAtPath:path];
	return obj ? obj : other;
}

- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz
{
	return [self arrayAtPath:path withClass:clazz otherwise:nil];
}

- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz otherwise:(NSArray *)other
{
	NSArray * array = [self arrayAtPath:path otherwise:nil];
	if ( array )
	{
		NSMutableArray * results = [NSMutableArray array];
		for ( NSObject * obj in array )
		{
			if ( [obj isKindOfClass:[NSDictionary class]] )
			{
				[results addObject:[clazz objectFromDictionary:obj]];
			}
		}
		return results;
	}
	return other;
}

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path
{
	NSObject * obj = [self objectAtPath:path];
	return [obj isKindOfClass:[NSMutableArray class]] ? (NSMutableArray *)obj : nil;	
}

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path otherwise:(NSMutableArray *)other
{
	NSMutableArray * obj = [self mutableArrayAtPath:path];
	return obj ? obj : other;
}

- (NSDictionary *)dictAtPath:(NSString *)path
{
	NSObject * obj = [self objectAtPath:path];
	return [obj isKindOfClass:[NSDictionary class]] ? (NSDictionary *)obj : nil;	
}

- (NSDictionary *)dictAtPath:(NSString *)path otherwise:(NSDictionary *)other
{
	NSDictionary * obj = [self dictAtPath:path];
	return obj ? obj : other;
}

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path
{
	NSObject * obj = [self objectAtPath:path];
	return [obj isKindOfClass:[NSMutableDictionary class]] ? (NSMutableDictionary *)obj : nil;	
}

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path otherwise:(NSMutableDictionary *)other
{
	NSMutableDictionary * obj = [self mutableDictAtPath:path];
	return obj ? obj : other;
}

// thanks to @ilikeido
- (id)objectForClass:(Class)clazz
{
    if ( [clazz respondsToSelector:@selector(initFromDictionary:)] )
	{
        return [clazz performSelector:@selector(initFromDictionary:) withObject:self];
    }

	if ( [clazz respondsToSelector:@selector(fromDictionary:)] )
	{
        return [clazz performSelector:@selector(fromDictionary:) withObject:self];
    }

    id object = [[[clazz alloc] init] autorelease];
	if ( nil == object )
		return nil;
    
	for ( Class clazzType = clazz; clazzType != [NSObject class]; )
	{
		unsigned int		propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
		
		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			const char *	attr = property_getAttributes(properties[i]);
			NSUInteger		type = [BeeTypeEncoding typeOf:attr];
			
			BOOL readonly = [BeeTypeEncoding isReadOnly:attr];
			if ( readonly )
				continue;

			NSObject *	tempValue = [self objectForKey:propertyName];
			NSObject *	value = nil;
			
			if ( tempValue )
			{
				if ( BeeTypeEncoding.NSNUMBER == type )
				{
					value = [tempValue asNSNumber];
				}
				else if ( BeeTypeEncoding.NSSTRING == type )
				{
					value = [tempValue asNSString];
				}
				else if ( BeeTypeEncoding.NSDATE == type )
				{
					value = [tempValue asNSDate];
				}
				else if ( BeeTypeEncoding.NSARRAY == type )
				{
					if ( [tempValue isKindOfClass:[NSArray class]] )
					{
						SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertPropertyClassFor_%@", propertyName] );
						if ( [clazz respondsToSelector:convertSelector] )
						{
							Class convertClass = [clazz performSelector:convertSelector];
							if ( convertClass )
							{
								NSMutableArray * arrayTemp = [NSMutableArray array];

								for ( NSObject * tempObject in (NSArray *)tempValue )
								{
									if ( [tempObject isKindOfClass:[NSDictionary class]] )
									{
										[arrayTemp addObject:[(NSDictionary *)tempObject objectForClass:convertClass]];
									}
								}
								
								value = arrayTemp;
							}
							else
							{
								value = tempValue;
							}
						}
						else
						{
							value = tempValue;
						}
					}
				}
				else if ( BeeTypeEncoding.NSDICTIONARY == type )
				{
					if ( [tempValue isKindOfClass:[NSDictionary class]] )
					{
						SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertPropertyClassFor_%@", propertyName] );
						if ( [clazz respondsToSelector:convertSelector] )
						{
							Class convertClass = [clazz performSelector:convertSelector];
							if ( convertClass )
							{
								value = [(NSDictionary *)tempValue objectForClass:convertClass];
							}
							else
							{
								value = tempValue;
							}
						}
						else
						{
							value = tempValue;
						}
					}
				}
				else if ( BeeTypeEncoding.OBJECT == type )
				{
					NSString * className = [BeeTypeEncoding classNameOfAttribute:attr];
					if ( [tempValue isKindOfClass:NSClassFromString(className)] )
					{
						value = tempValue;
					}
					else if ( [tempValue isKindOfClass:[NSDictionary class]] )
					{
						value = [(NSDictionary *)tempValue objectForClass:NSClassFromString(className)];
					}
				}
			}
            
            if ( nil != value )
            {
                [object setValue:value forKey:propertyName];
            }
		}
		
		free( properties );

		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}

    return object;
}

@end

#pragma mark -

// No-ops for non-retaining objects.
static const void *	__TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void			__TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) {};

#pragma mark -

@implementation NSMutableDictionary(BeeExtension)

@dynamic APPEND;

- (NSDictionaryAppendBlock)APPEND
{
	NSDictionaryAppendBlock block = ^ NSDictionary * ( NSString * key, id value )
	{
		if ( key && value )
		{
			[self setObject:value atPath:key];
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

+ (NSMutableDictionary *)nonRetainingDictionary
{
	CFDictionaryValueCallBacks callbacks = kCFTypeDictionaryValueCallBacks;
	callbacks.retain = __TTRetainNoOp;
	callbacks.release = __TTReleaseNoOp;
	return [(NSMutableDictionary *)CFDictionaryCreateMutable( NULL, 0, &kCFTypeDictionaryKeyCallBacks, &callbacks ) autorelease];
}

- (NSString *)stringOfAny:(NSArray *)array removeAll:(BOOL)flag
{
	NSString * result = [self stringOfAny:array];
	
	if ( flag )
	{
		[self removeObjectsForKeys:array];
	}
	
	return result;
}

- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path
{
	return [self setObject:obj atPath:path separator:nil];
}

- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path separator:(NSString *)separator
{
	if ( 0 == [path length] )
		return NO;
	
	if ( nil == separator )
	{
		path = [path stringByReplacingOccurrencesOfString:@"." withString:@"/"];
		separator = @"/";
	}
	
	NSArray * array = [path componentsSeparatedByString:separator]; 
	if ( 0 == [array count] )
	{
		[self setObject:obj forKey:path];
		return YES;
	}

	NSMutableDictionary *	upperDict = self;
	NSDictionary *			dict = nil;
	NSString *				subPath = nil;

	for ( subPath in array )
	{
		if ( 0 == [subPath length] )
			continue;

		if ( [array lastObject] == subPath )
			break;

		dict = [upperDict objectForKey:subPath];
		if ( nil == dict )
		{
			dict = [NSMutableDictionary dictionary];
			[upperDict setObject:dict forKey:subPath];
		}
		else
		{
			if ( NO == [dict isKindOfClass:[NSDictionary class]] )
				return NO;

			if ( NO == [dict isKindOfClass:[NSMutableDictionary class]] )
			{
				dict = [NSMutableDictionary dictionaryWithDictionary:dict];
				[upperDict setObject:dict forKey:subPath];
			}
		}

		upperDict = (NSMutableDictionary *)dict;
	}

	if ( subPath && obj )
	{
		[upperDict setObject:obj forKey:subPath];
	}
	return YES;
}

- (BOOL)setKeyValues:(id)first, ...
{
	va_list args;
	va_start( args, first );
	
	for ( ;; first = nil )
	{
		NSObject * key = first ? first : va_arg( args, NSObject * );
		if ( nil == key || NO == [key isKindOfClass:[NSString class]] )
			break;

		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;

		BOOL ret = [self setObject:value atPath:(NSString *)key];
		if ( NO == ret ) {
            va_end( args );
			return NO;
        }
	}
	va_end( args );
	return YES;
}

+ (NSMutableDictionary *)keyValues:(id)first, ...
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	va_list args;
	va_start( args, first );
	
	for ( ;; first = nil )
	{
		NSObject * key = first ? first : va_arg( args, NSObject * );
		if ( nil == key || NO == [key isKindOfClass:[NSString class]] )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;

		[dict setObject:value atPath:(NSString *)key];
	}
    va_end( args );
	return dict;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSDictionary_BeeExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

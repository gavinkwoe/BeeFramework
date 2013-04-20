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
//  Bee_UtilityRuntime.h
//

#import "Bee_Precompile.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <sys/errno.h>
#include <math.h>
#include <limits.h>
#include <objc/runtime.h>
#include <execinfo.h>

#import "Bee_Runtime.h"
#import "Bee_Log.h"

#define MAX_CALLSTACK_DEPTH	(64)

#pragma mark -

@interface BeeCallFrame(Private)
+ (NSUInteger)hex:(NSString *)text;
+ (id)parseFormat1:(NSString *)line;
+ (id)parseFormat2:(NSString *)line;
@end

#pragma mark -

@implementation BeeCallFrame

DEF_INT( TYPE_UNKNOWN,	0 )
DEF_INT( TYPE_OBJC,		1 )
DEF_INT( TYPE_NATIVEC,	2 )

@synthesize type = _type;
@synthesize process = _process;
@synthesize entry = _entry;
@synthesize offset = _offset;
@synthesize clazz = _clazz;
@synthesize method = _method;

- (NSString *)description
{
	if ( BeeCallFrame.TYPE_OBJC == _type )
	{
		return [NSString stringWithFormat:@"[O] %@(0x%08x + %d) -> [%@ %@]", _process, (unsigned int)_entry, _offset, _clazz, _method];
	}
	else if ( BeeCallFrame.TYPE_NATIVEC == _type )
	{
		return [NSString stringWithFormat:@"[C] %@(0x%08x + %d) -> %@", _process, (unsigned int)_entry, _offset, _method];
	}
	else
	{
		return [NSString stringWithFormat:@"[X] <unknown>(0x%08x + %d)", (unsigned int)_entry, _offset];
	}	
}

+ (NSUInteger)hex:(NSString *)text
{
	unsigned int number = 0;
	[[NSScanner scannerWithString:text] scanHexInt:&number];
	return (NSUInteger)number;
}

+ (id)parseFormat1:(NSString *)line
{
//	example: peeper  0x00001eca -[PPAppDelegate application:didFinishLaunchingWithOptions:] + 106
	NSError * error = NULL;
	NSString * expr = @"^[0-9]*\\s*([a-z0-9_]+)\\s+(0x[0-9a-f]+)\\s+-\\[([a-z0-9_]+)\\s+([a-z0-9_:]+)]\\s+\\+\\s+([0-9]+)$";	
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
	NSTextCheckingResult * result = [regex firstMatchInString:line options:0 range:NSMakeRange(0, [line length])];
	if ( result && (regex.numberOfCaptureGroups + 1) == result.numberOfRanges )
	{
		BeeCallFrame * frame = [[BeeCallFrame alloc] init];
		frame.type = BeeCallFrame.TYPE_OBJC;
		frame.process = [line substringWithRange:[result rangeAtIndex:1]];
		frame.entry = [BeeCallFrame hex:[line substringWithRange:[result rangeAtIndex:2]]];
		frame.clazz = [line substringWithRange:[result rangeAtIndex:3]];
		frame.method = [line substringWithRange:[result rangeAtIndex:4]];
		frame.offset = [[line substringWithRange:[result rangeAtIndex:5]] intValue];
		return [frame autorelease];
	}
	
	return nil;
}

+ (id)parseFormat2:(NSString *)line
{
//	example: UIKit 0x0105f42e UIApplicationMain + 1160
	NSError * error = NULL;
	NSString * expr = @"^[0-9]*\\s*([a-z0-9_]+)\\s+(0x[0-9a-f]+)\\s+([a-z0-9_]+)\\s+\\+\\s+([0-9]+)$";
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
	NSTextCheckingResult * result = [regex firstMatchInString:line options:0 range:NSMakeRange(0, [line length])];
	if ( result && (regex.numberOfCaptureGroups + 1) == result.numberOfRanges )
	{
		BeeCallFrame * frame = [[BeeCallFrame alloc] init];
		frame.type = BeeCallFrame.TYPE_NATIVEC;
		frame.process = [line substringWithRange:[result rangeAtIndex:1]];
		frame.entry = [self hex:[line substringWithRange:[result rangeAtIndex:2]]];
		frame.clazz = nil;
		frame.method = [line substringWithRange:[result rangeAtIndex:3]];
		frame.offset = [[line substringWithRange:[result rangeAtIndex:4]] intValue];
		return [frame autorelease];
	}
	
	return nil;
}

+ (id)unknown
{
	BeeCallFrame * frame = [[BeeCallFrame alloc] init];
	frame.type = BeeCallFrame.TYPE_UNKNOWN;
	return [frame autorelease];
}

+ (id)parse:(NSString *)line
{
	if ( 0 == [line length] )
		return nil;

	id frame1 = [BeeCallFrame parseFormat1:line];
	if ( frame1 )
		return frame1;
	
	id frame2 = [BeeCallFrame parseFormat2:line];
	if ( frame2 )
		return frame2;

	return [BeeCallFrame unknown];
}

- (void)dealloc
{
	[_process release];
	[_clazz release];
	[_method release];

	[super dealloc];
}

@end

#pragma mark -

@implementation BeeTypeEncoding

DEF_INT( UNKNOWN,		0 )
DEF_INT( OBJECT,		1 )
DEF_INT( NSNUMBER,		2 )
DEF_INT( NSSTRING,		3 )
DEF_INT( NSARRAY,		4 )
DEF_INT( NSDICTIONARY,	5 )
DEF_INT( NSDATE,		6 )

+ (NSUInteger)typeOf:(const char *)attr
{
	if ( attr[0] != 'T' )
		return BeeTypeEncoding.UNKNOWN;
	
	const char * type = &attr[1];
	if ( type[0] == '@' )
	{
		if ( type[1] != '"' )
			return BeeTypeEncoding.UNKNOWN;
		
		char typeClazz[128] = { 0 };
		
		const char * clazz = &type[2];
		const char * clazzEnd = strchr( clazz, '"' );
		
		if ( clazzEnd && clazz != clazzEnd )
		{
			unsigned int size = (unsigned int)(clazzEnd - clazz);
			strncpy( &typeClazz[0], clazz, size );
		}
		
		if ( 0 == strcmp((const char *)typeClazz, "NSNumber") )
		{
			return BeeTypeEncoding.NSNUMBER;
		}
		else if ( 0 == strcmp((const char *)typeClazz, "NSString") )
		{
			return BeeTypeEncoding.NSSTRING;
		}
		else if ( 0 == strcmp((const char *)typeClazz, "NSDate") )
		{
			return BeeTypeEncoding.NSDATE;
		}
		else if ( 0 == strcmp((const char *)typeClazz, "NSArray") )
		{
			return BeeTypeEncoding.NSARRAY;
		}
		else if ( 0 == strcmp((const char *)typeClazz, "NSDictionary") )
		{
			return BeeTypeEncoding.NSDICTIONARY;
		}
		else
		{
			return BeeTypeEncoding.OBJECT;
		}
	}
	else if ( type[0] == '[' )
	{
		return BeeTypeEncoding.UNKNOWN;
	}
	else if ( type[0] == '{' )
	{
		return BeeTypeEncoding.UNKNOWN;
	}
	else
	{
		if ( type[0] == 'c' || type[0] == 'C' )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else if ( type[0] == 'i' || type[0] == 's' || type[0] == 'l' || type[0] == 'q' )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else if ( type[0] == 'I' || type[0] == 'S' || type[0] == 'L' || type[0] == 'Q' )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else if ( type[0] == 'f' )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else if ( type[0] == 'd' )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else if ( type[0] == 'B' )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else if ( type[0] == 'v' )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else if ( type[0] == '*' )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else if ( type[0] == ':' )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else if ( 0 == strcmp(type, "bnum") )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else if ( type[0] == '^' )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else if ( type[0] == '?' )
		{
			return BeeTypeEncoding.UNKNOWN;
		}
		else
		{
			return BeeTypeEncoding.UNKNOWN;
		}
	}
	
	return BeeTypeEncoding.UNKNOWN;
}

+ (NSString *)classNameOf:(const char *)attr
{
	if ( attr[0] != 'T' )
		return nil;
	
	const char * type = &attr[1];
	if ( type[0] == '@' )
	{
		if ( type[1] != '"' )
			return nil;
		
		char typeClazz[128] = { 0 };
		
		const char * clazz = &type[2];
		const char * clazzEnd = strchr( clazz, '"' );
		
		if ( clazzEnd && clazz != clazzEnd )
		{
			unsigned int size = (unsigned int)(clazzEnd - clazz);
			strncpy( &typeClazz[0], clazz, size );
		}
		
		return [NSString stringWithUTF8String:typeClazz];
	}
	
	return nil;
}

@end

#pragma mark -

@implementation BeeRuntime

+ (id)allocByClass:(Class)clazz
{
	if ( nil == clazz )
		return nil;
	
	return [clazz alloc];	
}

+ (id)allocByClassName:(NSString *)clazzName
{
	if ( nil == clazzName || 0 == [clazzName length] )
		return nil;
	
	Class clazz = NSClassFromString( clazzName );
	if ( nil == clazz )
		return nil;
	
	return [clazz alloc];
}

+ (NSArray *)callstack:(NSUInteger)depth
{
	NSMutableArray * array = [[NSMutableArray alloc] init];
	
	void * stacks[MAX_CALLSTACK_DEPTH] = { 0 };

	depth = backtrace( stacks, (depth > MAX_CALLSTACK_DEPTH) ? MAX_CALLSTACK_DEPTH : depth );
	if ( depth )
	{
		char ** symbols = backtrace_symbols( stacks, depth );
		if ( symbols )
		{
			for ( int i = 0; i < depth; ++i )
			{
				NSString * symbol = [NSString stringWithUTF8String:(const char *)symbols[i]];
				if ( 0 == [symbol length] )
					continue;

				NSRange range1 = [symbol rangeOfString:@"["];
				NSRange range2 = [symbol rangeOfString:@"]"];

				if ( range1.length > 0 && range2.length > 0 )
				{
					NSRange range3;
					range3.location = range1.location;
					range3.length = range2.location + range2.length - range1.location;
					[array addObject:[symbol substringWithRange:range3]];
				}
				else
				{
					[array addObject:symbol];
				}					
			}

			free( symbols );
		}
	}
	
	return [array autorelease];
}

+ (NSArray *)callframes:(NSUInteger)depth
{
	NSMutableArray * array = [[NSMutableArray alloc] init];
	
	void * stacks[MAX_CALLSTACK_DEPTH] = { 0 };
	
	depth = backtrace( stacks, (depth > MAX_CALLSTACK_DEPTH) ? MAX_CALLSTACK_DEPTH : depth );
	if ( depth )
	{
		char ** symbols = backtrace_symbols( stacks, depth );
		if ( symbols )
		{
			for ( int i = 0; i < depth; ++i )
			{
				NSString * line = [NSString stringWithUTF8String:(const char *)symbols[i]];
				if ( 0 == [line length] )
					continue;

				BeeCallFrame * frame = [BeeCallFrame parse:line];
				if ( nil == frame )
					continue;
				
				[array addObject:frame];
			}
			
			free( symbols );
		}
	}
	
	return [array autorelease];
}

+ (void)printCallstack:(NSUInteger)depth
{
	NSArray * callstack = [self callstack:depth];
	if ( callstack && callstack.count )
	{
		VAR_DUMP( callstack );
	}
}

@end

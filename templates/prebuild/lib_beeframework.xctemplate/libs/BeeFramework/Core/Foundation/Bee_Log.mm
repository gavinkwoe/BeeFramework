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
//  Bee_Log.h
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

#import "Bee_Log.h"
#import "Bee_Sandbox.h"

#pragma mark -

#if defined(__BEE_LOG__) && __BEE_LOG__
static BOOL			__enabled = YES;
#else	// #if defined(__BEE_LOG__) && __BEE_LOG__
static BOOL			__enabled = NO;
#endif	// #if defined(__BEE_LOG__) && __BEE_LOG__

static BOOL			__firstLine = YES;
static NSUInteger	__indentTabs = 0;

extern "C" void BeeLogToogle( void )
{
	__enabled = __enabled ? NO : YES;
}

extern "C" void BeeLogEnable( BOOL flag )
{
	__enabled = flag;
}

extern "C" BOOL BeeLogIsEnabled( void )
{
	return __enabled;
}

extern "C" void BeeLogIndent( NSUInteger tabs )
{
	__indentTabs += tabs;
}

extern "C" void BeeLogUnindent( NSUInteger tabs )
{
	if ( __indentTabs < tabs )
	{
		__indentTabs = 0;
	}
	else
	{
		__indentTabs -= tabs;	
	}
}

extern "C" NSString * NSStringFormatted( NSString * format, va_list argList )
{
	return [[[NSString alloc] initWithFormat:format arguments:argList] autorelease];
}

extern "C" void BeeLog( NSObject * format, ... )
{
#if defined(__BEE_LOG__) && __BEE_LOG__

	if ( NO == __enabled || nil == format )
		return;

	if ( __firstLine )
	{
		fprintf( stderr, "    												\n" );
		fprintf( stderr, "    												\n" );
		fprintf( stderr, "    	 ______    ______    ______					\n" );
		fprintf( stderr, "    	/\\  __ \\  /\\  ___\\  /\\  ___\\			\n" );
		fprintf( stderr, "    	\\ \\  __<  \\ \\  __\\_ \\ \\  __\\_		\n" );
		fprintf( stderr, "    	 \\ \\_____\\ \\ \\_____\\ \\ \\_____\\		\n" );
		fprintf( stderr, "    	  \\/_____/  \\/_____/  \\/_____/			\n" );
		fprintf( stderr, "    												\n" );
		fprintf( stderr, "    	Copyright (c) 2013 BEE creators				\n" );
		fprintf( stderr, "    	Version %s									\n", BEE_VERSION );
		fprintf( stderr, "    												\n" );
		fprintf( stderr, "    	https://github.com/gavinkwoe/BeeFramework	\n" );
		fprintf( stderr, "    												\n" );
		fprintf( stderr, "    												\n" );
		fprintf( stderr, "    												\n" );
		
		__firstLine = NO;
	}
	
	va_list args;
	va_start( args, format );
	
	NSString * text = nil;
	NSString * tabs = nil;
	
	if ( __indentTabs )
	{
		tabs = [NSMutableString string];
		
		for ( int i = 0; i < __indentTabs; ++i )
		{
			[(NSMutableString *)tabs appendString:@"\t"];
		}
	}
	else
	{
		tabs = @"";
	}
	
	if ( [format isKindOfClass:[NSString class]] )
	{
		text = [NSString stringWithFormat:@"Bee >   %@%@", tabs, NSStringFormatted((NSString *)format, args)];
	}
	else
	{
		text = [NSString stringWithFormat:@"Bee >   %@%@", tabs, [format description]];
	}

	if ( [text rangeOfString:@"\n"].length )
	{
		text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
	}

	fprintf( stderr, [text UTF8String], NULL );
	fprintf( stderr, "\n", NULL );

	va_end( args );
	
#endif	// #if defined(__BEE_LOG__) && __BEE_LOG__
}

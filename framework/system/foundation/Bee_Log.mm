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

#import "Bee_Log.h"
#import "Bee_UnitTest.h"
#import "Bee_Sandbox.h"
#import "NSArray+BeeExtension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	MAX_BACKLOG
#define MAX_BACKLOG	(50)

#pragma mark -

@implementation BeeBacklog

@synthesize level = _level;
@synthesize time = _time;
@synthesize text = _text;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.level = BeeLogLevelNone;
		self.time = [NSDate date];
		self.text = nil;
	}
	return self;
}

- (void)dealloc
{
	self.time = nil;
	self.text = nil;
	
	[super dealloc];
}

@end

#pragma mark -

@interface BeeLogger()
{
	BOOL				_enabled;
	BOOL				_backlog;
	NSMutableArray *	_backlogs;
	NSUInteger			_indentTabs;
}
@end

#pragma mark -

@implementation BeeLogger

DEF_SINGLETON( BeeLogger );

@synthesize enabled = _enabled;
@synthesize backlog = _backlog;
@synthesize backlogs = _backlogs;
@synthesize indentTabs = _indentTabs;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.enabled = YES;
		self.backlog = YES;
		self.backlogs = [NSMutableArray array];
		self.indentTabs = 0;
	}
	return self;
}

- (void)dealloc
{
	self.backlogs = nil;
	
	[super dealloc];
}

- (void)toggle
{
	_enabled = _enabled ? NO : YES;
}

- (void)enable
{
	_enabled = YES;
}

- (void)disable
{
	_enabled = YES;
}

- (void)indent
{
	_indentTabs += 1;
}

- (void)indent:(NSUInteger)tabs
{
	_indentTabs += tabs;
}

- (void)unindent
{
	if ( _indentTabs > 0 )
	{
		_indentTabs -= 1;
	}
}

- (void)unindent:(NSUInteger)tabs
{
	if ( _indentTabs < tabs )
	{
		_indentTabs = 0;
	}
	else
	{
		_indentTabs -= tabs;
	}
}

- (void)level:(BeeLogLevel)level format:(NSString *)format, ...
{
#if (__ON__ == __BEE_LOG__)
	
	if ( nil == format || NO == [format isKindOfClass:[NSString class]] )
		return;

	va_list args;
	va_start( args, format );
	
	[self level:level format:format args:args];

	va_end( args );
	
#endif	// #if (__ON__ == __BEE_LOG__)
}

- (void)level:(BeeLogLevel)level format:(NSString *)format args:(va_list)args
{
#if (__ON__ == __BEE_LOG__)
	
	if ( NO == _enabled )
		return;
	
	// formatting
	
	NSString * prefix = nil;
	
	if ( BeeLogLevelInfo == level )
	{
		prefix = @"INFO";
	}
	else if ( BeeLogLevelPerf == level )
	{
		prefix = @"PERF";
	}
	else if ( BeeLogLevelWarn == level )
	{
		prefix = @"WARN";
	}
	else if ( BeeLogLevelError == level )
	{
		prefix = @"ERROR";
	}
	
	if ( prefix )
	{
		prefix = [NSString stringWithFormat:@"[%@]", prefix];
		prefix = [prefix stringByPaddingToLength:8 withString:@" " startingAtIndex:0];
	}
	
	NSMutableString * tabs = nil;
	NSMutableString * text = nil;
	
	if ( _indentTabs > 0 )
	{
		tabs = [NSMutableString string];
		
		for ( int i = 0; i < _indentTabs; ++i )
		{
			[tabs appendString:@"\t"];
		}
	}
	
	text = [NSMutableString string];
	
	if ( prefix && prefix.length )
	{
		[text appendString:prefix];
	}
	
	if ( tabs && tabs.length )
	{
		[text appendString:tabs];
	}
	
	if ( BeeLogLevelProgress == level )
	{
		NSString *	name = [format stringByPaddingToLength:32 withString:@" " startingAtIndex:0];
		NSString *	state = va_arg( args, NSString * );
		
		[text appendFormat:@"%@\t\t\t\t[%@]", name, state];
	}
	else
	{
		NSString * content = [[[NSString alloc] initWithFormat:(NSString *)format arguments:args] autorelease];
		if ( content && content.length )
		{
			[text appendString:content];
		}
	}
	
	if ( [text rangeOfString:@"\n"].length )
	{
		[text replaceOccurrencesOfString:@"\n"
							  withString:[NSString stringWithFormat:@"\n%@", tabs ? tabs : @"\t\t"]
								 options:NSCaseInsensitiveSearch
								   range:NSMakeRange( 0, text.length )];
	}
	
	// print to console
	
	fprintf( stderr, [text UTF8String], NULL );
	fprintf( stderr, "\n", NULL );
	
	// back log
	
	if ( _backlog )
	{
		BeeBacklog * log = [[[BeeBacklog alloc] init] autorelease];
		log.level = level;
		log.text = text;
		
		[_backlogs pushTail:log];
		[_backlogs keepTail:MAX_BACKLOG];
	}
	
#endif	// #if (__ON__ == __BEE_LOG__)
}

@end

extern "C" void BeeLog( NSString * format, ... )
{
#if (__ON__ == __BEE_LOG__)
	
	if ( nil == format || NO == [format isKindOfClass:[NSString class]] )
		return;
	
	va_list args;
	va_start( args, format );
	
	[[BeeLogger sharedInstance] level:BeeLogLevelInfo format:format args:args];
	
	va_end( args );
	
#endif	// #if (__ON__ == __BEE_LOG__)
}

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeLog )
{
	TIMES( 3 )
	{
		HERE( "output log", {
			CC( nil );
			CC( @"" );
			CC( @"format %@", @"" );
		});
		
		HERE( "test info", {
			INFO( nil );
			INFO( nil, nil );
			INFO( nil, @"" );
			INFO( nil, @"format %@", @"" );
			
			INFO( @"a", nil );
			INFO( @"a", @"" );
			INFO( @"a", @"format %@", @"" );
		});

		HERE( "test warn", {
			WARN( nil );
			WARN( nil, nil );
			WARN( nil, @"" );
			WARN( nil, @"format %@", @"" );

			WARN( @"a", nil );
			WARN( @"a", @"" );
			WARN( @"a", @"format %@", @"" );
		});
		
		HERE( "test error", {
			ERROR( nil );
			ERROR( nil, nil );
			ERROR( nil, @"" );
			ERROR( nil, @"format %@", @"" );
			
			ERROR( @"a", nil );
			ERROR( @"a", @"" );
			ERROR( @"a", @"format %@", @"" );
		});
	}
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

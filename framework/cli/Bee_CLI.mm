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

#import "Bee_CLI.h"

#if (TARGET_OS_MAC)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( BeePackage, BeeCLI, cli );

#pragma mark -

@interface BeeCLI()
{
	NSString *			_color;
	BOOL				_autoChangeBack;

	NSString *			_workingDirectory;
	NSString *			_execPath;
	NSString *			_execName;
	NSMutableArray *	_arguments;
}
@end

#pragma mark -

@implementation BeeCLI

DEF_SINGLETON( BeeCLI );

@dynamic ECHO;
@dynamic LINE;

@dynamic NO_COLOR;

@dynamic RED;
@dynamic BLUE;
@dynamic CYAN;
@dynamic GREEN;
@dynamic YELLOW;

@dynamic LIGHT_RED;
@dynamic LIGHT_BLUE;
@dynamic LIGHT_CYAN;
@dynamic LIGHT_GREEN;
@dynamic LIGHT_YELLOW;

@synthesize color = _color;
@synthesize autoChangeBack = _autoChangeBack;

@synthesize workingDirectory = _workingDirectory;
@synthesize execPath = _execPath;
@synthesize execName = _execName;
@synthesize arguments = _arguments;

+ (BOOL)autoLoad
{
	[BeeCLI sharedInstance];
	return YES;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		char	buff[256] = { 0 };
		char *	result = getcwd( buff, 256 - 1 );
		
		if ( result )
		{
			self.workingDirectory = [NSString stringWithUTF8String:buff];
		}
		
		self.arguments = [NSMutableArray array];
		self.autoChangeBack = YES;
	}
	return self;
}

- (void)dealloc
{
	self.workingDirectory = nil;
	self.execPath = nil;
	self.execName = nil;
	self.arguments = nil;
	
	self.color = nil;
	
	[super dealloc];
}

- (BeeCLIBlockN)ECHO
{
	BeeCLIBlockN block = ^ BeeCLI * ( id first, ... )
	{
		va_list args;
		va_start( args, first );

		if ( first && [first isKindOfClass:[NSString class]] )
		{
		#if (TARGET_OS_MAC)
			if ( self.color )
			{
				fprintf( stderr, "%s", [self.color UTF8String] );
			}
		#endif	// #if (TARGET_OS_MAC)

			NSString * text = [[NSString alloc] initWithFormat:(NSString *)first arguments:args];
			fprintf( stderr, "%s", [text UTF8String] );
			[text release];
		}

	#if (TARGET_OS_MAC)
		if ( self.color )
		{
			if ( self.autoChangeBack )
			{
				fprintf( stderr, "\e[0m" );
			}
		}
	#endif	// #if (TARGET_OS_MAC)

		va_end( args );

		if ( self.autoChangeBack )
		{
			self.color = nil;
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeCLIBlockN)LINE
{
	BeeCLIBlockN block = ^ BeeCLI * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		if ( first && [first isKindOfClass:[NSString class]] )
		{
#if (TARGET_OS_MAC)
			if ( self.color )
			{
				fprintf( stderr, "%s", [self.color UTF8String] );
			}
#endif	// #if (TARGET_OS_MAC)
			
			NSString * text = [[NSString alloc] initWithFormat:(NSString *)first arguments:args];
			fprintf( stderr, "%s", [text UTF8String] );
			[text release];
		}
		
#if (TARGET_OS_MAC)
		if ( self.color )
		{
			if ( self.autoChangeBack )
			{
				fprintf( stderr, "\e[0m" );
			}
		}
#endif	// #if (TARGET_OS_MAC)
		
		va_end( args );
		
		if ( self.autoChangeBack )
		{
			self.color = nil;
		}
		
		fprintf( stderr, "\n" );
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeCLIBlock)NO_COLOR
{
	BeeCLIBlock block = ^ BeeCLI * ( void )
	{
		self.color = @"\e[0m";
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeCLIBlock)RED
{
	BeeCLIBlock block = ^ BeeCLI * ( void )
	{
		self.color = @"\e[0;31m";
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeCLIBlock)BLUE
{
	BeeCLIBlock block = ^ BeeCLI * ( void )
	{
		self.color = @"\e[0;34m";
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeCLIBlock)CYAN
{
	BeeCLIBlock block = ^ BeeCLI * ( void )
	{
		self.color = @"\e[0;36m";
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeCLIBlock)GREEN
{
	BeeCLIBlock block = ^ BeeCLI * ( void )
	{
		self.color = @"\e[0;32m";
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeCLIBlock)YELLOW
{
	BeeCLIBlock block = ^ BeeCLI * ( void )
	{
		self.color = @"\e[0;33m";
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeCLIBlock)LIGHT_RED
{
	BeeCLIBlock block = ^ BeeCLI * ( void )
	{
		self.color = @"\e[1;31m";
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeCLIBlock)LIGHT_BLUE
{
	BeeCLIBlock block = ^ BeeCLI * ( void )
	{
		self.color = @"\e[1;34m";
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeCLIBlock)LIGHT_CYAN
{
	BeeCLIBlock block = ^ BeeCLI * ( void )
	{
		self.color = @"\e[1;36m";
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeCLIBlock)LIGHT_GREEN
{
	BeeCLIBlock block = ^ BeeCLI * ( void )
	{
		self.color = @"\e[1;32m";
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeCLIBlock)LIGHT_YELLOW
{
	BeeCLIBlock block = ^ BeeCLI * ( void )
	{
		self.color = @"\e[1;33m";
		return self;
	};

	return [[block copy] autorelease];
}

- (void)argc:(int)argc argv:(const char * [])argv
{
	if ( 0 == argc )
		return;
	
	NSString * exec = [NSString stringWithUTF8String:argv[0]];
	
	self.execPath = [exec stringByDeletingLastPathComponent];
	self.execName = [exec lastPathComponent];
	self.arguments = [NSMutableArray array];
	
	for ( NSUInteger i = 1; i < argc; ++i )
	{
		NSString * arg = [NSString stringWithUTF8String:argv[i]];
		
		[_arguments addObject:arg];
	}
}

- (NSString *)pathArgumentAtIndex:(NSUInteger)index
{
	if ( index >= self.arguments.count )
		return nil;

	NSString * currentPath = self.workingDirectory;
	NSString * fullPath = [self.arguments objectAtIndex:index];

	if ( NO == [currentPath hasSuffix:@"/"] )
	{
		currentPath = [currentPath stringByAppendingString:@"/"];
	}

	if ( NSNotFound == [fullPath rangeOfString:@"/"].location )
	{
		fullPath = [NSString stringWithFormat:@"./%@", fullPath];
	}
	
	NSString * resultFile = [fullPath lastPathComponent].trim.unwrap;
	NSString * resultPath = fullPath;
	
	resultPath = [resultPath stringByReplacingOccurrencesOfString:resultFile withString:@""];
	resultPath = [resultPath stringByReplacingOccurrencesOfString:@"~" withString:NSHomeDirectory()];
	resultPath = [resultPath stringByReplacingOccurrencesOfString:@"./" withString:currentPath];
	resultPath = [resultPath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
	resultPath = resultPath.trim.unwrap;

	return resultPath;
}

- (NSString *)fileArgumentAtIndex:(NSUInteger)index
{
	if ( index >= self.arguments.count )
		return nil;
	
	NSString * fullPath = [self.arguments objectAtIndex:index];
	NSString * resultPath = [self pathArgumentAtIndex:index];
	NSString * resultFile = [fullPath lastPathComponent].trim.unwrap;
	
	return [resultPath stringByAppendingString:resultFile];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeCLI )
{
	// TODO:
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#endif	// #if (TARGET_OS_MAC)

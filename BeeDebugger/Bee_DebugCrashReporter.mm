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
//  Bee_DebugCrashReporter.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__
#if defined(__BEE_CRASHLOG__) && __BEE_CRASHLOG__

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

#import <signal.h>
#import <unistd.h>
#import <objc/runtime.h>

#import "Bee_DebugCrashReporter.h"
#import "Bee_Sandbox.h"
#import "Bee_Log.h"
#import "Bee_Runtime.h"
#import "NSDate+BeeExtension.h"
#import "NSNumber+BeeExtension.h"

#import "JSONKit.h"

#pragma mark -

@interface BeeDebugCrashReporter(Private)
- (void)installSignal:(int)signal;
- (void)saveException:(NSException *)exception;
- (void)saveSignal:(int)signal info:(siginfo_t *)info;
- (void)saveInfo:(NSDictionary *)dict;
@end

#pragma mark -

@implementation BeeDebugCrashReporter

@synthesize installed = _installed;
@synthesize logPath = _logPath;

DEF_SINGLETON( BeeDebugCrashReporter )

static void signalHandler( int signal )
{
	[[BeeDebugCrashReporter sharedInstance] saveSignal:signal info:NULL];

	raise( signal );
}

static void exceptionHandler( NSException * exception )
{
	[[BeeDebugCrashReporter sharedInstance] saveException:exception];
	
	abort();
}

- (void)saveException:(NSException *)exception
{
	NSMutableDictionary * detail = [NSMutableDictionary dictionary];
	if ( exception.name )
	{
		[detail setObject:exception.name forKey:@"name"];
	}
	if ( exception.reason )
	{
		[detail setObject:exception.reason forKey:@"reason"];
	}
	if ( exception.userInfo )
	{
		[detail setObject:exception.userInfo forKey:@"userInfo"];
	}
	if ( exception.callStackSymbols )
	{
		[detail setObject:exception.callStackSymbols forKey:@"callStack"];
	}

	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	[dict setObject:@"exception" forKey:@"type"];
	[dict setObject:__INT(0) forKey:@"code"];
	[dict setObject:detail forKey:@"info"];
	
	[self saveInfo:dict];
}

- (void)saveSignal:(int)signal info:(siginfo_t *)info
{
	NSArray * stack = [BeeRuntime callstack:32];

	NSMutableDictionary * detail = [NSMutableDictionary dictionary];
	[detail setObject:stack forKey:@"callStack"];

	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	[dict setObject:@"signal" forKey:@"type"];
	[dict setObject:__INT(signal) forKey:@"code"];
	[dict setObject:detail forKey:@"info"];

	[self saveInfo:dict];
}

- (void)saveInfo:(NSDictionary *)dict
{
	NSString * fileName = [[NSDate date] stringWithDateFormat:@"yyyyMMdd_HHmmss"];
	NSString * fullName = [self.logPath stringByAppendingString:fileName];

	NSError * error = nil;
	BOOL succeed = [[dict JSONData] writeToFile:fullName options:NSDataWritingAtomic error:&error];
	if ( NO == succeed )
	{
		CC( [error description] );
	}
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.logPath = [NSString stringWithFormat:@"%@/BeeCrashLog/", [BeeSandbox libCachePath]];

		if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:self.logPath] )
		{
			[[NSFileManager defaultManager] createDirectoryAtPath:self.logPath
									  withIntermediateDirectories:YES
													   attributes:nil
															error:NULL];
		}
	}
	return self;
}

- (void)dealloc
{
	[_logPath release];
	
	signal( SIGABRT,	SIG_DFL );
	signal( SIGBUS,		SIG_DFL );
	signal( SIGFPE,		SIG_DFL );
	signal( SIGILL,		SIG_DFL );
	signal( SIGPIPE,	SIG_DFL );
	signal( SIGSEGV,	SIG_DFL );
	
	[super dealloc];
}

- (void)install
{
	if ( _installed )
		return;
	
	signal( SIGABRT,	&signalHandler );
    signal( SIGBUS,		&signalHandler );
    signal( SIGFPE,		&signalHandler );
    signal( SIGILL,		&signalHandler );
    signal( SIGPIPE,	&signalHandler );
    signal( SIGSEGV,	&signalHandler );

	NSSetUncaughtExceptionHandler( &exceptionHandler );
}

@end

#endif	// #if defined(__BEE_CRASHLOG__) && __BEE_CRASHLOG__
#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

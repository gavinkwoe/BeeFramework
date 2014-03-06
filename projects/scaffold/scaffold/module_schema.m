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

#import "module_schema.h"

#import "SchemaGenerator.h"
#import "SchemaServer.h"

#pragma mark -

@implementation module_schema

+ (NSString *)command
{
	return @"schema";
}

+ (void)usage
{
	bee.cli.LINE( nil );
	bee.cli.LINE( @"type 'bee schema build my.json'" );
	bee.cli.LINE( @"type 'bee schema build my.json ~/Desktop'" );
	bee.cli.LINE( nil );
	bee.cli.LINE( @"type 'bee schema test server my.json'" );
	bee.cli.LINE( @"type 'bee server test my.json 3000'" );
	bee.cli.LINE( nil );
}

+ (void)schema_build
{
	if ( bee.cli.arguments.count < 3 )
	{
		[self usage];
		return;
	}

	NSString * inputPath = [bee.cli fileArgumentAtIndex:2];
	NSString * outputPath = [bee.cli pathArgumentAtIndex:3];

	if ( nil == inputPath )
	{
		[self usage];
		return;
	}
	
	if ( nil == outputPath )
	{
		outputPath = inputPath;
	}
	
	SchemaGenerator * generator = [[[SchemaGenerator alloc] init] autorelease];
	generator.inputPath = [inputPath stringByDeletingLastPathComponent];
	generator.inputFile = [inputPath lastPathComponent];
	generator.outputPath = [outputPath stringByDeletingLastPathComponent];
	
	BOOL succeed = [generator generate];
	if ( NO == succeed )
	{
		if ( generator.errorLine )
		{
			bee.cli.RED().LINE( nil );
			bee.cli.RED().LINE( @"line #%d: %@", generator.errorLine, generator.errorDesc );
			bee.cli.RED().LINE( nil );
		}
		else
		{
			bee.cli.RED().LINE( nil );
			bee.cli.RED().LINE( @"%@", generator.errorDesc );
			bee.cli.RED().LINE( nil );
		}
	}
	else
	{
		for ( NSString * file in generator.results )
		{
			bee.cli.ECHO( @"%@", file );
			bee.cli.GREEN().LINE( @"\tDONE" );
		}
		
		bee.cli.GREEN().LINE( nil );
		bee.cli.GREEN().LINE( @"Total %d file(s) generated", generator.results.count );
		bee.cli.GREEN().LINE( nil );
	}
}

+ (void)schema_test
{
	if ( bee.cli.arguments.count < 3 )
	{
		[self usage];
		return;
	}

	NSString * inputPath = [bee.cli fileArgumentAtIndex:2];
	if ( nil == inputPath )
	{
		[self usage];
		return;
	}
	
	NSString * port = [bee.cli.arguments safeObjectAtIndex:3];

	SchemaServer * server = [[[SchemaServer alloc] init] autorelease];
	server.inputPath = [inputPath stringByDeletingLastPathComponent];
	server.inputFile = [inputPath lastPathComponent];
	server.port = port ? [port intValue] : 3000;

	BOOL succeed = [server start];
	if ( NO == succeed )
	{
		if ( server.errorLine )
		{
			bee.cli.RED().LINE( nil );
			bee.cli.RED().LINE( @"line #%d: %@", server.errorLine, server.errorDesc );
			bee.cli.RED().LINE( nil );
		}
		else
		{
			bee.cli.RED().LINE( nil );
			bee.cli.RED().LINE( @"%@", server.errorDesc );
			bee.cli.RED().LINE( nil );
		}
	}
	else
	{
		bee.cli.GREEN().LINE( nil );
		bee.cli.GREEN().LINE( @"Running..." );
		bee.cli.CYAN().LINE( nil );
		bee.cli.CYAN().LINE( @"Try to access 'http://localhost:%d'", server.port );
		bee.cli.CYAN().LINE( nil );

		CFRunLoopRun();
	}
}

+ (BOOL)execute
{
	NSString * command1 = [bee.cli.arguments objectAtIndex:0];
	NSString * command2 = [bee.cli.arguments objectAtIndex:1];

	if ( [command2 isEqualToString:@"build"] )
	{
		[self schema_build];
		
		return YES;
	}
	else if ( [command2 isEqualToString:@"test"] )
	{
		[self schema_test];
		
		return YES;
	}

	return NO;
}

@end

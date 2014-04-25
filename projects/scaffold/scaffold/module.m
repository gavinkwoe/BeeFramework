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

#import "module.h"

#import "module_help.h"
#import "module_project.h"
#import "module_schema.h"
#import "module_version.h"

#pragma mark -

@implementation module

+ (NSString *)command
{
	return nil;
}

+ (void)usage
{
	[module_help execute];
}

+ (BOOL)execute
{
	if ( bee.cli.arguments.count == 0 )
	{
		[self usage];
		return NO;
	}
	
	BOOL		handled = NO;
	NSString *	command = bee.cli.arguments[0];
	NSArray *	classes = [BeeRuntime allSubClassesOf:[module class]];
	
	for ( Class classType in classes )
	{
		NSString * moduleCommand = [classType command];
		if ( moduleCommand && [moduleCommand isEqualToString:command] )
		{
			handled = [classType execute];
			if ( handled )
			{
				return YES;
			}
		}
	}
	
	if ( NO == handled )
	{
		[self usage];
	}
	
	return NO;
}

@end

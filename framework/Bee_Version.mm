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

#import "Bee_Version.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( BeePackage, BeeVersion, ver );

#pragma mark -

@interface BeeVersion()
{
	NSUInteger	_major;
	NSUInteger	_minor;
	NSUInteger	_tiny;
	NSString *	_pre;
}
@end

#pragma mark -

@implementation BeeVersion

DEF_SINGLETON( BeeVersion )

@synthesize major = _major;
@synthesize minor = _minor;
@synthesize tiny = _tiny;
@synthesize pre = _pre;

+ (BOOL)autoLoad
{
	[BeeVersion sharedInstance];

	return YES;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		NSArray * array = [BEE_VERSION componentsSeparatedByString:@" "];
		if ( array.count > 0 )
		{
			if ( array.count > 1 )
			{
				_pre = [[array objectAtIndex:1] retain];
			}
			else
			{
				_pre = [@"" retain];
			}
			
			NSArray * subvers = [[array objectAtIndex:0] componentsSeparatedByString:@"."];
			if ( subvers.count >= 1 )
			{
				_major = [[subvers objectAtIndex:0] intValue];
			}
			if ( subvers.count >= 2 )
			{
				_minor = [[subvers objectAtIndex:1] intValue];
			}
			if ( subvers.count >= 3 )
			{
				_tiny = [[subvers objectAtIndex:2] intValue];
			}
		}
	}
	return self;
}

- (void)dealloc
{
	[_pre release];
	
	[super dealloc];
}

@end

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

#import "Bee_HTTPWorkflow2.h"
#import "Bee_HTTPWorklet2.h"

#pragma mark -

@interface BeeHTTPWorkflow2()
{
	NSMutableArray *		_worklets;
	BeeHTTPConnection2 *	_connection;
}
@end

#pragma mark -

@implementation BeeHTTPWorkflow2

@synthesize worklets = _worklets;
@synthesize connection = _connection;

static NSMutableArray * __stack = nil;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.connection = nil;
		self.worklets = [NSMutableArray array];
		
		NSArray * workletClasses = [BeeRuntime allSubClassesOf:[BeeHTTPWorklet2 class]];
		if ( workletClasses && workletClasses.count )
		{
			for ( Class workletClass in workletClasses )
			{
				BeeHTTPWorklet2 * worklet = [workletClass worklet];
				if ( worklet )
				{
					[self.worklets addObject:worklet];
				}
			}
		}

		[self.worklets sortUsingComparator:^ NSComparisonResult (id obj1, id obj2) {
			BeeHTTPWorklet2 * left = obj1;
			BeeHTTPWorklet2 * right = obj2;
			return (left.prio < right.prio) ? NSOrderedAscending : ((left.prio > right.prio) ? NSOrderedDescending : NSOrderedSame);
		}];
		
		[self performLoad];
	}
	return self;
}

- (void)dealloc
{
	[self performUnload];
	
	self.connection = nil;
	self.worklets = nil;

	[super dealloc];
}

+ (BeeHTTPWorkflow2 *)processingWorkflow
{
	if ( nil == __stack )
	{
		return nil;
	}
	
	return __stack.lastObject;
}

+ (BOOL)process:(BeeHTTPConnection2 *)conn
{
	if ( nil == __stack )
	{
		__stack = [NSMutableArray nonRetainingArray];
	}

	BeeHTTPWorkflow2 * workflow = [[[BeeHTTPWorkflow2 alloc] init] autorelease];
	if ( workflow )
	{
		[__stack addObject:workflow];
		
		workflow.connection = conn;
		[workflow process];

		[__stack removeLastObject];
	}
	
	return YES;
}

- (BOOL)process
{
	BOOL succeed = NO;

	INFO( @"Start workflow" );

	for ( BeeHTTPWorklet2 * worklet in self.worklets )
	{
		succeed = [worklet processWithWorkflow:self];
		if ( succeed )
		{
			INFO( @"	-> '%@', OK", worklet.name );
		}
		else
		{
			ERROR( @"	-> '%@', FAILED", worklet.name );
		}
	}

	INFO( @"End workflow" );

	return succeed;
}

@end

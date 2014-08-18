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

#import "Bee_Routine.h"
#import "Bee_MessageQueue.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation BeeRoutine

@synthesize userObject = _userObject;

+ (id)routine
{
	return [[[self alloc] init] autorelease];
}

+ (id)routineWithResponder:(id)responder
{
	BeeRoutine * routine = [[[self alloc] init] autorelease];
	routine.responder = responder;
	return routine;
}

+ (id)allocWithResponder:(id)responder
{
	BeeRoutine * routine = [[self alloc] init];
	routine.responder = responder;
	return routine;
}

+ (id)api
{
	return [self routineWithResponder:nil];
}

+ (id)apiWithResponder:(id)responder
{
	return [self routineWithResponder:responder];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.executable = YES;
		self.executer = self;
		self.userObject = nil;
		self.message = [[self class] description];
	}
	return self;
}

- (void)dealloc
{
	self.userObject = nil;
	
	[super dealloc];
}

- (void)index:(BeeMessage *)msg
{
}

- (void)route:(BeeMessage *)msg
{
	if ( msg == self )
	{
		[self routine];
	}
}

+ (BOOL)sending
{
	for ( BeeMessage * msg in [BeeMessageQueue sharedInstance].allMessages )
	{
		if ( [msg isKindOfClass:self] )
		{
			return msg.sending;
		}
	}
	
	return NO;
}

+ (BOOL)cancel
{
	NSMutableArray * msgs = [NSMutableArray nonRetainingArray];// TODO:
	
	for ( BeeMessage * msg in [BeeMessageQueue sharedInstance].allMessages )
	{
		if ( [msg isKindOfClass:self] )
		{
			[msgs addObject:msg];
		}
	}
	
	for ( BeeMessage * msg in msgs )
	{
		[msg cancel];
	}

	return msgs.count ? YES : NO;
}

+ (BOOL)cancel:(id)target
{
//	NSMutableArray * msgs = [NSMutableArray nonRetainingArray];
	NSMutableArray * msgs = [NSMutableArray array];
	
	for ( BeeMessage * msg in [BeeMessageQueue sharedInstance].allMessages )
	{
		if ( [msg isKindOfClass:self] && msg.responder == target )
		{
			[msgs addObject:msg];
		}
	}

	for ( BeeMessage * msg in msgs )
	{
		[msg cancel];
	}

	return msgs.count ? YES : NO;
}

- (void)routine
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( BeeRoutine )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

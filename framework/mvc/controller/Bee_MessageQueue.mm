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

#import "Bee_Package.h"
#import "Bee_MessageQueue.h"
#import "Bee_Message.h"

#import "Bee_HTTPRequestQueue.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	DEFAULT_RUNLOOP_INTERVAL
#define	DEFAULT_RUNLOOP_INTERVAL	(0.01f)

#pragma mark -

@interface BeeMessageQueue()
{
	BeeMessageQueueBlock	_whenCreate;
	BeeMessageQueueBlock	_whenUpdate;
	
	NSTimer *				_timer;
	BOOL					_pause;
}

- (void)runloop;

@end

#pragma mark -

@implementation BeeMessageQueue

static NSMutableArray * __sharedQueue = nil;

@synthesize whenCreate = _whenCreate;
@synthesize	whenUpdate = _whenUpdate;
@synthesize timer = _timer;
@synthesize pause = _pause;

DEF_SINGLETON( BeeMessageQueue );

- (NSArray *)messages
{
	return __sharedQueue;
}

- (NSArray *)allMessages
{
	return __sharedQueue;
}

- (NSArray *)pendingMessages
{
	NSMutableArray * array = [NSMutableArray array];
	
    NSArray * queued = [[NSArray alloc] initWithArray:__sharedQueue];
    
	for ( BeeMessage * bmsg in queued )
	{
		if ( bmsg.created )
		{
			[array addObject:bmsg];
		}
	}
    
    [queued release];
	
	return array;
}

- (NSArray *)sendingMessages
{
	NSMutableArray * array = [NSMutableArray array];
	
    NSArray * queued = [[NSArray alloc] initWithArray:__sharedQueue];
    
	for ( BeeMessage * msg in queued )
	{
		if ( msg.sending )
		{
			[array addObject:msg];
		}
	}
    
    [queued release];
	
	return array;
}

- (NSArray *)finishedMessages
{
	NSMutableArray * array = [NSMutableArray array];
	
    NSArray * queued = [[NSArray alloc] initWithArray:__sharedQueue];
    
	for ( BeeMessage * bmsg in queued )
	{
		if ( bmsg.succeed || bmsg.failed || bmsg.cancelled )
		{
			[array addObject:bmsg];
		}
	}
    
    [queued release];

	return array;	
}

- (NSArray *)messages:(NSString *)msgName
{
	if ( nil == msgName )
	{
		return __sharedQueue;
	}
	else
	{
		NSMutableArray * array = [NSMutableArray array];

        NSArray * queued = [[NSArray alloc] initWithArray:__sharedQueue];
        
		for ( BeeMessage * msg in queued )
		{
			if ( [msg.message isEqual:msgName] )
			{
				[array addObject:msg];
			}
		}
        
        [queued release];
		
		return array;
	}
}

- (NSArray *)messagesInSet:(NSArray *)msgNames
{
	NSMutableArray * array = [NSMutableArray array];
	
    NSArray * queued = [[NSArray alloc] initWithArray:__sharedQueue];
    
	for ( BeeMessage * msg in queued )
	{
		for ( NSString * msgName in msgNames )
		{
			if ( [msg.message isEqual:msgName] )
			{
				[array addObject:msg];
				break;
			}			
		}		
	}
    
    [queued release];
	
	return array;
}

- (NSArray *)messagesByResponder:(id)responder
{
	NSMutableArray * array = [NSMutableArray array];
	
    NSArray * queued = [[NSArray alloc] initWithArray:__sharedQueue];
    
	for ( BeeMessage * msg in queued )
	{
		if ( msg.responder == responder )
		{
			[array addObject:msg];
			break;
		}
	}
    
    [queued release];
	
	return array;	
}

- (BOOL)sendMessage:(BeeMessage *)msg
{
	if ( [__sharedQueue containsObject:msg] )
		return NO;

	if ( msg.sending )
		return NO;
	
	if ( msg.unique )
	{
		for ( BeeMessage * inqueue in __sharedQueue )
		{
			if ( [inqueue isTwinWith:msg] )
				return NO;
		}			
	}

	[msg setSending:YES];

	[__sharedQueue addObject:msg];
	
	return YES;
}

- (void)removeMessage:(BeeMessage *)msg
{
	[__sharedQueue removeObject:msg];
}

- (void)cancelMessage:(NSString *)msg
{
	if ( nil == msg )
	{
		[BeeHTTPRequestQueue cancelAllRequests];

		[__sharedQueue removeAllObjects];
	}
	else
	{
		NSUInteger		count = [__sharedQueue count];
		BeeMessage *	bmsg;
		
		for ( NSUInteger i = count; i > 0; --i )
		{
			bmsg = [__sharedQueue safeObjectAtIndex:(i - 1)];
			if ( msg && NO == [msg isEqualToString:bmsg.message] )
				continue;
			
			[bmsg changeState:BeeMessage.STATE_CANCELLED];			
		}		
	}
}

- (BOOL)sending:(NSString *)msg
{
	if ( nil == msg )
	{
		return ([__sharedQueue count] > 0) ? YES : NO;
	}
	else
	{
		BeeMessage * bmsg = nil;

		NSUInteger count = [__sharedQueue count];		
		for ( NSUInteger i = count; i > 0; --i )
		{
			bmsg = [__sharedQueue safeObjectAtIndex:(i - 1)];
			if ( YES == [msg isEqualToString:bmsg.message] )
			{
				if ( bmsg.created || bmsg.sending )
				{
					return YES;
				}
				else
				{
					return NO;
				}
			}
		}

		return NO;
	}
}

- (BOOL)sending:(NSString *)msg byResponder:(id)responder
{
	BeeMessage * bmsg = nil;
	
	NSUInteger count = [__sharedQueue count];		
	for ( NSUInteger i = count; i > 0; --i )
	{
		bmsg = [__sharedQueue safeObjectAtIndex:(i - 1)];
		if ( responder && bmsg.responder != responder )
			continue;

		if ( nil == msg || [msg isEqualToString:bmsg.message] )
		{
			if ( bmsg.created || bmsg.sending || bmsg.waiting )
			{
				return YES;
			}
			else
			{
				return NO;
			}
		}
	}
	
	return NO;
}

- (void)enableResponder:(id)responder
{
	NSUInteger		count = [__sharedQueue count];
	BeeMessage *	bmsg;
	
	for ( NSUInteger i = count; i > 0; --i )
	{
		bmsg = [__sharedQueue safeObjectAtIndex:(i - 1)];
		if ( responder && bmsg.responder != responder )
			continue;
		
		bmsg.disabled = NO;
	}
}

- (void)disableResponder:(id)responder
{
	NSUInteger		count = [__sharedQueue count];
	BeeMessage *	bmsg;
	
	for ( NSUInteger i = count; i > 0; --i )
	{
		bmsg = [__sharedQueue safeObjectAtIndex:(i - 1)];
		if ( responder && bmsg.responder != responder )
			continue;
		
		bmsg.disabled = YES;
	}
}

- (void)cancelMessage:(NSString *)msg byResponder:(id)responder
{
	NSUInteger		count = [__sharedQueue count];
	BeeMessage *	bmsg;
	
	for ( NSUInteger i = count; i > 0; --i )
	{
		bmsg = [__sharedQueue safeObjectAtIndex:(i - 1)];
		if ( responder && bmsg.responder != responder )
			continue;
		
		if ( msg && NO == [msg isEqualToString:bmsg.message] )
			continue;
		
		[bmsg changeState:BeeMessage.STATE_CANCELLED];
	}
}

- (void)cancelMessages
{
	[BeeHTTPRequestQueue cancelAllRequests];

	[__sharedQueue removeAllObjects];
}

#pragma mark -

- (id)init
{
	self = [super init];
	if ( self )
	{
		if ( nil == __sharedQueue )
		{
			__sharedQueue = [[NSMutableArray alloc] init];
		}
		
		if ( nil == self.timer )
		{
			self.timer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_RUNLOOP_INTERVAL
														  target:self
														selector:@selector(runloop)
														userInfo:nil
														 repeats:YES];
		}
	}
	
	return self;
}

- (void)runloop
{
	if ( _pause )
		return;
	
    NSArray * queued = [[NSArray alloc] initWithArray:__sharedQueue];
    
	for ( BeeMessage * bmsg in queued )
	{
		[bmsg runloop];
	}
    
    [queued release];
}

- (void)dealloc
{		
	[_timer invalidate];
	_timer = nil;

	self.whenCreate = nil;
	self.whenUpdate = nil;
	
	[super dealloc];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( BeeMessageQueue )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

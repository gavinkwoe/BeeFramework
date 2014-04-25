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

#import "NSObject+BeeMessage.h"
#import "Bee_MessageQueue.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(BeeMessage)

@dynamic MSG;
@dynamic MSG_IF_NOT_SENDING;
@dynamic MSG_CANCEL_IF_SENDING;
@dynamic CANCEL_MSG;

- (BeeMessageBlockN)MSG
{
	BeeMessageBlockN block = ^ BeeMessage * ( id first, ... )
	{
		return [self sendMessage:(NSString *)first];
	};

	return [[block copy] autorelease];
}

- (BeeMessageBlockN)MSG_IF_NOT_SENDING
{
	BeeMessageBlockN block = ^ BeeMessage * ( id first, ... )
	{
		if ( [self sendingMessage:(NSString *)first] )
		{
			return [BeeMessage message];
		}
		else
		{
			return [self sendMessage:(NSString *)first];
		}
	};
	
	return [[block copy] autorelease];
}

- (BeeMessageBlockN)MSG_CANCEL_IF_SENDING
{
	BeeMessageBlockN block = ^ BeeMessage * ( id first, ... )
	{
		[self cancelMessage:(NSString *)first];
		
		return [self message:(NSString *)first];
	};
	
	return [[block copy] autorelease];
}

- (BeeMessageBlockN)CANCEL_MSG
{
	BeeMessageBlockN block = ^ BeeMessage * ( id first, ... )
	{
		[self cancelMessage:(NSString *)first];
		return nil;
	};
	
	return [[block copy] autorelease];
}

- (BOOL)sendingMessage:(NSString *)msg
{
	return [[BeeMessageQueue sharedInstance] sending:msg byResponder:self];
}

- (void)cancelMessage:(NSString *)msg
{
	[[BeeMessageQueue sharedInstance] cancelMessage:msg byResponder:self];
}

- (void)cancelMessages
{
	[[BeeMessageQueue sharedInstance] cancelMessage:nil byResponder:self];
}

- (BeeMessage *)message:(NSString *)msg
{
	return [self message:msg timeoutSeconds:0];
}

- (BeeMessage *)message:(NSString *)msg timeoutSeconds:(NSUInteger)seconds
{
	return [BeeMessage message:msg responder:self timeoutSeconds:seconds];
}

- (BeeMessage *)sendMessage:(NSString *)msg
{
	return [self sendMessage:msg timeoutSeconds:0];
}

- (BeeMessage *)sendMessage:(NSString *)msg timeoutSeconds:(NSUInteger)seconds
{
	return [[BeeMessage message:msg responder:self timeoutSeconds:seconds] send];
}

#pragma mark -

- (BOOL)prehandleMessage:(BeeMessage *)msg
{
	return YES;
}

- (void)posthandleMessage:(BeeMessage *)msg
{
	
}

- (void)handleMessage:(BeeMessage *)msg
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( NSObject_BeeMessage )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

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

#import "Bee_Reachability.h"
#import "Bee_HTTPRequestQueue.h"
#import "Reachability.h"

#import "NSObject+BeeNotification.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( BeePackage, BeeReachability, reachability );

#pragma mark -

@interface BeeReachability()
{
	Reachability *	_reach;
}

- (BOOL)isReachable;
- (BOOL)isReachableViaWIFI;
- (BOOL)isReachableViaWLAN;

@end

#pragma mark -

@implementation BeeReachability

DEF_SINGLETON( BeeReachability )

DEF_NOTIFICATION( WIFI_REACHABLE )
DEF_NOTIFICATION( WLAN_REACHABLE )
DEF_NOTIFICATION( UNREACHABLE )

DEF_NOTIFICATION( CHANGED )

@dynamic isReachable;
@dynamic isReachableViaWIFI;
@dynamic isReachableViaWLAN;

@dynamic localIP;
@dynamic publicIP;

+ (BOOL)autoLoad
{
	[BeeReachability sharedInstance];
	return YES;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[self observeNotification:kReachabilityChangedNotification];
		
		_reach = [[Reachability reachabilityWithHostName:@"www.apple.com"] retain];
		[_reach startNotifier];
	}
	return self;
}

- (void)dealloc
{
	[self unobserveAllNotifications];

	[_reach release];
	_reach = nil;

	[super dealloc];
}

+ (BOOL)isReachable
{
	return [[BeeReachability sharedInstance] isReachable];
}

- (BOOL)isReachable
{
	return [_reach isReachable];
}

+ (BOOL)isReachableViaWIFI
{
	return [[BeeReachability sharedInstance] isReachableViaWIFI];
}

- (BOOL)isReachableViaWIFI
{
    if ( NO == [_reach isReachable] )
    {
		return NO;
    }

	return [_reach isReachableViaWiFi];
}

+ (BOOL)isReachableViaWLAN
{
	return [[BeeReachability sharedInstance] isReachableViaWLAN];
}

- (BOOL)isReachableViaWLAN
{
    if ( NO == [_reach isReachable] )
    {
		return NO;
    }
	
	return [_reach isReachableViaWWAN];
}

+ (NSString *)localIP
{
	return [[BeeReachability sharedInstance] localIP];
}

- (NSString *)localIP
{
    NSString *			ipAddr = nil;
    struct ifaddrs *	addrs = NULL;

	int ret = getifaddrs( &addrs );
    if ( 0 == ret )
	{
        const struct ifaddrs * cursor = addrs;

        while ( cursor )
		{
            if ( AF_INET == cursor->ifa_addr->sa_family && 0 == (cursor->ifa_flags & IFF_LOOPBACK) )
            {
				ipAddr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
				break;
            }
			
            cursor = cursor->ifa_next;
        }

        freeifaddrs( addrs );
    }
	
    return ipAddr;
}

+ (NSString *)publicIP
{
	return [[BeeReachability sharedInstance] publicIP];
}

- (NSString *)publicIP
{
	return nil;
}

ON_NOTIFICATION( notification )
{
	if ( [notification is:kReachabilityChangedNotification] )
	{
		if ( NO == [_reach isReachable] )
		{
			[self postNotification:BeeReachability.UNREACHABLE];
		}
		else
		{
			if ( [_reach isReachableViaWiFi] )
			{
				[self postNotification:BeeReachability.WIFI_REACHABLE];
			}
			else if ( [_reach isReachableViaWWAN] )
			{
				[self postNotification:BeeReachability.WLAN_REACHABLE];
			}
		}
		
		[self postNotification:BeeReachability.CHANGED];
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeReachability )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

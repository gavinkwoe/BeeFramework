//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#ifdef __OBJC__

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

	#import <UIKit/UIKit.h>
	#import <Foundation/Foundation.h>
	#import <QuartzCore/QuartzCore.h>
	#import <AudioToolbox/AudioToolbox.h>
	#import <TargetConditionals.h>

	#import <AVFoundation/AVFoundation.h>
	#import <CoreGraphics/CoreGraphics.h>
	#import <CoreVideo/CoreVideo.h>
	#import <CoreMedia/CoreMedia.h>

#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

	#import <Foundation/Foundation.h>
	#import <Cocoa/Cocoa.h>
	#import <AppKit/AppKit.h>
	#import <WebKit/WebKit.h>

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <objc/runtime.h>
#import <objc/message.h>
#import <CommonCrypto/CommonDigest.h>

#endif	// #ifdef __OBJC__

// ----------------------------------
// Version
// ----------------------------------

#undef	BEE_VERSION
#define BEE_VERSION		@"0.4.0 β"

// ----------------------------------
// Option values
// ----------------------------------

#undef	__ON__
#define __ON__		(1)

#undef	__OFF__
#define __OFF__		(0)

#undef	__AUTO__

#ifdef _DEBUG
#define __AUTO__	(1)
#else	// #ifdef _DEBUG
#define __AUTO__	(0)
#endif	// #ifdef _DEBUG

// ----------------------------------
// Global compile option
// ----------------------------------

#define __BEE_DEVELOPMENT__			(__ON__)				// Whether the development model?

#define __BEE_LOG__					(__BEE_DEVELOPMENT__)	// Whether enable logging?
#define __BEE_ASSERT__				(__BEE_DEVELOPMENT__)	// Whether enable assertion?
#define __BEE_PERFORMANCE__			(__BEE_DEVELOPMENT__)	// Whether enable performance testing?
#define __BEE_UNITTEST__			(__OFF__)				// Whether enable unit testing?
#define __BEE_MOCKSERVER__			(__OFF__)				// Whether use mock server?
#define __BEE_WIREFRAME__			(__OFF__)				// -iOS- Whether show wireframe?

#define __BEE_SELECTOR_STYLE1__		(__ON__)				// handle_{ClassName}
#define __BEE_SELECTOR_STYLE2__		(__ON__)				// handle_{ClassName}_{MethodName}
#define __BEE_SELECTOR_STYLE3__		(__ON__)				// handle_{namespace}_{tag} or handle_{tag}
#define __BEE_SELECTOR_STYLE4__		(__ON__)				// handle_{signal}

#define __BEE_CONTROLLER_ROUTER1__	(__ON__)				// @implementation xxx DEF_MESSAGE( yyy )
#define __BEE_CONTROLLER_ROUTER2__	(__OFF__)				// TODO: [self map:/xxx/yyy]

// ----------------------------------
// Backward compatible
// ----------------------------------

#if defined(__BEE_LOG__) && __BEE_LOG__
#undef	NSLog
#define	NSLog	BeeLog
#endif	// #if (__ON__ == __BEE_LOG__)

#ifdef __IPHONE_6_0

	#define UILineBreakModeWordWrap			NSLineBreakByWordWrapping
	#define UILineBreakModeCharacterWrap	NSLineBreakByCharWrapping
	#define UILineBreakModeClip				NSLineBreakByClipping
	#define UILineBreakModeHeadTruncation	NSLineBreakByTruncatingHead
	#define UILineBreakModeTailTruncation	NSLineBreakByTruncatingTail
	#define UILineBreakModeMiddleTruncation	NSLineBreakByTruncatingMiddle

	#define UITextAlignmentLeft				NSTextAlignmentLeft
	#define UITextAlignmentCenter			NSTextAlignmentCenter
	#define UITextAlignmentRight			NSTextAlignmentRight

#endif	// #ifdef __IPHONE_6_0

// ----------------------------------
// Compatible with ARC
// ----------------------------------

#if !defined(__clang__) || __clang_major__ < 3

	#ifndef __bridge
	#define __bridge
	#endif

	#ifndef __bridge_retain
	#define __bridge_retain
	#endif

	#ifndef __bridge_retained
	#define __bridge_retained
	#endif

	#ifndef __autoreleasing
	#define __autoreleasing
	#endif

	#ifndef __strong
	#define __strong
	#endif

	#ifndef __unsafe_unretained
	#define __unsafe_unretained
	#endif

	#ifndef __weak
	#define __weak
	#endif

#endif

#if __has_feature(objc_arc)

	#define BEE_PROP_RETAIN					strong
	#define BEE_RETAIN( x )					(x)
	#define BEE_RELEASE( x )
	#define BEE_AUTORELEASE( x )			(x)
	#define BEE_BLOCK_COPY( x )				(x)
	#define BEE_BLOCK_RELEASE( x )
	#define BEE_SUPER_DEALLOC()
	#define BEE_AUTORELEASE_POOL_START()	@autoreleasepool {
	#define BEE_AUTORELEASE_POOL_END()		}

#else

	#define BEE_PROP_RETAIN					retain
	#define BEE_RETAIN( x )					[(x) retain]
	#define BEE_RELEASE( x )				[(x) release]
	#define BEE_AUTORELEASE( x )			[(x) autorelease]
	#define BEE_BLOCK_COPY( x )				Block_copy( x )
	#define BEE_BLOCK_RELEASE( x )			Block_release( x )
	#define BEE_SUPER_DEALLOC()				[super dealloc]
	#define BEE_AUTORELEASE_POOL_START()	NSAutoreleasePool * __pool = [[NSAutoreleasePool alloc] init];
	#define BEE_AUTORELEASE_POOL_END()		[__pool release];

#endif

// ----------------------------------
// Global include
// ----------------------------------

#import <stdio.h>
#import <stdlib.h>
#import <stdint.h>
#import <string.h>
#import <assert.h>
#import <errno.h>

#import <sys/errno.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <sys/types.h>
#import <sys/socket.h>

#import <math.h>
#import <unistd.h>
#import <limits.h>
#import <execinfo.h>

#import <netdb.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <arpa/inet.h>
#import <netinet/in.h>

#import <mach/mach.h>
#import <malloc/malloc.h>
#import <libxml/tree.h>

#import "Bee_Vendor.h"

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

#ifndef __IPHONE_4_0
#warning "BeeFramework only available in iOS SDK 4.0 and later."
#endif

// ----------------------------------
// Version
// ----------------------------------

#undef	BEE_VERSION
#define BEE_VERSION		@"0.6.0"

// ----------------------------------
// Global include headers
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
#import <netinet/in.h>
#import <arpa/inet.h>
#import <ifaddrs.h>

#import <mach/mach.h>
#import <malloc/malloc.h>
#import <libxml/tree.h>

#ifdef __OBJC__

#import <Foundation/Foundation.h>

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <TargetConditionals.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreImage/CoreImage.h>
#import <CoreLocation/CoreLocation.h>

#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <objc/runtime.h>
#import <objc/message.h>
#import <CommonCrypto/CommonDigest.h>

#endif	// #ifdef __OBJC__

// ----------------------------------
// Option values
// ----------------------------------

#undef	__ON__
#define __ON__		(1)

#undef	__OFF__
#define __OFF__		(0)

#undef	__AUTO__

#if defined(_DEBUG) || defined(DEBUG)
#define __AUTO__	(1)
#else
#define __AUTO__	(0)
#endif

// ----------------------------------
// Global compile option
// ----------------------------------

#define __BEE_DEVELOPMENT__				(__ON__)
#define	__BEE_PERFORMANCE__				(__OFF__)
#define __BEE_LOG__						(__OFF__)
#define __BEE_UNITTEST__                (__OFF__)
#define __BEE_LIVELOAD__				    (__ON__)

#pragma mark -

#if defined(__BEE_LOG__) && __BEE_LOG__
#undef	NSLog
#define	NSLog	BeeLog
#endif	// #if (__ON__ == __BEE_LOG__)

#undef	UNUSED
#define	UNUSED( __x ) \
		{ \
			id __unused_var__ __attribute__((unused)) = (__x); \
		}

#undef	ALIAS
#define	ALIAS( __a, __b ) \
		__typeof__(__a) __b = __a;

#pragma mark -

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
#define BEE_PROP_ASSIGN					assign

#define BEE_RETAIN( x )					(x)
#define BEE_RELEASE( x )				(x)
#define BEE_AUTORELEASE( x )			(x)

#define BEE_BLOCK_COPY( x )				(x)
#define BEE_BLOCK_RELEASE( x )			(x)
#define BEE_SUPER_DEALLOC()

#define BEE_AUTORELEASE_POOL_START()	@autoreleasepool {
#define BEE_AUTORELEASE_POOL_END()		}

#else

#define BEE_PROP_RETAIN					retain
#define BEE_PROP_ASSIGN					assign

#define BEE_RETAIN( x )					[(x) retain]
#define BEE_RELEASE( x )				[(x) release]
#define BEE_AUTORELEASE( x )			[(x) autorelease]

#define BEE_BLOCK_COPY( x )				Block_copy( x )
#define BEE_BLOCK_RELEASE( x )			Block_release( x )
#define BEE_SUPER_DEALLOC()				[super dealloc]

#define BEE_AUTORELEASE_POOL_START()	NSAutoreleasePool * __pool = [[NSAutoreleasePool alloc] init];
#define BEE_AUTORELEASE_POOL_END()		[__pool release];

#endif

#undef	BEE_DEPRECATED
#define	BEE_DEPRECATED	__attribute__((deprecated))

#undef	BEE_EXTERN
#if defined(__cplusplus)
#define BEE_EXTERN		extern "C"
#else	// #if defined(__cplusplus)
#define BEE_EXTERN		extern
#endif	// #if defined(__cplusplus)

#pragma mark -

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000

#define UILineBreakMode					NSLineBreakMode
#define UILineBreakModeWordWrap			NSLineBreakByWordWrapping
#define UILineBreakModeCharacterWrap	NSLineBreakByCharWrapping
#define UILineBreakModeClip				NSLineBreakByClipping
#define UILineBreakModeHeadTruncation	NSLineBreakByTruncatingHead
#define UILineBreakModeTailTruncation	NSLineBreakByTruncatingTail
#define UILineBreakModeMiddleTruncation	NSLineBreakByTruncatingMiddle

#define UITextAlignmentLeft				NSTextAlignmentLeft
#define UITextAlignmentCenter			NSTextAlignmentCenter
#define UITextAlignmentRight			NSTextAlignmentRight
#define	UITextAlignment					NSTextAlignment

#endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000

#ifndef	weakify
#if __has_feature(objc_arc)
#define weakify( x )	autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x;
#else	// #if __has_feature(objc_arc)
#define weakify( x )	autoreleasepool{} __block __typeof__(x) __block_##x##__ = x;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	weakify

#ifndef	normalize
#if __has_feature(objc_arc)
#define normalize( x )	try{} @finally{} __typeof__(x) x = __weak_##x##__;
#else	// #if __has_feature(objc_arc)
#define normalize( x )	try{} @finally{} __typeof__(x) x = __block_##x##__;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	@normalize

#pragma mark -

typedef void ( *ImpFuncType )( id a, SEL b, void * c );

// ----------------------------------
// Preload headers
// ----------------------------------

#import "Bee_Vendor.h"

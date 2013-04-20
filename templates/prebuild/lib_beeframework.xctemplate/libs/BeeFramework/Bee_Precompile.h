//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  Bee_Precompile.h
//

#ifdef __OBJC__
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <TargetConditionals.h>
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#endif

// Global compile option

#undef	BEE_VERSION
#define BEE_VERSION				"0.3.0"

#define __BEE_DEVELOPMENT__		(1)	// 是否开发模式
#define __BEE_LOG__				(1)	// 是否打开LOG
#define __BEE_PERFORMANCE__		(0)	// 是否开启性能测试
#define __BEE_UNITTEST__		(1)	// 是否UnitTest

#if TARGET_OS_IPHONE
#define __BEE_DEBUGGER__		(0)	// 是否显示“小虫子”
#define __BEE_CRASHLOG__		(0)	// （未完成）
#define __BEE_WIREFRAME__		(1)	// 是否显示WireFrame
#endif

#define __BEE_SELECTOR_STYLE1__	(1)	// handle + ClassName
#define __BEE_SELECTOR_STYLE2__	(1)	// handleXXX + ClassName + MethodName

// Backward compatible

#undef	NSLog
#define	NSLog							BeeLog

#define UILineBreakModeWordWrap			NSLineBreakByWordWrapping
#define UILineBreakModeCharacterWrap	NSLineBreakByCharWrapping
#define UILineBreakModeClip				NSLineBreakByClipping
#define UILineBreakModeHeadTruncation	NSLineBreakByTruncatingHead
#define UILineBreakModeTailTruncation	NSLineBreakByTruncatingTail
#define UILineBreakModeMiddleTruncation	NSLineBreakByTruncatingMiddle

#define UITextAlignmentLeft				NSTextAlignmentLeft
#define UITextAlignmentCenter			NSTextAlignmentCenter
#define UITextAlignmentRight			NSTextAlignmentRight


// Compatible with ARC

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

// Compatible with ARC

#if __has_feature(objc_arc)

	#define BEE_PROP_RETAIN strong
	#define BEE_RETAIN(x) (x)
	#define BEE_RELEASE(x)
	#define BEE_AUTORELEASE(x) (x)
	#define BEE_BLOCK_COPY(x) (x)
	#define BEE_BLOCK_RELEASE(x)
	#define BEE_SUPER_DEALLOC()
	#define BEE_AUTORELEASE_POOL_START() @autoreleasepool {
	#define BEE_AUTORELEASE_POOL_END() }

#else

	#define BEE_PROP_RETAIN retain
	#define BEE_RETAIN(x) ([(x) retain])
	#define BEE_RELEASE(x) ([(x) release])
	#define BEE_AUTORELEASE(x) ([(x) autorelease])
	#define BEE_BLOCK_COPY(x) (Block_copy(x))
	#define BEE_BLOCK_RELEASE(x) (Block_release(x))
	#define BEE_SUPER_DEALLOC() ([super dealloc])
	#define BEE_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	#define BEE_AUTORELEASE_POOL_END() [pool release];

#endif

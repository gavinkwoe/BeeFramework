/*
 The MIT License (MIT)
 
 Copyright (c) 2016 SuXinDe (Email: suxinde2009@126.com)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

// Taken from the commercial iOS PDF framework http://PSPDFkit.com.
// Copyright (c) 2014 Peter Steinberger, BeeKit GmbH. All rights reserved.
// Licensed under MIT (http://opensource.org/licenses/MIT)
//
// You should only use this in debug builds. It doesn't use private API, but I wouldn't ship it.

#if DEBUG

#import <Foundation/Foundation.h>

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#define UIView NSView
#endif

#import <objc/runtime.h>
#import <objc/message.h>

#define PROPERTY(propName) NSStringFromSelector(@selector(propName))

#define BeeAssert(expression, ...) \
do { if(!(expression)) { \
NSLog(@"%@", [NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:@"" __VA_ARGS__]]); \
abort(); }} while(0)

// http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
BOOL BeeReplaceMethodWithBlock(Class c, SEL origSEL, SEL newSEL, id block) {
    BeeAssert(c && origSEL && newSEL && block);
    if ([c instancesRespondToSelector:newSEL]) return YES; // Selector already implemented, skip silently.
    
    Method origMethod = class_getInstanceMethod(c, origSEL);
    
    // Add the new method.
    IMP impl = imp_implementationWithBlock(block);
    if (!class_addMethod(c, newSEL, impl, method_getTypeEncoding(origMethod))) {
        NSLog(@"Failed to add method: %@ on %@", NSStringFromSelector(newSEL), c);
        return NO;
    }else {
        Method newMethod = class_getInstanceMethod(c, newSEL);
        
        // If original doesn't implement the method we want to swizzle, create it.
        if (class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(origMethod))) {
            class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(newMethod));
        }else {
            method_exchangeImplementations(origMethod, newMethod);
        }
    }
    return YES;
}

SEL _BeePrefixedSelector(SEL selector) {
    return NSSelectorFromString([NSString stringWithFormat:@"Bee_%@", NSStringFromSelector(selector)]);
}

void BeeAssertIfNotMainThread(void) {
    BeeAssert(NSThread.isMainThread, @"\nERROR: All calls to UIKit need to happen on the main thread. You have a bug in your code. Use dispatch_async(dispatch_get_main_queue(), ^{ ... }); if you're unsure what thread you're in.\n\nBreak on BeeAssertIfNotMainThread to find out where.\n\nStacktrace: %@", NSThread.callStackSymbols);
}

__attribute__((constructor)) static void BeeUIKitMainThreadGuard(void) {
    @autoreleasepool {
        for (NSString *selStr in @[PROPERTY(setNeedsLayout), PROPERTY(setNeedsDisplay), PROPERTY(setNeedsDisplayInRect:)]) {
            SEL selector = NSSelectorFromString(selStr);
            SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"Bee_%@", selStr]);
            if ([selStr hasSuffix:@":"]) {
                BeeReplaceMethodWithBlock(UIView.class, selector, newSelector, ^(__unsafe_unretained UIView *_self, CGRect r) {
                    // Check for window, since *some* UIKit methods are indeed thread safe.
                    // https://developer.apple.com/library/ios/#releasenotes/General/WhatsNewIniPhoneOS/Articles/iPhoneOS4.html
                    /*
                     Drawing to a graphics context in UIKit is now thread-safe. Specifically:
                     
                     The routines used to access and manipulate the graphics context can now correctly handle contexts residing on different threads.
                     
                     String and image drawing is now thread-safe.
                     
                     Using color and font objects in multiple threads is now safe to do.
                     */
                    if (_self.window) BeeAssertIfNotMainThread();
                    ((void ( *)(id, SEL, CGRect))objc_msgSend)(_self, newSelector, r);
                });
            }else {
                BeeReplaceMethodWithBlock(UIView.class, selector, newSelector, ^(__unsafe_unretained UIView *_self) {
                    if (_self.window) {
                        if (!NSThread.isMainThread) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                            dispatch_queue_t queue = dispatch_get_current_queue();
#pragma clang diagnostic pop
                            // iOS 8 layouts the MFMailComposeController in a background thread on an UIKit queue.
                            // https://github.com/BeeKit/BeeKit/issues/1423
                            if (!queue || !strstr(dispatch_queue_get_label(queue), "UIKit")) {
                                BeeAssertIfNotMainThread();
                            }
                        }
                    }
                    ((void ( *)(id, SEL))objc_msgSend)(_self, newSelector);
                });
            }
        }
    }
}

#endif

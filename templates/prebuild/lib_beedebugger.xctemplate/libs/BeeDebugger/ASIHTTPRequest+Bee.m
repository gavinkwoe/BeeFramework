//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//	Copyright (c) 2013 BEE creators
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

#import "ASIHTTPRequest+Bee.h"
#import <objc/runtime.h>

static BOOL forceThrottleBandwith = NO;
static IMP originalIsBandwidthThrottled;

@implementation ASIHTTPRequest (BeeExt)
+ (void)load
{
    Class clazz = objc_getMetaClass(class_getName([self class]));
    SEL selector = @selector(setForceThrottleBandwidth:);
    if ( ! [clazz resolveClassMethod:selector]) {
        IMP imp = class_getMethodImplementation(clazz, @selector(_setForceThrottleBandwidth:));
        class_addMethod(clazz, selector, imp, "v:C");
        
        SEL bandwidthSelector = @selector(isBandwidthThrottled);
        originalIsBandwidthThrottled = class_getMethodImplementation(clazz, bandwidthSelector);
        Method method = class_getClassMethod(clazz, bandwidthSelector);
        IMP myImp = class_getMethodImplementation(clazz, @selector(_isBandwidthThrottled));
		method_setImplementation( method, myImp );
    }
    class_getClassMethod(clazz, @selector(setForceThrottleBandwidth:));
}

// Set to YES to force turn on throttling
+ (void)_setForceThrottleBandwidth:(BOOL)throttle
{
    forceThrottleBandwith = throttle;
}

+ (BOOL)_isBandwidthThrottled
{
    if ( forceThrottleBandwith )
        return YES;
    if (originalIsBandwidthThrottled) {
       return (BOOL)originalIsBandwidthThrottled(self, _cmd);
    }
    return NO;
}

@end

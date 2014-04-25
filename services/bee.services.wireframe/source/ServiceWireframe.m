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

#import "ServiceWireframe.h"
#import "ServiceWireframeView.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface NSObject(UIWireframeHookPrivate)
+ (void)__applyWireframeHook;
@end

#pragma mark -

@implementation NSObject(UIWireframeHook)

static BOOL __swizzled = NO;
static void (*__drawRect)( id, SEL, CGRect );
static void (*__didMoveToSuperview)( id, SEL );

+ (void *)swizz:(Class)clazz method:(SEL)sel1 with:(SEL)sel2
{
	Method method;
	IMP implement;
	IMP implement2;
	
	// swizz UIView methods

	method = class_getInstanceMethod( clazz, sel1 );
	implement = (void *)method_getImplementation( method );
	implement2 = class_getMethodImplementation( clazz, sel2 );
	method_setImplementation( method, implement2 );

	return implement;
}

+ (void)__applyWireframeHook
{
	if ( NO == __swizzled )
	{
		__drawRect = [self swizz:[UIView class] method:@selector(drawRect:) with:@selector(myDrawRect:)];
		__didMoveToSuperview = [self swizz:[UIView class] method:@selector(didMoveToSuperview) with:@selector(myDidMoveToSuperview)];
		
		__swizzled = YES;
	}
}

- (void)showWireframeInView:(UIView *)view
{
	if ( [view isKindOfClass:[ServiceWireframeView class]] )
		return;

	[ServiceWireframeView showInContainer:view];
}

- (void)hideWireframeInView:(UIView *)view
{
	if ( [view isKindOfClass:[ServiceWireframeView class]] )
		return;
	
	[ServiceWireframeView hideInContainer:view];
}

- (void)myDrawRect:(CGRect)rect
{
	if ( [self isKindOfClass:[UIView class]] )
	{
		[self showWireframeInView:(UIView *)self];
	}
	
	if ( __drawRect )
	{
		__drawRect( self, _cmd, rect );
	}
}

- (void)myDidMoveToSuperview
{
	if ( [self isKindOfClass:[UIView class]] )
	{
		[self showWireframeInView:(UIView *)self];
	}
	
	if ( __didMoveToSuperview )
	{
		__didMoveToSuperview( self, _cmd );
	}
}

@end

#pragma mark -

@implementation ServiceWireframe

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( YES )

+ (void)load
{
	[NSObject __applyWireframeHook];
}

- (void)load
{
}

- (void)unload
{
}

#pragma mark -

- (void)powerOn
{
}

- (void)powerOff
{
}

- (void)serviceWillActive
{
}

- (void)serviceDidActived
{
}

- (void)serviceWillDeactive
{
}

- (void)serviceDidDeactived
{
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

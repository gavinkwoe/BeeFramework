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

#import "ServiceInspector_WindowHook.h"
#import "ServiceInspector_Border.h"
#import "ServiceInspector_Indicator.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@interface UIWindow(ServiceInspectorPrivate)
- (void)mySendEvent:(UIEvent *)event;
@end

#pragma mark -

@implementation UIWindow(ServiceInspector)

DEF_NOTIFICATION( TOUCH_BEGAN );
DEF_NOTIFICATION( TOUCH_MOVED );
DEF_NOTIFICATION( TOUCH_ENDED );

static BOOL	__blocked = NO;
static void (*__sendEvent)( id, SEL, UIEvent * );

+ (void)hook
{
	static BOOL __swizzled = NO;
	if ( NO == __swizzled )
	{
		Method method;
		IMP implement;

		method = class_getInstanceMethod( [UIWindow class], @selector(sendEvent:) );
		__sendEvent = (void *)method_getImplementation( method );
		
		implement = class_getMethodImplementation( [UIWindow class], @selector(mySendEvent:) );
		method_setImplementation( method, implement );
		
		__swizzled = YES;
	}
}

+ (void)block:(BOOL)flag
{
	__blocked = flag;
}

- (void)mySendEvent:(UIEvent *)event
{	
	UIWindow * keyWindow = [BeeUIApplication sharedInstance].window;
	if ( self == keyWindow )
	{
		if ( UIEventTypeTouches == event.type )
		{
			NSSet * allTouches = [event allTouches];
			if ( 1 == [allTouches count] )
			{
				UITouch * touch = [[allTouches allObjects] objectAtIndex:0];
				if ( 1 == [touch tapCount] )
				{
					if ( UITouchPhaseBegan == touch.phase )
					{
						[self postNotification:self.TOUCH_BEGAN withObject:touch];

						INFO( @"view '%@', touch began\n%@", [[touch.view class] description], [touch.view description] );
						
						ServiceInspector_Border * border = [ServiceInspector_Border new];
						border.frame = touch.view.bounds;
						[touch.view addSubview:border];
						[border startAnimation];
						[border release];
					}
					else if ( UITouchPhaseMoved == touch.phase )
					{
						[self postNotification:self.TOUCH_MOVED withObject:touch];
					}
					else if ( UITouchPhaseEnded == touch.phase || UITouchPhaseCancelled == touch.phase )
					{
						[self postNotification:self.TOUCH_ENDED withObject:touch];
					
						INFO( @"view '%@', touch ended\n%@", [[touch.view class] description], [touch.view description] );

						ServiceInspector_Indicator * indicator = [ServiceInspector_Indicator new];
						indicator.frame = CGRectMake( 0, 0, 50.0f, 50.0f );
						indicator.center = [touch locationInView:keyWindow];
						[keyWindow addSubview:indicator];
						[indicator startAnimation];
						[indicator release];
					}
				}
			}
		}
	}

	if ( NO == __blocked )
	{
		if ( __sendEvent )
		{
			__sendEvent( self, _cmd, event );
		}
	}
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

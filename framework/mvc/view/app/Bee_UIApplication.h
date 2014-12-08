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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Package.h"
#import "Bee_Foundation.h"
#import "Bee_ViewPackage.h"

#pragma mark -

AS_PACKAGE( BeePackage_UI, BeeUIApplication, application );

#pragma mark -

@class BeeUIApplication;
@compatibility_alias BeeSkeleton BeeUIApplication;

#pragma mark -

@interface BeeUIApplication : UIResponder<UIApplicationDelegate>

AS_NOTIFICATION( LAUNCHED )		// did launched
AS_NOTIFICATION( TERMINATED )	// will terminate

AS_NOTIFICATION( STATE_CHANGED )	// state changed
AS_NOTIFICATION( MEMORY_WARNING )	// memory warning

AS_NOTIFICATION( LOCAL_NOTIFICATION )
AS_NOTIFICATION( REMOTE_NOTIFICATION )

AS_NOTIFICATION( APS_REGISTERED )
AS_NOTIFICATION( APS_ERROR )

AS_INT( DEVICE_CURRENT )
AS_INT( DEVICE_PHONE_3_INCH )
AS_INT( DEVICE_PHONE_4_INCH )

@property (nonatomic, readonly) BOOL		ready;

@property (nonatomic, retain) UIWindow *	window;
@property (nonatomic, assign) NSUInteger	device;

@property (nonatomic, readonly) BOOL		inForeground;
@property (nonatomic, readonly) BOOL		inBackground;

+ (BeeUIApplication *)sharedInstance;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

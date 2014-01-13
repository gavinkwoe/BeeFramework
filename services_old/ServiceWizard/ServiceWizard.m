//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2013-2014, {Bee} open source community
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "ServiceWizard.h"
#import "ServiceWizard_Model.h"
#import "ServiceWizard_Window.h"

#pragma mark -

@implementation ServiceWizard

SERVICE_AUTO_LOADING(YES);

+ (void)configWithSplashes:(NSArray *)splashes
{
    [self configWithSplashes:splashes
				  background:nil
			  pageCtrlNormal:nil
			  pageCtrlHilite:nil
				pageCtrlLast:nil];
}

+ (void)configWithSplashes:(NSArray *)splashes background:(NSObject *)background
{
    [self configWithSplashes:splashes
				  background:background
			  pageCtrlNormal:nil
			  pageCtrlHilite:nil
				pageCtrlLast:nil];
}

+ (void)configWithSplashes:(NSArray *)splashes
                background:(NSObject *)background
            pageCtrlNormal:(NSString *)normal
            pageCtrlHilite:(NSString *)hilite
			  pageCtrlLast:(NSString *)last
{
	[ServiceWizard_Model sharedInstance].splashes = splashes;
	[ServiceWizard_Model sharedInstance].background = background;
	[ServiceWizard_Model sharedInstance].pageControlNoraml = normal;
	[ServiceWizard_Model sharedInstance].pageControlHilite = hilite;
	[ServiceWizard_Model sharedInstance].pageControlLast = last;
}

- (void)load
{
    [super load];
	
    [self observeNotification:BeeUIApplication.LAUNCHED];
}

- (void)unload
{
    [self unobserveAllNotifications];
    
    [super unload];
}

ON_NOTIFICATION3( BeeUIApplication, LAUNCHED, notification )
{
    if ( [notification is:BeeUIApplication.LAUNCHED] )
    {
		if ( NO == [ServiceWizard_Model shown] )
		{
			[self open];
		}
    }
}

- (void)open
{
    if ( [ServiceWizard_Model sharedInstance].splashes.count == 0 )
    {
        ERROR( @"There is no splashes for ServiceWizard." );
    }
    else
    {
        [[ServiceWizard_Window sharedInstance] open];
    }
}

- (void)close
{
    [[ServiceWizard_Window sharedInstance] close];
	[ServiceWizard_Model setShown:YES];
}

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

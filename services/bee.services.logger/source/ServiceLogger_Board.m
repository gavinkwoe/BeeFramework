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

#import "ServiceLogger_Board.h"
#import "ServiceLogger_Cell.h"
#import "ServiceLogger_Dock.h"
#import "ServiceLogger_Window.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@implementation ServiceLogger_Board

DEF_OUTLET( BeeUIScrollView, list )

ON_CREATE_VIEWS( signal )
{
	self.allowedPortrait = YES;
	self.allowedLandscape = YES;
	
	[self observeNotification:ServiceLogger_Dock.OPEN];
	[self observeNotification:ServiceLogger_Dock.CLOSE];

	self.list.whenReloading = ^
	{
		self.list.total = [BeeLogger sharedInstance].backlogs.count;
		if ( self.list.total )
		{
			for ( BeeUIScrollItem * item in self.list.items )
			{
				item.clazz = [ServiceLogger_Cell class];
				item.size = CGSizeAuto;
				item.data = [[BeeLogger sharedInstance].backlogs objectAtIndex:(self.list.total - item.index - 1)];
			}
		}
	};
}

ON_DELETE_VIEWS( signal )
{
	[self unobserveAllNotifications];
}

ON_WILL_APPEAR( signal )
{
	[self.list asyncReloadData];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -

ON_TICK( time )
{
	[self.list asyncReloadData];
}

ON_NOTIFICATION3( ServiceLogger_Dock, OPEN, notification )
{
	[self observeTick];
}

ON_NOTIFICATION3( ServiceLogger_Dock, CLOSE, notification )
{
	[self unobserveTick];
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

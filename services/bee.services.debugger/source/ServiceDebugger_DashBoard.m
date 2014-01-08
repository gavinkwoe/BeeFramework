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

#import "ServiceDebugger_DashBoard.h"
#import "ServiceDebugger_DashCPUCell.h"
#import "ServiceDebugger_DashMemoryCell.h"
#import "ServiceDebugger_DashMessageCell.h"
#import "ServiceDebugger_DashNetworkCell.h"
#import "ServiceDebugger_Dock.h"
#import "ServiceDebugger_CPUModel.h"
#import "ServiceDebugger_MemoryModel.h"
#import "ServiceDebugger_MessageModel.h"
#import "ServiceDebugger_NetworkModel.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@implementation ServiceDebugger_DashBoard

DEF_SINGLETON( ServiceDebugger_DashBoard )

@synthesize scroll = _scroll;

ON_SIGNAL2( BeeUIBoard, signal )
{
	SIGNAL_FORWARD( signal );
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		self.allowedPortrait = YES;
		self.allowedLandscape = YES;
		
		self.scroll = [[[BeeUIScrollView alloc] init] autorelease];
		self.scroll.dataSource = self;
		self.scroll.baseInsets = UIEdgeInsetsMake( 0, 0, 40.0f, 0.0f );
		[self.view addSubview:self.scroll];
		
		[self observeNotification:ServiceDebugger_Dock.OPEN];
		[self observeNotification:ServiceDebugger_Dock.CLOSE];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[self unobserveAllNotifications];

		self.scroll.dataSource = nil;
		self.scroll = nil;
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		self.scroll.frame = self.bounds;
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
		[self.scroll reloadData];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
}

ON_SIGNAL3( ServiceDebugger_DashCPUCell, more, signal )
{
	// TODO:
}

ON_SIGNAL3( ServiceDebugger_DashMemoryCell, more, signal )
{
	// TODO:
}

ON_SIGNAL3( ServiceDebugger_DashMemoryCell, alloc_50m, signal )
{
	[[ServiceDebugger_MemoryModel sharedInstance] alloc50M];
	
	[self.scroll asyncReloadData];
}

ON_SIGNAL3( ServiceDebugger_DashMemoryCell, free_50m, signal )
{
	[[ServiceDebugger_MemoryModel sharedInstance] free50M];
	
	[self.scroll asyncReloadData];
}

ON_SIGNAL3( ServiceDebugger_DashMemoryCell, alloc_all, signal )
{
	[[ServiceDebugger_MemoryModel sharedInstance] allocAll];
	
	[self.scroll asyncReloadData];
}

ON_SIGNAL3( ServiceDebugger_DashMemoryCell, free_all, signal )
{
	[[ServiceDebugger_MemoryModel sharedInstance] freeAll];
	
	[self.scroll asyncReloadData];
}

ON_SIGNAL3( ServiceDebugger_DashMemoryCell, warning, signal )
{
	[[ServiceDebugger_MemoryModel sharedInstance] toggleWarning];
	
	[self.scroll asyncReloadData];
}

ON_SIGNAL3( ServiceDebugger_DashMessageCell, more, signal )
{
	// TODO:
}

ON_SIGNAL3( ServiceDebugger_DashMessageCell, cancel, signal )
{
	[[BeeMessageQueue sharedInstance] cancelMessages];
	
	[self.scroll asyncReloadData];
}

ON_SIGNAL3( ServiceDebugger_DashMessageCell, freeze, signal )
{
	if ( [BeeMessageQueue sharedInstance].pause )
	{
		[BeeMessageQueue sharedInstance].pause = NO;
	}
	else
	{
		[BeeMessageQueue sharedInstance].pause = YES;		
	}
	
	[self.scroll asyncReloadData];
}

ON_SIGNAL3( ServiceDebugger_DashNetworkCell, more, signal )
{
	// TODO:
}

ON_SIGNAL3( ServiceDebugger_DashNetworkCell, add1s, signal )
{
	float delay = [BeeRequestQueue sharedInstance].delay;
	
	[BeeRequestQueue sharedInstance].delay = delay + 1.0f;
	
	[self.scroll asyncReloadData];
}

ON_SIGNAL3( ServiceDebugger_DashNetworkCell, sub1s, signal )
{
	float delay = [BeeRequestQueue sharedInstance].delay;
	
	if ( delay >= 1.0f )
	{
		delay = delay - 1.0f;
	}
	else
	{
		delay = 0.0f;
	}
	
	[BeeRequestQueue sharedInstance].delay = delay;
	
	[self.scroll asyncReloadData];
}

ON_SIGNAL3( ServiceDebugger_DashNetworkCell, flight, signal )
{
	if ( [BeeRequestQueue sharedInstance].online )
	{
		[BeeRequestQueue sharedInstance].online = NO;
	}
	else
	{
		[BeeRequestQueue sharedInstance].online = YES;
	}
	
	[self.scroll asyncReloadData];
}

ON_SIGNAL3( ServiceDebugger_DashNetworkCell, limit, signal )
{
	NSUInteger bandWidth = [ServiceDebugger_NetworkModel sharedInstance].bandWidth + 1;
	
	if ( bandWidth > ServiceDebugger_NetworkModel.BANDWIDTH_3G )
	{
		bandWidth = ServiceDebugger_NetworkModel.BANDWIDTH_CURRENT;
	}
	
	[[ServiceDebugger_NetworkModel sharedInstance] changeBandWidth:bandWidth];
	
	[self.scroll asyncReloadData];
}


ON_TICK( time )
{
	[self.scroll asyncReloadData];
}

ON_NOTIFICATION3( ServiceDebugger_Dock, OPEN, notification )
{
	[self observeTick];
}

ON_NOTIFICATION3( ServiceDebugger_Dock, CLOSE, notification )
{
	[self unobserveTick];
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	return 4;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	BeeUICell * cell = nil;
	
	if ( 0 == index )
	{
		cell = [scrollView dequeueWithContentClass:[ServiceDebugger_DashCPUCell class]];
	}
	else if ( 1 == index )
	{
		cell = [scrollView dequeueWithContentClass:[ServiceDebugger_DashMemoryCell class]];
	}
	else if ( 2 == index )
	{
		cell = [scrollView dequeueWithContentClass:[ServiceDebugger_DashMessageCell class]];
	}
	else if ( 3 == index )
	{
		cell = [scrollView dequeueWithContentClass:[ServiceDebugger_DashNetworkCell class]];
	}
	
	if ( cell )
	{
		cell.data = nil;
	}
	
	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	if ( 0 == index )
	{
		return [ServiceDebugger_DashCPUCell estimateUISizeByWidth:scrollView.width forData:nil];
	}
	else if ( 1 == index )
	{
		return [ServiceDebugger_DashMemoryCell estimateUISizeByWidth:scrollView.width forData:nil];
	}
	else if ( 2 == index )
	{
		return [ServiceDebugger_DashMessageCell estimateUISizeByWidth:scrollView.width forData:nil];
	}
	else if ( 3 == index )
	{
		return [ServiceDebugger_DashNetworkCell estimateUISizeByWidth:scrollView.width forData:nil];
	}
	
	return CGSizeZero;
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

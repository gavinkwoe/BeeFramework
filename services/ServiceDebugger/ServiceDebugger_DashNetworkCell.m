//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#import "ServiceDebugger_DashNetworkCell.h"
#import "ServiceDebugger_PlotsView.h"
#import "ServiceDebugger_NetworkModel.h"
#import "ServiceDebugger_Unit.h"

#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@implementation ServiceDebugger_DashNetworkCell

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.6f];

	ServiceDebugger_PlotsView * plotsView1 = (ServiceDebugger_PlotsView *)$(@"#plots1").view;
	ServiceDebugger_PlotsView * plotsView2 = (ServiceDebugger_PlotsView *)$(@"#plots2").view;
	
	plotsView1.alpha = 0.6f;
	plotsView1.lineColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
	plotsView1.capacity = MAX_REQUEST_HISTORY;

	plotsView2.alpha = 0.6f;
	plotsView2.lineColor = [UIColor greenColor];
	plotsView2.capacity = MAX_REQUEST_HISTORY;
}

- (void)unload
{
	
}

- (void)dataDidChanged
{
	$(@"delay").DATA( __INT([BeeRequestQueue sharedInstance].delay) );
	$(@"upload").DATA( [ServiceDebugger_Unit format:[ServiceDebugger_NetworkModel sharedInstance].uploadBytes] );
	$(@"download").DATA( [ServiceDebugger_Unit format:[ServiceDebugger_NetworkModel sharedInstance].downloadBytes] );
	
	ServiceDebugger_PlotsView * plotsView1 = (ServiceDebugger_PlotsView *)$(@"#plots1").view;
	ServiceDebugger_PlotsView * plotsView2 = (ServiceDebugger_PlotsView *)$(@"#plots2").view;

	[plotsView1 setUpperBound:[ServiceDebugger_NetworkModel sharedInstance].recvLowerBound];
	[plotsView1 setUpperBound:[ServiceDebugger_NetworkModel sharedInstance].recvUpperBound];
	[plotsView1 setPlots:[ServiceDebugger_NetworkModel sharedInstance].recvPlots];
	[plotsView1 setNeedsDisplay];
	
	[plotsView2 setUpperBound:[ServiceDebugger_NetworkModel sharedInstance].sendLowerBound];
	[plotsView2 setUpperBound:[ServiceDebugger_NetworkModel sharedInstance].sendUpperBound];
	[plotsView2 setPlots:[ServiceDebugger_NetworkModel sharedInstance].sendPlots];
	[plotsView2 setNeedsDisplay];
	
	NSUInteger bandWidth = [ServiceDebugger_NetworkModel sharedInstance].bandWidth;
	if ( ServiceDebugger_NetworkModel.BANDWIDTH_CURRENT == bandWidth )
	{
		$(@"limit").DATA( @"NO LIMIT" );
	}
	else if ( ServiceDebugger_NetworkModel.BANDWIDTH_GPRS == bandWidth )
	{
		$(@"limit").DATA( @"GPRS 10K/s" );
	}
	else if ( ServiceDebugger_NetworkModel.BANDWIDTH_EDGE == bandWidth )
	{
		$(@"limit").DATA( @"EDGE 30K/s" );
	}
	else if ( ServiceDebugger_NetworkModel.BANDWIDTH_3G == bandWidth )
	{
		$(@"limit").DATA( @"3G 300K/s" );
	}

	if ( [BeeRequestQueue sharedInstance].online )
	{
		$(@"flight").DATA( @"FLIGHT(OFF)" );
	}
	else
	{
		$(@"flight").DATA( @"FLIGHT(ON)" );
	}
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

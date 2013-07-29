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

#import "ServiceDebugger_DashMessageCell.h"
#import "ServiceDebugger_PlotsView.h"
#import "ServiceDebugger_MessageModel.h"

#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@implementation ServiceDebugger_DashMessageCell

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.6f];
	
	ServiceDebugger_PlotsView * plotsView1 = (ServiceDebugger_PlotsView *)$(@"#plots1").view;
	ServiceDebugger_PlotsView * plotsView2 = (ServiceDebugger_PlotsView *)$(@"#plots2").view;
	ServiceDebugger_PlotsView * plotsView3 = (ServiceDebugger_PlotsView *)$(@"#plots3").view;
	
	plotsView1.alpha = 0.6f;
	plotsView1.lineColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
	plotsView1.capacity = MAX_MESSAGE_HISTORY;

	plotsView2.alpha = 0.6f;
	plotsView2.lineColor = [UIColor greenColor];
	plotsView2.capacity = MAX_MESSAGE_HISTORY;

	plotsView3.alpha = 0.6f;
	plotsView3.lineColor = [UIColor redColor];
	plotsView3.capacity = MAX_MESSAGE_HISTORY;
}

- (void)unload
{
	
}

- (void)dataDidChanged
{
	$(@"#concurrent").DATA( __INT([ServiceDebugger_MessageModel sharedInstance].sendingCount) );
	$(@"#total").DATA( __INT([ServiceDebugger_MessageModel sharedInstance].totalCount) );

	ServiceDebugger_PlotsView * plotsView1 = (ServiceDebugger_PlotsView *)$(@"#plots1").view;
	ServiceDebugger_PlotsView * plotsView2 = (ServiceDebugger_PlotsView *)$(@"#plots2").view;
	ServiceDebugger_PlotsView * plotsView3 = (ServiceDebugger_PlotsView *)$(@"#plots3").view;

	[plotsView1 setUpperBound:[ServiceDebugger_MessageModel sharedInstance].upperBound];
	[plotsView1 setPlots:[ServiceDebugger_MessageModel sharedInstance].sendingPlots];
	[plotsView1 setNeedsDisplay];
	
	[plotsView2 setUpperBound:[ServiceDebugger_MessageModel sharedInstance].upperBound];
	[plotsView2 setPlots:[ServiceDebugger_MessageModel sharedInstance].succeedPlots];
	[plotsView2 setNeedsDisplay];
	
	[plotsView3 setUpperBound:[ServiceDebugger_MessageModel sharedInstance].upperBound];
	[plotsView3 setPlots:[ServiceDebugger_MessageModel sharedInstance].failedPlots];
	[plotsView3 setNeedsDisplay];
	
	if ( NO == [BeeMessageQueue sharedInstance].pause )
	{
		$(@"#freeze").DATA( @"FREEZE(OFF)" );
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.6f];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationRepeatAutoreverses:NO];
		[UIView setAnimationRepeatCount:1];
		
		self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.6f];
		
		[UIView commitAnimations];
	}
	else
	{
		$(@"#freeze").DATA( @"FREEZE(ON)" );
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.6f];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationRepeatAutoreverses:YES];
		[UIView setAnimationRepeatCount:999999];
		
		self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6f];
		
		[UIView commitAnimations];
	}
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

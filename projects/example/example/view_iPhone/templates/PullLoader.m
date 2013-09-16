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

#import "PullLoader.h"

#pragma mark -

@implementation PullLoader

+ (void)load
{
	[BeeUIPullLoader setDefaultSize:CGSizeMake(200, 50)];
	[BeeUIPullLoader setDefaultClass:[PullLoader class]];
}

- (void)load
{
	[super load];
	
	self.FROM_RESOURCE( @"PullLoader.xml" );

	$(@"state").DATA( @"Pull to refresh" );
	$(@"date").DATA( [NSString stringWithFormat:@"Last update：%@", [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]] );
}

- (void)unload
{
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	BeeUIImageView *				arrow = (BeeUIImageView *)$(@"arrow").view;
	BeeUIActivityIndicatorView *	indicator = (BeeUIActivityIndicatorView *)$(@"ind").view;

	if ( [signal is:BeeUIPullLoader.STATE_CHANGED] )
	{
		if ( self.animated )
		{
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationBeginsFromCurrentState:YES];
			[UIView setAnimationDuration:0.3f];
		}
		
		if ( BeeUIPullLoader.STATE_NORMAL == self.state )
		{
			arrow.hidden = NO;
			arrow.transform = CGAffineTransformIdentity;
			
			[indicator stopAnimating];
			
			$(@"state").DATA( @"Pull to refresh" );
			$(@"date").DATA( [NSString stringWithFormat:@"Last update：%@", [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]] );
		}
		else if ( BeeUIPullLoader.STATE_PULLING == self.state )
		{
			arrow.hidden = NO;
			arrow.transform = CGAffineTransformRotate( CGAffineTransformIdentity, (M_PI / 360.0f) * -359.0f );
			
			$(@"state").DATA( @"Release to refresh" );
			$(@"date").DATA( [NSString stringWithFormat:@"Last update：%@", [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]] );
		}
		else if ( BeeUIPullLoader.STATE_LOADING == self.state )
		{
			[indicator startAnimating];

			arrow.hidden = YES;
			
			$(@"state").DATA( @"Loading..." );
			$(@"date").DATA( [NSString stringWithFormat:@"Last update：%@", [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]] );
		}
		
		if ( self.animated )
		{
			[UIView commitAnimations];
		}

		self.RELAYOUT();
	}
	else if ( [signal is:BeeUIPullLoader.FRAME_CHANGED] )
	{
		self.RELAYOUT();
	}
}

@end

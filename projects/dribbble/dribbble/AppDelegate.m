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

#import "AppDelegate.h"
#import "DribbbleBoard_iPhone.h"

#pragma mark -

@implementation AppDelegate

- (void)load
{
	[UIApplication sharedApplication].statusBarHidden = NO;
	
	bee.ui.config.ASR = YES;
	bee.ui.config.iOS7Mode = YES;
//	bee.ui.config.highPerformance = YES;
//	bee.ui.config.cacheAsyncLoad = YES;
//	bee.ui.config.cacheAsyncSave = YES;

	if ( IOS7_OR_LATER )
	{
		[BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
		[BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar-64.png"]];
	}
	else
	{
		[BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
//		[BeeUINavigationBar setBackgroundColor:[UIColor blackColor]];
//		[BeeUINavigationBar setBackgroundTintColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.6f]];
		[BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar.png"]];
	}

	self.window.rootViewController = [BeeUIStack stackWithFirstBoardClass:[DribbbleBoard_iPhone class]];
}

- (void)unload
{	
}

@end

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

#import "TeamBoard_iPhone.h"
#import "TeamBoardCell_iPhone.h"
#import "PullLoader.h"
#import "FootLoader.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation TeamBoard_iPhone

DEF_OUTLET( BeeUIScrollView, list )

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

- (void)load
{
}

- (void)unload
{
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = SHORT_RGB( 0x333 );
	
	self.navigationBarShown = YES;
	self.navigationBarTitle = @"Team";
	self.navigationBarLeft = [UIImage imageNamed:@"menu-button.png"];

	self.list.lineCount = 1;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
	
	self.list.whenReloading = ^
	{
		self.list.total = 1;
		
		BeeUIScrollItem * item = self.list.items[0];
		item.clazz = [TeamBoardCell_iPhone class];
	};
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	[self.list reloadData];
	
	bee.ui.router.view.pannable = YES;
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
	bee.ui.router.view.pannable = NO;
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[[AppBoard_iPhone sharedInstance] showMenu];
}

#pragma mark -

ON_SIGNAL3( TeamBoardCell_iPhone, call, signal )
{
	NSURL * url = [NSURL URLWithString:@"telprompt:010-65615510"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, website, signal )
{
	NSURL * url = [NSURL URLWithString:@"http://www.geek-zoo.com"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, guo, signal )
{
	NSURL * url = [NSURL URLWithString:@"https://github.com/gavinkwoe"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, qfish, signal )
{
	NSURL * url = [NSURL URLWithString:@"http://qfi.sh"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, howie, signal )
{
	NSURL * url = [NSURL URLWithString:@"https://github.com/howiezhang"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, houxin, signal )
{
	NSURL * url = [NSURL URLWithString:@"https://github.com/houxin"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, donglin, signal )
{
	NSURL * url = [NSURL URLWithString:@"http://dribbble.com/realjons"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, stcui, signal )
{
	NSURL * url = [NSURL URLWithString:@"https://github.com/stcui"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, ilikeido, signal )
{
	NSURL * url = [NSURL URLWithString:@"https://github.com/ilikeido"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, uxyheaven, signal )
{
	NSURL * url = [NSURL URLWithString:@"https://github.com/uxyheaven"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, lancy, signal )
{
	NSURL * url = [NSURL URLWithString:@"https://github.com/lancy"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, yulong, signal )
{
	NSURL * url = [NSURL URLWithString:@"https://github.com/yulong"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, inonomori, signal )
{
	NSURL * url = [NSURL URLWithString:@"https://github.com/inonomori"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_SIGNAL3( TeamBoardCell_iPhone, esseak, signal )
{
	NSURL * url = [NSURL URLWithString:@"https://github.com/esseak"];
	[[UIApplication sharedApplication] openURL:url];
}

@end

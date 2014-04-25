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

#import "AboutBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@implementation AboutBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

DEF_OUTLET( BeeUIScrollView, list );

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
	self.navigationBarTitle = @"About";
	self.navigationBarLeft = [UIImage imageNamed:@"menu-button.png"];

	self.list.lineCount = 1;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;

	self.list.whenReloading = ^
	{
		self.list.total = 1;

		BeeUIScrollItem * item = self.list.items[0];
		item.clazz = [AboutBoardCell_iPhone class];
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

@end

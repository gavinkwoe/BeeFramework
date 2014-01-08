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

#import "DribbbleDetailBoard_iPhone.h"
#import "DribbbleDetailBoardHeader_iPhone.h"
#import "DribbbleDetailBoardComment_iPhone.h"

#pragma mark -

@implementation DribbbleDetailBoard_iPhone

DEF_MODEL( ShotInfoModel,		info );
DEF_MODEL( ShotCommentsModel,	comments );

DEF_OUTLET( BeeUIScrollView,	list );

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

- (void)load
{
	self.info = [ShotInfoModel modelWithObserver:self];
	self.comments = [ShotCommentsModel modelWithObserver:self];
}

- (void)unload
{
	[self.comments removeAllObservers];
	self.comments = nil;
	
	[self.info removeAllObservers];
	self.info = nil;
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = SHORT_RGB( 0x333 );

	self.allowedSwipeToBack = YES;
	
	self.navigationBarShown = YES;
	self.navigationBarTitle = @"Dribbble";

	[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back.png"]];

	self.list.headerShown = YES;
	self.list.footerShown = YES;
	self.list.lineCount = 1;
	self.list.vertical = YES;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
	
	self.list.whenReloading = ^
	{
		self.list.total = 1 + self.comments.comments.count;

		BeeUIScrollItem * header = self.list.items[0];
		header.clazz = [DribbbleDetailBoardHeader_iPhone class];
		header.data = self.info.shot;
		header.order = 0;
		header.size = CGSizeAuto;

		for ( NSUInteger i = 0; i < self.comments.comments.count; ++i )
		{
			BeeUIScrollItem * comment = self.list.items[1 + i];
			comment.clazz = [DribbbleDetailBoardComment_iPhone class];
			comment.data = self.comments.comments[i];
			comment.order = 0;
			comment.size = CGSizeAuto;
		}
	};
	
	self.list.whenHeaderRefresh = ^
	{
		[self.info reload];
		[self.comments firstPage];
	};
	
	self.list.whenFooterRefresh = ^
	{
		[self.comments nextPage];
	};
	
	self.list.whenReachBottom = ^
	{
		[self.comments nextPage];
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
	[self.info reload];
	[self.comments firstPage];

	[self.list reloadData];
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

ON_LEFT_BUTTON_TOUCHED( signal )
{
	[self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark -

ON_SIGNAL3( ShotInfoModel, RELOADING, signal )
{
	self.list.headerLoading = YES;
	self.list.footerLoading = YES;
}

ON_SIGNAL3( ShotInfoModel, RELOADED, signal )
{
	self.list.headerLoading = NO;
	self.list.footerLoading = NO;
	self.list.footerMore = self.comments.more;
	
	[self transitionFade];
	
	[self.list reloadData];
}

ON_SIGNAL3( ShotCommentsModel, RELOADING, signal )
{
	self.list.headerLoading = YES;
	self.list.footerLoading = YES;
}

ON_SIGNAL3( ShotCommentsModel, RELOADED, signal )
{
	self.list.headerLoading = NO;
	self.list.footerLoading = NO;
	self.list.footerMore = self.comments.more;
	
	[self transitionFade];
	
	[self.list reloadData];
}

@end

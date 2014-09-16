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

#import "DribbbleProfileBoard_iPhone.h"
#import "DribbbleProfileBoardCell_iPhone.h"
#import "DribbbleDetailBoard_iPhone.h"
#import "DribbbleBoardCell_iPhone.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@interface DribbbleProfileBoard_iPhone()
@end

#pragma mark -

@implementation DribbbleProfileBoard_iPhone

@synthesize player = _player;

DEF_MODEL( PlayerShotsModel,	playerShots );

DEF_OUTLET( BeeUIScrollView,	list );

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

- (void)load
{
	self.playerShots = [PlayerShotsModel modelWithObserver:self];
}

- (void)unload
{
	[self.playerShots cancelMessages];
	[self.playerShots removeObserver:self];
	self.playerShots = nil;
	
	self.player = nil;
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = SHORT_RGB( 0x444 );

//	self.allowedSwipeToBack = YES;
	
	self.navigationBarShown = YES;
	self.navigationBarTitle = @"Dribbble";
	self.navigationBarLeft  = [UIImage imageNamed:@"navigation-back.png"];

	self.list.headerClass = [PullLoader class];
	self.list.headerShown = YES;

	self.list.footerClass = [FootLoader class];
	self.list.footerShown = YES;

	self.list.lineCount = 1;
	self.list.vertical = YES;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
	
	self.list.whenReloading = ^
	{
		self.list.total = 1 + self.playerShots.shots.count;

		NSUInteger index = 0;
		
		BeeUIScrollItem * profile = self.list.items[index++];
		profile.clazz = [DribbbleProfileBoardCell_iPhone class];
		profile.data = self.player;
		profile.order = 0;
		profile.rule = BeeUIScrollLayoutRule_Line;
		profile.size = CGSizeAuto;
		
		for ( SHOT * shot in self.playerShots.shots )
		{
			BeeUIScrollItem * item = self.list.items[index++];
			item.clazz = [DribbbleBoardCell_iPhone class];
			item.data = shot;
			item.order = 0;
			item.rule = BeeUIScrollLayoutRule_Tile;
			item.size = CGSizeMake( self.list.frame.size.width, self.list.frame.size.width * 0.75f );
		}
	};
	
	self.list.whenHeaderRefresh = ^
	{
		[self.playerShots firstPage];
	};
	
	self.list.whenFooterRefresh = ^
	{
		[self.playerShots nextPage];
	};
	
	self.list.whenReachBottom = ^
	{
		[self.playerShots nextPage];
	};
}

ON_DELETE_VIEWS( signal )
{
}

ON_LOAD_DATAS( signal )
{
	self.playerShots.player_id = [self.player.id asNSString];
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	if ( NO == self.playerShots.loaded )
	{
		[self.playerShots firstPage];
	}
	
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

ON_SIGNAL3( DribbbleBoardCell_iPhone, mask, signal )
{
	SHOT * shot = signal.sourceCell.data;
	
	DribbbleDetailBoard_iPhone * board = [DribbbleDetailBoard_iPhone board];
	board.info.shot_id = shot.id;
	board.info.shot = shot;
	board.comments.shot_id = shot.id;
	[self.stack pushBoard:board animated:YES];
}

#pragma mark -

ON_SIGNAL3( PlayerShotsModel, RELOADING, signal )
{
	self.list.headerLoading = self.playerShots.loaded;
	self.list.footerLoading = YES;
}

ON_SIGNAL3( PlayerShotsModel, RELOADED, signal )
{
	self.list.headerLoading = NO;
	self.list.footerLoading = NO;
	self.list.footerMore = self.playerShots.more;
	
//	[self transitionFade];

	[self.list reloadData];
}

@end

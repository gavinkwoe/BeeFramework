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
#import "DribbbleDetailBoardPlayer_iPhone.h"
#import "DribbbleDetailBoardPhoto_iPhone.h"
#import "DribbbleDetailBoardComment_iPhone.h"
#import "DribbblePreviewBoard_iPhone.h"
#import "DribbbleProfileBoard_iPhone.h"
#import "DribbbleWebBoard_iPhone.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@interface DribbbleDetailBoard_iPhone()
AS_SIGNAL( VIEW_PROFILE )
AS_SIGNAL( VIEW_URL )
@end

#pragma mark -

@implementation DribbbleDetailBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

DEF_SIGNAL( VIEW_PROFILE )
DEF_SIGNAL( VIEW_URL )

DEF_MODEL( ShotInfoModel,		info );
DEF_MODEL( ShotCommentsModel,	comments );

DEF_OUTLET( BeeUIScrollView,	list );

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
		self.list.total = 2 + self.comments.comments.count;

		BeeUIScrollItem * player = self.list.items[0];
		player.clazz = [DribbbleDetailBoardPlayer_iPhone class];
		player.data = self.info.shot;
		player.order = 0;
		player.size = CGSizeAuto;

		BeeUIScrollItem * photo = self.list.items[1];
		photo.clazz = [DribbbleDetailBoardPhoto_iPhone class];
		photo.data = self.info.shot;
		photo.order = 0;
		photo.size = CGSizeAuto;

		for ( NSUInteger i = 0; i < self.comments.comments.count; ++i )
		{
			BeeUIScrollItem * comment = self.list.items[2 + i];
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
	if ( NO == self.info.loaded )
	{
		[self.info reload];
	}

	if ( NO == self.comments.loaded )
	{
		[self.comments firstPage];
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

ON_SIGNAL3( DribbbleDetailBoardPlayer_iPhone, mask, signal )
{
	DribbbleProfileBoard_iPhone * board = [DribbbleProfileBoard_iPhone board];
	board.player = self.info.shot.player;
	[self.stack pushBoard:board animated:YES];
}

#pragma mark -

ON_SIGNAL3( DribbbleDetailBoardPhoto_iPhone, mask, signal )
{
	DribbblePreviewBoard_iPhone * board = [DribbblePreviewBoard_iPhone board];
	board.shot = self.info.shot;
	[self.stack pushBoard:board animated:YES];
}

#pragma mark -

ON_SIGNAL3( DribbbleDetailBoardComment_iPhone, mask, signal )
{
	COMMENT * comment = signal.sourceCell.data;
	NSArray * urls = [comment.body allURLs];

	if ( urls.count )
	{
		BeeUIActionSheet * actionSheet = [[[BeeUIActionSheet alloc] init] autorelease];
		
		[actionSheet addButtonTitle:[NSString stringWithFormat:@"%@", comment.player.name]
							 signal:self.VIEW_PROFILE
							 object:comment.player];

		for ( NSString * url in urls )
		{
			[actionSheet addButtonTitle:url signal:self.VIEW_URL object:url];
		}

		[actionSheet addCancelTitle:@"Cancel"];
		
		[actionSheet showInViewController:self];
	}
	else
	{
		DribbbleProfileBoard_iPhone * board = [DribbbleProfileBoard_iPhone board];
		board.player = comment.player;
		[self.stack pushBoard:board animated:YES];
	}
}

#pragma mark -

ON_SIGNAL3( DribbbleDetailBoard_iPhone, VIEW_PROFILE, signal )
{
	DribbbleProfileBoard_iPhone * board = [DribbbleProfileBoard_iPhone board];
	board.player = signal.object;
	[self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( DribbbleDetailBoard_iPhone, VIEW_URL, signal )
{
	DribbbleWebBoard_iPhone * board = [DribbbleWebBoard_iPhone board];
	board.url = signal.object;
	[self.stack pushBoard:board animated:YES];
}

#pragma mark -

ON_SIGNAL3( ShotInfoModel, RELOADING, signal )
{
	self.list.headerLoading = self.info.loaded;
	self.list.footerLoading = YES;
}

ON_SIGNAL3( ShotInfoModel, RELOADED, signal )
{
	self.list.headerLoading = NO;
	self.list.footerLoading = NO;
	self.list.footerMore = self.comments.more;
	
//	[self transitionFade];
	
	[self.list reloadData];
}

ON_SIGNAL3( ShotCommentsModel, RELOADING, signal )
{
	self.list.headerLoading = self.info.loaded;
	self.list.footerLoading = YES;
}

ON_SIGNAL3( ShotCommentsModel, RELOADED, signal )
{
	self.list.headerLoading = NO;
	self.list.footerLoading = NO;
	self.list.footerMore = self.comments.more;
	
//	[self transitionFade];
	
	[self.list reloadData];
}

@end

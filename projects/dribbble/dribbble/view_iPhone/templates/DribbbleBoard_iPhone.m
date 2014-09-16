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

#import "DribbbleBoard_iPhone.h"
#import "DribbbleBoardCell_iPhone.h"
#import "DribbbleBoardTab_iPhone.h"
#import "DribbbleDetailBoard_iPhone.h"
#import "PullLoader.h"
#import "FootLoader.h"

#pragma mark -

@implementation DribbbleBoard_iPhone
{
	NSInteger	_selectedIndex;
}

SUPPORT_RESOURCE_LOADING(YES)
SUPPORT_AUTOMATIC_LAYOUT(YES)

DEF_MODEL( ShotEveryoneListModel,		everyone );
DEF_MODEL( ShotPopularListModel,		popular );
DEF_MODEL( ShotDebutsListModel,			debuts );

DEF_OUTLET( BeeUIScrollView,			list );
DEF_OUTLET( DribbbleBoardTab_iPhone,	tabbar );

- (void)load
{
	_selectedIndex = -1;

	self.everyone = [ShotEveryoneListModel modelWithObserver:self];
	self.popular = [ShotPopularListModel modelWithObserver:self];
	self.debuts = [ShotDebutsListModel modelWithObserver:self];
}

- (void)unload
{
	self.everyone = nil;
	self.popular = nil;
	self.debuts = nil;
}

- (ShotListModel *)currentModel
{
	if ( $(self.tabbar).FIND(@"#everyone").HAS_CLASS( @"active" ) )
	{
		return self.everyone;
	}
	else if ( $(self.tabbar).FIND(@"#popular").HAS_CLASS( @"active" ) )
	{
		return self.popular;
	}
	else if ( $(self.tabbar).FIND(@"#debuts").HAS_CLASS( @"active" ) )
	{
		return self.debuts;
	}
	
	return self.everyone;
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = SHORT_RGB( 0x444 );

	self.navigationBarShown = YES;
	self.navigationBarTitle = @"Dribbble";
//	self.navigationBarLeft = [UIImage imageNamed:@"navigation-menu.png"];

	self.list.headerClass = [PullLoader class];
	self.list.headerShown = YES;

	self.list.footerClass = [FootLoader class];
	self.list.footerShown = YES;
	
	self.list.lineCount = 2;
	self.list.animationDuration = 0.2f;
	self.list.baseInsets = bee.ui.config.baseInsets;

	self.list.whenReloading = ^
	{
		self.list.total = [self currentModel].shots.count;

		for ( BeeUIScrollItem * item in self.list.items )
		{
			item.clazz = [DribbbleBoardCell_iPhone class];
			
			if ( _selectedIndex == item.index )
			{
				item.size = CGSizeMake( self.list.width, self.list.width );
				item.order = 1;
				item.rule = BeeUIScrollLayoutRule_Inject;
			}
			else
			{
				item.size = CGSizeMake( self.list.width / self.list.lineCount, self.list.width / self.list.lineCount );
				item.order = 0;
				item.rule = BeeUIScrollLayoutRule_Fall;
			}
			
			item.data = [[self currentModel].shots safeObjectAtIndex:item.index];
		}
	};
	self.list.whenAnimated = ^
	{
		if ( _selectedIndex >= 0 )
		{
			[self.list scrollToIndex:_selectedIndex animated:YES];
		}
	};
	self.list.whenScrolling = ^
	{
//		self.navigationBarShown = NO;
	};
	self.list.whenStop = ^
	{
//		self.navigationBarShown = YES;
	};
	self.list.whenHeaderRefresh = ^
	{
		[self.currentModel firstPage];
	};
	self.list.whenFooterRefresh = ^
	{
		[self.currentModel nextPage];
	};
	
	[self.tabbar selectPopular];
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
	
	if ( NO == self.currentModel.loaded )
	{
		[self.currentModel firstPage];
	}

	[BeeUIRouter sharedInstance].view.pannable = YES;
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
	[BeeUIRouter sharedInstance].view.pannable = NO;
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -

ON_SIGNAL3( DribbbleBoardTab_iPhone, popular, signal )
{
	[self.tabbar selectPopular];
	[self.currentModel firstPage];

	_selectedIndex = -1;
	
	[self transitionFade];

	[self.list scrollToIndex:0 animated:YES];
	[self.list reloadData];
}

ON_SIGNAL3( DribbbleBoardTab_iPhone, everyone, signal )
{
	[self.tabbar selectEveryone];
	[self.currentModel firstPage];
	
	_selectedIndex = -1;
	
	[self transitionFade];
	
	[self.list scrollToIndex:0 animated:YES];
	[self.list reloadData];
}

ON_SIGNAL3( DribbbleBoardTab_iPhone, debuts, signal )
{
	[self.tabbar selectDebuts];
	[self.currentModel firstPage];

	_selectedIndex = -1;
	
	[self transitionFade];
	
	[self.list scrollToIndex:0 animated:YES];
	[self.list reloadData];
}

ON_SIGNAL3( DribbbleBoardCell_iPhone, mask, signal )
{
	SHOT * shot = signal.sourceCell.data;
	
	NSUInteger index = [self.currentModel.shots indexOfObject:shot];
	if ( index == _selectedIndex )
	{
		_selectedIndex = -1;

		DribbbleDetailBoard_iPhone * board = [DribbbleDetailBoard_iPhone board];
		board.info.shot_id = shot.id;
		board.info.shot = shot;
		board.comments.shot_id = shot.id;
		[self.stack pushBoard:board animated:YES];
//		[self.stack pushBoard:board animated:YES transition:bee.ui.transitionFade];
	}
	else
	{
		_selectedIndex = index;
	}

	[self.list recalcFrames];
}

#pragma mark -

ON_SIGNAL3( ShotListModel, RELOADING, signal )
{
	self.list.headerLoading = YES;
	self.list.footerLoading = YES;
}

ON_SIGNAL3( ShotListModel, RELOADED, signal )
{
	self.list.headerLoading = NO;
	self.list.footerLoading = NO;
	self.list.footerMore = self.currentModel.more;

//	[self transitionFade];
	
	[self.list reloadData];
}

@end

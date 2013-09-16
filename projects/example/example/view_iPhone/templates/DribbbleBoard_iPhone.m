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

#import "DribbbleBoard_iPhone.h"
#import "DribbbleDetailBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "model.h"

#pragma mark -

@implementation DribbbleBoardTab_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

- (void)deselectAll
{
	$(@"#everyone-bg").HIDE();
	$(@"#popular-bg").HIDE();
	$(@"#debuts-bg").HIDE();
	
	$(@"#everyone-button").UNSELECT();
	$(@"#popular-button").UNSELECT();
	$(@"#debuts-button").UNSELECT();
}

- (void)selectEveryone
{
	[self deselectAll];

	$(@"#everyone-bg").SHOW();
	$(@"#everyone-button").SELECT();
	
    self.RELAYOUT();
}

- (void)selectPopular
{
	[self deselectAll];
	
	$(@"#popular-bg").SHOW();
	$(@"#popular-button").SELECT();
	
    self.RELAYOUT();
}

- (void)selectDebuts
{
	[self deselectAll];
	
	$(@"#debuts-bg").SHOW();
	$(@"#debuts-button").SELECT();
	
    self.RELAYOUT();
}

@end

#pragma mark -

@implementation DribbbleBoardCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

- (void)dataDidChanged
{
	SHOT * shot = self.data;
	if ( shot )
	{
		$(@"#photo").DATA( shot.image_teaser_url );
		$(@"#view-num").DATA( shot.views_count );
		$(@"#comment-num").DATA( shot.comments_count );
		$(@"#like-num").DATA( shot.likes_count );
	}
}

@end

#pragma mark -

@implementation DribbbleBoard_iPhone
{
	BeeUIScrollView *			_scroll;
	DribbbleBoardTab_iPhone *	_tab;

	ShotEveryoneListModel *		_everyone;
	ShotPopularListModel *		_popular;
	ShotDebutsListModel *		_debuts;
}

@synthesize everyone = _everyone;
@synthesize popular = _popular;
@synthesize debuts = _debuts;

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

- (void)load
{
	self.everyone = [ShotEveryoneListModel modelWithObserver:self];
	self.popular = [ShotPopularListModel modelWithObserver:self];
	self.debuts = [ShotDebutsListModel modelWithObserver:self];
}

- (void)unload
{
	[self.everyone cancelMessages];
	self.everyone = nil;

	[self.popular cancelMessages];
	self.popular = nil;

	[self.debuts cancelMessages];
	self.debuts = nil;
}

- (ShotListModel *)currentModel
{
	if ( $(_tab).FIND(@"#everyone-button").selected )
	{
		return self.everyone;
	}
	else if ( $(_tab).FIND(@"#popular-button").selected )
	{
		return self.popular;
	}
	else if ( $(_tab).FIND(@"#debuts-button").selected )
	{
		return self.debuts;
	}
	
	return self.everyone;
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		self.view.backgroundColor = SHORT_RGB( 0x333 );

		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"menu-button.png"]];
		[self setTitleString:@"Dribbble"];

		_scroll = [BeeUIScrollView new];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
		_scroll.lineCount = 2;
		[_scroll setBaseInsets:UIEdgeInsetsMake( 0, 0, 44 + 44, 0 )];
		[_scroll showHeaderLoader:YES animated:NO];
		[self.view addSubview:_scroll];
		
		_tab = [DribbbleBoardTab_iPhone new];
		[_tab selectPopular];
		[self.view addSubview:_tab];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _scroll );
		SAFE_RELEASE_SUBVIEW( _tab );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_scroll.frame = CGRectInset( self.bounds, 4.0f, 0.0f );
		_tab.frame = CGRectMake( 0, self.height - 44, self.width, 44 );
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
		[_scroll reloadData];

		[[self currentModel] firstPage];
	}
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[[AppBoard_iPhone sharedInstance] showMenu];
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[[self currentModel] firstPage];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] )
	{
		[[self currentModel] nextPage];
	}
}

ON_SIGNAL3( DribbbleBoardTab_iPhone, everyone_button, signal )
{
	[_tab selectEveryone];
	
	[_scroll setContentOffset:CGPointZero];
	[_scroll reloadData];
	
	[[self currentModel] firstPage];
}

ON_SIGNAL3( DribbbleBoardTab_iPhone, popular_button, signal )
{
	[_tab selectPopular];
	
	[_scroll setContentOffset:CGPointZero];
	[_scroll reloadData];
	
	[[self currentModel] firstPage];
}

ON_SIGNAL3( DribbbleBoardTab_iPhone, debuts_button, signal )
{
	[_tab selectDebuts];
	
	[_scroll setContentOffset:CGPointZero];
	[_scroll reloadData];
		
	[[self currentModel] firstPage];
}

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

- (void)API_SHOTS_LIST:(API_SHOTS_LIST *)api
{
	if ( api.sending )
	{
		if ( NO == [self currentModel].loaded )
		{
			[self presentLoadingTips:@"Loading..."];
		}
	}
	else
	{
		[self dismissTips];
	}

	[_scroll setHeaderLoading:api.sending];

	if ( api.succeed )
	{
		[_scroll reloadData];
	}
	else if ( api.failed )
	{
		[self presentFailureTips:@"Error occurred"];
	}
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	return [self currentModel].shots.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	DribbbleBoardCell_iPhone * cell = [scrollView dequeueWithContentClass:[DribbbleBoardCell_iPhone class]];
	cell.data = [[self currentModel].shots safeObjectAtIndex:index];
	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return [DribbbleBoardCell_iPhone estimateUISizeByWidth:scrollView.width / 2.0f - 2.0f
												   forData:[[self currentModel].shots safeObjectAtIndex:index]];
}

@end

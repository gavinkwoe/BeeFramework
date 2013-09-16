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

#import "DribbbleDetailBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "model.h"

#pragma mark -

@implementation DribbbleDetailBoardHeader_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

- (void)dataDidChanged
{
	SHOT * shot = self.data;
	if ( shot )
	{
		$(@"#avatar").DATA( shot.player.avatar_url );
		$(@"#title").DATA( shot.title );
		$(@"#name").DATA( shot.player.name );
		$(@"#time").DATA( [[shot.created_at asNSDate] stringWithDateFormat:@"MM.dd.yyyy"] );
		
		$(@"#photo").DATA( shot.image_url );
		$(@"#view-num").DATA( shot.views_count );
		$(@"#comment-num").DATA( shot.comments_count );
		$(@"#like-num").DATA( shot.likes_count );
	}
}

@end

#pragma mark -

@implementation DribbbleDetailBoardComment_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

- (void)dataDidChanged
{
	COMMENT * comment = self.data;
	if ( comment )
	{
		$(@"avatar").DATA( comment.player.avatar_url );
		$(@"name").DATA( comment.player.name );
		$(@"text").DATA( comment.body );
		$(@"time").DATA( [[comment.created_at asNSDate] stringWithDateFormat:@"MM.dd.yyyy"] );
	}
}

@end

#pragma mark -

@implementation DribbbleDetailBoard_iPhone
{
	BeeUIScrollView *			_scroll;

	ShotInfoModel *				_info;
	ShotCommentsModel *			_comments;
}

@synthesize info = _info;
@synthesize comments = _comments;

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

- (void)load
{
	self.info = [ShotInfoModel modelWithObserver:self];
	self.comments = [ShotCommentsModel modelWithObserver:self];
}

- (void)unload
{
	[self.info cancelMessages];
	self.info = nil;

	[self.comments cancelMessages];
	self.comments = nil;
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		self.view.backgroundColor = SHORT_RGB( 0x333 );

		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back.png"]];
		[self setTitleString:@"Dribbble"];

		_scroll = [BeeUIScrollView new];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
		_scroll.lineCount = 1;
		[_scroll setBaseInsets:UIEdgeInsetsMake( 0, 0, 44, 0 )];
		[_scroll showHeaderLoader:YES animated:NO];
		[self.view addSubview:_scroll];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _scroll );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_scroll.frame = self.bounds;
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
		[_scroll reloadData];

		[self.info firstPage];
		[self.comments firstPage];
	}
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[self.stack popBoardAnimated:YES];
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[self.info firstPage];
		[self.comments firstPage];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] )
	{
		[self.comments nextPage];
	}
}

#pragma mark -

- (void)API_SHOTS_ID:(API_SHOTS_ID *)api
{
	if ( api.sending )
	{
		if ( NO == self.info.loaded )
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

- (void)API_SHOTS_ID_COMMENTS:(API_SHOTS_ID_COMMENTS *)api
{
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
	return 1 + self.comments.comments.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	if ( 0 == index )
	{
		DribbbleDetailBoardHeader_iPhone * cell = [scrollView dequeueWithContentClass:[DribbbleDetailBoardHeader_iPhone class]];
		cell.data = self.info.shot;
		return cell;
	}
	else
	{
		DribbbleDetailBoardComment_iPhone * cell = [scrollView dequeueWithContentClass:[DribbbleDetailBoardComment_iPhone class]];
		cell.data = [self.comments.comments safeObjectAtIndex:index - 1];
		return cell;	
	}
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	if ( 0 == index )
	{
		return [DribbbleDetailBoardHeader_iPhone estimateUISizeByWidth:scrollView.width forData:self.info.shot];
	}
	else
	{
		return [DribbbleDetailBoardComment_iPhone estimateUISizeByWidth:scrollView.width
																forData:[self.comments.comments safeObjectAtIndex:index - 1]];
	}
}

@end

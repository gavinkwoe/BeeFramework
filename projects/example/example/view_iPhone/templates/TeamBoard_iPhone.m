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

#import "TeamBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation TeamBoardCell_iPhone
SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );
@end

#pragma mark -

@implementation TeamBoard_iPhone
{
	BeeUIScrollView *	_scroll;
}

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

- (void)load
{
}

- (void)unload
{
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		self.view.backgroundColor = SHORT_RGB( 0x333 );
		
		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"menu-button.png"]];
		[self setTitleString:@"Team"];
		
		_scroll = [BeeUIScrollView new];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
		[self.view addSubview:_scroll];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _scroll );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_scroll.frame = self.viewBound;
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
		[_scroll asyncReloadData];
	}
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[[AppBoard_iPhone sharedInstance] showMenu];
}

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
	NSURL * url = [NSURL URLWithString:@"https://github.com/qfish"];
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

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	TeamBoardCell_iPhone * cell = [scrollView dequeueWithContentClass:[TeamBoardCell_iPhone class]];
	cell.data = nil;
	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return [TeamBoardCell_iPhone estimateUISizeByWidth:scrollView.width forData:nil];
}

@end

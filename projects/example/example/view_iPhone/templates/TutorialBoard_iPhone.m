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

#import "TutorialBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "Lesson1Board.h"
#import "Lesson2Board.h"
#import "Lesson3Board.h"
#import "Lesson4Board.h"
#import "Lesson5Board.h"
#import "Lesson6_1Board.h"
#import "Lesson6_2Board.h"
#import "Lesson6_3Board.h"
#import "Lesson6_4Board.h"
#import "Lesson6_5Board.h"
#import "Lesson6_6Board.h"

#pragma mark -

@implementation TutorialBoardCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

@end

#pragma mark -

@implementation TutorialBoard_iPhone
{
	BeeUIScrollView *	_scroll;
}

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		self.view.backgroundColor = SHORT_RGB( 0x333 );
		
		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"menu-button.png"]];
		[self setTitleString:@"Tutorial"];

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

ON_SIGNAL3( TutorialBoardCell_iPhone, lesson1, signal )
{
	[self.stack pushBoard:[Lesson1Board board] animated:YES];
}

ON_SIGNAL3( TutorialBoardCell_iPhone, lesson2, signal )
{
	[self.stack pushBoard:[Lesson2Board board] animated:YES];
}

ON_SIGNAL3( TutorialBoardCell_iPhone, lesson3, signal )
{
	[self.stack pushBoard:[Lesson3Board board] animated:YES];
}

ON_SIGNAL3( TutorialBoardCell_iPhone, lesson4, signal )
{
	[self.stack pushBoard:[Lesson4Board board] animated:YES];
}

ON_SIGNAL3( TutorialBoardCell_iPhone, lesson5, signal )
{
	[self.stack pushBoard:[Lesson5Board board] animated:YES];
}

ON_SIGNAL3( TutorialBoardCell_iPhone, lesson6_1, signal )
{
	[self.stack pushBoard:[Lesson6_1Board board] animated:YES];
}

ON_SIGNAL3( TutorialBoardCell_iPhone, lesson6_2, signal )
{
	[self.stack pushBoard:[Lesson6_2Board board] animated:YES];
}

ON_SIGNAL3( TutorialBoardCell_iPhone, lesson6_3, signal )
{
	[self.stack pushBoard:[Lesson6_3Board board] animated:YES];
}

ON_SIGNAL3( TutorialBoardCell_iPhone, lesson6_4, signal )
{
	[self.stack pushBoard:[Lesson6_4Board board] animated:YES];
}

ON_SIGNAL3( TutorialBoardCell_iPhone, lesson6_5, signal )
{
	[self.stack pushBoard:[Lesson6_5Board board] animated:YES];
}

ON_SIGNAL3( TutorialBoardCell_iPhone, lesson6_6, signal )
{
	[self.stack pushBoard:[Lesson6_6Board board] animated:YES];
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	TutorialBoardCell_iPhone * cell = [scrollView dequeueWithContentClass:[TutorialBoardCell_iPhone class]];
	cell.data = nil;
	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return [TutorialBoardCell_iPhone estimateUISizeByWidth:scrollView.width forData:nil];
}

@end

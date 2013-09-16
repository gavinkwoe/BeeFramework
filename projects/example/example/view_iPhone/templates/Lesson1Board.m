//
//  Lesson1Board.m
//

#import "Lesson1Board.h"

#pragma mark -

@implementation Lesson1Board

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
		// 界面创建

		[self setTitleString:@"Lesson 1"];
		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back.png"]];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{	
		// 界面删除
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{	
		// 界面重新布局
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{	
		// 数据加载
	}
	else if ( [signal is:BeeUIBoard.FREE_DATAS] )
	{	
		// 数据释放
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{	
		// 将要显示
	}
	else if ( [signal is:BeeUIBoard.DID_APPEAR] )
	{	
		// 已经显示
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{	
		// 将要隐藏
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{	
		// 已经隐藏
	}
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[self.stack popBoardAnimated:YES];
}

@end

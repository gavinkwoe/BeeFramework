//
//  Lesson1Board.m
//

#import "Lesson1Board.h"

#pragma mark -

@implementation Lesson1Board

// Other signal goes here
- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
}

// BeeUIBoard signal goes here
- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		// 界面创建

		[self setTitleString:@"Lesson 1"];
		[self showNavigationBarAnimated:NO];
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

@end

//
//  Lesson7_4Board.m
//

#import "Lesson7_4Board.h"

#pragma mark -

@implementation Lesson7_4Board

DEF_SIGNAL( BUTTON_TOUCHED )

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		[self setTitleString:@"BeeUIButton"];
		[self showNavigationBarAnimated:NO];
		
		// button2点击时，将发送我们自定义的信号 MY_SIGNAL
		_button = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button.backgroundColor = [UIColor blackColor];
		_button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button.stateNormal.title = @"Click";
		_button.stateNormal.titleColor = [UIColor whiteColor];
		_button.stateHighlighted.title = @"Clicked";
		_button.stateHighlighted.titleColor = [UIColor redColor];
		[_button addSignal:Lesson7_4Board.BUTTON_TOUCHED forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_button];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _button );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		CGRect buttonFrame;
		buttonFrame.size.width = self.viewSize.width - 30.0f;
		buttonFrame.size.height = 44.0f;
		buttonFrame.origin.x = 15.0f;
		buttonFrame.origin.y = self.viewSize.height - buttonFrame.size.height - 10.0f;
		_button.frame = buttonFrame;
	}
}

- (void)handleUISignal_Lesson7_4Board:(BeeUISignal *)signal
{
	if ( [signal is:Lesson7_4Board.BUTTON_TOUCHED] )
	{
		// TODO:
	}
}

@end

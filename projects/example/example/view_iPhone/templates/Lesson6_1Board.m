//
//  Lesson6_1Board.m
//

#import "Lesson6_1Board.h"

#pragma mark -

@implementation Lesson6_1Board

DEF_SIGNAL( BUTTON_TOUCHED )
DEF_SIGNAL( ACTION_ITEM1_TOUCHED )
DEF_SIGNAL( ACTION_ITEM2_TOUCHED )

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
		[self setTitleString:@"BeeUIActionSheet"];
		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back.png"]];

		// button2点击时，将发送我们自定义的信号 MY_SIGNAL
		_button = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button.backgroundColor = [UIColor blackColor];
		_button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button.title = @"Show actionSheet";
		_button.titleColor = [UIColor whiteColor];
		_button.signal = Lesson6_1Board.BUTTON_TOUCHED;
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

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( Lesson6_1Board, BUTTON_TOUCHED, signal )
{
	[super handleUISignal:signal];
	
	BeeUIActionSheet * actionSheet = [BeeUIActionSheet spawn];
	actionSheet.title = @"Lesson7";
	[actionSheet addButtonTitle:@"Button 1" signal:Lesson6_1Board.ACTION_ITEM1_TOUCHED];
	[actionSheet addDestructiveTitle:@"Button 2" signal:Lesson6_1Board.ACTION_ITEM2_TOUCHED];
	[actionSheet addCancelTitle:@"Cancel"];
	[actionSheet presentForController:self];
}

ON_SIGNAL3( Lesson6_1Board, ACTION_ITEM1_TOUCHED, signal )
{
	[super handleUISignal:signal];

	BeeUIActionSheet * actionSheet = (BeeUIActionSheet *)signal.source;
	[actionSheet dismissAnimated:YES];
}

ON_SIGNAL3( Lesson6_1Board, ACTION_ITEM2_TOUCHED, signal )
{
	[super handleUISignal:signal];

	BeeUIActionSheet * actionSheet = (BeeUIActionSheet *)signal.source;
	[actionSheet dismissAnimated:YES];
}

ON_SIGNAL3( BeeUIActionSheet, WILL_PRESENT, signal )
{
	[super handleUISignal:signal];

	_button.hidden = YES;
}


ON_SIGNAL3( BeeUIActionSheet, DID_DISMISS, signal )
{
	[super handleUISignal:signal];
	
	_button.hidden = NO;
}

@end

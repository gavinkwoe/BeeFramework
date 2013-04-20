//
//  Lesson7_1Board.m
//

#import "Lesson7_1Board.h"

#pragma mark -

@implementation Lesson7_1Board

DEF_SIGNAL( BUTTON_TOUCHED )
DEF_SIGNAL( ACTION_ITEM1_TOUCHED )
DEF_SIGNAL( ACTION_ITEM2_TOUCHED )

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
		[self setTitleString:@"BeeUIActionSheet"];
		[self showNavigationBarAnimated:NO];
		
		// button2点击时，将发送我们自定义的信号 MY_SIGNAL
		_button = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button.backgroundColor = [UIColor blackColor];
		_button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button.stateNormal.title = @"Show actionSheet";
		_button.stateNormal.titleColor = [UIColor whiteColor];
		[_button addSignal:Lesson7_1Board.BUTTON_TOUCHED forControlEvents:UIControlEventTouchUpInside];
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

- (void)handleUISignal_Lesson7_1Board:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:Lesson7_1Board.BUTTON_TOUCHED] )
	{
		BeeUIActionSheet * actionSheet = [BeeUIActionSheet spawn];
		actionSheet.title = @"Lesson7";
		[actionSheet addButtonTitle:@"Button 1" signal:Lesson7_1Board.ACTION_ITEM1_TOUCHED];
		[actionSheet addDestructiveTitle:@"Button 2" signal:Lesson7_1Board.ACTION_ITEM2_TOUCHED];
		[actionSheet addCancelTitle:@"Cancel"];
		[actionSheet presentForController:self];
	}	
	else if ( [signal is:Lesson7_1Board.ACTION_ITEM1_TOUCHED] )
	{
		BeeUIActionSheet * actionSheet = (BeeUIActionSheet *)signal.source;
		[actionSheet dismissAnimated:YES];
	}
	else if ( [signal is:Lesson7_1Board.ACTION_ITEM2_TOUCHED] )
	{
		BeeUIActionSheet * actionSheet = (BeeUIActionSheet *)signal.source;
		[actionSheet dismissAnimated:YES];
	}
}

- (void)handleUISignal_BeeUIActionSheet:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal is:BeeUIActionSheet.WILL_PRESENT] )
	{
		_button.hidden = YES;
	}
	else if ( [signal is:BeeUIActionSheet.DID_PRESENT] )
	{
		
	}
	else if ( [signal is:BeeUIActionSheet.WILL_DISMISS] )
	{
	}
	else if ( [signal is:BeeUIActionSheet.DID_DISMISS] )
	{
		_button.hidden = NO;			
	}
}

@end

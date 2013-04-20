//
//  Lesson7_3Board.m
//

#import "Lesson7_3Board.h"

#pragma mark -

@implementation Lesson7_3Board

DEF_SIGNAL( BUTTON_TOUCHED )
DEF_SIGNAL( ALERT_ITEM1_TOUCHED )
DEF_SIGNAL( ALERT_ITEM2_TOUCHED )

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
		[self setTitleString:@"BeeUIAlertView"];
		[self showNavigationBarAnimated:NO];
		
		// button2点击时，将发送我们自定义的信号 MY_SIGNAL
		_button = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button.backgroundColor = [UIColor blackColor];
		_button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button.stateNormal.title = @"Show alertView";
		_button.stateNormal.titleColor = [UIColor whiteColor];
		[_button addSignal:Lesson7_3Board.BUTTON_TOUCHED forControlEvents:UIControlEventTouchUpInside];
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

- (void)handleUISignal_Lesson7_3Board:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:Lesson7_3Board.BUTTON_TOUCHED] )
	{
		BeeUIAlertView * alert = [BeeUIAlertView spawn];
		
		alert.title = @"Title";
		alert.message = @"Message";
		
		[alert addButtonTitle:@"Button 1" signal:Lesson7_3Board.ALERT_ITEM1_TOUCHED];
		[alert addButtonTitle:@"Button 2" signal:Lesson7_3Board.ALERT_ITEM2_TOUCHED];
		[alert addCancelTitle:@"Close"];
		[alert presentForController:self];
	}	
	else if ( [signal is:Lesson7_3Board.ALERT_ITEM1_TOUCHED] )
	{
		BeeUIAlertView * alert = (BeeUIAlertView *)signal.source;
		[alert dismissAnimated:YES];
	}
	else if ( [signal is:Lesson7_3Board.ALERT_ITEM2_TOUCHED] )
	{
		BeeUIAlertView * alert = (BeeUIAlertView *)signal.source;
		[alert dismissAnimated:YES];		
	}
}

- (void)handleUISignal_BeeUIAlertView:(BeeUISignal *)signal
{
	if ( [signal isKindOf:BeeUIAlertView.SIGNAL] )
	{
//		BeeUIAlertView * alert = (BeeUIAlertView *)signal.source;

		if ( [signal is:BeeUIAlertView.WILL_PRESENT] )
		{
			_button.hidden = YES;
		}
		else if ( [signal is:BeeUIAlertView.DID_PRESENT] )
		{
			
		}
		else if ( [signal is:BeeUIAlertView.WILL_DISMISS] )
		{
		}
		else if ( [signal is:BeeUIAlertView.DID_DISMISS] )
		{
			_button.hidden = NO;			
		}
	}
}

@end

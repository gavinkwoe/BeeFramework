//
//  Lesson6_5Board.m
//

#import "Lesson6_5Board.h"

#pragma mark -

@implementation Lesson6_5Board

DEF_SIGNAL( BUTTON_TOUCHED )

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
		[self setTitleString:@"BeeUIDatePicker"];
		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back.png"]];

		_label = [[BeeUILabel alloc] initWithFrame:CGRectZero];
		_label.textColor = [UIColor orangeColor];
		_label.textAlignment = UITextAlignmentCenter;
		_label.font = [UIFont boldSystemFontOfSize:32.0f];
		[self.view addSubview:_label];
		
		_button = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button.backgroundColor = [UIColor blackColor];
		_button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button.title = @"Click";
		_button.titleColor = [UIColor whiteColor];
		_button.signal = Lesson6_5Board.BUTTON_TOUCHED;
		[self.view addSubview:_button];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _label );
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
		
		CGRect labelFrame = buttonFrame;
		labelFrame.origin.y = 40.0f;
		_label.frame = labelFrame;
	}
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( Lesson6_5Board, BUTTON_TOUCHED, signal )
{
	[super handleUISignal:signal];

	BeeUIDatePicker * picker = [BeeUIDatePicker spawn];
	picker.date = [NSDate date];
	[picker presentForController:self];
}

ON_SIGNAL3( BeeUIDatePicker, WILL_PRESENT, signal )
{
	_button.hidden = YES;
}

ON_SIGNAL3( BeeUIDatePicker, DID_DISMISS, signal )
{
	_button.hidden = NO;
}

ON_SIGNAL3( BeeUIDatePicker, CHANGED, signal )
{
	NSDate * date = (NSDate *)[(NSDictionary *)signal.object objectAtPath:@"/date"];
	_label.text = [date stringWithDateFormat:@"yyyy/MM/dd"];
}

ON_SIGNAL3( BeeUIDatePicker, CONFIRMED, signal )
{
	NSDate * date = (NSDate *)[(NSDictionary *)signal.object objectAtPath:@"/date"];
	_label.text = [date stringWithDateFormat:@"yyyy/MM/dd"];
}

@end

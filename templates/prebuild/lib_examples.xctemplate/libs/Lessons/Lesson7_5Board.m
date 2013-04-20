//
//  Lesson7_5Board.m
//

#import "Lesson7_5Board.h"

#pragma mark -

@implementation Lesson7_5Board

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
		[self setTitleString:@"BeeUIDatePicker"];
		[self showNavigationBarAnimated:NO];
		
		_label = [[BeeUILabel alloc] initWithFrame:CGRectZero];
		_label.textColor = [UIColor orangeColor];
		_label.textAlignment = UITextAlignmentCenter;
		_label.font = [UIFont boldSystemFontOfSize:32.0f];
		[self.view addSubview:_label];
		
		_button = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button.backgroundColor = [UIColor blackColor];
		_button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button.stateNormal.title = @"Click";
		_button.stateNormal.titleColor = [UIColor whiteColor];
		[_button addSignal:Lesson7_5Board.BUTTON_TOUCHED forControlEvents:UIControlEventTouchUpInside];
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


- (void)handleUISignal_Lesson7_5Board:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal is:Lesson7_5Board.BUTTON_TOUCHED] )
	{
		BeeUIDatePicker * picker = [BeeUIDatePicker spawn];
		picker.date = [NSDate date];
		[picker presentForController:self];
	}	
}

- (void)handleUISignal_BeeUIDatePicker:(BeeUISignal *)signal
{
	if ( [signal isKindOf:BeeUIDatePicker.SIGNAL] )
	{
//		BeeUIDatePicker * picker = (BeeUIDatePicker *)signal.source;

		if ( [signal is:BeeUIDatePicker.WILL_PRESENT] )
		{
			_button.hidden = YES;
		}
		else if ( [signal is:BeeUIDatePicker.DID_PRESENT] )
		{
			
		}
		else if ( [signal is:BeeUIDatePicker.WILL_DISMISS] )
		{
			
		}
		else if ( [signal is:BeeUIDatePicker.DID_DISMISS] )
		{
			_button.hidden = NO;
		}
		else if ( [signal is:BeeUIDatePicker.CHANGED] )
		{
			NSDate * date = (NSDate *)[(NSDictionary *)signal.object objectAtPath:@"/date"];
			_label.text = [date stringWithDateFormat:@"yyyy/MM/dd"];
		}
		else if ( [signal is:BeeUIDatePicker.CONFIRMED] )
		{
			NSDate * date = (NSDate *)[(NSDictionary *)signal.object objectAtPath:@"/date"];
			_label.text = [date stringWithDateFormat:@"yyyy/MM/dd"];
		}
	}
}

@end

//
//  Lesson3Board.m
//

#import "Lesson3Board.h"

#pragma mark -

@implementation Lesson3Board

DEF_SIGNAL( BACK );
DEF_SIGNAL( ENTER );

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
		[self setTitleString:@"Lesson 3"];
		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back.png"]];

		_button1 = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button1.backgroundColor = [UIColor blackColor];
		_button1.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button1.title = @"< Back";
		_button1.titleColor = [UIColor whiteColor];
		_button1.signal = self.BACK;
		[self.view addSubview:_button1];
		
		_button2 = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button2.backgroundColor = [UIColor blackColor];
		_button2.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button2.title = @"Enter >";
		_button2.titleColor = [UIColor whiteColor];
		_button2.signal = self.ENTER;
		[self.view addSubview:_button2];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _button1 );
		SAFE_RELEASE_SUBVIEW( _button2 );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		CGRect buttonFrame;
		buttonFrame.size.width = (self.viewSize.width - 30.0f) / 2.0f;
		buttonFrame.size.height = 44.0f;
		buttonFrame.origin.x = 10.0f;
		buttonFrame.origin.y = self.viewSize.height - buttonFrame.size.height - 10.0f;
		
		_button1.frame = buttonFrame;
		_button2.frame = CGRectOffset(buttonFrame, buttonFrame.size.width + 10.0f, 0.0f);
	}
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( Lesson3Board, ENTER, signal )
{
	Lesson3Board * board = [[[Lesson3Board alloc] init] autorelease];
	[self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( Lesson3Board, BACK, signal )
{
	[self.stack popBoardAnimated:YES];
}

@end

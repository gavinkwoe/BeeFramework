//
//  Lesson6_2Board.m
//

#import "Lesson6_2Board.h"

#pragma mark -

@implementation Lesson6_2Board

DEF_SIGNAL( SHOW )
DEF_SIGNAL( HIDE )

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
		[self setTitleString:@"BeeUIActivityIndicator"];
		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back.png"]];

		_indicator = [[BeeUIActivityIndicatorView alloc] initWithFrame:CGRectZero];
		_indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[self.view addSubview:_indicator];
		
		_button1 = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button1.backgroundColor = [UIColor blackColor];
		_button1.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button1.title = @"Start animating";
		_button1.titleColor = [UIColor whiteColor];
		_button1.signal = Lesson6_2Board.SHOW;
		[self.view addSubview:_button1];
		
		_button2 = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button2.backgroundColor = [UIColor blackColor];
		_button2.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button2.title = @"Stop animating";
		_button2.titleColor = [UIColor whiteColor];
		_button2.signal = Lesson6_2Board.HIDE;
		[self.view addSubview:_button2];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _button1 );
		SAFE_RELEASE_SUBVIEW( _button2 );
		SAFE_RELEASE_SUBVIEW( _indicator );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		CGRect indicatorFrame;
		indicatorFrame.size.width = 80.0f;
		indicatorFrame.size.height = 80.0f;
		indicatorFrame.origin.x = (self.viewSize.width - indicatorFrame.size.width) / 2.0f;
		indicatorFrame.origin.y = indicatorFrame.origin.x;
		
		_indicator.frame = indicatorFrame;
		
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

ON_SIGNAL3( Lesson6_2Board, SHOW, signal )
{
	[super handleUISignal:signal];
	
	[_indicator startAnimating];
}

ON_SIGNAL3( Lesson6_2Board, HIDE, signal )
{
	[super handleUISignal:signal];
	
	[_indicator stopAnimating];
}

@end

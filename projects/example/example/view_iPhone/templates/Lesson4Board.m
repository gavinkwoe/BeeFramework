//
//  Lesson4Board.m
//

#import "Lesson4Board.h"

#pragma mark -

@implementation Lesson4InnerBoard

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
		[self hideNavigationBarAnimated:NO];
		
		_button1 = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button1.backgroundColor = [UIColor blackColor];
		_button1.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button1.title = @"< Back";
		_button1.titleColor = [UIColor whiteColor];
		_button1.signal = Lesson4InnerBoard.BACK;
		[self.view addSubview:_button1];
		
		_button2 = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button2.backgroundColor = [UIColor blackColor];
		_button2.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button2.title = @"Enter >";
		_button2.titleColor = [UIColor whiteColor];
		_button2.signal = Lesson4InnerBoard.ENTER;
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
		buttonFrame.origin.y = self.viewSize.height - buttonFrame.size.height - 10.0f - 44.0f;
		
		_button1.frame = buttonFrame;
		_button2.frame = CGRectOffset(buttonFrame, buttonFrame.size.width + 10.0f, 0.0f);
	}
}

- (void)handleUISignal_Lesson4InnerBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:Lesson4InnerBoard.ENTER] )
	{
		Lesson4InnerBoard * board = [[[Lesson4InnerBoard alloc] init] autorelease];
		[self.stack pushBoard:board animated:YES];
	}
	else if ( [signal is:Lesson4InnerBoard.BACK] )
	{
		[self.stack popBoardAnimated:YES];
	}
}

@end

#pragma mark -

@implementation Lesson4Board

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
		BeeUISegmentedControl * seg = [BeeUISegmentedControl spawn];
		[seg addTitle:@"Page 1" tag:0];
		[seg addTitle:@"Page 2" tag:1];
		[seg setSelectedSegmentIndex:0];
		[self setTitleView:seg];
		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back.png"]];

		_router = [[BeeUIRouter alloc] init];
		[_router map:@"page1" toClass:[Lesson4InnerBoard class]];
		[_router map:@"page2" toClass:[Lesson4InnerBoard class]];
		[self.view addSubview:_router.view];
		
		[_router open:@"page1"];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[_router.view removeFromSuperview];
		[_router release];
		_router = nil;
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_router.view.frame = self.bounds;
	}
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUISegmentedControl, HIGHLIGHT_CHANGED, signal )
{
	BeeUISegmentedControl * titleView = signal.source;
	if ( 0 == titleView.selectedTag )
	{
		[_router open:@"page1"];
	}
	else
	{
		[_router open:@"page2"];
	}
}

@end

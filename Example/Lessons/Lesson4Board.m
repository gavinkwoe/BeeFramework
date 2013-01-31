//
//  Lesson4Board.m
//

#import "Lesson4Board.h"

#pragma mark -

@implementation Lesson4InnerBoard

DEF_SIGNAL( BACK );
DEF_SIGNAL( ENTER );

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		[self hideNavigationBarAnimated:NO];
		
		_textView.contentInset = UIEdgeInsetsMake( 0, 0, 44.0f + 20.0f, 0.0f );
		
		_button1 = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button1.backgroundColor = [UIColor blackColor];
		_button1.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button1.stateNormal.title = @"< Back";
		_button1.stateNormal.titleColor = [UIColor whiteColor];
		[_button1 addSignal:Lesson4InnerBoard.BACK forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_button1];
		
		_button2 = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button2.backgroundColor = [UIColor blackColor];
		_button2.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_button2.stateNormal.title = @"Enter >";
		_button2.stateNormal.titleColor = [UIColor whiteColor];
		[_button2 addSignal:Lesson4InnerBoard.ENTER forControlEvents:UIControlEventTouchUpInside];
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

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
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

		[self append:[BeeUIStack stackWithFirstBoardClass:[Lesson4InnerBoard class]]];
		[self append:[BeeUIStack stackWithFirstBoardClass:[Lesson4InnerBoard class]]];
		[self present:[self.stacks objectAtIndex:0]];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
}

- (void)handleUISignal_BeeUISegmentedControl:(BeeUISignal *)signal
{
	if ( [signal is:BeeUISegmentedControl.HIGHLIGHT_CHANGED] )
	{
		BeeUISegmentedControl * titleView = (BeeUISegmentedControl *)self.titleView;
		[self present:[self.stacks objectAtIndex:titleView.selectedTag]];
	}
}

@end

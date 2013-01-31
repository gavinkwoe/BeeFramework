//
//  Lesson2Board.m
//

#import "Lesson2Board.h"

#pragma mark -

@implementation Lesson2View2

DEF_SIGNAL( TEST )

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		_innerView = [[BeeUIButton alloc] initWithFrame:CGRectToBound(frame)];
		_innerView.backgroundColor = [UIColor blackColor];
		_innerView.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_innerView.stateNormal.title = @"Click";
		_innerView.stateNormal.titleColor = [UIColor whiteColor];
		[_innerView addSignal:Lesson2View2.TEST forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_innerView];
	}
	return self;
}

- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _innerView );
	[super dealloc];
}

@end

#pragma mark -

@implementation Lesson2View1

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		_innerView = [[Lesson2View2 alloc] initWithFrame:CGRectToBound(frame)];
		_innerView.backgroundColor = [UIColor clearColor];
		[self addSubview:_innerView];
	}
	return self;
}

- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _innerView );
	[super dealloc];
}

@end

#pragma mark -

@implementation Lesson2Board

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		[self setTitleString:@"Lesson 2"];
		[self showNavigationBarAnimated:NO];

		_textView.contentInset = UIEdgeInsetsMake( 0, 0, 44.0f + 20.0f, 0.0f );
		
		CGRect innerFrame;
		innerFrame.size.width = self.viewSize.width - 20.0f;
		innerFrame.size.height = 44.0f;
		innerFrame.origin.x = 10.0f;
		innerFrame.origin.y = self.viewSize.height - innerFrame.size.height - 10.0f;
		
		_innerView = [[Lesson2View1 alloc] initWithFrame:innerFrame];
		_innerView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:_innerView];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _innerView );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
	}	
}

// Lesson2View1 signal goes here
- (void)handleUISignal_Lesson2View1:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
}

// Lesson2View2 signal goes here
- (void)handleUISignal_Lesson2View2:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:Lesson2View2.TEST] )
	{
		[BeeUIAlertView showMessage:@"Signal received" cancelTitle:@"OK"];
	}
}

@end

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
		_innerView.title = @"Click";
		_innerView.titleColor = [UIColor whiteColor];
		_innerView.signal = self.TEST;
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
		[self setTitleString:@"Lesson 2"];
		[self showNavigationBarAnimated:NO];
		[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back.png"]];

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

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[self.stack popBoardAnimated:YES];
}

ON_SIGNAL2( Lesson2View1, signal )
{
	[super handleUISignal:signal];
}

ON_SIGNAL3( Lesson2View2, TEST, signal )
{
	[super handleUISignal:signal];
	
	[BeeUIAlertView showMessage:@"Touched" cancelTitle:@"OK"];
}

@end

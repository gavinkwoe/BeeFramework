//
//  Lesson10Board.m
//

#import "Lesson10Board.h"

#pragma mark -

@implementation Lesson10Board

DEF_SIGNAL( BUTTON1_TOUCHED )
DEF_SIGNAL( BUTTON2_TOUCHED )

- (void)load
{
	[super load];
	
	_model = [[Lesson10Model alloc] init];
}

- (void)unload
{
	[_model release];
	
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
		[self setTitleString:@"Lesson 10"];
		
		_textView = [[BeeUITextView alloc] initWithFrame:CGRectZero];
		_textView.font = [UIFont boldSystemFontOfSize:14.0f];
		_textView.textColor = [UIColor blackColor];
		_textView.textAlignment = UITextAlignmentLeft;
		_textView.editable = YES;
		_textView.dataDetectorTypes = UIDataDetectorTypeLink;
		_textView.scrollEnabled = YES;
		_textView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_textView.layer.borderColor = [UIColor grayColor].CGColor;
		_textView.layer.borderWidth = 2.0f;
		_textView.returnKeyType = UIReturnKeyDone;
		[self.view addSubview:_textView];
		
		_button1 = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button1.backgroundColor = [UIColor blackColor];
		_button1.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		_button1.stateNormal.title = @"Load cache";
		[_button1 addSignal:Lesson10Board.BUTTON1_TOUCHED forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_button1];
		
		_button2 = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button2.backgroundColor = [UIColor blackColor];
		_button2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		_button2.stateNormal.title = @"Save cache";
		[_button2 addSignal:Lesson10Board.BUTTON2_TOUCHED forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_button2];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _textView );
		SAFE_RELEASE_SUBVIEW( _button1 );
		SAFE_RELEASE_SUBVIEW( _button2 );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_textView.frame = CGRectInset(self.viewBound, 5.0f, 5.0f);
		
		CGRect buttonFrame;
		buttonFrame.size.width = (self.viewSize.width - 30.0f) / 2.0f;
		buttonFrame.size.height = 44.0f;
		buttonFrame.origin.x = 10.0f;
		buttonFrame.origin.y = self.viewSize.height - buttonFrame.size.height - 10.0f;
		
		_button1.frame = buttonFrame;
		_button2.frame = CGRectOffset(buttonFrame, buttonFrame.size.width + 10.0f, 0.0f);
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{
	}
}

- (void)handleUISignal_Lesson10Board:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal is:Lesson10Board.BUTTON1_TOUCHED] )
	{
		self.title = @"Loaded";
		
		[_model loadCache];
		
		_textView.text = _model.text;
	}
	else if ( [signal is:Lesson10Board.BUTTON2_TOUCHED] )
	{
		self.title = @"Saved";
		
		_model.date = [NSDate date];
		_model.text = _textView.text;
		
		[_model saveCache];
	}
}

- (void)handleUISignal_BeeUITextView:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal is:BeeUITextView.RETURN] )
	{
		[_textView resignFirstResponder];
	}
}

@end

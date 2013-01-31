//
//  LessonBaseBoard.m
//

#import "LessonBaseBoard.h"

#pragma mark -

@implementation LessonBaseBoard

DEF_SINGLETON( LessonBaseBoard );

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			_textView = [[BeeUITextView alloc] initWithFrame:CGRectInset(self.viewBound, 5.0f, 5.0f)];
			_textView.font = [UIFont boldSystemFontOfSize:12.0f];
			_textView.textColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
			_textView.editable = NO;
			[self.view addSubview:_textView];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{	
			SAFE_RELEASE_SUBVIEW( _textView );
		}
	}
	
	[self updateText];
}

- (void)updateText
{
#if __BEE_DEVELOPMENT__
	NSMutableString * text = [NSMutableString string];
	for ( NSUInteger i = 0; i < self.signals.count; ++i )
	{
		BeeUISignal * signal = [self.signals objectAtIndex:i];
		[text appendFormat:@"[%d] %@\n", self.signalSeq - i, signal.name];
	}

	_textView.text = text;
	_textView.scrollEnabled = YES;
	_textView.showsVerticalScrollIndicator = YES;
	[_textView flashScrollIndicators];	
#endif	// #ifdef __BEE_DEVELOPMENT__
}

@end

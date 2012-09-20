//
//  LessionBaseBoard.m
//

#import "LessionBaseBoard.h"

#pragma mark -

@implementation LessionBaseBoard

DEF_SINGLETON( LessionBaseBoard );

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			_textView = [[BeeUITextView alloc] initWithFrame:CGRectInset(self.viewBound, 5.0f, 5.0f)];
			_textView.font = [BeeUIFont height:12.0f bold:YES];
			_textView.textColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
			[self.view addSubview:_textView];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{	
			SAFE_RELEASE_SUBVIEW( _textView );
		}
	}
	
	[self log:signal.name];
}

- (void)log:(NSString *)msg
{
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease]];
	[formatter setDateFormat:@"hh:mm:ss"];

	_textView.text = [NSString stringWithFormat:@"%@ %@\n%@",
					  [formatter stringFromDate:[NSDate date]], msg, _textView.text];
	_textView.scrollEnabled = YES;
	_textView.showsVerticalScrollIndicator = YES;
	[_textView flashScrollIndicators];
	
	[formatter release];
}

@end

//
//  Lession2Board.m
//

#import "Lession2Board.h"

#define MY_SIGNAL	@"my.someSignal"

#pragma mark -

@implementation Lession2Board

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self setTitleString:@"Lession 2"];
			[self showNavigationBarAnimated:NO];

			_textView.contentInset = UIEdgeInsetsMake( 0, 0, 44.0f + 20.0f, 0.0f );
			
			CGRect buttonFrame;
			buttonFrame.size.width = (self.viewSize.width - 30.0f) / 2.0f;
			buttonFrame.size.height = 44.0f;
			buttonFrame.origin.x = 10.0f;
			buttonFrame.origin.y = self.viewSize.height - buttonFrame.size.height - 10.0f;

			// button1点击时，将发送系统信号 BeeUIButton.TOUCH_UP_INSIDE
			_button1 = [[BeeUIButton alloc] initWithFrame:buttonFrame];
			_button1.backgroundColor = [UIColor blackColor];
			_button1.titleLabel.font = [BeeUIFont height:12.0f bold:YES];
			_button1.stateNormal.title = @"Send system Signal";
			_button1.stateNormal.titleColor = [UIColor whiteColor];
			[self.view addSubview:_button1];

			// button2点击时，将发送我们自定义的信号 MY_SIGNAL
			_button2 = [[BeeUIButton alloc] initWithFrame:CGRectOffset(buttonFrame, buttonFrame.size.width + 10.0f, 0.0f)];
			_button2.backgroundColor = [UIColor blackColor];
			_button2.titleLabel.font = [BeeUIFont height:12.0f bold:YES];
			_button2.stateNormal.title = @"Send custom Signal";
			_button2.stateNormal.titleColor = [UIColor whiteColor];
			[_button2 addSignal:MY_SIGNAL forControlEvents:UIControlEventTouchUpInside];
			[self.view addSubview:_button2];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			SAFE_RELEASE_SUBVIEW( _button1 );
			SAFE_RELEASE_SUBVIEW( _button2 );
		}
	}
	else if ( [signal isKindOf:BeeUIButton.SIGNAL] )	// 如果是从某个BUTTON发过来的
	{
		if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )	// 如果是点击抬起
		{
			NSAssert( signal.source == _button1, @"" );
			
			[self log:[NSString stringWithFormat:@"系统信号, %@", [signal description]]];
		}
	}
	else if ( [signal isKindOf:@"my."] )				// 如果是用户BUTTON发过来的
	{
		if ( [signal is:MY_SIGNAL] )					// 如果是用户自定义信号
		{
			NSAssert( signal.source == _button2, @"" );
			
			[self log:[NSString stringWithFormat:@"用户信号, %@", [signal description]]];
		}
	}
}

@end

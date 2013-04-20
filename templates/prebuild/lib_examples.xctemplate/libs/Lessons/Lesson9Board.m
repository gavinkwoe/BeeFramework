//
//  Lesson9Board.m
//

#import "Lesson9Board.h"
#import "Lesson9Controller.h"
#import "JSONKit.h"

#pragma mark -

@implementation Lesson9Board

DEF_SIGNAL( BUTTON1_TOUCHED )
DEF_SIGNAL( BUTTON2_TOUCHED )

- (void)load
{
	[super load];
}

- (void)unload
{
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
		[self setTitleString:@"Lesson 9"];
		
		_button1 = [BeeUIButton new]; // [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button1.backgroundColor = [UIColor blackColor];
		_button1.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		_button1.stateNormal.title = @"Local message";
		[_button1 addSignal:Lesson9Board.BUTTON1_TOUCHED forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_button1];
		
		_button2 = [BeeUIButton new]; // [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button2.backgroundColor = [UIColor blackColor];
		_button2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		_button2.stateNormal.title = @"Remote message";
		[_button2 addSignal:Lesson9Board.BUTTON2_TOUCHED forControlEvents:UIControlEventTouchUpInside];
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

- (void)handleUISignal_Lesson9Board:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:Lesson9Board.BUTTON1_TOUCHED] )
	{
		if ( [self sendingMessage:Lesson9Controller.LOCAL] )
		{
			[self cancelMessage:Lesson9Controller.LOCAL];
		}
		else
		{
			[self sendMessage:Lesson9Controller.LOCAL timeoutSeconds:10.0f];
		}
	}
	else if ( [signal is:Lesson9Board.BUTTON2_TOUCHED] )
	{
		if ( [self sendingMessage:Lesson9Controller.REMOTE] )
		{
			[self cancelMessage:Lesson9Controller.REMOTE];
		}
		else
		{
			[[self sendMessage:Lesson9Controller.REMOTE timeoutSeconds:10.0f] input:
			 @"url", @"http://blog.whatsbug.com", nil];
		}
	}
}

- (void)handleMessage:(BeeMessage *)msg
{
	[super handleMessage:msg];
}

- (void)handleMessage_Lesson9Controller:(BeeMessage *)msg
{
	[super handleMessage:msg];

	if ( [msg is:Lesson9Controller.LOCAL] )
	{
		if ( msg.sending )
		{
			_button1.stateNormal.title = @"Cancel";
		}
		else
		{
			_button1.stateNormal.title = @"Local message";
		}
		
		if ( msg.succeed )
		{
			[BeeUIAlertView showMessage:[msg.output description] cancelTitle:@"OK"];
		}
	}
	else if ( [msg is:Lesson9Controller.REMOTE] )
	{
		if ( msg.sending )
		{
			_button2.stateNormal.title = @"Cancel";
		}
		else
		{
			_button2.stateNormal.title = @"Remote message";
		}
		
		if ( msg.sending )
		{
			// TODO: 当发送
			
			self.title = @"Communicating...";
		}
		else if ( msg.failed )
		{
			// TODO: 当失败
			
			self.title = @"Failed";
		}
		else if ( msg.succeed )
		{
			// TODO: 当成功
			
			self.title = @"Succeed";
			
			[BeeUIAlertView showMessage:[msg.output description] cancelTitle:@"OK"];
		}
		else if ( msg.cancelled )
		{
			// TODO: 当取消
			
			self.title = @"Cancelled";
		}
	}
}

@end

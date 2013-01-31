//
//  Lesson8Board.m
//

#import "Lesson8Board.h"

#pragma mark -

@implementation Lesson8Board

DEF_SIGNAL( BUTTON_TOUCHED )

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
		[self setTitleString:@"Lesson 8"];
		
		_button = [[BeeUIButton alloc] initWithFrame:CGRectZero];
		_button.backgroundColor = [UIColor blackColor];
		_button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
		_button.stateNormal.title = @"Send request";
		[_button addSignal:Lesson8Board.BUTTON_TOUCHED forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_button];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _button );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		CGRect buttonFrame;
		buttonFrame.size.width = self.viewSize.width - 30.0f;
		buttonFrame.size.height = 44.0f;
		buttonFrame.origin.x = 10.0f;
		buttonFrame.origin.y = self.viewSize.height - buttonFrame.size.height - 10.0f;
		_button.frame = buttonFrame;
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

- (void)handleUISignal_UINavigationBar:(BeeUISignal *)signal
{
	if ( [signal is:UINavigationBar.BACK_BUTTON_TOUCHED] )
	{
		
	}
	else if ( [signal is:UINavigationBar.DONE_BUTTON_TOUCHED] )
	{
	}	
}

- (void)handleUISignal_Lesson8Board:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:Lesson8Board.BUTTON_TOUCHED] )
	{
		if ( [self requestingURL:@"http://blog.whatsbug.com"] )
		{
			[self cancelRequests];
		}
		else
		{
			[self HTTP_GET:@"http://blog.whatsbug.com"];
		}
	}
}

- (void)handleRequest:(BeeRequest *)request
{
	if ( [request is:@"http://blog.whatsbug.com"] )
	{
		if ( request.sending )
		{
			_button.stateNormal.title = @"Cancel request";
		}
		else
		{
			_button.stateNormal.title = @"Send request";
		}
		
		if ( request.created )
		{
			// TODO: 等待建立连接
			
			self.title = @"Connecting...";
		}
		else if ( request.sending )
		{
			// TODO: 正在发送数据
			
			self.title = @"Sending...";
		}
		else if ( request.recving )
		{
			// TODO: 正在接收数据
			
			self.title = @"Receiving...";
		}
		else if ( request.failed )
		{
			// TODO: 请求失败
			
			self.title = @"Failed";
		}
		else if ( request.succeed )
		{
			// TODO: 请求成功
			
			self.title = @"Succeed";
			
			[BeeUIAlertView showMessage:request.responseString cancelTitle:@"OK"];
		}
		else if ( request.cancelled )
		{
			// TODO: 请求被取消
			
			self.title = @"Cancelled";
		}
		else if ( request.sendProgressed )
		{
			// TODO: 正在发送数据，更新百分比
			
			self.title = [NSString stringWithFormat:@"Sending(%f%%)", request.uploadPercent];
		}
		else if ( request.recvProgressed )
		{
			// TODO: 正在接收数据，更新百分比
			
			self.title = [NSString stringWithFormat:@"Receiving(%f%%)", request.downloadPercent];
		}
	}
}

@end

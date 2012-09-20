//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//
//
//  Bee_DebugMessageBoard.h
//

#if __BEE_DEBUGGER__

#import <QuartzCore/QuartzCore.h>
#import "Bee_DebugWindow.h"
#import "Bee_DebugMessageBoard.h"
#import "Bee_DebugMessageModel.h"

#pragma mark -

@implementation BeeDebugMessageDetailView

- (void)setMessage:(BeeMessage *)message
{
	NSMutableString * text = [NSMutableString string];
	
	[text appendFormat:@"%@\n\n", message.message];
	
	[text appendFormat:@"========= 耗时(Performance) =========\n"];
	[text appendFormat:@"排队耗时: %.0fms\n", message.timeCostPending * 1000.0f];
	[text appendFormat:@"网络耗时: %.0fms\n", message.timeCostOverAir * 1000.0f];
	[text appendFormat:@"整体耗时: %.0fms\n", message.timeElapsed * 1000.0f];
	[text appendString:@"\n"];

#if __BEE_DEVELOPMENT__
	[text appendFormat:@"========= 调用栈(CallStack) =========\n"];
	[text appendFormat:@"%@\n", message.callstack];	
	[text appendString:@"\n"];
#endif	// #if __BEE_DEVELOPMENT__
	
	[text appendFormat:@"========= 输入参数(Input) =========\n"];
	[text appendFormat:@"%@\n", [message.input description]];
	[text appendString:@"\n"];
	
	[text appendFormat:@"========= 输出结果(Output) =========\n"];
	if ( BEE_ERROR_CODE_OK != message.errorCode )
	{
		[text appendFormat:@"Error: %@（%d）\n", message.errorDomain, message.errorCode];		
	}
	[text appendFormat:@"%@\n", [message.output description]];
	[text appendString:@"\n"];
	
	[text appendFormat:@"========= HTTP请求包体 =========\n"];
	if ( message.request )
	{
		[text appendFormat:@"%@ %@\n", message.request.requestMethod, [message.request.url absoluteString]];
		[text appendString:@"\n"];
		[text appendFormat:@"%@\n", [message.request postBody]];
		[text appendString:@"\n"];
	}
	else
	{
		[text appendFormat:@"(empty)\n"];
		[text appendString:@"\n"];
	}
	
	[text appendFormat:@"========= HTTP回应包体 =========\n"];
	if ( message.request )
	{
		[text appendFormat:@"%@\n", [message.request responseString]];
		[text appendString:@"\n"];
	}
	else
	{
		[text appendFormat:@"(empty)\n"];
		[text appendString:@"\n"];
	}

	_content.text = text;
}

@end

#pragma mark -

@implementation BeeDebugMessageCell

+ (CGSize)cellSize:(NSObject *)data bound:(CGSize)bound
{
	return CGSizeMake( bound.width, 40.0f );
}

- (void)cellLayout:(BeeUIGridCell *)cell bound:(CGSize)bound
{
	CGRect timeFrame;
	timeFrame.size.width = 70.0f;
	timeFrame.size.height = bound.height;
	timeFrame.origin = CGPointZero;
	_timeLabel.frame = timeFrame;
	
	CGRect statusFrame;
	statusFrame.size.width = 70.0f;
	statusFrame.size.height = bound.height;
	statusFrame.origin.x = bound.width - statusFrame.size.width;
	statusFrame.origin.y = 0.0f;
	_statusLabel.frame = statusFrame;
	
	CGRect nameFrame;
	nameFrame.size.width = bound.width - timeFrame.size.width - statusFrame.size.width;
	nameFrame.size.height = bound.height;
	nameFrame.origin.x = timeFrame.size.width;
	nameFrame.origin.y = 0.0f;
	_nameLabel.frame = nameFrame;
}

- (void)load
{
	[super load];
	
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
	self.layer.borderColor = [UIColor colorWithWhite:0.2f alpha:1.0f].CGColor;
	self.layer.borderWidth = 1.0f;

	_timeLabel = [[BeeUILabel alloc] init];
	_timeLabel.textColor = [UIColor grayColor];
	_timeLabel.textAlignment = UITextAlignmentCenter;
	_timeLabel.font = [BeeUIFont height:12.0f bold:YES];
	[self addSubview:_timeLabel];

	_nameLabel = [[BeeUILabel alloc] init];
	_nameLabel.textAlignment = UITextAlignmentLeft;
	_nameLabel.font = [BeeUIFont height:12.0f bold:YES];
	_nameLabel.lineBreakMode = UILineBreakModeTailTruncation;
	_nameLabel.numberOfLines = 2;
	[self addSubview:_nameLabel];

	_statusLabel = [[BeeUILabel alloc] init];
	_statusLabel.textAlignment = UITextAlignmentCenter;
	_statusLabel.font = [BeeUIFont height:12.0f bold:YES];
	_statusLabel.lineBreakMode = UILineBreakModeClip;
	_statusLabel.numberOfLines = 2;
	[self addSubview:_statusLabel];
}

- (void)bindData:(NSObject *)data
{
	BeeMessage * msg = (BeeMessage *)data;
	
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease]];
	[formatter setDateFormat:@"hh:mm:ss"];
	NSDate * date2 = [NSDate dateWithTimeIntervalSince1970:msg.initTimeStamp];
	_timeLabel.text = [formatter stringFromDate:date2];
	[formatter release];

	_nameLabel.text = msg.message;
	
	if ( msg.created )
	{
		_statusLabel.text = @"Created";
		_statusLabel.textColor = [UIColor whiteColor];
	}
	else if ( msg.sending )
	{
		_statusLabel.text = [NSString stringWithFormat:@"Sending\n%dK / %dK",
							 [msg.request uploadBytes] / 1024,
							 [msg.request downloadBytes] / 1024];
		_statusLabel.textColor = [UIColor yellowColor];		
	}
	else if ( msg.succeed )
	{
//		_statusLabel.text = [NSString stringWithFormat:@"Succeed\n%dK / %dK",
//							 [msg.request uploadBytes] / 1024,
//							 [msg.request downloadBytes] / 1024];
		_statusLabel.text = @"Succeed";
		_statusLabel.textColor = [UIColor greenColor];
	}
	else if ( msg.failed )
	{
		if ( msg.timeout )
		{
			_statusLabel.text = @"Timeout";
			_statusLabel.textColor = [UIColor redColor];			
		}
		else
		{
			_statusLabel.text = @"Failed";
			_statusLabel.textColor = [UIColor redColor];
		}
	}
	else if ( msg.cancelled )
	{
		_statusLabel.text = @"Cancelled";
		_statusLabel.textColor = [UIColor grayColor];
	}
	else
	{
		_statusLabel.text = @"";
		_statusLabel.textColor = [UIColor whiteColor];
	}
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _nameLabel );
	SAFE_RELEASE_SUBVIEW( _timeLabel );
	SAFE_RELEASE_SUBVIEW( _statusLabel );
	
	[super unload];
}

@end

#pragma mark -

@implementation BeeDebugMessageBoard

DEF_SINGLETON( BeeDebugMessageBoard )

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self setBaseInsets:UIEdgeInsetsMake(0.0f, 0, 44.0f, 0)];

			[self observeTick];
			[self handleTick:0.0f];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			[self unobserveTick];
		}
	}
}

- (void)handleTick:(NSTimeInterval)elapsed
{
	[self syncReloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSObject * data = [[BeeDebugMessageModel sharedInstance].history objectAtIndex:indexPath.row];
	CGSize bound = CGSizeMake( self.viewSize.width, 0.0f );
	return [BeeDebugMessageCell cellSize:data bound:bound].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[BeeDebugMessageModel sharedInstance].history count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = (BeeUITableViewCell *)[self dequeueWithContentClass:[BeeDebugMessageCell class]];
	if ( cell )
	{
		[cell bindData:[[BeeDebugMessageModel sharedInstance].history objectAtIndex:indexPath.row]];
		return cell;
	}

	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGRect detailFrame = self.viewBound;
	detailFrame.size.height -= 44.0f;
	
	BeeDebugMessageDetailView * detailView = [[BeeDebugMessageDetailView alloc] initWithFrame:detailFrame];
	[detailView setMessage:(BeeMessage *)[[BeeDebugMessageModel sharedInstance].history objectAtIndex:indexPath.row]];
	[self presentModalView:detailView animated:YES];
	[detailView release];
}

@end

#endif	// #if __BEE_DEBUGGER__

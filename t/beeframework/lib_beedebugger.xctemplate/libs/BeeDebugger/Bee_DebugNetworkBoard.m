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
//  Bee_DebugNetworkBoard.m
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugWindow.h"
#import "Bee_DebugNetworkBoard.h"
#import "Bee_DebugNetworkModel.h"
#import "Bee_DebugUtility.h"

#pragma mark -

@implementation BeeDebugNetworkDetailView

- (void)setRequest:(BeeRequest *)req
{
	NSMutableString * text = [NSMutableString string];
	[text appendFormat:@"%@ %@\n\n", req.requestMethod, req.url.absoluteString];
	[text appendFormat:@"%@\n\n", [req responseString]];
	
	_content.text = text;
}

@end

#pragma mark -

@implementation BeeDebugNetworkCell

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	return CGSizeMake( bound.width, 50.0f );
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
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
	_urlLabel.frame = nameFrame;
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
	_timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	[self addSubview:_timeLabel];
	
	_urlLabel = [[BeeUILabel alloc] init];
	_urlLabel.textAlignment = UITextAlignmentLeft;
	_urlLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	_urlLabel.lineBreakMode = UILineBreakModeTailTruncation;
	_urlLabel.numberOfLines = 2;
	[self addSubview:_urlLabel];
	
	_statusLabel = [[BeeUILabel alloc] init];
	_statusLabel.textAlignment = UITextAlignmentCenter;
	_statusLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	_statusLabel.lineBreakMode = UILineBreakModeClip;
	_statusLabel.numberOfLines = 2;
	_statusLabel.adjustsFontSizeToFitWidth = YES;
	[self addSubview:_statusLabel];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _urlLabel );
	SAFE_RELEASE_SUBVIEW( _statusLabel );
	SAFE_RELEASE_SUBVIEW( _timeLabel );
	
	[super unload];
}

- (void)dataWillChange
{
	[super dataWillChange];
}

- (void)dataDidChanged
{
	[super dataDidChanged];
	
	BeeRequest * req = (BeeRequest *)self.cellData;
	if ( req )
	{
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease]];
		[formatter setDateFormat:@"hh:mm:ss"];
		NSDate * date2 = [NSDate dateWithTimeIntervalSince1970:req.initTimeStamp];
		_timeLabel.text = [formatter stringFromDate:date2];
		[formatter release];
		
		_urlLabel.text = [req.url absoluteString];

		NSUInteger upSize = req.postLength;
		NSUInteger downSize = [[req rawResponseData] length];
		
		if ( req.created )
		{
			_statusLabel.textColor = [UIColor whiteColor];
			_statusLabel.text = @"Pending";
		}
		else if ( req.sending )
		{
			_statusLabel.textColor = [UIColor yellowColor];
			_statusLabel.text = [NSString stringWithFormat:@"Sending\n%@/%@",
								 [BeeDebugUtility number2String:upSize],
								 [BeeDebugUtility number2String:downSize]];
		}
		else if ( req.recving )
		{
			_statusLabel.textColor = [UIColor yellowColor];
			_statusLabel.text = [NSString stringWithFormat:@"Recving\n%@/%@",
								 [BeeDebugUtility number2String:upSize],
								 [BeeDebugUtility number2String:downSize]];
		}
		else if ( req.failed )
		{
			_statusLabel.textColor = [UIColor redColor];
			_statusLabel.text = [NSString stringWithFormat:@"Failed\nerr%d", req.responseStatusCode];
		}
		else if ( req.succeed )
		{
			_statusLabel.textColor = [UIColor greenColor];
			_statusLabel.text = [NSString stringWithFormat:@"Succeed\n%@/%@",
								 [BeeDebugUtility number2String:upSize],
								 [BeeDebugUtility number2String:downSize]];

	//		_statusLabel.text = @"Succeed";
		}
		else if ( req.cancelled )
		{
			_statusLabel.textColor = [UIColor grayColor];
			_statusLabel.text = @"Cancelled";
		}
	}
}

@end

#pragma mark -

@implementation BeeDebugNetworkBoard

DEF_SINGLETON( BeeDebugNetworkBoard )

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self setBaseInsets:UIEdgeInsetsMake(0.0f, 0, 44.0f, 0)];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
			[self observeTick];
			[self handleTick:0.0f];
		}
		else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
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
#pragma mark TableBoardDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [BeeDebugNetworkModel sharedInstance].history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = [self dequeueWithContentClass:[BeeDebugNetworkCell class]];
	if ( cell )
	{
		cell.cellData = [[BeeDebugNetworkModel sharedInstance].history objectAtIndex:indexPath.row];
	}
	return cell;		
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize bound = CGSizeMake( self.viewSize.width, 0.0f );
	return [BeeDebugNetworkCell sizeInBound:bound forData:nil].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	CGRect bound = [UIScreen mainScreen].bounds;
	bound.origin.x += 10.0f;
	bound.origin.y += 10.0f;
	bound.size.width -= 20.0f;
	bound.size.height -= 20.0f;

	BeeRequest * request = (BeeRequest *)[[BeeDebugNetworkModel sharedInstance].history objectAtIndex:indexPath.row];

	NSString * absoluteURL = [request.url absoluteString];
	NSString * path = [request.url path];

	if ( [path hasSuffix:@".png"] || [path hasSuffix:@".jpg"] || [path hasSuffix:@".jpeg"] || [path hasSuffix:@".gif"] )
	{
		CGRect detailFrame = self.viewBound;
		detailFrame.size.height -= 44.0f;

		BeeDebugImageView * detailView = [[BeeDebugImageView alloc] initWithFrame:detailFrame];
		[detailView setURL:absoluteURL];
		[self presentModalView:detailView animated:YES];
		[detailView release];
	}
	else
	{
		CGRect detailFrame = self.viewBound;
		detailFrame.size.height -= 44.0f;

		BeeDebugNetworkDetailView * detailView = [[BeeDebugNetworkDetailView alloc] initWithFrame:detailFrame];
		[detailView setRequest:request];
		[self presentModalView:detailView animated:YES];
		[detailView release];
	}
}

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

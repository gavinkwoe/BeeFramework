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
//  Bee_DebugViewBoard.m
//

#if __BEE_DEBUGGER__

#import <QuartzCore/QuartzCore.h>
#import "Bee_DebugWindow.h"
#import "Bee_DebugViewBoard.h"
#import "Bee_DebugUtility.h"

#pragma mark -

@implementation BeeDebugViewDetailView

- (void)setBoard:(BeeUIBoard *)board
{
	NSMutableString * text = [NSMutableString string];
	
	[text appendFormat:@"%@(%p)\n\n", [[board class] description], board];

	[text appendFormat:@"========= 成员变量(MemberVar) =========\n"];
	[text appendFormat:@"lastSleep: %f\n", board.lastSleep];
	[text appendFormat:@"lastWeekup: %f\n", board.lastWeekup];

	if ( board.parentBoard )
	{
		[text appendFormat:@"parentBoard: %@(%p)\n", [[board.parentBoard class] description], board.parentBoard];
	}
	else
	{
		[text appendFormat:@"parentBoard: nil\n"];
	}

	[text appendFormat:@"firstEnter: %@\n", board.firstEnter ? @"YES" : @"NO"];
	[text appendFormat:@"presenting: %@\n", board.presenting ? @"YES" : @"NO"];
	[text appendFormat:@"viewBuilt: %@\n", board.viewBuilt ? @"YES" : @"NO"];
	[text appendFormat:@"dataLoaded: %@\n", board.dataLoaded ? @"YES" : @"NO"];
	
	if ( board.deactivated )
	{
		[text appendFormat:@"state: deactivated\n"];
	}
	else if ( board.deactivating )
	{
		[text appendFormat:@"state: deactivating\n"];
	}
	else if ( board.activating )
	{
		[text appendFormat:@"state: activating\n"];
	}
	else if ( board.activated )
	{
		[text appendFormat:@"state: activated\n"];
	}
	
	[text appendFormat:@"createDate: %@\n", [board.createDate description]];
	[text appendFormat:@"\n"];
	
#if __BEE_DEVELOPMENT__
	[text appendFormat:@"========= 调用栈(CallStack) =========\n"];
	[text appendFormat:@"%@\n", board.callstack];	
	[text appendFormat:@"\n"];

	[text appendFormat:@"========= 信号(Signal) =========\n"];
	for ( NSUInteger i = 0; i < board.signals.count; ++i )
	{
		BeeUISignal * signal = [board.signals objectAtIndex:i];
		[text appendFormat:@"[%d] %@\n", board.signalSeq - i, signal.name];
	}
#endif	// #ifdef __BEE_DEVELOPMENT__
	
	_content.text = text;
}

@end

#pragma mark -

@implementation BeeDebugViewCell

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
	statusFrame.size.width = 80.0f;
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
	_nameLabel.lineBreakMode = UILineBreakModeHeadTruncation;
	_nameLabel.numberOfLines = 2;
	[self addSubview:_nameLabel];
	
	_statusLabel = [[BeeUILabel alloc] init];
	_statusLabel.textAlignment = UITextAlignmentCenter;
	_statusLabel.font = [BeeUIFont height:12.0f bold:YES];
	_statusLabel.lineBreakMode = UILineBreakModeClip;
	_statusLabel.numberOfLines = 2;
	[self addSubview:_statusLabel];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _nameLabel );
	SAFE_RELEASE_SUBVIEW( _statusLabel );
	SAFE_RELEASE_SUBVIEW( _timeLabel );
	
	[super unload];
}

- (void)bindData:(NSObject *)data
{
	BeeUIBoard * board = (BeeUIBoard *)data;

	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease]];
	[formatter setDateFormat:@"hh:mm:ss"];
	_timeLabel.text = [formatter stringFromDate:board.createDate];
	[formatter release];

	_nameLabel.text = [[board class] description];

	if ( board.deactivated )
	{
		_statusLabel.textColor = [UIColor grayColor];
		_statusLabel.text = @"Deactivated";
	}
	else if ( board.deactivating )
	{
		_statusLabel.textColor = [UIColor yellowColor];
		_statusLabel.text = @"Deactivating";
	}
	else if ( board.activating )
	{
		_statusLabel.textColor = [UIColor yellowColor];
		_statusLabel.text = @"Activating";
	}
	else if ( board.activated )
	{
		_statusLabel.textColor = [UIColor greenColor];
		_statusLabel.text = @"Activated";
	}
}

@end

#pragma mark -

@implementation BeeDebugViewBoard

DEF_SINGLETON( BeeDebugViewBoard )

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
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self setBaseInsets:UIEdgeInsetsMake(0.0f, 0, 44.0f, 0)];

			[self observeTick];
			[self handleTick:0];
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
#pragma mark TableBoardDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [BeeUIBoard allBoards].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = [self dequeueWithContentClass:[BeeDebugViewCell class]];
	if ( cell )
	{
		[cell bindData:[[BeeUIBoard allBoards] objectAtIndex:indexPath.row]];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize bound = CGSizeMake( self.viewSize.width, 0.0f );
	return [BeeDebugViewCell cellSize:nil bound:bound].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	CGRect bound = [UIScreen mainScreen].bounds;
	bound.origin.x += 10.0f;
	bound.origin.y += 10.0f;
	bound.size.width -= 20.0f;
	bound.size.height -= 20.0f;

	BeeUIBoard * board = (BeeUIBoard *)[[BeeUIBoard allBoards] objectAtIndex:indexPath.row];

	CGRect detailFrame = self.viewBound;
	detailFrame.size.height -= 44.0f;

	BeeDebugViewDetailView * detailView = [[BeeDebugViewDetailView alloc] initWithFrame:detailFrame];
	[detailView setBoard:board];
	[self presentModalView:detailView animated:YES];
	[detailView release];
}

@end

#endif	// #if __BEE_DEBUGGER__

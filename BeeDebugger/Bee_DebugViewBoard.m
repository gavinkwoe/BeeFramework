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

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugWindow.h"
#import "Bee_DebugViewBoard.h"
#import "Bee_DebugUtility.h"
#import "Bee_DebugViewModel.h"

#pragma mark -

#undef	MAX_SIGNAL_HISTORY
#define MAX_SIGNAL_HISTORY	(50)

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
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	[text appendFormat:@"========= 调用栈(CallStack) =========\n"];
	[text appendFormat:@"%@\n", board.callstack];	
	[text appendFormat:@"\n"];

	[text appendFormat:@"========= 信号(Signal) =========\n"];
	for ( NSUInteger i = 0; i < board.signals.count; ++i )
	{
		BeeUISignal * signal = [board.signals objectAtIndex:i];
		[text appendFormat:@"[%d] %@\n", board.signalSeq, signal.name];
	}
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
	_content.text = text;
}

@end

#pragma mark -

@implementation BeeDebugViewCell

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	return CGSizeMake( bound.width, 50.0f );
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
	_plotView.frame = CGSizeMakeBound( bound );
	
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
	nameFrame.size.height = 14.0f;
	nameFrame.origin.x = timeFrame.size.width;
	nameFrame.origin.y = 12.0f;
	_nameLabel.frame = nameFrame;
	_countLabel.frame = CGRectOffset( nameFrame, 0.0f, nameFrame.size.height );
}

- (void)load
{
	[super load];
	
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
	self.layer.borderColor = [UIColor colorWithWhite:0.2f alpha:1.0f].CGColor;
	self.layer.borderWidth = 1.0f;
	
	_plotView = [[BeeDebugPlotsView alloc] initWithFrame:CGRectZero];
	_plotView.alpha = 0.6f;
	_plotView.fill = YES;
	_plotView.border = YES;
	_plotView.lineScale = 1.0f;
	_plotView.lineColor = [UIColor greenColor];
	_plotView.lineWidth = 1.0f;
	_plotView.capacity = MAX_SIGNAL_HISTORY;
	[self addSubview:_plotView];

	_timeLabel = [[BeeUILabel alloc] init];
	_timeLabel.textColor = [UIColor grayColor];
	_timeLabel.textAlignment = UITextAlignmentCenter;
	_timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	_timeLabel.numberOfLines = 2;
	[self addSubview:_timeLabel];
	
	_nameLabel = [[BeeUILabel alloc] init];
	_nameLabel.textAlignment = UITextAlignmentLeft;
	_nameLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	_nameLabel.lineBreakMode = UILineBreakModeTailTruncation;
	_nameLabel.numberOfLines = 1;
	[self addSubview:_nameLabel];

	_countLabel = [[BeeUILabel alloc] init];
	_countLabel.textColor = [UIColor lightGrayColor];
	_countLabel.textAlignment = UITextAlignmentLeft;
	_countLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	_countLabel.lineBreakMode = UILineBreakModeTailTruncation;
	_countLabel.numberOfLines = 1;
	_countLabel.alpha = 0.8f;
	[self addSubview:_countLabel];
	
	_statusLabel = [[BeeUILabel alloc] init];
	_statusLabel.textAlignment = UITextAlignmentCenter;
	_statusLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	_statusLabel.lineBreakMode = UILineBreakModeClip;
	_statusLabel.numberOfLines = 2;
	[self addSubview:_statusLabel];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _plotView );
	SAFE_RELEASE_SUBVIEW( _nameLabel );
	SAFE_RELEASE_SUBVIEW( _countLabel );
	SAFE_RELEASE_SUBVIEW( _statusLabel );
	SAFE_RELEASE_SUBVIEW( _timeLabel );
	
	[super unload];
}

- (NSUInteger)countSubviewsIn:(UIView *)view
{
	NSUInteger subCount = view.subviews.count;

	for ( UIView * subview in view.subviews )
	{
		subCount += [self countSubviewsIn:subview];
	}
	
	return subCount;
}

- (NSUInteger)countUIImageViewsIn:(UIView *)view
{
	NSUInteger subCount = 0;
	
	for ( UIView * subview in view.subviews )
	{
		if ( [subview isKindOfClass:[UIImageView class]] )
		{
			subCount += 1;
		}

		subCount += [self countUIImageViewsIn:subview];
	}
	
	return subCount;
}

- (void)dataWillChange
{
	[super dataWillChange];
}

- (void)dataDidChanged
{
	BeeUIBoard * board = (BeeUIBoard *)self.cellData;
	if ( board )
	{
		NSArray * plots = [[BeeDebugViewModel sharedInstance] plotsForBoard:board];
		
		[_plotView setPlots:plots];
		[_plotView setLowerBound:[BeeDebugViewModel sharedInstance].lowerBound];
		[_plotView setUpperBound:[BeeDebugViewModel sharedInstance].upperBound];
		[_plotView setNeedsDisplay];
		
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease]];
		[formatter setDateFormat:@"hh:mm:ss"];
		_timeLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:board.createDate]];
		[formatter release];
		
		//	_timeLabel.text = [NSString stringWithFormat:@"#%d", board.createSeq];
		
		if ( [[[board class] description] hasPrefix:@"BeeDebug"] )
		{
			_nameLabel.textColor = [UIColor lightGrayColor];
			_nameLabel.text = [[board class] description];
		}
		else
		{
			_nameLabel.textColor = [UIColor whiteColor];
			_nameLabel.text = [[board class] description];
		}
		
		NSUInteger subviewCount = [self countSubviewsIn:board.view];
		NSUInteger imageviewCount = [self countUIImageViewsIn:board.view];
		
		//	if ( subviewCount >= 100 )
		//	{
		//		_countLabel.textColor = [UIColor redColor];
		//	}
		//	else if ( subviewCount >= 50 )
		//	{
		//		_countLabel.textColor = [UIColor yellowColor];
		//	}
		//	else
		//	{
		_countLabel.textColor = [UIColor lightGrayColor];
		//	}
		
		_countLabel.text = [NSString stringWithFormat:@"%d subviews, %d images", subviewCount, imageviewCount];
		
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
	else
	{
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
	return [BeeUIBoard allBoards].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BeeUITableViewCell * cell = [self dequeueWithContentClass:[BeeDebugViewCell class]];
	if ( cell )
	{
		cell.cellData = [[BeeUIBoard allBoards] objectAtIndex:indexPath.row];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize bound = CGSizeMake( self.viewSize.width, 0.0f );
	return [BeeDebugViewCell sizeInBound:bound forData:nil].height;
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

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

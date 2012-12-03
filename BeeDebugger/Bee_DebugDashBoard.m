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
//  BeeDebugDashBoard.m
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugDashBoard.h"
#import "Bee_DebugUtility.h"
#import "Bee_DebugMemoryModel.h"
#import "Bee_DebugMessageModel.h"
#import "Bee_DebugNetworkModel.h"

#pragma mark -

@implementation BeeDebugMemoryView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		self.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
		self.layer.borderWidth = 1.0f;

		CGRect plotFrame;
		plotFrame.size.width = frame.size.width;
		plotFrame.size.height = 90.0f;
		plotFrame.origin.x = 0.0f;
		plotFrame.origin.y = 20.0f;

		_plotView1 = [[BeeDebugPlotsView alloc] initWithFrame:plotFrame];
		_plotView1.alpha = 0.6f;
		_plotView1.lowerBound = 0.0f;
		_plotView1.upperBound = 0.0f;
		_plotView1.lineColor = [UIColor greenColor];
		_plotView1.lineWidth = 1.0f;
		_plotView1.capacity = MAX_MEMORY_HISTORY;
		[self addSubview:_plotView1];

		_plotView2 = [[BeeDebugPlotsView alloc] initWithFrame:plotFrame];
		_plotView2.alpha = 0.6f;
		_plotView2.lowerBound = 0.0f;
		_plotView2.upperBound = 0.0f;
		_plotView2.lineColor = [UIColor grayColor];
		_plotView2.lineWidth = 1.0f;
		_plotView2.capacity = MAX_MEMORY_HISTORY;
		[self addSubview:_plotView2];
		
		CGRect titleFrame;
		titleFrame.size.width = 60.0f;
		titleFrame.size.height = 20.0f;
		titleFrame.origin.x = 8.0f;
		titleFrame.origin.y = 0.0f;

		_titleView = [[BeeUILabel alloc] initWithFrame:titleFrame];
		_titleView.textColor = [UIColor orangeColor];
		_titleView.textAlignment = UITextAlignmentLeft;
		_titleView.font = [UIFont boldSystemFontOfSize:12.0f];
		_titleView.lineBreakMode = UILineBreakModeClip;
		_titleView.numberOfLines = 1;
		_titleView.text = @"Memory";
		[self addSubview:_titleView];

		CGRect statusFrame;
		statusFrame.size.width = frame.size.width - 16.0f - 60.0f;
		statusFrame.size.height = 20.0f;
		statusFrame.origin.x = 68.0f;
		statusFrame.origin.y = 0.0f;

		_statusView = [[BeeUILabel alloc] initWithFrame:statusFrame];
		_statusView.textColor = [UIColor lightGrayColor];
		_statusView.textAlignment = UITextAlignmentLeft;
		_statusView.font = [UIFont boldSystemFontOfSize:12.0f];
		_statusView.lineBreakMode = UILineBreakModeClip;
		_statusView.numberOfLines = 1;
		[self addSubview:_statusView];

		CGRect allocFrame;
		allocFrame.size.width = 50.0f;
		allocFrame.size.height = 26.0f;
		allocFrame.origin.x = 4.0f;
		allocFrame.origin.y = frame.size.height - 30.0f;

		_manualAlloc = [[BeeUIButton alloc] initWithFrame:allocFrame];
		_manualAlloc.backgroundColor = [UIColor darkGrayColor];
		_manualAlloc.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_manualAlloc.layer.borderWidth = 2.0f;
		_manualAlloc.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_manualAlloc.stateNormal.title = @"+50M";
		_manualAlloc.stateNormal.titleColor = [UIColor whiteColor];
		[_manualAlloc addSignal:@"ALLOC" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_manualAlloc];
		
		allocFrame.origin.x += allocFrame.size.width + 3.0f;
		
		_manualFree = [[BeeUIButton alloc] initWithFrame:allocFrame];
		_manualFree.backgroundColor = [UIColor darkGrayColor];
		_manualFree.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_manualFree.layer.borderWidth = 2.0f;
		_manualFree.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_manualFree.stateNormal.title = @"-50M";
		_manualFree.stateNormal.titleColor = [UIColor whiteColor];
		[_manualFree addSignal:@"FREE" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_manualFree];
		
		allocFrame.origin.x += allocFrame.size.width + 3.0f;
		
		_manualAllocAll = [[BeeUIButton alloc] initWithFrame:allocFrame];
		_manualAllocAll.backgroundColor = [UIColor darkGrayColor];
		_manualAllocAll.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_manualAllocAll.layer.borderWidth = 2.0f;
		_manualAllocAll.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_manualAllocAll.stateNormal.title = @"+ALL";
		_manualAllocAll.stateNormal.titleColor = [UIColor whiteColor];
		[_manualAllocAll addSignal:@"ALLOC_ALL" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_manualAllocAll];

		allocFrame.origin.x += allocFrame.size.width + 3.0f;
		
		_manualFreeAll = [[BeeUIButton alloc] initWithFrame:allocFrame];
		_manualFreeAll.backgroundColor = [UIColor darkGrayColor];
		_manualFreeAll.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_manualFreeAll.layer.borderWidth = 2.0f;
		_manualFreeAll.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_manualFreeAll.stateNormal.title = @"-ALL";
		_manualFreeAll.stateNormal.titleColor = [UIColor whiteColor];
		[_manualFreeAll addSignal:@"FREE_ALL" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_manualFreeAll];
		
		CGRect warningFrame;
		warningFrame.size.width = 100.0f;
		warningFrame.size.height = 26.0f;
		warningFrame.origin.x = frame.size.width - warningFrame.size.width - 4.0f;
		warningFrame.origin.y = frame.size.height - 30.0f;
		
		_autoWarning = [[BeeUIButton alloc] initWithFrame:warningFrame];
		_autoWarning.backgroundColor = [UIColor darkGrayColor];
		_autoWarning.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_autoWarning.layer.borderWidth = 2.0f;
		_autoWarning.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_autoWarning.stateNormal.title = @"Warning(Off)";
		_autoWarning.stateNormal.titleColor = [UIColor whiteColor];
		[_autoWarning addSignal:@"WARNING" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_autoWarning];
	}
	return self;
}

- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _titleView );
	SAFE_RELEASE_SUBVIEW( _statusView );
	SAFE_RELEASE_SUBVIEW( _plotView1 );
	SAFE_RELEASE_SUBVIEW( _plotView2 );
	SAFE_RELEASE_SUBVIEW( _manualAllocAll );
	SAFE_RELEASE_SUBVIEW( _manualFreeAll );
	SAFE_RELEASE_SUBVIEW( _manualAlloc );
	SAFE_RELEASE_SUBVIEW( _manualFree );
	SAFE_RELEASE_SUBVIEW( _autoWarning );

	[super dealloc];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:@"ALLOC_ALL"] )
	{
		[[BeeDebugMemoryModel sharedInstance] allocAll];
		
		[self update];
	}
	else if ( [signal is:@"FREE_ALL"] )
	{
		[[BeeDebugMemoryModel sharedInstance] freeAll];
		
		[self update];
	}
	else if ( [signal is:@"ALLOC"] )
	{
		[[BeeDebugMemoryModel sharedInstance] alloc50M];

		[self update];
	}
	else if ( [signal is:@"FREE"] )
	{
		[[BeeDebugMemoryModel sharedInstance] free50M];
		
		[self update];
	}
	else if ( [signal is:@"WARNING"] )
	{
		[[BeeDebugMemoryModel sharedInstance] toggleWarning];
		
		if ( [BeeDebugMemoryModel sharedInstance].warningMode )
		{
			_autoWarning.stateNormal.title = @"Warning(On)";
			_autoWarning.stateNormal.titleColor = [UIColor greenColor];
		}
		else
		{
			_autoWarning.stateNormal.title = @"Warning(Off)";
			_autoWarning.stateNormal.titleColor = [UIColor whiteColor];
		}
		
		[self update];
	}
}

- (void)update
{
	NSUInteger used = [BeeDebugMemoryModel sharedInstance].usedBytes;
	NSUInteger total = [BeeDebugMemoryModel sharedInstance].totalBytes;
	
	float percent = (total > 0.0f) ? ((float)used / (float)total * 100.0f) : 0.0f;
	if ( percent >= 50.0f )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.6f];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationRepeatAutoreverses:YES];
		[UIView setAnimationRepeatCount:999999];
		
		self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6f];
		
		[UIView commitAnimations];
	}
	else
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.6f];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationRepeatAutoreverses:NO];
		[UIView setAnimationRepeatCount:1];
		
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		
		[UIView commitAnimations];
	}

	[_plotView1 setPlots:[BeeDebugMemoryModel sharedInstance].chartDatas];
	[_plotView1 setLowerBound:[BeeDebugMemoryModel sharedInstance].lowerBound];
	[_plotView1 setUpperBound:[BeeDebugMemoryModel sharedInstance].upperBound];
	[_plotView1 setNeedsDisplay];

	[_plotView2 setPlots:[BeeDebugMemoryModel sharedInstance].chartDatas];
	[_plotView2 setLowerBound:0];
	[_plotView2 setUpperBound:[BeeDebugMemoryModel sharedInstance].totalBytes];
	[_plotView2 setNeedsDisplay];
	
	NSMutableString * text = [NSMutableString string];
	[text appendFormat:@"Used:%@ (%.0f%%)   ", [BeeDebugUtility number2String:used], percent];
	[text appendFormat:@"Free:%@  ", [BeeDebugUtility number2String:total - used]];
	_statusView.text = text;
}

@end

#pragma mark -

@implementation BeeDebugMessageView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		self.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
		self.layer.borderWidth = 1.0f;

		CGRect titleFrame;
		titleFrame.size.width = 60.0f;
		titleFrame.size.height = 20.0f;
		titleFrame.origin.x = 8.0f;
		titleFrame.origin.y = 0.0f;
		
		_titleView = [[BeeUILabel alloc] initWithFrame:titleFrame];
		_titleView.textColor = [UIColor orangeColor];
		_titleView.textAlignment = UITextAlignmentLeft;
		_titleView.font = [UIFont boldSystemFontOfSize:12.0f];
		_titleView.lineBreakMode = UILineBreakModeClip;
		_titleView.numberOfLines = 1;
		_titleView.text = @"Message";
		[self addSubview:_titleView];
		
		CGRect statusFrame;
		statusFrame.size.width = frame.size.width - 16.0f - 60.0f;
		statusFrame.size.height = 20.0f;
		statusFrame.origin.x = 68.0f;
		statusFrame.origin.y = 0.0f;
		
		_statusView = [[BeeUILabel alloc] initWithFrame:statusFrame];
		_statusView.textColor = [UIColor lightGrayColor];
		_statusView.textAlignment = UITextAlignmentLeft;
		_statusView.font = [UIFont boldSystemFontOfSize:12.0f];
		_statusView.lineBreakMode = UILineBreakModeClip;
		_statusView.numberOfLines = 1;
		[self addSubview:_statusView];

		CGRect plotFrame;
		plotFrame.size.width = frame.size.width;
		plotFrame.size.height = 90.0f;
		plotFrame.origin.x = 0.0f;
		plotFrame.origin.y = 20.0f;
		
		_plotView1 = [[BeeDebugPlotsView alloc] initWithFrame:plotFrame];
		_plotView1.alpha = 0.6f;
		_plotView1.lowerBound = 0.0f;
		_plotView1.upperBound = MAX_MESSAGE_HISTORY;
		_plotView1.lineColor = [UIColor greenColor];
		_plotView1.lineWidth = 1.0f;
		_plotView1.capacity = MAX_MESSAGE_HISTORY;
		[self addSubview:_plotView1];
		
		_plotView2 = [[BeeDebugPlotsView alloc] initWithFrame:plotFrame];
		_plotView2.alpha = 0.6f;
		_plotView2.lowerBound = 0.0f;
		_plotView2.upperBound = MAX_MESSAGE_HISTORY;
		_plotView2.lineColor = [UIColor cyanColor];
		_plotView2.lineWidth = 1.0f;
		_plotView2.capacity = MAX_MESSAGE_HISTORY;
		[self addSubview:_plotView2];

		_plotView3 = [[BeeDebugPlotsView alloc] initWithFrame:plotFrame];
		_plotView3.alpha = 0.6f;
		_plotView3.lowerBound = 0.0f;
		_plotView3.upperBound = MAX_MESSAGE_HISTORY;
		_plotView3.lineColor = [UIColor redColor];
		_plotView3.lineWidth = 1.0f;
		_plotView3.capacity = MAX_MESSAGE_HISTORY;
		[self addSubview:_plotView3];

		CGRect allocFrame;
		allocFrame.size.width = 100.0f;
		allocFrame.size.height = 26.0f;
		allocFrame.origin.x = 4.0f;
		allocFrame.origin.y = frame.size.height - 30.0f;

		_cancelAll = [[BeeUIButton alloc] initWithFrame:allocFrame];
		_cancelAll.backgroundColor = [UIColor darkGrayColor];
		_cancelAll.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_cancelAll.layer.borderWidth = 2.0f;
		_cancelAll.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_cancelAll.stateNormal.title = @"Cancel all";
		_cancelAll.stateNormal.titleColor = [UIColor whiteColor];
		[_cancelAll addSignal:@"CANCEL_ALL" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_cancelAll];

		CGRect freezeFrame;
		freezeFrame.size.width = 100.0f;
		freezeFrame.size.height = 26.0f;
		freezeFrame.origin.x = frame.size.width - freezeFrame.size.width - 4.0f;
		freezeFrame.origin.y = frame.size.height - 30.0f;

		_freezeAll = [[BeeUIButton alloc] initWithFrame:freezeFrame];
		_freezeAll.backgroundColor = [UIColor darkGrayColor];
		_freezeAll.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_freezeAll.layer.borderWidth = 2.0f;
		_freezeAll.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_freezeAll.stateNormal.title = @"Freeze(Off)";
		_freezeAll.stateNormal.titleColor = [UIColor whiteColor];
		[_freezeAll addSignal:@"FREEZE_ALL" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_freezeAll];
	}
	return self;
}

- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _plotView1 );
	SAFE_RELEASE_SUBVIEW( _plotView2 );
	SAFE_RELEASE_SUBVIEW( _plotView3 );
	
	SAFE_RELEASE_SUBVIEW( _statusView );
	SAFE_RELEASE_SUBVIEW( _titleView );

	SAFE_RELEASE_SUBVIEW( _cancelAll );
	SAFE_RELEASE_SUBVIEW( _freezeAll );
	
	[super dealloc];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal is:@"CANCEL_ALL"] )
	{
		[[BeeMessageQueue sharedInstance] cancelMessages];
		
		[self update];
	}
	else if ( [signal is:@"FREEZE_ALL"] )
	{
		if ( [BeeMessageQueue sharedInstance].pause )
		{
			[BeeMessageQueue sharedInstance].pause = NO;

			_freezeAll.stateNormal.title = @"Freeze(Off)";
			_freezeAll.stateNormal.titleColor = [UIColor whiteColor];
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.6f];
			[UIView setAnimationBeginsFromCurrentState:YES];
			[UIView setAnimationRepeatAutoreverses:NO];
			[UIView setAnimationRepeatCount:1];
			
			self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
			
			[UIView commitAnimations];
		}
		else
		{
			[BeeMessageQueue sharedInstance].pause = YES;
			
			_freezeAll.stateNormal.title = @"Freeze(On)";
			_freezeAll.stateNormal.titleColor = [UIColor greenColor];
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.6f];
			[UIView setAnimationBeginsFromCurrentState:YES];
			[UIView setAnimationRepeatAutoreverses:YES];
			[UIView setAnimationRepeatCount:999999];
			
			self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6f];
			
			[UIView commitAnimations];
		}
		
		[self update];
	}
}

- (void)update
{
	NSMutableString * text = [NSMutableString string];
	[text appendFormat:@"Concurrent:%d  ", [BeeDebugMessageModel sharedInstance].sendingCount];
//	[text appendFormat:@"Succeed: %d  ", [BeeDebugMessageModel sharedInstance].succeedCount];
//	[text appendFormat:@"Failed: %d  ", [BeeDebugMessageModel sharedInstance].failedCount];
	_statusView.text = text;

	[_plotView1 setUpperBound:[BeeDebugMessageModel sharedInstance].upperBound];
	[_plotView1 setPlots:[BeeDebugMessageModel sharedInstance].sendingPlots];
	[_plotView1 setNeedsDisplay];

	[_plotView2 setUpperBound:[BeeDebugMessageModel sharedInstance].upperBound];
	[_plotView2 setPlots:[BeeDebugMessageModel sharedInstance].succeedPlots];
	[_plotView2 setNeedsDisplay];
	
	[_plotView3 setUpperBound:[BeeDebugMessageModel sharedInstance].upperBound];
	[_plotView3 setPlots:[BeeDebugMessageModel sharedInstance].failedPlots];
	[_plotView3 setNeedsDisplay];
}

@end

#pragma mark -

@implementation BeeDebugNetworkView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		self.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
		self.layer.borderWidth = 1.0f;

		CGRect titleFrame;
		titleFrame.size.width = 60.0f;
		titleFrame.size.height = 20.0f;
		titleFrame.origin.x = 8.0f;
		titleFrame.origin.y = 0.0f;
		
		_titleView = [[BeeUILabel alloc] initWithFrame:titleFrame];
		_titleView.textColor = [UIColor orangeColor];
		_titleView.textAlignment = UITextAlignmentLeft;
		_titleView.font = [UIFont boldSystemFontOfSize:12.0f];
		_titleView.lineBreakMode = UILineBreakModeClip;
		_titleView.numberOfLines = 1;
		_titleView.text = @"Network";
		[self addSubview:_titleView];
		
		CGRect statusFrame;
		statusFrame.size.width = frame.size.width - 16.0f - 60.0f;
		statusFrame.size.height = 20.0f;
		statusFrame.origin.x = 68.0f;
		statusFrame.origin.y = 0.0f;
		
		_statusView = [[BeeUILabel alloc] initWithFrame:statusFrame];
		_statusView.textColor = [UIColor lightGrayColor];
		_statusView.textAlignment = UITextAlignmentLeft;
		_statusView.font = [UIFont boldSystemFontOfSize:12.0f];
		_statusView.lineBreakMode = UILineBreakModeClip;
		_statusView.numberOfLines = 1;
		[self addSubview:_statusView];

		CGRect plotFrame;
		plotFrame.size.width = frame.size.width;
		plotFrame.size.height = 90.0f;
		plotFrame.origin.x = 0.0f;
		plotFrame.origin.y = 20.0f;
		
		_plotView1 = [[BeeDebugPlotsView alloc] initWithFrame:plotFrame];
		_plotView1.alpha = 0.75f;
		_plotView1.lowerBound = 0.0f;
		_plotView1.upperBound = MAX_REQUEST_HISTORY;
		_plotView1.lineColor = [UIColor greenColor];
		_plotView1.lineWidth = 1.0f;
		_plotView1.capacity = MAX_REQUEST_HISTORY;
		[self addSubview:_plotView1];

		_plotView2 = [[BeeDebugPlotsView alloc] initWithFrame:plotFrame];
		_plotView2.alpha = 0.6f;
		_plotView2.lowerBound = 0.0f;
		_plotView2.upperBound = MAX_REQUEST_HISTORY;
		_plotView2.lineColor = [UIColor grayColor];
		_plotView2.lineWidth = 1.0f;
		_plotView2.capacity = MAX_REQUEST_HISTORY;
		[self addSubview:_plotView2];
				
		CGRect allocFrame;
		allocFrame.size.width = 50.0f;
		allocFrame.size.height = 26.0f;
		allocFrame.origin.x = 4.0f;
		allocFrame.origin.y = frame.size.height - 30.0f;
		
		_delayPlus = [[BeeUIButton alloc] initWithFrame:allocFrame];
		_delayPlus.backgroundColor = [UIColor darkGrayColor];
		_delayPlus.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_delayPlus.layer.borderWidth = 2.0f;
		_delayPlus.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_delayPlus.stateNormal.title = @"+1s";
		_delayPlus.stateNormal.titleColor = [UIColor whiteColor];
		[_delayPlus addSignal:@"DELAY+" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_delayPlus];

		allocFrame.origin.x += allocFrame.size.width + 3.0f;
		
		_delaySub = [[BeeUIButton alloc] initWithFrame:allocFrame];
		_delaySub.backgroundColor = [UIColor darkGrayColor];
		_delaySub.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_delaySub.layer.borderWidth = 2.0f;
		_delaySub.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_delaySub.stateNormal.title = @"-1s";
		_delaySub.stateNormal.titleColor = [UIColor whiteColor];
		[_delaySub addSignal:@"DELAY-" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_delaySub];

		allocFrame.origin.x += allocFrame.size.width + 3.0f;
		allocFrame.size.width = 103.0f;

		_bandWidth = [[BeeUIButton alloc] initWithFrame:allocFrame];
		_bandWidth.backgroundColor = [UIColor darkGrayColor];
		_bandWidth.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_bandWidth.layer.borderWidth = 2.0f;
		_bandWidth.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_bandWidth.stateNormal.title = @"No limit";
		_bandWidth.stateNormal.titleColor = [UIColor whiteColor];
		[_bandWidth addSignal:@"LIMIT" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_bandWidth];

		CGRect switchFrame;
		switchFrame.size.width = 100.0f;
		switchFrame.size.height = 26.0f;
		switchFrame.origin.x = frame.size.width - switchFrame.size.width - 4.0f;
		switchFrame.origin.y = frame.size.height - 30.0f;

		_switchOnline = [[BeeUIButton alloc] initWithFrame:switchFrame];
		_switchOnline.backgroundColor = [UIColor darkGrayColor];
		_switchOnline.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_switchOnline.layer.borderWidth = 2.0f;
		_switchOnline.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		_switchOnline.stateNormal.title = @"FlightMode(Off)";
		_switchOnline.stateNormal.titleColor = [UIColor whiteColor];
		[_switchOnline addSignal:@"SWITCH" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_switchOnline];
	}
	return self;
}

- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _plotView1 );
	SAFE_RELEASE_SUBVIEW( _plotView2 );
	
	SAFE_RELEASE_SUBVIEW( _statusView );
	SAFE_RELEASE_SUBVIEW( _titleView );
	
	SAFE_RELEASE_SUBVIEW( _delayPlus );
	SAFE_RELEASE_SUBVIEW( _delaySub );
	SAFE_RELEASE_SUBVIEW( _bandWidth );	
	SAFE_RELEASE_SUBVIEW( _switchOnline );
	
	[super dealloc];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:@"DELAY+"] )
	{
		float delay = [BeeRequestQueue sharedInstance].delay;
		[BeeRequestQueue sharedInstance].delay = delay + 1.0f;

		[self update];
	}
	else if ( [signal is:@"DELAY-"] )
	{
		float delay = [BeeRequestQueue sharedInstance].delay;

		if ( delay >= 1.0f )
		{
			delay = delay - 1.0f;
		}
		else
		{
			delay = 0.0f;
		}
		
		[BeeRequestQueue sharedInstance].delay = delay;
		
		[self update];
	}
	else if ( [signal is:@"SWITCH"] )
	{	
		if ( [BeeRequestQueue sharedInstance].online )
		{
			[BeeRequestQueue sharedInstance].online = NO;

			_switchOnline.stateNormal.title = @"FlightMode(On)";
			_switchOnline.stateNormal.titleColor = [UIColor greenColor];
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.6f];
			[UIView setAnimationBeginsFromCurrentState:YES];
			[UIView setAnimationRepeatAutoreverses:YES];
			[UIView setAnimationRepeatCount:999999];
			
			self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6f];
			
			[UIView commitAnimations];
		}
		else
		{
			[BeeRequestQueue sharedInstance].online = YES;
			
			_switchOnline.stateNormal.title = @"FlightMode(Off)";
			_switchOnline.stateNormal.titleColor = [UIColor whiteColor];
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.6f];
			[UIView setAnimationBeginsFromCurrentState:YES];
			[UIView setAnimationRepeatAutoreverses:NO];
			[UIView setAnimationRepeatCount:1];
			
			self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
			
			[UIView commitAnimations];
		}

		[self update];
	}
	else if ( [signal is:@"LIMIT"] )
	{
		NSUInteger bandWidth = [BeeDebugNetworkModel sharedInstance].bandWidth + 1;
		if ( bandWidth > BANDWIDTH_3G )
		{
			bandWidth = BANDWIDTH_CURRENT;
		}
		
		[[BeeDebugNetworkModel sharedInstance] changeBandWidth:bandWidth];

		if ( BANDWIDTH_CURRENT == bandWidth )
		{
			_bandWidth.stateNormal.title = @"No limit";
			_bandWidth.stateNormal.titleColor = [UIColor whiteColor];
		}
		else if ( BANDWIDTH_GPRS == bandWidth )
		{
			_bandWidth.stateNormal.title = @"GPRS 10K/s";
			_bandWidth.stateNormal.titleColor = [UIColor greenColor];
		}
		else if ( BANDWIDTH_EDGE == bandWidth )
		{
			_bandWidth.stateNormal.title = @"EDGE 30K/s";
			_bandWidth.stateNormal.titleColor = [UIColor greenColor];
		}
		else if ( BANDWIDTH_3G == bandWidth )
		{
			_bandWidth.stateNormal.title = @"3G 200K/s";
			_bandWidth.stateNormal.titleColor = [UIColor greenColor];
		}
		
		[self update];
	}
}

- (void)update
{
	NSMutableString * text = [NSMutableString string];
	[text appendFormat:@"Concurrent:%d  ", [BeeDebugNetworkModel sharedInstance].totalCount];
	[text appendFormat:@"Delay:%.1fs  ", [BeeRequestQueue sharedInstance].delay];
	[text appendFormat:@"U:%@  ", [BeeDebugUtility number2String:[BeeDebugNetworkModel sharedInstance].uploadBytes]];
	[text appendFormat:@"D:%@  ", [BeeDebugUtility number2String:[BeeDebugNetworkModel sharedInstance].downloadBytes]];
	_statusView.text = text;
		
	[_plotView1 setUpperBound:[BeeDebugNetworkModel sharedInstance].recvLowerBound];
	[_plotView1 setUpperBound:[BeeDebugNetworkModel sharedInstance].recvUpperBound];
	[_plotView1 setPlots:[BeeDebugNetworkModel sharedInstance].recvPlots];
	[_plotView1 setNeedsDisplay];
	
	[_plotView2 setUpperBound:[BeeDebugNetworkModel sharedInstance].sendLowerBound];
	[_plotView2 setUpperBound:[BeeDebugNetworkModel sharedInstance].sendUpperBound];
	[_plotView2 setPlots:[BeeDebugNetworkModel sharedInstance].sendPlots];
	[_plotView2 setNeedsDisplay];
}

@end

#pragma mark -

@implementation BeeDebugDashBoard

DEF_SINGLETON( BeeDebugDashBoard )

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			CGRect memoryFrame;
			memoryFrame.origin = CGPointZero;
			memoryFrame.size.width = self.viewSize.width;
			memoryFrame.size.height = 139.0f;
			
			_memoryView = [[BeeDebugMemoryView alloc] initWithFrame:memoryFrame];
			[self.view addSubview:_memoryView];
			
			CGRect messageFrame;
			messageFrame.origin.x = 0.0f;
			messageFrame.origin.y = CGRectGetMaxY(memoryFrame);
			messageFrame.size.width = self.viewSize.width;
			messageFrame.size.height = 139.0f;
			
			_messageView = [[BeeDebugMessageView alloc] initWithFrame:messageFrame];
			[self.view addSubview:_messageView];
			
			CGRect networkFrame;
			networkFrame.origin.x = 0.0f;
			networkFrame.origin.y = CGRectGetMaxY(messageFrame);
			networkFrame.size.width = self.viewSize.width;
			networkFrame.size.height = 139.0f;
			
			_networkView = [[BeeDebugNetworkView alloc] initWithFrame:networkFrame];
			[self.view addSubview:_networkView];

			[self observeTick];
			[self handleTick:0.0f];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			[self unobserveTick];

			SAFE_RELEASE_SUBVIEW( _memoryView );
			SAFE_RELEASE_SUBVIEW( _messageView );
			SAFE_RELEASE_SUBVIEW( _networkView );
		}
	}
}

- (void)handleTick:(NSTimeInterval)elapsed
{
	[_memoryView update];
	[_messageView update];
	[_networkView update];
}

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

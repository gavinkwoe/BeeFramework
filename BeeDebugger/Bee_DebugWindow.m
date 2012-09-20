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
//  Bee_DebugWindow.m
//

#if __BEE_DEBUGGER__

#import <QuartzCore/QuartzCore.h>
#import "Bee_DebugWindow.h"
#import "Bee_DebugMemoryBoard.h"
#import "Bee_DebugMessageBoard.h"
#import "Bee_DebugNetworkBoard.h"
#import "Bee_DebugSandboxBoard.h"
#import "Bee_DebugViewBoard.h"
#import "Bee_DebugDashBoard.h"

#pragma mark -

@implementation BeeDebugShortcut

DEF_SINGLETON( BeeDebugShortcut )

- (id)init
{
	CGRect screenBound = [UIScreen mainScreen].bounds;
	CGRect shortcutFrame;
	shortcutFrame.size.width = 40.0f;
	shortcutFrame.size.height = 40.0f;
	shortcutFrame.origin.x = CGRectGetMaxX(screenBound) - shortcutFrame.size.width;
	shortcutFrame.origin.y = CGRectGetMaxY(screenBound) - shortcutFrame.size.height - 44.0f;

	self = [super initWithFrame:shortcutFrame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.hidden = YES;
		self.windowLevel = UIWindowLevelStatusBar + 100.0f;

		CGRect buttonFrame = shortcutFrame;
		buttonFrame.origin = CGPointZero;
		
		BeeUIButton * button = [[[BeeUIButton alloc] initWithFrame:buttonFrame] autorelease];
		button.backgroundColor = [UIColor clearColor];
		button.adjustsImageWhenHighlighted = YES;
		[button setImage:__IMAGE( @"bug.png" ) forState:UIControlStateNormal];
		[button addSignal:@"TOGGLE_TOUCHED" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
	}
	return self;
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( [signal is:@"TOGGLE_TOUCHED"] )
	{
		[BeeDebugWindow sharedInstance].hidden = NO;
		[BeeDebugShortcut sharedInstance].hidden = YES;
	}
}

- (void)dealloc
{
	[super dealloc];
}

@end

#pragma mark -

@interface BeeDebugBoard : BeeUIStackGroup
{
	UIView * _bottomView;
}

AS_SINGLETON( BeeDebugBoard );

@end

#pragma mark -

@implementation BeeDebugBoard

DEF_SINGLETON( BeeDebugBoard );

- (void)load
{
	[super load];
	
	[BeeDebugMemoryBoard sharedInstance];
	[BeeDebugMessageBoard sharedInstance];
	[BeeDebugNetworkBoard sharedInstance];
	[BeeDebugSandboxBoard sharedInstance];
	[BeeDebugViewBoard sharedInstance];
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
			[self append:[BeeUIStack stack:@"监视" firstBoard:[BeeDebugDashBoard sharedInstance]]];
			[self append:[BeeUIStack stack:@"视图" firstBoard:[BeeDebugViewBoard sharedInstance]]];
			[self append:[BeeUIStack stack:@"消息" firstBoard:[BeeDebugMessageBoard sharedInstance]]];
			[self append:[BeeUIStack stack:@"网络" firstBoard:[BeeDebugNetworkBoard sharedInstance]]];
			[self append:[BeeUIStack stack:@"沙箱" firstBoard:[BeeDebugSandboxBoard sharedInstance]]];
			[self present:[self.stacks objectAtIndex:0]];

			CGRect bottomFrame;
			bottomFrame.size.width = self.viewSize.width;
			bottomFrame.size.height = 44.0f;
			bottomFrame.origin.x = 0.0f;
			bottomFrame.origin.y = self.viewSize.height - bottomFrame.size.height;
			
			_bottomView = [[UIView alloc] initWithFrame:bottomFrame];
			_bottomView.backgroundColor = [UIColor grayColor];
			_bottomView.layer.borderWidth = 1.0f;
			_bottomView.layer.borderColor = [UIColor grayColor].CGColor;
			[self.view addSubview:_bottomView];
			
			CGRect segFrame;
			segFrame.size.width = self.viewSize.width - 44.0f - 10.0f;
			segFrame.size.height = 30.0f;
			segFrame.origin.x = 10.0f;
			segFrame.origin.y = (bottomFrame.size.height - segFrame.size.height) / 2.0f;
			
			BeeUISegmentedControl * segmentControl = [[[BeeUISegmentedControl alloc] initWithFrame:segFrame] autorelease];
			for ( BeeUIStack * stack in self.stacks )
			{
				[segmentControl addTitle:stack.name];
			}
			[segmentControl setSelectedSegmentIndex:0];
			[_bottomView addSubview:segmentControl];
			
			CGRect closeFrame;
			closeFrame.size.width = 44.0f;
			closeFrame.size.height = 44.0f;
			closeFrame.origin.x = self.viewSize.width - closeFrame.size.width;
			closeFrame.origin.y = (bottomFrame.size.height - closeFrame.size.height) / 2.0f;
			
			BeeUIButton * closeView = [[[BeeUIButton alloc] initWithFrame:closeFrame] autorelease];
			closeView.stateNormal.image = __IMAGE( @"close.png" );
			[closeView addSignal:@"CLOSE_TOUCHED" forControlEvents:UIControlEventTouchUpInside];
			[_bottomView addSubview:closeView];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{	
			SAFE_RELEASE_SUBVIEW( _bottomView );
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
			
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{

		}
	}
	else if ( [signal is:BeeUIStackGroup.INDEX_CHANGED] )
	{
		[self.view bringSubviewToFront:_bottomView];
	}
	else if ( [signal is:BeeUISegmentedControl.HIGHLIGHT_CHANGED] )
	{
		BeeUISegmentedControl * segmentControl = (BeeUISegmentedControl *)signal.source;
		[self present:[self.stacks objectAtIndex:segmentControl.selectedSegmentIndex]];
	}
	else if ( [signal is:@"CLOSE_TOUCHED"] )
	{
		[BeeDebugWindow sharedInstance].hidden = YES;
		[BeeDebugShortcut sharedInstance].hidden = NO;
	}
}

@end

#pragma mark -

@implementation BeeDebugWindow

DEF_SINGLETON( BeeDebugWindow )

- (id)init
{
	CGRect screenBound = [UIScreen mainScreen].bounds;
	self = [super initWithFrame:screenBound];
	if (self)
	{
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		self.hidden = YES;
		self.windowLevel = UIWindowLevelStatusBar + 200;

		if ( [self respondsToSelector:@selector(setRootViewController:)] )
		{
			self.rootViewController = [BeeDebugBoard sharedInstance];
		}
		else
		{
			[self addSubview:[BeeDebugBoard sharedInstance].view];
		}
	}
	return self;
}

- (void)setHidden:(BOOL)hidden
{
	[super setHidden:hidden];
	
	if ( self.hidden )
	{
		[[BeeDebugBoard sharedInstance] viewWillDisappear:NO];
		[[BeeDebugBoard sharedInstance] viewDidDisappear:NO];
	}
	else
	{
		[[BeeDebugBoard sharedInstance] viewWillAppear:NO];
		[[BeeDebugBoard sharedInstance] viewDidAppear:NO];
	}
}

- (void)dealloc
{
	[super dealloc];
}

@end

#endif

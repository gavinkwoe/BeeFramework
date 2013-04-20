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

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import "Bee_DebugWindow.h"
#import "Bee_DebugMessageBoard.h"
#import "Bee_DebugNetworkBoard.h"
#import "Bee_DebugSandboxBoard.h"
#import "Bee_DebugViewBoard.h"
#import "Bee_DebugDashBoard.h"
#import "Bee_DebugHeatmapModel.h"

#pragma mark -

@implementation BeeDebugShortcut

DEF_SINGLETON( BeeDebugShortcut )

DEF_SIGNAL( TOGGLE_HEATMAP )
DEF_SIGNAL( TOGGLE_DEBUGGER )

- (id)init
{
	CGRect screenBound = [UIScreen mainScreen].bounds;
	CGRect shortcutFrame;
	shortcutFrame.size.width = 80.0f;
	shortcutFrame.size.height = 40.0f;
	shortcutFrame.origin.x = CGRectGetMaxX(screenBound) - shortcutFrame.size.width;
	shortcutFrame.origin.y = CGRectGetMaxY(screenBound) - shortcutFrame.size.height - 44.0f;

	self = [super initWithFrame:shortcutFrame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.hidden = YES;
		self.windowLevel = UIWindowLevelStatusBar + 100.0f;

		CGRect buttonFrame;
		buttonFrame.origin = CGPointZero;
		buttonFrame.size.width = 40.0f;
		buttonFrame.size.height = 40.0f;
		
		BeeUIButton * button;
		
		button = [[BeeUIButton alloc] initWithFrame:buttonFrame];
		button.backgroundColor = [UIColor clearColor];
		button.adjustsImageWhenHighlighted = YES;
		[button setImage:__IMAGE( @"heat.png" ) forState:UIControlStateNormal];
		[button addSignal:BeeDebugShortcut.TOGGLE_HEATMAP forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
        [button release];
        
		button = [[BeeUIButton alloc] initWithFrame:CGRectOffset(buttonFrame, 40.0f, 0.0f)];
		button.backgroundColor = [UIColor clearColor];
		button.adjustsImageWhenHighlighted = YES;
		[button setImage:__IMAGE( @"bug.png" ) forState:UIControlStateNormal];
		[button addSignal:BeeDebugShortcut.TOGGLE_DEBUGGER forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
        [button release];
	}
	return self;
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( [signal is:BeeDebugShortcut.TOGGLE_DEBUGGER] )
	{
		[BeeDebugWindow sharedInstance].hidden = NO;
		[BeeDebugHeatmap sharedInstance].hidden = YES;
		[BeeDebugShortcut sharedInstance].hidden = YES;
	}
	else if ( [signal is:BeeDebugShortcut.TOGGLE_HEATMAP] )
	{
		[BeeDebugWindow sharedInstance].hidden = YES;
		[BeeDebugHeatmap sharedInstance].hidden = NO;
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
	
	if ( [signal is:@"CLOSE_TOUCHED"] )
	{
		[BeeDebugWindow sharedInstance].hidden = YES;
		[BeeDebugHeatmap sharedInstance].hidden = YES;
		[BeeDebugShortcut sharedInstance].hidden = NO;
	}
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		[self append:[BeeUIStack stack:@"Dash" firstBoard:[BeeDebugDashBoard sharedInstance]]];
		[self append:[BeeUIStack stack:@"View" firstBoard:[BeeDebugViewBoard sharedInstance]]];
		[self append:[BeeUIStack stack:@"Msg" firstBoard:[BeeDebugMessageBoard sharedInstance]]];
		[self append:[BeeUIStack stack:@"Net" firstBoard:[BeeDebugNetworkBoard sharedInstance]]];
		[self append:[BeeUIStack stack:@"File" firstBoard:[BeeDebugSandboxBoard sharedInstance]]];
//			[self append:[BeeUIStack stack:@"Crash" firstBoard:nil]];
		[self present:[self.stacks objectAtIndex:0]];

		CGRect bottomFrame;
		bottomFrame.size.width = self.viewSize.width;
		bottomFrame.size.height = 44.0f;
		bottomFrame.origin.x = 0.0f;
		bottomFrame.origin.y = self.viewSize.height - bottomFrame.size.height;
		
		_bottomView = [[UIView alloc] initWithFrame:bottomFrame];
		_bottomView.backgroundColor = [UIColor clearColor];
		_bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
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
		segmentControl.segmentedControlStyle = UISegmentedControlStyleBezeled;
		segmentControl.tintColor = [UIColor grayColor];
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

- (void)handleUISignal_BeeUIStackGroup:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIStackGroup.INDEX_CHANGED] )
	{
		[self.view bringSubviewToFront:_bottomView];
	}
}

- (void)handleUISignal_BeeUISegmentedControl:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal is:BeeUISegmentedControl.HIGHLIGHT_CHANGED] )
	{
		BeeUISegmentedControl * segmentControl = (BeeUISegmentedControl *)signal.source;
		[self present:[self.stacks objectAtIndex:segmentControl.selectedSegmentIndex]];
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

#pragma mark -

@implementation BeeDebugHeatmap

DEF_SINGLETON( BeeDebugHeatmap )

- (id)init
{
	CGRect screenBound = [UIScreen mainScreen].bounds;
	self = [super initWithFrame:screenBound];
	if (self)
	{
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
		self.hidden = YES;
		self.windowLevel = UIWindowLevelStatusBar + 200;
		
		CGRect closeFrame;
		closeFrame.size.width = 44.0f;
		closeFrame.size.height = 44.0f;
		closeFrame.origin.x = screenBound.size.width - closeFrame.size.width;
		closeFrame.origin.y = screenBound.size.height - closeFrame.size.height;

		BeeUIButton * closeView = [[BeeUIButton alloc] initWithFrame:closeFrame];
		closeView.stateNormal.image = __IMAGE( @"close.png" );
		[closeView addSignal:@"CLOSE_TOUCHED" forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:closeView];
		[closeView release];

		
		
		CGRect labelFrame;
		labelFrame.size.width = 64.0f;
		labelFrame.size.height = 24.0f;
		labelFrame.origin.x = 10.0f;
		labelFrame.origin.y = screenBound.size.height - labelFrame.size.height - 10.0f;;
		
		BeeUILabel * label1 = [[BeeUILabel alloc] initWithFrame:labelFrame];
		label1.alpha = 0.8f;
		label1.backgroundColor = [UIColor blueColor];
		label1.textColor = [UIColor whiteColor];
		label1.textAlignment = UITextAlignmentCenter;
		label1.font = [UIFont boldSystemFontOfSize:12.0f];
		label1.lineBreakMode = UILineBreakModeClip;
		label1.numberOfLines = 1;
		label1.text = @"Drag";
		label1.tag = 100;
		[self addSubview:label1];
		[label1 release];

		BeeUILabel * label2 = [[BeeUILabel alloc] initWithFrame:CGRectOffset(labelFrame, labelFrame.size.width + 10.0f, 0.0f)];
		label2.alpha = 0.8f;
		label2.backgroundColor = [UIColor redColor];
		label2.textColor = [UIColor whiteColor];
		label2.textAlignment = UITextAlignmentCenter;
		label2.font = [UIFont boldSystemFontOfSize:12.0f];
		label2.lineBreakMode = UILineBreakModeClip;
		label2.numberOfLines = 1;
		label2.text = @"Click";
		label2.tag = 200;
		[self addSubview:label2];
		[label2 release];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)setHidden:(BOOL)flag
{
	[super setHidden:flag];
	
	if ( flag )
	{
		[self unobserveTick];
	}
	else
	{
		UIView * label1 = [self viewWithTag:100];
		UIView * label2 = [self viewWithTag:200];
		
		label1.alpha = 0.8f;
		label2.alpha = 0.8f;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:2.0f];
		[UIView setAnimationDuration:1.0f];
		
		label1.alpha = 0.0f;
		label2.alpha = 0.0f;
		
		[UIView commitAnimations];
		
		[self observeTick];
		[self setNeedsDisplay];
	}
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:@"CLOSE_TOUCHED"] )
	{
		[BeeDebugWindow sharedInstance].hidden = YES;
		[BeeDebugHeatmap sharedInstance].hidden = YES;
		[BeeDebugShortcut sharedInstance].hidden = NO;
	}
}

- (void)handleTick:(NSTimeInterval)elapsed
{
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();			
	CGContextSaveGState( context );

	CGContextClearRect( context, rect );
	CGContextSetFillColorWithColor( context, [[UIColor blackColor] colorWithAlphaComponent:0.6f].CGColor );
    CGContextFillRect( context, rect );

	NSUInteger colCount = [BeeDebugHeatmapModel sharedInstance].colCount;
	NSUInteger rowCount = [BeeDebugHeatmapModel sharedInstance].rowCount;

	NSUInteger * heatmap;
	NSUInteger peakValue;
	
	heatmap = [BeeDebugHeatmapModel sharedInstance].heatmapDrag;
	peakValue = [BeeDebugHeatmapModel sharedInstance].peakValueDrag;
	
	if ( peakValue )
	{
		for ( NSUInteger row = 0; row < rowCount; ++row )
		{
			for ( NSUInteger col = 0; col < colCount; ++col )
			{
				NSUInteger value = heatmap[row * colCount + col];
				
				CGRect blockFrame;
				blockFrame.size.width = 16.0f;
				blockFrame.size.height = 16.0f;
				blockFrame.origin.x = blockFrame.size.width * col;
				blockFrame.origin.y = blockFrame.size.height * row;
				
				CGContextBeginPath( context );
				CGContextAddEllipseInRect( context, blockFrame );
				CGContextClosePath( context );
								
				CGFloat percent =  (CGFloat)value / (CGFloat)peakValue;
				if ( percent > 0.0f )
				{
					UIColor * color = nil;
					
					if ( percent < 0.2f )
					{
						color = [[UIColor blueColor] colorWithAlphaComponent:(0.05f + 0.05f * percent)];
					}
					else if ( percent < 0.4f )
					{
						color = [[UIColor blueColor] colorWithAlphaComponent:(0.2f + 0.3f * percent)];
					}
					else if ( percent < 0.6f )
					{
						color = [[UIColor blueColor] colorWithAlphaComponent:(0.3f + 0.3f * percent)];
					}
					else if ( percent < 0.8f )
					{
						color = [[UIColor blueColor] colorWithAlphaComponent:(0.4f + 0.3f * percent)];
					}
					else
					{
						color = [[UIColor blueColor] colorWithAlphaComponent:(0.5f + 0.3f * percent)];
					}
					
					CGContextSetFillColorWithColor( context, color.CGColor );
					CGContextFillPath( context );			
				}
			}		
		}
	}

	heatmap = [BeeDebugHeatmapModel sharedInstance].heatmapTap;
	peakValue = [BeeDebugHeatmapModel sharedInstance].peakValueTap;
	
	if ( peakValue )
	{
		for ( NSUInteger row = 0; row < rowCount; ++row )
		{
			for ( NSUInteger col = 0; col < colCount; ++col )
			{
				NSUInteger value = heatmap[row * colCount + col];
				
				CGRect blockFrame;
				blockFrame.size.width = 16.0f;
				blockFrame.size.height = 16.0f;
				blockFrame.origin.x = blockFrame.size.width * col;
				blockFrame.origin.y = blockFrame.size.height * row;
				
				CGContextBeginPath( context );
				CGContextAddEllipseInRect( context, blockFrame );
				CGContextClosePath( context );
				
				CGFloat percent =  (CGFloat)value / (CGFloat)peakValue;
				if ( percent > 0.0f )
				{
					UIColor * color = [[UIColor redColor] colorWithAlphaComponent:(0.2f + 0.8f * percent)];
					if ( color )
					{
						CGContextSetLineWidth( context, 4.0f );
						CGContextSetStrokeColorWithColor( context, color.CGColor );
						CGContextStrokePath( context );			
					}
				}
			}		
		}
	}

	CGContextRestoreGState( context );
}

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

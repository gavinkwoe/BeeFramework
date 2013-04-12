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
//  Bee_DebugHeatmapModel.h
//

#import "Bee_Precompile.h"
#import "Bee.h"

#if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

#import <objc/runtime.h>
#import "Bee_DebugHeatmapModel.h"

#pragma mark -

@interface BeeDebugTapIndicator : UIImageView
@end

#pragma mark -

@implementation BeeDebugTapIndicator

static inline float radians(double degrees) { return degrees * M_PI / 180.0f; } 

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		self.contentMode = UIViewContentModeCenter;
		self.image = [UIImage imageNamed:@"tap.png"];
	}
	return self;
}

- (void)startAnimation
{
	self.alpha = 1.0f;
	self.transform = CGAffineTransformMakeScale( 0.8f, 0.8f );

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationStopped)];
	
	self.alpha = 0.0f;
	self.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
}

- (void)didAppearingAnimationStopped
{
	[self removeFromSuperview];
}

- (void)dealloc
{
	[super dealloc];
}

@end

#pragma mark -

@interface BeeDebugBorder : UIImageView
@end

#pragma mark -

@implementation BeeDebugBorder

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		self.layer.borderWidth = 3.0f;
		self.layer.borderColor = [UIColor redColor].CGColor;
	}
	return self;
}

- (void)startAnimation
{
	self.alpha = 1.0f;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationStopped)];
	
	self.alpha = 0.0f;
	
	[UIView commitAnimations];
}

- (void)didAppearingAnimationStopped
{
	[self removeFromSuperview];
}

- (void)dealloc
{
	[super dealloc];
}

@end

#pragma mark -

@interface UIWindow(BeeDebugger)
- (void)mySendEvent:(UIEvent *)event;
@end

#pragma mark -

@implementation UIWindow(BeeDebugger)

static void (* _origSendEvent)( id, SEL, UIEvent * );

+ (void)swizzle
{
	static BOOL __swizzled = NO;
	if ( NO == __swizzled )
	{
		Method method;
		IMP implement;
		
		method = class_getInstanceMethod( [UIWindow class], @selector(sendEvent:) );
		_origSendEvent = (void *)method_getImplementation( method );

		implement = class_getMethodImplementation( [UIWindow class], @selector(mySendEvent:) );
		method_setImplementation( method, implement );

		__swizzled = YES;
	}
}

- (void)mySendEvent:(UIEvent *)event
{
	static NSTimeInterval __timeStamp = 0.0;

	if ( _origSendEvent )
	{
		_origSendEvent( self, _cmd, event );
	}

	UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
	if ( self != keyWindow )
		return;

	BeeDebugHeatmapModel * model = [BeeDebugHeatmapModel sharedInstance];

	if ( UIEventTypeTouches == event.type )
	{
		NSSet * allTouches = [event allTouches];  
		if ( 1 == [allTouches count] )
		{  
			UITouch * touch = [[allTouches allObjects] objectAtIndex:0];  			
			if ( 1 == [touch tapCount] )
			{ 
				CGPoint location = [touch locationInView:keyWindow];

//				CC( @"touch.phase = %d", touch.phase );
				
				if ( UITouchPhaseBegan == touch.phase )
				{
					__timeStamp = touch.timestamp;
					
					BeeDebugBorder * border = [[BeeDebugBorder alloc] initWithFrame:touch.view.bounds];
					[touch.view addSubview:border];
					[border startAnimation];
                    [border release];
					
					CC( @"touch.view = %@", touch.view );
				}
				else if ( UITouchPhaseMoved == touch.phase )
				{
					[model recordDragAtLocation:location];
				}
				else if ( UITouchPhaseEnded == touch.phase || UITouchPhaseCancelled == touch.phase )
				{
					BeeDebugTapIndicator * indicator = [[BeeDebugTapIndicator alloc] initWithFrame:CGRectMake(0, 0, 50.0f, 50.0f)] ;
					indicator.center = location;
					[keyWindow addSubview:indicator];
					[indicator startAnimation];					
                    [indicator release];
					NSTimeInterval diff = touch.timestamp - __timeStamp;
					if ( diff <= 0.3f )
					{
						[model recordTapAtLocation:location];
					}
				}
			}
		}
	}	
}

@end

#pragma mark -

@implementation BeeDebugHeatmapModel

@synthesize rowCount = _rowCount;
@synthesize colCount = _colCount;
@synthesize peakValueTap = _peakValueTap;
@synthesize peakValueDrag = _peakValueDrag;
@synthesize heatmapTap = _heatmapTap;
@synthesize heatmapDrag = _heatmapDrag;

DEF_SINGLETON( BeeDebugHeatmapModel )

- (void)load
{
	[super load];

	UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;

	_colCount = (NSUInteger)((keyWindow.bounds.size.width + 15.0f) / 16.0f);
	_rowCount = (NSUInteger)((keyWindow.bounds.size.height + 15.0f) / 16.0f);

	_peakValueTap = 1;
	_peakValueDrag = 1;

	size_t alloc_size = sizeof(NSUInteger) * _rowCount * _colCount;

	_heatmapTap = (NSUInteger *)malloc( alloc_size );
	memset( _heatmapTap, 0x0, alloc_size );

	_heatmapDrag = (NSUInteger *)malloc( alloc_size );
	memset( _heatmapDrag, 0x0, alloc_size );

	[UIWindow swizzle];
}

- (void)unload
{
	free( _heatmapTap );
	free( _heatmapDrag );
	
	[super unload];
}

- (void)recordTapAtLocation:(CGPoint)location
{
	NSUInteger col = (NSUInteger)(location.x / 16.0f);
	NSUInteger row = (NSUInteger)(location.y / 16.0f);
	NSUInteger index = _colCount * row + col;
	if ( index < _colCount * _rowCount )
	{
		_heatmapTap[index] += 1;
		
		if ( _heatmapTap[index] > _peakValueTap )
		{
			_peakValueTap = _heatmapTap[index];
		}
	}
}

- (void)recordDragAtLocation:(CGPoint)location
{
	NSUInteger col = (NSUInteger)(location.x / 16.0f);
	NSUInteger row = (NSUInteger)(location.y / 16.0f);
	NSUInteger index = _colCount * row + col;
	if ( index < _colCount * _rowCount )
	{	
		_heatmapDrag[index] += 1;
		
		if ( _heatmapDrag[index] > _peakValueDrag )
		{
			_peakValueDrag = _heatmapDrag[index];
		}
	}
}

@end

#endif	// #if defined(__BEE_DEBUGGER__) && __BEE_DEBUGGER__

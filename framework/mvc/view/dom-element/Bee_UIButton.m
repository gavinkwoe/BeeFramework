//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_UIButton.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"
#import "UIImage+BeeExtension.h"

#pragma mark -

#undef	LONG_INTERVAL
#define LONG_INTERVAL	(0.75f)

#pragma mark -

@implementation BeeUIButtonState
{
	BeeUIButton *	_button;
	UIControlState	_state;
}

@synthesize button = _button;
@synthesize state = _state;

@dynamic title;
@dynamic titleColor;
@dynamic titleShadowColor;
@dynamic image;
@dynamic backgroundImage;

- (NSString *)title
{
	return [_button titleForState:_state];
}

- (void)setTitle:(NSString *)text
{
	[_button setTitle:text forState:_state];
//	[_button setNeedsDisplay];
}

- (UIColor *)titleColor
{
	return [_button titleColorForState:_state];
}

- (void)setTitleColor:(UIColor *)color
{
	[_button setTitleColor:color forState:_state];
//	[_button setNeedsDisplay];
}

- (UIColor *)titleShadowColor
{
	return [_button titleShadowColorForState:_state];
}

- (void)setTitleShadowColor:(UIColor *)color
{
	[_button setTitleShadowColor:color forState:_state];
//	[_button setNeedsDisplay];
}

- (UIImage *)image
{
	return [_button imageForState:_state];
}

- (void)setImage:(UIImage *)img
{
	[_button setImage:img forState:_state];
//	[_button setNeedsDisplay];
}

- (UIImage *)backgroundImage
{
	return [_button backgroundImageForState:_state];
}

- (void)setBackgroundImage:(UIImage *)img
{
	[_button setBackgroundImage:img forState:_state];
//	[_button setNeedsDisplay];
}

@end

#pragma mark -

@interface BeeUIButton()
{
	NSMutableArray *	_actions;
	UILabel *			_label;
	UIEdgeInsets		_insets;
	NSString *			_signal;
	BOOL				_enableAllEvents;
}

- (void)initSelf;
- (void)didTouchDown;
- (void)didTouchLong;
- (void)didTouchDownRepeat;
- (void)didTouchUpInside;
- (void)didTouchUpOutside;
- (void)didTouchCancel;

- (void)didDragInside;
- (void)didDragOutside;
- (void)didDragEnter;
- (void)didDragExit;

- (BOOL)testEvent:(UIControlEvents)event;

@end

#pragma mark -

@implementation BeeUIButton
{
	NSTimer *			_timer;
	BOOL				_repeatCount;
	BOOL				_inited;
	BeeUIButtonState *	_stateNormal;
	BeeUIButtonState *	_stateHighlighted;
	BeeUIButtonState *	_stateDisabled;
	BeeUIButtonState *	_stateSelected;
}

DEF_SIGNAL( TOUCH_DOWN )
DEF_SIGNAL( TOUCH_DOWN_LONG )
DEF_SIGNAL( TOUCH_DOWN_REPEAT )
DEF_SIGNAL( TOUCH_UP_INSIDE )
DEF_SIGNAL( TOUCH_UP_OUTSIDE )
DEF_SIGNAL( TOUCH_UP_CANCEL )

DEF_SIGNAL( DRAG_INSIDE )		// 拖出
DEF_SIGNAL( DRAG_OUTSIDE )		// 拖入
DEF_SIGNAL( DRAG_ENTER )		// 进入
DEF_SIGNAL( DRAG_EXIT )			// 退出

@dynamic title;
@dynamic titleColor;
@dynamic titleShadowColor;
@dynamic titleFont;
@dynamic titleInsets;
@dynamic titleTextAlignment;
@dynamic image;
@synthesize signal = _signal;
@synthesize enableAllEvents = _enableAllEvents;

@synthesize stateNormal;
@synthesize stateHighlighted;
@synthesize stateDisabled;
@synthesize stateSelected;

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

// thanks to @ilikeido
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (void)initSelf
{
	if ( NO == _inited )
	{
		self.backgroundColor = [UIColor clearColor];
		self.contentMode = UIViewContentModeCenter;
		self.adjustsImageWhenDisabled = YES;
		self.adjustsImageWhenHighlighted = YES;
		
		self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		self.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;

		self.multipleTouchEnabled = NO;
		self.exclusiveTouch = NO;
		
		self.enableAllEvents = NO;

		[self addTarget:self action:@selector(didTouchDown) forControlEvents:UIControlEventTouchDown];
		[self addTarget:self action:@selector(didTouchDownRepeat) forControlEvents:UIControlEventTouchDownRepeat];
		[self addTarget:self action:@selector(didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self addTarget:self action:@selector(didTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];

		[self addTarget:self action:@selector(didDragInside) forControlEvents:UIControlEventTouchDragInside];
		[self addTarget:self action:@selector(didDragOutside) forControlEvents:UIControlEventTouchDragOutside];
		[self addTarget:self action:@selector(didDragEnter) forControlEvents:UIControlEventTouchDragEnter];
		[self addTarget:self action:@selector(didDragExit) forControlEvents:UIControlEventTouchDragExit];

		_actions = [[NSMutableArray alloc] init];
		_inited = YES;

//		[self load];
		[self performLoad];
	}
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];

	if ( _label )
	{
		_label.frame = CGRectMake( 0.0f, 0.0f, frame.size.width, frame.size.height );
	}
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	[_timer invalidate];
	_timer = nil;
	
	[_label removeFromSuperview];
	[_label release];
	_label = nil;
	
	[_signal release];
	
	[_actions removeAllObjects];
	[_actions release];
	
	[_stateNormal release];
	[_stateHighlighted release];
	[_stateDisabled release];
	[_stateSelected release];
	
	[super dealloc];
}

#pragma mark -

- (void)initLabel
{
	if ( _label )
		return;

	_label = [[UILabel alloc] initWithFrame:self.bounds];
	_label.backgroundColor = [UIColor clearColor];
	
	if ( IOS7_OR_LATER )
	{
		_label.font = [UIFont systemFontOfSize:15.0f];
	}
	else
	{
		_label.font = [UIFont boldSystemFontOfSize:15.0f];
	}
	
	_label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	_label.textAlignment = UITextAlignmentCenter;
	_label.textColor = [UIColor whiteColor];
	_label.backgroundColor = [UIColor clearColor];
	_label.lineBreakMode = UILineBreakModeTailTruncation;
	[self addSubview:_label];
}

- (NSString *)title
{
	return _label ? _label.text : @"";
}

- (void)setTitle:(NSString *)str
{
	[self initLabel];

	_label.text = str;
}

- (UIColor *)titleColor
{
	return _label ? _label.textColor : [UIColor clearColor];
}

- (void)setTitleColor:(UIColor *)color
{
	[self initLabel];
	
	_label.textColor = color;
}

- (UIColor *)titleShadowColor
{
	return _label ? _label.shadowColor : [UIColor clearColor];
}

- (void)setTitleShadowColor:(UIColor *)color
{
	[self initLabel];
	
	_label.shadowColor = color;
	_label.shadowOffset = CGSizeMake( 0.0f, -0.5f );
}

- (UIFont *)titleFont
{
	return _label ? _label.font : nil;
}

- (void)setTitleFont:(UIFont *)font
{
	[self initLabel];
	
	_label.font = font;
}

- (UIEdgeInsets)titleInsets
{
	return _insets;
}

- (void)setTitleInsets:(UIEdgeInsets)insets
{
	[self initLabel];
	
	_insets = insets;
	
	CGRect frame = CGRectInset( self.bounds, insets.left, insets.top );
	frame.size.width -= insets.left;
	frame.size.height -= insets.top;
	frame.size.width -= insets.right;
	frame.size.height -= insets.bottom;
	
	_label.frame = frame;
}

- (UITextAlignment)titleTextAlignment
{
	return _label ? _label.textAlignment : UITextAlignmentLeft;;
}

- (void)setTitleTextAlignment:(UITextAlignment)alignment
{
	[self initLabel];
	
    [_label setTextAlignment:alignment];
}

- (UIImage *)image
{
	return self.currentImage;
}

- (void)setImage:(UIImage *)img
{
	[self setImage:img forState:UIControlStateNormal];
	[self setImage:img forState:UIControlStateHighlighted];
	[self setImage:img forState:UIControlStateDisabled];
	[self setImage:img forState:UIControlStateSelected];

	[self setNeedsLayout];
//	[self setNeedsDisplay];
}

- (BeeUIButtonState *)stateNormal
{
	if ( nil == _stateNormal )
	{
		_stateNormal = [[BeeUIButtonState alloc] init];
		_stateNormal.button = self;
		_stateNormal.state = UIControlStateNormal;
	}
	
	return _stateNormal;
}

- (BeeUIButtonState *)stateHighlighted
{
	if ( nil == _stateHighlighted )
	{
		_stateHighlighted = [[BeeUIButtonState alloc] init];
		_stateHighlighted.button = self;
		_stateHighlighted.state = UIControlStateHighlighted;
	}
	
	return _stateHighlighted;
}

- (BeeUIButtonState *)stateDisabled
{
	if ( nil == _stateDisabled )
	{
		_stateDisabled = [[BeeUIButtonState alloc] init];
		_stateDisabled.button = self;
		_stateDisabled.state = UIControlStateDisabled;
	}
	
	return _stateDisabled;
}

- (BeeUIButtonState *)stateSelected
{
	if ( nil == _stateSelected )
	{
		_stateSelected = [[BeeUIButtonState alloc] init];
		_stateSelected.button = self;
		_stateSelected.state = UIControlStateSelected;
	}
	
	return _stateSelected;
}

#pragma mark -

- (void)addSignal:(NSString *)signal forControlEvents:(UIControlEvents)controlEvents
{
	[self addSignal:signal forControlEvents:controlEvents object:nil];
}

- (void)addSignal:(NSString *)signal forControlEvents:(UIControlEvents)controlEvents object:(NSObject *)object
{
	if ( nil == signal )
	{
		signal = @"";
	}
	
	NSNumber * event = [NSNumber numberWithInt:controlEvents];
	[_actions addObject:[NSArray arrayWithObjects:event, signal, object, nil]];
}

- (void)didTouchDown
{
	_repeatCount = 0;

	[_timer invalidate];
	_timer = nil;
	
	if ( NO == _enableAllEvents )
		return;

	_timer = [NSTimer scheduledTimerWithTimeInterval:LONG_INTERVAL
											  target:self
											selector:@selector(didTouchLong)
											userInfo:nil
											 repeats:NO];

	if ( NO == [self testEvent:UIControlEventTouchDown] )
	{
		[self sendUISignal:BeeUIButton.TOUCH_DOWN];
	}
}

- (void)didTouchDownRepeat
{
	_repeatCount += 1;
	
	if ( NO == _enableAllEvents )
		return;
	
	if ( NO == [self testEvent:UIControlEventTouchDownRepeat] )
	{
		[self sendUISignal:BeeUIButton.TOUCH_DOWN_REPEAT];
	}
}

- (void)didTouchLong
{
	_timer = nil;
	
	[self sendUISignal:BeeUIButton.TOUCH_DOWN_LONG];
}

- (void)didTouchUpInside
{
	[_timer invalidate];
	_timer = nil;
	
	if ( NO == [self testEvent:UIControlEventTouchUpInside] )
	{
		if ( self.signal )
		{
			[self sendUISignal:self.signal];
		}
		else
		{
			[self sendUISignal:BeeUIButton.TOUCH_UP_INSIDE];
		}
	}
}

- (void)didTouchUpOutside
{
	[_timer invalidate];
	_timer = nil;

	if ( NO == _enableAllEvents )
		return;
	
	if ( NO == [self testEvent:UIControlEventTouchUpOutside] )
	{
		[self sendUISignal:BeeUIButton.TOUCH_UP_OUTSIDE];
	}
}

- (void)didTouchCancel
{
	[_timer invalidate];
	_timer = nil;

	if ( NO == _enableAllEvents )
		return;
	
	if ( NO == [self testEvent:UIControlEventTouchCancel] )
	{
		[self sendUISignal:BeeUIButton.TOUCH_UP_CANCEL];
	}
}

- (void)didDragInside
{
	if ( NO == _enableAllEvents )
		return;
	
	if ( NO == [self testEvent:UIControlEventTouchDragInside] )
	{
		[self sendUISignal:BeeUIButton.DRAG_INSIDE];
	}	
}

- (void)didDragOutside
{
	if ( NO == _enableAllEvents )
		return;
	
	if ( NO == [self testEvent:UIControlEventTouchDragOutside] )
	{
		[self sendUISignal:BeeUIButton.DRAG_OUTSIDE];
	}
}

- (void)didDragEnter
{
	if ( NO == _enableAllEvents )
		return;
	
	if ( NO == [self testEvent:UIControlEventTouchDragEnter] )
	{
		[self sendUISignal:BeeUIButton.DRAG_ENTER];
	}
}

- (void)didDragExit
{
	if ( NO == _enableAllEvents )
		return;
	
	if ( NO == [self testEvent:UIControlEventTouchDragExit] )
	{
		[self sendUISignal:BeeUIButton.DRAG_EXIT];
	}
}

- (BOOL)testEvent:(UIControlEvents)event
{
	for ( NSArray * action in _actions )
	{
		NSNumber * actionEvent = [action objectAtIndex:0];
		if ( [actionEvent intValue] & event )
		{
			NSString * signal = [action objectAtIndex:1];
			NSObject * object = ([action count] >= 3) ? [action objectAtIndex:2] : nil;
			[self sendUISignal:signal
					withObject:object
						  from:self];
			return YES;
		}
	}
	
	return NO;
}

#pragma mark -

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
	[self setTitle:title];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
	[self setTitleColor:color];
}

- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state
{
	[self setTitleShadowColor:color];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

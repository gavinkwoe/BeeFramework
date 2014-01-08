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

#import "Bee_UICheck.h"
#import "Bee_UIImageView.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"
#import "UIImage+BeeExtension.h"

#pragma mark -

@interface BeeUICheck()
{
	BOOL				_inited;
	BOOL				_checked;
	NSString *			_signal;
	BeeUIImageView *	_underView;
	BeeUIImageView *	_upperView;
}

- (void)initSelf;
- (void)didTouchUpInside;

@end

#pragma mark -

@implementation BeeUICheck

DEF_SIGNAL( CHECKED )
DEF_SIGNAL( UNCHECKED )

@dynamic checked;
@dynamic underImage;
@dynamic upperImage;
@synthesize signal = _signal;

- (id)init
{
	self = [super init];
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
	
		[self addTarget:self action:@selector(didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		
		_underView = [[BeeUIImageView alloc] init];
		_underView.backgroundColor = [UIColor clearColor];
		_underView.autoresizesSubviews = YES;
		_underView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_underView.contentMode = UIViewContentModeCenter;
		[self addSubview:_underView];

		_upperView = [[BeeUIImageView alloc] init];
		_upperView.backgroundColor = [UIColor clearColor];
		_upperView.autoresizesSubviews = YES;
		_upperView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_underView.contentMode = UIViewContentModeCenter;
		_upperView.hidden = YES;
		[self addSubview:_upperView];

		_inited = YES;

//		[self load];
		[self performLoad];
	}
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	_underView.frame = CGRectMake( 0, 0, frame.size.width, frame.size.height );
	_upperView.frame = CGRectMake( 0, 0, frame.size.width, frame.size.height );
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	[_signal release];
	
	SAFE_RELEASE_SUBVIEW( _underView );
	SAFE_RELEASE_SUBVIEW( _upperView );

	[super dealloc];
}

#pragma mark -

- (BOOL)checked
{
	return _checked;
}

- (void)setChecked:(BOOL)flag
{
	if ( _checked != flag )
	{
		_checked = flag;
		
		if ( _checked )
		{
			_upperView.hidden = NO;
		}
		else
		{
			_upperView.hidden = YES;
		}
	}
}

- (void)check
{
	[self setChecked:YES];
}

- (void)uncheck
{
	[self setChecked:NO];
}

- (void)toogle
{
	[self setChecked:_checked ? NO : YES];
}

- (UIImage *)underImage
{
	return _underView.image;
}

- (void)setUnderImage:(UIImage *)image
{
	_underView.image = image;
}

- (UIImage *)upperImage
{
	return _upperView.image;
}

- (void)setUpperImage:(UIImage *)image
{
	_upperView.image = image;
}

#pragma mark -

- (void)didTouchUpInside
{
	[self toogle];

	if ( self.signal )
	{
		[self sendUISignal:self.signal];
	}
	else
	{
		if ( self.checked )
		{
			[self sendUISignal:BeeUICheck.CHECKED];
		}
		else
		{
			[self sendUISignal:BeeUICheck.UNCHECKED];
		}
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

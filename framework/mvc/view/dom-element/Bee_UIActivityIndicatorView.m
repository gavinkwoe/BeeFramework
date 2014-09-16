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

#import "Bee_UIActivityIndicatorView.h"
#import "Bee_UIStyle.h"
#import "Bee_UIStyleParser.h"
#import "UIView+BeeUISignal.h"
#import "UIView+BeeUIStyle.h"
#import "UIView+LifeCycle.h"
#import "UIView+Tag.h"

#pragma mark -

@interface BeeUIActivityIndicatorView()
{
	BOOL	_inited;
}

- (void)initSelf;

@end

@implementation BeeUIActivityIndicatorView

DEF_SIGNAL( WILL_START )
DEF_SIGNAL( DID_START )
DEF_SIGNAL( WILL_STOP )
DEF_SIGNAL( DID_STOP )

@synthesize enableAllEvents;
@dynamic animating;

#pragma mark -

- (id)init
{
	self = [super initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
	self = [super initWithActivityIndicatorStyle:style];
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
		self.hidden = YES;
		self.alpha = 0.0f;
		self.hidesWhenStopped = YES;
		self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;

	#if defined(__IPHONE_5_0)
		if ( IOS5_OR_LATER )
		{
			self.color = [UIColor whiteColor];
		}
	#endif
		
		_inited = YES;

//		[self startAnimating];
//		[self load];
		[self performLoad];
	}
}

- (void)dealloc
{
//	[self unload];
	[self performUnload];
	
	[super dealloc];
}

#pragma mark -

- (BOOL)animating
{
	return self.isAnimating;
}

- (void)setAnimating:(BOOL)flag
{
	if ( flag )
	{
		[self startAnimating];
	}
	else
	{
		[self stopAnimating];
	}
}

- (void)startAnimating
{	
	if ( self.isAnimating )
		return;
	
	if ( self.enableAllEvents )
	{
		[self sendUISignal:BeeUIActivityIndicatorView.WILL_START];
	}
	
	self.hidden = NO;
	self.alpha = 1.0f;
	
	[super startAnimating];

	if ( self.enableAllEvents )
	{
		[self sendUISignal:BeeUIActivityIndicatorView.DID_START];
	}
}

- (void)stopAnimating
{
	if ( NO == self.isAnimating )
		return;

	if ( self.enableAllEvents )
	{
		[self sendUISignal:BeeUIActivityIndicatorView.WILL_STOP];
	}

	self.hidden = YES;		
	self.alpha = 0.0f;

	[super stopAnimating];

	if ( self.enableAllEvents )
	{
		[self sendUISignal:BeeUIActivityIndicatorView.DID_STOP];
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

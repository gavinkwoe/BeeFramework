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
//  Bee_UIPullLoader.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UIPullLoader.h"
#import "Bee_UIActivityIndicatorView.h"
#import "Bee_UISignal.h"
#import "UIView+BeeExtension.h"
#import "UIView+BeeUISignal.h"

#pragma mark -

@interface BeeUIPullLoader(Private)
- (void)initSelf;
@end

@implementation BeeUIPullLoader

DEF_SIGNAL( STATE_CHANGED )

DEF_INT( STATE_NORMAL,	0 )
DEF_INT( STATE_PULLING,	1 )
DEF_INT( STATE_LOADING,	2 )

@synthesize state = _state;
@synthesize arrow = _arrow;
@synthesize indicator = _indicator;

@dynamic normal;
@dynamic pulling;
@dynamic loading;

+ (BeeUIPullLoader *)spawn
{
	return [[[BeeUIPullLoader alloc] init] autorelease];
}

+ (BeeUIPullLoader *)spawn:(NSString *)tagString
{
	BeeUIPullLoader * view = [[[BeeUIPullLoader alloc] init] autorelease];
	view.tagString = tagString;
	return view;
}

- (id)init
{
	self = [super init];
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
		[self changeFrame:frame];
    }
	
    return self;
}

- (void)initSelf
{
	self.backgroundColor = [UIColor clearColor];
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	_arrow = [[UIImageView alloc] initWithFrame:CGRectZero];
	_arrow.contentMode = UIViewContentModeScaleAspectFit;
	_arrow.backgroundColor = [UIColor clearColor];
	_arrow.hidden = NO;
	_arrow.image = [UIImage imageNamed:@"whiteArrow.png"];
	[self addSubview:_arrow];
	
    [_indicator release];
	_indicator = [[BeeUIActivityIndicatorView alloc] initWithFrame:CGRectZero];
	_indicator.hidden = YES;
	_indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	[self addSubview:_indicator];
	
	_state = BeeUIPullLoader.STATE_NORMAL;
}

- (void)changeFrame:(CGRect)frame
{
	CGRect imageFrame;
	imageFrame.size.width = frame.size.height * 0.5f;
	imageFrame.size.height = frame.size.height * 0.5f;
	imageFrame.origin.x = (frame.size.width - imageFrame.size.width) / 2.0f;
	imageFrame.origin.y = (frame.size.height - imageFrame.size.height) / 2.0f;
	_arrow.frame = imageFrame;
	
	CGRect indicatorFrame;
	indicatorFrame.size.width = 20.0f;
	indicatorFrame.size.height = 20.0f;
	indicatorFrame.origin.x = (frame.size.width - indicatorFrame.size.width) / 2.0f;
	indicatorFrame.origin.y = (frame.size.height - indicatorFrame.size.height) / 2.0f;
	_indicator.frame = indicatorFrame;	
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
    [self changeFrame:frame];
}

- (void)dealloc
{	
	SAFE_RELEASE_SUBVIEW( _arrow );
	SAFE_RELEASE_SUBVIEW( _indicator );
	
    [super dealloc];
}

- (BOOL)normal
{
	return (BeeUIPullLoader.STATE_NORMAL == _state) ? YES : NO;
}

- (void)setNormal:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:BeeUIPullLoader.STATE_NORMAL];		
	}
}

- (BOOL)pulling
{
	return (BeeUIPullLoader.STATE_PULLING == _state) ? YES : NO;
}

- (void)setPulling:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:BeeUIPullLoader.STATE_PULLING];		
	}
}

- (BOOL)loading
{
	return (BeeUIPullLoader.STATE_LOADING == _state) ? YES : NO;
}

- (void)setLoading:(BOOL)flag
{
	if ( flag )
	{
		[self changeState:BeeUIPullLoader.STATE_LOADING];
	}
}

- (void)changeState:(NSInteger)state
{
	[self changeState:state animated:NO];
}

- (void)changeState:(NSInteger)state animated:(BOOL)animated
{
	if ( _state == state )
		return;

	_state = state;
	
	if ( BeeUIPullLoader.STATE_NORMAL == state )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3f];
		_arrow.hidden = NO;
		_arrow.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];

		[_indicator stopAnimating];		
	}
	else if ( BeeUIPullLoader.STATE_PULLING == state )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3f];
		_arrow.hidden = NO;
		_arrow.transform = CGAffineTransformRotate( CGAffineTransformIdentity, (M_PI / 360.0f) * -359.0f );
		[UIView commitAnimations];		
	}
	else if ( BeeUIPullLoader.STATE_LOADING == state )
	{
		[_indicator startAnimating];

		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3f];
		_arrow.hidden = YES;
		[UIView commitAnimations];		
	}

	[self sendUISignal:BeeUIPullLoader.STATE_CHANGED];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

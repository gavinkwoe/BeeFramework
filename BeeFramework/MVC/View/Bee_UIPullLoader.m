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

#import <QuartzCore/QuartzCore.h>
#import "Bee_UIPullLoader.h"
#import "Bee_UIActivityIndicatorView.h"
#import "Bee_UISignal.h"

#pragma mark -

@interface BeeUIPullLoader(Private)
- (void)initSelf;
@end

@implementation BeeUIPullLoader

DEF_SIGNAL( STATE_CHANGED )

@synthesize state = _state;

+ (BeeUIPullLoader *)spawn
{
	return [[[BeeUIPullLoader alloc] init] autorelease];
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
    }
	
    return self;
}

- (void)initSelf
{
	self.backgroundColor = [UIColor clearColor];
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	_arrowView = [[UIImageView alloc] initWithFrame:CGRectZero];
	_arrowView.image = [UIImage imageNamed:@"common-pic-load.png"];
	_arrowView.contentMode = UIViewContentModeCenter;
	_arrowView.backgroundColor = [UIColor clearColor];
	_arrowView.hidden = NO;
	[self addSubview:_arrowView];
	
	_indicator = [[BeeUIActivityIndicatorView alloc] initWithFrame:CGRectZero];
	_indicator.hidden = YES;
	[self addSubview:_indicator];
	
	_state = BEE_UIPULLLOADER_STATE_NORMAL;
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];

	CGRect imageFrame;
	imageFrame.size.width = frame.size.height;
	imageFrame.size.height = frame.size.height;
	imageFrame.origin.x = (frame.size.width - imageFrame.size.width) / 2.0f;
	imageFrame.origin.y = (frame.size.height - imageFrame.size.height) / 2.0f;
	_arrowView.frame = imageFrame;
	
	CGRect indicatorFrame;
	indicatorFrame.size.width = 20.0f;
	indicatorFrame.size.height = 20.0f;
	indicatorFrame.origin.x = (frame.size.width - indicatorFrame.size.width) / 2.0f;
	indicatorFrame.origin.y = (frame.size.height - indicatorFrame.size.height) / 2.0f;
	_indicator.frame = indicatorFrame;	
}

- (void)dealloc
{	
	SAFE_RELEASE_SUBVIEW( _arrowView );
	SAFE_RELEASE_SUBVIEW( _indicator );
	
    [super dealloc];
}

- (void)changeState:(BeeUIPullLoaderState)state
{
	[self changeState:state animated:NO];
}

- (void)changeState:(BeeUIPullLoaderState)state animated:(BOOL)animated
{
	if ( _state == state )
		return;

	_state = state;
	
	if ( BEE_UIPULLLOADER_STATE_NORMAL == state )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3f];
		_arrowView.hidden = NO;
		_arrowView.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];

		[_indicator stopAnimating];		
	}
	else if ( BEE_UIPULLLOADER_STATE_PULLING == state )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3f];
		_arrowView.hidden = NO;
		_arrowView.transform = CGAffineTransformRotate( CGAffineTransformIdentity, (M_PI / 360.0f) * -359.0f );
		[UIView commitAnimations];		
	}
	else if ( BEE_UIPULLLOADER_STATE_LOADING == state )
	{
		[_indicator startAnimating];

		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3f];
		_arrowView.hidden = YES;
		[UIView commitAnimations];		
	}

	[self sendUISignal:BeeUIPullLoader.STATE_CHANGED];
}

@end

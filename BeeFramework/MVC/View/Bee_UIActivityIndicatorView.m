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
//  Bee_UIActivityIndicatorView.m
//

#import <QuartzCore/QuartzCore.h>
#import "Bee_UIActivityIndicatorView.h"
#import "Bee_UISignal.h"
#import "Bee_SystemInfo.h"

#pragma mark -

@interface BeeUIActivityIndicatorView(Private)
- (void)initSelf;
@end

@implementation BeeUIActivityIndicatorView

DEF_SIGNAL( WILL_START )
DEF_SIGNAL( DID_START )
DEF_SIGNAL( WILL_STOP )
DEF_SIGNAL( DID_STOP )

+ (BeeUIActivityIndicatorView *)spawn
{
	return [[[BeeUIActivityIndicatorView alloc] init] autorelease];
}

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
}

- (void)startAnimating
{	
	if ( self.isAnimating )
		return;
	
	[self sendUISignal:BeeUIActivityIndicatorView.WILL_START];
	
	self.hidden = NO;
	self.alpha = 1.0f;
	
	[super startAnimating];

	[self sendUISignal:BeeUIActivityIndicatorView.DID_START];
}

- (void)stopAnimating
{
	if ( NO == self.isAnimating )
		return;

	[self sendUISignal:BeeUIActivityIndicatorView.WILL_STOP];

	self.hidden = YES;		
	self.alpha = 0.0f;

	[super stopAnimating];

	[self sendUISignal:BeeUIActivityIndicatorView.DID_STOP];
}

- (void)dealloc
{
	[super dealloc];
}

@end

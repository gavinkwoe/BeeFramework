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
//  Bee_UINavigationBar.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UINavigationBar.h"
#import "Bee_Runtime.h"
#import "UIView+BeeExtension.h"
#import "UIView+BeeUISignal.h"
#import "UIViewController+BeeUISignal.h"

#pragma mark -

#undef	UNUSED
#define UNUSED( __x )	(void)(__x)

#pragma mark -

static UIImage * __defaultImage = nil;

#pragma mark -

@implementation BeeUINavigationBar

DEF_NOTIFICATION( BACKGROUND_CHANGED )

@synthesize navigationController = _navigationController;
@dynamic backgroundImage;

- (id)init
{
    self = [super initWithFrame:CGRectZero];
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
		[self setBarStyle:UIBarStyleBlackOpaque];
		[self observeNotification:BeeUINavigationBar.BACKGROUND_CHANGED];
	
	self.layer.masksToBounds = NO;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOffset = CGSizeMake(0, 2);
	self.layer.shadowRadius = 0.6f;
	self.layer.shadowOpacity = 0.6f;
}

- (void)dealloc
{
	[self unobserveAllNotifications];
	
    [_backgroundImage release];
	
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    if ( _backgroundImage )
	{
        [_backgroundImage drawInRect:rect];
    }
	else if ( __defaultImage )
	{
		[__defaultImage drawInRect:rect];
	}
	else
	{
        [super drawRect:rect];
    }
}

- (void)handleNotification:(NSNotification *)notification
{
	if ( [notification is:BeeUINavigationBar.BACKGROUND_CHANGED] )
	{
		[self setNeedsDisplay];
	}
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( _navigationController )
	{
		UIViewController * vc = _navigationController.topViewController;
		if ( vc )
		{
			[signal forward:vc];
		}
	}
	else
	{
		[super handleUISignal:signal];
	}
}

- (void)setBackgroundImage:(UIImage *)image
{
	[image retain];
	[_backgroundImage release];
	_backgroundImage = image;
	
	[self setNeedsDisplay];
}

+ (void)setBackgroundImage:(UIImage *)image
{
	[image retain];
	[__defaultImage release];
	__defaultImage = image;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BeeUINavigationBar.BACKGROUND_CHANGED object:nil];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

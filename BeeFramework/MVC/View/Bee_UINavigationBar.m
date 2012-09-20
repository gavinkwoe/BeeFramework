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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Bee_UINavigationBar.h"
#import "Bee_UISignal.h"
#import "Bee_Log.h"

@implementation BeeUINavigationBar

@dynamic backgroundImage;

static UIImage * __defaultImage = nil;

+ (BeeUINavigationBar *)spawn
{
	return [[[BeeUINavigationBar alloc] init] autorelease];
}

+ (void)setDefaultBackgroundImage:(UIImage *)image
{
	[image retain];
	[__defaultImage release];
	__defaultImage = image;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
	{
    }
    return self;
}

- (void)dealloc
{
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

- (void)setBackgroundImage:(UIImage *)image
{
	[image retain];
	[_backgroundImage release];
	_backgroundImage = image;
	
	[self setNeedsDisplay];
}

@end

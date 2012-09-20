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
//  Bee_UIPageControl.m
//

#import <QuartzCore/QuartzCore.h>
#import "Bee_UIPageControl.h"
#import "Bee_UISignal.h"
#import "Bee_SystemInfo.h"

#pragma mark -

@interface BeeUIPageControl(Private)
- (void)initSelf;
- (void)updateDotImages;
@end

@implementation BeeUIPageControl

@synthesize dotImageNormal = _dotImageNormal;
@synthesize dotImageHilite = _dotImageHilite;
@synthesize dotSize = _dotSize;

+ (BeeUIPageControl *)spawn
{
	return [[[BeeUIPageControl alloc] init] autorelease];
}

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
	self.numberOfPages = 0;
	self.currentPage = 0;
	self.hidesForSinglePage = YES;
	self.defersCurrentPageDisplay = NO;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
	return _dotSize;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super endTrackingWithTouch:touch withEvent:event];
	
	[self updateDotImages];
}

- (void)updateDotImages
{
	for ( UIView * subView in self.subviews )
	{
		NSUInteger index = 0;
		
		if ( [subView isKindOfClass:[UIImageView class]] )
		{
			index += 1;
			
			UIImageView * imageView = (UIImageView *)subView;
			if ( self.currentPage == index )
			{
				if ( self.dotImageHilite )
				{
					imageView.image = self.dotImageHilite;					
				}
			}
			else
			{
				if ( self.dotImageNormal )
				{
					imageView.image = self.dotImageNormal;					
				}
			}
		}
	}
}

- (void)dealloc
{
	[_dotImageNormal release];
	[_dotImageHilite release];

	[super dealloc];
}

@end

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

#import "Bee_UIAnimationAlpha.h"

#pragma mark -

@interface BeeUIAnimationAlpha()
- (void)animationPerformForward;
- (void)animationPerformBackward;
@end

#pragma mark -

@implementation BeeUIAnimationAlpha

@dynamic from;
@dynamic to;

#pragma mark -

- (CGFloat)from
{
	NSNumber * number = [self.params objectForKey:@"from"];
	if ( number )
	{
		return number.floatValue;
	}
	
	return -1.0f;
}

- (void)setFrom:(CGFloat)value
{
	[self.params setObject:[NSNumber numberWithFloat:value] forKey:@"from"];
}

- (CGFloat)to
{
	NSNumber * number = [self.params objectForKey:@"to"];
	if ( number )
	{
		return number.floatValue;
	}
	
	return -1.0f;
}

- (void)setTo:(CGFloat)value
{
	[self.params setObject:[NSNumber numberWithFloat:value] forKey:@"to"];
}

#pragma mark -

- (void)load
{
	self.type = BeeUIAnimationTypeAlpha;
//	self.from = -1.0f;
	self.to = 1.0f;
	self.autoCommit = YES;
}

- (void)unload
{
}

- (void)animationPerform
{
	if ( self.reversed )
	{
		[self animationPerformBackward];
	}
	else
	{
		[self animationPerformForward];
	}
}

- (void)animationPerformForward
{
	if ( self.from >= 0.0f )
	{
		for ( UIView * view in self.views )
		{
			view.alpha = self.from;
		}
	}
	
	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelay:self.delay];
	[UIView setAnimationDuration:self.duration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	
	if ( self.to >= 0.0f )
	{
		for ( UIView * view in self.views )
		{
			view.alpha = self.to;
		}
	}

	if ( self.autoCommit )
	{
		[UIView commitAnimations];

		self.performing = YES;
	}
}

- (void)animationPerformBackward
{
	if ( self.to >= 0.0f )
	{
		for ( UIView * view in self.views )
		{
			view.alpha = self.to;
		}
	}

	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelay:self.delay];
	[UIView setAnimationDuration:self.duration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];

	if ( self.from >= 0.0f )
	{
		for ( UIView * view in self.views )
		{
			view.alpha = self.from;
		}
	}

	[UIView commitAnimations];

	if ( self.autoCommit )
	{
		[UIView commitAnimations];
		
		self.performing = YES;
	}
}

- (void)animationDidStop
{
	self.completed = YES;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

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

#import "Bee_UIAnimationBounce.h"

#pragma mark -

@interface BeeUIAnimationBounce()
- (void)bounce1AnimationDidStop;
- (void)bounce2AnimationDidStop;
- (void)bounce3AnimationDidStop;
- (void)animationDidStop;
@end

#pragma mark -

@implementation BeeUIAnimationBounce

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
	self.type = BeeUIAnimationTypeBounce;
	self.to = 1.0f;
}

- (void)unload
{
}

- (void)animationPerform
{
	if ( self.from >= 0.0f )
	{
		CGFloat scale = self.from;
		
		for ( UIView * view in self.views )
		{
			view.transform = CGAffineTransformScale( CGAffineTransformIdentity, scale, scale );
		}
	}

	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelay:self.delay];
	[UIView setAnimationDuration:(self.duration / 4.0f)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationDidStop)];

	if ( self.to >= 0.0f )
	{
		CGFloat scale = self.to;
		
		for ( UIView * view in self.views )
		{
			view.transform = CGAffineTransformScale( CGAffineTransformIdentity, scale * 1.16f, scale * 1.16f );
		}
	}
	
	if ( self.autoCommit )
	{
		[UIView commitAnimations];
		
		self.performing = YES;
	}
}

- (void)bounce1AnimationDidStop
{
	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:(self.duration / 4.0f)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationDidStop)];

	if ( self.to >= 0.0f )
	{
		CGFloat scale = self.to;
		
		for ( UIView * view in self.views )
		{
			view.transform = CGAffineTransformScale( CGAffineTransformIdentity, scale * 0.92f, scale * 0.92f );
		}
	}
	
	[UIView commitAnimations];
}

- (void)bounce2AnimationDidStop
{
	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:(self.duration / 4.0f)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce3AnimationDidStop)];

	if ( self.to >= 0.0f )
	{
		CGFloat scale = self.to;
		
		for ( UIView * view in self.views )
		{
			view.transform = CGAffineTransformScale( CGAffineTransformIdentity, scale * 1.08f, scale * 1.08f );
		}
	}
	
	[UIView commitAnimations];
}

- (void)bounce3AnimationDidStop
{
	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:(self.duration / 4.0f)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	
	if ( self.to >= 0.0f )
	{
		CGFloat scale = self.to;
		
		for ( UIView * view in self.views )
		{
			view.transform = CGAffineTransformScale( CGAffineTransformIdentity, scale * 1.0f, scale * 1.0f );
		}
	}
	
	[UIView commitAnimations];
}

- (void)animationDidStop
{
	self.completed = YES;
}

@end

#pragma mark -


#pragma mark -

@interface BeeUIAnimationDissolve()
- (void)animationDidStop;
@end

#pragma mark -

@implementation BeeUIAnimationDissolve

- (void)load
{
	self.type = BeeUIAnimationTypeDissolve;
}

- (void)unload
{
}

- (void)animationPerform
{
	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelay:self.delay];
	[UIView setAnimationDuration:self.duration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	
	for ( UIView * view in self.views )
	{
		view.transform = CGAffineTransformScale( CGAffineTransformIdentity, 1.25f, 1.25f );
		view.alpha = 0.0f;
	}

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

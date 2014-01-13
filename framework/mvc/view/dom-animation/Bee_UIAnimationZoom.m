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

#import "Bee_UIAnimationZoom.h"

#pragma mark -

@implementation BeeUIAnimationZoomIn

@dynamic rect;

- (CGRect)rect
{
	NSValue * value = [self.params objectForKey:@"rect"];
	if ( value )
	{
		return value.CGRectValue;
	}
	
	return CGRectZero;
}

- (void)setRect:(CGRect)value
{
	[self.params setObject:[NSValue valueWithCGRect:value] forKey:@"rect"];
}

- (void)load
{
	self.type = BeeUIAnimationTypeZoomIn;
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
		CGPoint center1 = CGPointMake( view.bounds.origin.x + (view.bounds.size.width / 2.0f), view.bounds.origin.y + (view.bounds.size.height / 2.0f) );
		CGPoint center2 = CGPointMake( self.rect.origin.x + (self.rect.size.width / 2.0f), self.rect.origin.y + (self.rect.size.height / 2.0f) );
		
		CGFloat depthZ = self.rect.size.width;
		CGFloat transZ = self.rect.size.width * ((view.bounds.size.width - self.rect.size.width) / view.bounds.size.width);
		CGFloat transX = center1.x - center2.x;
		CGFloat transY = center1.y - center2.y;
		
		CATransform3D transform = view.layer.transform;
		transform.m34 = -(1.0f / depthZ);
		transform = CATransform3DTranslate( transform, transX, transY, transZ );
		
		view.layer.transform = transform;
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

#pragma mark -

@implementation BeeUIAnimationZoomOut

- (void)load
{
	self.type = BeeUIAnimationTypeZoomOut;
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
		view.layer.transform = CATransform3DIdentity;
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

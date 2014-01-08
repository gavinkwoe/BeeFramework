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

#import "ServiceShare_Window.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceShare_Window

DEF_SINGLETON( ServiceShare_Window )

DEF_NOTIFICATION( OPEN )
DEF_NOTIFICATION( CLOSE )

#pragma mark -

- (void)load
{
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;

//    self.windowLevel = UIWindowLevelNormal + 5.0f;

    self.windowLevel = UIWindowLevelNormal + 2.0f;

}

- (void)unload
{
}

#pragma mark -

- (void)didOpen
{
	[self makeKeyAndVisible];
}

- (void)didClose
{
	self.hidden = YES;
	self.rootViewController = nil;

    [[BeeUIApplication sharedInstance].window makeKeyAndVisible];
}

- (void)open
{
    if ( NO == self.hidden )
        return;

	self.hidden = NO;

	CATransform3D transform;
    
	transform = CATransform3DIdentity;
	transform.m34 = -(1.0f / 2500.0f);
	transform = CATransform3DTranslate( transform, 0, 0, 200.0f );
	
	self.alpha = 0.0f;
	self.layer.transform = transform;

	[BeeUIApplication sharedInstance].window.alpha = 1.0f;
	[BeeUIApplication sharedInstance].window.layer.transform = CATransform3DIdentity;
	
	[UIView beginAnimations:@"openWindow" context:nil];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDidStopSelector:@selector(didOpen)];
    
	transform = CATransform3DIdentity;
	transform.m34 = -(1.0f / 2500.0f);
	transform = CATransform3DTranslate( transform, 0, 0, -200.0f );
	
	[BeeUIApplication sharedInstance].window.alpha = 0.0f;
	[BeeUIApplication sharedInstance].window.layer.transform = transform;
    
	self.alpha = 1.0f;
	self.layer.transform = CATransform3DIdentity;
    
	[UIView commitAnimations];
}

- (void)close
{
    if ( self.hidden )
        return;
    
    [self endEditing:YES];
    
	[UIView beginAnimations:@"closeWindow" context:nil];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didClose)];
	
	[BeeUIApplication sharedInstance].window.alpha = 1.0f;
	[BeeUIApplication sharedInstance].window.layer.transform = CATransform3DIdentity;
    
	CATransform3D transform;
	transform = CATransform3DIdentity;
	transform.m34 = -(1.0f / 2500.0f);
	transform = CATransform3DTranslate( transform, 0, 0, 200.0f );
    
	self.alpha = 0.0f;
	self.layer.transform = transform;
    
	[UIView commitAnimations];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

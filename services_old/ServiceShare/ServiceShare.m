//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2013-2014, {Bee} open source community
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceShare.h"
#import "ServiceShare_Window.h"
#import "ServiceShare_AuthorizeBoard.h"

@implementation ServiceShare

DEF_NOTIFICATION( OPEN )
DEF_NOTIFICATION( CLOSE )

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( NO )

- (void)load
{
	[super load];
    
    [self observeNotification:ServiceShareApi.BEGIN];
    [self observeNotification:ServiceShareApi.CANCEL];
    [self observeNotification:ServiceShareApi.FAILURE];
    [self observeNotification:ServiceShareApi.SUCCESS];
    [self observeNotification:ServiceShareApi.AUTHORIZE_CANCEL];
    [self observeNotification:ServiceShareApi.AUTHORIZE_FAILURE];
    [self observeNotification:ServiceShareApi.AUTHORIZE_SUCCESS];
}

- (void)unload
{
	[self unobserveAllNotifications];
	
	[super unload];
}

- (void)powerOn
{
//    [Weixin powerOn];
//	[ServiceShare_Window sharedInstance].hidden = YES;
}

- (void)powerOff
{
}

#pragma mark -

ON_NOTIFICATION2( ServiceShareApi, notification )
{
//    if ( [notification is:ServiceShareApi.BEGIN] )
//    {
//    }
//    else if ( [notification is:ServiceShareApi.CANCEL] )
//    {
//        [self hideAuthorizeBoard];
//    }
//    else if ( [notification is:ServiceShareApi.FAILURE] )
//    {
//        [self hideAuthorizeBoard];
//    }
//    else if ( [notification is:ServiceShareApi.SUCCESS] )
//    {
//        [self hideAuthorizeBoard];
//    }
//    else
    if ( [notification is:ServiceShareApi.AUTHORIZE_FAILURE] )
    {
        [self hideAuthorizeBoard];
    }
    else if ( [notification is:ServiceShareApi.AUTHORIZE_SUCCESS] )
    {
        [self hideAuthorizeBoard];
    }
    else if ( [notification is:ServiceShareApi.AUTHORIZE_CANCEL] )
    {
        [self hideAuthorizeBoard];
    }
}

#pragma mark -

- (void)showAuthorizeBoard:(Class)boardClazz
{
    [self openWindow];
    
    [ServiceShare_Window sharedInstance].rootViewController = [BeeUIStack stackWithFirstBoard:[boardClazz board]];
}

- (void)hideAuthorizeBoard
{
    [self closeWindow];
}

- (void)showEditBoard:(Class)boardClazz;
{
    [self openWindow];
}

- (void)hideEditBoard
{
    [self closeWindow];
}

#pragma mark - manage the service window

- (void)didOpen
{
}

- (void)didClose
{
    [ServiceShare_Window sharedInstance].hidden = YES;
    [[BeeUIApplication sharedInstance].window makeKeyAndVisible];
}

- (void)openWindow
{
    if ( NO == [ServiceShare_Window sharedInstance].hidden )
    {
        return;
    }
    
	[ServiceShare_Window sharedInstance].hidden = NO;
    [[ServiceShare_Window sharedInstance] makeKeyAndVisible];
    
	CATransform3D transform;
    
	transform = CATransform3DIdentity;
	transform.m34 = -(1.0f / 2500.0f);
	transform = CATransform3DTranslate( transform, 0, 0, 200.0f );
	[ServiceShare_Window sharedInstance].alpha = 0.0f;
	[ServiceShare_Window sharedInstance].layer.transform = transform;
	
	[UIApplication sharedApplication].keyWindow.alpha = 1.0f;
	[UIApplication sharedApplication].keyWindow.layer.transform = CATransform3DIdentity;
	
	[UIView beginAnimations:@"openWindow" context:nil];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDidStopSelector:@selector(didOpen)];
    
	transform = CATransform3DIdentity;
	transform.m34 = -(1.0f / 2500.0f);
	transform = CATransform3DTranslate( transform, 0, 0, -200.0f );
	
	[UIApplication sharedApplication].keyWindow.alpha = 0.0f;
	[UIApplication sharedApplication].keyWindow.layer.transform = transform;
    
	[ServiceShare_Window sharedInstance].alpha = 1.0f;
	[ServiceShare_Window sharedInstance].layer.transform = CATransform3DIdentity;
    
	[UIView commitAnimations];
}

- (void)closeWindow
{
    if ( YES == [ServiceShare_Window sharedInstance].hidden )
    {
        return;
    }
    
    [[ServiceShare_Window sharedInstance] endEditing:YES];
    
	[UIView beginAnimations:@"closeWindow" context:nil];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didClose)];
	
	[UIApplication sharedApplication].keyWindow.alpha = 1.0f;
	[UIApplication sharedApplication].keyWindow.layer.transform = CATransform3DIdentity;
    
	CATransform3D transform;
	transform = CATransform3DIdentity;
	transform.m34 = -(1.0f / 2500.0f);
	transform = CATransform3DTranslate( transform, 0, 0, 200.0f );
    
	[ServiceShare_Window sharedInstance].alpha = 0.0f;
	[ServiceShare_Window sharedInstance].layer.transform = transform;
    
	[UIView commitAnimations];
}

@end

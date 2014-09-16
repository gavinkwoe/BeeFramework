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

#import "DribbblePreviewBoard_iPhone.h"

#pragma mark -

@implementation DribbblePreviewBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

@synthesize shot = _shot;

DEF_OUTLET( BeeUIZoomImageView, preview );

- (void)load
{
}

- (void)unload
{
	self.shot = nil;
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
//	self.allowedSwipeToBack = YES;
	
	self.view.backgroundColor = SHORT_RGB( 0x444 );

	self.navigationBarShown = YES;
	self.navigationBarTitle = @"Dribbble"; // self.shot.title;
	self.navigationBarLeft  = [UIImage imageNamed:@"navigation-back.png"];
}

ON_DELETE_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
}

ON_DID_APPEAR( signal )
{
	self.preview.imageView.enableAllEvents = YES;
	self.preview.data = self.shot.image_url;
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
	[self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
	[self presentLoadingTips:@"Saving..."];
	
	UIImageWriteToSavedPhotosAlbum( self.preview.imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil );
}

#pragma mark -

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    if ( error )
	{
		[self presentFailureTips:@"Failed to download"];
	}
	else
	{
		[self presentSuccessTips:@"Done"];
	}
}

#pragma mark -

ON_SIGNAL3( BeeUIImageView, LOAD_CACHE, signal )
{
	if ( self.preview.imageView.loaded )
	{
		[self transitionFade];
		
		self.navigationBarRight = @"Save";
	}
}

ON_SIGNAL3( BeeUIImageView, LOAD_COMPLETED, signal )
{
	if ( self.preview.imageView.loaded )
	{
		[self transitionFade];
		
		self.navigationBarRight = @"Save";
	}
}

@end

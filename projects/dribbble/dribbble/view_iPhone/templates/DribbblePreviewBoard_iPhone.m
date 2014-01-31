//
//  PhotoPreviewBoard_iPhone.m
//  Beestrap
//
//  Created by QFish on 9/6/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "PhotoPreviewBoard_iPhone.h"

#pragma mark -

@implementation PhotoPreviewBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

@synthesize imageURL = _imageURL;
@synthesize image = _image;

DEF_OUTLET( BeeUIZoomImageView, preview );

#pragma mark -

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = HEX_RGB( 0xdfdfdf );
	
	self.navigationBarShown = YES;
	self.navigationBarTitle = @"预览";
	self.navigationBarLeft  = [UIImage imageNamed:@"navigation-back.png"];
}

ON_DELETE_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	bee.ext.appBoard.menuShown = NO;
	self.preview.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.preview.imageView.indicatorStyle = UIActivityIndicatorViewStyleWhite;
	self.preview.imageView.data = @"empty_photo.png";
    
    if ( self.image )
    {
        self.preview.imageView.data = self.image;
    }
    else
    {
        self.preview.imageView.data = self.imageURL;
    }
	self.preview.imageView.alpha = 0.f;
}

ON_DID_APPEAR( signal )
{
	[UIView animateWithDuration:0.35f animations:^{
		self.preview.imageView.alpha = 1.f;
	}];
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
	[self.stack popBoardAnimated:YES];
}

@end

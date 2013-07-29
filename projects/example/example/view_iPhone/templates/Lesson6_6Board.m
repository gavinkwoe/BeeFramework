//
//  Lesson6_6Board.m
//

#import "Lesson6_6Board.h"

#pragma mark -

@implementation Lesson6_6Board

- (void)load
{
	
}

- (void)unload
{
	
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self setTitleString:@"BeeUIImageView"];
			[self showNavigationBarAnimated:NO];
			[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"navigation-back.png"]];

			_image1 = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
			_image1.contentMode = UIViewContentModeScaleAspectFit;
			_image1.url = @"http://dribbble.s3.amazonaws.com/users/2862/screenshots/802586/asiabear.jpg";
			[self.view addSubview:_image1];
			
			_image2 = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
			_image2.contentMode = UIViewContentModeScaleAspectFill;
			_image2.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
			_image2.url = @"http://dribbble.s3.amazonaws.com/users/2862/screenshots/802586/asiabear.jpg";
			[self.view addSubview:_image2];
			
			_image3 = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
			_image3.contentMode = UIViewContentModeScaleAspectFit;
			_image3.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
			_image3.round = YES;
			_image3.url = @"http://dribbble.s3.amazonaws.com/users/2862/screenshots/802586/asiabear.jpg";
			[self.view addSubview:_image3];
			
			_image4 = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
			_image4.contentMode = UIViewContentModeScaleAspectFill;
			_image4.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
			_image4.gray = YES;
			_image4.url = @"http://dribbble.s3.amazonaws.com/users/2862/screenshots/802586/asiabear.jpg";
			[self.view addSubview:_image4];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			SAFE_RELEASE_SUBVIEW( _image1 );
			SAFE_RELEASE_SUBVIEW( _image2 );
			SAFE_RELEASE_SUBVIEW( _image3 );
			SAFE_RELEASE_SUBVIEW( _image4 );
		}
		else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
		{			
			CGRect imageFrame;
			imageFrame.size.width = self.viewSize.width / 2.0f;
			imageFrame.size.height = self.viewSize.height / 2.0f;
			imageFrame.origin = CGPointZero;
			
			_image1.frame = imageFrame;
			_image2.frame = CGRectOffset( imageFrame, imageFrame.size.width, 0.0f );
			_image3.frame = CGRectOffset( imageFrame, 0.0f, imageFrame.size.height );
			_image4.frame = CGRectOffset( imageFrame, imageFrame.size.width, imageFrame.size.height );
		}
	}
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[self.stack popBoardAnimated:YES];
}

@end

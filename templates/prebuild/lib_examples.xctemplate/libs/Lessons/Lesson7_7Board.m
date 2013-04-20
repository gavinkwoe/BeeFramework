//
//  Lesson7_7Board.m
//

#import "Lesson7_7Board.h"

#pragma mark -

@implementation Lesson7_7Board

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self setTitleString:@"BeeUIImageView"];
			[self showNavigationBarAnimated:NO];
			
			_image1 = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
			_image1.resource = @"Default.png";
			[self.view addSubview:_image1];
			
			_image2 = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
			_image2.contentMode = UIViewContentModeScaleAspectFill;
			_image2.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
			_image2.url = @"http://dribbble.s3.amazonaws.com/users/2862/screenshots/802586/asiabear.jpg";
			[self.view addSubview:_image2];
			
			_image3 = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
			_image3.contentMode = UIViewContentModeScaleAspectFit;
			_image3.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
			_image3.rounded = YES;
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

@end

//
//  DribbblePhotoBoard.m
//

#import "DribbblePhotoBoard.h"

#pragma mark -

@implementation DribbblePhotoBoard

@synthesize feed = _feed;

- (void)load
{
	[super load];
}

- (void)unload
{
	[_feed release];
	
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self showNavigationBarAnimated:NO];

			_imageView = [[BeeUIImageView alloc] initWithFrame:self.viewBound];
			_imageView.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;

			_zoomView = [[BeeUIZoomView alloc] initWithFrame:self.viewBound];
			_zoomView.backgroundColor = [UIColor blackColor];
			[_zoomView setContent:_imageView animated:NO];
			[self.view addSubview:_zoomView];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			SAFE_RELEASE_SUBVIEW( _zoomView );
			SAFE_RELEASE_SUBVIEW( _imageView );
		}
		else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
		{
			self.title = [_feed stringAtPath:@"/title"];

			CGSize photoSize;
			photoSize.width = [[_feed numberAtPath:@"/width"] floatValue];
			photoSize.height = [[_feed numberAtPath:@"/height"] floatValue];

			_imageView.frame = CGRectMake( 0.0f, 0.0f, photoSize.width, photoSize.height );
			_imageView.url = [_feed stringAtPath:@"/image_url"];

			[_zoomView setContentSize:photoSize];
			[_zoomView layoutContent];
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{
		}
		else if ( [signal is:BeeUIBoard.BACK_BUTTON_TOUCHED] )
		{
			
		}
		else if ( [signal is:BeeUIBoard.DONE_BUTTON_TOUCHED] )
		{
		}
	}
}

@end

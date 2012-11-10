//
//  DribbblePhotoBoard.h
//

#import "Bee.h"

#pragma mark -

@interface DribbblePhotoBoard : BeeUIBoard
{
	NSDictionary *		_feed;
	BeeUIImageView *	_imageView;
	BeeUIZoomView *		_zoomView;
}

@property (nonatomic, retain) NSDictionary *	feed;

@end

//
//  DribbbleBoard.h
//

#import "Bee.h"
#import "DribbbleModel.h"
#import "DribbbleController.h"

#pragma mark -

@interface DribbbleCell : BeeUIGridCell
{
	BeeUIImageView *	_photo;
	UIView *			_mask;
	BeeUIImageView *	_avatar;
	BeeUILabel *		_title;
	BeeUILabel *		_name;
	BeeUILabel *		_time;
}
@end

#pragma mark -

@interface DribbbleBoard : BeeUITableBoard
AS_SINGLETON( DribbbleBoard );
@end

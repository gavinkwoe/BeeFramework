//
//  DribbbleBoard.h
//

#import "Bee.h"
#import "DribbbleModel.h"
#import "Bee_UITableBoard.h"

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
{
	DribbbleEveryoneModel *		_everyoneModel;
	DribbbleDebutsModel *		_debutsModel;
	DribbblePopularModel *		_popularModel;
}
@end

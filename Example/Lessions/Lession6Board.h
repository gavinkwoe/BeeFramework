//
//  DribbbleBoard.h
//

#import "Bee.h"

#pragma mark -

@interface Lession6Cell : BeeUIGridCell
{
	BeeUIImageView *	_photo;
}
@end

#pragma mark -

@interface Lession6Board : BeeUIFlowBoard
{
	NSMutableArray *	_datas;
}

@end

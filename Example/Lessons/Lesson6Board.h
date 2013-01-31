//
//  DribbbleBoard.h
//

#import "Bee.h"
#import "Bee_UIFlowBoard.h"

#pragma mark -

@interface Lesson6Cell : BeeUIGridCell
{
	BeeUIImageView *	_photo;
}
@end

#pragma mark -

@interface Lesson6Board : BeeUIFlowBoard
{
	NSMutableArray *	_datas;
}

@end

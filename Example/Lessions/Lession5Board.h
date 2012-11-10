//
//  DribbbleBoard.h
//

#import "Bee.h"

#pragma mark -

@interface Lession5CellLayout1 : NSObject
AS_SINGLETON(Lession5CellLayout1);
@end

@interface Lession5CellLayout2 : NSObject
AS_SINGLETON(Lession5CellLayout2);
@end

@interface Lession5Cell : BeeUIGridCell
{
	BeeUIImageView *	_photo1;
	BeeUIImageView *	_photo2;
	BeeUIImageView *	_photo3;
}
@end

#pragma mark -

@interface Lession5Board : BeeUITableBoard
{
	NSMutableArray *	_datas;
}

@end

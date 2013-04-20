//
//  DribbbleBoard.h
//

#import "Bee.h"
#import "Bee_UITableBoard.h"

#pragma mark -

@interface Lesson5CellLayout1 : NSObject
AS_SINGLETON(Lesson5CellLayout1);
@end

@interface Lesson5CellLayout2 : NSObject
AS_SINGLETON(Lesson5CellLayout2);
@end

@interface Lesson5Cell : BeeUIGridCell
{
	BeeUIImageView *	_photo1;
	BeeUIImageView *	_photo2;
	BeeUIImageView *	_photo3;
}
@end

#pragma mark -

@interface Lesson5Board : BeeUITableBoard
{
	NSMutableArray *	_datas;
}

@end

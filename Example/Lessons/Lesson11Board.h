//
//  Lesson10Model.h
//

#import "Lesson10Model.h"
#import "Bee.h"
#import "Bee_UITableBoard.h"

#pragma mark -

@interface Lesson11Cell : BeeUIGridCell
{
	BeeUILabel *		_label1;
	BeeUILabel *		_label2;
}
@end

#pragma mark -

@interface Lesson11Board : BeeUITableBoard
{
	NSMutableArray *	_records;
}

@end

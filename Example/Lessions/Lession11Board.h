//
//  Lession10Model.h
//

#import "Lession10Model.h"
#import "Bee.h"
#import "Bee_UITableBoard.h"

#pragma mark -

@interface Lession11Cell : BeeUIGridCell
{
	BeeUILabel *		_label1;
	BeeUILabel *		_label2;
}
@end

#pragma mark -

@interface Lession11Board : BeeUITableBoard
{
	NSMutableArray *	_records;
}

@end

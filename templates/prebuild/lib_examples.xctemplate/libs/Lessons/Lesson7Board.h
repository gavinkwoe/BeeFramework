//
//  DribbbleBoard.h
//

#import "Bee.h"
#import "Bee_UITableBoard.h"

#pragma mark -

@interface Lesson7Cell : BeeUIGridCell
{
	BeeUILabel *		_title;
}
@end

#pragma mark -

@interface Lesson7Board : BeeUITableBoard
{
	NSMutableArray *	_items;
}
@end

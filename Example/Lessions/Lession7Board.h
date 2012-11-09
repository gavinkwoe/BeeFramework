//
//  DribbbleBoard.h
//

#import "Bee.h"

#pragma mark -

@interface Lession7Cell : BeeUIGridCell
{
	BeeUILabel *		_title;
}
@end

#pragma mark -

@interface Lession7Board : BeeUITableBoard
{
	NSMutableArray *	_items;
}
@end

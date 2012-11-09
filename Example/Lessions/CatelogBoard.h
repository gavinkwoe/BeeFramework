//
//  CatelogBoard.h
//

#import "Bee.h"

#pragma mark -

@interface CatelogCell : BeeUIGridCell
{
	BeeUILabel *		_title;
	BeeUILabel *		_intro;
}
@end

#pragma mark -

@interface CatelogBoard : BeeUITableBoard
{
	NSMutableArray * _lessions;
}

AS_SINGLETON( CatelogBoard );

@end

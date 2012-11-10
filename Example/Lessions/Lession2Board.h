//
//  Lession2Board.h
//

#import "Bee.h"
#import "LessionBaseBoard.h"

#pragma mark -

@interface Lession2View2 : UIView
{
	BeeUIButton *	_innerView;
}

AS_SIGNAL( TEST )

@end

#pragma mark -

@interface Lession2View1 : UIView
{
	Lession2View2 *	_innerView;
}
@end

#pragma mark -

@interface Lession2Board : LessionBaseBoard
{
	Lession2View1 *	_innerView;
}
@end

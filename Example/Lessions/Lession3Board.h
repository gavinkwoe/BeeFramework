//
//  Lession2Board.h
//

#import "Bee.h"
#import "LessionBaseBoard.h"

#pragma mark -

@interface Lession3Board : LessionBaseBoard
{
	BeeUIButton *	_button1;
	BeeUIButton *	_button2;
}

AS_SIGNAL( BACK );
AS_SIGNAL( ENTER );

@end

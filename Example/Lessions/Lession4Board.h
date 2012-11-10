//
//  Lession2Board.h
//

#import "Lession3Board.h"
#import "Bee.h"

#pragma mark -

@interface Lession4InnerBoard : LessionBaseBoard
{
	BeeUIButton *	_button1;
	BeeUIButton *	_button2;
}

AS_SIGNAL( BACK );
AS_SIGNAL( ENTER );

@end

#pragma mark -

@interface Lession4Board : BeeUIStackGroup
@end

//
//  Lession9Board.h
//

#import "Lession9Controller.h"
#import "Bee.h"

#pragma mark -

@interface Lession9Board : BeeUIBoard
{
	BeeUIButton *	_button1;
	BeeUIButton *	_button2;
}

AS_SIGNAL( BUTTON1_TOUCHED )
AS_SIGNAL( BUTTON2_TOUCHED )

@end

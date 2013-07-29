//
//  Lesson6_1Board.h
//

#import "Bee.h"

#pragma mark -

@interface Lesson6_1Board : BeeUIBoard
{
	BeeUIButton *	_button;
}

AS_SIGNAL( BUTTON_TOUCHED )
AS_SIGNAL( ACTION_ITEM1_TOUCHED )
AS_SIGNAL( ACTION_ITEM2_TOUCHED )

@end

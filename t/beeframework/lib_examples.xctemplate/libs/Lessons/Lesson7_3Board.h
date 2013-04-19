//
//  Lesson7_3Board.h
//

#import "Bee.h"

#pragma mark -

@interface Lesson7_3Board : BeeUIBoard
{
	BeeUIButton *	_button;
}

AS_SIGNAL( BUTTON_TOUCHED )
AS_SIGNAL( ALERT_ITEM1_TOUCHED )
AS_SIGNAL( ALERT_ITEM2_TOUCHED )

@end

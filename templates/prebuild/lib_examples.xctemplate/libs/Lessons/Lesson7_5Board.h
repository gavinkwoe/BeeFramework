//
//  Lesson7_5Board.h
//

#import "Bee.h"

#pragma mark -

@interface Lesson7_5Board : BeeUIBoard
{
	BeeUILabel *	_label;
	BeeUIButton *	_button;
}

AS_SIGNAL( BUTTON_TOUCHED )

@end

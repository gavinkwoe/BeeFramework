//
//  Lesson6_5Board.h
//

#import "Bee.h"

#pragma mark -

@interface Lesson6_5Board : BeeUIBoard
{
	BeeUILabel *	_label;
	BeeUIButton *	_button;
}

AS_SIGNAL( BUTTON_TOUCHED )

@end

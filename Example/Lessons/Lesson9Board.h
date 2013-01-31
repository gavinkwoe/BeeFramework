//
//  Lesson9Board.h
//

#import "Lesson9Controller.h"
#import "Bee.h"

#pragma mark -

@interface Lesson9Board : BeeUIBoard
{
	BeeUIButton *	_button1;
	BeeUIButton *	_button2;
}

AS_SIGNAL( BUTTON1_TOUCHED )
AS_SIGNAL( BUTTON2_TOUCHED )

@end

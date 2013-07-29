//
//  Lesson2Board.h
//

#import "Bee.h"

#pragma mark -

@interface Lesson3Board : BeeUIBoard
{
	BeeUIButton *	_button1;
	BeeUIButton *	_button2;
}

AS_SIGNAL( BACK );
AS_SIGNAL( ENTER );

@end

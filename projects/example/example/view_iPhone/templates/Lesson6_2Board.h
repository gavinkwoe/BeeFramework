//
//  Lesson6_2Board.h
//

#import "Bee.h"

#pragma mark -

@interface Lesson6_2Board : BeeUIBoard
{
	BeeUIActivityIndicatorView *	_indicator;
	BeeUIButton *					_button1;
	BeeUIButton *					_button2;
}

AS_SIGNAL( SHOW )
AS_SIGNAL( HIDE )

@end

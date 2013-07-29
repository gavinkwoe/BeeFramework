//
//  Lesson4Board.h
//

#import "Lesson3Board.h"
#import "Bee.h"

#pragma mark -

@interface Lesson4InnerBoard : BeeUIBoard
{
	BeeUIButton *	_button1;
	BeeUIButton *	_button2;
}

AS_SIGNAL( BACK );
AS_SIGNAL( ENTER );

@end

#pragma mark -

@interface Lesson4Board : BeeUIBoard
{
	BeeUIRouter *	_router;
}
@end

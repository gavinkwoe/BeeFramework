//
//  Lesson2Board.h
//

#import "Bee.h"
#import "LessonBaseBoard.h"

#pragma mark -

@interface Lesson2View2 : UIView
{
	BeeUIButton *	_innerView;
}

AS_SIGNAL( TEST )

@end

#pragma mark -

@interface Lesson2View1 : UIView
{
	Lesson2View2 *	_innerView;
}
@end

#pragma mark -

@interface Lesson2Board : LessonBaseBoard
{
	Lesson2View1 *	_innerView;
}
@end

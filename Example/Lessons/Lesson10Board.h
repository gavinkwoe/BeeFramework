//
//  Lesson10Model.h
//

#import "Lesson10Model.h"
#import "Bee.h"

#pragma mark -

@interface Lesson10Board : BeeUIBoard
{
	Lesson10Model *	_model;
	
	UITextView *		_textView;
	BeeUIButton *		_button1;
	BeeUIButton *		_button2;
}

AS_SIGNAL( BUTTON1_TOUCHED )
AS_SIGNAL( BUTTON2_TOUCHED )

@end

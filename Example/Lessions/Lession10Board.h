//
//  Lession10Model.h
//

#import "Lession10Model.h"
#import "Bee.h"

#pragma mark -

@interface Lession10Board : BeeUIBoard
{
	Lession10Model *	_model;
	
	UITextView *		_textView;
	BeeUIButton *		_button1;
	BeeUIButton *		_button2;
}

AS_SIGNAL( BUTTON1_TOUCHED )
AS_SIGNAL( BUTTON2_TOUCHED )

@end

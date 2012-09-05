//
//  LessionBaseBoard.h
//

#import "Bee.h"

#pragma mark -

@interface LessionBaseBoard : BeeUIBoard
{
	BeeUITextView *	_textView;
}

AS_SINGLETION( LessionBaseBoard );

- (void)log:(NSString *)msg;

@end

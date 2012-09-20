//
//  LessionBaseBoard.h
//

#import "Bee.h"

#pragma mark -

@interface LessionBaseBoard : BeeUIBoard
{
	BeeUITextView *	_textView;
}

AS_SINGLETON( LessionBaseBoard );

- (void)log:(NSString *)msg;

@end

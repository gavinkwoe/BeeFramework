//
//  Lesson13Board.h
//

#import "Lesson13Board.h"

#pragma mark - Lesson13Board

@implementation Lesson13Board

#pragma mark [B] UISignal

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		self.titleString = @"Lesson13";
		
        self.FROM_RESOURCE( @"Lesson13Board.xml" );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        self.RELAYOUT();
	}
}

- (void)handleUISignal_welcome:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Welcome"];
	}
}

- (void)handleUISignal_facebook:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Facebook"];
	}
}

- (void)handleUISignal_twitter:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Twitter"];
	}
}

- (void)handleUISignal_google:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Google"];
	}
}

- (void)handleUISignal_sign_up:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Sign up"];
	}
}

- (void)handleUISignal_sign_in:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self presentMessageTips:@"Sign in"];
	}
}

@end

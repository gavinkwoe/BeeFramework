//
//  SplashBoard.m
//  Path
//

#import "SplashBoard.h"

#pragma mark -

@implementation SplashBoard

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			[self.view showWireframe:@"Splash" tintColor:[UIColor redColor]];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{	
		}
		else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
		{	
		}
	}
}

@end

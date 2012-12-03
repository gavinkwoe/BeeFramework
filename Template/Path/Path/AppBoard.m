//
//  AppBoard.m
//  Path
//
//  Created by kwoe gavin on 12-11-14.
//  Copyright tencent 2012年. All rights reserved.
//

#import "AppBoard.h"
#import "SplashBoard.h"

#pragma mark -

@implementation AppBoard

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{	
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
		{	
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
		{	
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.FREE_DATAS] )
		{	
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
		{	
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.DID_APPEAR] )
		{	
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
		{	
			// TODO:
		}
		else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
		{	
			// TODO:
		}
	}
}

@end

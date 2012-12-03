//
//  Lession9Controller.m
//

#import "Lession9Controller.h"
#import "JSONKit.h"

#pragma mark -

@implementation Lession9Controller

DEF_MESSAGE( LOCAL )
DEF_MESSAGE( REMOTE )

- (void)load
{
	[super load];
}

- (void)unload
{	
	[super unload];
}

- (void)index:(BeeMessage *)msg
{
	// default action
}

- (void)LOCAL:(BeeMessage *)msg
{
	if ( msg.sending )
	{
		[msg output:
		 @"key1", @"value1",
		 @"key2", @"value2",
		 @"key3", @"value3",
		 nil];
		
		msg.succeed = YES;	
	}	
	else if ( msg.succeed )
	{
		// TODO
	}
	else if ( msg.failed )
	{
		if ( msg.timeout )
		{
			// TODO
		}
		else
		{
			// TODO
		}
	}
	else if ( msg.cancelled )
	{
		// TODO
	}
}

- (void)REMOTE:(BeeMessage *)msg
{
	if ( msg.sending )
	{
		NSString * url = [msg.input stringAtPath:@"/url"];
		if ( [url empty] )
		{
			msg.failed = YES;
		}
		else
		{
			[msg GET:url];
		}
	}
	else if ( msg.succeed )
	{
		NSString * httpResponse = [NSString stringWithUTF8String:[msg.response bytes]];
		[msg output:@"response", httpResponse, nil];
	}
	else if ( msg.failed )
	{		
		if ( msg.timeout )
		{
			// TODO
		}
		else
		{
			// TODO
		}
	}
	else if ( msg.cancelled )
	{
		// TODO
	}
}

@end

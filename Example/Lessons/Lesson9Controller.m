//
//  Lesson9Controller.m
//

#import "Lesson9Controller.h"
#import "JSONKit.h"

#pragma mark -

@implementation Lesson9Controller

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
		msg
		.OUTPUT( @"key1", @"value1" )
		.OUTPUT( @"key2", @"value2" )
		.OUTPUT( @"key3", @"value3" );
		
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
			msg.HTTP_GET( url );
		}
	}
	else if ( msg.succeed )
	{
		msg.OUTPUT( @"response", msg.responseString );
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

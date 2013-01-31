//
//  DribbbleController.m
//

#import "DribbbleController.h"
#import "JSONKit.h"

#pragma mark -

@implementation DribbbleController

DEF_MESSAGE( GET_SHOTS )

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

- (void)GET_SHOTS:(BeeMessage *)msg
{
	if ( msg.sending )
	{
		NSString * cate = [msg.input stringAtPath:@"/cate"];
		NSNumber * page = [msg.input numberAtPath:@"/page"];
		NSNumber * size = [msg.input numberAtPath:@"/size"];

		cate = (nil == cate) ? @"everyone" : cate;
		page = (nil == page) ? __INT(0) : page;
		size = (nil == size) ? __INT(30) : size;

		NSString * baseURL = [@"http://api.dribbble.com/shots/" stringByAppendingString:cate];
		NSString * callURL = [baseURL urlByAppendingArray:[NSArray arrayWithObjects:@"page", page, @"per_page", size, nil]];

		msg.HTTP_GET( callURL );
	}
	else if ( msg.progressed )
	{
	}
	else if ( msg.succeed )
	{
		NSDictionary * list = [msg.response objectFromJSONData];
		if ( nil == list )
		{
			[msg setLastError];
			return;				
		}

		NSNumber * total = [list numberAtPath:@"/total"];
		if ( nil == total )
		{
			[msg setLastError];
			return;
		}

		NSArray * shots = [list arrayAtPath:@"/shots"];
		if ( nil == shots )
		{
			[msg setLastError];
			return;	
		}

		[msg output:@"total", total, @"shots", shots, nil];		
	}
	else if ( msg.failed )
	{
		[msg output:@"total", __INT(0), @"shots", [NSArray array], nil];
	}
	else if ( msg.cancelled )
	{
	}	
}

@end

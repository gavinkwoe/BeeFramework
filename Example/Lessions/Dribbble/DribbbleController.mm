//
//  DribbbleController.m
//

#import "DribbbleController.h"
#import "DribbbleModel.h"
#import "JSONKit.h"

#pragma mark -

@implementation DribbbleController

DEF_SINGLETON(DribbbleController)

DEF_MESSAGE( SHOTS )
DEF_MESSAGE( SHOTS_EVERYONE )
DEF_MESSAGE( SHOTS_DEBUTS )
DEF_MESSAGE( SHOTS_POPULAR )

- (void)load
{
	[super load];

	[self map:DribbbleController.SHOTS			action:@selector(shots:)];
	[self map:DribbbleController.SHOTS_EVERYONE	action:@selector(shotsEveryone:)];
	[self map:DribbbleController.SHOTS_DEBUTS	action:@selector(shotsDebuts:)];
	[self map:DribbbleController.SHOTS_POPULAR	action:@selector(shotsPopular:)];
}

- (void)unload
{	
	[super unload];
}

- (void)index:(BeeMessage *)msg
{
	// default action
}

- (void)shotsEveryone:(BeeMessage *)msg
{
	[msg.input setObject:@"everyone" atPath:@"/cate"];
	
	[self shots:msg];
}

- (void)shotsDebuts:(BeeMessage *)msg
{
	[msg.input setObject:@"debuts" atPath:@"/cate"];
	
	[self shots:msg];
}

- (void)shotsPopular:(BeeMessage *)msg
{
	[msg.input setObject:@"popular" atPath:@"/cate"];
	
	[self shots:msg];
}

- (void)shots:(BeeMessage *)msg
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

		[msg GET:callURL];
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

		
		NSNumber * page = [msg.input numberAtPath:@"/page" otherwise:__INT(0)];
		NSString * cate = [msg.input stringAtPath:@"/cate"];

		if ( [cate is:@"everyone"] )
		{
			if ( 0 == [page intValue] )
			{
				[[DribbbleEveryoneModel sharedInstance] removeAllShots];
			}

			[[DribbbleEveryoneModel sharedInstance] setTotal:[total intValue]];
			[[DribbbleEveryoneModel sharedInstance] addShots:shots];
		}
		else if ( [cate is:@"debuts"] )
		{
			if ( 0 == [page intValue] )
			{
				[[DribbbleDebutsModel sharedInstance] removeAllShots];
			}

			[[DribbbleDebutsModel sharedInstance] setTotal:[total intValue]];
			[[DribbbleDebutsModel sharedInstance] addShots:shots];			
		}
		else if ( [cate is:@"popular"] )
		{
			if ( 0 == [page intValue] )
			{
				[[DribbblePopularModel sharedInstance] removeAllShots];
			}

			[[DribbblePopularModel sharedInstance] setTotal:[total intValue]];
			[[DribbblePopularModel sharedInstance] addShots:shots];			
		}
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

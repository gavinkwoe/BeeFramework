//    												
//    												
//    	 ______    ______    ______					
//    	/\  __ \  /\  ___\  /\  ___\			
//    	\ \  __<  \ \  __\_ \ \  __\_		
//    	 \ \_____\ \ \_____\ \ \_____\		
//    	  \/_____/  \/_____/  \/_____/			
//    												
//    												
//    												
// title:  Dribbble
// author: http://dribbble.com/api
// date:   2014-01-23 08:47:42 +0000
//

#import "dribbble.h"

#pragma mark - COMMENT

@implementation COMMENT

@synthesize body = _body;
@synthesize created_at = _created_at;
@synthesize likes_count = _likes_count;
@synthesize player = _player;
@synthesize id = _id;

- (BOOL)validate
{
	if ( nil == self.id || NO == [self.id isKindOfClass:[NSNumber class]] )
	{
		return NO;
	}

	return YES;
}

@end

#pragma mark - PLAYER

@implementation PLAYER

@synthesize avatar_url = _avatar_url;
@synthesize comments_count = _comments_count;
@synthesize comments_received_count = _comments_received_count;
@synthesize created_at = _created_at;
@synthesize drafted_by_player_id = _drafted_by_player_id;
@synthesize draftees_count = _draftees_count;
@synthesize followers_count = _followers_count;
@synthesize following_count = _following_count;
@synthesize likes_count = _likes_count;
@synthesize likes_received_count = _likes_received_count;
@synthesize location = _location;
@synthesize name = _name;
@synthesize rebounds_count = _rebounds_count;
@synthesize rebounds_received_count = _rebounds_received_count;
@synthesize shots_count = _shots_count;
@synthesize twitter_screen_name = _twitter_screen_name;
@synthesize url = _url;
@synthesize username = _username;
@synthesize id = _id;

- (BOOL)validate
{
	if ( nil == self.id || NO == [self.id isKindOfClass:[NSNumber class]] )
	{
		return NO;
	}

	return YES;
}

@end

#pragma mark - SHOT

@implementation SHOT

@synthesize comments_count = _comments_count;
@synthesize created_at = _created_at;
@synthesize height = _height;
@synthesize image_teaser_url = _image_teaser_url;
@synthesize image_url = _image_url;
@synthesize likes_count = _likes_count;
@synthesize player = _player;
@synthesize rebound_source_id = _rebound_source_id;
@synthesize rebounds_count = _rebounds_count;
@synthesize short_url = _short_url;
@synthesize title = _title;
@synthesize url = _url;
@synthesize views_count = _views_count;
@synthesize width = _width;
@synthesize id = _id;

- (BOOL)validate
{
	if ( nil == self.id || NO == [self.id isKindOfClass:[NSNumber class]] )
	{
		return NO;
	}

	return YES;
}

@end

#pragma mark - GET /players/:id


@implementation API_PLAYERS_ID

@synthesize id = _id;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.id )
		{
			self.failed = YES;
			return;
		}

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/players/:id"];
		requestURI = [requestURI stringByReplacingOccurrencesOfString:@":id" withString:self.id];

		self.HTTP_GET( requestURI );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[PLAYER class]] )
		{
			self.resp = (PLAYER *)result;
		}
		else if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [PLAYER objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - GET /players/:id/draftees

#pragma mark - RESP_PLAYERS_ID_DRAFTEES

@implementation RESP_PLAYERS_ID_DRAFTEES

@synthesize page = _page;
@synthesize pages = _pages;
@synthesize per_page = _per_page;
@synthesize players = _players;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( players, PLAYER );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PLAYERS_ID_DRAFTEES

@synthesize id = _id;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.id )
		{
			self.failed = YES;
			return;
		}

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/players/:id/draftees"];
		requestURI = [requestURI stringByReplacingOccurrencesOfString:@":id" withString:self.id];

		self.HTTP_GET( requestURI );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_PLAYERS_ID_DRAFTEES objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - GET /players/:id/followers

#pragma mark - RESP_PLAYERS_ID_FOLLOWERS

@implementation RESP_PLAYERS_ID_FOLLOWERS

@synthesize page = _page;
@synthesize pages = _pages;
@synthesize per_page = _per_page;
@synthesize players = _players;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( players, PLAYER );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PLAYERS_ID_FOLLOWERS

@synthesize id = _id;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.id )
		{
			self.failed = YES;
			return;
		}

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/players/:id/followers"];
		requestURI = [requestURI stringByReplacingOccurrencesOfString:@":id" withString:self.id];

		self.HTTP_GET( requestURI );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_PLAYERS_ID_FOLLOWERS objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - GET /players/:id/following

#pragma mark - RESP_PLAYERS_ID_FOLLOWING

@implementation RESP_PLAYERS_ID_FOLLOWING

@synthesize page = _page;
@synthesize pages = _pages;
@synthesize per_page = _per_page;
@synthesize players = _players;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( players, PLAYER );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PLAYERS_ID_FOLLOWING

@synthesize id = _id;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.id )
		{
			self.failed = YES;
			return;
		}

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/players/:id/following"];
		requestURI = [requestURI stringByReplacingOccurrencesOfString:@":id" withString:self.id];

		self.HTTP_GET( requestURI );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_PLAYERS_ID_FOLLOWING objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - GET /players/:id/shots

#pragma mark - REQ_PLAYERS_ID_SHOTS

@implementation REQ_PLAYERS_ID_SHOTS

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_PLAYERS_ID_SHOTS

@implementation RESP_PLAYERS_ID_SHOTS

@synthesize page = _page;
@synthesize pages = _pages;
@synthesize per_page = _per_page;
@synthesize shots = _shots;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( shots, SHOT );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PLAYERS_ID_SHOTS

@synthesize id = _id;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_PLAYERS_ID_SHOTS alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		if ( NULL == self.id )
		{
			self.failed = YES;
			return;
		}

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/players/:id/shots"];
		requestURI = [requestURI stringByReplacingOccurrencesOfString:@":id" withString:self.id];

		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_PLAYERS_ID_SHOTS objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - GET /players/:id/shots/following

#pragma mark - REQ_PLAYERS_ID_SHOTS_FOLLOWING

@implementation REQ_PLAYERS_ID_SHOTS_FOLLOWING

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_PLAYERS_ID_SHOTS_FOLLOWING

@implementation RESP_PLAYERS_ID_SHOTS_FOLLOWING

@synthesize page = _page;
@synthesize pages = _pages;
@synthesize per_page = _per_page;
@synthesize shots = _shots;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( shots, SHOT );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PLAYERS_ID_SHOTS_FOLLOWING

@synthesize id = _id;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_PLAYERS_ID_SHOTS_FOLLOWING alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		if ( NULL == self.id )
		{
			self.failed = YES;
			return;
		}

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/players/:id/shots/following"];
		requestURI = [requestURI stringByReplacingOccurrencesOfString:@":id" withString:self.id];

		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_PLAYERS_ID_SHOTS_FOLLOWING objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - GET /players/:id/shots/likes

#pragma mark - REQ_PLAYERS_ID_SHOTS_LIKES

@implementation REQ_PLAYERS_ID_SHOTS_LIKES

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_PLAYERS_ID_SHOTS_LIKES

@implementation RESP_PLAYERS_ID_SHOTS_LIKES

@synthesize page = _page;
@synthesize pages = _pages;
@synthesize per_page = _per_page;
@synthesize shots = _shots;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( shots, SHOT );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PLAYERS_ID_SHOTS_LIKES

@synthesize id = _id;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_PLAYERS_ID_SHOTS_LIKES alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		if ( NULL == self.id )
		{
			self.failed = YES;
			return;
		}

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/players/:id/shots/likes"];
		requestURI = [requestURI stringByReplacingOccurrencesOfString:@":id" withString:self.id];

		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_PLAYERS_ID_SHOTS_LIKES objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - GET /shots/:id


@implementation API_SHOTS_ID

@synthesize id = _id;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.id )
		{
			self.failed = YES;
			return;
		}

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/shots/:id"];
		requestURI = [requestURI stringByReplacingOccurrencesOfString:@":id" withString:self.id];

		self.HTTP_GET( requestURI );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[SHOT class]] )
		{
			self.resp = (SHOT *)result;
		}
		else if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [SHOT objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - GET /shots/:id/comments

#pragma mark - REQ_SHOTS_ID_COMMENTS

@implementation REQ_SHOTS_ID_COMMENTS

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_SHOTS_ID_COMMENTS

@implementation RESP_SHOTS_ID_COMMENTS

@synthesize comments = _comments;
@synthesize page = _page;
@synthesize pages = _pages;
@synthesize per_page = _per_page;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( comments, COMMENT );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_SHOTS_ID_COMMENTS

@synthesize id = _id;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_SHOTS_ID_COMMENTS alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		if ( NULL == self.id )
		{
			self.failed = YES;
			return;
		}

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/shots/:id/comments"];
		requestURI = [requestURI stringByReplacingOccurrencesOfString:@":id" withString:self.id];

		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_SHOTS_ID_COMMENTS objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - GET /shots/:id/rebounds

#pragma mark - RESP_SHOTS_ID_REBOUNDS

@implementation RESP_SHOTS_ID_REBOUNDS

@synthesize page = _page;
@synthesize pages = _pages;
@synthesize per_page = _per_page;
@synthesize shots = _shots;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( shots, SHOT );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_SHOTS_ID_REBOUNDS

@synthesize id = _id;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( NULL == self.id )
		{
			self.failed = YES;
			return;
		}

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/shots/:id/rebounds"];
		requestURI = [requestURI stringByReplacingOccurrencesOfString:@":id" withString:self.id];

		self.HTTP_GET( requestURI );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_SHOTS_ID_REBOUNDS objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - GET /shots/:list

#pragma mark - REQ_SHOTS_LIST

@implementation REQ_SHOTS_LIST

@synthesize page = _page;
@synthesize per_page = _per_page;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_SHOTS_LIST

@implementation RESP_SHOTS_LIST

@synthesize page = _page;
@synthesize pages = _pages;
@synthesize per_page = _per_page;
@synthesize shots = _shots;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( shots, SHOT );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_SHOTS_LIST

@synthesize list = _list;
@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_SHOTS_LIST alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		if ( NULL == self.list )
		{
			self.failed = YES;
			return;
		}

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/shots/:list"];
		requestURI = [requestURI stringByReplacingOccurrencesOfString:@":list" withString:self.list];

		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_SHOTS_LIST objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - config

@implementation ServerConfig

DEF_SINGLETON( ServerConfig )

DEF_INT( CONFIG_DEVELOPMENT,	0 )
DEF_INT( CONFIG_TEST,			1 )
DEF_INT( CONFIG_PRODUCTION,	2 )

@synthesize config = _config;
@dynamic url;
@dynamic testUrl;
@dynamic productionUrl;
@dynamic developmentUrl;

- (NSString *)url
{
	NSString * host = nil;

	if ( self.CONFIG_DEVELOPMENT == self.config )
	{
		host = self.developmentUrl;
	}
	else if ( self.CONFIG_TEST == self.config )
	{
		host = self.testUrl;
	}
	else
	{
		host = self.productionUrl;
	}

	if ( NO == [host hasPrefix:@"http://"] && NO == [host hasPrefix:@"https://"] )
	{
		host = [@"http://" stringByAppendingString:host];
	}

	return host;
}

- (NSString *)developmentUrl
{
	return @"api.dribbble.com";
}

- (NSString *)testUrl
{
	return @"api.dribbble.com";
}

- (NSString *)productionUrl
{
	return @"api.dribbble.com";
}

@end


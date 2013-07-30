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
// date:   2013-07-30 06:49:38 +0000
//

#import "Bee.h"

#pragma mark - enums

#define LIST_EVERYONE	@"everyone"
#define LIST_POPULAR	@"popular"
#define LIST_DEBUTS	@"debuts"

#pragma mark - models

@class COMMENT;
@class PLAYER;
@class SHOT;

@interface COMMENT : BeeActiveObject
@property (nonatomic, retain) NSNumber *		id;
@property (nonatomic, retain) NSString *		body;
@property (nonatomic, retain) NSString *		created_at;
@property (nonatomic, retain) NSNumber *		likes_count;
@property (nonatomic, retain) PLAYER *		player;
@end

@interface PLAYER : BeeActiveObject
@property (nonatomic, retain) NSNumber *		id;
@property (nonatomic, retain) NSString *		avatar_url;
@property (nonatomic, retain) NSNumber *		comments_count;
@property (nonatomic, retain) NSNumber *		comments_received_count;
@property (nonatomic, retain) NSString *		created_at;
@property (nonatomic, retain) NSNumber *		draftees_count;
@property (nonatomic, retain) NSNumber *		followers_count;
@property (nonatomic, retain) NSNumber *		following_count;
@property (nonatomic, retain) NSNumber *		likes_count;
@property (nonatomic, retain) NSNumber *		likes_received_count;
@property (nonatomic, retain) NSString *		location;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSNumber *		rebounds_count;
@property (nonatomic, retain) NSNumber *		rebounds_received_count;
@property (nonatomic, retain) NSNumber *		shots_count;
@property (nonatomic, retain) NSString *		twitter_screen_name;
@property (nonatomic, retain) NSString *		url;
@property (nonatomic, retain) NSString *		username;
@end

@interface SHOT : BeeActiveObject
@property (nonatomic, retain) NSNumber *		id;
@property (nonatomic, retain) NSNumber *		comments_count;
@property (nonatomic, retain) NSString *		created_at;
@property (nonatomic, retain) NSNumber *		height;
@property (nonatomic, retain) NSString *		image_teaser_url;
@property (nonatomic, retain) NSString *		image_url;
@property (nonatomic, retain) NSNumber *		likes_count;
@property (nonatomic, retain) PLAYER *		player;
@property (nonatomic, retain) NSNumber *		rebound_source_id;
@property (nonatomic, retain) NSNumber *		rebounds_count;
@property (nonatomic, retain) NSString *		short_url;
@property (nonatomic, retain) NSString *		title;
@property (nonatomic, retain) NSString *		url;
@property (nonatomic, retain) NSNumber *		views_count;
@property (nonatomic, retain) NSNumber *		width;
@end

#pragma mark - controllers

#pragma mark - GET /players/:id

@interface REQ_PLAYERS_ID : BeeActiveObject
@end


@interface API_PLAYERS_ID : BeeRoutine
@property (nonatomic, retain) NSString *	id;
@property (nonatomic, retain) REQ_PLAYERS_ID *	req;
@property (nonatomic, retain) PLAYER *	resp;
@end

#pragma mark - GET /players/:id/draftees

@interface REQ_PLAYERS_ID_DRAFTEES : BeeActiveObject
@end

@interface RESP_PLAYERS_ID_DRAFTEES : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		pages;
@property (nonatomic, retain) NSNumber *		per_page;
@property (nonatomic, retain) NSArray *		players;
@property (nonatomic, retain) NSNumber *		total;
@end

@interface API_PLAYERS_ID_DRAFTEES : BeeRoutine
@property (nonatomic, retain) NSString *	id;
@property (nonatomic, retain) REQ_PLAYERS_ID_DRAFTEES *	req;
@property (nonatomic, retain) RESP_PLAYERS_ID_DRAFTEES *	resp;
@end

#pragma mark - GET /players/:id/followers

@interface REQ_PLAYERS_ID_FOLLOWERS : BeeActiveObject
@end

@interface RESP_PLAYERS_ID_FOLLOWERS : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		pages;
@property (nonatomic, retain) NSNumber *		per_page;
@property (nonatomic, retain) NSArray *		players;
@property (nonatomic, retain) NSNumber *		total;
@end

@interface API_PLAYERS_ID_FOLLOWERS : BeeRoutine
@property (nonatomic, retain) NSString *	id;
@property (nonatomic, retain) REQ_PLAYERS_ID_FOLLOWERS *	req;
@property (nonatomic, retain) RESP_PLAYERS_ID_FOLLOWERS *	resp;
@end

#pragma mark - GET /players/:id/following

@interface REQ_PLAYERS_ID_FOLLOWING : BeeActiveObject
@end

@interface RESP_PLAYERS_ID_FOLLOWING : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		pages;
@property (nonatomic, retain) NSNumber *		per_page;
@property (nonatomic, retain) NSArray *		players;
@property (nonatomic, retain) NSNumber *		total;
@end

@interface API_PLAYERS_ID_FOLLOWING : BeeRoutine
@property (nonatomic, retain) NSString *	id;
@property (nonatomic, retain) REQ_PLAYERS_ID_FOLLOWING *	req;
@property (nonatomic, retain) RESP_PLAYERS_ID_FOLLOWING *	resp;
@end

#pragma mark - GET /players/:id/shots

@interface REQ_PLAYERS_ID_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		per_page;
@end

@interface RESP_PLAYERS_ID_SHOTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		pages;
@property (nonatomic, retain) NSNumber *		per_page;
@property (nonatomic, retain) NSArray *		shots;
@property (nonatomic, retain) NSNumber *		total;
@end

@interface API_PLAYERS_ID_SHOTS : BeeRoutine
@property (nonatomic, retain) NSString *	id;
@property (nonatomic, retain) REQ_PLAYERS_ID_SHOTS *	req;
@property (nonatomic, retain) RESP_PLAYERS_ID_SHOTS *	resp;
@end

#pragma mark - GET /players/:id/shots/following

@interface REQ_PLAYERS_ID_SHOTS_FOLLOWING : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		per_page;
@end

@interface RESP_PLAYERS_ID_SHOTS_FOLLOWING : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		pages;
@property (nonatomic, retain) NSNumber *		per_page;
@property (nonatomic, retain) NSArray *		shots;
@property (nonatomic, retain) NSNumber *		total;
@end

@interface API_PLAYERS_ID_SHOTS_FOLLOWING : BeeRoutine
@property (nonatomic, retain) NSString *	id;
@property (nonatomic, retain) REQ_PLAYERS_ID_SHOTS_FOLLOWING *	req;
@property (nonatomic, retain) RESP_PLAYERS_ID_SHOTS_FOLLOWING *	resp;
@end

#pragma mark - GET /players/:id/shots/likes

@interface REQ_PLAYERS_ID_SHOTS_LIKES : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		per_page;
@end

@interface RESP_PLAYERS_ID_SHOTS_LIKES : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		pages;
@property (nonatomic, retain) NSNumber *		per_page;
@property (nonatomic, retain) NSArray *		shots;
@property (nonatomic, retain) NSNumber *		total;
@end

@interface API_PLAYERS_ID_SHOTS_LIKES : BeeRoutine
@property (nonatomic, retain) NSString *	id;
@property (nonatomic, retain) REQ_PLAYERS_ID_SHOTS_LIKES *	req;
@property (nonatomic, retain) RESP_PLAYERS_ID_SHOTS_LIKES *	resp;
@end

#pragma mark - GET /shots/:id

@interface REQ_SHOTS_ID : BeeActiveObject
@end


@interface API_SHOTS_ID : BeeRoutine
@property (nonatomic, retain) NSString *	id;
@property (nonatomic, retain) REQ_SHOTS_ID *	req;
@property (nonatomic, retain) SHOT *	resp;
@end

#pragma mark - GET /shots/:id/comments

@interface REQ_SHOTS_ID_COMMENTS : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		per_page;
@end

@interface RESP_SHOTS_ID_COMMENTS : BeeActiveObject
@property (nonatomic, retain) NSArray *		comments;
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		pages;
@property (nonatomic, retain) NSNumber *		per_page;
@property (nonatomic, retain) NSNumber *		total;
@end

@interface API_SHOTS_ID_COMMENTS : BeeRoutine
@property (nonatomic, retain) NSString *	id;
@property (nonatomic, retain) REQ_SHOTS_ID_COMMENTS *	req;
@property (nonatomic, retain) RESP_SHOTS_ID_COMMENTS *	resp;
@end

#pragma mark - GET /shots/:id/rebounds

@interface REQ_SHOTS_ID_REBOUNDS : BeeActiveObject
@end

@interface RESP_SHOTS_ID_REBOUNDS : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		pages;
@property (nonatomic, retain) NSNumber *		per_page;
@property (nonatomic, retain) NSArray *		shots;
@property (nonatomic, retain) NSNumber *		total;
@end

@interface API_SHOTS_ID_REBOUNDS : BeeRoutine
@property (nonatomic, retain) NSString *	id;
@property (nonatomic, retain) REQ_SHOTS_ID_REBOUNDS *	req;
@property (nonatomic, retain) RESP_SHOTS_ID_REBOUNDS *	resp;
@end

#pragma mark - GET /shots/:list

@interface REQ_SHOTS_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		per_page;
@end

@interface RESP_SHOTS_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *		page;
@property (nonatomic, retain) NSNumber *		pages;
@property (nonatomic, retain) NSNumber *		per_page;
@property (nonatomic, retain) NSArray *		shots;
@property (nonatomic, retain) NSNumber *		total;
@end

@interface API_SHOTS_LIST : BeeRoutine
@property (nonatomic, retain) NSString *	list;
@property (nonatomic, retain) REQ_SHOTS_LIST *	req;
@property (nonatomic, retain) RESP_SHOTS_LIST *	resp;
@end


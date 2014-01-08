#Scaffold

{Bee} based generator that provides scaffolding for your apps.

####1. Writing a JSON schema

Here is an example for api.dribbble.com, copy it into code editor, and save it as 'dribbble.json'.

	{
	    "title"  : "Dribbble",
	    "author" : "http://dribbble.com/api",

	    "server" :
	    {
	        "development"	: "api.dribbble.com",
	        "test"			: "api.dribbble.com",
	        "production"	: "api.dribbble.com"
	    },

		"enum" :
		{
			"LIST" :
			{
				"DEBUTS"	: "debuts",
				"EVERYONE"	: "everyone",
				"POPULAR"	: "popular"
			}
		},

	    "model" :
	    {
			"PLAYER" :
			{
				"! id"						: 1,
				"name"						: "Dan Cederholm",
				"username"					: "simplebits",
				"url"						: "http://dribbble.com/simplebits",
				"avatar_url"				: "dancederholm-peek.jpg",
				"location"					: "Salem, MA",
				"twitter_screen_name"		: "simplebits",
				"drafted_by_player_id"		: null,
				"shots_count"				: 147,
				"draftees_count"			: 103,
				"followers_count"			: 2027,
				"following_count"			: 354,
				"comments_count"			: 2001,
				"comments_received_count"	: 1509,
				"likes_count"				: 7289,
				"likes_received_count"		: 2624,
				"rebounds_count"			: 15,
				"rebounds_received_count"	: 279,
				"created_at"				: "2009/07/07 21:51:22 -0400"
			},

			"SHOT" :
			{
				"! id"					: 21603,
				"title"					: "Moon",
				"url"					: "http://dribbble.com/shots/21603-Moon",
				"short_url"				: "http://drbl.in/21603",
				"image_url"				: "shot_1274474082.png",
				"image_teaser_url"		: "shot_1274474082_teaser.png",
				"width"					: 400,
				"height"				: 300,
				"views_count"			: 1693,
				"likes_count"			: 15,
				"comments_count"		: 4,
				"rebounds_count"		: 0,
				"rebound_source_id"		: 21595,
				"created_at"			: "2010/05/21 16:34:42 -0400",
				"player"				: "{PLAYER}"
			},

			"COMMENT" :
			{
				"! id"					: 54065,
	      		"body"					: "No clue.",
	      		"likes_count"			: 0,
	      		"created_at"			: "2010/05/21 16:36:22 -0400",
	      		"player"				: "{PLAYER}"
			}
		},
		
	    "controller" :
	    {
	    	// Returns the specified list of shots where :list
			// has one of the following values: debuts, everyone, popular
			"GET /shots/:list" :
			{
				"request"	:
				{
					"page"		: 1,
					"per_page"	: 10
				},
				"response"	:
				{
					"page"		: 1,
					"pages"		: 50,
					"per_page"	: 15,
					"total"		: 750,
					"shots"		: ["{SHOT}"]
				}
			},

	    	// Returns details for a shot specified by :id.
			"GET /shots/:id" :
			{
				"request" :
				{
				},
				"response" : "{SHOT}"
			}
		}
	}

####2. Build

Type the command below in terminal, and press enter.

	>> bee schema build ./dribbble.json
    												
    	 ______    ______    ______				
    	/\  __ \  /\  ___\  /\  ___\			
    	\ \  __<  \ \  __\_ \ \  __\_		
    	 \ \_____\ \ \_____\ \ \_____\		
    	  \/_____/  \/_____/  \/_____/			
    											
    	version 0.4.0 β									
    												
    	copyright (c) 2013-2014, {Bee} community	
    	http://www.bee-framework.com				
    											
	[INFO]  Loading servers ...
	[INFO]  Loading tables ...
	[INFO]  Loading models ...
	[INFO]  Loading controllers ...
	[INFO]  Loading services ...

	generated './dribbble.h'
	generated './dribbble.mm'


####3. Verify

a. Drag and drop these two files into your project.
b. Copy and paste these codes into your view controller:

		- (void)testAPI    
		{
			API_SHOTS_LIST * api = [API_SHOTS_LIST apiWithResponder:self];
			api.list = LIST_POPULAR;
			api.req.page = @1;
			api.req.per_page = @10;
			[api send];
		}

		- (void)API_SHOTS_LIST:(API_SHOTS_LIST *)api
		{
			if ( api.succeed )
			{
				if ( nil == api.resp.shots )
				{
					api.failed = YES;
					return;
				}
	
				printf( "succeed\n" );
			}
			else ( api.failed )
			{
				printf( "failed\n" );
			}
		}

c. build and run.
d. now, you can generate codes for {Bee} model and {Bee} controller without any hard coding.


####Enjoy it

QQ group:	79054681    
Email:		gavinkwoe@gmail.com    


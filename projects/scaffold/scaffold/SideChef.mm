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
// title:  SideChef
// author: http://www.sidechef.com
// date:   2015-03-03 09:49:28 +0000
//

#import "SideChef.h"

#pragma mark - AddCookBookResData

@implementation AddCookBookResData

@synthesize Currency = _Currency;
@synthesize Result = _Result;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - BuyUploadCountResData

@implementation BuyUploadCountResData

@synthesize Currency = _Currency;
@synthesize Result = _Result;
@synthesize UploadSolt = _UploadSolt;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - CommentReqData

@implementation CommentReqData

@synthesize impressions = _impressions;
@synthesize star = _star;
@synthesize strComment = _strComment;
@synthesize uID = _uID;
@synthesize urID = _urID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - CookOverResData

@implementation CookOverResData

@synthesize Currency = _Currency;
@synthesize UserRecipeId = _UserRecipeId;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - GetCommentByRecipeResData

@implementation GetCommentByRecipeResData

@synthesize Comment = _Comment;
@synthesize CommentID = _CommentID;
@synthesize CommentTime = _CommentTime;
@synthesize FName = _FName;
@synthesize PicName = _PicName;
@synthesize PicType = _PicType;
@synthesize ProfilePic = _ProfilePic;
@synthesize ReportAble = _ReportAble;
@synthesize Star = _Star;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - GetCookedResData

@implementation GetCookedResData

@synthesize Comment = _Comment;
@synthesize CommentID = _CommentID;
@synthesize CommentTime = _CommentTime;
@synthesize CookTime = _CookTime;
@synthesize CoverPic = _CoverPic;
@synthesize Followed = _Followed;
@synthesize MakerID = _MakerID;
@synthesize MakerName = _MakerName;
@synthesize PicName = _PicName;
@synthesize ProfilePic = _ProfilePic;
@synthesize RecipeBody = _RecipeBody;
@synthesize RecipeID = _RecipeID;
@synthesize RecipeName = _RecipeName;
@synthesize RecipeUrl = _RecipeUrl;
@synthesize Star = _Star;
@synthesize URID = _URID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - GetDetailResData

@implementation GetDetailResData

@synthesize Address = _Address;
@synthesize BackPic = _BackPic;
@synthesize Backed = _Backed;
@synthesize BadgeCount = _BadgeCount;
@synthesize CookedCount = _CookedCount;
@synthesize Currency = _Currency;
@synthesize FName = _FName;
@synthesize FollowCount = _FollowCount;
@synthesize Followed = _Followed;
@synthesize FollowerCount = _FollowerCount;
@synthesize ID = _ID;
@synthesize IsBrandUser = _IsBrandUser;
@synthesize PersonalSign = _PersonalSign;
@synthesize PersonalSite = _PersonalSite;
@synthesize ProfilePic = _ProfilePic;
@synthesize RecipeCount = _RecipeCount;
@synthesize Served = _Served;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - GetFavRecResData

@implementation GetFavRecResData

@synthesize CommentCount = _CommentCount;
@synthesize FavCount = _FavCount;
@synthesize RecipeID = _RecipeID;
@synthesize RecipeName = _RecipeName;
@synthesize RecipeUrl = _RecipeUrl;
@synthesize Star = _Star;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - GetFollowerResData

@implementation GetFollowerResData

@synthesize Address = _Address;
@synthesize BackPic = _BackPic;
@synthesize Backed = _Backed;
@synthesize FName = _FName;
@synthesize Featured = _Featured;
@synthesize FollowerCount = _FollowerCount;
@synthesize FollowingCount = _FollowingCount;
@synthesize ID = _ID;
@synthesize LastRecipe = _LastRecipe;
@synthesize Name = _Name;
@synthesize PersonalSite = _PersonalSite;
@synthesize ProfilePic = _ProfilePic;
@synthesize RecipeCount = _RecipeCount;
@synthesize TableCount = _TableCount;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - GetFriendByFacebookResData

@implementation GetFriendByFacebookResData

@synthesize Address = _Address;
@synthesize BackPic = _BackPic;
@synthesize Backed = _Backed;
@synthesize Featured = _Featured;
@synthesize Followed = _Followed;
@synthesize FollowerCount = _FollowerCount;
@synthesize FollowingCount = _FollowingCount;
@synthesize PersonalSite = _PersonalSite;
@synthesize ProfilePic = _ProfilePic;
@synthesize RealName = _RealName;
@synthesize RecipeCount = _RecipeCount;
@synthesize TableCount = _TableCount;
@synthesize UserId = _UserId;
@synthesize Username = _Username;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - GetInviteCodeResData

@implementation GetInviteCodeResData

@synthesize AddCurrency = _AddCurrency;
@synthesize Code = _Code;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - GetNewsfeedResData

@implementation GetNewsfeedResData

@synthesize Desc = _Desc;
@synthesize ID = _ID;
@synthesize Time = _Time;
@synthesize Type = _Type;
@synthesize UserID = _UserID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - GetRecDetailResData

@implementation GetRecDetailResData

@synthesize CommentCount = _CommentCount;
@synthesize CookedCount = _CookedCount;
@synthesize DishChar = _DishChar;
@synthesize FName = _FName;
@synthesize Faved = _Faved;
@synthesize IsNew = _IsNew;
@synthesize RecipeID = _RecipeID;
@synthesize Star = _Star;
@synthesize TypeDish = _TypeDish;
@synthesize UName = _UName;
@synthesize UploadTime = _UploadTime;
@synthesize Url = _Url;
@synthesize UserID = _UserID;
@synthesize Version = _Version;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - GetResultPicResData

@implementation GetResultPicResData

@synthesize Liked = _Liked;
@synthesize PicID = _PicID;
@synthesize PicName = _PicName;
@synthesize ProfilePic = _ProfilePic;
@synthesize ReportAble = _ReportAble;
@synthesize Time = _Time;
@synthesize UserID = _UserID;
@synthesize UserName = _UserName;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - InputCodeResData

@implementation InputCodeResData

@synthesize AddCurrency = _AddCurrency;
@synthesize AddUploadCount = _AddUploadCount;
@synthesize Currency = _Currency;
@synthesize IsSpecial = _IsSpecial;
@synthesize Result = _Result;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - IpadHomeTab

@implementation IpadHomeTab

@synthesize DisplayName = _DisplayName;
@synthesize ID = _ID;
@synthesize TagName = _TagName;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - LoginSuccessResData

@implementation LoginSuccessResData

@synthesize Address = _Address;
@synthesize Currency = _Currency;
@synthesize Email = _Email;
@synthesize FName = _FName;
@synthesize ProfilePic = _ProfilePic;
@synthesize UserID = _UserID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RecipeListResData

@implementation RecipeListResData

@synthesize AlertLanguage = _AlertLanguage;
@synthesize BuyUrl = _BuyUrl;
@synthesize CommentCount = _CommentCount;
@synthesize CookAble = _CookAble;
@synthesize Cooked = _Cooked;
@synthesize CookedCount = _CookedCount;
@synthesize CoverPic = _CoverPic;
@synthesize FName = _FName;
@synthesize Faved = _Faved;
@synthesize Featured = _Featured;
@synthesize ImpressionId = _ImpressionId;
@synthesize IsNew = _IsNew;
@synthesize LikedCount = _LikedCount;
@synthesize PersonalSite = _PersonalSite;
@synthesize ProfilePic = _ProfilePic;
@synthesize RecipeBody = _RecipeBody;
@synthesize RecipeCount = _RecipeCount;
@synthesize RecipeID = _RecipeID;
@synthesize RecipeName = _RecipeName;
@synthesize Reviewed = _Reviewed;
@synthesize Star = _Star;
@synthesize TotalTime = _TotalTime;
@synthesize UName = _UName;
@synthesize UploadTime = _UploadTime;
@synthesize Url = _Url;
@synthesize UserID = _UserID;
@synthesize Version = _Version;
@synthesize VideoUrl = _VideoUrl;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - TabVersion

@implementation TabVersion

@synthesize FileName = _FileName;
@synthesize TabName = _TabName;
@synthesize Version = _Version;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - UploadResultPicResData

@implementation UploadResultPicResData

@synthesize Currency = _Currency;
@synthesize IsFirst = _IsFirst;
@synthesize PicName = _PicName;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - UserPushGroup

@implementation UserPushGroup

@synthesize DoActivity = _DoActivity;
@synthesize EarnBadge = _EarnBadge;
@synthesize NewFollower = _NewFollower;
@synthesize OperateRecipe = _OperateRecipe;
@synthesize RecipeUpdate = _RecipeUpdate;
@synthesize SideChefUpdate = _SideChefUpdate;
@synthesize Social = _Social;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - UserRecipe

@implementation UserRecipe

@synthesize RecipeID = _RecipeID;
@synthesize UserID = _UserID;
@synthesize UserRecipeID = _UserRecipeID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - GET /DataSource/GetAllTab

#pragma mark - REQ_DATASOURCE_GETALLTAB

@implementation REQ_DATASOURCE_GETALLTAB

@synthesize platform = _platform;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_DATASOURCE_GETALLTAB

@implementation RESP_DATASOURCE_GETALLTAB

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, TabVersion );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_DATASOURCE_GETALLTAB

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_DATASOURCE_GETALLTAB alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/DataSource/GetAllTab"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_DATASOURCE_GETALLTAB objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/AddCookBook

#pragma mark - REQ_INTERFACEIPHONE_ADDCOOKBOOK

@implementation REQ_INTERFACEIPHONE_ADDCOOKBOOK

@synthesize platform = _platform;
@synthesize recipeID = _recipeID;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_ADDCOOKBOOK

@implementation RESP_INTERFACEIPHONE_ADDCOOKBOOK

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_ADDCOOKBOOK

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_ADDCOOKBOOK alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/AddCookBook"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_ADDCOOKBOOK objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/Answer

#pragma mark - REQ_INTERFACEIPHONE_ANSWER

@implementation REQ_INTERFACEIPHONE_ANSWER

@synthesize content = _content;
@synthesize platform = _platform;
@synthesize questionID = _questionID;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_ANSWER

@implementation RESP_INTERFACEIPHONE_ANSWER

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_ANSWER

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_ANSWER alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/Answer"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_ANSWER objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/Ask

#pragma mark - REQ_INTERFACEIPHONE_ASK

@implementation REQ_INTERFACEIPHONE_ASK

@synthesize content = _content;
@synthesize platform = _platform;
@synthesize recipeID = _recipeID;
@synthesize stepGuid = _stepGuid;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_ASK

@implementation RESP_INTERFACEIPHONE_ASK

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_ASK

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_ASK alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/Ask"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_ASK objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/BuyUploadCount

#pragma mark - REQ_INTERFACEIPHONE_BUYUPLOADCOUNT

@implementation REQ_INTERFACEIPHONE_BUYUPLOADCOUNT

@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_BUYUPLOADCOUNT

@implementation RESP_INTERFACEIPHONE_BUYUPLOADCOUNT

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_BUYUPLOADCOUNT

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_BUYUPLOADCOUNT alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/BuyUploadCount"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_BUYUPLOADCOUNT objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/CancelFavRec

#pragma mark - REQ_INTERFACEIPHONE_CANCELFAVREC

@implementation REQ_INTERFACEIPHONE_CANCELFAVREC

@synthesize platform = _platform;
@synthesize recipeID = _recipeID;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_CANCELFAVREC

@implementation RESP_INTERFACEIPHONE_CANCELFAVREC

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_CANCELFAVREC

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_CANCELFAVREC alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/CancelFavRec"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_CANCELFAVREC objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/CancelFollow

#pragma mark - REQ_INTERFACEIPHONE_CANCELFOLLOW

@implementation REQ_INTERFACEIPHONE_CANCELFOLLOW

@synthesize followUserID = _followUserID;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_CANCELFOLLOW

@implementation RESP_INTERFACEIPHONE_CANCELFOLLOW

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_CANCELFOLLOW

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_CANCELFOLLOW alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/CancelFollow"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_CANCELFOLLOW objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/CancelLikeResultPic

#pragma mark - REQ_INTERFACEIPHONE_CANCELLIKERESULTPIC

@implementation REQ_INTERFACEIPHONE_CANCELLIKERESULTPIC

@synthesize picID = _picID;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_CANCELLIKERESULTPIC

@implementation RESP_INTERFACEIPHONE_CANCELLIKERESULTPIC

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_CANCELLIKERESULTPIC

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_CANCELLIKERESULTPIC alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/CancelLikeResultPic"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_CANCELLIKERESULTPIC objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/ChangePwd

#pragma mark - REQ_INTERFACEIPHONE_CHANGEPWD

@implementation REQ_INTERFACEIPHONE_CHANGEPWD

@synthesize currentPwd = _currentPwd;
@synthesize encryptMethod = _encryptMethod;
@synthesize newPwd = _newPwd;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_CHANGEPWD

@implementation RESP_INTERFACEIPHONE_CHANGEPWD

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_CHANGEPWD

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_CHANGEPWD alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/ChangePwd"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_CHANGEPWD objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/CheckFollowed

#pragma mark - REQ_INTERFACEIPHONE_CHECKFOLLOWED

@implementation REQ_INTERFACEIPHONE_CHECKFOLLOWED

@synthesize platform = _platform;
@synthesize userID = _userID;
@synthesize userID2 = _userID2;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_CHECKFOLLOWED

@implementation RESP_INTERFACEIPHONE_CHECKFOLLOWED

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_CHECKFOLLOWED

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_CHECKFOLLOWED alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/CheckFollowed"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_CHECKFOLLOWED objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/ClearBadgeCount

#pragma mark - REQ_INTERFACEIPHONE_CLEARBADGECOUNT

@implementation REQ_INTERFACEIPHONE_CLEARBADGECOUNT

@synthesize deviceToken = _deviceToken;
@synthesize platform = _platform;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_CLEARBADGECOUNT

@implementation RESP_INTERFACEIPHONE_CLEARBADGECOUNT

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_CLEARBADGECOUNT

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_CLEARBADGECOUNT alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/ClearBadgeCount"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_CLEARBADGECOUNT objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/Comment

#pragma mark - REQ_INTERFACEIPHONE_COMMENT

@implementation REQ_INTERFACEIPHONE_COMMENT

@synthesize comment = _comment;
@synthesize impressions = _impressions;
@synthesize platform = _platform;
@synthesize recipeID = _recipeID;
@synthesize star = _star;
@synthesize userID = _userID;
@synthesize userRecipeID = _userRecipeID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_COMMENT

@implementation RESP_INTERFACEIPHONE_COMMENT

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_COMMENT

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_COMMENT alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/Comment"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_COMMENT objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/CookOver

#pragma mark - REQ_INTERFACEIPHONE_COOKOVER

@implementation REQ_INTERFACEIPHONE_COOKOVER

@synthesize cookTime = _cookTime;
@synthesize platform = _platform;
@synthesize recipeId = _recipeId;
@synthesize userId = _userId;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_COOKOVER

@implementation RESP_INTERFACEIPHONE_COOKOVER

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_COOKOVER

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_COOKOVER alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/CookOver"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_COOKOVER objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/DeleteCooked

#pragma mark - REQ_INTERFACEIPHONE_DELETECOOKED

@implementation REQ_INTERFACEIPHONE_DELETECOOKED

@synthesize platform = _platform;
@synthesize userRecipeID = _userRecipeID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_DELETECOOKED

@implementation RESP_INTERFACEIPHONE_DELETECOOKED

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_DELETECOOKED

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_DELETECOOKED alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/DeleteCooked"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_DELETECOOKED objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/DeleteNewsfeed

#pragma mark - REQ_INTERFACEIPHONE_DELETENEWSFEED

@implementation REQ_INTERFACEIPHONE_DELETENEWSFEED

@synthesize newsfeedID = _newsfeedID;
@synthesize platform = _platform;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_DELETENEWSFEED

@implementation RESP_INTERFACEIPHONE_DELETENEWSFEED

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_DELETENEWSFEED

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_DELETENEWSFEED alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/DeleteNewsfeed"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_DELETENEWSFEED objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/EvaluateOurApp

#pragma mark - REQ_INTERFACEIPHONE_EVALUATEOURAPP

@implementation REQ_INTERFACEIPHONE_EVALUATEOURAPP

@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_EVALUATEOURAPP

@implementation RESP_INTERFACEIPHONE_EVALUATEOURAPP

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_EVALUATEOURAPP

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_EVALUATEOURAPP alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/EvaluateOurApp"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_EVALUATEOURAPP objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/ExistsNewBadge

#pragma mark - REQ_INTERFACEIPHONE_EXISTSNEWBADGE

@implementation REQ_INTERFACEIPHONE_EXISTSNEWBADGE

@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_EXISTSNEWBADGE

@implementation RESP_INTERFACEIPHONE_EXISTSNEWBADGE

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_EXISTSNEWBADGE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_EXISTSNEWBADGE alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/ExistsNewBadge"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_EXISTSNEWBADGE objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/FavRec

#pragma mark - REQ_INTERFACEIPHONE_FAVREC

@implementation REQ_INTERFACEIPHONE_FAVREC

@synthesize platform = _platform;
@synthesize recipeID = _recipeID;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_FAVREC

@implementation RESP_INTERFACEIPHONE_FAVREC

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_FAVREC

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_FAVREC alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/FavRec"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_FAVREC objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/Follow

#pragma mark - REQ_INTERFACEIPHONE_FOLLOW

@implementation REQ_INTERFACEIPHONE_FOLLOW

@synthesize followUserID = _followUserID;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_FOLLOW

@implementation RESP_INTERFACEIPHONE_FOLLOW

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_FOLLOW

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_FOLLOW alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/Follow"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_FOLLOW objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/FollowAll

#pragma mark - REQ_INTERFACEIPHONE_FOLLOWALL

@implementation REQ_INTERFACEIPHONE_FOLLOWALL

@synthesize followUserList = _followUserList;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_FOLLOWALL

@implementation RESP_INTERFACEIPHONE_FOLLOWALL

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_FOLLOWALL

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_FOLLOWALL alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/FollowAll"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_FOLLOWALL objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetBadge

#pragma mark - REQ_INTERFACEIPHONE_GETBADGE

@implementation REQ_INTERFACEIPHONE_GETBADGE

@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETBADGE

@implementation RESP_INTERFACEIPHONE_GETBADGE

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETBADGE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETBADGE alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetBadge"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETBADGE objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetCommentByRecipe

#pragma mark - REQ_INTERFACEIPHONE_GETCOMMENTBYRECIPE

@implementation REQ_INTERFACEIPHONE_GETCOMMENTBYRECIPE

@synthesize platform = _platform;
@synthesize recipeID = _recipeID;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETCOMMENTBYRECIPE

@implementation RESP_INTERFACEIPHONE_GETCOMMENTBYRECIPE

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, GetCommentByRecipeResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETCOMMENTBYRECIPE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETCOMMENTBYRECIPE alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetCommentByRecipe"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETCOMMENTBYRECIPE objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetCooked

#pragma mark - REQ_INTERFACEIPHONE_GETCOOKED

@implementation REQ_INTERFACEIPHONE_GETCOOKED

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETCOOKED

@implementation RESP_INTERFACEIPHONE_GETCOOKED

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, GetCookedResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETCOOKED

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETCOOKED alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetCooked"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETCOOKED objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetDetail

#pragma mark - REQ_INTERFACEIPHONE_GETDETAIL

@implementation REQ_INTERFACEIPHONE_GETDETAIL

@synthesize platform = _platform;
@synthesize userID = _userID;
@synthesize userID2 = _userID2;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETDETAIL

@implementation RESP_INTERFACEIPHONE_GETDETAIL

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETDETAIL

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETDETAIL alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetDetail"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETDETAIL objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetFavRec

#pragma mark - REQ_INTERFACEIPHONE_GETFAVREC

@implementation REQ_INTERFACEIPHONE_GETFAVREC

@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETFAVREC

@implementation RESP_INTERFACEIPHONE_GETFAVREC

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, GetFavRecResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETFAVREC

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETFAVREC alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetFavRec"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETFAVREC objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetFeaturedChef

#pragma mark - REQ_INTERFACEIPHONE_GETFEATUREDCHEF

@implementation REQ_INTERFACEIPHONE_GETFEATUREDCHEF

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize platform = _platform;
@synthesize userId = _userId;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETFEATUREDCHEF

@implementation RESP_INTERFACEIPHONE_GETFEATUREDCHEF

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, GetFollowerResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETFEATUREDCHEF

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETFEATUREDCHEF alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetFeaturedChef"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETFEATUREDCHEF objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetFollower

#pragma mark - REQ_INTERFACEIPHONE_GETFOLLOWER

@implementation REQ_INTERFACEIPHONE_GETFOLLOWER

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETFOLLOWER

@implementation RESP_INTERFACEIPHONE_GETFOLLOWER

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, GetFollowerResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETFOLLOWER

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETFOLLOWER alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetFollower"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETFOLLOWER objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetFollowing

#pragma mark - REQ_INTERFACEIPHONE_GETFOLLOWING

@implementation REQ_INTERFACEIPHONE_GETFOLLOWING

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETFOLLOWING

@implementation RESP_INTERFACEIPHONE_GETFOLLOWING

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, GetFollowerResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETFOLLOWING

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETFOLLOWING alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetFollowing"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETFOLLOWING objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetFriendByFacebook

#pragma mark - REQ_INTERFACEIPHONE_GETFRIENDBYFACEBOOK

@implementation REQ_INTERFACEIPHONE_GETFRIENDBYFACEBOOK

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize platform = _platform;
@synthesize type = _type;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETFRIENDBYFACEBOOK

@implementation RESP_INTERFACEIPHONE_GETFRIENDBYFACEBOOK

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, GetFriendByFacebookResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETFRIENDBYFACEBOOK

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETFRIENDBYFACEBOOK alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetFriendByFacebook"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETFRIENDBYFACEBOOK objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetGuideResultPic

#pragma mark - REQ_INTERFACEIPHONE_GETGUIDERESULTPIC

@implementation REQ_INTERFACEIPHONE_GETGUIDERESULTPIC

@synthesize platform = _platform;
@synthesize userID = _userID;
@synthesize userID2 = _userID2;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETGUIDERESULTPIC

@implementation RESP_INTERFACEIPHONE_GETGUIDERESULTPIC

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETGUIDERESULTPIC

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETGUIDERESULTPIC alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetGuideResultPic"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETGUIDERESULTPIC objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetHomeTab

#pragma mark - RESP_INTERFACEIPHONE_GETHOMETAB

@implementation RESP_INTERFACEIPHONE_GETHOMETAB

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, IpadHomeTab );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETHOMETAB

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
		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetHomeTab"];
		self.HTTP_GET( requestURI );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETHOMETAB objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetInviteCode

#pragma mark - REQ_INTERFACEIPHONE_GETINVITECODE

@implementation REQ_INTERFACEIPHONE_GETINVITECODE

@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETINVITECODE

@implementation RESP_INTERFACEIPHONE_GETINVITECODE

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETINVITECODE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETINVITECODE alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetInviteCode"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETINVITECODE objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetNewsfeed

#pragma mark - REQ_INTERFACEIPHONE_GETNEWSFEED

@implementation REQ_INTERFACEIPHONE_GETNEWSFEED

@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETNEWSFEED

@implementation RESP_INTERFACEIPHONE_GETNEWSFEED

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, GetNewsfeedResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETNEWSFEED

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETNEWSFEED alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetNewsfeed"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETNEWSFEED objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetQuestionByStep

#pragma mark - REQ_INTERFACEIPHONE_GETQUESTIONBYSTEP

@implementation REQ_INTERFACEIPHONE_GETQUESTIONBYSTEP

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize platform = _platform;
@synthesize stepGuid = _stepGuid;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETQUESTIONBYSTEP

@implementation RESP_INTERFACEIPHONE_GETQUESTIONBYSTEP

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETQUESTIONBYSTEP

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETQUESTIONBYSTEP alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetQuestionByStep"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETQUESTIONBYSTEP objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetRecDetail

#pragma mark - REQ_INTERFACEIPHONE_GETRECDETAIL

@implementation REQ_INTERFACEIPHONE_GETRECDETAIL

@synthesize platform = _platform;
@synthesize recipeID = _recipeID;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETRECDETAIL

@implementation RESP_INTERFACEIPHONE_GETRECDETAIL

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETRECDETAIL

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETRECDETAIL alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetRecDetail"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETRECDETAIL objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetRecipeByUser

#pragma mark - REQ_INTERFACEIPHONE_GETRECIPEBYUSER

@implementation REQ_INTERFACEIPHONE_GETRECIPEBYUSER

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize platform = _platform;
@synthesize userID = _userID;
@synthesize userID2 = _userID2;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETRECIPEBYUSER

@implementation RESP_INTERFACEIPHONE_GETRECIPEBYUSER

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, RecipeListResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETRECIPEBYUSER

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETRECIPEBYUSER alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetRecipeByUser"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETRECIPEBYUSER objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetRecipeDetail

#pragma mark - REQ_INTERFACEIPHONE_GETRECIPEDETAIL

@implementation REQ_INTERFACEIPHONE_GETRECIPEDETAIL

@synthesize platform = _platform;
@synthesize recipeID = _recipeID;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETRECIPEDETAIL

@implementation RESP_INTERFACEIPHONE_GETRECIPEDETAIL

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETRECIPEDETAIL

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETRECIPEDETAIL alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetRecipeDetail"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETRECIPEDETAIL objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetRecipeUrl

#pragma mark - REQ_INTERFACEIPHONE_GETRECIPEURL

@implementation REQ_INTERFACEIPHONE_GETRECIPEURL

@synthesize platform = _platform;
@synthesize recipeID = _recipeID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETRECIPEURL

@implementation RESP_INTERFACEIPHONE_GETRECIPEURL

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETRECIPEURL

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETRECIPEURL alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetRecipeUrl"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETRECIPEURL objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetResultPic

#pragma mark - REQ_INTERFACEIPHONE_GETRESULTPIC

@implementation REQ_INTERFACEIPHONE_GETRESULTPIC

@synthesize platform = _platform;
@synthesize recipeID = _recipeID;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETRESULTPIC

@implementation RESP_INTERFACEIPHONE_GETRESULTPIC

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, GetResultPicResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETRESULTPIC

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETRESULTPIC alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetResultPic"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETRESULTPIC objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GetUserPushGroup

#pragma mark - REQ_INTERFACEIPHONE_GETUSERPUSHGROUP

@implementation REQ_INTERFACEIPHONE_GETUSERPUSHGROUP

@synthesize platform = _platform;
@synthesize userId = _userId;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GETUSERPUSHGROUP

@implementation RESP_INTERFACEIPHONE_GETUSERPUSHGROUP

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GETUSERPUSHGROUP

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GETUSERPUSHGROUP alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GetUserPushGroup"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GETUSERPUSHGROUP objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/GewNewsfeedDetail

#pragma mark - REQ_INTERFACEIPHONE_GEWNEWSFEEDDETAIL

@implementation REQ_INTERFACEIPHONE_GEWNEWSFEEDDETAIL

@synthesize newsfeedID = _newsfeedID;
@synthesize platform = _platform;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_GEWNEWSFEEDDETAIL

@implementation RESP_INTERFACEIPHONE_GEWNEWSFEEDDETAIL

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_GEWNEWSFEEDDETAIL

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_GEWNEWSFEEDDETAIL alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/GewNewsfeedDetail"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_GEWNEWSFEEDDETAIL objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/InputCode

#pragma mark - REQ_INTERFACEIPHONE_INPUTCODE

@implementation REQ_INTERFACEIPHONE_INPUTCODE

@synthesize code = _code;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_INPUTCODE

@implementation RESP_INTERFACEIPHONE_INPUTCODE

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_INPUTCODE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_INPUTCODE alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/InputCode"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_INPUTCODE objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/LikeResultPic

#pragma mark - REQ_INTERFACEIPHONE_LIKERESULTPIC

@implementation REQ_INTERFACEIPHONE_LIKERESULTPIC

@synthesize picID = _picID;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_LIKERESULTPIC

@implementation RESP_INTERFACEIPHONE_LIKERESULTPIC

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_LIKERESULTPIC

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_LIKERESULTPIC alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/LikeResultPic"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_LIKERESULTPIC objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/LoginFacebook

#pragma mark - REQ_INTERFACEIPHONE_LOGINFACEBOOK

@implementation REQ_INTERFACEIPHONE_LOGINFACEBOOK

@synthesize deviceToken = _deviceToken;
@synthesize facebookID = _facebookID;
@synthesize platform = _platform;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_LOGINFACEBOOK

@implementation RESP_INTERFACEIPHONE_LOGINFACEBOOK

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_LOGINFACEBOOK

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_LOGINFACEBOOK alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/LoginFacebook"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_LOGINFACEBOOK objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/LoginQQ

#pragma mark - REQ_INTERFACEIPHONE_LOGINQQ

@implementation REQ_INTERFACEIPHONE_LOGINQQ

@synthesize deviceToken = _deviceToken;
@synthesize email = _email;
@synthesize platform = _platform;
@synthesize qqOpenId = _qqOpenId;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_LOGINQQ

@implementation RESP_INTERFACEIPHONE_LOGINQQ

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_LOGINQQ

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_LOGINQQ alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/LoginQQ"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_LOGINQQ objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/LoginSinaWeibo

#pragma mark - REQ_INTERFACEIPHONE_LOGINSINAWEIBO

@implementation REQ_INTERFACEIPHONE_LOGINSINAWEIBO

@synthesize deviceToken = _deviceToken;
@synthesize email = _email;
@synthesize platform = _platform;
@synthesize sinaWeiboId = _sinaWeiboId;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_LOGINSINAWEIBO

@implementation RESP_INTERFACEIPHONE_LOGINSINAWEIBO

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_LOGINSINAWEIBO

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_LOGINSINAWEIBO alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/LoginSinaWeibo"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_LOGINSINAWEIBO objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/Logout

#pragma mark - REQ_INTERFACEIPHONE_LOGOUT

@implementation REQ_INTERFACEIPHONE_LOGOUT

@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_LOGOUT

@implementation RESP_INTERFACEIPHONE_LOGOUT

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_LOGOUT

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_LOGOUT alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/Logout"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_LOGOUT objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/RecipeList

#pragma mark - REQ_INTERFACEIPHONE_RECIPELIST

@implementation REQ_INTERFACEIPHONE_RECIPELIST

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_RECIPELIST

@implementation RESP_INTERFACEIPHONE_RECIPELIST

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, RecipeListResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_RECIPELIST

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_RECIPELIST alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/RecipeList"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_RECIPELIST objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/RecipeListTab

#pragma mark - REQ_INTERFACEIPHONE_RECIPELISTTAB

@implementation REQ_INTERFACEIPHONE_RECIPELISTTAB

@synthesize keyword = _keyword;
@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_RECIPELISTTAB

@implementation RESP_INTERFACEIPHONE_RECIPELISTTAB

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, RecipeListResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_RECIPELISTTAB

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_RECIPELISTTAB alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/RecipeListTab"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_RECIPELISTTAB objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/RegFacebook

#pragma mark - REQ_INTERFACEIPHONE_REGFACEBOOK

@implementation REQ_INTERFACEIPHONE_REGFACEBOOK

@synthesize deviceToken = _deviceToken;
@synthesize facebookID = _facebookID;
@synthesize platform = _platform;
@synthesize realName = _realName;
@synthesize userName = _userName;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_REGFACEBOOK

@implementation RESP_INTERFACEIPHONE_REGFACEBOOK

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_REGFACEBOOK

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_REGFACEBOOK alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/RegFacebook"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_REGFACEBOOK objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/RegQQ

#pragma mark - REQ_INTERFACEIPHONE_REGQQ

@implementation REQ_INTERFACEIPHONE_REGQQ

@synthesize deviceToken = _deviceToken;
@synthesize email = _email;
@synthesize openId = _openId;
@synthesize platform = _platform;
@synthesize realName = _realName;
@synthesize userName = _userName;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_REGQQ

@implementation RESP_INTERFACEIPHONE_REGQQ

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_REGQQ

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_REGQQ alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/RegQQ"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_REGQQ objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/RegSinaWeibo

#pragma mark - REQ_INTERFACEIPHONE_REGSINAWEIBO

@implementation REQ_INTERFACEIPHONE_REGSINAWEIBO

@synthesize deviceToken = _deviceToken;
@synthesize email = _email;
@synthesize platform = _platform;
@synthesize realName = _realName;
@synthesize sinaWeiboId = _sinaWeiboId;
@synthesize userName = _userName;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_REGSINAWEIBO

@implementation RESP_INTERFACEIPHONE_REGSINAWEIBO

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_REGSINAWEIBO

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_REGSINAWEIBO alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/RegSinaWeibo"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_REGSINAWEIBO objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/RemoveFromCookBook

#pragma mark - REQ_INTERFACEIPHONE_REMOVEFROMCOOKBOOK

@implementation REQ_INTERFACEIPHONE_REMOVEFROMCOOKBOOK

@synthesize platform = _platform;
@synthesize recipeID = _recipeID;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_REMOVEFROMCOOKBOOK

@implementation RESP_INTERFACEIPHONE_REMOVEFROMCOOKBOOK

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_REMOVEFROMCOOKBOOK

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_REMOVEFROMCOOKBOOK alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/RemoveFromCookBook"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_REMOVEFROMCOOKBOOK objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/ReportComment

#pragma mark - REQ_INTERFACEIPHONE_REPORTCOMMENT

@implementation REQ_INTERFACEIPHONE_REPORTCOMMENT

@synthesize cID = _cID;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_REPORTCOMMENT

@implementation RESP_INTERFACEIPHONE_REPORTCOMMENT

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_REPORTCOMMENT

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_REPORTCOMMENT alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/ReportComment"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_REPORTCOMMENT objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/ReportResultPic

#pragma mark - REQ_INTERFACEIPHONE_REPORTRESULTPIC

@implementation REQ_INTERFACEIPHONE_REPORTRESULTPIC

@synthesize picID = _picID;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_REPORTRESULTPIC

@implementation RESP_INTERFACEIPHONE_REPORTRESULTPIC

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_REPORTRESULTPIC

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_REPORTRESULTPIC alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/ReportResultPic"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_REPORTRESULTPIC objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/SaveFacebookFriendForUser

#pragma mark - REQ_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER

@implementation REQ_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER

@synthesize facebookIdList = _facebookIdList;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER

@implementation RESP_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/SaveFacebookFriendForUser"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/SearchRecipe

#pragma mark - REQ_INTERFACEIPHONE_SEARCHRECIPE

@implementation REQ_INTERFACEIPHONE_SEARCHRECIPE

@synthesize filter = _filter;
@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_SEARCHRECIPE

@implementation RESP_INTERFACEIPHONE_SEARCHRECIPE

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, RecipeListResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_SEARCHRECIPE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_SEARCHRECIPE alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/SearchRecipe"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_SEARCHRECIPE objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/SearchUser

#pragma mark - REQ_INTERFACEIPHONE_SEARCHUSER

@implementation REQ_INTERFACEIPHONE_SEARCHUSER

@synthesize keyword = _keyword;
@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize platform = _platform;
@synthesize tag = _tag;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_SEARCHUSER

@implementation RESP_INTERFACEIPHONE_SEARCHUSER

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

CONVERT_PROPERTY_CLASS( data, GetFollowerResData );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_SEARCHUSER

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_SEARCHUSER alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/SearchUser"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_SEARCHUSER objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/Share

#pragma mark - REQ_INTERFACEIPHONE_SHARE

@implementation REQ_INTERFACEIPHONE_SHARE

@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_SHARE

@implementation RESP_INTERFACEIPHONE_SHARE

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_SHARE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_SHARE alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/Share"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_SHARE objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - GET /InterfaceIPhone/TurnOnOffPush

#pragma mark - REQ_INTERFACEIPHONE_TURNONOFFPUSH

@implementation REQ_INTERFACEIPHONE_TURNONOFFPUSH

@synthesize on = _on;
@synthesize platform = _platform;
@synthesize pushGroup = _pushGroup;
@synthesize userId = _userId;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_TURNONOFFPUSH

@implementation RESP_INTERFACEIPHONE_TURNONOFFPUSH

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_TURNONOFFPUSH

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_TURNONOFFPUSH alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/TurnOnOffPush"];
		self.HTTP_GET( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_TURNONOFFPUSH objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/Update

#pragma mark - REQ_INTERFACEIPHONE_UPDATE

@implementation REQ_INTERFACEIPHONE_UPDATE

@synthesize address = _address;
@synthesize fname = _fname;
@synthesize operate = _operate;
@synthesize personalSign = _personalSign;
@synthesize personalSite = _personalSite;
@synthesize platform = _platform;
@synthesize userID = _userID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_UPDATE

@implementation RESP_INTERFACEIPHONE_UPDATE

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_UPDATE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_UPDATE alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/Update"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_UPDATE objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/UploadResultPic

#pragma mark - REQ_INTERFACEIPHONE_UPLOADRESULTPIC

@implementation REQ_INTERFACEIPHONE_UPLOADRESULTPIC

@synthesize imageData = _imageData;
@synthesize platform = _platform;
@synthesize userRecipeID = _userRecipeID;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_UPLOADRESULTPIC

@implementation RESP_INTERFACEIPHONE_UPLOADRESULTPIC

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_UPLOADRESULTPIC

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_UPLOADRESULTPIC alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/UploadResultPic"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_UPLOADRESULTPIC objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/UserLogin

#pragma mark - REQ_INTERFACEIPHONE_USERLOGIN

@implementation REQ_INTERFACEIPHONE_USERLOGIN

@synthesize device_token = _device_token;
@synthesize encryptMethod = _encryptMethod;
@synthesize platform = _platform;
@synthesize uEmail = _uEmail;
@synthesize uPwd = _uPwd;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_USERLOGIN

@implementation RESP_INTERFACEIPHONE_USERLOGIN

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_USERLOGIN

@synthesize req = _req;
@synthesize resp = _resp;
@synthesize fileList = _fileList;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_USERLOGIN alloc] init] autorelease];
		self.resp = nil;
		self.fileList = [[[FILELIST_INTERFACEIPHONE_USERLOGIN alloc] init] autorelease];
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	self.fileList = nil;
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/UserLogin"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] ).FILE_JPG("pic1", self.fileList.pic1).FILE("pic3", self.fileList.pic3).FILE_PNG("pic2", self.fileList.pic2);
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_USERLOGIN objectFromDictionary:(NSDictionary *)result];
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

#pragma mark - POST /InterfaceIPhone/UserReg

#pragma mark - REQ_INTERFACEIPHONE_USERREG

@implementation REQ_INTERFACEIPHONE_USERREG

@synthesize encryptMethod = _encryptMethod;
@synthesize platform = _platform;
@synthesize uEmail = _uEmail;
@synthesize uName = _uName;
@synthesize uPwd = _uPwd;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_INTERFACEIPHONE_USERREG

@implementation RESP_INTERFACEIPHONE_USERREG

@synthesize data = _data;
@synthesize message = _message;
@synthesize status = _status;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_INTERFACEIPHONE_USERREG

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_INTERFACEIPHONE_USERREG alloc] init] autorelease];
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

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/InterfaceIPhone/UserReg"];
		self.HTTP_POST( requestURI ).PARAM( [self.req objectToDictionary] );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_INTERFACEIPHONE_USERREG objectFromDictionary:(NSDictionary *)result];
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
	return @"http://54.65.55.75:8080";
}

- (NSString *)testUrl
{
	return @"http://54.65.55.75:8080";
}

- (NSString *)productionUrl
{
	return @"http://interface.sidechef.com";
}

@end


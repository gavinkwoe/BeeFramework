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

#import "Bee.h"

#pragma mark - enums

#define LIST_Mains	@"Mains"
#define LIST_Cookbook	@"Cookbook"
#define LIST_Snacks	@"Snacks"
#define LIST_MyFeed	@"MyFeed"
#define LIST_Desserts	@"Desserts"

#define ProfileTabList_Recipe	@"recipe"
#define ProfileTabList_Badge	@"badge"
#define ProfileTabList_Following	@"following"
#define ProfileTabList_Follower	@"follower"
#define ProfileTabList_Table	@"table"

#define StatusCode_NormalCode	@"100"
#define StatusCode_ErrorCode	@"200"

#pragma mark - models

@class AddCookBookResData;
@class BuyUploadCountResData;
@class CommentReqData;
@class CookOverResData;
@class GetCommentByRecipeResData;
@class GetCookedResData;
@class GetDetailResData;
@class GetFavRecResData;
@class GetFollowerResData;
@class GetFriendByFacebookResData;
@class GetInviteCodeResData;
@class GetNewsfeedResData;
@class GetRecDetailResData;
@class GetResultPicResData;
@class InputCodeResData;
@class IpadHomeTab;
@class LoginSuccessResData;
@class RecipeListResData;
@class TabVersion;
@class UploadResultPicResData;
@class UserPushGroup;
@class UserRecipe;

@interface AddCookBookResData : BeeActiveObject
@property (nonatomic, retain) NSNumber *			Currency;
@property (nonatomic, retain) NSNumber *			Result;
@end

@interface BuyUploadCountResData : BeeActiveObject
@property (nonatomic, retain) NSNumber *			Currency;
@property (nonatomic, retain) NSNumber *			Result;
@property (nonatomic, retain) NSNumber *			UploadSolt;
@end

@interface CommentReqData : BeeActiveObject
@property (nonatomic, retain) NSString *			impressions;
@property (nonatomic, retain) NSNumber *			star;
@property (nonatomic, retain) NSString *			strComment;
@property (nonatomic, retain) NSNumber *			uID;
@property (nonatomic, retain) NSNumber *			urID;
@end

@interface CookOverResData : BeeActiveObject
@property (nonatomic, retain) NSNumber *			Currency;
@property (nonatomic, retain) NSNumber *			UserRecipeId;
@end

@interface GetCommentByRecipeResData : BeeActiveObject
@property (nonatomic, retain) NSString *			Comment;
@property (nonatomic, retain) NSNumber *			CommentID;
@property (nonatomic, retain) NSNumber *			CommentTime;
@property (nonatomic, retain) NSString *			FName;
@property (nonatomic, retain) NSString *			PicName;
@property (nonatomic, retain) NSNumber *			PicType;
@property (nonatomic, retain) NSString *			ProfilePic;
@property (nonatomic, retain) NSNumber *			ReportAble;
@property (nonatomic, retain) NSNumber *			Star;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface GetCookedResData : BeeActiveObject
@property (nonatomic, retain) NSString *			Comment;
@property (nonatomic, retain) NSNumber *			CommentID;
@property (nonatomic, retain) NSNumber *			CommentTime;
@property (nonatomic, retain) NSNumber *			CookTime;
@property (nonatomic, retain) NSString *			CoverPic;
@property (nonatomic, retain) NSNumber *			Followed;
@property (nonatomic, retain) NSNumber *			MakerID;
@property (nonatomic, retain) NSString *			MakerName;
@property (nonatomic, retain) NSString *			PicName;
@property (nonatomic, retain) NSString *			ProfilePic;
@property (nonatomic, retain) RecipeBody *			RecipeBody;
@property (nonatomic, retain) NSNumber *			RecipeID;
@property (nonatomic, retain) NSString *			RecipeName;
@property (nonatomic, retain) NSString *			RecipeUrl;
@property (nonatomic, retain) NSNumber *			Star;
@property (nonatomic, retain) NSNumber *			URID;
@end

@interface GetDetailResData : BeeActiveObject
@property (nonatomic, retain) NSString *			Address;
@property (nonatomic, retain) NSString *			BackPic;
@property (nonatomic, retain) NSNumber *			Backed;
@property (nonatomic, retain) NSNumber *			BadgeCount;
@property (nonatomic, retain) NSNumber *			CookedCount;
@property (nonatomic, retain) NSNumber *			Currency;
@property (nonatomic, retain) NSString *			FName;
@property (nonatomic, retain) NSNumber *			FollowCount;
@property (nonatomic, retain) NSNumber *			Followed;
@property (nonatomic, retain) NSNumber *			FollowerCount;
@property (nonatomic, retain) NSNumber *			ID;
@property (nonatomic, retain) NSNumber *			IsBrandUser;
@property (nonatomic, retain) NSString *			PersonalSign;
@property (nonatomic, retain) NSString *			PersonalSite;
@property (nonatomic, retain) NSString *			ProfilePic;
@property (nonatomic, retain) NSNumber *			RecipeCount;
@property (nonatomic, retain) NSNumber *			Served;
@end

@interface GetFavRecResData : BeeActiveObject
@property (nonatomic, retain) NSNumber *			CommentCount;
@property (nonatomic, retain) NSNumber *			FavCount;
@property (nonatomic, retain) NSNumber *			RecipeID;
@property (nonatomic, retain) NSString *			RecipeName;
@property (nonatomic, retain) NSString *			RecipeUrl;
@property (nonatomic, retain) NSNumber *			Star;
@end

@interface GetFollowerResData : BeeActiveObject
@property (nonatomic, retain) NSString *			Address;
@property (nonatomic, retain) NSString *			BackPic;
@property (nonatomic, retain) NSNumber *			Backed;
@property (nonatomic, retain) NSString *			FName;
@property (nonatomic, retain) NSNumber *			Featured;
@property (nonatomic, retain) NSNumber *			FollowerCount;
@property (nonatomic, retain) NSNumber *			FollowingCount;
@property (nonatomic, retain) NSNumber *			ID;
@property (nonatomic, retain) NSString *			LastRecipe;
@property (nonatomic, retain) NSString *			Name;
@property (nonatomic, retain) NSString *			PersonalSite;
@property (nonatomic, retain) NSString *			ProfilePic;
@property (nonatomic, retain) NSNumber *			RecipeCount;
@property (nonatomic, retain) NSNumber *			TableCount;
@end

@interface GetFriendByFacebookResData : BeeActiveObject
@property (nonatomic, retain) NSString *			Address;
@property (nonatomic, retain) NSString *			BackPic;
@property (nonatomic, retain) NSNumber *			Backed;
@property (nonatomic, retain) NSNumber *			Featured;
@property (nonatomic, retain) NSNumber *			Followed;
@property (nonatomic, retain) NSNumber *			FollowerCount;
@property (nonatomic, retain) NSNumber *			FollowingCount;
@property (nonatomic, retain) NSString *			PersonalSite;
@property (nonatomic, retain) NSString *			ProfilePic;
@property (nonatomic, retain) NSString *			RealName;
@property (nonatomic, retain) NSNumber *			RecipeCount;
@property (nonatomic, retain) NSNumber *			TableCount;
@property (nonatomic, retain) NSNumber *			UserId;
@property (nonatomic, retain) NSString *			Username;
@end

@interface GetInviteCodeResData : BeeActiveObject
@property (nonatomic, retain) NSNumber *			AddCurrency;
@property (nonatomic, retain) NSString *			Code;
@end

@interface GetNewsfeedResData : BeeActiveObject
@property (nonatomic, retain) NSString *			Desc;
@property (nonatomic, retain) NSNumber *			ID;
@property (nonatomic, retain) NSNumber *			Time;
@property (nonatomic, retain) NSString *			Type;
@property (nonatomic, retain) NSNumber *			UserID;
@end

@interface GetRecDetailResData : BeeActiveObject
@property (nonatomic, retain) NSNumber *			CommentCount;
@property (nonatomic, retain) NSNumber *			CookedCount;
@property (nonatomic, retain) NSString *			DishChar;
@property (nonatomic, retain) NSString *			FName;
@property (nonatomic, retain) NSNumber *			Faved;
@property (nonatomic, retain) NSNumber *			IsNew;
@property (nonatomic, retain) NSNumber *			RecipeID;
@property (nonatomic, retain) NSNumber *			Star;
@property (nonatomic, retain) NSString *			TypeDish;
@property (nonatomic, retain) NSString *			UName;
@property (nonatomic, retain) NSString *			UploadTime;
@property (nonatomic, retain) NSString *			Url;
@property (nonatomic, retain) NSNumber *			UserID;
@property (nonatomic, retain) NSNumber *			Version;
@end

@interface GetResultPicResData : BeeActiveObject
@property (nonatomic, retain) NSString *			Liked;
@property (nonatomic, retain) NSNumber *			PicID;
@property (nonatomic, retain) NSString *			PicName;
@property (nonatomic, retain) NSString *			ProfilePic;
@property (nonatomic, retain) NSNumber *			ReportAble;
@property (nonatomic, retain) NSNumber *			Time;
@property (nonatomic, retain) NSNumber *			UserID;
@property (nonatomic, retain) NSString *			UserName;
@end

@interface InputCodeResData : BeeActiveObject
@property (nonatomic, retain) NSNumber *			AddCurrency;
@property (nonatomic, retain) NSNumber *			AddUploadCount;
@property (nonatomic, retain) NSNumber *			Currency;
@property (nonatomic, retain) NSNumber *			IsSpecial;
@property (nonatomic, retain) NSNumber *			Result;
@end

@interface IpadHomeTab : BeeActiveObject
@property (nonatomic, retain) NSString *			DisplayName;
@property (nonatomic, retain) NSString *			ID;
@property (nonatomic, retain) NSString *			TagName;
@end

@interface LoginSuccessResData : BeeActiveObject
@property (nonatomic, retain) NSString *			Address;
@property (nonatomic, retain) NSNumber *			Currency;
@property (nonatomic, retain) NSString *			Email;
@property (nonatomic, retain) NSString *			FName;
@property (nonatomic, retain) NSString *			ProfilePic;
@property (nonatomic, retain) NSNumber *			UserID;
@end

@interface RecipeListResData : BeeActiveObject
@property (nonatomic, retain) NSNumber *			AlertLanguage;
@property (nonatomic, retain) NSString *			BuyUrl;
@property (nonatomic, retain) NSNumber *			CommentCount;
@property (nonatomic, retain) NSNumber *			CookAble;
@property (nonatomic, retain) NSNumber *			Cooked;
@property (nonatomic, retain) NSNumber *			CookedCount;
@property (nonatomic, retain) NSString *			CoverPic;
@property (nonatomic, retain) NSString *			FName;
@property (nonatomic, retain) NSNumber *			Faved;
@property (nonatomic, retain) NSNumber *			Featured;
@property (nonatomic, retain) NSNumber *			ImpressionId;
@property (nonatomic, retain) NSNumber *			IsNew;
@property (nonatomic, retain) NSNumber *			LikedCount;
@property (nonatomic, retain) NSString *			PersonalSite;
@property (nonatomic, retain) NSString *			ProfilePic;
@property (nonatomic, retain) RecipeBody *			RecipeBody;
@property (nonatomic, retain) NSNumber *			RecipeCount;
@property (nonatomic, retain) NSNumber *			RecipeID;
@property (nonatomic, retain) NSString *			RecipeName;
@property (nonatomic, retain) NSNumber *			Reviewed;
@property (nonatomic, retain) NSNumber *			Star;
@property (nonatomic, retain) NSNumber *			TotalTime;
@property (nonatomic, retain) NSString *			UName;
@property (nonatomic, retain) NSDate *			UploadTime;
@property (nonatomic, retain) NSString *			Url;
@property (nonatomic, retain) NSNumber *			UserID;
@property (nonatomic, retain) NSNumber *			Version;
@property (nonatomic, retain) NSString *			VideoUrl;
@end

@interface TabVersion : BeeActiveObject
@property (nonatomic, retain) NSString *			FileName;
@property (nonatomic, retain) NSString *			TabName;
@property (nonatomic, retain) NSNumber *			Version;
@end

@interface UploadResultPicResData : BeeActiveObject
@property (nonatomic, retain) NSNumber *			Currency;
@property (nonatomic, retain) NSNumber *			IsFirst;
@property (nonatomic, retain) NSString *			PicName;
@end

@interface UserPushGroup : BeeActiveObject
@property (nonatomic, retain) NSNumber *			DoActivity;
@property (nonatomic, retain) NSNumber *			EarnBadge;
@property (nonatomic, retain) NSNumber *			NewFollower;
@property (nonatomic, retain) NSNumber *			OperateRecipe;
@property (nonatomic, retain) NSNumber *			RecipeUpdate;
@property (nonatomic, retain) NSNumber *			SideChefUpdate;
@property (nonatomic, retain) NSNumber *			Social;
@end

@interface UserRecipe : BeeActiveObject
@property (nonatomic, retain) NSNumber *			RecipeID;
@property (nonatomic, retain) NSNumber *			UserID;
@property (nonatomic, retain) NSNumber *			UserRecipeID;
@end

#pragma mark - controllers

#pragma mark - GET /DataSource/GetAllTab

@interface REQ_DATASOURCE_GETALLTAB : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@end

@interface RESP_DATASOURCE_GETALLTAB : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_DATASOURCE_GETALLTAB : BeeAPI
@property (nonatomic, retain) REQ_DATASOURCE_GETALLTAB *	req;
@property (nonatomic, retain) RESP_DATASOURCE_GETALLTAB *	resp;
@end

#pragma mark - GET /InterfaceIPhone/AddCookBook

@interface REQ_INTERFACEIPHONE_ADDCOOKBOOK : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeID;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_ADDCOOKBOOK : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_ADDCOOKBOOK : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_ADDCOOKBOOK *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_ADDCOOKBOOK *	resp;
@end

#pragma mark - POST /InterfaceIPhone/Answer

@interface REQ_INTERFACEIPHONE_ANSWER : BeeActiveObject
@property (nonatomic, retain) NSString *			content;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			questionID;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_ANSWER : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_ANSWER : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_ANSWER *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_ANSWER *	resp;
@end

#pragma mark - POST /InterfaceIPhone/Ask

@interface REQ_INTERFACEIPHONE_ASK : BeeActiveObject
@property (nonatomic, retain) NSString *			content;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeID;
@property (nonatomic, retain) NSString *			stepGuid;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_ASK : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_ASK : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_ASK *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_ASK *	resp;
@end

#pragma mark - GET /InterfaceIPhone/BuyUploadCount

@interface REQ_INTERFACEIPHONE_BUYUPLOADCOUNT : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_BUYUPLOADCOUNT : BeeActiveObject
@property (nonatomic, retain) BuyUploadCountResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_BUYUPLOADCOUNT : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_BUYUPLOADCOUNT *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_BUYUPLOADCOUNT *	resp;
@end

#pragma mark - GET /InterfaceIPhone/CancelFavRec

@interface REQ_INTERFACEIPHONE_CANCELFAVREC : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeID;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_CANCELFAVREC : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_CANCELFAVREC : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_CANCELFAVREC *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_CANCELFAVREC *	resp;
@end

#pragma mark - GET /InterfaceIPhone/CancelFollow

@interface REQ_INTERFACEIPHONE_CANCELFOLLOW : BeeActiveObject
@property (nonatomic, retain) NSNumber *			followUserID;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_CANCELFOLLOW : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_CANCELFOLLOW : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_CANCELFOLLOW *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_CANCELFOLLOW *	resp;
@end

#pragma mark - GET /InterfaceIPhone/CancelLikeResultPic

@interface REQ_INTERFACEIPHONE_CANCELLIKERESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSNumber *			picID;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_CANCELLIKERESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_CANCELLIKERESULTPIC : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_CANCELLIKERESULTPIC *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_CANCELLIKERESULTPIC *	resp;
@end

#pragma mark - GET /InterfaceIPhone/ChangePwd

@interface REQ_INTERFACEIPHONE_CHANGEPWD : BeeActiveObject
@property (nonatomic, retain) NSString *			currentPwd;
@property (nonatomic, retain) NSNumber *			encryptMethod;
@property (nonatomic, retain) NSString *			newPwd;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_CHANGEPWD : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_CHANGEPWD : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_CHANGEPWD *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_CHANGEPWD *	resp;
@end

#pragma mark - GET /InterfaceIPhone/CheckFollowed

@interface REQ_INTERFACEIPHONE_CHECKFOLLOWED : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@property (nonatomic, retain) NSNumber *			userID2;
@end

@interface RESP_INTERFACEIPHONE_CHECKFOLLOWED : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_CHECKFOLLOWED : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_CHECKFOLLOWED *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_CHECKFOLLOWED *	resp;
@end

#pragma mark - GET /InterfaceIPhone/ClearBadgeCount

@interface REQ_INTERFACEIPHONE_CLEARBADGECOUNT : BeeActiveObject
@property (nonatomic, retain) NSString *			deviceToken;
@property (nonatomic, retain) NSNumber *			platform;
@end

@interface RESP_INTERFACEIPHONE_CLEARBADGECOUNT : BeeActiveObject
@property (nonatomic, retain) LoginSuccessResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_CLEARBADGECOUNT : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_CLEARBADGECOUNT *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_CLEARBADGECOUNT *	resp;
@end

#pragma mark - POST /InterfaceIPhone/Comment

@interface REQ_INTERFACEIPHONE_COMMENT : BeeActiveObject
@property (nonatomic, retain) NSString *			comment;
@property (nonatomic, retain) NSString *			impressions;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeID;
@property (nonatomic, retain) NSNumber *			star;
@property (nonatomic, retain) NSNumber *			userID;
@property (nonatomic, retain) NSNumber *			userRecipeID;
@end

@interface RESP_INTERFACEIPHONE_COMMENT : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_COMMENT : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_COMMENT *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_COMMENT *	resp;
@end

#pragma mark - GET /InterfaceIPhone/CookOver

@interface REQ_INTERFACEIPHONE_COOKOVER : BeeActiveObject
@property (nonatomic, retain) NSNumber *			cookTime;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeId;
@property (nonatomic, retain) NSNumber *			userId;
@end

@interface RESP_INTERFACEIPHONE_COOKOVER : BeeActiveObject
@property (nonatomic, retain) CookOverResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_COOKOVER : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_COOKOVER *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_COOKOVER *	resp;
@end

#pragma mark - GET /InterfaceIPhone/DeleteCooked

@interface REQ_INTERFACEIPHONE_DELETECOOKED : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userRecipeID;
@end

@interface RESP_INTERFACEIPHONE_DELETECOOKED : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_DELETECOOKED : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_DELETECOOKED *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_DELETECOOKED *	resp;
@end

#pragma mark - GET /InterfaceIPhone/DeleteNewsfeed

@interface REQ_INTERFACEIPHONE_DELETENEWSFEED : BeeActiveObject
@property (nonatomic, retain) NSNumber *			newsfeedID;
@property (nonatomic, retain) NSNumber *			platform;
@end

@interface RESP_INTERFACEIPHONE_DELETENEWSFEED : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_DELETENEWSFEED : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_DELETENEWSFEED *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_DELETENEWSFEED *	resp;
@end

#pragma mark - GET /InterfaceIPhone/EvaluateOurApp

@interface REQ_INTERFACEIPHONE_EVALUATEOURAPP : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_EVALUATEOURAPP : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_EVALUATEOURAPP : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_EVALUATEOURAPP *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_EVALUATEOURAPP *	resp;
@end

#pragma mark - GET /InterfaceIPhone/ExistsNewBadge

@interface REQ_INTERFACEIPHONE_EXISTSNEWBADGE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_EXISTSNEWBADGE : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_EXISTSNEWBADGE : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_EXISTSNEWBADGE *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_EXISTSNEWBADGE *	resp;
@end

#pragma mark - GET /InterfaceIPhone/FavRec

@interface REQ_INTERFACEIPHONE_FAVREC : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeID;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_FAVREC : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_FAVREC : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_FAVREC *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_FAVREC *	resp;
@end

#pragma mark - GET /InterfaceIPhone/Follow

@interface REQ_INTERFACEIPHONE_FOLLOW : BeeActiveObject
@property (nonatomic, retain) NSNumber *			followUserID;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_FOLLOW : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_FOLLOW : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_FOLLOW *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_FOLLOW *	resp;
@end

#pragma mark - POST /InterfaceIPhone/FollowAll

@interface REQ_INTERFACEIPHONE_FOLLOWALL : BeeActiveObject
@property (nonatomic, retain) NSString *			followUserList;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_FOLLOWALL : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_FOLLOWALL : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_FOLLOWALL *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_FOLLOWALL *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetBadge

@interface REQ_INTERFACEIPHONE_GETBADGE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETBADGE : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETBADGE : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETBADGE *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETBADGE *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetCommentByRecipe

@interface REQ_INTERFACEIPHONE_GETCOMMENTBYRECIPE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeID;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETCOMMENTBYRECIPE : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETCOMMENTBYRECIPE : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETCOMMENTBYRECIPE *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETCOMMENTBYRECIPE *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetCooked

@interface REQ_INTERFACEIPHONE_GETCOOKED : BeeActiveObject
@property (nonatomic, retain) NSNumber *			pageIndex;
@property (nonatomic, retain) NSNumber *			pageSize;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETCOOKED : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETCOOKED : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETCOOKED *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETCOOKED *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetDetail

@interface REQ_INTERFACEIPHONE_GETDETAIL : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@property (nonatomic, retain) NSNumber *			userID2;
@end

@interface RESP_INTERFACEIPHONE_GETDETAIL : BeeActiveObject
@property (nonatomic, retain) GetDetailResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETDETAIL : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETDETAIL *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETDETAIL *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetFavRec

@interface REQ_INTERFACEIPHONE_GETFAVREC : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETFAVREC : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETFAVREC : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETFAVREC *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETFAVREC *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetFeaturedChef

@interface REQ_INTERFACEIPHONE_GETFEATUREDCHEF : BeeActiveObject
@property (nonatomic, retain) NSNumber *			pageIndex;
@property (nonatomic, retain) NSNumber *			pageSize;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userId;
@end

@interface RESP_INTERFACEIPHONE_GETFEATUREDCHEF : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETFEATUREDCHEF : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETFEATUREDCHEF *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETFEATUREDCHEF *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetFollower

@interface REQ_INTERFACEIPHONE_GETFOLLOWER : BeeActiveObject
@property (nonatomic, retain) NSNumber *			pageIndex;
@property (nonatomic, retain) NSNumber *			pageSize;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETFOLLOWER : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETFOLLOWER : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETFOLLOWER *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETFOLLOWER *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetFollowing

@interface REQ_INTERFACEIPHONE_GETFOLLOWING : BeeActiveObject
@property (nonatomic, retain) NSNumber *			pageIndex;
@property (nonatomic, retain) NSNumber *			pageSize;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETFOLLOWING : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETFOLLOWING : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETFOLLOWING *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETFOLLOWING *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetFriendByFacebook

@interface REQ_INTERFACEIPHONE_GETFRIENDBYFACEBOOK : BeeActiveObject
@property (nonatomic, retain) NSNumber *			pageIndex;
@property (nonatomic, retain) NSNumber *			pageSize;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			type;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETFRIENDBYFACEBOOK : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETFRIENDBYFACEBOOK : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETFRIENDBYFACEBOOK *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETFRIENDBYFACEBOOK *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetGuideResultPic

@interface REQ_INTERFACEIPHONE_GETGUIDERESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@property (nonatomic, retain) NSNumber *			userID2;
@end

@interface RESP_INTERFACEIPHONE_GETGUIDERESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETGUIDERESULTPIC : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETGUIDERESULTPIC *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETGUIDERESULTPIC *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetHomeTab

@interface RESP_INTERFACEIPHONE_GETHOMETAB : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETHOMETAB : BeeAPI
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETHOMETAB *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetInviteCode

@interface REQ_INTERFACEIPHONE_GETINVITECODE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETINVITECODE : BeeActiveObject
@property (nonatomic, retain) GetInviteCodeResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETINVITECODE : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETINVITECODE *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETINVITECODE *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetNewsfeed

@interface REQ_INTERFACEIPHONE_GETNEWSFEED : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETNEWSFEED : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETNEWSFEED : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETNEWSFEED *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETNEWSFEED *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetQuestionByStep

@interface REQ_INTERFACEIPHONE_GETQUESTIONBYSTEP : BeeActiveObject
@property (nonatomic, retain) NSNumber *			pageIndex;
@property (nonatomic, retain) NSNumber *			pageSize;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSString *			stepGuid;
@end

@interface RESP_INTERFACEIPHONE_GETQUESTIONBYSTEP : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETQUESTIONBYSTEP : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETQUESTIONBYSTEP *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETQUESTIONBYSTEP *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetRecDetail

@interface REQ_INTERFACEIPHONE_GETRECDETAIL : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeID;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETRECDETAIL : BeeActiveObject
@property (nonatomic, retain) GetRecDetailResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETRECDETAIL : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETRECDETAIL *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETRECDETAIL *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetRecipeByUser

@interface REQ_INTERFACEIPHONE_GETRECIPEBYUSER : BeeActiveObject
@property (nonatomic, retain) NSNumber *			pageIndex;
@property (nonatomic, retain) NSNumber *			pageSize;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@property (nonatomic, retain) NSNumber *			userID2;
@end

@interface RESP_INTERFACEIPHONE_GETRECIPEBYUSER : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETRECIPEBYUSER : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETRECIPEBYUSER *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETRECIPEBYUSER *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetRecipeDetail

@interface REQ_INTERFACEIPHONE_GETRECIPEDETAIL : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeID;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETRECIPEDETAIL : BeeActiveObject
@property (nonatomic, retain) RecipeListResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETRECIPEDETAIL : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETRECIPEDETAIL *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETRECIPEDETAIL *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetRecipeUrl

@interface REQ_INTERFACEIPHONE_GETRECIPEURL : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeID;
@end

@interface RESP_INTERFACEIPHONE_GETRECIPEURL : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETRECIPEURL : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETRECIPEURL *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETRECIPEURL *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetResultPic

@interface REQ_INTERFACEIPHONE_GETRESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeID;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_GETRESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETRESULTPIC : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETRESULTPIC *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETRESULTPIC *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GetUserPushGroup

@interface REQ_INTERFACEIPHONE_GETUSERPUSHGROUP : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userId;
@end

@interface RESP_INTERFACEIPHONE_GETUSERPUSHGROUP : BeeActiveObject
@property (nonatomic, retain) UserPushGroup *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GETUSERPUSHGROUP : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GETUSERPUSHGROUP *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GETUSERPUSHGROUP *	resp;
@end

#pragma mark - GET /InterfaceIPhone/GewNewsfeedDetail

@interface REQ_INTERFACEIPHONE_GEWNEWSFEEDDETAIL : BeeActiveObject
@property (nonatomic, retain) NSNumber *			newsfeedID;
@property (nonatomic, retain) NSNumber *			platform;
@end

@interface RESP_INTERFACEIPHONE_GEWNEWSFEEDDETAIL : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_GEWNEWSFEEDDETAIL : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_GEWNEWSFEEDDETAIL *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_GEWNEWSFEEDDETAIL *	resp;
@end

#pragma mark - GET /InterfaceIPhone/InputCode

@interface REQ_INTERFACEIPHONE_INPUTCODE : BeeActiveObject
@property (nonatomic, retain) NSString *			code;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_INPUTCODE : BeeActiveObject
@property (nonatomic, retain) InputCodeResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_INPUTCODE : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_INPUTCODE *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_INPUTCODE *	resp;
@end

#pragma mark - GET /InterfaceIPhone/LikeResultPic

@interface REQ_INTERFACEIPHONE_LIKERESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSNumber *			picID;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_LIKERESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_LIKERESULTPIC : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_LIKERESULTPIC *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_LIKERESULTPIC *	resp;
@end

#pragma mark - GET /InterfaceIPhone/LoginFacebook

@interface REQ_INTERFACEIPHONE_LOGINFACEBOOK : BeeActiveObject
@property (nonatomic, retain) NSString *			deviceToken;
@property (nonatomic, retain) NSString *			facebookID;
@property (nonatomic, retain) NSNumber *			platform;
@end

@interface RESP_INTERFACEIPHONE_LOGINFACEBOOK : BeeActiveObject
@property (nonatomic, retain) LoginSuccessResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_LOGINFACEBOOK : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_LOGINFACEBOOK *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_LOGINFACEBOOK *	resp;
@end

#pragma mark - POST /InterfaceIPhone/LoginQQ

@interface REQ_INTERFACEIPHONE_LOGINQQ : BeeActiveObject
@property (nonatomic, retain) NSString *			deviceToken;
@property (nonatomic, retain) NSString *			email;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSString *			qqOpenId;
@end

@interface RESP_INTERFACEIPHONE_LOGINQQ : BeeActiveObject
@property (nonatomic, retain) LoginSuccessResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_LOGINQQ : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_LOGINQQ *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_LOGINQQ *	resp;
@end

#pragma mark - POST /InterfaceIPhone/LoginSinaWeibo

@interface REQ_INTERFACEIPHONE_LOGINSINAWEIBO : BeeActiveObject
@property (nonatomic, retain) NSString *			deviceToken;
@property (nonatomic, retain) NSString *			email;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSString *			sinaWeiboId;
@end

@interface RESP_INTERFACEIPHONE_LOGINSINAWEIBO : BeeActiveObject
@property (nonatomic, retain) LoginSuccessResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_LOGINSINAWEIBO : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_LOGINSINAWEIBO *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_LOGINSINAWEIBO *	resp;
@end

#pragma mark - GET /InterfaceIPhone/Logout

@interface REQ_INTERFACEIPHONE_LOGOUT : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_LOGOUT : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_LOGOUT : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_LOGOUT *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_LOGOUT *	resp;
@end

#pragma mark - GET /InterfaceIPhone/RecipeList

@interface REQ_INTERFACEIPHONE_RECIPELIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			pageIndex;
@property (nonatomic, retain) NSNumber *			pageSize;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_RECIPELIST : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_RECIPELIST : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_RECIPELIST *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_RECIPELIST *	resp;
@end

#pragma mark - GET /InterfaceIPhone/RecipeListTab

@interface REQ_INTERFACEIPHONE_RECIPELISTTAB : BeeActiveObject
@property (nonatomic, retain) NSString *			keyword;
@property (nonatomic, retain) NSNumber *			pageIndex;
@property (nonatomic, retain) NSNumber *			pageSize;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_RECIPELISTTAB : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_RECIPELISTTAB : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_RECIPELISTTAB *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_RECIPELISTTAB *	resp;
@end

#pragma mark - POST /InterfaceIPhone/RegFacebook

@interface REQ_INTERFACEIPHONE_REGFACEBOOK : BeeActiveObject
@property (nonatomic, retain) NSString *			deviceToken;
@property (nonatomic, retain) NSString *			facebookID;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSString *			realName;
@property (nonatomic, retain) NSString *			userName;
@end

@interface RESP_INTERFACEIPHONE_REGFACEBOOK : BeeActiveObject
@property (nonatomic, retain) LoginSuccessResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_REGFACEBOOK : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_REGFACEBOOK *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_REGFACEBOOK *	resp;
@end

#pragma mark - POST /InterfaceIPhone/RegQQ

@interface REQ_INTERFACEIPHONE_REGQQ : BeeActiveObject
@property (nonatomic, retain) NSString *			deviceToken;
@property (nonatomic, retain) NSString *			email;
@property (nonatomic, retain) NSString *			openId;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSString *			realName;
@property (nonatomic, retain) NSString *			userName;
@end

@interface RESP_INTERFACEIPHONE_REGQQ : BeeActiveObject
@property (nonatomic, retain) LoginSuccessResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_REGQQ : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_REGQQ *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_REGQQ *	resp;
@end

#pragma mark - POST /InterfaceIPhone/RegSinaWeibo

@interface REQ_INTERFACEIPHONE_REGSINAWEIBO : BeeActiveObject
@property (nonatomic, retain) NSString *			deviceToken;
@property (nonatomic, retain) NSString *			email;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSString *			realName;
@property (nonatomic, retain) NSString *			sinaWeiboId;
@property (nonatomic, retain) NSString *			userName;
@end

@interface RESP_INTERFACEIPHONE_REGSINAWEIBO : BeeActiveObject
@property (nonatomic, retain) LoginSuccessResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_REGSINAWEIBO : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_REGSINAWEIBO *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_REGSINAWEIBO *	resp;
@end

#pragma mark - GET /InterfaceIPhone/RemoveFromCookBook

@interface REQ_INTERFACEIPHONE_REMOVEFROMCOOKBOOK : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			recipeID;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_REMOVEFROMCOOKBOOK : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_REMOVEFROMCOOKBOOK : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_REMOVEFROMCOOKBOOK *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_REMOVEFROMCOOKBOOK *	resp;
@end

#pragma mark - GET /InterfaceIPhone/ReportComment

@interface REQ_INTERFACEIPHONE_REPORTCOMMENT : BeeActiveObject
@property (nonatomic, retain) NSNumber *			cID;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_REPORTCOMMENT : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_REPORTCOMMENT : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_REPORTCOMMENT *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_REPORTCOMMENT *	resp;
@end

#pragma mark - GET /InterfaceIPhone/ReportResultPic

@interface REQ_INTERFACEIPHONE_REPORTRESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSNumber *			picID;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_REPORTRESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_REPORTRESULTPIC : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_REPORTRESULTPIC *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_REPORTRESULTPIC *	resp;
@end

#pragma mark - POST /InterfaceIPhone/SaveFacebookFriendForUser

@interface REQ_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER : BeeActiveObject
@property (nonatomic, retain) NSString *			facebookIdList;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_SAVEFACEBOOKFRIENDFORUSER *	resp;
@end

#pragma mark - GET /InterfaceIPhone/SearchRecipe

@interface REQ_INTERFACEIPHONE_SEARCHRECIPE : BeeActiveObject
@property (nonatomic, retain) NSString *			filter;
@property (nonatomic, retain) NSNumber *			pageIndex;
@property (nonatomic, retain) NSNumber *			pageSize;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_SEARCHRECIPE : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_SEARCHRECIPE : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_SEARCHRECIPE *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_SEARCHRECIPE *	resp;
@end

#pragma mark - GET /InterfaceIPhone/SearchUser

@interface REQ_INTERFACEIPHONE_SEARCHUSER : BeeActiveObject
@property (nonatomic, retain) NSString *			keyword;
@property (nonatomic, retain) NSNumber *			pageIndex;
@property (nonatomic, retain) NSNumber *			pageSize;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSString *			tag;
@end

@interface RESP_INTERFACEIPHONE_SEARCHUSER : BeeActiveObject
@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_SEARCHUSER : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_SEARCHUSER *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_SEARCHUSER *	resp;
@end

#pragma mark - GET /InterfaceIPhone/Share

@interface REQ_INTERFACEIPHONE_SHARE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_SHARE : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_SHARE : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_SHARE *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_SHARE *	resp;
@end

#pragma mark - GET /InterfaceIPhone/TurnOnOffPush

@interface REQ_INTERFACEIPHONE_TURNONOFFPUSH : BeeActiveObject
@property (nonatomic, retain) NSNumber *			on;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			pushGroup;
@property (nonatomic, retain) NSNumber *			userId;
@end

@interface RESP_INTERFACEIPHONE_TURNONOFFPUSH : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_TURNONOFFPUSH : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_TURNONOFFPUSH *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_TURNONOFFPUSH *	resp;
@end

#pragma mark - POST /InterfaceIPhone/Update

@interface REQ_INTERFACEIPHONE_UPDATE : BeeActiveObject
@property (nonatomic, retain) NSString *			address;
@property (nonatomic, retain) NSString *			fname;
@property (nonatomic, retain) NSString *			operate;
@property (nonatomic, retain) NSString *			personalSign;
@property (nonatomic, retain) NSString *			personalSite;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userID;
@end

@interface RESP_INTERFACEIPHONE_UPDATE : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_UPDATE : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_UPDATE *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_UPDATE *	resp;
@end

#pragma mark - POST /InterfaceIPhone/UploadResultPic

@interface REQ_INTERFACEIPHONE_UPLOADRESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSData *			imageData;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSNumber *			userRecipeID;
@end

@interface RESP_INTERFACEIPHONE_UPLOADRESULTPIC : BeeActiveObject
@property (nonatomic, retain) NSObject *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_UPLOADRESULTPIC : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_UPLOADRESULTPIC *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_UPLOADRESULTPIC *	resp;
@end

#pragma mark - POST /InterfaceIPhone/UserLogin

@interface REQ_INTERFACEIPHONE_USERLOGIN : BeeActiveObject
@property (nonatomic, retain) NSString *			device_token;
@property (nonatomic, retain) NSNumber *			encryptMethod;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSString *			uEmail;
@property (nonatomic, retain) NSString *			uPwd;
@end

@interface RESP_INTERFACEIPHONE_USERLOGIN : BeeActiveObject
@property (nonatomic, retain) LoginSuccessResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_USERLOGIN : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_USERLOGIN *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_USERLOGIN *	resp;
@property (nonatomic, retain) FILELIST_INTERFACEIPHONE_USERLOGIN *	resp;
@end

#pragma mark - POST /InterfaceIPhone/UserReg

@interface REQ_INTERFACEIPHONE_USERREG : BeeActiveObject
@property (nonatomic, retain) NSNumber *			encryptMethod;
@property (nonatomic, retain) NSNumber *			platform;
@property (nonatomic, retain) NSString *			uEmail;
@property (nonatomic, retain) NSString *			uName;
@property (nonatomic, retain) NSString *			uPwd;
@end

@interface RESP_INTERFACEIPHONE_USERREG : BeeActiveObject
@property (nonatomic, retain) LoginSuccessResData *			data;
@property (nonatomic, retain) NSString *			message;
@property (nonatomic, retain) NSString *			status;
@end

@interface API_INTERFACEIPHONE_USERREG : BeeAPI
@property (nonatomic, retain) REQ_INTERFACEIPHONE_USERREG *	req;
@property (nonatomic, retain) RESP_INTERFACEIPHONE_USERREG *	resp;
@end

#pragma mark - config

@interface ServerConfig : NSObject

AS_SINGLETON( ServerConfig )

AS_INT( CONFIG_DEVELOPMENT )
AS_INT( CONFIG_TEST )
AS_INT( CONFIG_PRODUCTION )

@property (nonatomic, assign) NSUInteger			config;

@property (nonatomic, readonly) NSString *			url;
@property (nonatomic, readonly) NSString *			testUrl;
@property (nonatomic, readonly) NSString *			productionUrl;
@property (nonatomic, readonly) NSString *			developmentUrl;

@end


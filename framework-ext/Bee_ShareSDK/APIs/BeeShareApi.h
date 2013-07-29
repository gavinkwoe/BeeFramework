//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  BeeShareApi.h
//  BeeSNS
//
//  Created by QFish on 4/27/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "Bee.h"

@protocol BeeShareApiProtocol <NSObject>

@optional
- (void)setup;
- (void)login;
- (void)logout;
- (BOOL)isLogined;
- (BOOL)isExpired;
- (BOOL)isAuthValid;
- (void)restoreAuthData:(id)authData;

@required

@end

#pragma mark -

@interface BeeShareApi : BeeController<BeeShareApiProtocol>

AS_NOTIFICATION( SIGNIN_DID_START )
AS_NOTIFICATION( SIGNIN_DID_FAILED )
AS_NOTIFICATION( SIGNIN_DID_CANCEL )
AS_NOTIFICATION( SIGNIN_DID_SUCCESS )

@property (nonatomic, retain) NSString   * title;
@property (nonatomic, retain) BeeUIBoard * context;
@property (nonatomic, retain) Class authorizeBoardClazz;

+ (NSString *)authorizeUrl;
+ (NSString *)paramValueFromUrl:(NSString*)url paramName:(NSString *)paramName;
+ (NSDictionary *)dictionaryWtihURLParams:(NSString *)query;
+ (NSDate *)dateWithString:(NSString *)string;

- (id)initWithContext:(UIViewController *)context;

@end

//
//  ServiceShare_API.h
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "Bee.h"

@interface ServiceShareError : NSObject
@property (nonatomic, copy) NSNumber * code;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, copy) NSString * domain;

+ (id)errorWithCode:(NSNumber *)code
               desc:(NSString *)desc
             domain:(NSString *)domain;

@end

@protocol ServiceShareApiProtocol <NSObject>

@optional
- (BOOL)isExpired;
- (BOOL)isAuthorized;
- (void)authorize;
- (void)unauthorize;
- (void)saveAuthData:(id)authData;
- (void)removeAuthData;
- (void)restoreAuthData;
- (NSString *)authorizeURL;
@end

typedef void (^ServiceShareBlock)();
typedef void (^ServiceShareBlockError)( ServiceShareError * error );

@interface ServiceShareApi : BeeController <ServiceShareApiProtocol>

AS_NOTIFICATION( BEGIN )
AS_NOTIFICATION( CANCEL )
AS_NOTIFICATION( FAILURE )
AS_NOTIFICATION( SUCCESS )
AS_NOTIFICATION( AUTHORIZE_CANCEL )
AS_NOTIFICATION( AUTHORIZE_FAILURE )
AS_NOTIFICATION( AUTHORIZE_SUCCESS )

@property (nonatomic, retain) id sharer;
@property (nonatomic, assign) BOOL shouldEdit;

@property (nonatomic, copy) NSString * appKey;
@property (nonatomic, copy) NSString * appSecret;
@property (nonatomic, copy) NSString * redirectUri;

+ (NSDictionary *)dictionaryWtihURLString:(NSString *)string;
+ (NSString *)paramValueFromUrl:(NSString*)url paramName:(NSString *)paramName;

@end


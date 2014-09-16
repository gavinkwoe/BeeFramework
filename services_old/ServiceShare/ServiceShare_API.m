//
//  ServiceShare_API.m
//  ShareService
//
//  Created by QFish on 8/8/13.
//  Copyright (c) 2013 com.bee-framework. All rights reserved.
//

#import "ServiceShare_API.h"
#import "ServiceShare.h"

@implementation ServiceShareError

+ (id)errorWithCode:(NSNumber *)code desc:(NSString *)desc domain:(NSString *)domain
{
    ServiceShareError * error = [[[ServiceShareError alloc] init] autorelease];
    error.code = code;
    error.desc = desc;
    error.domain = domain;
    return error;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@;\n%@;\n%@", self.domain, self.desc, self.code];
}

@end

#pragma mark

@implementation ServiceShareApi

DEF_NOTIFICATION( BEGIN )
DEF_NOTIFICATION( CANCEL )
DEF_NOTIFICATION( FAILURE )
DEF_NOTIFICATION( SUCCESS )
DEF_NOTIFICATION( AUTHORIZE_CANCEL )
DEF_NOTIFICATION( AUTHORIZE_FAILURE )
DEF_NOTIFICATION( AUTHORIZE_SUCCESS )

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        [self observeNotification:[ServiceShare OPEN]];
        [self observeNotification:[ServiceShare CLOSE]];
    }
    
    return self;
}

- (void)dealloc
{
    [self unobserveAllNotifications];
    
    [super dealloc];
}

#pragma mark - uitls

+ (NSString *)paramValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

+ (NSDictionary *)dictionaryWtihURLString:(NSString *)string;
{
    NSString * paramsString = [[string componentsSeparatedByString:@"#"] safeObjectAtIndex:1];
    NSArray * pairs = [paramsString componentsSeparatedByString:@"&"];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
	
    for (NSString * pair in pairs)
    {
		NSArray * keyAndValue = [pair componentsSeparatedByString:@"="];
        
        if ( keyAndValue.count == 2 )
        {
            NSString * value =[[keyAndValue objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:value forKey:[keyAndValue objectAtIndex:0]];
        }
	}
    return params;
}

@end
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
//  BeeShareApi.m
//  BeeSNS
//
//  Created by QFish on 4/27/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "BeeShareApi.h"
#import "AuthorizeBoard.h"

#pragma mark -

@implementation BeeShareApi

DEF_NOTIFICATION( SIGNIN_DID_START )
DEF_NOTIFICATION( SIGNIN_DID_FAILED )
DEF_NOTIFICATION( SIGNIN_DID_CANCEL )
DEF_NOTIFICATION( SIGNIN_DID_SUCCESS )

+ (NSString *)authorizeUrl
{
    return nil;
}

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

+ (NSDictionary *)dictionaryWtihURLParams:(NSString *)query;
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *val =[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
	}
    return [params autorelease];
}

+ (NSDate *)dateWithString:(NSString *)dateTime
{
	NSDate *expirationDate = nil;
    
	if ( dateTime != nil )
    {
		int expVal = [dateTime intValue];
        
		if ( expVal == 0 )
        {
			expirationDate = [NSDate distantFuture];
		} else {
			expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
		}
	}
	return expirationDate;
}

- (id)initWithContext:(BeeUIBoard *)context
{
    self = [super init];
    if ( self )
    {
        [self setup];
        [self setContext:context];
    }
    return self;
}

- (void)login
{
    if ( [self isAuthValid] )
    {
        
    }
    else
    {
        [self logout];
        
        AuthorizeBoard * board = [[self.authorizeBoardClazz alloc] init];
        [board showIn:self.context.view];
    }
}

- (void)logout
{
    // clear cookies
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* sinaWeiboCookies = [cookies cookiesForURL:
                                 [NSURL URLWithString:[[self class] authorizeUrl]]];
    
    for (NSHTTPCookie* cookie in sinaWeiboCookies)
    {
        [cookies deleteCookie:cookie];
    }
}

- (BOOL)isAuthValid
{
    return ( [self isLogined] && ![self isExpired] );
}

@end

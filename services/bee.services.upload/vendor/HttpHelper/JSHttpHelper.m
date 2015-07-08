//
//  JSHttpHelper.m
//  UMan
//
//  Created by 王 正星 on 14-7-20.
//  Copyright (c) 2014年 zhengxing Wang. All rights reserved.
//

#import "JSHttpHelper.h"
#import "CJSONSerializer.h"
#import "ASIDownloadCache.h"
#import "ASIFormDataRequest.h"
#import "NSString+BeeExtension.h"

#define REQUEST_DEBUG 

@implementation JSHttpHelper

+ (ASIHTTPRequest *)post:(NSString *)url withJSONValue:(NSDictionary *)parma withDelegate:(id)delegate withUserInfo:(NSString *)userInfo
{
    if (!url) {
        return nil;
    }
#ifdef REQUEST_DEBUG
    NSLog(@"request post -》 %@",
          [[NSString alloc]initWithData:[[CJSONSerializer serializer] serializeDictionary:parma error:nil] encoding:NSUTF8StringEncoding]);
#endif
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[[CJSONSerializer serializer] serializeDictionary:parma error:nil]];
    [request setTimeOutSeconds:30];
    
    [request setDelegate:delegate];
    request.userInfo = [NSDictionary dictionaryWithObject:userInfo forKey:@"userInfo"];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidFinished:)];
    return request;
}

+ (ASIHTTPRequest *)post:(NSString *)url withValue:(NSDictionary *)parma withDelegate:(id)delegate withUserInfo:(NSString *)userInfo
{
    if (!url)
    {
        return nil;
    }
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    for (NSString *key in parma.allKeys) {
        [request setPostValue:[parma objectForKey:key] forKey:key];
    }
#ifdef REQUEST_DEBUG
    NSLog(@"request post -》 %@",url);
#endif

    [request setTimeOutSeconds:30];
    [request setDelegate:delegate];
    request.userInfo = [NSDictionary dictionaryWithObject:userInfo forKey:@"userInfo"];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidFinished:)];
    
    return request;
}

+ (ASIHTTPRequest *)get:(NSString *)url withValue:(NSDictionary *)parma withDelegate:(id)delegate withUserInfo:(NSString *)userInfo
{
    if (!url) {
        return nil;
    }
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    
    
    for (NSString *key in parma.allKeys) {
        //[request setValue:[parma objectForKey:key] forKey:[key asNSString]];
        NSString * base = [request.url absoluteString];

        NSString * query = request.url.query;
        NSString * params = [NSString queryStringFromKeyValues:key, [[parma objectForKey:key] asNSString], nil];
        NSURL * newURL = nil;
        
        if ( query.length )
        {
            newURL = [NSURL URLWithString:[base stringByAppendingFormat:@"&%@", params]];
        }
        else
        {
            newURL = [NSURL URLWithString:[base stringByAppendingFormat:@"?%@", params]];
        }
        
        if ( newURL )
        {
            [request setURL:newURL];
        }
    }
    
#ifdef REQUEST_DEBUG
    NSLog(@"request get:%@",request.url);
#endif

    
    [request setTimeOutSeconds:30];
    [request setDelegate:delegate];
    request.userInfo = [NSDictionary dictionaryWithObject:userInfo forKey:@"userInfo"];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidFinished:)];
    
    return request;
}

+ (ASIHTTPRequest *)post:(NSString *)url withValueDict:(NSDictionary *)parma withDataDict:(NSDictionary*)data withDelegate:(id)delegate withUserInfo:(NSString *)userInfo
{
    if (!url)
    {
        return nil;
    }
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    for (NSString *key in parma.allKeys) {
        [request setPostValue:[parma objectForKey:key] forKey:key];
    }
    [request setTimeOutSeconds:30];
    [request setDelegate:delegate];
    request.userInfo = [NSDictionary dictionaryWithObject:userInfo forKey:@"userInfo"];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidFinished:)];
    for (NSString *key in data.allKeys)
    {
        [request setData:[data objectForKey:key] withFileName:nil andContentType:@"application/octet-stream" forKey:key];
    }
    [request setShouldContinueWhenAppEntersBackground:YES];
    return request;
}

+ (ASIHTTPRequest*)post:(NSString*)url withValue:(NSDictionary*)parma withDelegate:(id)delegate withDict:(NSDictionary*)userInfo
{
    if (!url)
    {
        return nil;
    }
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    for (NSString *key in parma.allKeys) {
        [request setPostValue:[parma objectForKey:key] forKey:key];
    }
    [request setTimeOutSeconds:30];
    [request setDelegate:delegate];
    request.userInfo = userInfo;
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidFinished:)];
    [request setShouldContinueWhenAppEntersBackground:YES];
    return request;
}

+ (ASIHTTPRequest*)post:(NSString*)url withDataDict:(NSDictionary*)data withDelegate:(id)delegate withUserInfo:(NSDictionary*)userInfo
{
    if (!url)
    {
        return nil;
    }
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    for (NSString *key in data.allKeys)
    {
        [request setData:[data objectForKey:key] withFileName:nil andContentType:@"application/octet-stream" forKey:key];
    }
    [request setTimeOutSeconds:30];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setDelegate:delegate];
    request.userInfo = userInfo;
    request.showAccurateProgress = YES;
    request.uploadProgressDelegate = delegate;
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request setDidFinishSelector:@selector(requestDidFinished:)];
    return request;
}

- (void)requestDidFailed:(ASIHTTPRequest*)theRequest
{
    
}
- (void)requestDidFinished:(ASIHTTPRequest *)theRequest
{
    
}


@end

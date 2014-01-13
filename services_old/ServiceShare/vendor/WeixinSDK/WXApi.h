//
//  MMApi.h
//  ApiClient
//
//  Created by Tencent on 12-2-28.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApiObject.h"

#pragma mark - 
/*! @brief 接收并处理来至微信终端程序的事件消息
 *
 * 接收并处理来至微信终端程序的事件消息，期间微信界面会切换到第三方应用程序。
 * WXApiDelegate 会在handleOpenURL中使用并触发。
 */
@protocol WXApiDelegate <NSObject>

@optional

/*! @brief 收到一个来自微信的请求，处理完后调用sendResp
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req;

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp;

@end

#pragma mark -

/*! @brief 微信Api接口函数
 *
 * 该类封装了微信终端SDK的所有接口
 */
@interface WXApi : NSObject

/*! @brief WXApi的成员函数，在微信终端程序中注册第三方应用。
 *
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现。
 * @param appid 微信开发者ID
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) registerApp:(NSString *) appid;

/*! @brief 处理微信通过URL启动App时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 启动App的URL
 * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) handleOpenURL:(NSURL *) url delegate:(id<WXApiDelegate>) delegate;

/*! @brief 检查微信是否已被用户安装
 *
 * @return 微信已安装返回YES，未安装返回NO。
 */
+(BOOL) isWXAppInstalled;

/*! @brief 判断当前微信的版本是否支持OpenApi
 *
 * @return 支持返回YES，不支持返回NO。
 */
+(BOOL) isWXAppSupportApi;

/*! @brief 获取当前微信的版本所支持的API最高版本
 *
 * @return 返回微信支持的最高API版本号。
 */
+(NSString *) getWXAppSupportMaxApiVersion;

/*! @brief 获取当前微信SDK的版本号
 *
 * @return 返回当前微信SDK的版本号
 */
+(NSString *) getApiVersion;

/*! @brief 获取微信的itunes安装地址
 *
 * @return 微信的安装地址字符串。
 */
+(NSString *) getWXAppInstallUrl;

/*! @brief 打开微信
 *
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) openWXApp;

/*! @brief 发送请求到微信,等待微信返回onResp
 *
 * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。可能发送的请求有
 * SendMessageToWXReq、SendAuthReq等。
 * @param req 具体的发送请求，在调用函数后，请自己释放。
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) sendReq:(BaseReq*)req;

/*! @brief 收到微信onReq的请求，发送对应的应答给微信，并切换到微信界面
 *
 * 函数调用后，会切换到微信的界面。第三方应用程序收到微信onReq的请求，异步处理该请求，完成后必须调用该函数。可能发送的相应有
 * GetMessageFromWXResp、ShowMessageFromWXResp等。
 * @param resp 具体的应答内容，调用函数后，请自己释放
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) sendResp:(BaseResp*)resp;

@end
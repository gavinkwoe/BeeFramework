//
//  MMApiObject.h
//  ApiClient
//
//  Created by Tencent on 12-2-28.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////

enum  WXErrCode {
    WXSuccess           = 0,
    WXErrCodeCommon     = -1,
    WXErrCodeUserCancel = -2,
    WXErrCodeSentFail   = -3,
    WXErrCodeAuthDeny   = -4,
    WXErrCodeUnsupport  = -5,
};

enum WXScene {
  
    WXSceneSession   = 0, 
    WXSceneTimeline = 1,
};

enum WXAPISupport {
  
    WXAPISupportSession = 0,
};

/*! @brief 该类为微信终端SDK所有请求类的基类
 *
 */
@interface BaseReq : NSObject

/** 请求类型 */
@property (nonatomic, assign) int type;

@end

/*! @brief 该类为微信终端SDK所有响应类的基类
 *
 */
@interface BaseResp : NSObject
/** 错误码 */
@property (nonatomic, assign) int errCode;
/** 错误提示字符串 */
@property (nonatomic, retain) NSString *errStr;
/** 响应类型 */
@property (nonatomic, assign) int type;

@end


@class WXMediaMessage;
/*! @brief 第三方程序发送消息至微信终端程序的消息结构体
 *
 * 第三方程序向微信发送信息需要传入SendMessageToWXReq结构体，信息类型包括文本消息和多媒体消息，
 * 分别对应于text和message成员。调用该方法后，微信处理完信息会向第三方程序发送一个处理结果。
 * @see SendMessageToWXResp
 */
@interface SendMessageToWXReq : BaseReq
/** 发送消息的文本内容
 * @note 文本长度必须大于0且小于10K 
 */
@property (nonatomic, retain) NSString* text;
/** 发送消息的多媒体内容
 * @see WXMediaMessage
 */
@property (nonatomic, retain) WXMediaMessage* message;
/** 发送消息的类型，包括文本消息和多媒体消息两种，两者只能选择其一，不能同时发送文本和多媒体消息 */
@property (nonatomic, assign) BOOL bText;

/** 发送的目标场景， 可以选择发送到会话(WXSceneSession)或者朋友圈(WXSceneTimeline)。 默认发送到会话。
 * @see WXScene
 */
@property (nonatomic, assign) int scene;

@end

/*! @brief 微信终端向第三方程序返回的SendMessageToWXReq处理结果。
 *
 * 第三方程序向微信终端发送SendMessageToWXReq后，微信发送回来的处理结果，该结果用SendMessageToWXResp表示。
 */
@interface SendMessageToWXResp : BaseResp
@end


/*! @brief 第三方程序向微信终端请求认证的消息结构
 *
 * 第三方程序要向微信申请认证，并请求某些权限，需要调用WXApi的sendReq成员函数，
 * 向微信终端发送一个SendAuthReq消息结构。微信终端处理完后会向第三方程序发送一个处理结果。
 * @see SendAuthResp
 */
@interface SendAuthReq : BaseReq
/** 第三方程序要向微信申请认证，并请求某些权限，需要调用WXApi的sendReq成员函数，向微信终端发送一个SendAuthReq消息结构。微信终端处理完后会向第三方程序发送一个处理结果。 
 * @see SendAuthResp
 * @note scope字符串长度不能超过1K
 */
@property (nonatomic, retain) NSString* scope;
/** 第三方程序本身用来标识其请求的唯一性，最后跳转回第三方程序时，由微信终端回传。 
 * @note state字符串长度不能超过1K
 */
@property (nonatomic, retain) NSString* state;
@end

/*! @brief 微信处理完第三方程序的认证和权限申请后向第三方程序回送的处理结果。
 *
 * 第三方程序要向微信申请认证，并请求某些权限，需要调用WXApi的sendReq成员函数，向微信终端发送一个SendAuthReq消息结构。
 * 微信终端处理完后会向第三方程序发送一个SendAuthResp。
 * @see onResp
 */
@interface SendAuthResp : BaseResp
/** 用户名 */
@property (nonatomic, retain) NSString* userName;
/** 认证口令 */
@property (nonatomic, retain) NSString* token;
/** 认证过期时间 */
@property (nonatomic, retain) NSDate* expireDate;
/** 第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传 
 * @note state字符串长度不能超过1K
 */
@property (nonatomic, retain) NSString* state; 
@end


/*! @brief 微信终端向第三方程序请求提供内容的消息结构体。
 *
 * 微信终端向第三方程序请求提供内容，微信终端会向第三方程序发送GetMessageFromWXReq消息结构体，
 * 需要第三方程序调用sendResp返回一个GetMessageFromWXResp消息结构体。
 */
@interface GetMessageFromWXReq : BaseReq
@end

/*! @brief 微信终端向第三方程序请求提供内容，第三方程序向微信终端返回的消息结构体。
 *
 * 微信终端向第三方程序请求提供内容，第三方程序调用sendResp向微信终端返回一个GetMessageFromWXResp消息结构体。
 */
@interface GetMessageFromWXResp : BaseResp
/** 向微信终端提供的文本内容
 @note 文本长度必须大于0且小于10K
 */
@property (nonatomic, retain) NSString* text;
/** 向微信终端提供的多媒体内容。
 * @see WXMediaMessage
 */
@property (nonatomic, retain) WXMediaMessage* message;
/** 向微信终端提供内容的消息类型，包括文本消息和多媒体消息两种，两者只能选择其一，不能同时发送文本和多媒体消息 */
@property (nonatomic, assign) BOOL bText;
@end

/*! @brief 微信通知第三方程序，要求第三方程序显示的消息结构体。
 *
 * 微信需要通知第三方程序显示或处理某些内容时，会向第三方程序发送ShowMessageFromWXReq消息结构体。
 * 第三方程序处理完内容后调用sendResp向微信终端发送ShowMessageFromWXResp。
 */
@interface ShowMessageFromWXReq : BaseReq
/** 微信终端向第三方程序发送的要求第三方程序处理的多媒体内容 
 * @see WXMediaMessage
 */
@property (nonatomic, retain) WXMediaMessage* message;
@end

/*! @brief 微信通知第三方程序，要求第三方程序显示或处理某些消息，第三方程序处理完后向微信终端发送的处理结果。
 *
 * 微信需要通知第三方程序显示或处理某些内容时，会向第三方程序发送ShowMessageFromWXReq消息结构体。
 * 第三方程序处理完内容后调用sendResp向微信终端发送ShowMessageFromWXResp。
 */
@interface ShowMessageFromWXResp : BaseResp
@end


#pragma mark - WXMediaMessage

/*! @brief 多媒体消息结构体
 * 
 * 用于微信终端和第三方程序之间传递消息的多媒体消息内容
 */
@interface WXMediaMessage : NSObject

+(WXMediaMessage *) message;

/** 标题 
 * @note 长度不能超过512字节
 */
@property (nonatomic, retain) NSString *title;
/** 描述内容 
 * @note 长度不能超过1K
 */
@property (nonatomic, retain) NSString *description;
/** 缩略图数据 
 * @note 大小不能超过32K
 */
@property (nonatomic, retain) NSData   *thumbData;
/** 多媒体数据对象，可以为WXWebpageObject，WXImageObject，WXMusicObject等。 */
@property (nonatomic, retain) id        mediaObject;

/*! @brief 设置消息缩略图的方法
 *
 * @param image 缩略图
 * @note 大小不能超过32K
 */
- (void) setThumbImage:(UIImage *)image;

@end


#pragma mark -
/*! @brief 多媒体消息中包含的图片数据对象
 *
 * 微信终端和第三方程序之间传递消息中包含的图片数据对象。
 * @note imageData和imageUrl成员不能同时为空
 * @see WXMediaMessage
 */
@interface WXImageObject : NSObject
/*! @brief 返回一个WXImageObject对象
 *
 * @note 返回的WXImageObject对象是自动释放的
 */
+(WXImageObject *) object;

/** 图片真实数据内容 
 * @note 大小不能超过10M
 */
@property (nonatomic, retain) NSData    *imageData;
/** 图片url 
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString  *imageUrl;

@end

/*! @brief 多媒体消息中包含的音乐数据对象
 *
 * 微信终端和第三方程序之间传递消息中包含的音乐数据对象。
 * @note musicUrl和musicLowBandUrl成员不能同时为空。
 * @see WXMediaMessage
 */
@interface WXMusicObject : NSObject
/*! @brief 返回一个WXMusicObject对象
 *
 * @note 返回的WXMusicObject对象是自动释放的
 */
+(WXMusicObject *) object;

/** 音乐网页的url地址 
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicUrl;
/** 音乐lowband网页的url地址 
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicLowBandUrl;
/** 音乐数据url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicDataUrl;

/**音乐lowband数据url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicLowBandDataUrl;

@end

/*! @brief 多媒体消息中包含的视频数据对象
 *
 * 微信终端和第三方程序之间传递消息中包含的视频数据对象。
 * @note videoUrl和videoLowBandUrl不能同时为空。
 * @see WXMediaMessage
 */
@interface WXVideoObject : NSObject
/*! @brief 返回一个WXVideoObject对象
 *
 * @note 返回的WXVideoObject对象是自动释放的
 */
+(WXVideoObject *) object;

/** 视频网页的url地址 
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *videoUrl;
/** 视频lowband网页的url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *videoLowBandUrl;

@end

/*! @brief 多媒体消息中包含的网页数据对象
 *
 * 微信终端和第三方程序之间传递消息中包含的网页数据对象。
 * @see WXMediaMessage
 */
@interface WXWebpageObject : NSObject
/*! @brief 返回一个WXWebpageObject对象
 *
 * @note 返回的WXWebpageObject对象是自动释放的
 */
+(WXWebpageObject *) object;

/** 网页的url地址 
 * @note 不能为空且长度不能超过10K
 */
@property (nonatomic, retain) NSString *webpageUrl;

@end

/*! @brief 多媒体消息中包含的App扩展数据对象
 *
 * 第三方程序向微信终端发送包含WXAppExtendObject的多媒体消息，
 * 微信需要处理该消息时，会调用该第三方程序来处理多媒体消息内容。
 * @note url，extInfo和fileData不能同时为空
 * @see WXMediaMessage
 */
@interface WXAppExtendObject : NSObject
/*! @brief 返回一个WXAppExtendObject对象
 *
 * @note 返回的WXAppExtendObject对象是自动释放的
 */
+(WXAppExtendObject *) object;

/** 若第三方程序不存在，微信终端会打开该url所指的App下载地址 
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *url;
/** 第三方程序自定义简单数据，微信终端会回传给第三方程序处理 
 * @note 长度不能超过2K
 */
@property (nonatomic, retain) NSString *extInfo;
/** App文件数据，该数据发送给微信好友，微信好友需要点击后下载数据，微信终端会回传给第三方程序处理 
 * @note 大小不能超过10M
 */
@property (nonatomic, retain) NSData   *fileData;

@end

/*! @brief 多媒体消息中包含的表情数据对象
 *
 * 微信终端和第三方程序之间传递消息中包含的表情数据对象。
 * @see WXMediaMessage
 */
@interface WXEmoticonObject : NSObject

/*! @brief 返回一个WXEmoticonObject对象
 *
 * @note 返回的WXEmoticonObject对象是自动释放的
 */
+(WXEmoticonObject *) object;

/** 表情真实数据内容 
 * @note 大小不能超过10M
 */
@property (nonatomic, retain) NSData    *emoticonData;

@end



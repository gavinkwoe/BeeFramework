//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "Bee_Precompile.h"
#import "Bee_Package.h"
#import "Bee_Singleton.h"

#define MODEL_QUEUE_DEBUG_ 1
#define UPYUN_UAD_DEBUG_ 1

#pragma mark Model

typedef void (^BeeQueueModelProgress)( CGFloat );
typedef void (^BeeQueueModelInfo)( NSString * );

/*!
 队列中单个数据处理状态
 */
typedef enum E_QueueModelState
{
    QUEUE_DATA_WAIT = 0, // 等待处理
    QUEUE_DATA_RUNING, // 正在处理
    QUEUE_DATA_FINISH, // 处理完成
    QUEUE_DATA_FAILED, // 处理失败
    QUEUE_DATA_PAUSE, // 暂停处理
    QUEUE_DATA_REMOVE // 删除
    
}EQueueModelState;

/*!
 队列中单个数据操作类型
 */
typedef enum E_QueueModeAction
{
    QUEUE_MODEL_UPLOAD = 0, // 上传
    QUEUE_MODEL_DOWNLOAD // 下载
}EQueueModeAction;

/*!
 上传：整块上传、分块上传
 */
typedef enum E_ModelUploadMethod
{
    QUEUE_MODEL_UPLOAD_ALL = 0, // 整
    QUEUE_MODEL_UPLOAD_BLOCK, // 分块
    QUEUE_MODEL_DOWN_METHOD
}EModelUploadMethod;

@interface BeeQueueModel : BeeModel
@property (nonatomic, readonly) NSString * key;
@property (atomic, readonly) EQueueModelState state;
@property (atomic, readonly) CGFloat progress;

@property (nonatomic, strong) NSData * data;
@property (nonatomic, strong) NSString * local;  // 如果该属性被设置，data属性可以不用设置。
@property (nonatomic, strong) NSString * server; // 如果该属性没有被设置，默认为UPY服务器
@property (nonatomic, strong) NSString * path; // 服务器的目录
@property (nonatomic, strong) NSString * visit; // 访问地址
@property (nonatomic, assign) EQueueModeAction action;
@property (nonatomic, assign) EModelUploadMethod method;
@property (nonatomic, assign) NSUInteger maxCountOfOperator;

@property (nonatomic, copy) BeeQueueModelProgress whenUpdate;
@property (nonatomic, copy) BeeQueueModelInfo whenSucced;
@property (nonatomic, copy) BeeQueueModelInfo whenFailed;

/*!
 *	@author venking, 2015-07-24 10:07:16
 *
 *	运用本地路径进行队列模型初始化
 *
 *	@param local	本地路径
 *	@param server	服务器地址
 *	@param path		服务器路径
 *	@param action	操作类型（上传、下载）
 *	@param method	操作方式（整块、分块）
 *	@param access	存取地址（上传完成后，可以访问的地址）
 *
 *	@return 对象实例
 */
- (id) initWithLocal:(NSString *)local
              server:(NSString *)server
                path:(NSString *)path
              action:(EQueueModeAction)action
              method:(EModelUploadMethod)method
              access:(NSString *)access;

/*!
 *	@author venking, 2015-07-24 10:07:58
 *
 *	运用二进制进行队列模型初始化
 *
 *	@param data		二进制数据
 *	@param server	服务器地址
 *	@param path		服务器路径
 *	@param action	操作类型
 *	@param method	操作方式
 *	@param access	存取地址
 *
 *	@return 对象实例
 */
- (id) initWithData:(NSData *)data
             server:(NSString *)server
               path:(NSString *)path
             action:(EQueueModeAction)action
             method:(EModelUploadMethod)method
             access:(NSString *)access;

/*!
 *	@author venking, 2015-07-24 10:07:43
 *
 *	改变数据模型的运行状态
 *
 *	@param eState	下一状态
 *
 *	@return 模型的唯一健
 */
- (NSString *) changeState:(EQueueModelState) eState;

/*!
 *	@author venking, 2015-07-24 10:07:37
 *
 *	当前数据处理进度
 *
 *	@param progress	进度
 */
- (void) setProgress:(CGFloat)progress;

/*!
 *	@author venking, 2015-07-24 10:07:05
 *
 *	暂停数据运行
 */
- (void) pauseModel;

/*!
 *	@author venking, 2015-07-24 10:07:17
 *
 *	将暂停的重新启动
 */
- (void) runModel;
@end


AS_PACKAGE( BeePackage, BeeQueue, queue );

@interface BeeQueue : NSObject

AS_SINGLETON( BeeQueue )

#undef DATA_IS_NULL
#define DATA_IS_NULL -1

/*!
 *	@author venking, 2015-07-24 10:07:45
 *
 *	向指定队列中放入数据。
 *
 *	@param data	需要存放的数据
 *	@param queue	 数据所属队列名
 *
 *	@return 数据在队列中的唯一 KEY
 */
+ (NSString *) putData:(BeeQueueModel *)data byQueue:(NSString *)queue;

/*!
 *	@author venking, 2015-07-24 10:07:53
 *
 *	获取指定队列中的第一个数据
 *
 *	@param queue	数据所属队列名
 *
 *	@return 队列的第一个数据
 */
+ (BeeQueueModel *) getFirstDataByQueue:(NSString *)queue;

/*!
 *	@author venking, 2015-07-24 10:07:24
 *
 *	从指定队列中删除数据
 *
 *	@param key		存放数据时返回的 唯一 KEY
 *	@param queue	数据所属队列名
 *
 *	@return 成功 YES，失败 NO
 */
+ (BOOL) removeKey:(NSString *)key ofQueue:(NSString *)queue;

/*!
 *	@author venking, 2015-07-24 10:07:18
 *
 *	获取指定队列中所有数据
 *
 *	@param queue	数据所属队列名
 *
 *	@return 整个队列
 */
+ (NSArray *) getQueue:(NSString *)queue;

/*!
 *	@author venking, 2015-07-24 10:07:57
 *
 *	获取指定队列中所有数据
 *
 *	@param queue	数据所属队列名
 *	@param state	目标状态
 *
 *	@return 满足条件的所有数据
 */
+ (NSArray *) getQueue:(NSString *)queue isState:(EQueueModelState)state;

/*!
 *	@author venking, 2015-07-24 10:07:36
 *
 *	将指定队列的某个数据从使用状态转换为暂停状态
 *
 *	@param key		存放数据时返回的 唯一 KEY
 *	@param queue    数据所属队列名
 *
 *	@return YES : 暂停成功; NO : 操作失败
 */
+ (BOOL) pauseKey:(NSString *)key ofQueue:(NSString *)queue;

/*!
 *	@author venking, 2015-07-24 10:07:10
 *
 *	将指定队列的某个数据从使用状态转换为成功状态，并从队列中删除
 *
 *	@param key		存放数据时返回的 唯一 KEY
 *	@param queue	数据所属队列名
 *
 *	@return YES : 暂停成功; NO : 操作失败
 */
+ (BOOL) successKey:(NSString *)key ofQueue:(NSString *)queue;

/*!
 *	@author venking, 2015-07-24 10:07:55
 *
 *	将指定队列的某个数据从使用状态转换为失败状态，并从队列中删除
 *
 *	@param key		存放数据时返回的 唯一 KEY
 *	@param queue	数据所属队列名
 *
 *	@return YES : 暂停成功; NO : 操作失败
 */
+ (BOOL) failedKey:(NSString *)key ofQueue:(NSString *)queue;

/*!
 *	@author venking, 2015-07-24 10:07:22
 *
 *	将指定队列的某个数据从使用状态转换为待处理状态
 *
 *	@param key		存放数据时返回的 唯一 KEY
 *	@param queue	数据所属队列名
 *
 *	@return YES : 暂停成功; NO : 操作失败
 */
+ (BOOL) waitKey:(NSString *)key ofQueue:(NSString *)queue;
@end

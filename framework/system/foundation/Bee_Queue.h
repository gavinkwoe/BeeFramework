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

typedef enum E_QueueModelState
{
    QUEUE_DATA_WAIT = 0, // 等待处理
    QUEUE_DATA_RUNING, // 正在处理
    QUEUE_DATA_FINISH, // 处理完成
    QUEUE_DATA_FAILED, // 处理失败
    QUEUE_DATA_PAUSE, // 暂停处理
    QUEUE_DATA_REMOVE // 删除
    
}EQueueModelState;

typedef enum E_QueueModeAction
{
    QUEUE_MODEL_UPLOAD = 0, // 上传
    QUEUE_MODEL_DOWNLOAD // 下载
}EQueueModeAction;

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

// required
@property (nonatomic, strong) NSData * data;
@property (nonatomic, strong) NSString * serverPath;
@property (nonatomic, assign) EQueueModeAction action;
@property (nonatomic, assign) EModelUploadMethod method;
@property (nonatomic, assign) NSUInteger maxCountOfOperator;
// optional
@property (nonatomic, strong) NSString * url; // 如果该属性没有被设置，默认为UPY服务器
@property (nonatomic, strong) NSString * localPath;  // 如果该属性被设置，data属性可以不用设置。

@property (nonatomic, copy) BeeQueueModelProgress whenProgress;

- (id) initWithLocal:(NSString *)local server:(NSString *)server action:(EQueueModeAction)action method:(EModelUploadMethod)method;
- (id) initWithData:(NSData *)data server:(NSString *)server action:(EQueueModeAction)action method:(EModelUploadMethod)method;
- (NSString *) changeState:(EQueueModelState) eState;

- (void) pauseModel;
- (void) runModel;
@end


AS_PACKAGE( BeePackage, BeeQueue, queue );

@interface BeeQueue : NSObject

AS_SINGLETON( BeeQueue )

#undef DATA_IS_NULL
#define DATA_IS_NULL -1

/* 
 向指定队列中放入数据。
 参数：
    data -- 需要存放的数据
    queue -- 数据所属队列名
 返回值：数据在队列中的唯一 KEY。
 */
+ (NSString *) putData:(BeeQueueModel *)data byQueue:(NSString *)queue;

/*
 获取指定队列中的第一个数据。
 参数：
 queue -- 数据所属队列名
 返回值：队列的第一个数据。
 */
+ (BeeQueueModel *) getFirstDataByQueue:(NSString *)queue;

/*
 从指定队列中删除数据。
 参数：
 queue -- 数据所属队列名
 key -- 存放数据时返回的 唯一 KEY
 返回值：被删除的数据
 */
+ (BOOL) removeKey:(NSString *)key ofQueue:(NSString *)queue;

/*
 获取指定队列中所有数据。
 参数：
 queue -- 数据所属队列名
 返回值： 所有数据。
 */
+ (NSArray *) getQueue:(NSString *)queue;

/*
 获取指定队列中所有数据。
 参数：
 queue -- 数据所属队列名
 state -- 目标状态
 返回值：满足条件的所有数据。
*/
+ (NSArray *) getQueue:(NSString *)queue isState:(EQueueModelState)state;

/*
 将指定队列的某个数据从使用状态转换为等候状态。
 参数：
 queue -- 数据所属队列名
 key -- 存放数据时返回的 唯一 KEY
 返回值：YES : 暂停成功; NO : 操作失败。
 */
+ (BOOL) pauseKey:(NSString *)key ofQueue:(NSString *)queue;

+ (BOOL) successKey:(NSString *)key ofQueue:(NSString *)queue;

+ (BOOL) failedKey:(NSString *)key ofQueue:(NSString *)queue;

+ (BOOL) waitKey:(NSString *)key ofQueue:(NSString *)queue;
@end

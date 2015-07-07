#import "Bee_Queue.h"
#import "Bee_UnitTest.h"

#pragma mark Model


@interface BeeQueueModel()
{
}
@end

@implementation BeeQueueModel

- (id) initWithPathOfLocal:(NSString *)local andServer:(NSString *)server
{
    if (self = [super init])
    {
        self.data = nil;
        self.key = [local MD5];
        self.state = QUEUE_DATA_WAIT;
        self.serverPath = server;
        self.localPath = local;
        self.name = [local MD5];
        self.progress = 0.0f;
    }
    return self;
}

- (NSString *) changeState:(EQueueModelState) eState
{
    if (self.state == eState)
    {
        return self.key;
    }
    
    if (QUEUE_DATA_REMOVE == eState && QUEUE_DATA_WAIT != self.state && QUEUE_DATA_PAUSE != self.state)
    {
        return nil;
    }
    
    self.state = eState;
    return self.key;
}

- (BOOL) compare:(BeeQueueModel *)model
{
    if (self == model)
    {
        return YES;
    }
    
    if (NSOrderedSame == [self.key compare:model.key options:NSLiteralSearch])
    {
        return YES;
    }
    
    return NO;
}

@end


DEF_PACKAGE( BeePackage, BeeQueue, queue );

#pragma mark BeeQueue

@interface BeeQueue()
{
    NSMutableDictionary * m_activatedPool;
    NSMutableDictionary * m_notActivatedPool;
  
    // NSLock * m_optLock;
    NSCondition * m_optLock;
    NSCondition * m_haveLock;
}
@end

@implementation BeeQueue

DEF_SINGLETON( BeeQueue )

- (id) init
{
    self = [super init];
    if (self)
    {
        m_notActivatedPool = [[NSMutableDictionary alloc] init];
        m_activatedPool = [[NSMutableDictionary alloc] init];

        // m_optLock = [[NSLock alloc] init];
        m_optLock = [[NSCondition alloc] init];
        m_haveLock = [[NSCondition alloc] init];
    }
    return self;
}

- (NSInteger) putModel:(BeeQueueModel *)model ofQueue:(NSString *)queue toPool:(NSMutableDictionary *)pool
{
    NSInteger count = 0;
    {
        NSMutableArray * datas = [pool objectForKey:queue];
        if (nil == datas)
        {
            datas = [[NSMutableArray alloc] init];
            [pool setObject:datas forKey:queue];
        }
        
        [datas addObject:model];
        count = datas.count;
    }
    
    return count;
}

- (NSString *) putData:(BeeQueueModel *)data byQueue:(NSString *)queue
{
    if (!data)
    {
        return nil;
    }
    
    if (!data.localPath || !data.serverPath || 0 == data.localPath.length || 0 == data.serverPath.length)
    {
        return @"源路径|目标路径 不能为空!";
    }
    
    [m_optLock lock];
    NSString * key = nil;
    {
        key = data.key;
        [data changeState:QUEUE_DATA_WAIT];
        [self putModel:data ofQueue:queue toPool:m_notActivatedPool];
    }
    [m_optLock signal];
    [m_optLock unlock];
    
    return key;
}

+ (NSString *) putData:(BeeQueueModel *)data byQueue:(NSString *)queue
{
    if (![data isKindOfClass:[BeeQueueModel class]])
    {
        return nil;
    }
    return [[BeeQueue sharedInstance] putData:data byQueue:queue ];
}

- (BeeQueueModel *) getFirstDataByQueue:(NSString *)queue
{
    [m_optLock lock];
    
    NSMutableArray * datas = [m_notActivatedPool objectForKey:queue];
    if (nil == datas)
    {
        [m_optLock unlock];
        return nil;
    }
    
    if (0 == datas.count)
    {
        [m_optLock unlock];
        return nil;
    }
    
    BeeQueueModel * model = nil;
    for (NSInteger index = 0; index < datas.count; ++index)
    {
        BeeQueueModel * temp = datas[index];
        if (QUEUE_DATA_WAIT == temp.state)
        {
            INFO(@" INDEX ---- %i", index);

            [temp changeState:QUEUE_DATA_RUNING];
            
            // 暂时不用两个队列
            // [self putModel:temp ofQueue:queue toPool:m_activatedPool];
            
            // [datas removeObjectAtIndex:index];
            
            model = temp;
            break;
        }
    }
    if (!model)
    {
        INFO(@"WAITING ··· ···");
        [m_optLock wait];
    }
    [m_optLock unlock];

    return model;
}

+ (BeeQueueModel *) getFirstDataByQueue:(NSString *)queue
{
    return [[BeeQueue sharedInstance] getFirstDataByQueue:queue];
}

- (NSArray *) getQueue:(NSString *)queue isState:(EQueueModelState)state
{
    [m_optLock lock];
    NSMutableArray * pool = [m_notActivatedPool objectForKey:queue];
    NSMutableArray * datas = [[NSMutableArray alloc] init];
    for (BeeQueueModel * model in pool)
    {
        if (model.state == state)
        {
            [datas addObject:model];
        }
    }
    [m_optLock unlock];
    return [datas copy];
}

+ (NSArray *) getQueue:(NSString *)queue isState:(EQueueModelState)state
{
    return [[BeeQueue sharedInstance] getQueue:queue isState:state];
}

- (NSArray *) getQueue:(NSString *)queue
{
    [m_optLock lock];
    NSMutableArray * datas = [m_notActivatedPool objectForKey:queue];
    [m_optLock unlock];
    return [datas copy];
}

+ (NSArray *) getQueue:(NSString *)queue
{
    return [[BeeQueue sharedInstance] getQueue:queue];
}

- (NSUInteger) findKey:(NSString *)key fromDatas:(NSMutableArray *)datas
{
    NSUInteger index = 0;
    for (BeeQueueModel * model in datas)
    {
        if (NSOrderedSame == [key compare:model.key options:NSLiteralSearch])
        {
            break;
        }
        ++index;
    }
    if (datas.count <= index || NSNotFound == index)
    {
        return NSNotFound;
    }
    return index;
}

- (BOOL) removeKey:(NSString *)key ofQueue:(NSString *)queue
{
    [m_optLock lock];
    
    NSMutableArray * datas = [m_notActivatedPool objectForKey:queue];
    if (nil == datas)
    {
        [m_optLock unlock];
        return YES;
    }
    
    if (0 == datas.count)
    {
        [m_optLock unlock];
        return YES;
    }
    
    NSInteger index = [self findKey:key fromDatas:datas];
    if (NSNotFound == index)
    {
        [m_optLock unlock];
        return YES;
    }
    
    [datas removeObjectAtIndex:index];
    
    [m_optLock unlock];

    return YES;
}

+ (BOOL) removeKey:(NSString *)key ofQueue:(NSString *)queue
{
  return [[BeeQueue sharedInstance] removeKey:key ofQueue:queue];
}

- (BOOL) pauseKey:(NSString *)key ofQueue:(NSString *)queue
{
    [m_optLock lock];
    NSMutableArray * datas = [m_notActivatedPool objectForKey:queue];
    if (nil == datas)
    {
        [m_optLock unlock];
        return 0;
    }
    if (0 == datas.count)
    {
        [m_optLock unlock];
        return 0;
    }
    
    NSInteger index = [self findKey:key fromDatas:datas];
    if (NSNotFound != index)
    {
        BeeQueueModel * model = datas[index];
        
        [model changeState:QUEUE_DATA_PAUSE];
        
        // [self putModel:model ofQueue:queue toPool:m_notActivatedPool];
        // [datas removeObjectAtIndex:index];
    }
    
    [m_optLock unlock];
    
    return YES;
}

+ (BOOL) pauseKey:(NSString *)key ofQueue:(NSString *)queue
{
    return [[BeeQueue sharedInstance] pauseKey:key ofQueue:queue];
}

- (BOOL) successKey:(NSString *)key ofQueue:(NSString *)queue
{
    [m_optLock lock];
    NSMutableArray * datas = [m_notActivatedPool objectForKey:queue];
    if (nil == datas)
    {
        [m_optLock unlock];
        return 0;
    }
    if (0 == datas.count)
    {
        [m_optLock unlock];
        return 0;
    }
    
    NSInteger index = [self findKey:key fromDatas:datas];
    if (NSNotFound != index)
    {
        BeeQueueModel * model = datas[index];
        
        [model changeState:QUEUE_DATA_FINISH];
        
        // [self putModel:model ofQueue:queue toPool:m_notActivatedPool];
        [datas removeObjectAtIndex:index];
    }
    [m_optLock unlock];
    
    return YES;
}

+ (BOOL) successKey:(NSString *)key ofQueue:(NSString *)queue
{
    return [[BeeQueue sharedInstance] successKey:key ofQueue:queue];
}

- (BOOL) failedKey:(NSString *)key ofQueue:(NSString *)queue
{
    [m_optLock lock];
    NSMutableArray * datas = [m_notActivatedPool objectForKey:queue];
    if (nil == datas)
    {
        [m_optLock unlock];
        return 0;
    }
    if (0 == datas.count)
    {
        [m_optLock unlock];
        return 0;
    }
    
    NSInteger index = [self findKey:key fromDatas:datas];
    if (NSNotFound != index)
    {
        BeeQueueModel * model = datas[index];
        
        [model changeState:QUEUE_DATA_FAILED];
        
        // [self putModel:model ofQueue:queue toPool:m_notActivatedPool];
        [datas removeObjectAtIndex:index];
    }
    [m_optLock unlock];
    
    return YES;
}

+ (BOOL) failedKey:(NSString *)key ofQueue:(NSString *)queue
{
    return [[BeeQueue sharedInstance] failedKey:key ofQueue:queue];
}

- (BOOL) waitKey:(NSString *)key ofQueue:(NSString *)queue
{
    [m_optLock lock];
    NSMutableArray * datas = [m_notActivatedPool objectForKey:queue];
    if (nil == datas)
    {
        [m_optLock unlock];
        return 0;
    }
    if (0 == datas.count)
    {
        [m_optLock unlock];
        return 0;
    }
    
    NSInteger index = [self findKey:key fromDatas:datas];
    if (NSNotFound != index)
    {
        BeeQueueModel * model = datas[index];
        
        [model changeState:QUEUE_DATA_WAIT];
        
        // [self putModel:model ofQueue:queue toPool:m_notActivatedPool];
        // [datas removeObjectAtIndex:index];
    }
    [m_optLock unlock];
    
    return YES;
}

+ (BOOL) waitKey:(NSString *)key ofQueue:(NSString *)queue
{
    return [[BeeQueue sharedInstance] waitKey:key ofQueue:queue];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( BeeQueue )
{
  
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

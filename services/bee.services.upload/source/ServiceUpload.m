//
//  BeeUpload.m
//  BabyunCore
//
//  Created by venking on 15/6/11.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "ServiceUpload.h"
#import "FileUploadMessage.h"
#import "UPYHTTPRequest.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@interface ServiceUpload()
{
    NSOperationQueue * m_queue;
}
@end

#pragma mark -

@implementation ServiceUpload

DEF_SINGLETON( ServiceUpload )

SERVICE_AUTO_LOADING( YES );
SERVICE_AUTO_POWERON( YES )

// DEF_INT( ERROR_SUCCEED,		9000 )

// DEF_NOTIFICATION( WAITING )

- (void)load
{
    if (!m_queue)
    {
        m_queue = [[NSOperationQueue alloc] init];
    }
}

- (void)unload
{
}

#pragma mark -

- (void)powerOn
{

}

- (void)powerOff
{
}

- (void)serviceWillActive
{
}

- (void)serviceDidActived
{
    // [self singleUpload];
    [self multiUpload];
}

- (void)serviceWillDeactive
{
}

- (void)serviceDidDeactived
{
}

- (void) singleUpload
{
    // NSBlockOperation * block = [NSBlockOperation blockOperationWithBlock:^{
    // BACKGROUND_BEGIN
    {
        FileUploadMessage * uploadMesage = [[FileUploadMessage alloc] init];
        [uploadMesage  routine];
    }
    // BACKGROUND_COMMIT
    // }];
    // [m_queue addOperation:block];
}

- (void) multiUpload
{
    BACKGROUND_BEGIN
    {
        [UPYHTTPRequest run];
    }
    BACKGROUND_COMMIT
}

#pragma mark -

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
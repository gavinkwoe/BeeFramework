//
//  BeeUpload.h
//  BabyunCore
//
//  Created by venking on 15/6/11.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "Bee.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface ServiceUpload : BeeService

AS_SINGLETON( ServiceUpload )

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
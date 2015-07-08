//
//  bee.serivce.h
//  BabyunCore
//
//  Created by venking on 15/6/12.
//  Copyright (c) 2015年 babyun. All rights reserved.
//

#import "Bee.h"
#import "ServiceUpload.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

AS_SERVICE( ServiceUpload, upload )

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

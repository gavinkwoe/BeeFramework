//
//  ServiceLiveload_Watcher.h
//  dribbble
//
//  Created by QFish on 2/10/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#if (TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)

#import <Foundation/Foundation.h>

@interface ServiceLiveload_Watcher : NSObject

AS_SINGLETON( ServiceLiveload_Watcher );

+ (void)setWatcher:(id)watcher path:(NSString *)path forKey:(NSString *)key;
+ (void)removeWatcher:(id)watcher forKey:(NSString *)key;

@end

#endif  // #if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)`
#endif  // #if (TARGET_IPHONE_SIMULATOR)

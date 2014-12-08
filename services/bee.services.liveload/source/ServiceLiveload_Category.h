//
//  ServiceLiveload_Category.h
//  dribbble
//
//  Created by QFish on 2/10/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#if (TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)

@interface NSObject (ServiceLiveload)

@property (nonatomic, retain) NSNumber * shouldReload;

- (void)liveload_reloadWithObject:(id)obj;
- (void)liveload_reloadDefaultStlye;

@end

@interface UIView (ServiceLiveload)

- (void)markShouldReload:(BOOL)shouldReload;

- (NSObject *)liveload_responder;
- (NSString *)liveload_path;
- (NSString *)liveload_pathKey;

@end

#endif  // #if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)`
#endif  // #if (TARGET_IPHONE_SIMULATOR)

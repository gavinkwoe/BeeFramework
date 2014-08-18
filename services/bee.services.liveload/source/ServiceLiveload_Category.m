//
//  ServiceLiveload_Category.m
//  dribbble
//
//  Created by QFish on 2/10/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#if (TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)

#import "ServiceLiveload.h"
#import "ServiceLiveload_Watcher.h"
#import "ServiceLiveload_Category.h"
#import "ServiceLiveload_Hook.h"
#import "ServiceLiveload_Border.h"

static const char kUIViewShouldReloadKey;

@implementation NSObject (ServiceLiveload)

@dynamic shouldReload;

- (void)setShouldReload:(NSNumber *)shouldReload
{
    objc_setAssociatedObject(self, &kUIViewShouldReloadKey, shouldReload, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)shouldReload
{
    return objc_getAssociatedObject(self, &kUIViewShouldReloadKey);
}

- (void)liveload_reloadWithObject:(id)obj;
{
}

- (void)liveload_reloadDefaultStlye
{
    NSString * defaultPath = [ServiceLiveload sharedInstance].defaultStyle;
    BeeUIStyle * style = [[BeeUIStyleManager sharedInstance]
                          fromFile:defaultPath useCache:NO];
    [BeeUIStyleManager sharedInstance].defaultStyle = style;
}

@end

@implementation UIView (ServiceLiveload)

- (NSString *)liveload_path
{
    NSObject * responder = [self liveload_responder];
    NSString * path = [responder UIResourcePath];
    NSString * name = [responder UIResourceName];    
    if ( path && name )
    {
        return [NSString stringWithFormat:@"%@/%@.xml", path, name];
    }
    
    return nil;
}

- (NSString *)liveload_pathKey
{
    return [[self liveload_path] lastPathComponent];
}

- (void)markShouldReload:(BOOL)shouldReload
{
    if ( self.viewController )
    {
        if ( self.shouldReload && self.shouldReload.boolValue == shouldReload )
            return;
        
        [self liveload_responder].shouldReload = @(shouldReload);
        self.shouldReload = @(shouldReload);
        
        [self walkthroughWithBlock:^(UIView * view)
        {
            if ( [[view liveload_responder] supportForUIResourceLoading] )
            {
                view.shouldReload = @(shouldReload);
            }
        }];
    }
}

- (void)walkthroughWithBlock:(void (^)(UIView *))block
{
    block(self);
    
    for ( UIView * subview in self.subviews )
    {
        [subview walkthroughWithBlock:block];
    }
}

- (NSObject *)liveload_responder
{
    if ( self.viewController )
        return self.viewController;
    return self;
}

@end

#pragma mark - categories

@implementation UIView (ServiceLiveloadPrivate)
- (void)liveload_reloadWithObject:(id)obj
{
    if ( [obj isEqualToString:[ServiceLiveload sharedInstance].defaultStyle] )
    {
        [self liveload_reloadDefaultStlye];
    }

    [self removeAllSubviews];

    self.FROM_FILE( [self liveload_path] );
    
    if ( [self respondsToSelector:@selector(dataDidChanged)] )
    {
        [self performSelector:@selector(dataDidChanged) withObject:nil];
    }
    
    self.RELAYOUT();

    ServiceLiveload_Border * border = [ServiceLiveload_Border new];
    border.frame = self.bounds;
    [self addSubview:border];
    [border startAnimation];
    [border release];
}
@end

@implementation BeeUIScrollView (ServiceLiveloadPrivate)
- (void)liveload_reloadWithObject:(id)obj
{
    if ( [obj isEqualToString:[ServiceLiveload sharedInstance].defaultStyle] )
    {
        [self liveload_reloadDefaultStlye];
    }

    [self reloadData];
}
@end

@implementation BeeUIBoard (ServiceLiveloadPrivate)
- (void)liveload_reloadWithObject:(id)obj
{
    if ( [obj isEqualToString:[ServiceLiveload sharedInstance].defaultStyle] )
    {
        [self liveload_reloadDefaultStlye];
    }

    [self.view removeAllSubviews];
    
    self.FROM_FILE( [self.view liveload_path] );

    [self sendUISignal:self.DELETE_VIEWS];
    [self sendUISignal:self.CREATE_VIEWS];
    [self sendUISignal:self.WILL_APPEAR];
    [self sendUISignal:self.DID_APPEAR];
}
@end

#endif  // #if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)`
#endif  // #if (TARGET_IPHONE_SIMULATOR)
//
//  ServiceLiveload_Hook.m
//  dribbble
//
//  Created by QFish on 2/9/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#if (TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)

#import "ServiceLiveload.h"
#import "ServiceLiveload_Hook.h"
#import "ServiceLiveload_Watcher.h"
#import "ServiceLiveload_Category.h"

#import "UIView+BeeUITemplate.h"

static BOOL __swizzled_liveload__ = NO;
static void (*__willMoveToSuperview_liveload__)( id, SEL, id );
static void (*__dealloc_liveload__)( id, SEL );

#pragma mark - 

@interface NSObject(ServiceLiveloadPrivate)
+ (void *)swizz:(Class)clazz method:(SEL)sel1 with:(SEL)sel2;
@end

#pragma mark -

@interface UIView(ServiceLiveloadPrivate)

- (void)myDealloc_liveload;
- (void)mySetTemplateName_liveload:(NSString *)name;

@end

#pragma mark -

@implementation UIView (ServiceLiveloadHook)

+ (void)hook
{
    if ( NO == __swizzled_liveload__ )
    {
        [NSObject swizz:[UIView class] method:@selector(setTemplateName:) with:@selector(mySetTemplateName_liveload:)];
        
        __willMoveToSuperview_liveload__ = [self swizz:[UIView class] method:@selector(willMoveToSuperview:) with:@selector(myWillMoveToSuperview_liveload:)];
        
        __dealloc_liveload__ = [self swizz:[UIView class] method:@selector(dealloc) with:@selector(myDealloc_liveload)];
        
        __swizzled_liveload__ = YES;
    }
}

- (void)mySetTemplateName_liveload:(NSString *)name
{
    if ( [[self liveload_responder] supportForUIResourceLoading] )
    {
        BeeUITemplate * temp = nil;
        
        NSString * shadowPath = [self liveload_path];
        
        if ( shadowPath && shadowPath.length )
        {
            temp = [[BeeUITemplateManager sharedInstance] fromFile:shadowPath];
        }
        else
        {
            temp = [[BeeUITemplateManager sharedInstance] fromName:name];
        }
        
        if ( temp && temp.rootLayout )
        {
            self.layout = temp.rootLayout;
            [self.layout buildFor:self];
        }
    }
}

- (void)myWillMoveToSuperview_liveload:(UIView *)newSuperview
{
    NSObject * responder = [self liveload_responder];
    NSString * pathKey = [self liveload_pathKey];
    NSString * path = [self liveload_path];
    
    if ( [responder supportForUIResourceLoading] )
    {
        if ( nil == newSuperview )
        {
            [self markShouldReload:NO];
            
            [[ServiceLiveload sharedInstance] removeResonpder:responder forKey:pathKey];
        }
        else
        {
            [self markShouldReload:YES];
            self.shouldReload = @(YES);
            [[ServiceLiveload sharedInstance] setResonpder:responder path:path forKey:pathKey];
        }
    }
    
    if ( __willMoveToSuperview_liveload__ ) {
        __willMoveToSuperview_liveload__(self, _cmd, newSuperview);
    }
}

- (void)myDealloc_liveload
{
    NSObject * responder = [self liveload_responder];
    NSString * pathKey = [self liveload_pathKey];

    if ( [responder supportForUIResourceLoading] )
    {
        [[ServiceLiveload sharedInstance] removeResonpder:responder
                                                   forKey:pathKey];
    }
    
    if ( __dealloc_liveload__ )
    {
        __dealloc_liveload__( self, _cmd );
    }
}


@end

@implementation NSObject(ServiceLiveloadPrivate)

+ (void *)swizz:(Class)clazz method:(SEL)sel1 with:(SEL)sel2
{
	Method method;
	IMP implement;
	IMP implement2;
	
	method = class_getInstanceMethod( clazz, sel1 );
	implement = (void *)method_getImplementation( method );
	implement2 = class_getMethodImplementation( clazz, sel2 );
	method_setImplementation( method, implement2 );
    
	return implement;
}

@end

#endif  // #if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)`
#endif  // #if (TARGET_IPHONE_SIMULATOR)
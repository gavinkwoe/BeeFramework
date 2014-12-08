//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceLiveload.h"
#import "ServiceLiveload_Hook.h"
#import "ServiceLiveload_Watcher.h"

NSString * BeeGetAbsoluteFilePath(const char *currentFilePath, NSString *relativeFilePath)
{
    return [NSString stringWithFormat:@"%@/%@", [[NSString stringWithFormat:@"%s", currentFilePath] stringByDeletingLastPathComponent], relativeFilePath];
}

#pragma mark -

@interface ServiceLiveload()
@property (nonatomic, retain) NSMutableDictionary * responderMap;
@end

#pragma mark -

@implementation ServiceLiveload

DEF_SINGLETON( ServiceLiveload )

#if (TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)

SERVICE_AUTO_LOADING( YES );
SERVICE_AUTO_POWERON( YES );

+ (void)load
{
    [UIView hook];
}

- (void)load
{
    self.responderMap = [[NSMutableDictionary alloc] init];
}

#pragma mark -

- (void)setResonpder:(NSObject *)responder path:(NSString *)path forKey:(NSString *)key
{
    if ( key && responder )
    {
        self.responderMap[key] = responder;
        
        if ( path && path.length )
        {
            [ServiceLiveload_Watcher setWatcher:responder path:path forKey:key];
        }
        
        NSString * defaultStyle = [ServiceLiveload sharedInstance].defaultStyle;
        
        if ( defaultStyle && defaultStyle.length )
        {
            [ServiceLiveload_Watcher setWatcher:responder
                                           path:defaultStyle
                                         forKey:defaultStyle ];
        }
    }
}

- (void)removeResonpder:(NSObject *)responder forKey:(NSString *)key
{
    [ServiceLiveload_Watcher removeWatcher:responder
                                    forKey:key];
    [ServiceLiveload_Watcher removeWatcher:responder
                                    forKey:[ServiceLiveload sharedInstance].defaultStyle];
    
    if ( self.responderMap[key] )
    {
        [self.responderMap removeObjectForKey:key];
    }
}

- (void)reloadResponder:(NSObject *)responder withObject:(id)object
{
    if ( responder.shouldReload )
    {
        INFO( @"[Liveload]: %@", [responder class] );
        [responder liveload_reloadWithObject:object];
    }
}

#endif  // #if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)`
#endif  // #if (TARGET_IPHONE_SIMULATOR)

@end

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

#import "Bee.h"
#import "ServiceLiveload_Category.h"

#define BEE_LIVELOAD_PATH(relativePath) BeeGetAbsoluteFilePath(__FILE__, relativePath)

NSString * BeeGetAbsoluteFilePath(const char *currentFilePath, NSString *relativeFilePath);

#pragma mark -

@interface ServiceLiveload: BeeService 

AS_SINGLETON( ServiceLiveload );

@property (nonatomic, copy) NSString * defaultStyle;

#if (TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)

- (void)reloadResponder:(NSObject *)responder withObject:(id)object;
- (void)removeResonpder:(NSObject *)responder forKey:(NSString *)key;
- (void)setResonpder:(NSObject *)responder path:(NSString *)path forKey:(NSString *)key;

#endif  // #if (__ON__ == __BEE_DEVELOPMENT__ && __ON__ == __BEE_LIVELOAD__)`
#endif  // #if (TARGET_IPHONE_SIMULATOR)

@end
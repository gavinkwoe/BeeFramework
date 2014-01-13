//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Package.h"
#import "Bee_Foundation.h"
#import "Bee_ViewPackage.h"

#import "Bee_UIBoard.h"
#import "Bee_UISignal.h"

#pragma mark -

AS_PACKAGE( BeePackage_UI, BeeUIRouter, router );

#pragma mark -

typedef enum
{
	BeeUIRouterEffectNone = 0,
	BeeUIRouterEffectPush
} BeeUIRouterEffect;

#pragma mark -

@interface BeeUIRouter : BeeUIBoard

AS_SIGNAL( WILL_CHANGE )
AS_SIGNAL( DID_CHANGED )

AS_NOTIFICATION( STACK_WILL_CHANGE )
AS_NOTIFICATION( STACK_DID_CHANGED )

AS_SINGLETON( BeeUIRouter )

@property (nonatomic, assign) BeeUIRouterEffect		effect;
@property (nonatomic, retain) NSString *			defaultRule;
@property (nonatomic, readonly) BeeUIBoard *		currentBoard;
@property (nonatomic, readonly) BeeUIStack *		currentStack;
@property (nonatomic, readonly) NSArray *			stacks;

- (void)map:(NSString *)rule toClass:(Class)clazz;
- (void)map:(NSString *)rule toBoard:(BeeUIBoard *)board;
- (void)map:(NSString *)rule toStack:(BeeUIStack *)stack;

- (BOOL)open:(NSString *)url;
- (BOOL)open:(NSString *)url animated:(BOOL)animated;
- (BOOL)openExternal:(NSString *)url;
- (BOOL)openExternal:(NSString *)url withParams:(NSDictionary *)dict;

- (void)close:(NSString *)url;

- (void)buildStacks;
- (void)clear;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id)key;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

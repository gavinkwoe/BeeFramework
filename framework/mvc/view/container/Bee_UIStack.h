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
#import "Bee_Foundation.h"
#import "Bee_UISignal.h"
#import "Bee_UITransition.h"

#pragma mark -

@class BeeUIBoard;
@class BeeUIStack;

#pragma mark -

@interface BeeUIStack : UINavigationController

@property (nonatomic, retain) NSString *				name;
@property (nonatomic, readonly) NSArray *				boards;
@property (nonatomic, readonly) BeeUIBoard *			topBoard;

+ (BeeUIStack *)stack;
+ (BeeUIStack *)stack:(NSString *)name;
+ (BeeUIStack *)stack:(NSString *)name firstBoardClass:(Class)clazz;
+ (BeeUIStack *)stack:(NSString *)name firstBoard:(BeeUIBoard *)board;
+ (BeeUIStack *)stackWithFirstBoardClass:(Class)clazz;
+ (BeeUIStack *)stackWithFirstBoard:(BeeUIBoard *)board;

- (BeeUIStack *)initWithName:(NSString *)name andFirstBoardClass:(Class)clazz;
- (BeeUIStack *)initWithName:(NSString *)name andFirstBoard:(BeeUIBoard *)board;

// manipulation

- (void)pushBoard:(BeeUIBoard *)board animated:(BOOL)animated;
- (void)pushBoard:(BeeUIBoard *)board animated:(BOOL)animated transitionType:(BeeUITransitionType)type;
- (void)pushBoard:(BeeUIBoard *)board animated:(BOOL)animated transition:(BeeUITransition *)trans;

- (UIViewController *)popBoardAnimated:(BOOL)animated;
- (UIViewController *)popBoardAnimated:(BOOL)animated transitionType:(BeeUITransitionType)type;
- (UIViewController *)popBoardAnimated:(BOOL)animated transition:(BeeUITransition *)trans;

- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated;
- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated transitionType:(BeeUITransitionType)type;
- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated transition:(BeeUITransition *)trans;

- (NSArray *)popToFirstBoardAnimated:(BOOL)animated;
- (NSArray *)popToFirstBoardAnimated:(BOOL)animated transitionType:(BeeUITransitionType)type;
- (NSArray *)popToFirstBoardAnimated:(BOOL)animated transition:(BeeUITransition *)trans;

- (void)popAllBoards;

- (BOOL)existsBoard:(BeeUIBoard *)board;
- (BOOL)existsBoardClass:(Class)boardClazz;

// life-cycle

- (void)__enterBackground;
- (void)__enterForeground;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

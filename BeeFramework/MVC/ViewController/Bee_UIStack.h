//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
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
//
//  Bee_UIStack.h
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_UINavigationBar.h"
#import "Bee_UIImageView.h"
#import "NSObject+BeeNotification.h"

#pragma mark -

@class BeeUIBoard;
@class BeeUIStack;

#pragma mark -

@interface UIView(BeeUIStack)
- (BeeUIStack *)stack;
- (UINavigationController *)navigationController;
@end

#pragma mark -

@interface BeeUIStack : UINavigationController
{
	BeeUIBoard *		_parentBoard;
	NSString *			_name;
}

AS_INT( ANIMATION_TYPE_DEFAULT )	// 默认
AS_INT( ANIMATION_TYPE_CUBE )		// 3D
AS_INT( ANIMATION_TYPE_FADE )		// 渐隐
AS_INT( ANIMATION_TYPE_PAGING )		// 竖直翻页
AS_INT( ANIMATION_TYPE_SLIDE )		// 滑动
AS_INT( ANIMATION_TYPE_FLIP )		// 翻页

@property (nonatomic, retain) NSString *				name;
@property (nonatomic, assign) BeeUIBoard *				parentBoard;

@property (nonatomic, readonly) BeeUINavigationBar *	navigationBar;
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

- (void)pushBoard:(BeeUIBoard *)board animated:(BOOL)animated;
- (void)pushBoard:(BeeUIBoard *)board animated:(BOOL)animated animationType:(NSInteger)type;

- (void)popBoardAnimated:(BOOL)animated;
- (void)popBoardAnimated:(BOOL)animated animationType:(NSInteger)type;

- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated;
- (NSArray *)popToBoard:(BeeUIBoard *)board animated:(BOOL)animated animationType:(NSInteger)type;

- (NSArray *)popToFirstBoardAnimated:(BOOL)animated;
- (NSArray *)popToFirstBoardAnimated:(BOOL)animated animationType:(NSInteger)type;

- (void)popAllBoards;

- (BOOL)existsBoard:(BeeUIBoard *)board;
- (BeeUIBoard *)getBoard:(Class)clazz;

@end

#pragma mark -

@interface BeeUIStack(InternalUseOnly)
- (void)__enterBackground;
- (void)__enterForeground;
@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

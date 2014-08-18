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

#pragma mark -

@interface UIViewController(UINavigationBar)

@property (nonatomic, retain) NSString *				titleString			BEE_DEPRECATED;
@property (nonatomic, retain) UIImage *					titleImage			BEE_DEPRECATED;
@property (nonatomic, retain) UIView *					titleView			BEE_DEPRECATED;
@property (nonatomic, retain) UIViewController *		titleViewController	BEE_DEPRECATED;

@property (nonatomic, readonly) UIView *				leftBarButton		BEE_DEPRECATED;
@property (nonatomic, readonly) UIView *				rightBarButton		BEE_DEPRECATED;

@property (nonatomic, assign) BOOL						navigationBarShown;
@property (nonatomic, retain) id						navigationBarLeft;
@property (nonatomic, retain) id						navigationBarRight;
@property (nonatomic, retain) id						navigationBarTitle;

- (void)showNavigationBarAnimated:(BOOL)animated;
- (void)hideNavigationBarAnimated:(BOOL)animated;

- (void)showBarButton:(NSInteger)position title:(NSString *)name;
- (void)showBarButton:(NSInteger)position image:(UIImage *)image;
- (void)showBarButton:(NSInteger)position image:(UIImage *)image image:(UIImage *)image2;
- (void)showBarButton:(NSInteger)position title:(NSString *)name image:(UIImage *)image;

- (void)showBarButton:(NSInteger)position system:(UIBarButtonSystemItem)index;
- (void)showBarButton:(NSInteger)position custom:(UIView *)view;
- (void)hideBarButton:(NSInteger)position;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

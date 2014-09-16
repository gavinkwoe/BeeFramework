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

#import "Bee_UISignal.h"
#import "Bee_UILabel.h"
#import "Bee_UICapability.h"

#pragma mark -

AS_PACKAGE( BeePackage_UI, BeeImageCache, imageCache );

#pragma mark -

@class BeeUIActivityIndicatorView;

#pragma mark -

@interface BeeImageCache : NSObject

AS_SINGLETON( BeeImageCache )

- (BOOL)hasCachedForURL:(NSString *)url;
- (BOOL)hasFileCachedForURL:(NSString *)url;
- (BOOL)hasMemoryCachedForURL:(NSString *)url;

- (UIImage *)imageForURL:(NSString *)url;
- (UIImage *)fileImageForURL:(NSString *)url;
- (UIImage *)memoryImageForURL:(NSString *)url;

- (void)saveImage:(UIImage *)image forURL:(NSString *)url;
- (void)saveData:(NSData *)data forURL:(NSString *)url;

- (void)deleteImageForURL:(NSString *)url;
- (void)deleteAllImages;

@end

#pragma mark -

@interface BeeUIImageView : UIImageView

AS_SIGNAL( LOAD_START )			// 加载开始
AS_SIGNAL( LOAD_COMPLETED )		// 加载完成
AS_SIGNAL( LOAD_FAILED )		// 加载失败
AS_SIGNAL( LOAD_CANCELLED )		// 加载取消
AS_SIGNAL( LOAD_CACHE )         // 加载缓存

//AS_SIGNAL( WILL_CHANGE )		// 图将要变了
//AS_SIGNAL( DID_CHANGED )		// 图已经变了

@property (nonatomic, assign) BOOL							gray;			// 是否变为灰色
@property (nonatomic, assign) BOOL							round;			// 是否裁剪为圆型
@property (nonatomic, assign) BOOL							crop;			// 是否裁剪
@property (nonatomic, assign) CGSize                        cropSize;       // 裁剪大小
@property (nonatomic, assign) BOOL							pattern;		// 是否平铺
@property (nonatomic, assign) BOOL							strech;			// 是否裁剪为圆型
@property (nonatomic, assign) UIEdgeInsets					strechInsets;	// 是否裁剪为圆型
@property (nonatomic, assign) BOOL							loading;
@property (nonatomic, assign) BOOL							loaded;
@property (nonatomic, retain) BeeUILabel *					altLabel;
@property (nonatomic, retain) BeeUIActivityIndicatorView *	indicator;
@property (nonatomic, assign) UIActivityIndicatorViewStyle	indicatorStyle;
@property (nonatomic, retain) UIColor *						indicatorColor;
@property (nonatomic, retain) NSString *					loadedURL;
@property (nonatomic, retain) NSString *					loadedCroppedURL;
@property (nonatomic, retain) UIImage *						defaultImage;
@property (nonatomic, assign) BOOL							enableAllEvents;

@property (nonatomic, assign) NSString *					url;
@property (nonatomic, assign) NSString *					file;
@property (nonatomic, assign) NSString *					resource;

- (void)GET:(NSString *)url useCache:(BOOL)useCache;
- (void)GET:(NSString *)url useCache:(BOOL)useCache placeHolder:(UIImage *)defaultImage;

- (void)clear;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

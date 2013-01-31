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
//  UIView+BeeExtension.h
//

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "Bee_UIImageView.h"

#pragma mark -

#undef	SAFE_RELEASE_SUBLAYER
#define SAFE_RELEASE_SUBLAYER( __x ) \
		{ \
			[__x removeFromSuperlayer]; \
			BEE_RELEASE(__x); \
			__x = nil; \
		}

#undef	SAFE_RELEASE_SUBVIEW
#define SAFE_RELEASE_SUBVIEW( __x ) \
		{ \
			[__x removeFromSuperview]; \
			BEE_RELEASE(__x); \
			__x = nil; \
		}

#pragma mark -

@interface UIView(BeeExtension)

@property (nonatomic, retain) NSString *		tagString;
@property (nonatomic, retain) NSString *		hintString;
@property (nonatomic, retain) UIColor *			hintColor;

@property (nonatomic, retain) BeeUIImageView *	backgroundImageView;
@property (nonatomic, retain) UIImage *			backgroundImage;

- (UIView *)viewWithTagString:(NSString *)value;
- (UIView *)viewAtPath:(NSString *)name;
- (UIView *)subview:(NSString *)name;
- (UIViewController *)viewController;

+ (UIView *)spawn;
+ (UIView *)spawn:(NSString *)tagString;

@end

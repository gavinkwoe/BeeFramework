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
//  Bee_UIZoomView.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bee_UISignal.h"

#pragma mark -

@class BeeUIZoomInnerView;
@class BeeUIZoomView;

@protocol BeeUIZoomInnerViewDelegate<NSObject>
- (CGSize)zoomContentSize:(BeeUIZoomInnerView *)view;
- (UIView *)zoomContentView:(BeeUIZoomInnerView *)view;

- (void)zoomInnerViewChanged:(BeeUIZoomInnerView *)view;
- (void)zoomInnerViewSingleTapped:(BeeUIZoomInnerView *)view location:(CGPoint)location;
- (void)zoomInnerViewDoubleTapped:(BeeUIZoomInnerView *)view location:(CGPoint)location;
@end

#pragma mark -

@interface BeeUIZoomInnerView : UIScrollView
{
	id<BeeUIZoomInnerViewDelegate> _zoomDelegate;
}

@property (nonatomic, assign) id<BeeUIZoomInnerViewDelegate>	zoomDelegate;

@end

#pragma mark -

@interface BeeUIZoomView : UIView<UIScrollViewDelegate, BeeUIZoomInnerViewDelegate>
{
	BeeUIZoomInnerView *	_innerView;
	CGSize					_contentSize;
	UIView *				_content;
}

AS_SIGNAL( ZOOMING );
AS_SIGNAL( ZOOMED );
AS_SIGNAL( SINGLE_TAPPED );
AS_SIGNAL( DOUBLE_TAPPED );

@property (nonatomic, retain) BeeUIZoomInnerView *	innerView;
@property (nonatomic, assign) CGSize				contentSize;
@property (nonatomic, retain) UIView *				content;

+ (BeeUIZoomView *)spawn;

- (void)resetZoom;
- (void)layoutContent;
- (void)layoutContentRotated;
- (void)setContent:(UIView *)contentView animated:(BOOL)animated;

@end
